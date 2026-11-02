local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local AnimationLibrary_m = require(ReplicatedStorage.Modules.AnimationLibrary)
local Gun_m = require(Players.LocalPlayer.PlayerScripts.Modules.ItemTypes.Gun)
local t = setmetatable({}, Gun_m)
t.__index = t

function t.new(...) -- line: 10
    -- upvalues:
    --  [1] Gun_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(Gun_m.new(...), t)
    t_1.ToggleAimEnabled = nil
    t_1._is_charging = false
    t_1._charge_hash = 0
    t_1:_Init()

    return t_1
end

function t.StartAiming(arg1, arg2) -- line: 27
    -- upvalues:
    --  [1] AnimationLibrary_m (copy)

    if not arg2 then
        if
            arg1._is_charging
            or tick() < arg1._shoot_cooldown
            or tick() < arg1._reload_cooldown
            or tick() < arg1._shoot_cooldown_no_ammo
            or arg1:IsEquipping()
        then
            return false
        end

        if arg1:Get("Ammo") <= 0 then
            local t_2 = { arg1:StartReloading() }

            if t_2[1] then
                return table.unpack(t_2)
            end

            arg1._shoot_cooldown_no_ammo = tick() + arg1.Info.ShootCooldown
            arg1:CreateSound(
                "rbxassetid://13087319223",
                1,
                1,
                true,
                5
            )

            return false
        end
    end

    local ChargeLevelTimestamps = arg1.Info.ChargeLevelTimestamps
    arg1._is_charging = true
    arg1._shoot_cooldown = math.huge
    arg1._reload_cooldown = math.huge
    arg1:_StartAimAssist()
    arg1._on_shoot_callback()
    arg1.ViewModel:StopAnimation("Equip", 0)
    arg1.ViewModel:PlayAnimation("Charge", math.huge, 0.1)

    if arg1.ItemInterface then
        arg1.ItemInterface.Charge:Set(1)
        arg1.ItemInterface.Charge:Start(ChargeLevelTimestamps)
    end

    arg1._charge_hash += 1
    local ChargeHash = arg1._charge_hash
    task.spawn(function() -- line: 64
        -- upvalues:
        --  [1] ChargeLevelTimestamps (copy)
        --  [2] ChargeHash (copy)
        --  [3] arg1 (copy)

        for key, val in pairs(ChargeLevelTimestamps) do
            if not (val <= 0) then
                wait(val - (ChargeLevelTimestamps[key - 1] or 0))

                if ChargeHash ~= arg1._charge_hash then
                    return
                end

                arg1:SetReplicate("FOVOffset", 5 * (key - 1))
                arg1.ViewModel:PlayChargeEffect(key)

                if arg1.ItemInterface then
                    arg1.ItemInterface.Charge:Set(key)
                    arg1.ItemInterface.Charge:Play()
                end
            end
        end
    end)
    task.spawn(function() -- line: 87
        -- upvalues:
        --  [1] AnimationLibrary_m (ref)
        --  [2] arg1 (copy)
        --  [3] ChargeHash (copy)

        wait(AnimationLibrary_m.Info[arg1.ViewModel.Info.Animations.Charge].Length)

        if ChargeHash ~= arg1._charge_hash then
            return
        end

        arg1.ViewModel:PlayAnimation("ChargeLoop", math.huge, 0)
    end)

    return true, "StartAiming"
end

function t.FinishAiming(arg3, arg4) -- line: 100
    if not arg4 and not arg3._is_charging then
        return false
    end

    arg3:_StopCharging()

    return true, "FinishAiming", (arg3.ClientFighter:GetCameraData())
end

function t.StartSprinting(_, _) -- line: 112
    return false
end

function t.Unequip(arg7, ...) -- line: 116
    -- upvalues:
    --  [1] Gun_m (copy)

    task.spawn(arg7.Input, arg7, "FinishAiming")
    task.defer(arg7._StopCharging, arg7, true)
    Gun_m.Unequip(arg7, ...)
end

function t._StopCharging(arg8, arg9) -- line: 126
    local ChargeReleaseCooldown = arg8.Info.ChargeReleaseCooldown
    arg8._is_charging = false
    arg8._charge_hash += 1
    arg8._shoot_cooldown = tick() + ChargeReleaseCooldown
    arg8._reload_cooldown = tick() + ChargeReleaseCooldown
    arg8:_FinishAimAssist()
    arg8:SetReplicate("FOVOffset", 0)

    if not arg9 then
        arg8.ViewModel:PlayAnimation("ChargeRelease", ChargeReleaseCooldown, 0)
    end

    arg8.ViewModel:StopAnimation("ChargeLoop", 0.1)
    arg8.ViewModel:StopAnimation("Charge", 0.1)

    if arg8.ItemInterface then
        arg8.ItemInterface.Charge:Stop(arg9)
    end
end

function t._Setup(arg10) -- line: 148
    function arg10._on_shoot_callback() -- line: 149
        -- upvalues:
        --  [1] arg10 (copy)

        arg10.ViewModel:StopAnimation("ChargeLoop", 0)
        arg10.ViewModel:StopAnimation("ChargeRelease", 0)
    end
end

function t._Init(arg11) -- line: 155
    table.insert(arg11._connections, arg11.ClientFighter.Interrupted:Connect(function() -- line: 156
        -- upvalues:
        --  [1] arg11 (copy)

        arg11:_StopCharging(true)
    end))
    arg11:_Setup()
end

return t
