local _ = Vector2.new(0, 0)
local v1 = 0
local cframe = CFrame.fromOrientation(-0.2617993877991494, 0, 0)
local UserFixCameraFPError = require(
    script.Parent.Parent:WaitForChild("CommonUtils"):WaitForChild("FlagUtil")
).getUserFlag("UserFixCameraFPError")
local Players = game:GetService("Players")
local CameraInput_m = require(script.Parent:WaitForChild("CameraInput"))
local CameraUtils_m = require(script.Parent:WaitForChild("CameraUtils"))
local BaseCamera_m = require(script.Parent:WaitForChild("BaseCamera"))
local t = setmetatable({}, BaseCamera_m)
t.__index = t

function t.new() -- line: 39
    -- upvalues:
    --  [1] BaseCamera_m (copy)
    --  [2] t (copy)
    --  [3] CameraUtils_m (copy)

    local t_1 = setmetatable(BaseCamera_m.new(), t)
    t_1.isFollowCamera = false
    t_1.isCameraToggle = false
    t_1.lastUpdate = tick()
    t_1.cameraToggleSpring = CameraUtils_m.Spring.new(5, 0)

    return t_1
end

function t.GetCameraToggleOffset(t1: table, n1: number) -- line: 50
    -- upvalues:
    --  [1] CameraInput_m (copy)
    --  [2] CameraUtils_m (copy)

    if t1.isCameraToggle then
        local CurrentSubjectDistance = t1.currentSubjectDistance

        if CameraInput_m.getTogglePan() then
            t1.cameraToggleSpring.goal = math.clamp(
                CameraUtils_m.map(
                    CurrentSubjectDistance,
                    0.5,
                    t1.FIRST_PERSON_DISTANCE_THRESHOLD,
                    0,
                    1
                ),
                0,
                1
            )
        else
            t1.cameraToggleSpring.goal = 0
        end

        return (Vector3.new(
            0,
            t1.cameraToggleSpring:step(n1) * (math.clamp(
                CameraUtils_m.map(
                    CurrentSubjectDistance,
                    0.5,
                    64,
                    0,
                    1
                ),
                0,
                1
            ) + 1),
            0
        ))
    end

    return (Vector3.new())
end

function t.SetCameraMovementMode(arg1, arg2) -- line: 68
    -- upvalues:
    --  [1] BaseCamera_m (copy)

    BaseCamera_m.SetCameraMovementMode(arg1, arg2)
    arg1.isFollowCamera = arg2 == Enum.ComputerCameraMovementMode.Follow
    arg1.isCameraToggle = arg2 == Enum.ComputerCameraMovementMode.CameraToggle
end

function t.Update(arg3, arg4) -- line: 75
    -- upvalues:
    --  [1] cframe (copy)
    --  [2] Players (copy)
    --  [3] CameraInput_m (copy)
    --  [4] v1 (ref)
    --  [5] CameraUtils_m (copy)
    --  [6] UserFixCameraFPError (copy)

    local now = tick()
    local CurrentCamera = workspace.CurrentCamera
    local v10 = CurrentCamera.CFrame
    local v11 = CurrentCamera.Focus
    local LookVector_1 = nil

    if arg3.resetCameraAngle then
        local v13 = arg3:GetHumanoidRootPart()
        LookVector_1 = if v13 then (v13.CFrame * cframe).lookVector else cframe.lookVector
        arg3.resetCameraAngle = false
    end

    local LocalPlayer = Players.LocalPlayer
    local v14 = arg3:GetHumanoid()
    local CameraSubject = CurrentCamera.CameraSubject
    local v15 = CameraSubject

    if v15 then
        v15 = CameraSubject:IsA("VehicleSeat")
    end

    local v16 = CameraSubject

    if v16 then
        v16 = CameraSubject:IsA("SkateboardPlatform")
    end

    local v17 = v14

    if v17 then
        v17 = if v14:GetState() ~= Enum.HumanoidStateType.Climbing then false else true
    end

    if arg3.lastUpdate == nil or arg4 > 1 then
        arg3.lastCameraTransform = nil
    end

    local v18 = CameraInput_m.getRotation(arg4)
    arg3:StepZoom()
    local v19 = arg3:GetCameraHeight()

    if v18 ~= Vector2.new() then
        v1 = 0
        arg3.lastUserPanCamera = tick()
    end

    local v20 = now - arg3.lastUserPanCamera < 2
    local v21 = arg3:GetSubjectPosition()

    if v21 and LocalPlayer and CurrentCamera then
        local v22 = arg3:GetCameraToSubjectDistance()

        if v22 < 0.5 then
            v22 = 0.5
        end

        if arg3:GetIsMouseLocked() and not arg3:IsInFirstPerson() then
            local v23 = arg3:CalculateNewLookCFrameFromArg(LookVector_1, v18)
            local v24 = arg3:GetMouseLockOffset()

            if v14 then
                v24 += v14.CameraOffset
            end

            local v25 = v24.X * v23.RightVector + v24.Y * v23.UpVector + v24.Z * v23.LookVector

            if CameraUtils_m.IsFiniteVector3(v25) then
                v21 += v25
            end
        elseif not (if v18 == Vector2.new() then false else true) and arg3.lastCameraTransform then
            local v26 = arg3:IsInFirstPerson()

            if if v15 then arg3.lastUpdate and v14 and v14.Torso else if v16 then arg3.lastUpdate and v14 and v14.Torso else arg3.isFollowCamera and v17 and arg3.lastUpdate and v14 and v14.Torso then
                if v26 then
                    if arg3.lastSubjectCFrame then
                        local v27

                        if not v15 then
                            if v16 and CameraSubject:IsA("BasePart") then
                                v27 = -CameraUtils_m.GetAngleBetweenXZVectors(
                                    arg3.lastSubjectCFrame.lookVector,
                                    CameraSubject.CFrame.lookVector
                                )

                                if CameraUtils_m.IsFinite(v27) then
                                    v18 += Vector2.new(v27, 0)
                                end

                                v1 = 0
                            end
                        elseif CameraSubject:IsA("BasePart") then
                            v27 = -CameraUtils_m.GetAngleBetweenXZVectors(
                                arg3.lastSubjectCFrame.lookVector,
                                CameraSubject.CFrame.lookVector
                            )

                            if CameraUtils_m.IsFinite(v27) then
                                v18 += Vector2.new(v27, 0)
                            end

                            v1 = 0
                        end
                    end
                elseif not v20 then
                    local LookVector = v14.Torso.CFrame.lookVector
                    v1 = math.clamp(v1 + 3.839724354387525 * arg4, 0, 4.363323129985824)
                    local v28 = math.clamp(v1 * arg4, 0, 1)

                    if arg3:IsInFirstPerson() and (not arg3.isFollowCamera or not arg3.isClimbing) then
                        v28 = 1
                    end

                    local v29 = CameraUtils_m.GetAngleBetweenXZVectors(
                        LookVector,
                        arg3:GetCameraLookVector()
                    )

                    if CameraUtils_m.IsFinite(v29) and math.abs(v29) > 0.0001 then
                        v18 += Vector2.new(v29 * v28, 0)
                    end
                end
            elseif arg3.isFollowCamera and not v26 and not v20 then
                local v31 = CameraUtils_m.GetAngleBetweenXZVectors(
                    -(arg3.lastCameraTransform.p - v21),
                    arg3:GetCameraLookVector()
                )

                if CameraUtils_m.IsFinite(v31) and math.abs(v31) > 0.0001 and math.abs(v31) > 0.4 * arg4 then
                    v18 += Vector2.new(v31, 0)
                end
            end
        end

        if not arg3.isFollowCamera then
            v11 = CFrame.new(v21)
            local P = v11.p
            local v32 = arg3:CalculateNewLookVectorFromArg(LookVector_1, v18)
            v10 = if UserFixCameraFPError then CFrame.lookAlong(P - v22 * v32, v32) else CFrame.new(
                P - v22 * v32,
                P
            )
        else
            local v33 = arg3:CalculateNewLookVectorFromArg(LookVector_1, v18)
            v11 = CFrame.new(v21)
            v10 = if UserFixCameraFPError then CFrame.lookAlong(v11.p - v22 * v33, v33) else CFrame.new(
                v11.p - v22 * v33,
                v11.p
            ) + Vector3.new(0, v19, 0)
        end

        v22 = arg3:GetCameraToggleOffset(arg4)
        v11 += v22
        v10 += v22
        arg3.lastCameraTransform = v10
        arg3.lastCameraFocus = v11

        if if v15 then CameraSubject:IsA("BasePart") else v16 and CameraSubject:IsA("BasePart") then
            arg3.lastSubjectCFrame = CameraSubject.CFrame
        else
            arg3.lastSubjectCFrame = nil
        end
    end

    arg3.lastUpdate = now

    return v10, v11
end

return t
