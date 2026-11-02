local t = { 0, 30 }
local VRBaseCamera_m = require(script.Parent:WaitForChild("VRBaseCamera"))
local CameraUtils_m = require(script.Parent:WaitForChild("CameraUtils"))
local CameraInput_m = require(script.Parent:WaitForChild("CameraInput"))
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VRService = game:GetService("VRService")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer
local MapClamp = CameraUtils_m.mapClamp
local VehicleCameraConfig_m = require(
    script.Parent:WaitForChild("VehicleCamera"):FindFirstChild("VehicleCameraConfig")
)
local raycastParams = RaycastParams.new()
raycastParams.FilterType = Enum.RaycastFilterType.Exclude
raycastParams.IgnoreWater = true

local _ = function(vec1: Vector3, u1: CFrame) --[[ yawVelocity ]] -- line: 36
    local v5 = u1.YVector:Dot(vec1)

    return (math.abs(v5))
end

local _ = function(u2: CFrame, vec2: Vector3, n1: number) --[[ computeCameraCFrame ]] -- line: 40
    local angle = math.atan2(vec2.X, vec2.Z)

    return CFrame.new(u2.Position + vec2 * n1) * CFrame.Angles(0, angle, 0)
end

local function vrOccludeDisplace(u3: CFrame, vec3: Vector3, n2: number, u4: userdata?) -- line: 45
    -- upvalues:
    --  [1] LocalPlayer (copy)
    --  [2] raycastParams (copy)

    local angle_1 = math.atan2(vec3.X, vec3.Z)
    local v8 = CFrame.new(u3.Position + vec3 * n2) * CFrame.Angles(0, angle_1, 0)
    local v9 = workspace.CurrentCamera

    if not v9 then
        return v8
    end

    local Position = u3.Position
    local v10 = (v8.Position - Position) * Vector3.new(1, 0, 1)
    local Magnitude = v10.Magnitude

    if Magnitude < 0.5 then
        return v8
    end

    local t_1 = { v9 }

    if u4 then
        table.insert(t_1, u4)
    end

    v9 = LocalPlayer

    if v9 then
        v9 = LocalPlayer.Character
    end

    if v9 then
        table.insert(t_1, v9)
    end

    raycastParams.FilterDescendantsInstances = t_1
    local Unit = v10.Unit
    v9 = workspace:Raycast(Position, v10, raycastParams)

    if v9 and v9.Normal:Dot(Unit) < 0 then
        local v11 = (v9.Position - Position).Magnitude - 0.5

        if v11 < Magnitude then
            return CFrame.new(u3.Position + Unit * math.max(v11, 0.5)) * v8.Rotation
        end
    end

    return v8
end

local overlapParams = OverlapParams.new()
overlapParams.FilterType = Enum.RaycastFilterType.Exclude

local function findObstructions(u5: CFrame, u6: CFrame, n3: number, u7: userdata?) -- line: 81
    -- upvalues:
    --  [1] VRService (copy)
    --  [2] LocalPlayer (copy)
    --  [3] raycastParams (copy)
    --  [4] overlapParams (copy)

    local v12 = workspace.CurrentCamera

    if not v12 then
        return 0, {}
    end

    local Position_1 = u6.Position
    local v13 = VRService:GetUserCFrame(Enum.UserCFrame.Head)
    local v14 = u5 * (CFrame.new(v13.Position * v12.HeadScale) * v13.Rotation)
    local v15 = v14.Position - Position_1
    local Magnitude_1 = v15.Magnitude

    if Magnitude_1 < 0.5 then
        return 0, {}
    end

    local t_2 = { v12 }

    if u7 then
        table.insert(t_2, u7)
    end

    v12 = LocalPlayer

    if v12 then
        v12 = LocalPlayer.Character
    end

    if v12 then
        table.insert(t_2, v12)
    end

    raycastParams.FilterDescendantsInstances = t_2
    v12 = workspace:Raycast(Position_1, v15, raycastParams)

    if v12 then
        local Magnitude_2 = (v12.Position - Position_1).Magnitude

        if Magnitude_1 > Magnitude_2 then
            local maximum_1 = math.max(
                math.clamp((1 - -v15.Unit:Dot(v14.LookVector)) / 0.1339745962155613, 0, 1),
                1 - Magnitude_2 / n3,
                0.15
            )
            local Position_2 = v12.Position
            local Position_3 = v14.Position
            local v17 = (Position_2 + Position_3) / 2
            local vec3_1 = Vector3.new(2, 2, (Position_3 - Position_2).Magnitude)
            local cframe_4 = CFrame.lookAt(v17, Position_3)
            overlapParams.FilterDescendantsInstances = t_2

            return maximum_1, (workspace:GetPartBoundsInBox(cframe_4, vec3_1, overlapParams))
        end
    end

    return 0, {}
end

local v21 = 0.016666666666666666
local t_3 = setmetatable({}, VRBaseCamera_m)
t_3.__index = t_3

function t_3.new() -- line: 133
    -- upvalues:
    --  [1] VRBaseCamera_m (copy)
    --  [2] t_3 (copy)
    --  [3] RunService (copy)
    --  [4] v21 (ref)

    local t_4 = setmetatable(VRBaseCamera_m.new(), t_3)
    t_4.skipOcclusion = true
    t_4:Reset()

    if t_4.thirdPersonOptionChanged then
        t_4.thirdPersonOptionChanged:Disconnect()
        t_4.thirdPersonOptionChanged = nil
    end

    RunService.Stepped:Connect(function(_: number, n5: number) -- line: 143
        -- upvalues:
        --  [1] v21 (ref)

        v21 = n5
    end)

    return t_4
end

function t_3.Reset(arg1) -- line: 150
    -- upvalues:
    --  [1] CameraUtils_m (copy)
    --  [2] t (copy)

    local CurrentCamera = workspace.CurrentCamera
    local v23 = CurrentCamera and CurrentCamera.CameraSubject
    assert(CurrentCamera, "VRVehicleCamera initialization error")
    assert(v23)
    assert(v23:IsA("VehicleSeat"))
    arg1.lastOrbitalDir = nil
    arg1.wasInFirstPerson = nil
    local v24 = v23:GetConnectedParts(true)
    table.insert(v24, v23)
    local v25, v26 = CameraUtils_m.getLooseBoundingSphere(v24)
    v24 = v23:FindFirstAncestorOfClass("Model") or v23.Parent
    arg1.vehicleModel = v24
    arg1.assemblyRadius = math.max(v26, 5)
    arg1.assemblyOffset = v23.CFrame:Inverse() * v25
    arg1.gamepadZoomLevels = {}

    for _, val in t do
        table.insert(arg1.gamepadZoomLevels, val * arg1.headScale * arg1.assemblyRadius / 10)
    end

    arg1.lastCameraFocus = nil

    if not arg1:IsInFirstPerson() then
        arg1:SetCameraToSubjectDistance(arg1.gamepadZoomLevels[#arg1.gamepadZoomLevels])
    end

    arg1.needsReset = false
end

function t_3._getThirdPersonLocalOffset(arg2) -- line: 184
    -- upvalues:
    --  [1] VehicleCameraConfig_m (copy)

    return arg2.assemblyOffset + Vector3.new(
        0,
        arg2.assemblyRadius * VehicleCameraConfig_m.verticalCenterOffset,
        0
    )
end

function t_3._getFirstPersonLocalOffset(t1: table, u8: CFrame) -- line: 188
    -- upvalues:
    --  [1] LocalPlayer (copy)

    local Character = LocalPlayer.Character

    if Character and Character.Parent then
        local Head = Character:FindFirstChild("Head")

        if Head and Head:IsA("BasePart") then
            return u8:Inverse() * Head.Position
        end
    end

    return t1:_getThirdPersonLocalOffset()
end

function t_3._vrOccludeVignette(t2: table, u9: CFrame, vec4: Vector3, n6: number) -- line: 202
    -- upvalues:
    --  [1] findObstructions (copy)
    --  [2] Lighting (copy)
    --  [3] LocalPlayer (copy)

    local angle_2 = math.atan2(vec4.X, vec4.Z)
    local v30 = CFrame.new(u9.Position + vec4 * n6) * CFrame.Angles(0, angle_2, 0)
    local v31, v32 = findObstructions(v30, u9, n6, t2.vehicleModel)
    local v33 = Lighting:FindFirstChild("VRFade")

    if not v33 then
        v33 = Instance.new("ColorCorrectionEffect")
        v33.Name = "VRFade"
        v33.Parent = Lighting
    end

    v33.Brightness = -v31

    if t2.lastOccludedParts then
        for _, val_1 in t2.lastOccludedParts do
            val_1.LocalTransparencyModifier = 0
        end
    end

    if #v32 > 0 then
        for _, val_2 in v32 do
            val_2.LocalTransparencyModifier = 1
        end

        t2:StartVREdgeBlur(LocalPlayer, true)
    end

    t2.lastOccludedParts = v32

    return v30
end

function t_3.Update(arg3) -- line: 229
    -- upvalues:
    --  [1] v21 (ref)
    --  [2] LocalPlayer (copy)

    local v34 = v21
    v21 = 0
    arg3:UpdateFadeFromBlack(v34)
    arg3:UpdateEdgeBlur(LocalPlayer, v34)
    local v35, v36 = arg3:_updateStepRotation(v34)

    return v35, v36
end

function t_3._updateStepRotation(t3: table, n7: number) -- line: 241
    -- upvalues:
    --  [1] MapClamp (copy)
    --  [2] CameraInput_m (copy)
    --  [3] VehicleCameraConfig_m (copy)
    --  [4] vrOccludeDisplace (copy)

    local v37 = t3:GetSubjectCFrame()
    local v38 = t3:GetCameraToSubjectDistance()
    local v39 = MapClamp(
        v38,
        0.5,
        t3.assemblyRadius,
        1,
        0
    )
    local v43 = v37 * t3:_getThirdPersonLocalOffset():Lerp(t3:_getFirstPersonLocalOffset(v37), v39)
    local New = CFrame.new
    local v44 = t3:GetCameraHeight()
    local v45 = New(v43 + Vector3.new(0, v44, 0))

    if t3.needsReset or t3.recentered then
        t3.lastOrbitalDir = nil
        t3.needsReset = false
        t3.recentered = false
    end

    v43 = t3.lastOrbitalDir

    if not v43 then
        v43 = (v37.LookVector * Vector3.new(-1, 0, -1)).Unit
        t3:StartFadeFromBlack()
    end

    v39 = (t3:GetSubjectVelocity() * Vector3.new(1, 0, 1)).Magnitude > 2 and true

    if not v39 then
        local v46 = t3:getRotation(n7)

        if math.abs(v46) > 0 then
            v43 = (CFrame.Angles(0, -v46, 0) * CFrame.new(v43)).Position.Unit
            t3.lastRotateTime = os.clock()
        end
    else
        CameraInput_m.getRotation(n7)
    end

    local v49

    if t3:IsInFirstPerson() then
        if not t3.wasInFirstPerson or v39 then
            v43 = (v37.LookVector * Vector3.new(-1, 0, -1)).Unit
            t3.wasInFirstPerson = true
        end

        local angle_3 = math.atan2(-v37.LookVector.X, -v37.LookVector.Z)

        if t3.lastVehicleYaw then
            local v47 = (angle_3 - t3.lastVehicleYaw + 3.141592653589793) % 6.283185307179586 - 3.141592653589793

            if math.abs(v47) > 0.001 then
                v43 = (CFrame.Angles(0, v47, 0) * CFrame.new(v43)).Position.Unit
            end
        end

        t3.lastVehicleYaw = angle_3
        local angle_4 = math.atan2(v43.X, v43.Z)
        v49 = CFrame.new(v45.Position + v43 * v38) * CFrame.Angles(0, angle_4, 0)
    else
        t3.wasInFirstPerson = false
        t3.lastVehicleYaw = nil

        if
            v39
            and not (t3.lastRotateTime and os.clock() - t3.lastRotateTime < VehicleCameraConfig_m.autocorrectDelay)
        then
            local Unit_1 = (v37.LookVector * Vector3.new(-1, 0, -1)).Unit
            local angle_5 = math.acos((math.clamp(v43:Dot(Unit_1), -1, 1)))
            v43 = v43:Lerp(
                Unit_1,
                (math.min(
                    0.01 + angle_5 / 3.141592653589793 * 0.05 + math.abs(
                        (v37.YVector:Dot((t3:GetSubjectRotVelocity())))
                    ) * 0.02,
                    0.15
                ))
            )
        end

        v49 = vrOccludeDisplace(v45, v43, v38, t3.vehicleModel)
    end

    t3.lastOrbitalDir = v43

    return v49, v49 * CFrame.new(0, 0, -v38)
end

return t_3
