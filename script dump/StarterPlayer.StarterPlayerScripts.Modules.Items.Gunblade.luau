local ReplicatedStorage = game:GetService("ReplicatedStorage")
local _ = game:GetService("RunService")
local Players = game:GetService("Players")
local AnimationLibrary_m = require(ReplicatedStorage.Modules.AnimationLibrary)
local _ = require(ReplicatedStorage.Modules.BetterDebris)
local Gun_m = require(Players.LocalPlayer.PlayerScripts.Modules.ItemTypes.Gun)
local t = setmetatable({}, Gun_m)
t.__index = t

function t.new(...) -- line: 14
    -- upvalues:
    --  [1] Gun_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(Gun_m.new(...), t)
    t_1.ToggleAimEnabled = nil
    t_1._transition_cooldown = 0
    t_1._blade_cooldown = 0
    t_1._blade_attack_num = 0
    t_1._last_blade_animation_name = nil
    t_1._dash_cooldown = 0
    t_1._fov_offset_speed = 1
    t_1._blade_critical_hit_hash = 0
    t_1._transition_animation_playing = 0
    t_1:_Init()

    return t_1
end

function t.CanQuickAttack(arg1) -- line: 37
    -- upvalues:
    --  [1] Gun_m (copy)

    local v2 = false

    if tick() > arg1._transition_cooldown then
        if arg1:Get("Mode") == "Gun" then
            return (Gun_m.CanQuickAttack(arg1))
        end

        v2 = if tick() > arg1._blade_cooldown then not arg1:IsEquipping() else false
    end

    return v2
end

function t.GetAutoShootReactionTime(arg2) -- line: 41
    -- upvalues:
    --  [1] Gun_m (copy)

    if arg2:Get("Mode") == "Blade" then
        return 0
    end

    return (Gun_m.GetAutoShootReactionTime(arg2))
end

function t.GetAutoShootReach(arg3) -- line: 45
    -- upvalues:
    --  [1] Gun_m (copy)

    if arg3:Get("Mode") == "Blade" then
        return arg3.Info.BladeReach
    end

    return (Gun_m.GetAutoShootReach(arg3))
end

function t.GetAimSpeed(arg4) -- line: 49
    return arg4._fov_offset_speed
end

function t.GetMobileInputSettings(arg5) -- line: 53
    -- upvalues:
    --  [1] Gun_m (copy)

    if arg5:Get("Mode") == "Blade" then
        return arg5.Info.BladeModeMobileInputSettings
    end

    return (Gun_m.GetMobileInputSettings(arg5))
end

function t.StartShooting(arg6, arg7, arg8, ...) -- line: 57
    -- upvalues:
    --  [1] Gun_m (copy)

    local v3 = arg8 or arg6:Get("Mode")

    if not arg7 and (tick() < arg6._transition_cooldown or arg6:IsEquipping()) then
        return false
    end

    arg6.ViewModel:StopAnimation("To" .. v3)

    if v3 == "Gun" then
        return Gun_m.StartShooting(arg6, arg7, ...)
    end

    if v3 == "Blade" then
        return arg6:_StartShootingBladeMode(arg7, ...)
    end

    return false
end

function t.StartAiming(arg9, arg10, arg11, ...) -- line: 75
    -- upvalues:
    --  [1] Gun_m (copy)

    local v5 = arg11 or arg9:Get("Mode")

    if
        not arg10
        and (if v5 ~= "Gun" then arg9:IsEquipping() else tick() < arg9._transition_cooldown or arg9:IsEquipping())
    then
        return false
    end

    arg9.ViewModel:StopAnimation("To" .. v5)

    if v5 == "Gun" then
        return Gun_m.StartAiming(arg9, arg10, ...)
    end

    if v5 == "Blade" then
        return arg9:_StartAimingBladeMode(arg10, ...)
    end

    return false
end

function t.ReplicateFromServer(arg12, arg13, ...) -- line: 93
    -- upvalues:
    --  [1] AnimationLibrary_m (copy)
    --  [2] Gun_m (copy)

    if arg13 == "BladeCriticalHit" then
        if not arg12:IsRendered() or not arg12.IsEquipped then
            return
        end

        local v7 = if ... then "BladeAttackOnHitNoAmmo" else "BladeAttackOnHit"
        arg12._blade_critical_hit_hash += 1
        local BladeCriticalHitHash = arg12._blade_critical_hit_hash
        arg12._fov_offset_speed = 5
        arg12:SetReplicate("FOVOffset", -5)

        if arg12._last_blade_animation_name then
            arg12.ViewModel:StopAnimation(arg12._last_blade_animation_name)
        end

        arg12.ViewModel:PlayAnimation(v7, nil, 0)
        wait(AnimationLibrary_m.Info[arg12.ViewModel.Info.Animations[v7]].ActionTimestamp)

        if arg12._blade_critical_hit_hash ~= BladeCriticalHitHash then
            return
        end

        arg12:SetReplicate("FOVOffset", 5)
        arg12:_Recoil(2)
        arg12.ViewModel:MuzzleFlash()
        wait(0.125)

        if arg12._blade_critical_hit_hash ~= BladeCriticalHitHash then
            return
        end

        arg12._fov_offset_speed = 1
        arg12:SetReplicate("FOVOffset", 0)

        return
    else
        Gun_m.ReplicateFromServer(arg12, arg13, ...)

        return
    end
end

function t._StartShootingBladeMode(arg14, arg15) -- line: 145
    if not arg15 and tick() < arg14._blade_cooldown then
        return false
    end

    local now_2 = tick()
    arg14._blade_cooldown = now_2 + arg14.Info.BladeCooldown

    if arg14._last_blade_animation_name then
        arg14.ViewModel:StopAnimation(arg14._last_blade_animation_name)
    end

    arg14._blade_attack_num = arg14._blade_attack_num % #arg14.ViewModel:GetAnimationKeys(
        "BladeAttack"
    ) + 1
    arg14._last_blade_animation_name = "BladeAttack" .. arg14._blade_attack_num
    arg14.ViewModel:StopAnimation("Dash", 0)
    arg14.ViewModel:StopAnimation("BladeAttackOnHitNoAmmo")
    arg14.ViewModel:StopAnimation("BladeAttackOnHit")
    arg14.ViewModel:StopAnimation("BladeEquip")
    arg14.ViewModel:StopAnimation("Equip")
    arg14.ViewModel:PlayAnimation(arg14._last_blade_animation_name, arg14.Info.BladeCooldown)
    task.delay(0.1, function() -- line: 166
        -- upvalues:
        --  [1] arg14 (copy)

        arg14:_Shake("Bump")
    end)
    local v8, v9 = arg14.ClientFighter:GetCameraData()

    if arg14.ClientFighter.IsLocalPlayer then
        arg14:_ImpactMarkerSlash(arg14.Info.BladeReach, v8, v9)
    end

    return true, "StartShooting", v8
end

function t._StartAimingBladeMode(arg16, arg17) -- line: 179
    if not arg17 and tick() < arg16._dash_cooldown then
        return false
    end

    arg16._dash_cooldown = tick() + arg16.Info.DashCooldown
    arg16:CooldownEffect("rbxassetid://16828140099", arg16.Info.DashCooldown, "Dash")

    if not arg17 then
        arg16.ClientFighter.Entity:HardDash(
            arg16.ClientFighter:GetMoveVector(
                true,
                false,
                workspace.CurrentCamera.CFrame.LookVector
            ) * arg16.Info.DashSpeed,
            arg16.Info.DashDuration
        )
    end

    arg16:CreateSound("rbxassetid://16492958314", 1, 1 + 0.1 * math.random(), true)

    if arg16.ItemInterface then
        arg16.ItemInterface:PlaySpeedLines(arg16.Info.DashDuration)
    end

    if arg16.ViewModel:GetAnimationTrack("Dash") then
        if arg16._last_attack_animation_name then
            arg16.ViewModel:StopAnimation(arg16._last_attack_animation_name)
        end

        if arg16._last_blade_animation_name then
            arg16.ViewModel:StopAnimation(arg16._last_blade_animation_name)
        end

        arg16.ViewModel:StopAnimation("BladeAttackOnHitNoAmmo")
        arg16.ViewModel:StopAnimation("BladeAttackOnHit")
        arg16.ViewModel:StopAnimation("BladeEquip")
        arg16.ViewModel:StopAnimation("Equip")
        arg16.ViewModel:PlayAnimation("Dash")
    end

    return true, "StartAiming"
end

function t._ModeChanged(arg18, arg19) -- line: 219
    if arg18._last_shoot_animation_name then
        arg18.ViewModel:StopAnimation(arg18._last_shoot_animation_name)
    end

    if arg18._last_blade_animation_name then
        arg18.ViewModel:StopAnimation(arg18._last_blade_animation_name)
    end

    local v14 = arg18:Get("Mode")
    local v15 = if v14 == "Blade" then "Blade" else ""
    arg18.ViewModel:ChangeEquipAnimation(v15 .. "Equip")
    arg18.ViewModel:ChangeIdleAnimation(v15 .. "Idle")
    arg18.ViewModel:ChangeSprintAnimation(v15 .. "Sprint")
    arg18.ViewModel:ChangeInspectAnimation(v15 .. "Inspect")

    if not arg19 then
        arg18.ViewModel:PlayAnimation(
            "To" .. v14 .. (if v14 ~= "Gun" then "" else arg18._blade_attack_num or "")
        )

        for _, val in pairs({ "Shoot", "BladeAttack" }) do
            for index = 1, #arg18.ViewModel:GetAnimationKeys(val) do
                arg18.ViewModel.Animator:BlockAnimation(val .. index, 0.25)
            end
        end
    end

    arg18.ToggleAimEnabled = v14 == "Gun"
end

function t._Setup(arg20) -- line: 250
    function arg20._on_shoot_callback() -- line: 251
        -- upvalues:
        --  [1] arg20 (copy)

        arg20.ViewModel:StopAnimation("Dash", 0)
    end
end

function t._Init(arg21) -- line: 256
    arg21.Shot:Connect(function() -- line: 257
        -- upvalues:
        --  [1] arg21 (copy)

        arg21.ViewModel:StopAnimation("BladeAttackOnHit")
        arg21.ViewModel:StopAnimation("BladeAttackOnHitNoAmmo")
    end)
    arg21:GetDataChangedSignal("Mode"):Connect(function() -- line: 271
        -- upvalues:
        --  [1] arg21 (copy)

        task.spawn(arg21.Input, arg21, "FinishAiming")
        arg21._blade_attack_num = if arg21:Get("Mode") == "Blade" then 0 else arg21._blade_attack_num
        arg21._transition_cooldown = tick() + arg21.Info.TransitionCooldown - 0.1
        arg21:_ModeChanged()
        arg21.ToggleOffMobileInputButton:Fire("mobile_aim")
    end)
    arg21:_Setup()
    arg21:_ModeChanged(true)
end

return t
