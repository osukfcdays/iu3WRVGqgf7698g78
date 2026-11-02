local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CONSTANTS_m = require(ReplicatedStorage.Modules.CONSTANTS)
local AnimationLibrary_m = require(ReplicatedStorage.Modules.AnimationLibrary)
local GameplayUtility_m = require(ReplicatedStorage.Modules.GameplayUtility)
local BetterDebris_m = require(ReplicatedStorage.Modules.BetterDebris)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local Spring_m = require(ReplicatedStorage.Modules.Spring)
local Signal_m = require(ReplicatedStorage.Modules.Signal)
local PlayerDataController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.PlayerDataController
)
local CameraController_m = require(Players.LocalPlayer.PlayerScripts.Controllers.CameraController)
local WrapController_m = require(Players.LocalPlayer.PlayerScripts.Controllers.WrapController)
local ClientItem_m = require(
    Players.LocalPlayer.PlayerScripts.Modules.ClientReplicatedClasses.ClientFighter.ClientItem
)
local TracerEffect_m = require(Players.LocalPlayer.PlayerScripts.Modules.TracerEffect)
local Projectiles = Players.LocalPlayer.PlayerScripts.Assets:WaitForChild("Projectiles")
local t = setmetatable({}, ClientItem_m)
t.__index = t

function t.new(...) -- line: 24
    -- upvalues:
    --  [1] ClientItem_m (copy)
    --  [2] t (copy)
    --  [3] Signal_m (copy)
    --  [4] Spring_m (copy)

    local t_1 = setmetatable(ClientItem_m.new(...), t)
    t_1.Shot = Signal_m.new()
    t_1.ProjectileShot = Signal_m.new()
    t_1.ToggleAimEnabled = true
    t_1.Data.IsAiming = false
    t_1._last_shot = 0
    t_1._burst_count = 0
    t_1._shoot_cooldown = 0
    t_1._is_revolver_quick_shooting = nil
    t_1._shoot_animation_num = 1
    t_1._last_shoot_animation_name = nil
    t_1._shoot_cooldown_no_ammo = 0
    t_1._on_shoot_callback = nil
    t_1._shot_but_ammo_hasnt_updated = false
    t_1._reload_threads = {}
    t_1._reload_cooldown = 0
    t_1._reload_cancel_cooldown = 0
    t_1._reload_cancel_expiration = 0
    t_1._reload_delay = 0
    t_1._local_tracers = {}
    t_1._on_reload_callback = nil
    t_1._projectile_part_to_model = {}
    t_1._is_input_queueing = false
    t_1._camera_displacement_spring = Spring_m.new(Vector2.zero, 1, 25)
    t_1._shoot_animation_name_prefix = nil
    t_1._num_shooting_animations = nil
    t_1:_Init()

    return t_1
end

function t.CanQuickAttack(arg1) -- line: 65
    return if tick() > arg1._shoot_cooldown then if arg1:Get("Ammo") > 0 then not arg1:IsEquipping() else false else false
end

function t.GetAutoShootReactionTime(arg2) -- line: 69
    if arg2.Info.BurstCount > 1 then
        return (arg2.Info.BurstCooldown * arg2.Info.BurstCount) ^ 2
    end

    return arg2.Info.ShootCooldown ^ 2
end

function t.GetAimSpeed(arg3) -- line: 73
    return arg3:Get("IsAiming") and arg3.Info.AimSpeed or 1
end

function t.IsFullyAiming(arg4) -- line: 77
    local v4 = arg4:Get("IsAiming")

    if v4 then
        v4 = not arg4.Info.AimScopePercent or arg4.ViewModel.CurrentAimValue >= arg4.Info.AimScopePercent
    end

    return v4
end

function t.ChangeShootAnimationNamePrefix(arg5, arg6) -- line: 81
    arg5._shoot_animation_name_prefix = arg6
    arg5._num_shooting_animations = #arg5.ViewModel:GetAnimationKeys(
        arg5._shoot_animation_name_prefix
    )
    arg5._shoot_animation_num = if arg5._num_shooting_animations == 0 then 0 else math.clamp(
        arg5._shoot_animation_num,
        1,
        arg5._num_shooting_animations
    )
end

function t.StartShooting(arg7, arg8, arg9) -- line: 87
    if tick() < (arg7._is_revolver_quick_shooting or 0) and not arg9 then
        return false
    end

    local v6 = arg7:Get("Ammo")

    if not arg8 then
        if tick() < arg7._shoot_cooldown_no_ammo or arg7:IsEquipping() then
            return false
        end

        if
            tick() < arg7._reload_cooldown
            and (tick() < arg7._reload_cancel_cooldown or v6 <= 0 or tick() >= arg7._reload_cancel_expiration)
        then
            return false
        end

        if arg7.Info.MaxAmmo and v6 <= 0 and tick() > arg7._reload_delay then
            local t_2 = { arg7:StartReloading() }

            if t_2[1] then
                return table.unpack(t_2)
            end

            arg7._shoot_cooldown_no_ammo = tick() + math.max(0.1, arg7.Info.ShootCooldown)
            arg7:CreateSound(
                "rbxassetid://13087319223",
                1,
                1,
                true,
                5
            )

            return false
        end

        if tick() < arg7._shoot_cooldown then
            if
                not arg7._is_input_queueing
                and not arg7.Info.InputSpammingEnabled.StartShooting
                and arg7._shoot_cooldown - tick() < 0.1
            then
                arg7._is_input_queueing = true
                task.delay(arg7._shoot_cooldown - tick(), function() -- line: 114
                    -- upvalues:
                    --  [1] arg7 (copy)

                    arg7._is_input_queueing = false
                    arg7.ClientFighter:Input("StartShooting")
                end)
            end

            return false
        end

        if
            arg7.Name == "Minigun"
            and (arg7.ViewModel.IsWindingMinigun or not arg7.ViewModel.IsChargingMinigun)
        then
            task.defer(arg7.ViewModel.StartChargingMinigun, arg7.ViewModel)

            return false
        end
    end

    if arg9 then
        arg7._is_revolver_quick_shooting = tick() + arg7.Info.QuickShotCooldown * arg7.Info.MaxAmmo
    end

    arg7.ViewModel:StopAnimation("Equip")
    arg7.ViewModel:StopAnimation("EquipEmpty")
    arg7:_ResetReloadState()
    arg7._burst_count = if tick() - arg7._last_shot >= arg7.Info.ShootCooldown then 0 else arg7._burst_count
    arg7._burst_count = arg7._burst_count % arg7.Info.BurstCount + 1
    arg7._last_shot = tick()
    local v8 = arg7:IsFullyAiming()
    local v10 = v6 + (if arg8 then 1 else 0)
    local v11 = arg9 and arg7.Info.QuickShotCooldown or arg7._burst_count < arg7.Info.BurstCount and arg7.Info.BurstCooldown or arg7.Info.ShootCooldown
    arg7._shoot_cooldown = tick() + v11

    if arg7._num_shooting_animations > 0 then
        local v12 = if arg9 and arg7.ViewModel.Info.Animations.FinalQuickShot and v10 == 1 then "FinalQuickShot" else if arg9 then "QuickShot" else if arg7.ViewModel.Info.Animations.FinalShoot and v10 == 1 then "FinalShoot" else if arg7.ViewModel.Info.Animations.ShootAiming and v8 then "ShootAiming" else arg7._shoot_animation_name_prefix .. arg7._shoot_animation_num
        arg7._shoot_animation_num = if arg7._num_shooting_animations == 0 then 0 else arg7._shoot_animation_num % arg7._num_shooting_animations + 1

        if arg7._last_shoot_animation_name then
            arg7.ViewModel:StopAnimation(arg7._last_shoot_animation_name)
        end

        arg7._last_shoot_animation_name = v12
        arg7.ViewModel:PlayAnimation(v12, v11, 0)
    end

    v11 = arg7.ClientFighter:GetCameraData()

    if arg7._on_shoot_callback then
        arg7._on_shoot_callback(v11)
    end

    arg7:_Recoil(if not v8 then 1 else 0.5)
    arg7.ViewModel:MuzzleFlash()

    if v10 < math.huge and v10 <= arg7.Info.MaxAmmo * 0.25 then
        arg7:CreateSound(
            "rbxassetid://13087319223",
            1,
            1,
            true,
            5
        )
    end

    if
        arg7.ClientFighter.IsLocalPlayer
        and arg7.Info.IsRaycast
        and not arg7.Info.DisableTracerEffects
    then
        arg7:_LocalTracers(v8, arg9)
    end

    if arg7.Info.AimScopePercent or arg7.Name == "Shotgun" then
        task.defer(arg7.Input, arg7, "FinishAiming")
        arg7.ToggleOffMobileInputButton:Fire("mobile_aim")
    end

    arg7._shot_but_ammo_hasnt_updated = true
    arg7.Shot:Fire()
    local v16

    if arg7.ClientFighter:Get("IsSpectating") then
        local CameraDisplacementSpring = arg7._camera_displacement_spring
        local vec2 = Vector2.new(
            0.017453292519943295,
            math.sign(math.random() - 0.5) * 0.017453292519943295
        )
        v16 = v8 and arg7.Info.ShootCameraDisplacementRecoilWhileAiming or arg7.Info.ShootCameraDisplacementRecoil
        CameraDisplacementSpring.Value = vec2 * v16
        arg7:_StartCameraDisplacementLoop()
    end

    v16 = v8 or (if not arg9 then nil else false)

    return true, "StartShooting", v11, v16, arg9
end

function t.StartReloading(
    arg10,
    arg11,
    arg12,
    arg13,
    arg14
) -- line: 199
    -- upvalues:
    --  [1] AnimationLibrary_m (copy)

    local v17 = arg10:Get("Ammo")
    local v18 = arg10:Get("AmmoReserve")

    if arg10._shot_but_ammo_hasnt_updated then
        v17 = math.max(0, v17 - 1)
    end

    if
        not arg10.Info.ReloadType
        or not arg11 and (tick() < arg10._reload_cooldown or arg10:IsEquipping() or not arg10.ClientFighter:Get(
            "InfiniteAmmoReserve"
        ) and v18 and v18 <= 0)
        or v17 >= arg10.Info.MaxAmmo
    then
        return false
    end

    task.defer(arg10.Input, arg10, "FinishAiming")
    arg10.ToggleOffMobileInputButton:Fire("mobile_aim")
    arg10.ViewModel:StopAnimation("Equip")
    arg10.ViewModel:StopAnimation("EquipEmpty")

    if arg10._last_shoot_animation_name then
        arg10.ViewModel:StopAnimation(arg10._last_shoot_animation_name, 0)
    end

    arg10._is_revolver_quick_shooting = nil
    arg10._shoot_animation_num = 1
    arg10:_ResetReloadState()

    if arg10._on_reload_callback then
        arg10._on_reload_callback()
    end

    local v19 = v17 == 0
    local v20 = if arg12 then arg10:FromEnum(arg12) or (if not v19 then "Reload" else if not (arg10.Info.NumEmptyReloadFiles > 0) then "Reload" else "EmptyReload") else if not v19 then "Reload" else if not (arg10.Info.NumEmptyReloadFiles > 0) then "Reload" else "EmptyReload"
    local v22 = arg10:Get("NumReloadsSoFar") % arg10.Info.NumReloadFiles + 1
    local v24 = arg10.Info.ReloadFiles[v20][v22]
    local v25

    if arg13 then
        v25 = arg10:FromEnum(arg13)

        if not v25 then
            v25 = if v19 and arg10.ViewModel.Animator:HasEmptyReloadAnimations() then "EmptyReload" else v22 ~= 1 and "Reload" .. v22 or "Reload"
        end
    else
        v25 = if v19 and arg10.ViewModel.Animator:HasEmptyReloadAnimations() then "EmptyReload" else v22 ~= 1 and "Reload" .. v22 or "Reload"
    end

    if arg10.Info.ReloadType == "Regular" then
        local Length = v24.Length
        local ActionTimestamp = v24.ActionTimestamp
        arg10._reload_cooldown = tick() + Length
        arg10._reload_cancel_expiration = tick() + v24.ActionTimestamp
        local now_9 = tick()
        local v26 = if not v19 then 0.25 else Length
        arg10._reload_cancel_cooldown = now_9 + v26
        table.insert(arg10._reload_threads, task.spawn(function() -- line: 249
            -- upvalues:
            --  [1] arg10 (copy)
            --  [2] ActionTimestamp (copy)
            --  [3] Length (copy)

            arg10:CooldownEffect("rbxassetid://17139961241", ActionTimestamp, "Reload", true)
            wait(ActionTimestamp)
            arg10:CooldownEffect("rbxassetid://17156089790", Length - ActionTimestamp, "Reload")
        end))
        table.insert(arg10._reload_threads, task.spawn(function() -- line: 258
            -- upvalues:
            --  [1] arg10 (copy)
            --  [2] v25 (copy)
            --  [3] Length (copy)

            local ViewModel = arg10.ViewModel
            local v28 = v25
            ViewModel:PlayAnimation(
                v28,
                Length,
                if not arg10.ViewModel.ShouldPlayReloadAnimationInstantly then 0.1 else 0
            )
        end))
    elseif arg10.Info.ReloadType == "Segmented" then
        local StartLength = v24.StartLength
        local StartActionTimestamp = v24.StartActionTimestamp
        local SegmentLength = v24.SegmentLength
        local SegmentActionTimestamp = v24.SegmentActionTimestamp
        local FinishActionTimestamp = v24.FinishActionTimestamp
        local FinishLength = v24.FinishLength
        local v31

        if arg14 then
            v31 = utf8.codepoint(arg14)
        else
            local v32 = not arg10.ClientFighter:Get("InfiniteAmmoReserve") and v18 or math.huge
            v31 = math.min(v32, arg10.Info.MaxAmmo - v17) - (if StartActionTimestamp then 1 else 0) - (if not FinishActionTimestamp then 0 else 1)
        end

        local v35 = StartLength + SegmentLength * v31 + FinishLength
        local v36 = StartActionTimestamp or StartLength + SegmentActionTimestamp
        arg10._reload_cooldown = tick() + v35
        arg10._reload_cancel_expiration = math.huge
        arg10._reload_cancel_cooldown = if not v19 then tick() + 0.25 else v36
        table.insert(arg10._reload_threads, task.spawn(function() -- line: 279
            -- upvalues:
            --  [1] StartActionTimestamp (copy)
            --  [2] arg10 (copy)
            --  [3] StartLength (copy)
            --  [4] v31 (copy)
            --  [5] SegmentActionTimestamp (copy)
            --  [6] SegmentLength (copy)
            --  [7] FinishActionTimestamp (copy)

            if StartActionTimestamp then
                arg10:CooldownEffect(
                    "rbxassetid://17139961241",
                    StartActionTimestamp,
                    "Reload",
                    true
                )
            end

            wait(StartLength)

            for _ = 1, v31 do
                arg10:CooldownEffect(
                    "rbxassetid://17139961241",
                    SegmentActionTimestamp,
                    "Reload",
                    true
                )
                wait(SegmentLength)
            end

            if FinishActionTimestamp then
                arg10:CooldownEffect(
                    "rbxassetid://17139961241",
                    FinishActionTimestamp,
                    "Reload",
                    true
                )
            end
        end))
        table.insert(arg10._reload_threads, task.spawn(function() -- line: 298
            -- upvalues:
            --  [1] AnimationLibrary_m (ref)
            --  [2] arg10 (copy)
            --  [3] v25 (copy)
            --  [4] v31 (copy)

            local Length_1 = AnimationLibrary_m.Info[arg10.ViewModel.Info.Animations[v25 .. "Start"]].Length
            local Length_2 = AnimationLibrary_m.Info[arg10.ViewModel.Info.Animations[v25 .. "Segment"]].Length
            local Length_3 = AnimationLibrary_m.Info[arg10.ViewModel.Info.Animations[v25 .. "Finish"]].Length
            arg10.ViewModel:PlayAnimation(
                v25 .. "Start",
                Length_1,
                if arg10.ViewModel.ShouldPlayReloadAnimationInstantly then 0 else 0.1
            )
            wait(Length_1)

            for _ = 1, v31 do
                arg10.ViewModel:PlayAnimation(v25 .. "Segment", Length_2, 0)
                wait(Length_2)
            end

            if arg10.ViewModel.Info.Animations[v25 .. "SegmentFinal"] then
                arg10.ViewModel:PlayAnimation(v25 .. "SegmentFinal", Length_2, 0)
                wait(
                    AnimationLibrary_m.Info[arg10.ViewModel.Info.Animations[v25 .. "SegmentFinal"]].Length
                )
            end

            arg10.ViewModel:PlayAnimation(v25 .. "Finish", Length_3, 0)
        end))
    else
        return false
    end

    return true, "StartReloading", arg10:ToEnum(v20), arg10:ToEnum(v25)
end

function t.StartAiming(arg15, arg16) -- line: 328
    if
        not arg16
        and (arg15:Get("IsAiming") or tick() < arg15._reload_cooldown or arg15:IsEquipping())
    then
        return false
    end

    arg15:SetReplicate("IsAiming", true)
    arg15.StopSprinting:Fire()
    arg15.ViewModel:SetAiming(true)
    arg15:SetReplicate("FOVOffset", arg15.Info.AimFOVOffset)
    arg15:_StartAimAssist()

    if arg15.ClientFighter:Get("IsSpectating") then
        arg15:CreateSound(
            "rbxassetid://13949557885",
            1,
            1,
            true,
            5
        )

        if arg15.ViewModel.PlayAimSound then
            arg15.ViewModel:PlayAimSound(true)
        end
    end

    if arg15.Info.AimScopePercent then
        arg15.ViewModel:StopAnimation(arg15.ViewModel.Animator:GetInspectAnimationKey())
        arg15.ViewModel:StopAnimation(arg15.ViewModel.Animator:GetRareInspectAnimationKey())
    end

    return true, "StartAiming"
end

function t.FinishAiming(arg17, _) -- line: 356
    if not arg17:Get("IsAiming") then
        return false
    end

    arg17:_FinishAiming()
    arg17.AttemptToSprintAgain:Fire()

    if arg17.ClientFighter:Get("IsSpectating") then
        arg17:CreateSound(
            "rbxassetid://13949557844",
            1,
            1,
            true,
            5
        )

        if arg17.ViewModel.PlayAimSound then
            arg17.ViewModel:PlayAimSound(false)
        end
    end

    return true, "FinishAiming"
end

function t.StartSprinting(arg19, _) -- line: 375
    arg19:SimulateInputFromGameplayMechanic("FinishAiming", true)

    return false
end

function t.Equip(arg21, ...) -- line: 381
    -- upvalues:
    --  [1] ClientItem_m (copy)

    ClientItem_m.Equip(arg21, ...)
    arg21._is_revolver_quick_shooting = nil
    arg21._shoot_cooldown = if arg21._shoot_cooldown and arg21._shoot_cooldown >= math.huge then 0 else arg21._shoot_cooldown
    arg21:_ResetReloadState()
end

function t.Unequip(arg22, ...) -- line: 389
    -- upvalues:
    --  [1] ClientItem_m (copy)

    arg22._is_revolver_quick_shooting = nil
    arg22._shoot_cooldown = if arg22._shoot_cooldown and arg22._shoot_cooldown >= math.huge then 0 else arg22._shoot_cooldown
    arg22:_ResetReloadState()
    arg22:_FinishAiming()
    ClientItem_m.Unequip(arg22, ...)
end

function t.Update(arg23, ...) -- line: 398
    -- upvalues:
    --  [1] ClientItem_m (copy)

    ClientItem_m.Update(arg23, ...)

    if arg23.ItemInterface then
        local v46 = arg23.Info.AimScopePercent

        if v46 then
            v46 = if arg23.ViewModel.CurrentAimValue >= arg23.Info.AimScopePercent then arg23.ClientFighter:IsActuallyFirstPerson() else false
        end

        if not arg23.ItemInterface:IsScopeActive() and v46 then
            arg23.ItemInterface:SetScopeActive(true)

            return
        end

        if arg23.ItemInterface:IsScopeActive() and not v46 then
            arg23.ItemInterface:SetScopeActive(false)
        end
    end
end

function t.ReplicateFromServer(arg24, arg25, ...) -- line: 413
    -- upvalues:
    --  [1] ClientItem_m (copy)

    if arg25 == "ShootEffect" then
        if not arg24:IsRendered() then
            return
        end

        arg24:_ShootEffect(...)

        return
    elseif arg25 == "ProjectileEffect" then
        if not arg24:IsRendered() then
            return
        end

        arg24:_ProjectileEffect(...)

        return
    elseif arg25 == "ResetReloadState" then
        if not arg24:IsRendered() then
            return
        end

        arg24:_ResetReloadState()

        return
    else
        ClientItem_m.ReplicateFromServer(arg24, arg25, ...)

        return
    end
end

function t.Destroy(arg26) -- line: 437
    -- upvalues:
    --  [1] ClientItem_m (copy)

    arg26.Shot:Destroy()
    arg26.ProjectileShot:Destroy()
    arg26:_ResetReloadState()
    arg26:_FinishAiming()

    for _, val in pairs(arg26._projectile_part_to_model) do
        val:Destroy()
    end

    ClientItem_m.Destroy(arg26)
end

function t._StartCameraDisplacementLoop(arg27) -- line: 455
    -- upvalues:
    --  [1] RunService (copy)
    --  [2] CameraController_m (copy)

    if
        arg27._camera_displacement_loop_active
        or arg27._camera_displacement_spring.Value.Magnitude < 0.001
    then
        return
    end

    task.spawn(function() -- line: 460
        -- upvalues:
        --  [1] arg27 (copy)
        --  [2] RunService (ref)
        --  [3] CameraController_m (ref)

        arg27._camera_displacement_loop_active = true

        while true do
            local v47 = RunService.RenderStepped:Wait()

            if
                arg27._destroyed
                or arg27._camera_displacement_spring.Value.Magnitude < 0.001
                or not arg27.ClientFighter:Get("IsSpectating")
            then
                break
            end

            CameraController_m:ApplyRotationDelta(
                arg27._camera_displacement_spring.Value * v47,
                true
            )
        end

        arg27._camera_displacement_loop_active = false
    end)
end

function t._FinishAiming(arg28) -- line: 477
    arg28:SetReplicate("IsAiming", false)
    arg28.ViewModel:SetAiming(false)
    arg28:SetReplicate("FOVOffset", 0)
    arg28:_FinishAimAssist()
end

function t._ProjectileEffect(arg29, arg30, arg31) -- line: 484
    -- upvalues:
    --  [1] Projectiles (copy)
    --  [2] BetterDebris_m (copy)
    --  [3] WrapController_m (copy)
    --  [4] Spring_m (copy)
    --  [5] RunService (copy)
    --  [6] PlayerDataController_m (copy)
    --  [7] Utility_m (copy)

    if not arg30 then
        return
    end

    arg30.Transparency = 1

    local _ = function(arg32) --[[ get_setting ]] -- line: 491
        -- upvalues:
        --  [1] arg31 (copy)
        --  [2] arg29 (copy)

        return if not arg31 then arg29.Info[arg32] else if arg31[arg32] == nil then arg29.Info[arg32] else arg31[arg32]
    end

    local v49 = arg31

    if v49 then
        v49 = arg31.ProjectileNameOverride
    end

    local v50 = v49 and Projectiles:FindFirstChild(v49) or Projectiles:FindFirstChild(
        arg29.ViewModel.Name
    ) or Projectiles[arg29.Name]
    v49 = v50:Clone()
    v49.Parent = workspace
    arg29._projectile_part_to_model[arg30] = v49
    BetterDebris_m:AddItem(v49, 60)
    WrapController_m:ApplyWrap(
        WrapController_m:RecordOriginalWrapProperties(v49),
        arg29:GetWrap(),
        true
    )
    arg30.Destroying:Connect(function() -- line: 503
        -- upvalues:
        --  [1] arg29 (copy)
        --  [2] arg30 (copy)

        arg29._projectile_part_to_model[arg30] = nil
    end)

    for _, val_1 in pairs(v49:GetChildren()) do
        val_1.CanCollide = false
        val_1.CanTouch = false
        val_1.CanQuery = false
        val_1.Massless = true
        val_1.Anchored = true
    end

    arg29.ProjectileShot:Fire(arg30, v49)
    local ProjectileLogicOptimized = if arg31 and arg31.ProjectileLogicOptimized ~= nil then arg31.ProjectileLogicOptimized else arg29.Info.ProjectileLogicOptimized
    local v57

    if ProjectileLogicOptimized then
        v50 = CFrame.Angles(
            math.random() * 3.141592653589793 * 2,
            math.random() * 3.141592653589793 * 2,
            math.random() * 3.141592653589793 * 2
        )
        v57 = Spring_m.new(arg30.Position, 1, 100)

        while true do
            if arg29._destroyed or not arg30:IsDescendantOf(workspace) then
                break
            end

            v57.Target = arg30.Position
            v49:PivotTo(CFrame.new(v57.Value) * arg30.CFrame.Rotation * v50)
            RunService.RenderStepped:Wait()
        end

        v49:Destroy()

        return
    end

    v57 = 0.5

    for _, val_2 in pairs(v49:GetDescendants()) do
        if val_2:IsA("Trail") then
            v57 = math.max(v57, val_2.Lifetime)
        elseif val_2:IsA("ParticleEmitter") then
            v57 = math.max(v57, val_2.Lifetime.Max)
        end
    end

    local ProjectileVisualSpinEnabled = if not arg31 then arg29.Info.ProjectileVisualSpinEnabled else if arg31.ProjectileVisualSpinEnabled == nil then arg29.Info.ProjectileVisualSpinEnabled else arg31.ProjectileVisualSpinEnabled
    local v61 = if not arg31 then arg29.Info.ProjectileType else if arg31.ProjectileType == nil then arg29.Info.ProjectileType else arg31.ProjectileType
    local v62

    if v61 then
        v61 = if not arg31 then arg29.Info.ProjectileType else if arg31.ProjectileType == nil then arg29.Info.ProjectileType else arg31.ProjectileType

        if v61 ~= "RaycastProjectile" then
            v62 = false
            v61 = if not arg31 then arg29.Info.ProjectileType else if arg31.ProjectileType == nil then arg29.Info.ProjectileType else arg31.ProjectileType

            if v61 == "PhysicalProjectile" then
                v61 = if not arg31 then arg29.Info.ProjectilePhysicalClientSided else if arg31.ProjectilePhysicalClientSided == nil then arg29.Info.ProjectilePhysicalClientSided else arg31.ProjectilePhysicalClientSided
                v62 = not v61

                if v62 then
                    v62 = arg29.ClientFighter:IsActuallyFirstPerson()

                    if v62 then
                        v62 = PlayerDataController_m:GetSetting("Projectile Smoothing")
                    end
                end
            end
        else
            v62 = arg29.ClientFighter:IsActuallyFirstPerson()

            if v62 then
                v62 = PlayerDataController_m:GetSetting("Projectile Smoothing")
            end
        end
    else
        v62 = arg29.ClientFighter:IsActuallyFirstPerson()

        if v62 then
            v62 = PlayerDataController_m:GetSetting("Projectile Smoothing")
        end
    end

    local New_1 = Spring_m.new
    local v64 = New_1(
        arg30.Position + (v62 and -arg30.Velocity.Unit * 200 or Vector3.new(0, 0, 0)),
        1,
        40
    )
    v62 = CFrame.Angles(0, 0, math.random() * 3.141592653589793 * 2)
    local v65 = Vector3.new(0, 0, 0)
    local v66 = Vector3.new(0, 0, 0)
    local now_10 = tick()
    local v67 = tick() + v57
    local v68 = false
    local v69 = 0
    local v70 = 0

    while true do
        if arg29._destroyed or not (v67 > tick()) then
            break
        end

        if arg30:IsDescendantOf(workspace) then
            v67 = tick() + v57
            v64.Target = arg30.Position
        else
            v64.Target += v65 * v70

            if not v68 then
                v68 = true

                for _, val_3 in pairs(v49:GetDescendants()) do
                    if val_3:IsA("BasePart") or val_3:IsA("Texture") or val_3:IsA("Decal") then
                        val_3.LocalTransparencyModifier = 1
                    elseif val_3:IsA("Beam") or val_3:IsA("ParticleEmitter") then
                        val_3.Enabled = false
                    elseif val_3:IsA("Light") then
                        local Brightness = val_3.Brightness
                        task.spawn(
                            Utility_m.RenderstepForLoop,
                            Utility_m,
                            0,
                            100,
                            1,
                            function(arg33) -- line: 582
                                -- upvalues:
                                --  [1] val_3 (copy)
                                --  [2] Brightness (copy)

                                val_3.Brightness = Brightness * (1 - arg33 / 100)
                            end
                        )
                    end
                end
            end
        end

        v69 += arg30.Velocity.Magnitude * v70 * 0.25
        v64.Speed = math.clamp(tick() - now_10, 0.01, 1) * 60 + 40
        local v73 = arg30.Velocity.Magnitude > 0.01 and arg30.Velocity or v66
        local v74 = if not ProjectileVisualSpinEnabled then CFrame.identity else CFrame.Angles(
            -v69,
            0,
            0
        )

        if v73.Magnitude > 0.01 and arg29.Name ~= "Flare Gun" then
            v49:PivotTo(CFrame.new(v64.Position, v64.Position + v73) * v62 * v74)
        else
            v49:PivotTo(CFrame.new(v64.Position) * v62 * arg30.CFrame.Rotation * v74)
        end

        v66 = v73
        v65 = v66.Magnitude > v65.Magnitude and v66 or v65
        v70 = RunService.RenderStepped:Wait()
    end

    v49:SetAttribute("Destroying", true)
    BetterDebris_m:AddItem(v49, v57)
end

function t._ResetReloadState(arg34) -- line: 612
    arg34._reload_cooldown = 0

    for _, val_4 in pairs(arg34._reload_threads) do
        pcall(task.cancel, val_4)
    end

    arg34:StopCooldownEffect("Reload")
    arg34.ViewModel:StopAnimation("Reload")
    arg34.ViewModel:StopAnimation("EmptyReload")
    arg34.ViewModel:StopAnimation("ReloadStart")
    arg34.ViewModel:StopAnimation("ReloadSegment")
    arg34.ViewModel:StopAnimation("ReloadFinish")
    arg34.ViewModel:StopAnimation("EmptyReloadStart")
    arg34.ViewModel:StopAnimation("EmptyReloadSegment")
    arg34.ViewModel:StopAnimation("EmptyReloadFinish")

    for index_2 = 2, arg34.Info.NumReloadFiles do
        arg34.ViewModel:StopAnimation("Reload" .. index_2)
    end
end

function t._LocalTracers(arg35, arg36, arg37) -- line: 635
    -- upvalues:
    --  [1] GameplayUtility_m (copy)
    --  [2] CONSTANTS_m (copy)

    local v79 = arg35.ClientFighter:GetEntityLookupParams()
    local v80 = arg35.ClientFighter:Get("EnvironmentID")
    local v81 = arg35.ClientFighter:IsCrouching()
    local v82 = arg35.ClientFighter:GetRaycastWhitelist(true)
    local t_3 = {}

    for index_3 = 1, arg35.Info.ShootPellets do
        local v84 = (arg37 and arg35.Info.QuickShotSpread or arg35.Info.ShootSpread) + math.min(
            arg35.Info.ShootSpreadPerVelocityLimit,
            arg35.ClientFighter.Entity.RootPart.Velocity.Magnitude * arg35.Info.ShootSpreadPerVelocityUnit
        )
        local v86 = GameplayUtility_m:GetSpread(
            v84,
            arg35.Info.AimSpreadMultiplier,
            arg36,
            v81,
            index_3,
            arg35.Info.ShootPellets,
            arg35.Info.ShootSpreadConsistent
        )
        local v88 = arg35.ClientFighter:GetCameraData(v82, v86, true)
        local v89 = v88[utf8.char(0)]
        local v90 = v88[utf8.char(1)]
        local v91 = v88[utf8.char(2)]
        local v92 = v88[utf8.char(3)]
        local v93 = v91 and (v91.CFrame * v92).Position or (v90 * v86 * CFrame.new(
            0,
            0,
            -CONSTANTS_m.MAX_RAYCAST_DISTANCE
        )).Position
        v92 = v89.Position
        local v95 = (v93 - v92).Unit

        for index_4 = 0, arg35.Info.RaycastBounceCount do
            if v95 ~= v95 then
                table.insert(t_3, { Position = v92 + v95 * CONSTANTS_m.MAX_RAYCAST_DISTANCE })
                break
            end

            local _, v97 = GameplayUtility_m:GetEntitiesFromRaycast(
                v80,
                v79,
                v92,
                v95,
                CONSTANTS_m.MAX_RAYCAST_DISTANCE,
                nil,
                arg35.Info.RaycastPierceCount
            )
            local t_5 = { Position = v97.Position }

            if index_4 > 0 then
                t_5.LastRaycastResult = t_3[#t_3]
                t_5.StartPosition = t_5.LastRaycastResult.Position
            end

            table.insert(t_3, t_5)

            if not v97.Normal then
                break
            end

            v92 = v97.Position
            v95 -= 2 * v95:Dot(v97.Normal) * v97.Normal
            v95 = GameplayUtility_m:GetRaycastRedirection(
                v80,
                v79,
                v95,
                v92,
                arg35.Info.RaycastBounceRedirectionAngle
            )
        end
    end

    table.insert(arg35._local_tracers, t_3)
    task.delay(1, function() -- line: 691
        -- upvalues:
        --  [1] arg35 (copy)
        --  [2] t_3 (copy)

        local index_5 = table.find(arg35._local_tracers, t_3)

        if index_5 then
            table.remove(arg35._local_tracers, index_5)
        end
    end)
    arg35:_Tracers({ RaycastResults = t_3, IsEnemy = false, IsLocal = true })
end

function t._CorrectLocalTracers(arg38, arg39) -- line: 709
    local removedValue = table.remove(arg38._local_tracers, 1)

    if not removedValue then
        return
    end

    for key_5, val_5 in pairs(arg39) do
        for key_6, val_6 in pairs(val_5) do
            removedValue[key_5][key_6] = val_6
        end

        removedValue[key_5].StartPosition = removedValue[key_5].CurrentTracerPosition
    end
end

function t._Tracers(arg40, arg41, arg42) -- line: 726
    -- upvalues:
    --  [1] TracerEffect_m (copy)

    local t_7 = {}
    local v99 = arg40.ViewModel.GetFriendlyTracerColor

    if v99 then
        v99 = arg40.ViewModel:GetFriendlyTracerColor()
    end

    t_7.FriendlyTracerColor = v99
    t_7.ActuallyFirstPerson = arg40.ClientFighter:IsActuallyFirstPerson()
    t_7.MuzzlePosition = arg40.ViewModel:GetMuzzlePosition()
    local v100, v101, v102 = TracerEffect_m:VerifyTracerData(arg41, arg42, t_7)

    if arg40.ViewModel.CustomTracers then
        return arg40.ViewModel:CustomTracers(v100, v101, v102)
    end

    TracerEffect_m:Play(v100, v101, v102)
end

function t._ShootEffect(arg43, arg44) -- line: 742
    -- upvalues:
    --  [1] Players (copy)

    local t_8 = {}
    local v103

    for key_7, val_7 in pairs(arg44) do
        v103 = utf8.codepoint(key_7) + 1
        local t_9 = {
            Position = val_7[utf8.char(0)] or nil,
            Instance = val_7[utf8.char(1)] or nil,
            Normal = val_7[utf8.char(2)] or nil
        }
        local v104 = val_7[utf8.char(3)] and utf8.codepoint(val_7[utf8.char(3)]) + 1 or nil
        t_9.LastRaycastIndex = v104
        t_8[v103] = t_9
    end

    for _, val_8 in pairs(t_8) do
        v103 = val_8.LastRaycastIndex and t_8[val_8.LastRaycastIndex] or nil
        val_8.LastRaycastResult = v103
        val_8.LastRaycastIndex = nil
        local v105 = val_8.LastRaycastResult and val_8.LastRaycastResult.Position or nil
        val_8.StartPosition = v105
    end

    if not (arg43.ClientFighter.IsLocalPlayer and #arg43._local_tracers > 0) then
        arg43:_Tracers(
            {
                RaycastResults = t_8,
                IsEnemy = if Players.LocalPlayer:GetAttribute("TeamID") == arg43.ClientFighter.Player:GetAttribute(
                    "TeamID"
                ) then false else true,
                IsLocal = arg43.ClientFighter.IsLocalPlayer
            }
        )
    end

    arg43:_ImpactMarkers(t_8)
end

function t._CheckReload(arg45) -- line: 775
    if arg45:Get("Ammo") <= 0 then
        if arg45.Name == "Daggers" then
            arg45._reload_delay = tick() + 0.2
            wait(0.2)
        end

        arg45:SimulateInputFromGameplayMechanic("StartReloading")
    end
end

function t._Init(arg46) -- line: 786
    arg46:GetDataChangedSignal("Ammo"):Connect(function() -- line: 787
        -- upvalues:
        --  [1] arg46 (copy)

        arg46._shot_but_ammo_hasnt_updated = false
        arg46:_CheckReload()
    end)
    arg46:GetDataChangedSignal("AmmoReserve"):Connect(function() -- line: 792
        -- upvalues:
        --  [1] arg46 (copy)

        arg46:_CheckReload()
    end)
    arg46.ViewModel.AnimationPlayed:Connect(function(animationTrack: AnimationTrack) -- line: 796
        -- upvalues:
        --  [1] arg46 (copy)

        if if animationTrack == arg46.ViewModel.Animator:GetInspectAnimationKey() then arg46._last_shoot_animation_name else not (animationTrack ~= arg46.ViewModel.Animator:GetRareInspectAnimationKey()) and arg46._last_shoot_animation_name then
            arg46.ViewModel:StopAnimation(arg46._last_shoot_animation_name, 0)
        end
    end)
    table.insert(arg46._connections, arg46.ClientFighter.Interrupted:Connect(function() -- line: 804
        -- upvalues:
        --  [1] arg46 (copy)

        arg46:_ResetReloadState()
        arg46:SimulateInputFromGameplayMechanic("FinishAiming", true)
    end))
    arg46:ChangeShootAnimationNamePrefix("Shoot")
end

return t
