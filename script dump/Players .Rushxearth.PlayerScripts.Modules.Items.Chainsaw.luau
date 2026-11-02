local ReplicatedStorage = game:GetService("ReplicatedStorage")
local _ = game:GetService("RunService")
local Players = game:GetService("Players")
local AnimationLibrary_m = require(ReplicatedStorage.Modules.AnimationLibrary)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local Melee_m = require(Players.LocalPlayer.PlayerScripts.Modules.ItemTypes.Melee)
local t = setmetatable({}, Melee_m)
t.__index = t

function t.new(...) -- line: 14
    -- upvalues:
    --  [1] Melee_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(Melee_m.new(...), t)
    t_1._is_holding = false
    t_1._hold_cooldown = 0
    t_1._hold_hash = 0
    t_1._hold_sounds = nil
    t_1._hold_sounds_progress = 0
    t_1._hold_particles = {}
    t_1:_Init()

    return t_1
end

function t.StartAiming(arg1, arg2) -- line: 33
    -- upvalues:
    --  [1] AnimationLibrary_m (copy)
    --  [2] Utility_m (copy)

    if
        not arg2
        and (arg1._is_holding or tick() < arg1._hold_cooldown or tick() < arg1._attack_cooldown or arg1:Get(
            "Ammo"
        ) <= 0 or arg1:IsEquipping())
    then
        return false
    end

    arg1._is_holding = true
    local now = tick()
    arg1._hold_cooldown = now + arg1.Info.InternalHoldCooldown
    arg1._attack_cooldown = math.huge

    if arg1._last_attack_animation_name then
        arg1.ViewModel:StopAnimation(arg1._last_attack_animation_name)
    end

    arg1.ViewModel:StopAnimation(arg1.ViewModel.Animator:GetEquipAnimationKey(), 0)
    arg1.ViewModel:PlayAnimation("HoldStart", math.huge, 0.1)
    arg1.ViewModel:StopAnimation("HoldFinish", 0.1)
    arg1._hold_hash += 1
    local HoldHash = arg1._hold_hash
    task.spawn(function() -- line: 54
        -- upvalues:
        --  [1] arg1 (copy)
        --  [2] HoldHash (copy)

        local now_1 = tick()
        local v3 = nil
        local now_2 = nil

        while true do
            if not arg1._is_holding or HoldHash ~= arg1._hold_hash then
                break
            end

            arg1.ClientFighter.Entity:SetBoost(
                "Speed",
                "ChainsawHold",
                0.3,
                arg1.Info.HoldSpeedBoostMin + (arg1.Info.HoldSpeedBoostMax - arg1.Info.HoldSpeedBoostMin) * math.clamp(
                    (tick() - now_1) / arg1.Info.HoldSpeedBoostRampTime,
                    0,
                    1
                )
            )
            arg1:_Shake("ChainsawHold")

            if not v3 or v3 ~= arg1:Get("Ammo") then
                v3 = arg1:Get("Ammo")
                now_2 = tick()
            elseif tick() - now_2 > 0.25 then
                arg1:SimulateInputFromGameplayMechanic("FinishAiming", true)

                return
            end

            wait(0.1)
        end
    end)
    task.spawn(function() -- line: 81
        -- upvalues:
        --  [1] AnimationLibrary_m (ref)
        --  [2] arg1 (copy)
        --  [3] HoldHash (copy)

        wait(AnimationLibrary_m.Info[arg1.ViewModel.Info.Animations.HoldStart].Length)

        if HoldHash ~= arg1._hold_hash then
            return
        end

        arg1.ViewModel:PlayAnimation("HoldLoop", math.huge, 0)
        arg1.ViewModel:EnableParticles(true)
    end)

    if not arg1._hold_sounds then
        arg1._hold_sounds = {}

        for _, val in pairs(arg1.ViewModel:CreateHoldSounds()) do
            arg1._hold_sounds[val] = val.Volume
            val.Looped = true
        end

        arg1.ViewModel:PlayStartingHoldSounds()
    end

    task.spawn(
        Utility_m.RenderstepForLoop,
        Utility_m,
        arg1._hold_sounds_progress,
        100,
        25,
        function(arg3) -- line: 103
            -- upvalues:
            --  [1] HoldHash (copy)
            --  [2] arg1 (copy)

            if HoldHash ~= arg1._hold_hash then
                return true
            end

            arg1._hold_sounds_progress = arg3

            for key_1, val_1 in pairs(arg1._hold_sounds) do
                key_1.Volume = val_1 * arg3 / 100
            end
        end
    )

    return true, "StartAiming"
end

function t.FinishAiming(arg4, arg5) -- line: 118
    if not arg5 and not arg4._is_holding then
        return
    end

    arg4:_StopHolding(true)

    return true, "FinishAiming"
end

function t.Equip(arg6) -- line: 128
    -- upvalues:
    --  [1] Melee_m (copy)

    Melee_m.Equip(arg6)
    arg6:_StopHolding()
end

function t.Unequip(arg7) -- line: 133
    -- upvalues:
    --  [1] Melee_m (copy)

    arg7:_StopHolding(true)
    Melee_m.Unequip(arg7)
end

function t.ReplicateFromServer(arg8, arg9, ...) -- line: 138
    -- upvalues:
    --  [1] Melee_m (copy)

    if arg9 == "StopHolding" then
        arg8:_StopHolding(true)

        return
    end

    Melee_m.ReplicateFromServer(arg8, arg9, ...)
end

function t.Destroy(arg10) -- line: 146
    -- upvalues:
    --  [1] Melee_m (copy)

    arg10:_StopHolding()
    Melee_m.Destroy(arg10)
end

function t._StopHolding(arg11, arg12) -- line: 155
    -- upvalues:
    --  [1] AnimationLibrary_m (copy)
    --  [2] Utility_m (copy)

    local IsHolding = arg11._is_holding
    arg11._hold_hash += 1
    arg11._is_holding = false
    arg11._attack_cooldown = if arg12 then 0 else arg11._attack_cooldown

    if arg11.ClientFighter.Entity then
        arg11.ClientFighter.Entity:RemoveBoost("ChainsawHold")
    end

    if IsHolding then
        arg11.ViewModel:PlayAnimation(
            "HoldFinish",
            AnimationLibrary_m.Info[arg11.ViewModel.Info.Animations.HoldFinish].Length,
            0.1
        )
    end

    arg11.ViewModel:StopAnimation("HoldStart", 0.1)
    arg11.ViewModel:StopAnimation("HoldLoop", 0.1)

    if arg11._hold_sounds then
        local HoldHash_1 = arg11._hold_hash
        task.spawn(function() -- line: 176
            -- upvalues:
            --  [1] Utility_m (ref)
            --  [2] arg11 (copy)
            --  [3] HoldHash_1 (copy)

            Utility_m:RenderstepForLoop(arg11._hold_sounds_progress, 0, -10, function(arg13) -- line: 177
                -- upvalues:
                --  [1] HoldHash_1 (ref)
                --  [2] arg11 (ref)

                if HoldHash_1 ~= arg11._hold_hash then
                    return true
                end

                arg11._hold_sounds_progress = arg13

                for key_2, val_2 in pairs(arg11._hold_sounds) do
                    key_2.Volume = val_2 * (arg13 / 100) ^ 2
                end
            end)

            if HoldHash_1 ~= arg11._hold_hash then
                return
            end

            for key_3, _ in pairs(arg11._hold_sounds) do
                key_3:Destroy()
            end

            arg11._hold_sounds = nil
        end)
    end

    arg11.ViewModel:EnableParticles(false)
end

function t._Setup(arg14) -- line: 204
    function arg14._on_attack_callback() -- line: 205
        -- upvalues:
        --  [1] arg14 (copy)

        arg14.ViewModel:StopAnimation("HoldFinish")
    end
end

function t._Init(arg15) -- line: 210
    table.insert(arg15._connections, arg15.ClientFighter.Interrupted:Connect(function() -- line: 211
        -- upvalues:
        --  [1] arg15 (copy)

        if arg15._is_holding then
            arg15:_StopHolding(true)
        end
    end))
    arg15:_Setup()
end

return t
