local VRService = game:GetService("VRService")
local _ = game:GetService("Players").LocalPlayer
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local UserGameSettings = UserSettings():GetService("UserGameSettings")
local CameraInput_m = require(script.Parent:WaitForChild("CameraInput"))
local ZoomController_m = require(script.Parent:WaitForChild("ZoomController"))
local _ = require(script.Parent.Parent:WaitForChild("CommonUtils"):WaitForChild("FlagUtil"))
local BaseCamera_m = require(script.Parent:WaitForChild("BaseCamera"))
local t = setmetatable({}, BaseCamera_m)
t.__index = t

function t.new() -- line: 32
    -- upvalues:
    --  [1] BaseCamera_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(BaseCamera_m.new(), t)
    t_1.gamepadZoomLevels = { 0, 7 }
    t_1.headScale = 1
    t_1:SetCameraToSubjectDistance(7)
    t_1.VRFadeResetTimer = 0
    t_1.VREdgeBlurTimer = 0
    t_1.gamepadResetConnection = nil
    t_1.needsReset = true
    t_1.recentered = false
    t_1:Reset()

    return t_1
end

function t.Reset(arg1) -- line: 58
    arg1.stepRotateTimeout = 0
end

function t.GetModuleName(_) -- line: 62
    return "VRBaseCamera"
end

function t.GamepadZoomPress(arg3) -- line: 66
    -- upvalues:
    --  [1] BaseCamera_m (copy)

    BaseCamera_m.GamepadZoomPress(arg3)
    arg3:GamepadReset()
    arg3:ResetZoom()
end

function t.GamepadReset(arg4) -- line: 74
    arg4.stepRotateTimeout = 0
    arg4.needsReset = true
end

function t.ResetZoom(arg5) -- line: 79
    -- upvalues:
    --  [1] ZoomController_m (copy)

    ZoomController_m.SetZoomParameters(arg5.currentSubjectDistance, 0)
    ZoomController_m.ReleaseSpring()
end

function t.OnEnabledChanged(arg6) -- line: 84
    -- upvalues:
    --  [1] BaseCamera_m (copy)
    --  [2] CameraInput_m (copy)
    --  [3] VRService (copy)
    --  [4] Lighting (copy)

    BaseCamera_m.OnEnabledChanged(arg6)

    if arg6.enabled then
        arg6.gamepadResetConnection = CameraInput_m.gamepadReset:Connect(function() -- line: 88
            -- upvalues:
            --  [1] arg6 (copy)

            arg6:GamepadReset()
        end)
        arg6.thirdPersonOptionChanged = VRService:GetPropertyChangedSignal(
            "ThirdPersonFollowCamEnabled"
        ):Connect(function() -- line: 93
            -- upvalues:
            --  [1] arg6 (copy)

            arg6:Reset()
        end)
        arg6.vrRecentered = VRService.UserCFrameChanged:Connect(function(arg7, _) -- line: 97
            -- upvalues:
            --  [1] arg6 (copy)

            if arg7 == Enum.UserCFrame.Floor then
                arg6.recentered = true
            end
        end)

        return
    end

    if arg6.inFirstPerson then
        arg6:GamepadZoomPress()
    end

    if arg6.thirdPersonOptionChanged then
        arg6.thirdPersonOptionChanged:Disconnect()
        arg6.thirdPersonOptionChanged = nil
    end

    if arg6.vrRecentered then
        arg6.vrRecentered:Disconnect()
        arg6.vrRecentered = nil
    end

    if arg6.cameraHeadScaleChangedConn then
        arg6.cameraHeadScaleChangedConn:Disconnect()
        arg6.cameraHeadScaleChangedConn = nil
    end

    if arg6.gamepadResetConnection then
        arg6.gamepadResetConnection:Disconnect()
        arg6.gamepadResetConnection = nil
    end

    local VRFade = Lighting:FindFirstChild("VRFade")

    if VRFade then
        VRFade.Brightness = 0
    end
end

function t.OnCurrentCameraChanged(arg9) -- line: 137
    -- upvalues:
    --  [1] BaseCamera_m (copy)

    BaseCamera_m.OnCurrentCameraChanged(arg9)

    if arg9.cameraHeadScaleChangedConn then
        arg9.cameraHeadScaleChangedConn:Disconnect()
        arg9.cameraHeadScaleChangedConn = nil
    end

    local CurrentCamera = workspace.CurrentCamera

    if CurrentCamera then
        arg9.cameraHeadScaleChangedConn = CurrentCamera:GetPropertyChangedSignal("HeadScale"):Connect(
            function() -- line: 149
                -- upvalues:
                --  [1] arg9 (copy)

                arg9:OnHeadScaleChanged()
            end
        )
        arg9:OnHeadScaleChanged()
    end
end

function t.OnHeadScaleChanged(arg10) -- line: 154
    local HeadScale_1 = workspace.CurrentCamera.HeadScale

    for key, val in arg10.gamepadZoomLevels do
        arg10.gamepadZoomLevels[key] = val * HeadScale_1 / arg10.headScale
    end

    arg10:SetCameraToSubjectDistance(
        arg10:GetCameraToSubjectDistance() * HeadScale_1 / arg10.headScale
    )
    arg10.headScale = HeadScale_1
end

function t.GetVRFocus(arg11, arg12, arg13) -- line: 170
    local v7 = arg11.lastCameraFocus or arg12
    local X = arg11.cameraTranslationConstraints.x
    local minimum = math.min(1, arg11.cameraTranslationConstraints.y + arg13)
    arg11.cameraTranslationConstraints = Vector3.new(
        X,
        minimum,
        arg11.cameraTranslationConstraints.z
    )
    local v8 = arg11:GetCameraHeight()
    local vec3 = Vector3.new(0, v8, 0)

    return (CFrame.new(
        Vector3.new(arg12.x, v7.y, arg12.z):Lerp(arg12 + vec3, arg11.cameraTranslationConstraints.y)
    ))
end

function t.StartFadeFromBlack(arg14) -- line: 186
    -- upvalues:
    --  [1] UserGameSettings (copy)
    --  [2] Lighting (copy)

    if UserGameSettings.VignetteEnabled == false then
        return
    end

    local v10 = Lighting:FindFirstChild("VRFade")

    if not v10 then
        v10 = Instance.new("ColorCorrectionEffect")
        v10.Name = "VRFade"
        v10.Parent = Lighting
    end

    v10.Brightness = -1
    arg14.VRFadeResetTimer = 0.1
end

function t.UpdateFadeFromBlack(t1: table, n1: number) -- line: 201
    -- upvalues:
    --  [1] Lighting (copy)

    local VRFade_1 = Lighting:FindFirstChild("VRFade")

    if t1.VRFadeResetTimer > 0 then
        t1.VRFadeResetTimer = math.max(t1.VRFadeResetTimer - n1, 0)
        local VRFade_2 = Lighting:FindFirstChild("VRFade")

        if VRFade_2 and VRFade_2.Brightness < 0 then
            VRFade_2.Brightness = math.min(VRFade_2.Brightness + n1 * 10, 0)

            return
        end
    elseif VRFade_1 then
        VRFade_1.Brightness = 0
    end
end

function t.StartVREdgeBlur(arg15, arg16, arg17) -- line: 217
    -- upvalues:
    --  [1] UserGameSettings (copy)
    --  [2] RunService (copy)
    --  [3] VRService (copy)

    if not arg17 and UserGameSettings.VignetteEnabled == false then
        return
    end

    local v11 = workspace.CurrentCamera:FindFirstChild("VRBlurPart")

    if not v11 then
        v11 = Instance.new("Part")
        v11.Name = "VRBlurPart"
        v11.Parent = workspace.CurrentCamera
        v11.CanTouch = false
        v11.CanCollide = false
        v11.CanQuery = false
        v11.Anchored = true
        v11.Size = Vector3.new(0.44, 0.47, 1)
        v11.Transparency = 1
        v11.CastShadow = false
        RunService.RenderStepped:Connect(function(_) -- line: 237
            -- upvalues:
            --  [1] VRService (ref)
            --  [2] v11 (ref)

            local v12 = VRService:GetUserCFrame(Enum.UserCFrame.Head)
            local v14 = workspace.CurrentCamera.CFrame * (CFrame.new(
                v12.p * workspace.CurrentCamera.HeadScale
            ) * (v12 - v12.p))
            v11.CFrame = v14 * CFrame.Angles(0, 3.141592653589793, 0) + v14.LookVector * (1.05 * workspace.CurrentCamera.HeadScale)
            v11.Size = Vector3.new(0.44, 0.47, 1) * workspace.CurrentCamera.HeadScale
        end)
    end

    local v16 = arg16.PlayerGui:FindFirstChild("VRBlurScreen")
    local v17 = if v16 then v16:FindFirstChild("VRBlur") else nil

    if not v17 then
        if not v16 then
            v16 = Instance.new("SurfaceGui") or Instance.new("ScreenGui")
        end

        v16.Name = "VRBlurScreen"
        v16.Parent = arg16.PlayerGui
        v16.Adornee = v11
        v17 = Instance.new("ImageLabel")
        v17.Name = "VRBlur"
        v17.Parent = v16
        v17.Image = "rbxasset://textures/ui/VR/edgeBlur.png"
        v17.AnchorPoint = Vector2.new(0.5, 0.5)
        v17.Position = UDim2.new(0.5, 0, 0.5, 0)
        v17.Size = UDim2.fromScale(
            workspace.CurrentCamera.ViewportSize.X * 2.3 / 512,
            workspace.CurrentCamera.ViewportSize.Y * 2.3 / 512
        )
        v17.BackgroundTransparency = 1
        v17.Active = true
        v17.ScaleType = Enum.ScaleType.Stretch
    end

    v17.Visible = true
    v17.ImageTransparency = 0
    arg15.VREdgeBlurTimer = 0.14
end

function t.UpdateEdgeBlur(arg19, arg20, arg21) -- line: 286
    local VRBlurScreen = arg20.PlayerGui:FindFirstChild("VRBlurScreen")
    local v19 = if VRBlurScreen then VRBlurScreen:FindFirstChild("VRBlur") else nil

    if v19 then
        if arg19.VREdgeBlurTimer > 0 then
            arg19.VREdgeBlurTimer -= arg21
            local VRBlurScreen_1 = arg20.PlayerGui:FindFirstChild("VRBlurScreen")

            if VRBlurScreen_1 then
                local VRBlur = VRBlurScreen_1:FindFirstChild("VRBlur")

                if VRBlur then
                    VRBlur.ImageTransparency = 1 - math.clamp(arg19.VREdgeBlurTimer, 0.01, 0.14) * 7.142857142857142

                    return
                end
            end
        else
            v19.Visible = false
        end
    end
end

function t.GetCameraHeight(arg22) -- line: 311
    if not arg22.inFirstPerson then
        return 0.25881904510252074 * arg22.currentSubjectDistance
    end

    return 0
end

function t.GetSubjectCFrame(arg23) -- line: 318
    -- upvalues:
    --  [1] BaseCamera_m (copy)

    local v20 = BaseCamera_m.GetSubjectCFrame(arg23)
    local CurrentCamera_1 = workspace.CurrentCamera
    local v22 = CurrentCamera_1

    if v22 then
        v22 = CurrentCamera_1.CameraSubject
    end

    if not v22 then
        return v20
    end

    if v22:IsA("Humanoid") then
        v20 = if not (if v22:GetState() ~= Enum.HumanoidStateType.Dead then false else true) then v20 else if v22 ~= arg23.lastSubject then v20 else arg23.lastSubjectCFrame
    end

    if v20 then
        arg23.lastSubjectCFrame = v20
    end

    return v20
end

function t.GetSubjectPosition(arg24) -- line: 344
    -- upvalues:
    --  [1] BaseCamera_m (copy)

    local v23 = BaseCamera_m.GetSubjectPosition(arg24)
    local CurrentCamera_2 = game.Workspace.CurrentCamera
    local v25 = CurrentCamera_2

    if v25 then
        v25 = CurrentCamera_2.CameraSubject
    end

    if v25 then
        if v25:IsA("Humanoid") then
            if
                (if v25:GetState() ~= Enum.HumanoidStateType.Dead then false else true)
                and v25 == arg24.lastSubject
            then
                v23 = arg24.lastSubjectPosition
            end
        elseif v25:IsA("VehicleSeat") then
            v23 = v25.CFrame.p + v25.CFrame:vectorToWorldSpace(Vector3.new(0, 4, 0))
        end
    else
        return nil
    end

    arg24.lastSubjectPosition = v23

    return v23
end

function t.getRotation(arg25, arg26) -- line: 373
    -- upvalues:
    --  [1] CameraInput_m (copy)
    --  [2] UserGameSettings (copy)

    local v26 = CameraInput_m.getRotation(arg26)

    if UserGameSettings.VRSmoothRotationEnabled then
        return v26.X
    end

    if math.abs(v26.X) > 0.03 then
        if arg25.stepRotateTimeout > 0 then
            arg25.stepRotateTimeout -= arg26
        end

        if arg25.stepRotateTimeout <= 0 then
            local v27 = 1
            v27 = if not (v26.X < 0) then v27 else -1
            v27 *= 0.5235987755982988
            arg25:StartFadeFromBlack()
            arg25.stepRotateTimeout = 0.25

            return v27
        end
    elseif math.abs(v26.X) < 0.02 then
        arg25.stepRotateTimeout = 0
    end

    return 0
end

function t.HandleSubjectDistance(arg27, arg28) -- line: 408
    if arg28 and arg28.IsInFirstPerson and arg28:IsInFirstPerson() then
        arg27:SetCameraToSubjectDistance(0)
    end
end

return t
