local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local _ = require(ReplicatedStorage.Modules.Utility)
local ClientItem_m = require(
    Players.LocalPlayer.PlayerScripts.Modules.ClientReplicatedClasses.ClientFighter.ClientItem
)
local t = setmetatable({}, ClientItem_m)
t.__index = t

function t.new(...) -- line: 10
    -- upvalues:
    --  [1] ClientItem_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(ClientItem_m.new(...), t)
    t_1._last_attack = 0
    t_1._burst_count = 0
    t_1._attack_cooldown = 0
    t_1._attack_num = 0
    t_1._attack_hash = 0
    t_1._last_attack_animation_name = nil
    t_1._on_attack_callback = nil
    t_1:_Init()

    return t_1
end

function t.GetAutoShootReach(arg1) -- line: 30
    return arg1.Info.AttackReach
end

function t.CanQuickAttack(arg2) -- line: 34
    local v2 = not arg2:IsEquipping()

    if v2 then
        v2 = if tick() > arg2._attack_cooldown then not arg2.Info.NeedsAmmoToAttack or arg2:Get(
            "Ammo"
        ) > 0 and true else false
    end

    return v2
end

function t.StartShooting(arg3, arg4, arg5) -- line: 38
    if
        not arg4
        and (arg3:IsEquipping() or tick() < arg3._attack_cooldown or arg3.Info.NeedsAmmoToAttack and arg3:Get(
            "Ammo"
        ) <= 0)
    then
        return false
    end

    local v3

    if arg3._last_attack_animation_name then
        v3 = arg3.ViewModel
        v3:StopAnimation(
            arg3._last_attack_animation_name,
            if not (arg3.Info.BurstCount > 1) then nil else 0
        )
    end

    v3 = if not (tick() - arg3._last_attack >= arg3.Info.AttackCooldown) then arg3._burst_count else 0
    arg3._burst_count = v3
    arg3._burst_count = arg3._burst_count % arg3.Info.BurstCount + 1
    arg3._last_attack = tick()
    local v5 = arg3._burst_count < arg3.Info.BurstCount and arg3.Info.BurstCooldown or arg3.Info.AttackCooldown
    arg3._attack_cooldown = tick() + v5
    arg3._attack_hash += 1
    local AttackHash = arg3._attack_hash
    arg3._attack_num = arg3._attack_num % #arg3.ViewModel:GetAnimationKeys("Attack") + 1
    local v6 = arg5 and arg3:FromEnum(arg5) or "Attack" .. arg3._attack_num
    arg3._last_attack_animation_name = v6
    arg3.ViewModel:StopAnimation("Equip")
    arg3.ViewModel:PlayAnimation(v6, v5)

    if arg3._on_attack_callback then
        arg3._on_attack_callback()
    end

    task.delay(arg3.Info.AttackDelay, function() -- line: 68
        -- upvalues:
        --  [1] AttackHash (copy)
        --  [2] arg3 (copy)

        if AttackHash ~= arg3._attack_hash then
            return
        end

        if arg3.ClientFighter.IsLocalPlayer then
            local v7, v8 = arg3.ClientFighter:GetCameraData()
            arg3:_ImpactMarkerSlash(arg3.Info.AttackReach, v7, v8)
        end

        arg3:_Shake("Bump")
    end)

    return true, "StartShooting", arg3.ClientFighter:GetCameraData(), arg3:ToEnum(v6)
end

function t.Equip(arg6, ...) -- line: 86
    -- upvalues:
    --  [1] ClientItem_m (copy)

    ClientItem_m.Equip(arg6, ...)
    arg6._attack_hash += 1
end

function t.Unequip(arg7, ...) -- line: 91
    -- upvalues:
    --  [1] ClientItem_m (copy)

    arg7._attack_hash += 1
    ClientItem_m.Unequip(arg7, ...)
end

function t._Init(_) -- line: 100
end

return t
