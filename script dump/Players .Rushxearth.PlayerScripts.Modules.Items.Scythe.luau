local ReplicatedStorage = game:GetService("ReplicatedStorage")
local _ = game:GetService("RunService")
local Players = game:GetService("Players")
local _ = require(ReplicatedStorage.Modules.BetterDebris)
local _ = require(Players.LocalPlayer.PlayerScripts.Controllers.ControlsController)
local Melee_m = require(Players.LocalPlayer.PlayerScripts.Modules.ItemTypes.Melee)
local t = setmetatable({}, Melee_m)
t.__index = t

function t.new(...) -- line: 12
    -- upvalues:
    --  [1] Melee_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(Melee_m.new(...), t)
    t_1._dash_cooldown = 0
    t_1:_Init()

    return t_1
end

function t.CanEasyQuickAttack(arg1) -- line: 26
    local v2 = arg1:CanQuickAttack()

    if v2 then
        v2 = if tick() > arg1._dash_cooldown then not arg1:IsEquipping() else false
    end

    return v2
end

function t.StartAiming(arg2, arg3) -- line: 30
    if not arg3 and (tick() < arg2._dash_cooldown or arg2:IsEquipping()) then
        return false
    end

    arg2._dash_cooldown = tick() + arg2.Info.DashCooldown
    arg2:CooldownEffect("rbxassetid://16828140099", arg2.Info.DashCooldown, "Dash")
    arg2.ViewModel:StopAnimation("Inspect")

    if arg2.ViewModel:GetAnimationTrack("Dash") then
        if arg2._last_attack_animation_name then
            arg2.ViewModel:StopAnimation(arg2._last_attack_animation_name)
        end

        arg2.ViewModel:PlayAnimation("Dash")
    end

    if not arg3 then
        arg2.ClientFighter.Entity:HardDash(
            arg2.ClientFighter:GetMoveVector(true, false, workspace.CurrentCamera.CFrame.LookVector) * arg2.Info.DashSpeed,
            arg2.Info.DashDuration
        )
    end

    arg2:CreateSound("rbxassetid://16492958314", 1, 1 + 0.1 * math.random(), true)

    if arg2.ItemInterface then
        arg2.ItemInterface:PlaySpeedLines(arg2.Info.DashDuration)
    end

    return true, "StartAiming"
end

function t.FinishAiming(_, _) -- line: 63
    return false
end

function t._Setup(arg6) -- line: 71
    function arg6._on_attack_callback() -- line: 72
        -- upvalues:
        --  [1] arg6 (copy)

        arg6.ViewModel:StopAnimation("Dash", 0)
    end
end

function t._Init(arg7) -- line: 77
    arg7:_Setup()
end

return t
