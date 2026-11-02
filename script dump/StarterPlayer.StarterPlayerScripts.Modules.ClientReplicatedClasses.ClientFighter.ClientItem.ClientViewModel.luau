local ReplicatedStorage = game:GetService("ReplicatedStorage")
local _ = game:GetService("UserInputService")
local _ = game:GetService("ContentProvider")
local Players = game:GetService("Players")
local CONSTANTS_m = require(ReplicatedStorage.Modules.CONSTANTS)
local CosmeticLibrary_m = require(ReplicatedStorage.Modules.CosmeticLibrary)
local ReplicatedClass_m = require(ReplicatedStorage.Modules.ReplicatedClass)
local SoundLibrary_m = require(ReplicatedStorage.Modules.SoundLibrary)
local ItemLibrary_m = require(ReplicatedStorage.Modules.ItemLibrary)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local Spring_m = require(ReplicatedStorage.Modules.Spring)
local Signal_m = require(ReplicatedStorage.Modules.Signal)
local PlayerDataController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.PlayerDataController
)
local CameraController_m = require(Players.LocalPlayer.PlayerScripts.Controllers.CameraController)
local WrapController_m = require(Players.LocalPlayer.PlayerScripts.Controllers.WrapController)
local Charm_m = require(Players.LocalPlayer.PlayerScripts.Modules.Charm)
local ViewModelAnimator_m = require(script:WaitForChild("ViewModelAnimator"))
local ViewModels = workspace:WaitForChild("ViewModels")
local FirstPerson = ViewModels:WaitForChild("FirstPerson")
local ViewModels_1 = ReplicatedStorage.Assets:WaitForChild("Temp"):WaitForChild("ViewModels")
local ScopeGlareGui1 = Players.LocalPlayer.PlayerScripts.UserInterface.ScopeGlareGui1
local ScopeGlareGui2 = Players.LocalPlayer.PlayerScripts.UserInterface.ScopeGlareGui2
local MuzzleFlashes = Players.LocalPlayer.PlayerScripts.Assets.Misc.MuzzleFlashes
local ViewModelRoot = Players.LocalPlayer.PlayerScripts.Assets.Misc.ViewModelRoot
local ViewModels_2 = Players.LocalPlayer.PlayerScripts.Assets.ViewModels
local Charms = Players.LocalPlayer.PlayerScripts.Modules.Charms
local color = Color3.fromRGB(0, 0, 0)
local t = {
    Vector3.new(0.5, 0.5, 0.5),
    Vector3.new(-0.5, 0.5, 0.5),
    Vector3.new(-0.5, 0.5, -0.5),
    Vector3.new(0.5, 0.5, -0.5),
    Vector3.new(0.5, -0.5, 0.5),
    Vector3.new(-0.5, -0.5, 0.5),
    Vector3.new(-0.5, -0.5, -0.5),
    Vector3.new(0.5, -0.5, -0.5)
}
local t_1 = setmetatable({}, ReplicatedClass_m)
t_1.__index = t_1

function t_1.new(arg1, arg2) -- line: 50
    -- upvalues:
    --  [1] ReplicatedClass_m (copy)
    --  [2] t_1 (copy)
    --  [3] Signal_m (copy)
    --  [4] ItemLibrary_m (copy)
    --  [5] ViewModelRoot (copy)
    --  [6] Utility_m (copy)
    --  [7] ViewModels_2 (copy)
    --  [8] ViewModelAnimator_m (copy)
    --  [9] Spring_m (copy)

    local t_2 = setmetatable(ReplicatedClass_m.new(arg1), t_1)
    t_2.AnimationPlayed = Signal_m.new()
    t_2.AnimationStopped = Signal_m.new()
    t_2.Equipped = Signal_m.new()
    t_2.Unequipped = Signal_m.new()
    t_2.ClientItem = arg2
    t_2.Name = t_2:Get("Name")
    t_2.Info = ItemLibrary_m.ViewModels[t_2.Name]
    t_2.Model = ViewModelRoot:Clone()
    t_2.ItemModel = Utility_m:LookThrough(ViewModels_2, t_2.Name):Clone()
    t_2.Animator = ViewModelAnimator_m.new(t_2)
    t_2.Charm = nil
    t_2.ShouldPlayReloadAnimationInstantly = nil
    t_2.RightArmIKControlDisabled = nil
    t_2.LeftArmIKControlDisabled = nil
    t_2.CurrentBobbingValue = Vector2.zero
    t_2.CurrentRecoilValue = Vector3.new(0, 0, 0)
    t_2.CurrentSwayValue = Vector2.zero
    t_2.CurrentJumpValue = 0
    t_2.CurrentAimValue = 0
    t_2.CurrentInspectValue = 0
    t_2.CurrentLandingValue = 0
    t_2._serial = arg1
    t_2._destroyed = false
    t_2._connections = {}
    t_2._preloaded_sounds = {}
    t_2._last_hitmarker_sounds = {}
    t_2._left_arm = t_2.Model.LeftArm
    t_2._left_arm_shirt_texture = t_2._left_arm.ShirtTexture
    t_2._right_arm = t_2.Model.RightArm
    t_2._right_arm_shirt_texture = t_2._right_arm.ShirtTexture
    t_2._shirt_id = nil
    t_2._left_arm_color = nil
    t_2._right_arm_color = nil
    t_2._body_model = nil
    t_2._original_scale = t_2.ItemModel:GetScale()
    t_2._equip_spring = Spring_m.new(0, 0.625, 12.5)
    t_2._aim_spring = Spring_m.new(0, 1, 30)
    t_2._crouching_spring = Spring_m.new(0, 0.875, 17.5)
    t_2._sliding_spring = Spring_m.new(0, 0.5, 12.5)
    t_2._sprinting_spring = Spring_m.new(
        0,
        0.75,
        if t_2.Info.PlayAnimationsInstantly then 100 else 15
    )
    t_2._bobbing_speed_spring = Spring_m.new(0, 1, 20)
    t_2._bobbing_value_spring = Spring_m.new(Vector2.zero, 0.5, 12.5)
    t_2._sway_spring = Spring_m.new(Vector2.zero, 0.5, 12.5)
    t_2._landing_spring = Spring_m.new(0, 0.75, 10)
    t_2._jump_spring = Spring_m.new(0, 0.5, 15)
    t_2._tilt_spring = Spring_m.new(Vector2.zero, 0.5, 15)
    t_2._recoil_spring = Spring_m.new(Vector3.new(0, 0, 0), 0.875, 100)
    t_2._unrecoil_spring = Spring_m.new(Vector3.new(0, 0, 0), 0.375, 25)
    t_2._head_raycast_spring = Spring_m.new(0, 1, 50)
    t_2._raycast_tilt_spring = Spring_m.new(0, 1, 50)
    t_2._impulse_position_spring = Spring_m.new(Vector3.new(0, 0, 0), 0.25, 20)
    t_2._inspect_spring = Spring_m.new(0, 1, 20)
    t_2._instant_set_inspect_spring = true
    t_2._render_cooldown = 0
    t_2._is_equipped = false
    t_2._root_part_offset_inverse = t_2.Info.RootPartOffset:Inverse()
    t_2._root_part_offset_override = nil
    t_2._root_part_offset_override_inverse = nil
    t_2._custom_sprinting_enabled = 0
    t_2._bobbing_tick = 0
    t_2._aim_position_attachment = nil
    t_2._aim_lookat_attachment = nil
    t_2._center_attachment = nil
    t_2._muzzle_attachments = {}
    t_2._charm_attachment_model = nil
    t_2._charm_pivot_attachment = nil
    t_2._charm_sub_model = nil
    t_2._scope_glare_attachment = nil
    t_2._scope_glare_gui1 = nil
    t_2._scope_glare_gui2 = nil
    t_2._was_first_person = nil
    t_2._local_transparency_modifiers = {}
    t_2._local_transparency_modifier_update = {}
    t_2._hidden_submodels = {}
    t_2._animation_context_submodels = {}
    t_2._arm_submodels = {}
    t_2._original_wrap_properties = nil
    t_2._original_object_transparencies = {}
    t_2._right_arm_wrapped_part = nil
    t_2._left_arm_wrapped_part = nil
    t_2._wrapped_only_objects = {}
    t_2._can_wrap_left_arm = false
    t_2._can_wrap_right_arm = false
    t_2._submodels_behind_head_values = {}
    t_2._submodel_boundingbox_attachments = {}
    t_2:_Init()

    return t_2
end

function t_1.GetCameraOffset(arg3) -- line: 159
    -- upvalues:
    --  [1] Utility_m (copy)

    if Utility_m:AngleBetweenVectors(
        arg3.Model.Camera.CFrame.LookVector,
        arg3.Model.HumanoidRootPart.CFrame.LookVector
    ) > 1.5707963267948966 then
        return CFrame.identity
    end

    return arg3.Model.HumanoidRootPart.CFrame:ToObjectSpace(arg3.Model.Camera.CFrame)
end

function t_1.GetImage(arg4) -- line: 168
    return arg4.Info.Image
end

function t_1.IsEquipped(arg5) -- line: 172
    return arg5._is_equipped
end

function t_1.IsRenderingDisabled(arg6) -- line: 176
    local v4 = if not (tick() < arg6._render_cooldown) then arg6.Animator:IsRenderingDisabled() or arg6.ClientItem.ClientFighter:Get(
        "IsHiddenByEmotes"
    ) or arg6.ClientItem.ClientFighter:Get("IsHiddenByCutscene") or arg6.ClientItem.ClientFighter.Entity and arg6.ClientItem.ClientFighter.Entity:IsEmoting() else true

    return v4
end

function t_1.IsAimingAnimationEnabled(arg7) -- line: 184
    -- upvalues:
    --  [1] PlayerDataController_m (copy)

    local v5 = arg7._aim_position_attachment

    if v5 then
        v5 = arg7._aim_lookat_attachment

        if v5 then
            v5 = arg7.ClientItem.Info.AimScopePercent or PlayerDataController_m:GetSetting(
                "ViewModel Aiming"
            )
        end
    end

    return v5
end

function t_1.AreAnimationsPlaying(arg8, ...) -- line: 188
    return arg8.Animator:AreAnimationsPlaying(...)
end

function t_1.IsAnimationPlaying(arg9, ...) -- line: 192
    return arg9.Animator:IsAnimationPlaying(...)
end

function t_1.GetAnimationTrack(arg10, ...) -- line: 196
    return arg10.Animator:GetAnimationTrack(...)
end

function t_1.GetAnimationKeys(arg11, ...) -- line: 200
    return arg11.Animator:GetAnimationKeys(...)
end

function t_1.Inspect(arg12, ...) -- line: 204
    return arg12.Animator:Inspect(...)
end

function t_1.StopInspecting(arg13, ...) -- line: 208
    return arg13.Animator:StopInspecting(...)
end

function t_1.PlayAnimation(arg14, ...) -- line: 212
    return arg14.Animator:PlayAnimation(...)
end

function t_1.StopAnimation(arg15, ...) -- line: 216
    return arg15.Animator:StopAnimation(...)
end

function t_1.ChangeEquipAnimation(arg16, ...) -- line: 220
    return arg16.Animator:ChangeEquipAnimation(...)
end

function t_1.ChangeIdleAnimation(arg17, ...) -- line: 224
    return arg17.Animator:ChangeIdleAnimation(...)
end

function t_1.ChangeSprintAnimation(arg18, ...) -- line: 228
    return arg18.Animator:ChangeSprintAnimation(...)
end

function t_1.ChangeInspectAnimation(arg19, ...) -- line: 232
    return arg19.Animator:ChangeInspectAnimation(...)
end

function t_1.GetMuzzlePosition(arg20) -- line: 236
    local v6 = if arg20:IsRenderingDisabled() then arg20:_GetDefaultMuzzlePosition() else nil

    if not v6 and #arg20._muzzle_attachments > 0 then
        local v7 = Vector3.new(0, 0, 0)

        for _, val in pairs(arg20._muzzle_attachments) do
            v7 += val.WorldPosition
        end

        return v7 / #arg20._muzzle_attachments
    end

    if not v6 and arg20._body_model and arg20._body_model.PrimaryPart then
        return arg20._body_model.PrimaryPart.Position
    end

    return v6 or arg20:_GetDefaultMuzzlePosition()
end

function t_1.GetMuzzleAttachment(arg21) -- line: 260
    return arg21._muzzle_attachments[1]
end

function t_1.GetWrap(arg22) -- line: 264
    -- upvalues:
    --  [1] PlayerDataController_m (copy)

    local v9

    if not arg22.ClientItem.ClientFighter:Get("IsSpectating") then
        v9 = not PlayerDataController_m:GetSetting("Wraps Disabled")

        if v9 then
            v9 = arg22:Get("Wrap")
        end
    else
        v9 = arg22:Get("Wrap")
    end

    return v9
end

function t_1.SetParent(arg23, arg24) -- line: 268
    arg23.Model.Parent = arg24
    arg23.Animator:LoadAnimations()
end

function t_1.SetArmsData(arg25, arg26, arg27, arg28) -- line: 274
    -- upvalues:
    --  [1] color (copy)

    assert(
        not arg26 or (if typeof(arg26) ~= "string" then false else true),
        "Argument 1 invalid, expected a string or nil, got " .. tostring(arg26)
    )
    arg25._shirt_id = arg26 or ""
    arg25._left_arm_color = arg27 or color
    arg25._right_arm_color = arg28 or color
    arg25:_UpdateArms()
end

function t_1.SetAiming(arg29, arg30) -- line: 284
    assert(
        if typeof(arg30) ~= "boolean" then false else true,
        "Argument 1 invalid, expected a boolean"
    )
    arg29._aim_spring.Target = if arg30 then 1 else 0
    local AimSpring_1 = arg29._aim_spring
    local v13 = arg30 and arg29.ClientItem.Info.AimSpeed or 1
    AimSpring_1.Speed = 30 * v13

    if arg30 then
        arg29:StopInspecting()
    end
end

function t_1.SetCustomSprintingEnabled(arg31, arg32, arg33) -- line: 295
    if arg32 then
        arg31._custom_sprinting_enabled = tick() + arg32
    end

    if arg33 then
        arg31._sprinting_spring.Value = 0
    end
end

function t_1.SetCFrame(arg34, arg35) -- line: 306
    arg34.Model.PrimaryPart.CFrame = arg35
end

function t_1.CreateSound(arg36, ...) -- line: 310
    return arg36.ClientItem:CreateSound(...)
end

function t_1.CreateSpectatorSound(arg37, ...) -- line: 314
    return arg37.ClientItem:CreateSpectatorSound(...)
end

function t_1.OverrideRootPartOffset(arg38, arg39) -- line: 318
    arg38._root_part_offset_override = arg39
    local v14 = arg38._root_part_offset_override_inverse

    if v14 then
        v14 = arg38._root_part_offset_override:Inverse()
    end

    arg38._root_part_offset_override_inverse = v14
end

function t_1.HideSubModel(arg40, arg41, arg42) -- line: 323
    arg40._hidden_submodels[arg41] = (arg40._hidden_submodels[arg41] or 0) + 1
    arg40:_UpdateSubModelVisibility()
    local v15 = arg40._hidden_submodels[arg41]

    local function callback() -- line: 329
        -- upvalues:
        --  [1] arg40 (copy)
        --  [2] arg41 (copy)
        --  [3] v15 (copy)

        if arg40._hidden_submodels[arg41] ~= v15 then
            return
        end

        arg40._hidden_submodels[arg41] = false
        arg40:_UpdateSubModelVisibility()
    end

    if arg42 > 0 then
        if arg42 < math.huge then
            task.delay(arg42, callback)

            return
        end
    else
        task.spawn(callback)
    end
end

function t_1.Impulse(
    arg43,
    arg44,
    arg45,
    arg46,
    arg47
) -- line: 347
    local ImpulsePositionSpring = arg43._impulse_position_spring
    local v16 = arg47 and arg43._impulse_position_spring.Target or arg43._impulse_position_spring.Position
    ImpulsePositionSpring.Position = v16
    arg43._impulse_position_spring.Velocity = arg44
    v16 = arg45
    local ImpulsePositionSpring_1 = arg43._impulse_position_spring

    if not v16 then
        v16 = arg43._impulse_position_spring.Damper
    end

    ImpulsePositionSpring_1.Damper = v16
    local ImpulsePositionSpring_2 = arg43._impulse_position_spring
    v16 = arg46 or arg43._impulse_position_spring.Speed
    ImpulsePositionSpring_2.Speed = v16
end

function t_1.ApplyRecoil(arg48, arg49) -- line: 354
    assert(
        if typeof(arg49) ~= "Vector3" then false else true,
        "Argument 1 invalid, expected a Vector3"
    )
    local RecoilSpring = arg48._recoil_spring
    RecoilSpring.Target += arg49
    local UnrecoilSpring = arg48._unrecoil_spring
    UnrecoilSpring.Target += arg49
end

function t_1.Equip(arg50, arg51) -- line: 361
    -- upvalues:
    --  [1] SoundLibrary_m (copy)

    arg50._is_equipped = true
    arg50.Equipped:Fire(arg51)
    arg50._instant_set_inspect_spring = true
    arg50._render_cooldown = tick() + 0.1
    arg50.Animator:SetInspectCooldown(0)
    arg50.Animator:PlayIdleAnimation()
    arg50:CreateSound(
        SoundLibrary_m.EquipSounds[math.random(#SoundLibrary_m.EquipSounds)],
        if arg51 then 0.25 else 0.5,
        0.9 + 0.2 * math.random(),
        true,
        5
    )

    if arg51 then
        arg50._equip_spring.Value = 0.5

        return
    end

    if not arg50.Animator:PlayEquipAnimation() then
        arg50._equip_spring.Value = 1
    end
end

function t_1.Unequip(arg52) -- line: 383
    arg52._is_equipped = false
    arg52.Unequipped:Fire()

    if arg52._highlight then
        arg52._highlight:Destroy()
        arg52._highlight = nil
    end

    arg52.Animator:StopAllAnimations()
end

function t_1.MuzzleFlash(arg53) -- line: 395
    -- upvalues:
    --  [1] PlayerDataController_m (copy)
    --  [2] Utility_m (copy)

    if
        arg53._aim_spring.Target >= 1
        and PlayerDataController_m:GetSetting("Aiming Hides Muzzle Flashes")
    then
        return
    end

    for _, val_1 in pairs(arg53._muzzle_attachments) do
        Utility_m:PlayParticles(val_1)
    end
end

function t_1.PlayHitAnimation(arg54, arg55) -- line: 405
    if arg55 and arg54.Info.Animations.HeavyAttackAnimationHit then
        arg54:PlayAnimation("HeavyAttackAnimationHit", nil, 0)
    end
end

function t_1.PlayHitmarkerSound(arg56, arg57, arg58) -- line: 411
    if #arg56._last_hitmarker_sounds > 10 then
        for index = #arg56._last_hitmarker_sounds % 10, 1, -1 do
            arg56._last_hitmarker_sounds[index]:Destroy()
            table.remove(arg56._last_hitmarker_sounds, index)
        end
    end

    if arg57 then
        arg56:_CreateHitmarkerSound(
            "rbxassetid://16537449730",
            3 / arg58,
            1 + 0.2 * math.random(),
            script,
            true,
            1
        )
        arg56:_CreateHitmarkerSound(
            "rbxassetid://16537337310",
            2 / arg58,
            1 + 0.2 * math.random(),
            script,
            true,
            1
        )

        return
    end

    arg56:_CreateHitmarkerSound(
        "rbxassetid://13110130082",
        1.5 / arg58,
        1 + 0.2 * math.random(),
        script,
        true,
        1
    )
end

function t_1.Update(arg59, arg60, arg61, arg62) -- line: 427
    -- upvalues:
    --  [1] ViewModels_1 (copy)
    --  [2] PlayerDataController_m (copy)
    --  [3] Utility_m (copy)
    --  [4] CONSTANTS_m (copy)
    --  [5] CameraController_m (copy)
    --  [6] ItemLibrary_m (copy)
    --  [7] FirstPerson (copy)
    --  [8] ViewModels (copy)

    if not arg62.IsActive then
        if arg59.Model ~= ViewModels_1 then
            pcall(function() -- line: 432
                -- upvalues:
                --  [1] arg59 (copy)
                --  [2] ViewModels_1 (ref)

                arg59:SetParent(ViewModels_1)
            end)
        end

        return
    end

    local v27 = arg59.Animator:IsInspectAnimationPlaying()
    arg59._inspect_spring.Target = if v27 then 1 else 0
    local InspectSpring_1 = arg59._inspect_spring
    InspectSpring_1.Value = if not arg59._instant_set_inspect_spring then arg59._inspect_spring.Value else arg59._inspect_spring.Target
    arg59._instant_set_inspect_spring = false
    local v29 = arg59.ClientItem.ClientFighter:GetCameraSway(true) * 35
    local state = arg59.ClientItem.ClientFighter.Entity.Humanoid:GetState()
    local v30 = arg59.Animator:GetSprintTrack()
    local Value = arg59._inspect_spring.Value
    local v31 = arg59._aim_spring.Value * (1 - Value * 0.125)
    local v32 = 1 - v31
    local v33 = arg59._recoil_spring.Value - arg59._unrecoil_spring.Value
    local v34 = arg61.IsActuallySprinting

    if v34 then
        v34 = arg59._aim_spring.Target == 0
    end

    if
        not arg59._highlight
        and arg61.IsActuallyFirstPerson
        and not arg59:IsRenderingDisabled()
        and PlayerDataController_m:GetSetting("ViewModel Highlight")
    then
        arg59._highlight = Instance.new("Highlight")
        arg59._highlight.Name = "ViewModel"
        arg59._highlight.FillTransparency = 1
        arg59._highlight.OutlineTransparency = 0.875
        arg59._highlight.OutlineColor = Color3.new()
        arg59._highlight.Adornee = arg59.Model
        arg59._highlight.Parent = arg59.Model
    elseif arg59._highlight and not arg61.IsActuallyFirstPerson then
        arg59._highlight:Destroy()
        arg59._highlight = nil
    end

    if v30 then
        if v34 and not v30.IsPlaying then
            arg59.Animator:PlaySprintAnimation()
        elseif not v34 and v30.IsPlaying then
            arg59.Animator:StopSprintAnimation()
        end

        if v30.IsPlaying then
            v30:AdjustSpeed(
                arg59.Animator.SprintTrackSpeed * arg59._bobbing_speed_spring.Value / 0.1111111111111111 * 0.8
            )
        end
    end

    local v36 = if not arg61.IsActuallyFirstPerson then 1 else 0
    arg59._left_arm.Transparency = v36
    arg59._right_arm.Transparency = v36
    arg59._left_arm_shirt_texture.Transparency = v36
    arg59._right_arm_shirt_texture.Transparency = v36

    if arg59._scope_glare_gui1 and arg59._scope_glare_gui2 then
        local LookVector = arg59.ClientItem.ClientFighter.Entity.RootPart.CFrame.LookVector
        local ScopeGlareGui1_1 = arg59._scope_glare_gui1
        local v37 = not arg61.IsActuallyFirstPerson

        if v37 then
            v37 = if arg59._aim_spring.Target >= 1 then Utility_m:AngleBetweenVectors(
                (workspace.CurrentCamera.CFrame.Position - arg59._scope_glare_attachment.WorldPosition).Unit,
                LookVector
            ) < 0.7853981633974483 and true else false
        end

        ScopeGlareGui1_1.Enabled = v37
        arg59._scope_glare_gui2.Enabled = false
    end

    local v65

    if arg59:IsRenderingDisabled() then
        arg59:SetCFrame(CFrame.identity)
        arg59:_StepBehindHeadSubmodels(false)
    elseif not arg61.IsActuallyFirstPerson then
        local v38 = arg59.ClientItem.ClientFighter:GetRotationCFrame()
        arg59:SetCFrame(CFrame.new(arg59.ClientItem.ClientFighter.Entity.Head.Position) * v38)
        arg59:_StepBehindHeadSubmodels(nil, v38)
        arg59:_UpdateHiddenArmSubmodels(false)
    else
        arg59:_StepBehindHeadSubmodels(true)
        arg59:_UpdateHiddenArmSubmodels(true)
        local v40 = CONSTANTS_m.DEVICE == "VR" and workspace.CurrentCamera.CFrame * CameraController_m.VRCameraCFrame.Rotation + CameraController_m.VRCameraCFrame.Position * 1.4142135623730951 / 2 or workspace.CurrentCamera.CFrame
        local v43 = v40 * arg62.ViewModelOffset * (arg59._root_part_offset_override or arg59.Info.RootPartOffset)
        local SwaySpring = arg59._sway_spring
        SwaySpring.Value = SwaySpring.Value + Vector2.new(v29.Y * 0.5, v29.X)
        v40 = arg59._sway_spring.Value * 0.0003
        local v44 = arg59._aim_lookat_attachment and arg59._aim_lookat_attachment.WorldCFrame:ToObjectSpace(
            arg59.Model.PrimaryPart.CFrame
        ) or CFrame.identity
        local cframe = CFrame.new(v40.Y * 1, -v40.X * 2, 0)
        local v48 = cframe:Lerp(
            v44:Inverse() * CFrame.Angles(0, v40.Y * 0.05625, 0) * CFrame.Angles(v40.X * 0.1, 0, 0) * v44,
            v31
        )
        local cframe_1 = CFrame.new(arg59._impulse_position_spring.Value)
        local Value_2 = arg59._equip_spring.Value
        local v49 = CFrame.new(0, -0.5 * Value_2, 0.25 * Value_2) * CFrame.Angles(
            -0.7853981633974483 * Value_2,
            0,
            0.7853981633974483 * Value_2
        )
        arg59._sliding_spring.Target = if arg61.IsSliding then 1 else 0
        local cframe_3 = CFrame.Angles(
            0,
            0,
            -0.3490658503988659 * (arg59._sliding_spring.Value * v32)
        )
        local v51

        if arg59.Info.DisableProceduralSprinting then
            v51 = CFrame.identity
        else
            local v52 = v34 and (if not v30 then not v27 and tick() > arg59._custom_sprinting_enabled else not v30.IsPlaying and not v27 and tick() > arg59._custom_sprinting_enabled)
            local SprintingSpring = arg59._sprinting_spring
            SprintingSpring.Target = if v52 then 1 else if state ~= Enum.HumanoidStateType.Climbing then 0 else 1
            v52 = arg59._sprinting_spring.Value
            v51 = CFrame.Angles(0, 0.4363323129985824 * v52, 0) * CFrame.Angles(
                -0.4363323129985824 * v52,
                0,
                0
            )
        end

        local BobbingSpeedSpring = arg59._bobbing_speed_spring
        local v54 = arg61.MoveSpeed / CONSTANTS_m.BASE_WALKSPEED * 0.1111111111111111
        local v55 = if not arg61.IsGrounded then 0.05 else 1
        BobbingSpeedSpring.Target = v54 * v55
        arg59._bobbing_tick += arg59._bobbing_speed_spring.Value * arg60 * 60
        local v56 = if not v34 then 1 else if not v30 then 1 else if not v30.IsPlaying then 1 else 0.25
        local v57 = math.max(0, arg61.MoveSpeed / CONSTANTS_m.BASE_WALKSPEED) ^ 2.5
        local v58 = if arg61.IsSliding or arg61.IsBeingKnockedBack then 0 else 1
        local v59 = if not arg59.ClientItem.Info.AimScopePercent then v32 else 1
        local v60 = v57 * v58 * v56 * 0.05 * v59
        v56 = arg59.Info.FramesPerSecond and math.floor(
            arg59._bobbing_tick * arg59.Info.FramesPerSecond
        ) / arg59.Info.FramesPerSecond or arg59._bobbing_tick
        local v62 = math.sin(v56) * v60 * 2
        arg59._bobbing_value_spring.Target = Vector2.new(
            v62,
            math.cos(v56 * 2 + 1.5707963267948966) * v60
        )
        local v63 = arg59.Info.FramesPerSecond and arg59._bobbing_value_spring.Target or arg59._bobbing_value_spring.Value
        local cframe_5 = CFrame.new(v63.X, v63.Y, 0)
        local LandingSpring = arg59._landing_spring
        LandingSpring.Velocity = arg61.JustLanded and -10 - 15 * v32 or arg59._landing_spring.Velocity
        v65 = arg59._landing_spring.Value
        v56 = CFrame.new(0, v65 * 0.125, 0)
        arg59._jump_spring.Target = math.max(
            -16 * v32,
            math.abs(arg61.PlayerVelocity.Y) ^ 1.25 * math.sign(arg61.PlayerVelocity.Y)
        )
        local v68 = arg59._jump_spring.Value * (2 - 1.5 * v31)
        local cframe_8 = CFrame.Angles(
            math.clamp(math.rad(-v68 / 6), -0.7853981633974483, 0.7853981633974483),
            0,
            0
        )
        local v70 = arg59:IsAimingAnimationEnabled()
        local v73, v74

        if arg59.Info.FramesPerSecond then
            local v71 = v31 * arg59.Info.FramesPerSecond
            local v72 = if not arg59.ClientItem.Info.AimScopePercent then 0.5 else 0
            v73 = math.floor(v71 + v72)
            v74 = v73 / arg59.Info.FramesPerSecond or v31
        else
            v74 = v31
        end

        if not v70 then
            v73 = CFrame.identity

            if not v73 then
                v73 = CFrame.lookAt(
                    arg59._aim_position_attachment.WorldPosition,
                    arg59._aim_lookat_attachment.WorldPosition,
                    arg59._aim_position_attachment.WorldCFrame.UpVector
                ):ToObjectSpace(arg59.Model.PrimaryPart.CFrame)
            end
        else
            v73 = CFrame.lookAt(
                arg59._aim_position_attachment.WorldPosition,
                arg59._aim_lookat_attachment.WorldPosition,
                arg59._aim_position_attachment.WorldCFrame.UpVector
            ):ToObjectSpace(arg59.Model.PrimaryPart.CFrame)
        end

        local cframe_6 = CFrame.new(v73.Position)
        local v75 = v73 - v73.Position
        local Identity
        local v76

        if arg61.IsActuallyFirstPerson then
            if v31 >= (arg59.ClientItem.Info.AimScopePercent or math.huge) then
                v73 = CFrame.new(0, 0, 10)

                if not v73 then
                    if not v70 then
                        v73 = CFrame.identity

                        if not v73 then
                            v76 = arg59._root_part_offset_override_inverse
                            Identity = CFrame.identity
                            v76 = v76 or arg59._root_part_offset_inverse
                            Identity = Identity:Lerp(v76 * arg62.ViewModelOffset:Inverse(), v31)
                            v73 = Identity * CFrame.identity:Lerp(cframe_6, v74) * CFrame.identity:Lerp(
                                v75,
                                v74
                            )
                        end
                    else
                        v76 = arg59._root_part_offset_override_inverse
                        Identity = CFrame.identity
                        v76 = v76 or arg59._root_part_offset_inverse
                        Identity = Identity:Lerp(v76 * arg62.ViewModelOffset:Inverse(), v31)
                        v73 = Identity * CFrame.identity:Lerp(cframe_6, v74) * CFrame.identity:Lerp(
                            v75,
                            v74
                        )
                    end
                end
            elseif not v70 then
                v73 = CFrame.identity

                if not v73 then
                    v76 = arg59._root_part_offset_override_inverse
                    Identity = CFrame.identity
                    v76 = v76 or arg59._root_part_offset_inverse
                    Identity = Identity:Lerp(v76 * arg62.ViewModelOffset:Inverse(), v31)
                    v73 = Identity * CFrame.identity:Lerp(cframe_6, v74) * CFrame.identity:Lerp(
                        v75,
                        v74
                    )
                end
            else
                v76 = arg59._root_part_offset_override_inverse
                Identity = CFrame.identity
                v76 = v76 or arg59._root_part_offset_inverse
                Identity = Identity:Lerp(v76 * arg62.ViewModelOffset:Inverse(), v31)
                v73 = Identity * CFrame.identity:Lerp(cframe_6, v74) * CFrame.identity:Lerp(
                    v75,
                    v74
                )
            end
        elseif not v70 then
            v73 = CFrame.identity

            if not v73 then
                v76 = arg59._root_part_offset_override_inverse
                Identity = CFrame.identity
                v76 = v76 or arg59._root_part_offset_inverse
                Identity = Identity:Lerp(v76 * arg62.ViewModelOffset:Inverse(), v31)
                v73 = Identity * CFrame.identity:Lerp(cframe_6, v74) * CFrame.identity:Lerp(
                    v75,
                    v74
                )
            end
        else
            v76 = arg59._root_part_offset_override_inverse
            Identity = CFrame.identity
            v76 = v76 or arg59._root_part_offset_inverse
            Identity = Identity:Lerp(v76 * arg62.ViewModelOffset:Inverse(), v31)
            v73 = Identity * CFrame.identity:Lerp(cframe_6, v74) * CFrame.identity:Lerp(v75, v74)
        end

        local v82 = -arg61.MoveVelocity:Cross(
            arg59.ClientItem.ClientFighter.Entity.RootPart.CFrame.LookVector
        ).Y / CONSTANTS_m.BASE_WALKSPEED * (1 + v31)
        local TiltSpring = arg59._tilt_spring
        local New_1 = Vector2.new
        local v83 = if arg61.IsSliding then 0 else arg61.MoveVelocity:Cross(
            arg59.ClientItem.ClientFighter.Entity.RootPart.CFrame.RightVector
        ).Y / CONSTANTS_m.BASE_WALKSPEED * (1 - v31 * 0.75)
        TiltSpring.Target = New_1(v82, v83)
        local Value_3 = arg59._tilt_spring.Value
        local v85 = v44:Inverse() * CFrame.Angles(
            Value_3.Y * 0.06981317007977318 * 0.5,
            0,
            Value_3.X * 0.06981317007977318
        ) * v44
        local cframe_9 = CFrame.new(
            Vector3.new(0, 0, v33.Z),
            (Vector3.new(v33.X, math.abs(v33.Y), v33.Z - 1))
        )
        local v87 = cframe_9 * CFrame.Angles(
            math.abs(v33.Y) * 0.7853981633974483,
            0,
            1.5707963267948966 * -v33.X
        )
        v74 = CFrame.new(v33.X * 2, -v33.Z / 10, v33.Z) * CFrame.Angles(0, v33.X * -2.5, v33.X * 10)
        local v91 = v44:Inverse() * CFrame.identity:Lerp(v87, 1 - v31)
        local v93 = v43 * v48 * cframe_1 * v49 * cframe_3 * v51 * cframe_5 * v56 * cframe_8 * v73 * v85
        arg59:SetCFrame(v93 * (v91 * CFrame.identity:Lerp(v74, v31) * v44))
        arg59.CurrentBobbingValue = v63
        arg59.CurrentSwayValue = v40
        arg59.CurrentJumpValue = v68
        arg59.CurrentLandingValue = v65
    end

    if arg59.Charm then
        task.defer(arg59.Charm.Update, arg59.Charm, arg60, not arg61.IsActuallyFirstPerson)
    end

    if arg59._was_first_person ~= arg61.IsActuallyFirstPerson then
        arg59._was_first_person = arg61.IsActuallyFirstPerson

        for key_2, val_2 in pairs(arg59._arm_submodels) do
            local OriginalScale = val_2.OriginalScale
            v65 = if not arg61.IsActuallyFirstPerson then 1.7 else 1
            key_2:ScaleTo(OriginalScale * v65)
        end

        if ItemLibrary_m.THIRD_PERSON_VIEWMODEL_BLACKLIST[arg59.Name] then
            arg59:_UpdateWrap()
        end
    end

    arg59.CurrentRecoilValue = v33
    arg59.CurrentAimValue = v31
    arg59.CurrentInspectValue = Value
    arg59:SetParent(if not arg61.IsActuallyFirstPerson then ViewModels else FirstPerson)

    return true
end

function t_1.Destroy(arg63) -- line: 691
    -- upvalues:
    --  [1] ReplicatedClass_m (copy)

    arg63._destroyed = true

    for _, val_3 in pairs(arg63._preloaded_sounds) do
        val_3:Destroy()
    end

    for _, val_4 in pairs(arg63._connections) do
        val_4:Disconnect()
    end

    for key_5, _ in pairs(arg63._wrapped_only_objects) do
        key_5:Destroy()
    end

    arg63.Equipped:Destroy()
    arg63.Unequipped:Destroy()
    arg63.AnimationPlayed:Destroy()
    arg63.AnimationStopped:Destroy()

    if arg63.Charm then
        arg63.Charm:Destroy()
    end

    arg63.Animator:Destroy()
    arg63.ItemModel:Destroy()
    arg63.Model:Destroy()
    ReplicatedClass_m.Destroy(arg63)
end

function t_1._UpdateHiddenArmSubmodels(arg64, arg65) -- line: 726
    for key_6, val_6 in pairs(arg64._arm_submodels) do
        local v97 = val_6.HideInThirdPerson

        if v97 then
            v97 = not arg65
        end

        local v98 = if not v97 then 0 else 1

        for _, val_7 in pairs(key_6:GetDescendants()) do
            if val_7:IsA("BasePart") then
                arg64:_LocalTransparencyModifier(val_7, "HiddenArmSubmodel", v98)
            end
        end
    end
end

function t_1._IsSubmodelBehindHead(arg66, arg67, arg68) -- line: 741
    -- upvalues:
    --  [1] Utility_m (copy)

    if not arg66._animation_context_submodels[arg67] then
    end

    local v100 = arg66.ClientItem.ClientFighter.Entity and (arg66.ClientItem.ClientFighter.Entity.Head or arg66.ClientItem.ClientFighter.Entity.RootPart)

    if not v100 or not arg67.PrimaryPart then
        return false
    end

    local v101 = arg68 or v100.CFrame.Rotation

    for _, val_8 in pairs(arg66._submodel_boundingbox_attachments[arg67]) do
        if
            val_8.WorldPosition:FuzzyEq(v100.Position)
            or Utility_m:AngleBetweenVectors(val_8.WorldPosition - v100.Position, v101.LookVector) < 1.5707963267948966
        then
            return false
        end
    end

    return true
end

function t_1._StepBehindHeadSubmodels(arg69, arg70, arg71) -- line: 763
    for _, child in pairs(arg69.ItemModel:GetChildren()) do
        local v105 = (if arg70 ~= nil then arg70 else not arg69:_IsSubmodelBehindHead(child, arg71)) or false

        if arg69._submodels_behind_head_values[child] ~= v105 then
            arg69._submodels_behind_head_values[child] = v105
            local v106 = if not v105 then 1 else 0

            for _, val_9 in pairs(child:GetDescendants()) do
                if val_9:IsA("BasePart") then
                    arg69:_LocalTransparencyModifier(val_9, "BehindHead", v106)
                end
            end

            if arg69.Charm and child == arg69._charm_sub_model then
                arg69.Charm:SetHidden(not v105)
            end
        end
    end
end

function t_1._GetDefaultMuzzlePosition(arg72) -- line: 788
    return (CFrame.new(arg72.ClientItem.ClientFighter.Entity.Head.Position) * arg72.ClientItem.ClientFighter:GetRotationCFrame() * CFrame.new(
        0.5,
        -0.5,
        -0.5
    )).Position
end

function t_1._AnimationWait(arg73, ...) -- line: 792
    return arg73.Animator:AnimationWait(...)
end

function t_1._CreateHitmarkerSound(arg74, ...) -- line: 796
    local v109 = arg74.ClientItem.ItemInterface:CreateSound(...)

    if v109 then
        table.insert(arg74._last_hitmarker_sounds, v109)
    end
end

function t_1._UpdateLocalTransparencyModifiers(arg75) -- line: 804
    for key_11, _ in pairs(arg75._local_transparency_modifiers) do
        arg75:_UpdateLocalTransparencyModifier(key_11)
    end
end

function t_1._UpdateLocalTransparencyModifier(arg76, arg77) -- line: 810
    arg76._local_transparency_modifier_update[arg77] = true
    task.defer(function() -- line: 813
        -- upvalues:
        --  [1] arg76 (copy)
        --  [2] arg77 (copy)

        if not arg76._local_transparency_modifier_update[arg77] then
            return
        end

        arg76._local_transparency_modifier_update[arg77] = nil
        local v110 = 0

        for _, val_11 in pairs(arg76._local_transparency_modifiers[arg77]) do
            v110 = math.max(v110, val_11)
        end

        arg77.LocalTransparencyModifier = v110

        for _, val_12 in pairs(arg77:GetDescendants()) do
            if
                val_12:IsA("Texture")
                or val_12:IsA("Beam")
                or val_12:IsA("ParticleEmitter")
                or val_12:IsA("Trail")
                or val_12:IsA("Decal")
            then
                val_12.LocalTransparencyModifier = v110
            end
        end
    end)
end

function t_1._LocalTransparencyModifier(arg78, arg79, arg80, arg81) -- line: 836
    if not arg79 then
        return
    end

    local v112 = arg78._local_transparency_modifiers[arg79] or {}
    arg78._local_transparency_modifiers[arg79] = v112

    if arg78._local_transparency_modifiers[arg79][arg80] == arg81 then
        return
    end

    local v113
    arg78._local_transparency_modifiers[arg79][arg80], v113 = arg81, arg79
    arg78:_UpdateLocalTransparencyModifier(v113)
end

function t_1._UpdateWrap(arg82) -- line: 851
    -- upvalues:
    --  [1] ItemLibrary_m (copy)
    --  [2] WrapController_m (copy)

    local v114 = if ItemLibrary_m.THIRD_PERSON_VIEWMODEL_BLACKLIST[arg82.Name] and not arg82._was_first_person then nil else arg82:GetWrap()

    if not v114 and not arg82._original_wrap_properties then
        return
    end

    local v115 = if v114 == nil then false else true

    if v115 then
    end

    local v116 = v115 and arg82._can_wrap_left_arm
    local v117 = v115 and arg82._can_wrap_right_arm
    local v119 = if not v116 then 0 else 1
    arg82:_LocalTransparencyModifier(arg82._left_arm, "FistsWrap", v119)
    arg82:_LocalTransparencyModifier(
        arg82._left_arm_shirt_texture,
        "FistsWrap",
        if v116 then 1 else 0
    )
    arg82:_LocalTransparencyModifier(arg82._right_arm, "FistsWrap", if v117 then 1 else 0)
    arg82:_LocalTransparencyModifier(
        arg82._right_arm_shirt_texture,
        "FistsWrap",
        if v117 then 1 else 0
    )

    for key_14, val_13 in pairs(arg82._wrapped_only_objects) do
        v117 = v115 and (if key_14.Name ~= "LeftArmWrapped" then if key_14.Name ~= "RightArmWrapped" then false else arg82._can_wrap_right_arm else arg82._can_wrap_left_arm or (if key_14.Name ~= "RightArmWrapped" then false else arg82._can_wrap_right_arm))
        local v123 = v117 and val_13 or nil
        key_14.Parent = v123
    end

    arg82._original_wrap_properties = arg82._original_wrap_properties or WrapController_m:RecordOriginalWrapProperties(
        arg82.Model
    )
    WrapController_m:ApplyWrap(arg82._original_wrap_properties, v114)
    arg82:_UpdateLocalTransparencyModifiers()
end

function t_1._UpdateSubModelVisibility(arg83) -- line: 881
    for _, child_1 in pairs(arg83.ItemModel:GetChildren()) do
        local v126 = arg83._animation_context_submodels[child_1]
        local v127 = arg83._hidden_submodels[child_1.Name]

        if v126 or v127 ~= nil then
            local v128 = if not v127 and (not v126 or arg83:AreAnimationsPlaying(v126)) then 0 else 1

            for _, val_14 in pairs(child_1:GetDescendants()) do
                if val_14:IsA("BasePart") or val_14:IsA("Texture") then
                    arg83:_LocalTransparencyModifier(val_14, "SubModelVisibility", v128)
                end
            end
        end
    end
end

function t_1._UpdateArms(arg84) -- line: 900
    -- upvalues:
    --  [1] WrapController_m (copy)

    WrapController_m:ResetWrap(arg84._original_wrap_properties)
    arg84._original_wrap_properties = nil
    arg84._right_arm_shirt_texture.Texture = arg84._shirt_id
    arg84._left_arm_shirt_texture.Texture = arg84._shirt_id
    arg84._right_arm.Color = arg84._right_arm_color
    arg84._left_arm.Color = arg84._left_arm_color
    arg84._right_arm_wrapped_part.Color = arg84._right_arm_color
    arg84._left_arm_wrapped_part.Color = arg84._left_arm_color

    if arg84.Name == "Hand Gun" then
        for _, val_15 in pairs(arg84.ItemModel:GetChildren()) do
            if val_15:FindFirstChild("MeshPart") then
                local MeshPart = val_15.MeshPart
                local v131 = val_15:GetAttribute("IsRightHand") and arg84._right_arm_color or arg84._left_arm_color
                MeshPart.Color = v131
            end
        end
    end

    arg84:_UpdateWrap()
end

function t_1._Setup(arg85) -- line: 922
    -- upvalues:
    --  [1] CosmeticLibrary_m (copy)
    --  [2] CONSTANTS_m (copy)
    --  [3] t (copy)
    --  [4] MuzzleFlashes (copy)
    --  [5] ScopeGlareGui1 (copy)
    --  [6] ScopeGlareGui2 (copy)
    --  [7] Charms (copy)
    --  [8] Charm_m (copy)
    --  [9] SoundLibrary_m (copy)
    --  [10] ViewModels_1 (copy)

    if CosmeticLibrary_m.IGNORE_TRANSPARENCY_WHITELIST[arg85.ClientItem.Name] then
        for _, val_16 in pairs(arg85.ItemModel:GetDescendants()) do
            if val_16:IsA("BasePart") then
                val_16:SetAttribute("IgnoreTransparency", true)
            end
        end
    end

    local Model = arg85.Model
    local v133 = arg85.ClientItem.ClientFighter.Player and arg85.ClientItem.ClientFighter.Player.Name or "???"
    Model.Name = v133 .. " - " .. arg85.ClientItem.Name .. " - " .. arg85.Name
    arg85._right_arm.Mesh.Scale = if CONSTANTS_m.DEVICE == "VR" then Vector3.new(0, 0, 0) else arg85._right_arm.Mesh.Scale
    arg85._left_arm.Mesh.Scale = if CONSTANTS_m.DEVICE == "VR" then Vector3.new(0, 0, 0) else arg85._left_arm.Mesh.Scale
    arg85._right_arm_wrapped_part = arg85.Model.RightArmWrapped
    arg85._right_arm_wrapped_part.Parent = nil
    arg85._wrapped_only_objects[arg85._right_arm_wrapped_part] = arg85.Model
    arg85._left_arm_wrapped_part = arg85.Model.LeftArmWrapped
    arg85._left_arm_wrapped_part.Parent = nil
    arg85._wrapped_only_objects[arg85._left_arm_wrapped_part] = arg85.Model
    arg85.ItemModel.Name = "ItemVisual"
    arg85.ItemModel.Parent = arg85.Model
    arg85._body_model = arg85.Model:FindFirstChild("Body")
    arg85._aim_position_attachment = arg85.Model:FindFirstChild("_aim_position", true)
    arg85._aim_lookat_attachment = arg85.Model:FindFirstChild("_aim_lookat", true)
    arg85._center_attachment = arg85.Model:FindFirstChild("_center", true)
    arg85._charm_attachment_model = arg85.Model:FindFirstChild("_charm_attachment_model", true)
    arg85._charm_pivot_attachment = arg85._charm_attachment_model and arg85._charm_attachment_model:FindFirstChild(
        "_charm_pivot_attachment",
        true
    ) or arg85.Model:FindFirstChild("_charm_pivot_attachment", true)
    arg85._scope_glare_attachment = arg85.Model:FindFirstChild("_scope_glare", true)
    local PrimaryPart = arg85.Model.PrimaryPart
    local v136 = CFrame.identity
    local v137 = nil

    for _, child_2 in pairs(arg85.ItemModel:GetChildren()) do
        if child_2.Name == "_fake" then
            arg85._can_wrap_left_arm = child_2:FindFirstChild("LeftArmWrapped")
            arg85._can_wrap_right_arm = child_2:FindFirstChild("RightArmWrapped")
            task.defer(child_2.Destroy, child_2)
        else
            child_2.PrimaryPart = child_2.Primary
            local v139 = v137 or child_2.PrimaryPart.CFrame
            v137 = v139
            v139 = if child_2.Name ~= "_right_arm" then if child_2.Name ~= "_left_arm" then nil else "LeftArm" else "RightArm"

            if v139 then
                local t_3 = {
                    OriginalScale = child_2:GetScale(),
                    HideInThirdPerson = child_2:GetAttribute("HideInThirdPerson")
                }
                arg85._arm_submodels[child_2] = t_3
                local v140 = arg85.Model[v139]
                child_2.Parent = v140
                child_2:PivotTo(v140.CFrame)
                local WeldConstraint = Instance.new("WeldConstraint")
                WeldConstraint.Part0 = v140
                WeldConstraint.Part1 = child_2.PrimaryPart
                WeldConstraint.Parent = child_2.PrimaryPart
            else
                local Motor6D = Instance.new("Motor6D")
                Motor6D.Part0 = PrimaryPart
                Motor6D.Part1 = child_2.PrimaryPart
                Motor6D.Name = "ItemVisual[\"" .. child_2.Name .. "\"]"
                local v141 = child_2:GetAttribute("C0") or child_2.PrimaryPart.CFrame:ToObjectSpace(
                    v137
                ):Inverse() * v136
                Motor6D.C0 = v141
                v141 = child_2:GetAttribute("C1") or CFrame.identity
                Motor6D.C1 = v141
                Motor6D.Parent = PrimaryPart
            end

            for _, val_17 in pairs(child_2:GetDescendants()) do
                if val_17:IsA("BasePart") then
                    val_17.CastShadow = false
                    val_17.CanCollide = false
                    val_17.CanTouch = false
                    val_17.CanQuery = false
                    val_17.Massless = true

                    if val_17 ~= child_2.PrimaryPart then
                        local WeldConstraint_1 = Instance.new("WeldConstraint")
                        WeldConstraint_1.Part0 = child_2.PrimaryPart
                        WeldConstraint_1.Part1 = val_17
                        WeldConstraint_1.Parent = child_2.PrimaryPart
                        val_17.Anchored = false
                    end
                end
            end

            child_2.PrimaryPart.Anchored = false

            if not v139 then
                child_2.PrimaryPart.Name = child_2.Name .. "Primary"
                child_2:PivotTo(PrimaryPart.CFrame)
                v139 = child_2:GetAttribute("AnimationContexts")

                if v139 then
                    arg85._animation_context_submodels[child_2] = {}
                    local v143 = 1

                    for index_1 = 1, #v139 do
                        if string.sub(v139, index_1 - 1, index_1) == ", " then
                            table.insert(
                                arg85._animation_context_submodels[child_2],
                                (string.sub(v139, v143, index_1 - 2))
                            )
                            v143 = index_1 + 1
                        end
                    end

                    if v143 <= #v139 then
                        table.insert(
                            arg85._animation_context_submodels[child_2],
                            (string.sub(v139, v143, #v139))
                        )
                    end
                end

                if arg85._charm_pivot_attachment and arg85._charm_pivot_attachment:IsDescendantOf(
                    child_2
                ) then
                    arg85._charm_sub_model = child_2
                end

                arg85._submodel_boundingbox_attachments[child_2] = {}
                local boundingCFrame, boundingSize = child_2:GetBoundingBox()

                for key_21, val_18 in pairs(t) do
                    local Attachment = Instance.new("Attachment")
                    Attachment.Name = "_boundingbox" .. key_21
                    Attachment.Parent = child_2.PrimaryPart
                    Attachment.WorldCFrame = boundingCFrame * CFrame.new(boundingSize * val_18)
                    table.insert(arg85._submodel_boundingbox_attachments[child_2], Attachment)
                end
            end
        end
    end

    for _, descendant in pairs(arg85.Model:GetDescendants()) do
        if descendant.Name == "_muzzle" then
            table.insert(arg85._muzzle_attachments, descendant)
            v137 = descendant:GetAttribute("MuzzleFlashParticlesName")
            v136 = v137 and MuzzleFlashes:FindFirstChild(v137) or MuzzleFlashes:FindFirstChild(
                arg85.Name
            ) or MuzzleFlashes:FindFirstChild(arg85.ClientItem.Name) or MuzzleFlashes.Default

            for _, val_19 in pairs(v136.Attachment:GetChildren()) do
                val_19:Clone().Parent = descendant
            end
        end
    end

    if arg85._scope_glare_attachment then
        arg85._scope_glare_gui1 = ScopeGlareGui1:Clone()
        arg85._scope_glare_gui1.Enabled = false
        arg85._scope_glare_gui1.Parent = arg85._scope_glare_attachment
        arg85._scope_glare_gui2 = ScopeGlareGui2:Clone()
        arg85._scope_glare_gui2.Enabled = false
        arg85._scope_glare_gui2.Parent = arg85._scope_glare_attachment
    end

    if arg85._charm_pivot_attachment then
        if arg85:Get("Charm") then
            local v148 = arg85:Get("Charm")
            local v149 = Charms:FindFirstChild(v148.Name, true)
            local v150 = v149 and require(v149) or Charm_m
            arg85.Charm = v150.new(arg85, v148, arg85._charm_pivot_attachment)
            arg85.Charm:SetParent(arg85.Model)
        else
            if arg85._charm_pivot_attachment then
                arg85._charm_pivot_attachment:Destroy()
            end

            if arg85._charm_attachment_model then
                arg85._charm_attachment_model:Destroy()
            end
        end
    end

    if arg85.ClientItem.ClientFighter.IsLocalPlayer then
        for _, val_20 in pairs(arg85.Info.Animations) do
            SoundLibrary_m:PreloadSounds(
                SoundLibrary_m.AnimationSounds[val_20],
                arg85._preloaded_sounds
            )
        end

        if SoundLibrary_m.ViewModelSounds[arg85.Name] then
            SoundLibrary_m:PreloadSounds(
                SoundLibrary_m.ViewModelSounds[arg85.Name],
                arg85._preloaded_sounds
            )
        end
    end

    arg85:SetArmsData(nil, nil, nil)
    arg85:SetParent(ViewModels_1)
    arg85:SetCFrame(CFrame.identity)
end

function t_1._Init(arg86) -- line: 1138
    -- upvalues:
    --  [1] PlayerDataController_m (copy)

    arg86.Animator.AnimationPlayed:Connect(function(...) -- line: 1139
        -- upvalues:
        --  [1] arg86 (copy)

        arg86.AnimationPlayed:Fire(...)
        arg86:_UpdateSubModelVisibility()
    end)
    arg86.Animator.AnimationStopped:Connect(function(...) -- line: 1144
        -- upvalues:
        --  [1] arg86 (copy)

        arg86.AnimationStopped:Fire(...)
        arg86:_UpdateSubModelVisibility()
    end)
    local Connections = arg86._connections
    local IsSpectating = arg86.ClientItem.ClientFighter:GetDataChangedSignal("IsSpectating")
    table.insert(Connections, IsSpectating:Connect(function() -- line: 1149
        -- upvalues:
        --  [1] arg86 (copy)

        arg86:_UpdateWrap()
    end))
    local Connections_1 = arg86._connections
    local v151 = PlayerDataController_m:GetSettingChangedSignal("Wraps Disabled")
    table.insert(Connections_1, v151:Connect(function() -- line: 1153
        -- upvalues:
        --  [1] arg86 (copy)

        arg86:_UpdateWrap()
    end))
    arg86:_Setup()
    arg86:_UpdateWrap()
end

return t_1
