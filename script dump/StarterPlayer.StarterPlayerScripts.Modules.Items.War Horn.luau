local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local AnimationLibrary_m = require(ReplicatedStorage.Modules.AnimationLibrary)
local Custom_m = require(Players.LocalPlayer.PlayerScripts.Modules.ItemTypes.Custom)
local t = setmetatable({}, Custom_m)
t.__index = t

function t.new(...) -- line: 10
    -- upvalues:
    --  [1] Custom_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(Custom_m.new(...), t)
    t_1._use_cooldown = 0
    t_1._use_hash = 0
    t_1:_Init()

    return t_1
end

function t.GetAutoShootReactionTime(_) -- line: 25
    return nil
end

function t.CanQuickAttack(arg2) -- line: 29
    return if tick() > arg2._use_cooldown then not arg2:IsEquipping() else false
end

function t.StartShooting(arg3, arg4) -- line: 33
    -- upvalues:
    --  [1] AnimationLibrary_m (copy)

    if not arg4 and (tick() < arg3._use_cooldown or arg3:IsEquipping()) then
        return false
    end

    arg3._use_cooldown = tick() + arg3.Info.Cooldown
    arg3:CooldownEffect("rbxassetid://17156089790", arg3.Info.Cooldown, "Use")
    arg3.ViewModel:StopAnimation("Equip")
    arg3.ViewModel:PlayAnimation(
        "Use",
        AnimationLibrary_m.Info[arg3.ViewModel.Info.Animations.Use].Length
    )
    arg3.ViewModel:PlayHornEffect()

    return true, "StartShooting"
end

function t.Unequip(arg5, ...) -- line: 47
    -- upvalues:
    --  [1] Custom_m (copy)

    arg5._use_hash += 1
    Custom_m.Unequip(arg5, ...)
end

function t._CancelUse(arg6) -- line: 56
    arg6._is_using = false
    arg6._use_hash += 1
    arg6:StopCooldownEffect("Use")
    arg6.ViewModel:StopAnimation("Use")
    arg6.ViewModel:StopAnimation("UseQuick")
end

function t._Init(_) -- line: 65
end

return t
