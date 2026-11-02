local Players = game:GetService("Players")
local _ = game:GetService("UserInputService")
local VRService = game:GetService("VRService")
local UserGameSettings = UserSettings():GetService("UserGameSettings")
local CommonUtils = script.Parent.Parent:WaitForChild("CommonUtils")
local ConnectionUtil_m = require(CommonUtils:WaitForChild("ConnectionUtil"))
local _ = require(CommonUtils:WaitForChild("FlagUtil"))
local CameraUtils_m = require(script.Parent:WaitForChild("CameraUtils"))
local ZoomController_m = require(script.Parent:WaitForChild("ZoomController"))
local CameraToggleStateController_m = require(
    script.Parent:WaitForChild("CameraToggleStateController")
)
local CameraInput_m = require(script.Parent:WaitForChild("CameraInput"))
local CameraUI_m = require(script.Parent:WaitForChild("CameraUI"))
local LocalPlayer = Players.LocalPlayer
local _ = Vector2.new(0, 0)
local _ = {
    CHARACTER_ADDED = "CHARACTER_ADDED",
    CAMERA_MODE_CHANGED = "CAMERA_MODE_CHANGED",
    CAMERA_MIN_DISTANCE_CHANGED = "CAMERA_MIN_DISTANCE_CHANGED",
    CAMERA_MAX_DISTANCE_CHANGED = "CAMERA_MAX_DISTANCE_CHANGED"
}
local t_1 = {}
t_1.__index = t_1

function t_1.new() -- line: 70
    -- upvalues:
    --  [1] t_1 (copy)
    --  [2] ConnectionUtil_m (copy)
    --  [3] LocalPlayer (copy)
    --  [4] UserGameSettings (copy)

    local t_2 = setmetatable({}, t_1)
    t_2._connections = ConnectionUtil_m.new()
    t_2.gamepadZoomLevels = { 0, 10, 20 }
    t_2.FIRST_PERSON_DISTANCE_THRESHOLD = 1
    t_2.cameraType = nil
    t_2.cameraMovementMode = nil
    t_2.lastCameraTransform = nil
    t_2.lastUserPanCamera = tick()
    t_2.humanoidRootPart = nil
    t_2.humanoidCache = {}
    t_2.lastSubject = nil
    t_2.lastSubjectPosition = Vector3.new(0, 5, 0)
    t_2.lastSubjectCFrame = CFrame.new(t_2.lastSubjectPosition)
    t_2.currentSubjectDistance = math.clamp(
        12.5,
        LocalPlayer.CameraMinZoomDistance,
        LocalPlayer.CameraMaxZoomDistance
    )
    t_2.inFirstPerson = false
    t_2.inMouseLockedMode = false
    t_2.resetCameraAngle = true
    t_2.enabled = false
    t_2.cameraChangedConn = nil
    t_2.shouldUseVRRotation = false
    t_2.VRRotationIntensityAvailable = false
    t_2.lastVRRotationIntensityCheckTime = 0
    t_2.lastVRRotationTime = 0
    t_2.vrRotateKeyCooldown = {}
    t_2.cameraTranslationConstraints = Vector3.new(1, 1, 1)
    t_2.humanoidJumpOrigin = nil
    t_2.trackingHumanoid = nil
    t_2.cameraFrozen = false
    t_2.subjectStateChangedConn = nil
    t_2.gamepadZoomPressConnection = nil
    t_2.mouseLockOffset = Vector3.new(0, 0, 0)
    UserGameSettings:SetCameraYInvertVisible()
    UserGameSettings:SetGamepadCameraSensitivityVisible()

    return t_2
end

function t_1.GetModuleName(_) -- line: 130
    return "BaseCamera"
end

function t_1._setUpConfigurations(arg2) -- line: 134
    -- upvalues:
    --  [1] LocalPlayer (copy)

    arg2._connections:trackConnection("CHARACTER_ADDED", LocalPlayer.CharacterAdded:Connect(function(
        character: Model
    ) -- line: 135
        -- upvalues:
        --  [1] arg2 (copy)

        arg2:OnCharacterAdded(character)
    end))
    arg2.humanoidRootPart = nil
    arg2._connections:trackConnection("CAMERA_MODE_CHANGED", LocalPlayer:GetPropertyChangedSignal(
        "CameraMode"
    ):Connect(function() -- line: 140
        -- upvalues:
        --  [1] arg2 (copy)

        arg2:OnPlayerCameraPropertyChange()
    end))
    arg2._connections:trackConnection("CAMERA_MIN_DISTANCE_CHANGED", LocalPlayer:GetPropertyChangedSignal(
        "CameraMinZoomDistance"
    ):Connect(function() -- line: 143
        -- upvalues:
        --  [1] arg2 (copy)

        arg2:OnPlayerCameraPropertyChange()
    end))
    arg2._connections:trackConnection("CAMERA_MAX_DISTANCE_CHANGED", LocalPlayer:GetPropertyChangedSignal(
        "CameraMaxZoomDistance"
    ):Connect(function() -- line: 146
        -- upvalues:
        --  [1] arg2 (copy)

        arg2:OnPlayerCameraPropertyChange()
    end))
    arg2:OnPlayerCameraPropertyChange()
end

function t_1.OnCharacterAdded(arg4, _) -- line: 152
    arg4.resetCameraAngle = arg4.resetCameraAngle or arg4:GetEnabled()
    arg4.humanoidRootPart = nil
end

function t_1.GetHumanoidRootPart(arg6) -- line: 159
    -- upvalues:
    --  [1] LocalPlayer (copy)

    if not arg6.humanoidRootPart and LocalPlayer.Character then
        local Humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")

        if Humanoid then
            arg6.humanoidRootPart = Humanoid.RootPart
        end
    end

    return arg6.humanoidRootPart
end

function t_1.GetBodyPartToFollow(_: table, u1: userdata, _: boolean) -- line: 171
    if u1:GetState() == Enum.HumanoidStateType.Dead then
        local Parent = u1.Parent

        if Parent and Parent:IsA("Model") then
            return Parent:FindFirstChild("Head") or u1.RootPart
        end
    end

    return u1.RootPart
end

function t_1.GetSubjectCFrame(arg7) -- line: 183
    local v10 = arg7.lastSubjectCFrame
    local v11 = workspace.CurrentCamera
    local v12 = v11

    if v12 then
        v12 = v11.CameraSubject
    end

    if not v12 then
        return v10
    end

    if v12:IsA("Humanoid") then
        v11 = if v12:GetState() ~= Enum.HumanoidStateType.Dead then false else true
        local v13 = v12.CameraOffset

        if arg7:GetIsMouseLocked() then
            v13 = Vector3.new()
        end

        local v14 = v12.RootPart

        if v11 and v12.Parent and v12.Parent:IsA("Model") then
            v14 = v12.Parent:FindFirstChild("Head") or v14
        end

        if v14 and v14:IsA("BasePart") then
            local v15

            if v12.RigType == Enum.HumanoidRigType.R15 then
                if v12.AutomaticScalingEnabled then
                    v15 = Vector3.new(0, 1.5, 0)
                    local RootPart = v12.RootPart

                    if v14 == RootPart then
                        v15 += Vector3.new(0, (RootPart.Size.Y - 2) / 2, 0)
                    end
                else
                    v15 = Vector3.new(0, 2, 0)
                end
            else
                v15 = Vector3.new(0, 1.5, 0)
            end

            if v11 then
                v15 = Vector3.new(0, 0, 0)
            end

            v10 = v14.CFrame * CFrame.new(v15 + v13)
        end
    elseif v12:IsA("BasePart") then
        v10 = v12.CFrame
    elseif v12:IsA("Model") then
        v10 = if v12.PrimaryPart then v12:GetPrimaryPartCFrame() else CFrame.new()
    end

    if v10 then
        arg7.lastSubjectCFrame = v10
    end

    return v10
end

function t_1.GetSubjectVelocity(_) -- line: 257
    local CurrentCamera = workspace.CurrentCamera
    local v17 = CurrentCamera

    if v17 then
        v17 = CurrentCamera.CameraSubject
    end

    if not v17 then
        return Vector3.new(0, 0, 0)
    end

    if v17:IsA("BasePart") then
        return v17.Velocity
    end

    if v17:IsA("Humanoid") then
        local RootPart_1 = v17.RootPart

        if RootPart_1 then
            return RootPart_1.Velocity
        end
    elseif v17:IsA("Model") then
        local PrimaryPart = v17.PrimaryPart

        if PrimaryPart then
            return PrimaryPart.Velocity
        end
    end

    return Vector3.new(0, 0, 0)
end

function t_1.GetSubjectRotVelocity(_) -- line: 286
    local CurrentCamera_1 = workspace.CurrentCamera
    local v18 = CurrentCamera_1

    if v18 then
        v18 = CurrentCamera_1.CameraSubject
    end

    if not v18 then
        return Vector3.new(0, 0, 0)
    end

    if v18:IsA("BasePart") then
        return v18.RotVelocity
    end

    if v18:IsA("Humanoid") then
        local RootPart_2 = v18.RootPart

        if RootPart_2 then
            return RootPart_2.RotVelocity
        end
    elseif v18:IsA("Model") then
        local PrimaryPart_1 = v18.PrimaryPart

        if PrimaryPart_1 then
            return PrimaryPart_1.RotVelocity
        end
    end

    return Vector3.new(0, 0, 0)
end

function t_1.StepZoom(arg10) -- line: 315
    -- upvalues:
    --  [1] CameraInput_m (copy)
    --  [2] ZoomController_m (copy)

    local CurrentSubjectDistance = arg10.currentSubjectDistance
    local v19 = CameraInput_m.getZoomDelta()

    if math.abs(v19) > 0 then
        local v20 = if v19 > 0 then math.max(
            CurrentSubjectDistance + v19 * (CurrentSubjectDistance * 0.5 + 1),
            arg10.FIRST_PERSON_DISTANCE_THRESHOLD
        ) else math.max((CurrentSubjectDistance + v19) / (1 - v19 * 0.5), 0.5)

        if v20 < arg10.FIRST_PERSON_DISTANCE_THRESHOLD then
            v20 = 0.5
        end

        arg10:SetCameraToSubjectDistance(v20)
    end

    return ZoomController_m.GetZoomRadius()
end

function t_1.GetSubjectPosition(arg11) -- line: 340
    local v21 = arg11.lastSubjectPosition
    local v22 = game.Workspace.CurrentCamera
    local v23 = v22

    if v23 then
        v23 = v22.CameraSubject
    end

    if v23 then
        if v23:IsA("Humanoid") then
            v22 = if v23:GetState() ~= Enum.HumanoidStateType.Dead then false else true
            local v24 = v23.CameraOffset

            if arg11:GetIsMouseLocked() then
                v24 = Vector3.new()
            end

            local v25 = v23.RootPart

            if v22 and v23.Parent and v23.Parent:IsA("Model") then
                v25 = v23.Parent:FindFirstChild("Head") or v25
            end

            if v25 and v25:IsA("BasePart") then
                local v26

                if v23.RigType == Enum.HumanoidRigType.R15 then
                    if v23.AutomaticScalingEnabled then
                        v26 = Vector3.new(0, 1.5, 0)

                        if v25 == v23.RootPart then
                            v26 += Vector3.new(0, v23.RootPart.Size.Y / 2 - 1, 0)
                        end
                    else
                        v26 = Vector3.new(0, 2, 0)
                    end
                else
                    v26 = Vector3.new(0, 1.5, 0)
                end

                if v22 then
                    v26 = Vector3.new(0, 0, 0)
                end

                v21 = v25.CFrame.p + v25.CFrame:vectorToWorldSpace(v26 + v24)
            end
        elseif v23:IsA("VehicleSeat") then
            v21 = v23.CFrame.p + v23.CFrame:vectorToWorldSpace(Vector3.new(0, 5, 0))
        elseif v23:IsA("SkateboardPlatform") then
            v21 = v23.CFrame.p + Vector3.new(0, 5, 0)
        elseif v23:IsA("BasePart") then
            v21 = v23.CFrame.p
        elseif v23:IsA("Model") then
            v21 = if v23.PrimaryPart then v23:GetPrimaryPartCFrame().p else v23:GetModelCFrame().p
        end
    else
        return nil
    end

    arg11.lastSubject = v23
    arg11.lastSubjectPosition = v21

    return v21
end

function t_1.OnCurrentCameraChanged(arg12) -- line: 418
    if arg12.cameraSubjectChangedConn then
        arg12.cameraSubjectChangedConn:Disconnect()
        arg12.cameraSubjectChangedConn = nil
    end

    local CurrentCamera_2 = game.Workspace.CurrentCamera

    if CurrentCamera_2 then
        arg12.cameraSubjectChangedConn = CurrentCamera_2:GetPropertyChangedSignal("CameraSubject"):Connect(
            function() -- line: 427
                -- upvalues:
                --  [1] arg12 (copy)

                arg12:OnNewCameraSubject()
            end
        )
        arg12:OnNewCameraSubject()
    end
end

function t_1.OnPlayerCameraPropertyChange(arg13) -- line: 434
    arg13:SetCameraToSubjectDistance(arg13.currentSubjectDistance)
end

function t_1.InputTranslationToCameraAngleChange(_, arg15, arg16) -- line: 439
    return arg15 * arg16
end

function t_1.GamepadZoomPress(arg17) -- line: 445
    -- upvalues:
    --  [1] LocalPlayer (copy)

    local v28 = arg17:GetCameraToSubjectDistance()
    local v29 = LocalPlayer.CameraMaxZoomDistance

    for index = #arg17.gamepadZoomLevels, 1, -1 do
        local v30 = arg17.gamepadZoomLevels[index]

        if not (v29 < v30) then
            if v30 < LocalPlayer.CameraMinZoomDistance then
                v30 = LocalPlayer.CameraMinZoomDistance

                if v29 == v30 then
                    break
                end
            end

            if v28 > v30 + (v29 - v30) / 2 then
                arg17:SetCameraToSubjectDistance(v30)

                return
            end

            v29 = v30
        end
    end

    arg17:SetCameraToSubjectDistance(arg17.gamepadZoomLevels[#arg17.gamepadZoomLevels])
end

function t_1.Enable(t2: table, b2: boolean) -- line: 482
    if t2.enabled ~= b2 then
        t2.enabled = b2
        t2:OnEnabledChanged()
    end
end

function t_1.OnEnabledChanged(arg18) -- line: 490
    -- upvalues:
    --  [1] CameraInput_m (copy)
    --  [2] LocalPlayer (copy)

    if arg18.enabled then
        arg18:_setUpConfigurations()
        CameraInput_m.setInputEnabled(true)
        arg18.gamepadZoomPressConnection = CameraInput_m.gamepadZoomPress:Connect(function() -- line: 496
            -- upvalues:
            --  [1] arg18 (copy)

            arg18:GamepadZoomPress()
        end)

        if LocalPlayer.CameraMode == Enum.CameraMode.LockFirstPerson then
            arg18.currentSubjectDistance = 0.5

            if not arg18.inFirstPerson then
                arg18:EnterFirstPerson()
            end
        end

        if arg18.cameraChangedConn then
            arg18.cameraChangedConn:Disconnect()
            arg18.cameraChangedConn = nil
        end

        arg18.cameraChangedConn = workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function() -- line: 508
            -- upvalues:
            --  [1] arg18 (copy)

            arg18:OnCurrentCameraChanged()
        end)
        arg18:OnCurrentCameraChanged()

        return
    end

    arg18._connections:disconnectAll()
    CameraInput_m.setInputEnabled(false)

    if arg18.gamepadZoomPressConnection then
        arg18.gamepadZoomPressConnection:Disconnect()
        arg18.gamepadZoomPressConnection = nil
    end

    arg18:Cleanup()
end

function t_1.GetEnabled(arg19) -- line: 526
    return arg19.enabled
end

function t_1.Cleanup(arg20) -- line: 530
    -- upvalues:
    --  [1] CameraUtils_m (copy)

    if arg20.subjectStateChangedConn then
        arg20.subjectStateChangedConn:Disconnect()
        arg20.subjectStateChangedConn = nil
    end

    if arg20.cameraChangedConn then
        arg20.cameraChangedConn:Disconnect()
        arg20.cameraChangedConn = nil
    end

    arg20.lastCameraTransform = nil
    arg20.lastSubjectCFrame = nil
    CameraUtils_m.restoreMouseBehavior()
end

function t_1.UpdateMouseBehavior(arg21) -- line: 547
    -- upvalues:
    --  [1] UserGameSettings (copy)
    --  [2] CameraUI_m (copy)
    --  [3] CameraInput_m (copy)
    --  [4] CameraToggleStateController_m (copy)
    --  [5] CameraUtils_m (copy)

    local v31 = UserGameSettings.ComputerMovementMode == Enum.ComputerMovementMode.ClickToMove

    if arg21.isCameraToggle and v31 == false then
        CameraUI_m.setCameraModeToastEnabled(true)
        CameraInput_m.enableCameraToggleInput()
        CameraToggleStateController_m(arg21.inFirstPerson)

        return
    end

    CameraUI_m.setCameraModeToastEnabled(false)
    CameraInput_m.disableCameraToggleInput()

    if arg21.inFirstPerson or arg21.inMouseLockedMode then
        CameraUtils_m.setRotationTypeOverride(Enum.RotationType.CameraRelative)
        CameraUtils_m.setMouseBehaviorOverride(Enum.MouseBehavior.LockCenter)

        return
    end

    CameraUtils_m.restoreRotationType()

    if CameraInput_m.getRotationActivated() then
        CameraUtils_m.setMouseBehaviorOverride(Enum.MouseBehavior.LockCurrentPosition)

        return
    end

    CameraUtils_m.restoreMouseBehavior()
end

function t_1.UpdateForDistancePropertyChange(arg22) -- line: 575
    arg22:SetCameraToSubjectDistance(arg22.currentSubjectDistance)
end

function t_1.SetCameraToSubjectDistance(t3: table, n1: number) -- line: 581
    -- upvalues:
    --  [1] LocalPlayer (copy)
    --  [2] ZoomController_m (copy)

    local CurrentSubjectDistance_1 = t3.currentSubjectDistance

    if LocalPlayer.CameraMode == Enum.CameraMode.LockFirstPerson then
        t3.currentSubjectDistance = 0.5

        if not t3.inFirstPerson then
            t3:EnterFirstPerson()
        end
    else
        local clampedValue = math.clamp(
            n1,
            LocalPlayer.CameraMinZoomDistance,
            LocalPlayer.CameraMaxZoomDistance
        )

        if clampedValue < 1 then
            t3.currentSubjectDistance = 0.5

            if not t3.inFirstPerson then
                t3:EnterFirstPerson()
            end
        else
            t3.currentSubjectDistance = clampedValue

            if t3.inFirstPerson then
                t3:LeaveFirstPerson()
            end
        end
    end

    ZoomController_m.SetZoomParameters(
        t3.currentSubjectDistance,
        (math.sign(n1 - CurrentSubjectDistance_1))
    )

    return t3.currentSubjectDistance
end

function t_1.SetCameraType(arg23, arg24) -- line: 615
    arg23.cameraType = arg24
end

function t_1.GetCameraType(arg25) -- line: 620
    return arg25.cameraType
end

function t_1.SetCameraMovementMode(arg26, arg27) -- line: 625
    arg26.cameraMovementMode = arg27
end

function t_1.GetCameraMovementMode(arg28) -- line: 629
    return arg28.cameraMovementMode
end

function t_1.SetIsMouseLocked(t4: table, b3: boolean) -- line: 633
    t4.inMouseLockedMode = b3
end

function t_1.GetIsMouseLocked(arg29) -- line: 637
    return arg29.inMouseLockedMode
end

function t_1.SetMouseLockOffset(arg30, arg31) -- line: 641
    arg30.mouseLockOffset = arg31
end

function t_1.GetMouseLockOffset(arg32) -- line: 645
    return arg32.mouseLockOffset
end

function t_1.InFirstPerson(arg33) -- line: 649
    return arg33.inFirstPerson
end

function t_1.EnterFirstPerson(arg34) -- line: 653
    arg34.inFirstPerson = true
    arg34:UpdateMouseBehavior()
end

function t_1.LeaveFirstPerson(arg35) -- line: 658
    arg35.inFirstPerson = false
    arg35:UpdateMouseBehavior()
end

function t_1.GetCameraToSubjectDistance(arg36) -- line: 664
    return arg36.currentSubjectDistance
end

function t_1.GetMeasuredDistanceToFocus(_) -- line: 671
    local CurrentCamera_4 = game.Workspace.CurrentCamera

    if CurrentCamera_4 then
        return (CurrentCamera_4.CoordinateFrame.p - CurrentCamera_4.Focus.p).magnitude
    end

    return nil
end

function t_1.GetCameraLookVector(_) -- line: 679
    return game.Workspace.CurrentCamera and game.Workspace.CurrentCamera.CFrame.LookVector or Vector3.new(0, 0, 1)
end

function t_1.CalculateNewLookCFrameFromArg(t5: table, vec1: Vector3?, u2: Vector2) -- line: 683
    local v33 = vec1 or t5:GetCameraLookVector()
    local angle = math.asin(v33.Y)
    local clampedValue_2 = math.clamp(u2.Y, angle + -1.3962634015954636, angle + 1.3962634015954636)
    local vec2_1 = Vector2.new(u2.X, clampedValue_2)
    local cframe = CFrame.new(Vector3.new(0, 0, 0), v33)

    return CFrame.Angles(0, -vec2_1.X, 0) * cframe * CFrame.Angles(-vec2_1.Y, 0, 0)
end

function t_1.CalculateNewLookVectorFromArg(t6: table, vec3: Vector3?, u3: Vector2) -- line: 693
    return t6:CalculateNewLookCFrameFromArg(vec3, u3).LookVector
end

function t_1.CalculateNewLookVectorVRFromArg(t7: table, u4: Vector2) -- line: 698
    local Unit = ((t7:GetSubjectPosition() - game.Workspace.CurrentCamera.CFrame.p) * Vector3.new(1, 0, 1)).unit
    local vec2_2 = Vector2.new(u4.X, 0)
    local cframe_1 = CFrame.new(Vector3.new(0, 0, 0), Unit)

    return ((CFrame.Angles(0, -vec2_2.X, 0) * cframe_1 * CFrame.Angles(-vec2_2.Y, 0, 0)).LookVector * Vector3.new(1, 0, 1)).unit
end

function t_1.GetHumanoid(arg39) -- line: 708
    -- upvalues:
    --  [1] LocalPlayer (copy)

    local v38 = LocalPlayer

    if v38 then
        v38 = LocalPlayer.Character
    end

    if v38 then
        local v39 = arg39.humanoidCache[LocalPlayer]

        if v39 and v39.Parent == v38 then
            return v39
        end

        arg39.humanoidCache[LocalPlayer] = nil
        local Humanoid_1 = v38:FindFirstChildOfClass("Humanoid")

        if Humanoid_1 then
            arg39.humanoidCache[LocalPlayer] = Humanoid_1
        end

        return Humanoid_1
    end

    return nil
end

function t_1.GetHumanoidPartToFollow(_: table, u5: userdata, arg40: any) -- line: 726
    if arg40 == Enum.HumanoidStateType.Dead then
        local Parent_1 = u5.Parent

        if Parent_1 then
            return Parent_1:FindFirstChild("Head") or u5.Torso
        end

        return u5.Torso
    else
        return u5.Torso
    end
end

function t_1.OnNewCameraSubject(arg41) -- line: 740
    if arg41.subjectStateChangedConn then
        arg41.subjectStateChangedConn:Disconnect()
        arg41.subjectStateChangedConn = nil
    end
end

function t_1.IsInFirstPerson(arg42) -- line: 747
    return arg42.inFirstPerson
end

function t_1.Update(_, _) -- line: 751
    error("BaseCamera:Update() This is a virtual function that should never be getting called.", 2)
end

function t_1.GetCameraHeight(arg45) -- line: 755
    -- upvalues:
    --  [1] VRService (copy)

    return if not VRService.VREnabled then 0 else if arg45.inFirstPerson then 0 else 0.25881904510252074 * arg45.currentSubjectDistance
end

return t_1
