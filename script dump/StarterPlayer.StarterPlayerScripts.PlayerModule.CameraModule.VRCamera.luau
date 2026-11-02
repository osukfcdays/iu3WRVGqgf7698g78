local Players = game:GetService("Players")
local VRService = game:GetService("VRService")
local _ = UserSettings():GetService("UserGameSettings")
local _ = require(script.Parent:WaitForChild("CameraInput"))
local _ = require(script.Parent:WaitForChild("CameraUtils"))
local VRCameraTeleportDetector_m = require(script.Parent:WaitForChild("VRCameraTeleportDetector"))
local FlagUtil_m = require(
    script.Parent.Parent:WaitForChild("CommonUtils"):WaitForChild("FlagUtil")
)
local UserVRRecenterOnExternalTeleport = FlagUtil_m.getUserFlag("UserVRRecenterOnExternalTeleport")
local UserFixVRImmersionAutoRotate = FlagUtil_m.getUserFlag("UserFixVRImmersionAutoRotate")
local VRBaseCamera_m = require(script.Parent:WaitForChild("VRBaseCamera"))
local t = setmetatable({}, VRBaseCamera_m)
t.__index = t

function t.new() -- line: 34
    -- upvalues:
    --  [1] VRBaseCamera_m (copy)
    --  [2] t (copy)
    --  [3] Players (copy)

    local t_1 = setmetatable(VRBaseCamera_m.new(), t)
    t_1.lastUpdate = tick()
    t_1.focusOffset = CFrame.new()
    t_1:Reset()
    t_1.controlModule = require(
        Players.LocalPlayer:WaitForChild("PlayerScripts").PlayerModule:WaitForChild("ControlModule")
    )
    t_1.savedAutoRotate = true
    t_1.autoRotateOverridden = false

    return t_1
end

function t.Reset(arg1) -- line: 48
    -- upvalues:
    --  [1] VRBaseCamera_m (copy)

    arg1.needsReset = true
    arg1.needsBlackout = true
    arg1.motionDetTime = 0
    arg1.blackOutTimer = 0
    arg1.lastCameraResetPosition = nil
    VRBaseCamera_m.Reset(arg1)
end

function t.Update(arg2, arg3) -- line: 57
    -- upvalues:
    --  [1] Players (copy)
    --  [2] VRService (copy)

    local CurrentCamera = workspace.CurrentCamera
    local v7 = CurrentCamera.CFrame
    local v8 = CurrentCamera.Focus
    local LocalPlayer = Players.LocalPlayer
    local _ = arg2:GetHumanoid()
    local _ = CurrentCamera.CameraSubject

    if arg2.lastUpdate == nil or arg3 > 1 then
        arg2.lastCameraTransform = nil
    end

    arg2:UpdateFadeFromBlack(arg3)
    local LastSubjectPosition = arg2.lastSubjectPosition
    local v10 = arg2:GetSubjectPosition()

    if arg2.needsBlackout then
        arg2:StartFadeFromBlack()
        arg2.blackOutTimer += math.clamp(arg3, 0.0001, 0.1)

        if arg2.blackOutTimer > 0.1 and game:IsLoaded() then
            arg2.needsBlackout = false
            arg2.needsReset = true
        end
    end

    if v10 and LocalPlayer and CurrentCamera then
        v8 = arg2:GetVRFocus(v10, arg3)

        if arg2:IsInFirstPerson() then
            if VRService.AvatarGestures then
                local v11, v12 = arg2:UpdateImmersionCamera(
                    arg3,
                    v7,
                    v8,
                    LastSubjectPosition,
                    v10
                )
                v7 = v11
                v8 = v12
            else
                local v13, v14 = arg2:UpdateFirstPersonTransform(
                    arg3,
                    v7,
                    v8,
                    LastSubjectPosition,
                    v10
                )
                v7 = v13
                v8 = v14
            end
        elseif VRService.ThirdPersonFollowCamEnabled then
            local v15, v16 = arg2:UpdateThirdPersonFollowTransform(
                arg3,
                v7,
                v8,
                LastSubjectPosition,
                v10
            )
            v7 = v15
            v8 = v16
        else
            local v17, v18 = arg2:UpdateThirdPersonComfortTransform(
                arg3,
                v7,
                v8,
                LastSubjectPosition,
                v10
            )
            v7 = v17
            v8 = v18
        end

        arg2.lastCameraTransform = v7
        arg2.lastCameraFocus = v8
    end

    arg2.lastUpdate = tick()

    return v7, v8
end

function t.GetAvatarFeetWorldYValue(_) -- line: 118
    local CameraSubject_1 = workspace.CurrentCamera.CameraSubject

    if not CameraSubject_1 then
        return nil
    end

    if CameraSubject_1:IsA("Humanoid") and CameraSubject_1.RootPart then
        local RootPart = CameraSubject_1.RootPart

        return RootPart.Position.Y - RootPart.Size.Y / 2 - CameraSubject_1.HipHeight
    end

    return nil
end

function t.UpdateFirstPersonTransform(
    arg5,
    arg6,
    _,
    arg8,
    _,
    _
) -- line: 133
    if arg5.needsReset then
        arg5:StartFadeFromBlack()
        arg5.needsReset = false
    end

    local P = arg8.p
    local v19 = arg5:GetCameraLookVector()
    local Unit = Vector3.new(v19.X, 0, v19.Z).Unit
    local v21 = arg5:getRotation(arg6)
    local v22 = arg5:CalculateNewLookVectorFromArg(Unit, Vector2.new(v21, 0))

    return CFrame.new(P - 0.5 * v22, P), arg8
end

function t.UpdateImmersionCamera(
    arg11,
    arg12,
    arg13,
    _,
    arg15,
    arg16
) -- line: 153
    -- upvalues:
    --  [1] Players (copy)
    --  [2] UserVRRecenterOnExternalTeleport (copy)
    --  [3] UserFixVRImmersionAutoRotate (copy)
    --  [4] VRService (copy)
    --  [5] VRCameraTeleportDetector_m (copy)

    local v23 = arg11:GetSubjectCFrame()
    local CurrentCamera_1 = workspace.CurrentCamera
    local Character = Players.LocalPlayer.Character
    local v24 = arg11:GetHumanoid()

    if not v24 then
        return CurrentCamera_1.CFrame, CurrentCamera_1.Focus
    end

    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")

    if not HumanoidRootPart then
        return CurrentCamera_1.CFrame, CurrentCamera_1.Focus
    end

    local v25 = if UserVRRecenterOnExternalTeleport then if arg15 then Vector3.new(
        arg16.X - arg15.X,
        0,
        arg16.Z - arg15.Z
    ).Magnitude else 0 else nil
    arg11.characterOrientation = HumanoidRootPart:FindFirstChild("CharacterAlignOrientation")

    if not arg11.characterOrientation then
        local RootAttachment = HumanoidRootPart:FindFirstChild("RootAttachment")

        if not RootAttachment then
            return
        end

        arg11.characterOrientation = Instance.new("AlignOrientation")
        arg11.characterOrientation.Name = "CharacterAlignOrientation"
        arg11.characterOrientation.Mode = Enum.OrientationAlignmentMode.OneAttachment
        arg11.characterOrientation.Attachment0 = RootAttachment
        arg11.characterOrientation.RigidityEnabled = true
        arg11.characterOrientation.Parent = HumanoidRootPart
    end

    if arg11.characterOrientation.Enabled == false then
        arg11.characterOrientation.Enabled = true
    end

    if arg11.needsReset then
        arg11.needsReset = false

        if UserFixVRImmersionAutoRotate then
            arg11:updateImmersionAutoRotate()
        else
            arg11.savedAutoRotate = v24.AutoRotate
            v24.AutoRotate = false
        end

        if UserVRRecenterOnExternalTeleport then
            VRService:RecenterUserHeadCFrame()
            arg11.lastTeleportRecenter = tick()
        end

        arg11:StartFadeFromBlack()
        arg13 = v23
    elseif v24.Sit then
        arg13 = v23
    else
        arg11.characterOrientation.CFrame = CurrentCamera_1.CFrame * arg11.controlModule:GetEstimatedVRTorsoFrame()

        if arg11.controlModule.inputMoveVector.Magnitude > 0 then
            arg11.motionDetTime = 0.1
        end

        if arg11.controlModule.inputMoveVector.Magnitude > 0 or arg11.motionDetTime > 0 then
            arg11.motionDetTime -= arg12
            local v27 = VRService:GetUserCFrame(Enum.UserCFrame.Head)
            local HumanoidRootPart_1 = Character.HumanoidRootPart
            local v29 = CurrentCamera_1.CFrame * (v27.Rotation + v27.Position * CurrentCamera_1.HeadScale) * CFrame.new(
                0,
                -0.7 * HumanoidRootPart_1.Size.Y / 2,
                0
            )
            local LookVector = HumanoidRootPart_1.CFrame.LookVector
            local v30 = arg16 - (v29 - Vector3.new(LookVector.X, 0, LookVector.Z).Unit * HumanoidRootPart_1.Size.Y * 0.125).Position + CurrentCamera_1.CFrame.Position
            arg13 = CurrentCamera_1.CFrame.Rotation + Vector3.new(v30.X, arg16.Y, v30.Z)
        elseif
            UserVRRecenterOnExternalTeleport
            and VRCameraTeleportDetector_m.shouldRecenter(
                arg11.prevSubjStep,
                v25,
                arg11.lastTeleportRecenter,
                tick()
            )
        then
            local v31 = VRService:GetUserCFrame(Enum.UserCFrame.Head)
            local HumanoidRootPart_2 = Character.HumanoidRootPart
            local v33 = CurrentCamera_1.CFrame * (v31.Rotation + v31.Position * CurrentCamera_1.HeadScale) * CFrame.new(
                0,
                -0.7 * HumanoidRootPart_2.Size.Y / 2,
                0
            )
            local LookVector_1 = HumanoidRootPart_2.CFrame.LookVector
            local v34 = arg16 - (v33 - Vector3.new(LookVector_1.X, 0, LookVector_1.Z).Unit * HumanoidRootPart_2.Size.Y * 0.125).Position + CurrentCamera_1.CFrame.Position
            arg13 = CurrentCamera_1.CFrame.Rotation + Vector3.new(v34.X, arg16.Y, v34.Z)
            VRService:RecenterUserHeadCFrame()
            arg11:StartFadeFromBlack()
            arg11.lastTeleportRecenter = tick()
        else
            arg13 = CurrentCamera_1.CFrame.Rotation + Vector3.new(
                CurrentCamera_1.CFrame.Position.X,
                arg16.Y,
                CurrentCamera_1.CFrame.Position.Z
            )
        end

        local v35 = arg11:getRotation(arg12)

        if math.abs(v35) > 0 then
            local v36 = VRService:GetUserCFrame(Enum.UserCFrame.Head)
            local v37 = v36.Rotation + v36.Position * CurrentCamera_1.HeadScale
            local v38 = arg13 * v37
            arg13 = CFrame.new(v38.Position) * CFrame.Angles(0, -math.rad(v35 * 90), 0) * v38.Rotation * v37:Inverse()
        end
    end

    if UserVRRecenterOnExternalTeleport then
        arg11.prevSubjStep = v25
    end

    return arg13, arg13 * CFrame.new(0, 0, -0.5)
end

function t.UpdateThirdPersonComfortTransform(
    arg17,
    arg18,
    arg19,
    arg20,
    arg21,
    arg22
) -- line: 305
    -- upvalues:
    --  [1] Players (copy)
    --  [2] VRService (copy)

    local v40 = arg17:GetCameraToSubjectDistance()

    if v40 < 0.5 then
        v40 = 0.5
    end

    if arg21 ~= nil and arg17.lastCameraFocus ~= nil then
        local _ = Players.LocalPlayer
        local v41 = arg21 - arg22
        local v42 = arg17.controlModule:GetMoveVector()
        local v43 = if not (v41.magnitude > 0.01) then v42.magnitude > 0.01 and true else true

        if v43 then
            arg17.motionDetTime = 0.1
        end

        arg17.motionDetTime -= arg18

        if arg17.motionDetTime > 0 then
            v43 = true
        end

        if v43 and not arg17.needsReset then
            local LastCameraFocus = arg17.lastCameraFocus
            arg17.VRCameraFocusFrozen = true

            return arg19, LastCameraFocus
        end

        v42 = arg17.lastCameraResetPosition == nil or (arg22 - arg17.lastCameraResetPosition).Magnitude > 1
        local v44 = arg17:getRotation(arg18)

        if math.abs(v44) > 0 then
            arg19 = arg20 * CFrame.Angles(0, -v44, 0) * arg20:ToObjectSpace(arg19)
        end

        if if not arg17.VRCameraFocusFrozen then arg17.needsReset else v42 or arg17.needsReset then
            VRService:RecenterUserHeadCFrame()
            arg17.VRCameraFocusFrozen = false
            arg17.needsReset = false
            arg17.lastCameraResetPosition = arg22
            arg17:ResetZoom()
            arg17:StartFadeFromBlack()
            local v46 = arg17:GetHumanoid()
            local v47 = v46.Torso and v46.Torso.CFrame.lookVector or Vector3.new(1, 0, 0)
            v47 = arg20.Position - Vector3.new(v47.X, 0, v47.Z) * v40
            arg19 = CFrame.new(v47, (Vector3.new(arg20.Position.X, v47.Y, arg20.Position.Z)))
        end
    end

    return arg19, arg20
end

function t.UpdateThirdPersonFollowTransform(
    arg23,
    arg24,
    arg25,
    _,
    arg27,
    arg28
) -- line: 372
    -- upvalues:
    --  [1] VRService (copy)
    --  [2] Players (copy)

    local CurrentCamera_2 = workspace.CurrentCamera
    local v49 = arg23:GetCameraToSubjectDistance()
    local v50 = arg23:GetVRFocus(arg28, arg24)

    if arg23.needsReset then
        arg23.needsReset = false
        VRService:RecenterUserHeadCFrame()
        arg23:ResetZoom()
        arg23:StartFadeFromBlack()
    end

    if arg23.recentered then
        local v51 = arg23:GetSubjectCFrame()

        if not v51 then
            return CurrentCamera_2.CFrame, CurrentCamera_2.Focus
        end

        arg25 = v50 * v51.Rotation * CFrame.new(0, 0, v49)
        arg23.focusOffset = v50:ToObjectSpace(arg25)
        local v52
        arg23.recentered, v52 = false, arg25

        return v52, v50
    else
        local v53 = v50:ToWorldSpace(arg23.focusOffset)
        local _ = Players.LocalPlayer
        local v54 = arg27 - arg28
        local ControlModule = arg23.controlModule
        local v55 = ControlModule:GetMoveVector()
        local LookVector_2, cframe_1
        local v56, v57

        if not (v54.magnitude > 0.01) then
            if v55.magnitude > 0 then
                v56 = ControlModule:GetEstimatedVRTorsoFrame()
                v57 = CurrentCamera_2.CFrame * (v56.Rotation + v56.Position * CurrentCamera_2.HeadScale)
                LookVector_2 = v57.LookVector
                cframe_1 = CFrame.new(
                    CurrentCamera_2.CFrame.Position + (v50.Position - Vector3.new(
                        LookVector_2.X,
                        0,
                        LookVector_2.Z
                    ).Unit * v49) - v57.Position
                )
                arg25 = v53:Lerp(cframe_1 * v53.Rotation, 0.01)
            else
                arg25 = v53
            end
        else
            v56 = ControlModule:GetEstimatedVRTorsoFrame()
            v57 = CurrentCamera_2.CFrame * (v56.Rotation + v56.Position * CurrentCamera_2.HeadScale)
            LookVector_2 = v57.LookVector
            cframe_1 = CFrame.new(
                CurrentCamera_2.CFrame.Position + (v50.Position - Vector3.new(
                    LookVector_2.X,
                    0,
                    LookVector_2.Z
                ).Unit * v49) - v57.Position
            )
            arg25 = v53:Lerp(cframe_1 * v53.Rotation, 0.01)
        end

        local v59 = arg23:getRotation(arg24)

        if math.abs(v59) > 0 then
            arg25 = v50 * CFrame.Angles(0, -v59, 0) * v50:ToObjectSpace(arg25)
        end

        arg23.focusOffset = v50:ToObjectSpace(arg25)

        return arg25, arg25 * CFrame.new(0, 0, -v49)
    end
end

function t.updateImmersionAutoRotate(arg29) -- line: 447
    -- upvalues:
    --  [1] VRService (copy)

    local v61 = arg29:GetHumanoid()

    if not v61 then
        return
    end

    if arg29:IsInFirstPerson() and VRService.AvatarGestures then
        if not arg29.autoRotateOverridden then
            arg29.savedAutoRotate = v61.AutoRotate
            arg29.autoRotateOverridden = true
        end

        v61.AutoRotate = false

        return
    end

    if arg29.autoRotateOverridden then
        v61.AutoRotate = arg29.savedAutoRotate
        arg29.autoRotateOverridden = false
    end
end

function t.OnEnabledChanged(arg30) -- line: 467
    -- upvalues:
    --  [1] VRBaseCamera_m (copy)
    --  [2] UserFixVRImmersionAutoRotate (copy)
    --  [3] VRService (copy)

    VRBaseCamera_m.OnEnabledChanged(arg30)

    if not UserFixVRImmersionAutoRotate then
        return
    end

    if arg30.enabled then
        if not arg30.avatarGesturesChangedConn then
            arg30.avatarGesturesChangedConn = VRService:GetPropertyChangedSignal("AvatarGestures"):Connect(
                function() -- line: 476
                    -- upvalues:
                    --  [1] arg30 (copy)

                    arg30:updateImmersionAutoRotate()
                end
            )

            return
        end
    elseif arg30.avatarGesturesChangedConn then
        arg30.avatarGesturesChangedConn:Disconnect()
        arg30.avatarGesturesChangedConn = nil
    end
end

function t.LeaveFirstPerson(arg31) -- line: 486
    -- upvalues:
    --  [1] VRBaseCamera_m (copy)
    --  [2] UserFixVRImmersionAutoRotate (copy)

    VRBaseCamera_m.LeaveFirstPerson(arg31)
    arg31.needsReset = true

    if arg31.VRBlur then
        arg31.VRBlur.Visible = false
    end

    if arg31.characterOrientation then
        arg31.characterOrientation.Enabled = false
    end

    if UserFixVRImmersionAutoRotate then
        arg31:updateImmersionAutoRotate()

        return
    end

    local v62 = arg31:GetHumanoid()

    if v62 then
        v62.AutoRotate = arg31.savedAutoRotate
    end
end

return t
