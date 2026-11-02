local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local Throwable_m = require(Players.LocalPlayer.PlayerScripts.Modules.ItemTypes.Throwable)
local t = setmetatable({}, Throwable_m)
t.__index = t

function t.new(...) -- line: 10
    -- upvalues:
    --  [1] Throwable_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(Throwable_m.new(...), t)
    t_1._detonate_cooldown = 0
    t_1._detonate_animation_cooldown = 0
    t_1:_Init()

    return t_1
end

function t.CanQuickAttack(arg1) -- line: 25
    -- upvalues:
    --  [1] Throwable_m (copy)

    return Throwable_m.CanQuickAttack(arg1) or arg1:Get("NumSatchels") > 0 and true
end

function t.StartShooting(arg2, arg3) -- line: 29
    -- upvalues:
    --  [1] Throwable_m (copy)

    if not arg3 and (arg2:Get("Ammo") or math.huge) <= 0 and arg2:Get("NumSatchels") > 0 then
        return arg2:StartAiming(arg3)
    end

    return Throwable_m.StartShooting(arg2, arg3)
end

function t.StartAiming(arg4, arg5) -- line: 37
    if not arg5 and arg4:IsEquipping() then
        return false
    end

    if arg5 or tick() > arg4._detonate_animation_cooldown then
        arg4._detonate_animation_cooldown = tick() + 0.25
        arg4.ViewModel:PlayAnimation("Detonate")
    end

    if not arg5 and (arg4:Get("NumSatchels") <= 0 or tick() < arg4._detonate_cooldown) then
        return false
    end

    arg4._detonate_cooldown = tick() + 0.25

    return true, "StartAiming"
end

function t.FinishAiming(_, _) -- line: 56
    return false
end

function t.ReplicateFromServer(arg8, arg9, ...) -- line: 60
    -- upvalues:
    --  [1] Utility_m (copy)
    --  [2] Throwable_m (copy)

    if arg9 == "SatchelAttached" then
        if not arg8:IsRendered() then
            return
        end

        Utility_m:CreateSound(
            "rbxassetid://128061013194700",
            0.1,
            1,
            ...,
            true,
            5
        )

        return
    else
        Throwable_m.ReplicateFromServer(arg8, arg9, ...)

        return
    end
end

function t._Init(_) -- line: 78
end

return t
