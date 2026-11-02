local UserFixOrbitalCameraAzimuth = require(
    script.Parent.Parent:WaitForChild("CommonUtils"):WaitForChild("FlagUtil")
).getUserFlag("UserFixOrbitalCameraAzimuth")
local _ = {
    InitialDistance = 25,
    MinDistance = 10,
    MaxDistance = 100,
    InitialElevation = 35,
    MinElevation = 35,
    MaxElevation = 35,
    ReferenceAzimuth = -45,
    CWAzimuthTravel = 90,
    CCWAzimuthTravel = 90,
    UseAzimuthLimits = false
}
local CameraUtils_m = require(script.Parent:WaitForChild("CameraUtils"))
local CameraInput_m = require(script.Parent:WaitForChild("CameraInput"))
local Players = game:GetService("Players")
local BaseCamera_m = require(script.Parent:WaitForChild("BaseCamera"))
local t_1 = setmetatable({}, BaseCamera_m)
t_1.__index = t_1

function t_1.new() -- line: 46
    -- upvalues:
    --  [1] BaseCamera_m (copy)
    --  [2] t_1 (copy)

    local t_2 = setmetatable(BaseCamera_m.new(), t_1)
    t_2.lastUpdate = tick()
    t_2.changedSignalConnections = {}
    t_2.refAzimuthRad = nil
    t_2.curAzimuthRad = nil
    t_2.minAzimuthAbsoluteRad = nil
    t_2.maxAzimuthAbsoluteRad = nil
    t_2.useAzimuthLimits = nil
    t_2.curElevationRad = nil
    t_2.minElevationRad = nil
    t_2.maxElevationRad = nil
    t_2.curDistance = nil
    t_2.minDistance = nil
    t_2.maxDistance = nil
    t_2.gamepadDollySpeedMultiplier = 1
    t_2.lastUserPanCamera = tick()
    t_2.externalProperties = {}
    t_2.externalProperties.InitialDistance = 25
    t_2.externalProperties.MinDistance = 10
    t_2.externalProperties.MaxDistance = 100
    t_2.externalProperties.InitialElevation = 35
    t_2.externalProperties.MinElevation = 35
    t_2.externalProperties.MaxElevation = 35
    t_2.externalProperties.ReferenceAzimuth = -45
    t_2.externalProperties.CWAzimuthTravel = 90
    t_2.externalProperties.CCWAzimuthTravel = 90
    t_2.externalProperties.UseAzimuthLimits = false
    t_2:LoadNumberValueParameters()

    return t_2
end

function t_1.LoadOrCreateNumberValueParameter(t1: table, s1: string, arg1: any, arg2: any) -- line: 85
    local v5 = script:FindFirstChild(s1)

    if v5 and v5:IsA(arg1) then
        t1.externalProperties[s1] = v5.Value
    elseif t1.externalProperties[s1] ~= nil then
        v5 = Instance.new(arg1)
        v5.Name = s1
        v5.Parent = script
        v5.Value = t1.externalProperties[s1]
    else
        return
    end

    if arg2 then
        if t1.changedSignalConnections[s1] then
            t1.changedSignalConnections[s1]:Disconnect()
        end

        t1.changedSignalConnections[s1] = v5.Changed:Connect(function(arg3) -- line: 105
            -- upvalues:
            --  [1] t1 (copy)
            --  [2] s1 (copy)
            --  [3] arg2 (copy)

            t1.externalProperties[s1] = arg3
            arg2(t1)
        end)
    end
end

function t_1.SetAndBoundsCheckAzimuthValues(arg4) -- line: 112
    local radians = math.rad(arg4.externalProperties.ReferenceAzimuth)
    local radians_1 = math.rad(arg4.externalProperties.CWAzimuthTravel)
    arg4.minAzimuthAbsoluteRad = radians - math.abs(radians_1)
    local radians_2 = math.rad(arg4.externalProperties.ReferenceAzimuth)
    local radians_3 = math.rad(arg4.externalProperties.CCWAzimuthTravel)
    arg4.maxAzimuthAbsoluteRad = radians_2 + math.abs(radians_3)
    arg4.useAzimuthLimits = arg4.externalProperties.UseAzimuthLimits

    if arg4.useAzimuthLimits then
        arg4.curAzimuthRad = math.max(arg4.curAzimuthRad, arg4.minAzimuthAbsoluteRad)
        arg4.curAzimuthRad = math.min(arg4.curAzimuthRad, arg4.maxAzimuthAbsoluteRad)
    end
end

function t_1.SetAndBoundsCheckElevationValues(arg5) -- line: 122
    local maximum = math.max(arg5.externalProperties.MinElevation, -80)
    local minimum = math.min(arg5.externalProperties.MaxElevation, 80)
    local minimum_1 = math.min(maximum, minimum)
    arg5.minElevationRad = math.rad(minimum_1)
    local maximum_1 = math.max(maximum, minimum)
    arg5.maxElevationRad = math.rad(maximum_1)
    arg5.curElevationRad = math.max(arg5.curElevationRad, arg5.minElevationRad)
    arg5.curElevationRad = math.min(arg5.curElevationRad, arg5.maxElevationRad)
end

function t_1.SetAndBoundsCheckDistanceValues(arg6) -- line: 138
    arg6.minDistance = arg6.externalProperties.MinDistance
    arg6.maxDistance = arg6.externalProperties.MaxDistance
    arg6.curDistance = math.max(arg6.curDistance, arg6.minDistance)
    arg6.curDistance = math.min(arg6.curDistance, arg6.maxDistance)
end

function t_1.LoadNumberValueParameters(arg7) -- line: 146
    -- upvalues:
    --  [1] UserFixOrbitalCameraAzimuth (copy)

    arg7:LoadOrCreateNumberValueParameter("InitialElevation", "NumberValue", nil)
    arg7:LoadOrCreateNumberValueParameter("InitialDistance", "NumberValue", nil)
    arg7:LoadOrCreateNumberValueParameter(
        "ReferenceAzimuth",
        "NumberValue",
        if UserFixOrbitalCameraAzimuth then arg7.SetAndBoundsCheckAzimuthValues else arg7.SetAndBoundsCheckAzimuthValue
    )
    arg7:LoadOrCreateNumberValueParameter(
        "CWAzimuthTravel",
        "NumberValue",
        arg7.SetAndBoundsCheckAzimuthValues
    )
    arg7:LoadOrCreateNumberValueParameter(
        "CCWAzimuthTravel",
        "NumberValue",
        arg7.SetAndBoundsCheckAzimuthValues
    )
    arg7:LoadOrCreateNumberValueParameter(
        "MinElevation",
        "NumberValue",
        arg7.SetAndBoundsCheckElevationValues
    )
    arg7:LoadOrCreateNumberValueParameter(
        "MaxElevation",
        "NumberValue",
        arg7.SetAndBoundsCheckElevationValues
    )
    arg7:LoadOrCreateNumberValueParameter(
        "MinDistance",
        "NumberValue",
        arg7.SetAndBoundsCheckDistanceValues
    )
    arg7:LoadOrCreateNumberValueParameter(
        "MaxDistance",
        "NumberValue",
        arg7.SetAndBoundsCheckDistanceValues
    )
    arg7:LoadOrCreateNumberValueParameter(
        "UseAzimuthLimits",
        "BoolValue",
        arg7.SetAndBoundsCheckAzimuthValues
    )
    arg7.curAzimuthRad = math.rad(arg7.externalProperties.ReferenceAzimuth)
    arg7.curElevationRad = math.rad(arg7.externalProperties.InitialElevation)
    arg7.curDistance = arg7.externalProperties.InitialDistance
    arg7:SetAndBoundsCheckAzimuthValues()
    arg7:SetAndBoundsCheckElevationValues()
    arg7:SetAndBoundsCheckDistanceValues()
end

function t_1.GetModuleName(_) -- line: 172
    return "OrbitalCamera"
end

function t_1.SetInitialOrientation(t2: table, u1: userdata) -- line: 176
    -- upvalues:
    --  [1] CameraUtils_m (copy)

    if not u1 or not u1.RootPart then
        warn("OrbitalCamera could not set initial orientation due to missing humanoid")

        return
    end

    assert(u1.RootPart, "")
    local Unit = (u1.RootPart.CFrame.LookVector - Vector3.new(0, 0.23, 0)).Unit
    local v7 = CameraUtils_m.GetAngleBetweenXZVectors(Unit, t2:GetCameraLookVector())
    local v8 = math.asin(t2:GetCameraLookVector().Y) - math.asin(Unit.Y)

    if not CameraUtils_m.IsFinite(v7) then
    end

    if not CameraUtils_m.IsFinite(v8) then
    end
end

function t_1.GetCameraToSubjectDistance(arg9) -- line: 194
    return arg9.curDistance
end

function t_1.SetCameraToSubjectDistance(arg10, arg11) -- line: 198
    -- upvalues:
    --  [1] Players (copy)

    if Players.LocalPlayer then
        arg10.currentSubjectDistance = math.clamp(arg11, arg10.minDistance, arg10.maxDistance)
        arg10.currentSubjectDistance = math.max(
            arg10.currentSubjectDistance,
            arg10.FIRST_PERSON_DISTANCE_THRESHOLD
        )
    end

    arg10.inFirstPerson = false
    arg10:UpdateMouseBehavior()

    return arg10.currentSubjectDistance
end

function t_1.CalculateNewLookVector(t3: table, vec1: Vector3, u2: Vector2) -- line: 211
    local v11 = vec1 or t3:GetCameraLookVector()
    local angle_1 = math.asin(v11.Y)
    local clampedValue_1 = math.clamp(
        u2.Y,
        angle_1 - 1.3962634015954636,
        angle_1 - -1.3962634015954636
    )
    local vec2 = Vector2.new(u2.X, clampedValue_1)
    local cframe = CFrame.new(Vector3.new(0, 0, 0), v11)

    return (CFrame.Angles(0, -vec2.X, 0) * cframe * CFrame.Angles(-vec2.Y, 0, 0)).LookVector
end

function t_1.Update(t4: table, n1: number) -- line: 222
    -- upvalues:
    --  [1] CameraInput_m (copy)
    --  [2] Players (copy)

    local now = tick()
    local v14 = now - t4.lastUpdate
    local v16 = if CameraInput_m.getRotation(n1) == Vector2.new() then false else true
    local CurrentCamera = workspace.CurrentCamera
    local v17 = CurrentCamera.CFrame
    local v18 = CurrentCamera.Focus
    local LocalPlayer = Players.LocalPlayer
    local v19 = CurrentCamera and CurrentCamera.CameraSubject
    local v20 = v19

    if v20 then
        v20 = v19:IsA("VehicleSeat")
    end

    local v21 = v19

    if v21 then
        v21 = v19:IsA("SkateboardPlatform")
    end

    if t4.lastUpdate == nil or v14 > 1 then
        t4.lastCameraTransform = nil
    end

    if v16 then
        t4.lastUserPanCamera = tick()
    end

    v16 = t4:GetSubjectPosition()

    if v16 and LocalPlayer and CurrentCamera then
        if t4.gamepadDollySpeedMultiplier ~= 1 then
            t4:SetCameraToSubjectDistance(
                t4.currentSubjectDistance * t4.gamepadDollySpeedMultiplier
            )
        end

        v18 = CFrame.new(v16)
        local v23 = CameraInput_m.getRotation(n1)
        t4.curAzimuthRad -= v23.X

        if t4.useAzimuthLimits then
            t4.curAzimuthRad = math.clamp(
                t4.curAzimuthRad,
                t4.minAzimuthAbsoluteRad,
                t4.maxAzimuthAbsoluteRad
            )
        else
            t4.curAzimuthRad = t4.curAzimuthRad ~= 0 and math.sign(t4.curAzimuthRad) * (math.abs(
                t4.curAzimuthRad
            ) % 6.283185307179586) or 0
        end

        t4.curElevationRad = math.clamp(
            t4.curElevationRad + v23.Y,
            t4.minElevationRad,
            t4.maxElevationRad
        )
        v17 = CFrame.new(
            v16 + t4.currentSubjectDistance * (CFrame.fromEulerAnglesYXZ(
                -t4.curElevationRad,
                t4.curAzimuthRad,
                0
            ) * Vector3.new(0, 0, 1)),
            v16
        )
        t4.lastCameraTransform = v17
        t4.lastCameraFocus = v18

        if if v20 then v19:IsA("BasePart") else v21 and v19:IsA("BasePart") then
            t4.lastSubjectCFrame = v19.CFrame
        else
            t4.lastSubjectCFrame = nil
        end
    end

    t4.lastUpdate = now

    return v17, v18
end

return t_1
