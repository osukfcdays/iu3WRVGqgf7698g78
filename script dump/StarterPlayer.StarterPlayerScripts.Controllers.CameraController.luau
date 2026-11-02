local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local _ = game:GetService("GuiService")
local RunService = game:GetService("RunService")
local VRService = game:GetService("VRService")
local Players = game:GetService("Players")
local CONSTANTS_m = require(ReplicatedStorage.Modules.CONSTANTS)
local QuaternionSpring_m = require(ReplicatedStorage.Modules.QuaternionSpring)
local GameplayUtility_m = require(ReplicatedStorage.Modules.GameplayUtility)
local _ = require(ReplicatedStorage.Modules.DebugLibrary)
local InputLibrary_m = require(ReplicatedStorage.Modules.InputLibrary)
local _ = require(ReplicatedStorage.Modules.TaskLibrary)
local _ = require(ReplicatedStorage.Modules.TestLibrary)
local Quaternion_m = require(ReplicatedStorage.Modules.Quaternion)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local Spring_m = require(ReplicatedStorage.Modules.Spring)
local Signal_m = require(ReplicatedStorage.Modules.Signal)
local _ = require(Players.LocalPlayer.PlayerScripts.Controllers.PrivateServerController)
local UserInterfaceController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.UserInterfaceController
)
local PlayerDataController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.PlayerDataController
)
local ControlsController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.ControlsController
)
local SettingsController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.SettingsController
)
local DebugState_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.DebugController.DebugState
)
local CameraShaker_m = require(Players.LocalPlayer.PlayerScripts.Modules.CameraShaker)
local CameraState_m = require(script:WaitForChild("CameraState"))
local Value = Enum.RenderPriority.Camera.Value
local t = {}
local v2 = Vector2.new(0.77, 1) * 0.008726646259971648
local t_1 = { MouseKeyboard = 1, Touch = 0.875, Gamepad = 0.75 }
t.__index = t

function t._new() -- line: 38
    -- upvalues:
    --  [1] t (copy)
    --  [2] Signal_m (copy)
    --  [3] CameraState_m (copy)
    --  [4] Spring_m (copy)
    --  [5] QuaternionSpring_m (copy)
    --  [6] Quaternion_m (copy)

    local t_2 = setmetatable({}, t)
    t_2.StateChanged = Signal_m.new()
    t_2.ActiveStateChanged = Signal_m.new()
    t_2.POVStateChanged = Signal_m.new()
    t_2.CustomFreecamStateChanged = Signal_m.new()
    t_2.RotationDeltaApplied = Signal_m.new()
    t_2.SubjectChanged = Signal_m.new()
    t_2.CameraState = CameraState_m.new(t_2)
    t_2.Rotation = Vector2.zero
    t_2.ShakeCFrame = CFrame.identity
    t_2.ViewModelOffsetCFrame = CFrame.identity
    t_2.VRCameraCFrame = nil
    t_2._current_subject = nil
    t_2._current_duel_subject = nil
    t_2._third_person_override = nil
    t_2._external_fov_offsets = {}
    t_2._is_editing_mobile_buttons = false
    t_2._last_dt = 0
    t_2._last_mouse_behavior = nil
    t_2._gamepad_rotation_input = Vector2.zero
    t_2._bobbing_tick = 0
    t_2._fov_gameplay_spring = Spring_m.new(60, 0.75, 30)
    t_2._fov_weapons_spring = Spring_m.new(0, 1, 20)
    t_2._position_spring = Spring_m.new(Vector3.new(0, 0, 0), 0.75, 30)
    t_2._pov_spring = Spring_m.new(Vector3.new(0, 0, 0), 0.875, 25)
    t_2._sway_spring = Spring_m.new(Vector2.zero, 0.5, 12.5)
    t_2._bobbing_speed_spring = Spring_m.new(0, 0.5, 12.5)
    t_2._bobbing_value_spring = Spring_m.new(0, 0.75, 12.5)
    t_2._jump_spring = Spring_m.new(0, 0.5, 15)
    t_2._sliding_spring = Spring_m.new(0, 0.5, 15)
    t_2._leaning_spring = Spring_m.new(0, 1, 20)
    t_2._camera_shaker = nil
    t_2._collision_whitelist = {}
    t_2._next_collision_whitelist_fetch = 0
    t_2._viewmodel_animation_spring = QuaternionSpring_m.new(
        Quaternion_m.fromCFrame(CFrame.identity),
        1,
        10
    )
    t_2._crosshair_disabled = false
    t_2._base_fov = 80
    t_2._gameplay_fov_effects_enabled = true
    t_2._shake_enabled = true
    t_2._open_playerlist_input_down = false
    t_2._inverted_identity_vector = Vector2.one
    t_2._camera_sensitivity = 1
    t_2._camera_sensitivity_ads_multiplier = 1
    t_2._camera_sensitivity_ads_multiplier_scoped = 1
    t_2._camera_sensitivity_x = 1
    t_2._camera_sensitivity_y = 1
    t_2._fov_offset_strength = 0
    t_2._fov_offset_strength_scoped = 0
    t_2._gamepad_deadzone = 0.25
    t_2:_Init()

    return t_2
end

function t.GetPublicState(arg1, ...) -- line: 108
    return arg1.CameraState:GetPublicState(...)
end

function t.GetCurrentSubject(arg2) -- line: 112
    return arg2._current_subject
end

function t.IsSubjectEmoting(arg3) -- line: 116
    local v3 = arg3:GetCurrentSubject()
    local v4 = v3

    if v4 then
        v4 = v3.Entity

        if v4 then
            v4 = v3.Entity:IsEmoting()
        end
    end

    return v4
end

function t.HasThirdPersonAccess(arg4, arg5) -- line: 122
    -- upvalues:
    --  [1] DebugState_m (copy)
    --  [2] ControlsController_m (copy)

    if arg4._third_person_override ~= nil then
        return arg4._third_person_override
    end

    if
        arg4._current_subject and arg4._current_subject:Get("CheaterMode")
        or not arg5 and arg4:IsSubjectEmoting()
    then
        return true
    end

    return DebugState_m:Get("AreHandicapsEnabled") or ControlsController_m.CurrentControls == "Touch"
end

function t.HasUnlockedMouseAccess(arg6) -- line: 129
    -- upvalues:
    --  [1] ControlsController_m (copy)

    local v6 = arg6:HasThirdPersonAccess()

    if v6 then
        v6 = if ControlsController_m.CurrentControls ~= "MouseKeyboard" then arg6:IsSubjectEmoting() else true
    end

    return v6
end

function t.GetLastHeartbeatDeltaTime(arg7) -- line: 133
    return arg7._last_dt
end

function t.GetRenderstepPriority(_) -- line: 137
    -- upvalues:
    --  [1] Value (copy)

    return Value
end

function t.GetCameraCFrame(arg9, arg10) -- line: 141
    -- upvalues:
    --  [1] ControlsController_m (copy)

    local v7 = arg10 or arg9._current_subject

    if ControlsController_m.CurrentControls == "VR" then
        return workspace.CurrentCamera.CFrame * arg9.VRCameraCFrame
    end

    if not v7 or not v7.Entity then
        return CFrame.identity
    end

    local v9 = if arg9.CameraState:GetPublicState() == arg9.CameraState.States.FirstPerson then CFrame.new(
        arg9._leaning_spring.Value * Vector3.new(2, 0.1, 0)
    ) else CFrame.identity

    return CFrame.new(v7.Entity.RootPart.Position) * CFrame.new(arg9._position_spring.Value) * arg9:GetRotationCFrame() * v9
end

function t.GetRotationCFrame(arg11, arg12) -- line: 158
    local v11 = arg12 or arg11.Rotation

    return CFrame.Angles(0, v11.Y, 0) * CFrame.Angles(v11.X, 0, 0)
end

function t.GetGamepadRotationInput(arg13, arg14) -- line: 166
    return arg14 and Vector2.new(arg13._gamepad_rotation_input.Y, arg13._gamepad_rotation_input.X) or arg13._gamepad_rotation_input
end

function t.GetExternalFOVOffset(arg15) -- line: 170
    local v13 = 0

    for _, val in pairs(arg15._external_fov_offsets) do
        v13 += val
    end

    return v13
end

function t.GetCameraSensitivity(arg16) -- line: 180
    local v14 = arg16._current_subject

    if v14 then
        v14 = arg16._current_subject.EquippedItem

        if v14 then
            v14 = arg16._current_subject.EquippedItem:Get("IsAiming")
        end
    end

    local v15 = arg16._current_subject and arg16._current_subject.EquippedItem and arg16._current_subject.EquippedItem.Info.AimScopePercent
    local v16 = if not v14 then if not v14 then 1 else arg16._camera_sensitivity_ads_multiplier else if not v15 then if not v14 then 1 else arg16._camera_sensitivity_ads_multiplier else arg16._camera_sensitivity_ads_multiplier_scoped

    return arg16._camera_sensitivity * (v16 or 1)
end

function t.SetRotation(arg17, arg18) -- line: 189
    if
        arg17._current_subject
        and arg17._current_subject.Entity
        and arg17._current_subject.Entity:Get("IsFrozen")
    then
        return
    end

    arg17.Rotation = Vector2.new(
        math.clamp(arg18.X, -1.5690509975429023, 1.5690509975429023),
        arg18.Y
    )
end

function t.SetSubject(arg19, arg20) -- line: 198
    arg19._current_subject = arg20
    arg19.SubjectChanged:Fire()
end

function t.SetDuelSubject(arg21, arg22) -- line: 204
    arg21._current_duel_subject = arg22
end

function t.SetExternalFOVOffset(arg23, arg24, arg25) -- line: 208
    local ExternalFovOffsets = arg23._external_fov_offsets
    ExternalFovOffsets[arg24] = if arg25 ~= 0 then arg25 else nil
end

function t.SetThirdPersonOverride(arg26, arg27) -- line: 212
    arg26._third_person_override = arg27
    arg26.CameraState:VerifyPOV()
end

function t.SetIsEditingMobileButtons(arg28, arg29) -- line: 217
    arg28._is_editing_mobile_buttons = arg29
end

function t.Freeze(arg30, arg31) -- line: 221
    -- upvalues:
    --  [1] UserInputService (copy)

    if arg31 and not arg30.IsFrozen then
        UserInputService.MouseIconEnabled = true
        UserInputService.MouseBehavior = Enum.MouseBehavior.Default
    elseif not arg31 and arg30.IsFrozen then
        arg30._last_mouse_behavior = nil
    end

    arg30.IsFrozen = arg31
    arg30:Update(0)
end

function t.ApplyRotationDelta(arg32, arg33, arg34) -- line: 234
    local v20 = arg33 * (if arg34 then Vector2.one else arg32._inverted_identity_vector * arg32:GetCameraSensitivity() * Vector2.new(
        arg32._camera_sensitivity_y,
        arg32._camera_sensitivity_x
    ))
    arg32:SetRotation(arg32.Rotation + v20)
    arg32.RotationDeltaApplied:Fire(v20)
end

function t.ShakeOnce(arg35, ...) -- line: 242
    arg35._camera_shaker:ShakeOnce(...)
end

function t.Shake(arg36, ...) -- line: 246
    arg36._camera_shaker:Shake(...)
end

function t.MimicRotation(arg37, arg38) -- line: 251
    local v22, v23, _ = arg38:ToOrientation()
    arg37:SetRotation(Vector2.new(v22, v23))
end

function t.Update(arg39, arg40) -- line: 257
    -- upvalues:
    --  [1] CollectionService (copy)
    --  [2] UserInputService (copy)
    --  [3] ControlsController_m (copy)
    --  [4] CONSTANTS_m (copy)
    --  [5] UserInterfaceController_m (copy)
    --  [6] Quaternion_m (copy)
    --  [7] GameplayUtility_m (copy)
    --  [8] Utility_m (copy)

    if
        arg39.IsFrozen
        or arg39.CameraState:GetPublicState() == arg39.CameraState.States.CustomFreecam
    then
        return
    end

    local v27 = arg40 or 0
    local v28 = false

    if arg39._current_subject ~= nil then
        v28 = arg39._current_subject:IsAlive()

        if v28 then
            v28 = arg39._current_subject
        end
    end

    local v29 = v28
    local CameraState = arg39.CameraState

    if v29 then
        v29 = v28:IsActive()
    end

    CameraState:SetActive(v29)
    local v30 = arg39.CameraState:GetPublicState()
    local v31 = not v30

    if v31 then
        v31 = arg39._current_duel_subject

        if v31 then
            v31 = not arg39._current_duel_subject.LocalDueler
        end
    end

    local v32 = if v31 then arg39._current_duel_subject.Map and arg39._current_duel_subject.Map:GetSpectatePart() or CollectionService:GetTagged(
        "WaitingRoomSpectate"
    )[1] else nil

    if v32 then
        UserInputService.MouseIconEnabled = true
        UserInputService.MouseBehavior = Enum.MouseBehavior.Default
        workspace.CurrentCamera.CameraSubject = nil
        workspace.CurrentCamera.CameraType = Enum.CameraType.Scriptable
        workspace.CurrentCamera.CFrame = v32.CFrame

        return
    end

    v32 = v30 == arg39.CameraState.States.ThirdPersonUnlockedMouse or not v28 or not v28.IsLocalPlayer
    v31 = v30 and v30 ~= arg39.CameraState.States.ThirdPersonUnlockedMouse
    local v33 = v28 and v28.EquippedItem
    local v34 = arg39:_Modal()
    local v35 = v34

    if v35 then
        v35 = ControlsController_m.CurrentControls == "MouseKeyboard"
    end

    local v36 = if not v31 then Enum.MouseBehavior.Default else if v32 then Enum.MouseBehavior.Default else if ControlsController_m.CurrentControls ~= "MouseKeyboard" then Enum.MouseBehavior.Default else if v35 then Enum.MouseBehavior.Default else Enum.MouseBehavior.LockCenter or Enum.MouseBehavior.Default
    local CameraType = workspace.CurrentCamera.CameraType
    local CurrentCamera = workspace.CurrentCamera
    local v37 = v28 and v28.Entity and v28.Entity.Humanoid or nil
    CurrentCamera.CameraSubject = v37
    local CurrentCamera_1 = workspace.CurrentCamera
    v37 = v31 and Enum.CameraType.Scriptable or Enum.CameraType.Custom
    CurrentCamera_1.CameraType = v37
    v37 = v35
    local v38 = UserInputService

    if not v37 then
        v37 = not v33

        if not v37 then
            v37 = not v28

            if not v37 then
                v37 = not v28.IsLocalPlayer

                if not v37 then
                    v37 = if ControlsController_m.CurrentControls ~= "Touch" then arg39._crosshair_disabled and v32 or arg39:IsSubjectEmoting() else true
                end
            end
        end
    end

    v38.MouseIconEnabled = v37

    if v36 == Enum.MouseBehavior.LockCenter or v36 ~= arg39._last_mouse_behavior then
        UserInputService.MouseBehavior = v36
        arg39._last_mouse_behavior = v36
    end

    if not v31 then
        arg39:MimicRotation(
            workspace.CurrentCamera.CFrame.Rotation * CFrame.Angles(0.17453292519943295, 0, 0)
        )
    end

    if not v28 then
        workspace.CurrentCamera.FieldOfView = arg39._base_fov

        return
    end

    v36 = CFrame.new(v28.Entity.RootPart.Position)
    v35 = if CameraType ~= Enum.CameraType.Custom then false else if workspace.CurrentCamera.CameraType == Enum.CameraType.Custom then false else (workspace.CurrentCamera.CFrame.Position - v36.Position).Magnitude < 128

    if v35 then
        arg39._fov_gameplay_spring.Value = workspace.CurrentCamera.FieldOfView
    end

    local IsLocalPlayer = v28.IsLocalPlayer
    v32 = v28:IsSprinting()
    local v40 = v28:IsCrouching()
    v31 = v28:IsSliding()
    local v41 = v28:IsGrounded()
    local v42 = v28

    if v42 then
        v42 = v28.Entity

        if v42 then
            v42 = v28.Entity.Humanoid

            if v42 then
                v42 = if v28.Entity.Humanoid:GetState() ~= Enum.HumanoidStateType.Climbing then false else true
            end
        end
    end

    local v43 = v28:GetRotationCFrame()
    local v44 = v28:GetCameraSway() * 0.25
    local v45 = v28:GetCameraLean()
    local v46 = v28.Entity:GetClampedVelocity()
    local Magnitude = (v46 * Vector3.new(1, 0, 1)).Magnitude
    local v47 = if v33 and v33.Info.AimScopePercent then arg39._fov_offset_strength_scoped else arg39._fov_offset_strength
    arg39._fov_weapons_spring.Speed = 20 * v28:GetAimSpeed()
    arg39._fov_weapons_spring.Target = if v30 == arg39.CameraState.States.ThirdPersonUnlockedMouse then 0 else v28:GetFOVOffset() * v47
    local FovGameplaySpring = arg39._fov_gameplay_spring
    local BaseFov = arg39._base_fov
    local v49 = arg39._gameplay_fov_effects_enabled and math.max(
        0,
        Magnitude - CONSTANTS_m.BASE_WALKSPEED
    ) * 10 / CONSTANTS_m.BASE_WALKSPEED or 0
    FovGameplaySpring.Target = BaseFov + v49 + arg39:GetExternalFOVOffset()
    workspace.CurrentCamera.FieldOfView = arg39._fov_gameplay_spring.Value + arg39._fov_weapons_spring.Value * (arg39._fov_gameplay_spring.Value / 80)
    arg39._position_spring.Target = Vector3.new(0, 1.75, 0) + Vector3.new(
        0,
        if v31 then -3 else if not v42 then if not v40 then 0 else -2 else -2.5,
        0
    )

    if workspace.CurrentCamera.CameraType ~= Enum.CameraType.Scriptable then
        return
    end

    if v35 then
        arg39._position_spring.Value = workspace.CurrentCamera.CFrame:ToObjectSpace(v36):Inverse().Position * 0.5
    end

    if
        ControlsController_m.CurrentControls == "Gamepad"
        and not v34
        and not UserInterfaceController_m:IsPageOpen()
    then
        arg39:ApplyRotationDelta(
            arg39._gamepad_rotation_input * arg39:_GetFOVMultiplier() * v27 * 60
        )
    end

    local cframe_2 = CFrame.new(arg39._position_spring.Value)
    v42 = CFrame.identity
    v35 = CFrame.identity

    if v30 == arg39.CameraState.States.FirstPerson and not IsLocalPlayer then
        local v54 = if not v41 then 0 else 1
        arg39._bobbing_speed_spring.Target = Magnitude / CONSTANTS_m.BASE_WALKSPEED * v54 * 0.111
        arg39._bobbing_tick += arg39._bobbing_speed_spring.Value * v27 * 60
        arg39._bobbing_value_spring.Target = (math.abs((math.sin(arg39._bobbing_tick))) - 0.5) * (Magnitude / CONSTANTS_m.BASE_WALKSPEED) ^ 2 * (if v31 then 0 else 1) * 0.125
        local Value_1 = arg39._bobbing_value_spring.Value
        v42 = CFrame.new(0, Value_1, 0)
        v35 = CFrame.Angles(Value_1 * 0.08726646259971647, 0, 0)
    end

    local cframe_3 = CFrame.new(arg39._pov_spring.Value)
    local SwaySpring = arg39._sway_spring
    SwaySpring.Value = SwaySpring.Value + Vector2.new(v44.Y * 0.5, v44.X)
    local v56 = if not IsLocalPlayer then 0.025 else 0
    local v57 = arg39._sway_spring.Value * v56
    local cframe_4 = CFrame.Angles(v57.X, 0, v57.Y)
    local v58

    if IsLocalPlayer then
        v57 = CFrame.identity

        if not v57 then
            local Angles = CFrame.Angles
            v58 = math.sin(tick() * 0.23983 % 6.283185307179586) * 0.004363323129985824
            v57 = Angles(
                v58,
                math.sin(tick() * 0.372721 % 6.283185307179586) * 0.004363323129985824,
                math.sin(tick() * 0.43123 % 6.283185307179586) * 0.004363323129985824
            )
        end
    else
        local Angles_1 = CFrame.Angles
        v58 = math.sin(tick() * 0.23983 % 6.283185307179586) * 0.004363323129985824
        v57 = Angles_1(
            v58,
            math.sin(tick() * 0.372721 % 6.283185307179586) * 0.004363323129985824,
            math.sin(tick() * 0.43123 % 6.283185307179586) * 0.004363323129985824
        )
    end

    arg39._jump_spring.Target = v46.Y
    local v61 = if not IsLocalPlayer then 0.5 else 0
    local cframe_8 = CFrame.Angles(
        math.clamp(
            math.rad(-(arg39._jump_spring.Value / CONSTANTS_m.BASE_GRAVITY * v61) / 15),
            -0.7853981633974483,
            0.7853981633974483
        ),
        0,
        0
    )
    arg39._sliding_spring.Target = if v31 then 1 else 0
    local cframe_5 = CFrame.Angles(0, 0, -0.08726646259971647 * arg39._sliding_spring.Value)
    local LeaningSpring = arg39._leaning_spring
    v61 = if v30 ~= arg39.CameraState.States.FirstPerson then 0 else v45 or 0
    LeaningSpring.Target = v61
    local Value_4 = arg39._leaning_spring.Value
    local v63 = CFrame.new(Value_4 * Vector3.new(2, 0.1, 0)) * CFrame.Angles(
        0,
        0,
        Value_4 * -0.08726646259971647
    )
    local ViewmodelAnimationSpring = arg39._viewmodel_animation_spring
    local FromCFrame = Quaternion_m.fromCFrame
    local v64 = v33 and v33.ViewModel and v33.ViewModel:GetCameraOffset() or CFrame.identity
    ViewmodelAnimationSpring.Target = FromCFrame(v64)
    arg39.ViewModelOffsetCFrame = CFrame.identity
    local v65 = v42 * v43 * v35 * cframe_3 * cframe_4 * v57 * cframe_8 * cframe_5 * v63 * arg39.ViewModelOffsetCFrame * arg39.ShakeCFrame
    v57 = v36 * cframe_2 * v65
    v65 = v57.Position

    if tick() > arg39._next_collision_whitelist_fetch then
        arg39._next_collision_whitelist_fetch = tick() + 5
        arg39._collision_whitelist = GameplayUtility_m:GetRaycastWhitelist(v28:Get("EnvironmentID"))
    end

    local raycastResult = Utility_m:Raycast(
        v28.Entity.RootPart.Position,
        v57.Position,
        (v57.Position - v28.Entity.RootPart.Position).Magnitude,
        arg39._collision_whitelist,
        Enum.RaycastFilterType.Include
    )

    if raycastResult.Instance then
        v65 = v28.Entity.RootPart.Position + (v57.Position - v28.Entity.RootPart.Position).Unit * ((v28.Entity.RootPart.Position - raycastResult.Position).Magnitude - 0.5)
    end

    workspace.CurrentCamera.CFrame = CFrame.new(v65) * v57.Rotation
end

function t._UpdateSettings(arg41) -- line: 440
    -- upvalues:
    --  [1] PlayerDataController_m (copy)

    arg41._crosshair_disabled = PlayerDataController_m:GetSetting("Crosshair Disabled")
    arg41._base_fov = PlayerDataController_m:GetSetting("Camera FOV")
    arg41._gameplay_fov_effects_enabled = PlayerDataController_m:GetSetting("Camera FOV Effects")
    arg41._shake_enabled = PlayerDataController_m:GetSetting("Camera Shake")
    arg41._inverted_identity_vector = Vector2.new(
        if PlayerDataController_m:GetSetting("Camera Inverted Y") then -1 else 1,
        if PlayerDataController_m:GetSetting("Camera Inverted X") then -1 else 1
    )
    arg41._camera_sensitivity = PlayerDataController_m:GetSetting("Camera Sensitivity")
    arg41._camera_sensitivity_ads_multiplier = PlayerDataController_m:GetSetting(
        "Camera Sensitivity ADS"
    )
    arg41._camera_sensitivity_ads_multiplier_scoped = PlayerDataController_m:GetSetting(
        "Camera Sensitivity Scoped"
    )
    arg41._camera_sensitivity_x = PlayerDataController_m:GetSetting("Camera Sensitivity X")
    arg41._camera_sensitivity_y = PlayerDataController_m:GetSetting("Camera Sensitivity Y")
    arg41._fov_offset_strength = PlayerDataController_m:GetSetting("Camera Zoom Effects")
    arg41._fov_offset_strength_scoped = PlayerDataController_m:GetSetting(
        "Camera Zoom Effects Scoped"
    )
    arg41._gamepad_deadzone = PlayerDataController_m:GetSetting("Gamepad Deadzone")
end

function t._Modal(arg42) -- line: 456
    -- upvalues:
    --  [1] UserInterfaceController_m (copy)

    local v69 = arg42._current_duel_subject

    if v69 then
        v69 = arg42._current_duel_subject.DuelInterface

        if v69 then
            v69 = arg42._current_duel_subject.DuelInterface.Scoreboard:IsOpen()
        end
    end

    return v69 or UserInterfaceController_m:IsPageOpen() or arg42._open_playerlist_input_down
end

function t._GetFOVMultiplier(arg43) -- line: 462
    return workspace.CurrentCamera.FieldOfView < arg43._base_fov and workspace.CurrentCamera.FieldOfView / arg43._base_fov or 1
end

function t._InputChanged(arg44, arg45, arg46) -- line: 466
    -- upvalues:
    --  [1] ControlsController_m (copy)
    --  [2] t_1 (copy)
    --  [3] v2 (copy)

    if
        arg46
        or arg44._is_editing_mobile_buttons
        or ControlsController_m.CurrentControls == "MouseKeyboard" and arg45.UserInputType ~= Enum.UserInputType.MouseMovement and arg45.UserInputType ~= Enum.UserInputType.MouseWheel
    then
        return
    end

    local v72 = t_1[ControlsController_m.CurrentControls]

    if
        ControlsController_m.CurrentControls == "MouseKeyboard"
        or ControlsController_m.CurrentControls == "Touch"
    then
        arg44:ApplyRotationDelta(
            Vector2.new(arg45.Delta.Y, arg45.Delta.X) * v2 * v72 * arg44:_GetFOVMultiplier() * -1
        )

        return
    end

    if
        ControlsController_m.CurrentControls == "Gamepad"
        and (arg45.KeyCode == Enum.KeyCode.Thumbstick1 or arg45.KeyCode == Enum.KeyCode.Thumbstick2)
    then
        local maximum = math.max(
            0,
            (Vector2.new(arg45.Position.X, arg45.Position.Y).Magnitude - arg44._gamepad_deadzone) / (1 - arg44._gamepad_deadzone)
        )
        local v75 = arg45.Position.X * maximum
        local v77 = math.floor(arg45.Position.Y * maximum * 10 + 0.5) * v72
        arg44._gamepad_rotation_input = Vector2.new(v77, -math.floor(v75 * 10 + 0.5) * v72) * 0.01
    end
end

function t._Setup(arg47) -- line: 495
    -- upvalues:
    --  [1] VRService (copy)
    --  [2] CameraShaker_m (copy)

    if VRService:GetUserCFrameEnabled(Enum.UserCFrame.RightHand) then
        arg47.VRCameraCFrame = VRService:GetUserCFrame(Enum.UserCFrame.RightHand)
    end

    arg47._camera_shaker = CameraShaker_m.new(Enum.RenderPriority.Camera.Value + 1, function(arg48) -- line: 500
        -- upvalues:
        --  [1] arg47 (copy)

        local v78 = arg47
        v78.ShakeCFrame = arg47._shake_enabled and arg48 or CFrame.identity
    end)
    arg47._camera_shaker:Start()
end

function t._Init(arg49) -- line: 507
    -- upvalues:
    --  [1] UserInputService (copy)
    --  [2] Utility_m (copy)
    --  [3] InputLibrary_m (copy)
    --  [4] SettingsController_m (copy)
    --  [5] PlayerDataController_m (copy)
    --  [6] VRService (copy)
    --  [7] RunService (copy)
    --  [8] Value (copy)

    arg49.StateChanged:Connect(function() -- line: 508
        -- upvalues:
        --  [1] arg49 (copy)

        local v80 = arg49.CameraState:GetPublicState()
        arg49._pov_spring.Target = if v80 == arg49.CameraState.States.ThirdPerson then Vector3.new(3, 1.5, 7.5) else if v80 ~= arg49.CameraState.States.ThirdPersonMirrored then if v80 ~= arg49.CameraState.States.ThirdPersonUnlockedMouse then Vector3.new(0, 0, 0) else Vector3.new(0, 3, 10) else Vector3.new(-3, 1.5, 7.5)
    end)
    arg49.CameraState.StateChanged:Connect(function(old, new) -- line: 517
        -- upvalues:
        --  [1] arg49 (copy)

        arg49.StateChanged:Fire(old, new)

        if not old or not new then
            arg49.ActiveStateChanged:Fire(old, new)
        end

        if
            old == arg49.CameraState.States.CustomFreecam
            or new == arg49.CameraState.States.CustomFreecam
        then
            arg49.CustomFreecamStateChanged:Fire(old, new)
        end

        local index = table.find(arg49.CameraState.POVStates, old)
        local index_1 = table.find(arg49.CameraState.POVStates, new)

        if index or index_1 then
            arg49.POVStateChanged:Fire(old, new, index and index_1)
        end
    end)
    UserInputService.InputBegan:Connect(function(input: InputObject, gameProcessedEvent: boolean) -- line: 536
        -- upvalues:
        --  [1] arg49 (copy)
        --  [2] Utility_m (ref)
        --  [3] InputLibrary_m (ref)
        --  [4] SettingsController_m (ref)
        --  [5] PlayerDataController_m (ref)

        local v82 = arg49.CameraState:GetPublicState()

        if
            not (if v82 == arg49.CameraState.States.CustomFreecam then Utility_m:IsTextBoxFocused() else gameProcessedEvent)
            and InputLibrary_m:InputIs(input, "HideHUD")
        then
            SettingsController_m:ChangeSetting(
                "Hide HUD",
                not PlayerDataController_m:GetSetting("Hide HUD")
            )
        end

        if arg49.IsFrozen or not v82 then
            return
        end

        if not gameProcessedEvent and InputLibrary_m:InputIs(input, "SwitchCameraPOV") then
            arg49.CameraState:TogglePOV()

            return
        end

        if not gameProcessedEvent and InputLibrary_m:InputIs(input, "OpenPlayerList") then
            arg49._open_playerlist_input_down = true
        end
    end)
    UserInputService.InputChanged:Connect(function(...) -- line: 556
        -- upvalues:
        --  [1] arg49 (copy)

        if arg49.IsFrozen or not arg49.CameraState:GetPublicState() then
            return
        end

        arg49:_InputChanged(...)
    end)
    UserInputService.InputEnded:Connect(function(arg54, _) -- line: 564
        -- upvalues:
        --  [1] InputLibrary_m (ref)
        --  [2] arg49 (copy)

        if InputLibrary_m:InputIs(arg54, "OpenPlayerList") then
            arg49._open_playerlist_input_down = false
        end
    end)
    VRService.UserCFrameChanged:Connect(function(_, _) -- line: 570
        -- upvalues:
        --  [1] arg49 (copy)
        --  [2] VRService (ref)

        if arg49.IsFrozen or not arg49.CameraState:GetPublicState() then
            return
        end

        local v85 = VRService:GetUserCFrameEnabled(Enum.UserCFrame.RightHand)

        if v85 then
            v85 = VRService:GetUserCFrame(Enum.UserCFrame.RightHand)
        end

        local v86 = VRService:GetUserCFrameEnabled(Enum.UserCFrame.Head)

        if v86 then
            v86 = VRService:GetUserCFrame(Enum.UserCFrame.Head)
        end

        local v87 = v86 or v85 or CFrame.identity
        local v88 = v85 or v86 or CFrame.identity
        arg49.VRCameraCFrame = CFrame.new(v87.Position) * (v88 - v88.Position)
    end)
    RunService:BindToRenderStep("CameraController", Value, function(arg58) -- line: 583
        -- upvalues:
        --  [1] arg49 (copy)

        arg49._last_dt = arg58
        arg49:Update(arg58)
    end)
    PlayerDataController_m:GetSettingChangedSignal("Crosshair Disabled"):Connect(function() -- line: 588
        -- upvalues:
        --  [1] arg49 (copy)

        arg49:_UpdateSettings()
    end)
    PlayerDataController_m:GetSettingChangedSignal("Camera FOV"):Connect(function() -- line: 592
        -- upvalues:
        --  [1] arg49 (copy)

        arg49:_UpdateSettings()
    end)
    PlayerDataController_m:GetSettingChangedSignal("Camera FOV Effects"):Connect(function() -- line: 596
        -- upvalues:
        --  [1] arg49 (copy)

        arg49:_UpdateSettings()
    end)
    PlayerDataController_m:GetSettingChangedSignal("Camera Inverted X"):Connect(function() -- line: 600
        -- upvalues:
        --  [1] arg49 (copy)

        arg49:_UpdateSettings()
    end)
    PlayerDataController_m:GetSettingChangedSignal("Camera Inverted Y"):Connect(function() -- line: 604
        -- upvalues:
        --  [1] arg49 (copy)

        arg49:_UpdateSettings()
    end)
    PlayerDataController_m:GetSettingChangedSignal("Camera Shake"):Connect(function() -- line: 608
        -- upvalues:
        --  [1] arg49 (copy)

        arg49:_UpdateSettings()
    end)
    PlayerDataController_m:GetSettingChangedSignal("Camera Sensitivity"):Connect(function() -- line: 612
        -- upvalues:
        --  [1] arg49 (copy)

        arg49:_UpdateSettings()
    end)
    PlayerDataController_m:GetSettingChangedSignal("Camera Sensitivity ADS"):Connect(function() -- line: 616
        -- upvalues:
        --  [1] arg49 (copy)

        arg49:_UpdateSettings()
    end)
    PlayerDataController_m:GetSettingChangedSignal("Camera Zoom Effects"):Connect(function() -- line: 620
        -- upvalues:
        --  [1] arg49 (copy)

        arg49:_UpdateSettings()
    end)
    PlayerDataController_m:GetSettingChangedSignal("Camera Zoom Effects Scoped"):Connect(function() -- line: 624
        -- upvalues:
        --  [1] arg49 (copy)

        arg49:_UpdateSettings()
    end)
    PlayerDataController_m:GetSettingChangedSignal("Gamepad Deadzone"):Connect(function() -- line: 628
        -- upvalues:
        --  [1] arg49 (copy)

        arg49:_UpdateSettings()
    end)
    PlayerDataController_m:GetSettingChangedSignal("Camera Sensitivity X"):Connect(function() -- line: 632
        -- upvalues:
        --  [1] arg49 (copy)

        arg49:_UpdateSettings()
    end)
    PlayerDataController_m:GetSettingChangedSignal("Camera Sensitivity Y"):Connect(function() -- line: 636
        -- upvalues:
        --  [1] arg49 (copy)

        arg49:_UpdateSettings()
    end)
    PlayerDataController_m:GetSettingChangedSignal("Camera Sensitivity Scoped"):Connect(function() -- line: 640
        -- upvalues:
        --  [1] arg49 (copy)

        arg49:_UpdateSettings()
    end)
    PlayerDataController_m.SettingsSliderChanged:Connect(function(arg59, arg60) -- line: 644
        -- upvalues:
        --  [1] arg49 (copy)

        if arg59 == "Camera FOV" then
            arg49._base_fov = arg60
        end
    end)
    arg49:_Setup()
    arg49:_UpdateSettings()
end

return t._new()
