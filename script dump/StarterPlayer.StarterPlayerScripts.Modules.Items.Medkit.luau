local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local AnimationLibrary_m = require(ReplicatedStorage.Modules.AnimationLibrary)
local Signal_m = require(ReplicatedStorage.Modules.Signal)
local Custom_m = require(Players.LocalPlayer.PlayerScripts.Modules.ItemTypes.Custom)
local t = setmetatable({}, Custom_m)
t.__index = t

function t.new(...) -- line: 11
    -- upvalues:
    --  [1] Custom_m (copy)
    --  [2] t (copy)
    --  [3] Signal_m (copy)

    local t_1 = setmetatable(Custom_m.new(...), t)
    t_1.AnimationReachedHealTimestamp = Signal_m.new()
    t_1._is_using = false
    t_1._use_cooldown = 0
    t_1._use_hash = 0
    t_1:_Init()

    return t_1
end

function t.GetAutoShootReactionTime(_) -- line: 29
    return nil
end

function t.CanQuickAttack(arg2) -- line: 33
    local v2 = not arg2._is_using

    if v2 then
        v2 = false

        if tick() > arg2._use_cooldown then
            v2 = not arg2:IsEquipping()

            if v2 then
                v2 = arg2.ClientFighter:GetHealth() < arg2.ClientFighter:GetMaxHealth() and true
            end
        end
    end

    return v2
end

function t.StartShooting(arg3, arg4) -- line: 37
    local v4 = arg3.ClientFighter:GetHealth()

    if
        not arg4
        and (arg3._is_using or tick() < arg3._use_cooldown or arg3:IsEquipping() or v4 >= arg3.ClientFighter:GetMaxHealth())
    then
        return false
    end

    arg3:_Use("Long")

    return true, "StartShooting"
end

function t.StartAiming(arg5, arg6) -- line: 47
    local v5 = arg5.ClientFighter:GetHealth()

    if
        not arg6
        and (arg5._is_using or tick() < arg5._use_cooldown or arg5:IsEquipping() or v5 >= arg5.ClientFighter:GetMaxHealth())
    then
        return false
    end

    arg5:_Use("Quick")

    return true, "StartAiming"
end

function t.Unequip(arg7, ...) -- line: 57
    -- upvalues:
    --  [1] Custom_m (copy)

    arg7:_CancelUse()
    Custom_m.Unequip(arg7, ...)
end

function t.ReplicateFromServer(arg8, arg9, ...) -- line: 62
    -- upvalues:
    --  [1] Custom_m (copy)

    if arg9 == "CancelUse" then
        if not arg8:IsRendered() then
            return
        end

        arg8:_CancelUse()

        return
    elseif arg9 == "SetCooldown" then
        if not arg8:IsRendered() then
            return
        end

        arg8:_SetCooldown()

        return
    else
        Custom_m.ReplicateFromServer(arg8, arg9, ...)

        return
    end
end

function t.Destroy(arg10) -- line: 80
    -- upvalues:
    --  [1] Custom_m (copy)

    arg10.AnimationReachedHealTimestamp:Destroy()
    Custom_m.Destroy(arg10)
end

function t._SetCooldown(arg11) -- line: 89
    arg11._use_cooldown = tick() + arg11.Info.Cooldown
    arg11._is_using = false
    arg11:CooldownEffect("rbxassetid://17156089790", arg11.Info.Cooldown, "Heal")
end

function t._CancelUse(arg12) -- line: 95
    arg12._is_using = false
    arg12._use_hash += 1
    arg12:StopCooldownEffect("Healing")
    arg12.ViewModel:StopAnimation("Use")
    arg12.ViewModel:StopAnimation("UseQuick")
end

function t._Use(arg13, arg14) -- line: 104
    -- upvalues:
    --  [1] AnimationLibrary_m (copy)

    arg13._is_using = true
    local UseHash = arg13._use_hash
    local v6 = arg13.Info[arg14 .. "ActionTimestamp"]
    local v7 = if arg14 == "Long" then "Use" else if arg14 ~= "Quick" then nil else "UseQuick"
    local v8 = AnimationLibrary_m.Info[arg13.ViewModel.Info.Animations[v7]]
    arg13.ViewModel:StopAnimation(arg13.ViewModel.Animator:GetEquipAnimationKey())
    arg13.ViewModel:PlayAnimation(v7, v8.Length)
    arg13:CooldownEffect("rbxassetid://17140223250", v6, "Healing", true)
    task.spawn(function() -- line: 116
        -- upvalues:
        --  [1] v6 (copy)
        --  [2] UseHash (copy)
        --  [3] arg13 (copy)

        wait(v6)

        if UseHash ~= arg13._use_hash then
            return
        end

        arg13.AnimationReachedHealTimestamp:Fire()
        arg13._use_cooldown = tick() + 1
        arg13._is_using = false
    end)
    task.spawn(function() -- line: 132
        -- upvalues:
        --  [1] v8 (copy)
        --  [2] UseHash (copy)
        --  [3] arg13 (copy)

        wait(v8.Length)

        if UseHash ~= arg13._use_hash then
            return
        end

        if arg13.ViewModel.PlayEquipAnimationOnHeal then
            arg13.ViewModel:PlayAnimation(arg13.ViewModel.Animator:GetEquipAnimationKey())
        end
    end)
end

function t._Init(_) -- line: 145
end

return t
