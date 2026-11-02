local _ = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local _ = require(Players.LocalPlayer.PlayerScripts.Controllers.ControlsController)
local Melee_m = require(Players.LocalPlayer.PlayerScripts.Modules.ItemTypes.Melee)
local t = setmetatable({}, Melee_m)
t.__index = t

function t.new(...) -- line: 10
    -- upvalues:
    --  [1] Melee_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(Melee_m.new(...), t)
    t_1._deflect_cooldown = 0
    t_1._deflect_hash = 0
    t_1._deflect_num = 0
    t_1:_Init()

    return t_1
end

function t.CanEasyQuickAttack(arg1) -- line: 26
    local v2 = arg1:CanQuickAttack()

    if v2 then
        v2 = if tick() > arg1._deflect_cooldown then not arg1:IsEquipping() else false
    end

    return v2
end

function t.StartAiming(arg2, arg3) -- line: 30
    if not arg3 and (tick() < arg2._deflect_cooldown or arg2:IsEquipping()) then
        return
    end

    local now_1 = tick()
    arg2._deflect_cooldown = now_1 + arg2.Info.DeflectDuration + arg2.Info.DeflectCooldown
    local now_2 = tick()
    arg2._attack_cooldown = now_2 + arg2.Info.DeflectDuration
    arg2:_StartDeflecting()
    arg2:CooldownEffect("rbxassetid://16828414433", arg2.Info.DeflectDuration, "Deflect", true)
    task.delay(arg2.Info.DeflectDuration, function() -- line: 40
        -- upvalues:
        --  [1] arg2 (copy)

        arg2:CooldownEffect("rbxassetid://16828414433", arg2.Info.DeflectCooldown, "Deflect")
    end)

    return true, "StartAiming"
end

function t.ReplicateFromServer(arg4, arg5, ...) -- line: 48
    -- upvalues:
    --  [1] Melee_m (copy)

    if arg5 == "DeflectHit" then
        if not arg4:IsRendered() then
            return
        end

        arg4.ViewModel:StopAnimation("DeflectIdle", 0)
        arg4.ViewModel:StopAnimation("Deflect" .. arg4._deflect_num)
        arg4._deflect_num = if arg4._deflect_num == #arg4.ViewModel:GetAnimationKeys("Deflect") then 1 else arg4._deflect_num + 1
        arg4.ViewModel:PlayAnimation("Deflect" .. arg4._deflect_num, 1, 0)
        arg4.ViewModel:PlayDeflectHitParticles()
        arg4.ViewModel:PlayDeflectHitSounds()

        return
    else
        Melee_m.ReplicateFromServer(arg4, arg5, ...)

        return
    end
end

function t._StopDeflectionAnimations(arg6) -- line: 69
    for index = 1, #arg6.ViewModel:GetAnimationKeys("Deflect") do
        arg6.ViewModel:StopAnimation("Deflect" .. index)
    end
end

function t._StartDeflecting(arg7) -- line: 75
    if arg7._last_attack_animation_name then
        arg7.ViewModel:StopAnimation(arg7._last_attack_animation_name)
    end

    arg7._deflect_hash += 1
    local DeflectHash = arg7._deflect_hash
    arg7:SetReplicate("FOVOffset", 5)
    arg7.ViewModel:StopAnimation("Equip", 0)
    arg7.ViewModel:PlayAnimation("DeflectIdle", arg7.Info.DeflectDuration)

    if arg7:Get("QuickAttackQueued") then
        task.delay(0.1, function() -- line: 89
            -- upvalues:
            --  [1] arg7 (copy)

            arg7.ViewModel:PlayDeflectActiveParticles()
        end)
    else
        arg7.ViewModel:PlayDeflectActiveParticles()
    end

    task.spawn(function() -- line: 96
        -- upvalues:
        --  [1] arg7 (copy)
        --  [2] DeflectHash (copy)

        wait(arg7.Info.DeflectDuration)

        if arg7._deflect_hash ~= DeflectHash then
            return
        end

        arg7:_StopDeflecting()
        wait(arg7.Info.DeflectCooldown)

        if arg7._deflect_hash ~= DeflectHash then
            return
        end

        arg7:StopCooldownEffect("Deflect")
    end)
end

function t._StopDeflecting(arg8) -- line: 115
    arg8._deflect_hash += 1
    arg8:SetReplicate("FOVOffset", 0)
    arg8.ViewModel:ClearDeflectActiveParticles()
    arg8:_StopDeflectionAnimations()
end

function t._Setup(arg9) -- line: 122
    function arg9._on_attack_callback() -- line: 123
        -- upvalues:
        --  [1] arg9 (copy)

        arg9.ViewModel:StopAnimation("DeflectIdle", 0)
        arg9:_StopDeflectionAnimations()
    end
end

function t._Init(arg10) -- line: 129
    arg10:_Setup()
end

return t
