local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local _ = require(ReplicatedStorage.Modules.BetterDebris)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local Signal_m = require(ReplicatedStorage.Modules.Signal)
local Custom_m = require(Players.LocalPlayer.PlayerScripts.Modules.ItemTypes.Custom)
local t = setmetatable({}, Custom_m)
t.__index = t

function t.new(...) -- line: 12
    -- upvalues:
    --  [1] Custom_m (copy)
    --  [2] t (copy)
    --  [3] Signal_m (copy)

    local t_1 = setmetatable(Custom_m.new(...), t)
    t_1.Airblasted = Signal_m.new()
    t_1._is_using = false
    t_1._use_cooldown = 0
    t_1._airblast_cooldown = 0
    t_1:_Init()

    return t_1
end

function t.GetAutoShootReactionTime(_) -- line: 30
    return 0
end

function t.GetAutoShootReach(arg2) -- line: 34
    return arg2.Info.Reach
end

function t.CanQuickAttack(arg3) -- line: 38
    return if tick() > arg3._airblast_cooldown then not arg3:IsEquipping() else false
end

function t.StartShooting(arg4, arg5) -- line: 43
    if
        not arg5
        and (arg4._is_using or tick() < arg4._use_cooldown or arg4:Get("Ammo") <= 0 or arg4:IsEquipping())
    then
        return false
    end

    arg4._is_using = true
    arg4._use_cooldown = tick() + arg4.Info.InternalUseCooldown
    arg4.ViewModel:SetFlameParticlesEnabled(true)
    arg4.ViewModel:SetCustomSprintingEnabled(math.huge)

    if arg4.ViewModel.Info.Animations.Using then
        arg4.ViewModel:PlayAnimation("Using")
    end

    return true, "StartShooting"
end

function t.FinishShooting(arg6, arg7) -- line: 60
    if not arg7 and not arg6._is_using then
        return false
    end

    arg6:_StopUsing()

    return true, "FinishShooting"
end

function t.StartAiming(arg8, arg9) -- line: 70
    -- upvalues:
    --  [1] Utility_m (copy)

    if not arg9 and (tick() < arg8._airblast_cooldown or arg8:IsEquipping()) then
        return false
    end

    local now_2 = tick()
    arg8._airblast_cooldown = now_2 + arg8.Info.AirblastCooldown
    arg8.Airblasted:Fire()
    arg8:CooldownEffect("rbxassetid://16828140099", arg8.Info.AirblastCooldown, "Airblast")
    arg8.ViewModel:Impulse(Vector3.new(0, 0, 30), 0.5)
    arg8.ViewModel:StopAnimation("Inspect")
    arg8.ViewModel:SetCustomSprintingEnabled(if arg8._is_using then nil else 0.5, true)
    arg8:_Recoil(2)

    if arg8:Get("QuickAttackQueued") then
        task.delay(0.1, function() -- line: 86
            -- upvalues:
            --  [1] arg8 (copy)

            arg8.ViewModel:AirblastEffect()
        end)
    else
        arg8.ViewModel:AirblastEffect()
    end

    local v4 = arg8.ClientFighter:GetCameraData()

    if arg8.ClientFighter.IsLocalPlayer then
        local v5 = arg8.ClientFighter.Entity.RootPart.Velocity * Vector3.new(1, 0, 1)
        local RootPart = arg8.ClientFighter.Entity.RootPart
        local v6 = v5 + Vector3.new(
            0,
            math.max(0, arg8.ClientFighter.Entity.RootPart.Velocity.Y),
            0
        )
        RootPart.Velocity = v6 + Utility_m:DecodeCFrame(v4[utf8.char(0)]).LookVector * Vector3.new(0, 1, 0) * -25 * arg8.Info.AirblastRecoilKnockback
    end

    return true, "StartAiming", v4
end

function t.Equip(arg10, ...) -- line: 112
    -- upvalues:
    --  [1] Custom_m (copy)

    Custom_m.Equip(arg10, ...)
    arg10:_StopUsing()
end

function t.Unequip(arg11, ...) -- line: 117
    -- upvalues:
    --  [1] Custom_m (copy)

    arg11:_StopUsing()
    Custom_m.Unequip(arg11, ...)
end

function t.ReplicateFromServer(arg12, arg13, ...) -- line: 122
    -- upvalues:
    --  [1] Custom_m (copy)

    if arg13 == "StopUsing" then
        arg12:_StopUsing()

        return
    end

    Custom_m.ReplicateFromServer(arg12, arg13, ...)
end

function t.Destroy(arg14) -- line: 130
    -- upvalues:
    --  [1] Custom_m (copy)

    arg14.Airblasted:Destroy()
    arg14:_StopUsing()
    Custom_m.Destroy(arg14)
end

function t._StopUsing(arg15) -- line: 140
    if not arg15._is_using then
        return
    end

    arg15._is_using = false
    arg15.ViewModel:SetFlameParticlesEnabled(false)
    arg15.ViewModel:SetCustomSprintingEnabled(0)

    if arg15.ViewModel.Info.Animations.Using then
        arg15.ViewModel:StopAnimation("Using")
    end
end

function t._Init(arg16) -- line: 154
    table.insert(arg16._connections, arg16.ClientFighter.Interrupted:Connect(function() -- line: 155
        -- upvalues:
        --  [1] arg16 (copy)

        arg16:_StopUsing()
    end))
end

return t
