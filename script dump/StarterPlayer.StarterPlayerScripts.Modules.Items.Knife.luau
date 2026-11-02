local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local _ = require(ReplicatedStorage.Modules.Utility)
local Melee_m = require(Players.LocalPlayer.PlayerScripts.Modules.ItemTypes.Melee)
local t = setmetatable({}, Melee_m)
t.__index = t

function t.new(...) -- line: 13
    -- upvalues:
    --  [1] Melee_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(Melee_m.new(...), t)
    t_1._heavy_attack_num = 0
    t_1._backstab_hash = 0
    t_1._fov_offset_speed = 1
    t_1:_Init()

    return t_1
end

function t.GetAimSpeed(arg1) -- line: 29
    return arg1._fov_offset_speed
end

function t.StartAiming(arg2, arg3, arg4) -- line: 33
    if not arg3 and (tick() < arg2._attack_cooldown or arg2:IsEquipping()) then
        return false
    end

    local now = tick()
    arg2._attack_cooldown = now + arg2.Info.HeavyAttackCooldown
    arg2:CooldownEffect(
        "rbxassetid://133090003053503",
        arg2.Info.HeavyAttackCooldown,
        "HeavyAttack"
    )

    if arg2._last_attack_animation_name then
        arg2.ViewModel:StopAnimation(arg2._last_attack_animation_name)
    end

    arg2._heavy_attack_num = arg2._heavy_attack_num % #arg2.ViewModel:GetAnimationKeys(
        "HeavyAttack"
    ) + 1
    local v2 = arg4 and arg2:FromEnum(arg4) or "HeavyAttack" .. arg2._heavy_attack_num
    arg2._last_attack_animation_name = v2
    arg2.ViewModel:StopAnimation("HeavyAttackAnimationHit")
    arg2.ViewModel:StopAnimation("Equip")
    arg2.ViewModel:PlayAnimation(v2, arg2.Info.HeavyAttackCooldown)
    task.delay(0.1, function() -- line: 54
        -- upvalues:
        --  [1] arg2 (copy)

        arg2:_Shake("Bump")
    end)
    local v3, v4 = arg2.ClientFighter:GetCameraData()

    if arg2.ClientFighter.IsLocalPlayer then
        arg2:_ImpactMarkerSlash(arg2.Info.HeavyAttackReach, v3, v4)
    end

    if arg2:Get("DashOnAim") then
        if not arg3 then
            arg2.ClientFighter.Entity:HardDash(
                arg2.ClientFighter:GetMoveVector(
                    true,
                    false,
                    workspace.CurrentCamera.CFrame.LookVector
                ) * 100,
                0.25
            )
        end

        arg2:CreateSound("rbxassetid://16492958314", 1, 1 + 0.1 * math.random(), true)
    end

    return true, "StartAiming", v3, arg2:ToEnum(v2)
end

function t.ReplicateFromServer(arg5, arg6, ...) -- line: 78
    -- upvalues:
    --  [1] Melee_m (copy)

    if arg6 == "BackstabEffect" then
        if not arg5:IsRendered() then
            return
        end

        arg5._backstab_hash += 1
        local BackstabHash = arg5._backstab_hash
        arg5._fov_offset_speed = 5
        arg5:SetReplicate("FOVOffset", -10)
        wait(0.25)

        if arg5._backstab_hash ~= BackstabHash then
            return
        end

        arg5._fov_offset_speed = 1
        arg5:SetReplicate("FOVOffset", 0)

        return
    else
        Melee_m.ReplicateFromServer(arg5, arg6, ...)

        return
    end
end

function t._Setup(arg7) -- line: 107
    function arg7._on_attack_callback() -- line: 108
        -- upvalues:
        --  [1] arg7 (copy)

        arg7.ViewModel:StopAnimation("HeavyAttackAnimationHit")
    end
end

function t._Init(arg8) -- line: 113
    arg8:_Setup()
end

return t
