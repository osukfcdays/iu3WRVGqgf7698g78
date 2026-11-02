local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local _ = require(ReplicatedStorage.Modules.AnimationLibrary)
local _ = require(ReplicatedStorage.Modules.BetterDebris)
local Melee_m = require(Players.LocalPlayer.PlayerScripts.Modules.ItemTypes.Melee)
local t = setmetatable({}, Melee_m)
t.__index = t

function t.new(...) -- line: 11
    -- upvalues:
    --  [1] Melee_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(Melee_m.new(...), t)
    t_1._spin_cooldown = 0
    t_1:_Init()

    return t_1
end

function t.CanQuickAttack(arg1) -- line: 25
    return if tick() > arg1._spin_cooldown then not arg1:IsEquipping() else false
end

function t.StartAiming(arg2, arg3) -- line: 29
    if
        not arg3
        and (tick() < arg2._spin_cooldown or tick() < arg2._attack_cooldown or arg2:IsEquipping())
    then
        return
    end

    arg2._spin_cooldown = tick() + arg2.Info.SpinCooldown
    arg2._attack_cooldown = tick() + arg2.Info.SpinDuration + 0.5

    if not arg3 then
        local v5 = arg2.ClientFighter:GetMoveVector(
            true,
            true,
            if workspace.CurrentCamera.CFrame.LookVector:FuzzyEq(Vector3.new(0, 1, 0)) then Vector3.new(0, 0, 0) else (workspace.CurrentCamera.CFrame.LookVector * Vector3.new(1, 0, 1)).Unit
        ) * arg2.Info.SpinSpeed
        arg2.ClientFighter.Entity:HardDash(
            v5,
            arg2.Info.SpinDuration,
            true,
            Vector3.new(0, 0.625, 0)
        )
    end

    if arg2.ItemInterface then
        arg2.ItemInterface:PlaySpeedLines(arg2.Info.SpinDuration)
    end

    if arg2._last_attack_animation_name then
        arg2.ViewModel:StopAnimation(arg2._last_attack_animation_name)
    end

    arg2:CooldownEffect("rbxassetid://16828140099", arg2.Info.SpinCooldown, "Spin")
    arg2.ViewModel:StopAnimation("Equip")
    arg2.ViewModel:PlayAnimation("SpinAttack", 1)
    arg2.ViewModel:PlaySpinParticles()
    arg2:_Shake("BattleAxeSpin")

    return true, "StartAiming", (arg2.ClientFighter:GetCameraData())
end

function t._Setup(arg4) -- line: 68
    function arg4._on_attack_callback() -- line: 69
        -- upvalues:
        --  [1] arg4 (copy)

        arg4.ViewModel:StopAnimation("SpinAttack")
    end
end

function t._Init(arg5) -- line: 74
    arg5:_Setup()
end

return t
