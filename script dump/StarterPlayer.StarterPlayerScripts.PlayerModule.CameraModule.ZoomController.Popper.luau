local Players = game:GetService("Players")
local CommonUtils = script.Parent.Parent.Parent:WaitForChild("CommonUtils")
local v1 = require(CommonUtils:WaitForChild("FlagUtil"))
local CameraWrapper_m = require(CommonUtils:WaitForChild("CameraWrapper"))
local ConnectionUtil_m = require(CommonUtils:WaitForChild("ConnectionUtil"))
local UserRaycastUpdateAPI2 = v1.getUserFlag("UserRaycastUpdateAPI2")
local UserCurrentCameraUpdate2 = v1.getUserFlag("UserCurrentCameraUpdate2")
local UserPlayerConnectionMemoryLeak = v1.getUserFlag("UserPlayerConnectionMemoryLeak")
v1 = if UserCurrentCameraUpdate2 then CameraWrapper_m.new() else nil
local v4 = if not UserCurrentCameraUpdate2 then game.Workspace.CurrentCamera else nil

if UserCurrentCameraUpdate2 then
    v1:Enable()
end

local math_min = math.min
local math_tan = math.tan
local math_rad = math.rad
local New = Ray.new
local raycastParams = RaycastParams.new()
raycastParams.IgnoreWater = true
raycastParams.FilterType = Enum.RaycastFilterType.Exclude
raycastParams.RespectCanCollide = true
local raycastParams_1 = RaycastParams.new()
raycastParams_1.IgnoreWater = true
raycastParams_1.FilterType = Enum.RaycastFilterType.Include
local v5 = if not UserPlayerConnectionMemoryLeak then nil else ConnectionUtil_m.new()

local _ = function(arg1) --[[ getTotalTransparency ]] -- line: 43
    return 1 - (1 - arg1.Transparency) * (1 - arg1.LocalTransparencyModifier)
end

local _ = function(arg2, arg3) --[[ eraseFromEnd ]] -- line: 47
    for index = #arg2, arg3 + 1, -1 do
        arg2[index] = nil
    end
end

local v6 = nil
local v7 = nil
local NearPlaneZ_1

if UserCurrentCameraUpdate2 then
    local function updateProjection() -- line: 57
        -- upvalues:
        --  [1] v1 (copy)
        --  [2] math_rad (copy)
        --  [3] v7 (ref)
        --  [4] math_tan (copy)
        --  [5] v6 (ref)

        local v8 = v1:getCamera()
        local v9 = math_rad(v8.FieldOfView)
        local ViewportSize = v8.ViewportSize
        local v10 = ViewportSize.X / ViewportSize.Y
        v7 = math_tan(v9 / 2) * 2
        v6 = v10 * v7
    end

    v1:Connect("FieldOfView", updateProjection)
    v1:Connect("ViewportSize", updateProjection)
    local v11 = v1:getCamera()
    local v12 = math_rad(v11.FieldOfView)
    local ViewportSize_1 = v11.ViewportSize
    local v13 = ViewportSize_1.X / ViewportSize_1.Y
    v7 = math_tan(v12 / 2) * 2
    v6 = v13 * v7
    NearPlaneZ_1 = v1:getCamera().NearPlaneZ
    v1:Connect("NearPlaneZ", function() -- line: 73
        -- upvalues:
        --  [1] NearPlaneZ_1 (ref)
        --  [2] v1 (copy)

        NearPlaneZ_1 = v1:getCamera().NearPlaneZ
    end)
else
    local function updateProjection_1() --[[ updateProjection ]] -- line: 79
        -- upvalues:
        --  [1] v4 (ref)
        --  [2] math_rad (copy)
        --  [3] v7 (ref)
        --  [4] math_tan (copy)
        --  [5] v6 (ref)

        local v16 = math_rad(v4.FieldOfView)
        local ViewportSize_2 = v4.ViewportSize
        local v17 = ViewportSize_2.X / ViewportSize_2.Y
        v7 = math_tan(v16 / 2) * 2
        v6 = v17 * v7
    end

    v4:GetPropertyChangedSignal("FieldOfView"):Connect(updateProjection_1)
    v4:GetPropertyChangedSignal("ViewportSize"):Connect(updateProjection_1)
    local v18 = math_rad(v4.FieldOfView)
    local ViewportSize_4 = v4.ViewportSize
    local v19 = ViewportSize_4.X / ViewportSize_4.Y
    v7 = math_tan(v18 / 2) * 2
    v6 = v19 * v7
    NearPlaneZ_1 = v4.NearPlaneZ
    v4:GetPropertyChangedSignal("NearPlaneZ"):Connect(function() -- line: 93
        -- upvalues:
        --  [1] NearPlaneZ_1 (ref)
        --  [2] v4 (ref)

        NearPlaneZ_1 = v4.NearPlaneZ
    end)
end

local t_3 = {}
local t = {}

local _ = function() --[[ refreshIgnoreList ]] -- line: 102
    -- upvalues:
    --  [1] t_3 (ref)
    --  [2] t (copy)

    local v21 = 1
    t_3 = {}

    for _, val in pairs(t) do
        t_3[v21] = val
        v21 += 1
    end
end

local function playerAdded(arg4) -- line: 111
    -- upvalues:
    --  [1] t (copy)
    --  [2] t_3 (ref)
    --  [3] UserPlayerConnectionMemoryLeak (copy)
    --  [4] v5 (copy)

    local function characterAdded(arg5) -- line: 112
        -- upvalues:
        --  [1] t (ref)
        --  [2] arg4 (copy)
        --  [3] t_3 (ref)

        t[arg4] = arg5
        local v22 = 1
        t_3 = {}

        for _, val_1 in pairs(t) do
            t_3[v22] = val_1
            v22 += 1
        end
    end

    local function characterRemoving() -- line: 116
        -- upvalues:
        --  [1] t (ref)
        --  [2] arg4 (copy)
        --  [3] t_3 (ref)

        t[arg4] = nil
        local v23 = 1
        t_3 = {}

        for _, val_2 in pairs(t) do
            t_3[v23] = val_2
            v23 += 1
        end
    end

    if UserPlayerConnectionMemoryLeak then
        v5:trackConnection(
            `{arg4.UserId}CharacterAdded`,
            arg4.CharacterAdded:Connect(characterAdded)
        )
        v5:trackConnection(
            `{arg4.UserId}CharacterRemoving`,
            arg4.CharacterRemoving:Connect(characterRemoving)
        )
    else
        arg4.CharacterAdded:Connect(characterAdded)
        arg4.CharacterRemoving:Connect(characterRemoving)
    end

    if arg4.Character then
        t[arg4] = arg4.Character
        characterRemoving = 1
        t_3 = {}

        for _, val_3 in pairs(t) do
            t_3[characterRemoving] = val_3
            characterRemoving += 1
        end
    end
end

local function playerRemoving(arg6) -- line: 134
    -- upvalues:
    --  [1] t (copy)
    --  [2] t_3 (ref)
    --  [3] UserPlayerConnectionMemoryLeak (copy)
    --  [4] v5 (copy)

    t[arg6] = nil
    local v28 = 1
    t_3 = {}

    for _, val_4 in pairs(t) do
        t_3[v28] = val_4
        v28 += 1
    end

    if UserPlayerConnectionMemoryLeak then
        v5:disconnect(`{arg6.UserId}CharacterAdded`)
        v5:disconnect(`{arg6.UserId}CharacterRemoving`)
    end
end

Players.PlayerAdded:Connect(playerAdded)
Players.PlayerRemoving:Connect(playerRemoving)

for _, val_5 in ipairs(Players:GetPlayers()) do
    playerAdded(val_5)
end

playerRemoving = 1
t_3 = {}

for _, val_6 in pairs(t) do
    t_3[playerRemoving] = val_6
    playerRemoving += 1
end

local v34 = nil
local v35 = nil

if UserCurrentCameraUpdate2 then
    v1:Connect("CameraSubject", function() -- line: 174
        -- upvalues:
        --  [1] v1 (copy)
        --  [2] v35 (ref)

        local CameraSubject = v1:getCamera().CameraSubject

        if CameraSubject and CameraSubject:IsA("Humanoid") then
            v35 = CameraSubject.RootPart

            return
        end

        if CameraSubject and CameraSubject:IsA("BasePart") then
            v35 = CameraSubject

            return
        end

        v35 = nil
    end)
else
    v4:GetPropertyChangedSignal("CameraSubject"):Connect(function() -- line: 185
        -- upvalues:
        --  [1] v4 (ref)
        --  [2] v35 (ref)

        local CameraSubject_2 = v4.CameraSubject

        if CameraSubject_2:IsA("Humanoid") then
            v35 = CameraSubject_2.RootPart

            return
        end

        if CameraSubject_2:IsA("BasePart") then
            v35 = CameraSubject_2

            return
        end

        v35 = nil
    end)
end

local _ = function(arg7) --[[ canOcclude ]] -- line: 197
    -- upvalues:
    --  [1] UserRaycastUpdateAPI2 (copy)
    --  [2] v34 (ref)

    local v36 = false

    if 1 - (1 - arg7.Transparency) * (1 - arg7.LocalTransparencyModifier) < 0.25 then
        if not UserRaycastUpdateAPI2 then
            v36 = arg7.CanCollide

            if v36 then
                v36 = if v34 ~= (arg7:GetRootPart() or arg7) then not arg7:IsA("TrussPart") else false
            end
        else
            v36 = if v34 ~= (arg7:GetRootPart() or arg7) then not arg7:IsA("TrussPart") else false
        end
    end

    return v36
end

local t_1 = {
    Vector2.new(0.4, 0),
    Vector2.new(-0.4, 0),
    Vector2.new(0, -0.4),
    Vector2.new(0, 0.4),
    Vector2.new(0, 0.2)
}

local function getCollisionPoint(arg8, arg9) -- line: 225
    -- upvalues:
    --  [1] UserRaycastUpdateAPI2 (copy)
    --  [2] raycastParams (copy)
    --  [3] t_3 (ref)
    --  [4] New (copy)

    if UserRaycastUpdateAPI2 then
        raycastParams.FilterDescendantsInstances = t_3
        local raycastResult = workspace:Raycast(arg8, arg9, raycastParams)

        if raycastResult then
            return raycastResult.Position, true
        end
    else
        local v39 = #t_3
        local v42

        repeat
            local v43
            v42, v43 = workspace:FindPartOnRayWithIgnoreList(New(arg8, arg9), t_3, false, true)

            if v42 then
                if v42.CanCollide then
                    local v44 = t_3

                    for index_1 = #v44, v39 + 1, -1 do
                        v44[index_1] = nil
                    end

                    return v43, true
                end

                t_3[#t_3 + 1] = v42
            end
        until not v42

        local v46 = t_3

        for index_2 = #v46, v39 + 1, -1 do
            v46[index_2] = nil
        end
    end

    return arg8 + arg9, false
end

local function queryPoint(arg10, arg11, arg12, arg13) -- line: 258
    -- upvalues:
    --  [1] t_3 (ref)
    --  [2] NearPlaneZ_1 (ref)
    --  [3] UserRaycastUpdateAPI2 (copy)
    --  [4] raycastParams (copy)
    --  [5] v34 (ref)
    --  [6] raycastParams_1 (copy)
    --  [7] New (copy)

    debug.profilebegin("queryPoint")
    local v47 = #t_3
    arg12 += NearPlaneZ_1
    local v48 = arg10 + arg11 * arg12
    local v49 = math.huge
    local v50 = math.huge
    local v51 = arg10
    local v52 = 0

    if UserRaycastUpdateAPI2 then
        raycastParams.FilterDescendantsInstances = t_3
        local v54

        repeat
            local raycastResult_1 = workspace:Raycast(v51, v48 - v51, raycastParams)

            if not raycastResult_1 then
                break
            end

            v52 += 1
            v54 = raycastResult_1.Instance
            local Position = raycastResult_1.Position
            local Magnitude = (Position - arg10).Magnitude

            if v52 >= 64 then
                v50 = Magnitude
            else
                local v55 = false

                if 1 - (1 - v54.Transparency) * (1 - v54.LocalTransparencyModifier) < 0.25 then
                    if not UserRaycastUpdateAPI2 then
                        v55 = v54.CanCollide

                        if v55 then
                            v55 = if v34 ~= (v54:GetRootPart() or v54) then not v54:IsA("TrussPart") else false
                        end
                    else
                        v55 = if v34 ~= (v54:GetRootPart() or v54) then not v54:IsA("TrussPart") else false
                    end
                end

                if v55 then
                    raycastParams_1.FilterDescendantsInstances = { v54 }

                    if workspace:Raycast(v48, Position - v48, raycastParams_1) then
                        local v60 = if arg13 then workspace:Raycast(
                            arg13,
                            v48 - arg13,
                            raycastParams_1
                        ) or workspace:Raycast(v48, arg13 - v48, raycastParams_1) else false

                        if v60 then
                            v50 = Magnitude
                        elseif arg12 < v49 then
                            v49 = Magnitude
                        end
                    else
                        v50 = Magnitude
                    end
                end
            end

            raycastParams:AddToFilter(v54)
            v51 = Position - arg11 * 0.001
        until v50 < math.huge or not v54
    else
        local v64

        repeat
            local v62 = workspace
            local v63 = New(v51, v48 - v51)
            local v65
            v64, v65 = v62:FindPartOnRayWithIgnoreList(v63, t_3, false, true)
            v52 += 1

            if v64 then
                v63 = v52 >= 64
                local v66 = false

                if 1 - (1 - v64.Transparency) * (1 - v64.LocalTransparencyModifier) < 0.25 then
                    if not UserRaycastUpdateAPI2 then
                        v66 = v64.CanCollide

                        if v66 then
                            v66 = if v34 ~= (v64:GetRootPart() or v64) then not v64:IsA("TrussPart") else false
                        end
                    else
                        v66 = if v34 ~= (v64:GetRootPart() or v64) then not v64:IsA("TrussPart") else false
                    end
                end

                if v66 or v63 then
                    v66 = { v64 }
                    local v69 = workspace
                    local v70 = New(v48, v65 - v48)
                    local v71 = v69:FindPartOnRayWithWhitelist(v70, v66, true)
                    local Magnitude_1 = (v65 - arg10).Magnitude

                    if v71 and not v63 then
                        v70 = false

                        if arg13 then
                            v70 = workspace:FindPartOnRayWithWhitelist(
                                New(arg13, v48 - arg13),
                                v66,
                                true
                            ) or workspace:FindPartOnRayWithWhitelist(
                                New(v48, arg13 - v48),
                                v66,
                                true
                            )
                        end

                        if v70 then
                            v50 = Magnitude_1
                        elseif arg12 < v49 then
                            v49 = Magnitude_1
                        end
                    else
                        v50 = Magnitude_1
                    end
                end

                t_3[#t_3 + 1] = v64
                v51 = v65 - arg11 * 0.001
            end
        until v50 < math.huge or not v64

        local v77 = t_3

        for index_3 = #v77, v47 + 1, -1 do
            v77[index_3] = nil
        end
    end

    debug.profileend()

    return v49 - NearPlaneZ_1, v50 - NearPlaneZ_1
end

local function queryViewport(arg14, arg15) -- line: 361
    -- upvalues:
    --  [1] v4 (ref)
    --  [2] UserCurrentCameraUpdate2 (copy)
    --  [3] v1 (copy)
    --  [4] v6 (ref)
    --  [5] v7 (ref)
    --  [6] NearPlaneZ_1 (ref)
    --  [7] queryPoint (copy)

    debug.profilebegin("queryViewport")
    local P = arg14.p
    local RightVector = arg14.rightVector
    local UpVector = arg14.upVector
    local v78 = -arg14.lookVector
    v4 = if UserCurrentCameraUpdate2 then v1:getCamera() else v4
    local ViewportSize_5 = v4.ViewportSize
    local v80 = math.huge
    local v81 = math.huge

    for index_4 = 0, 1 do
        local v82 = RightVector * ((index_4 - 0.5) * v6)

        for index_5 = 0, 1 do
            local v86 = P + NearPlaneZ_1 * (v82 + UpVector * ((index_5 - 0.5) * v7))
            local v88
            v88, v86 = queryPoint(
                v86,
                v78,
                arg15,
                v4:ViewportPointToRay(ViewportSize_5.x * index_4, ViewportSize_5.y * index_5).Origin
            )

            if v80 > v86 then
                v80 = v86
            end

            if v81 > v88 then
                v81 = v88
            end
        end
    end

    debug.profileend()

    return v81, v80
end

local function testPromotion(arg16, arg17, arg18) -- line: 404
    -- upvalues:
    --  [1] getCollisionPoint (copy)
    --  [2] math_min (copy)
    --  [3] queryPoint (copy)
    --  [4] t_1 (copy)

    debug.profilebegin("testPromotion")
    local P_1 = arg16.p
    local RightVector_1 = arg16.rightVector
    local UpVector_1 = arg16.upVector
    local v89 = -arg16.lookVector
    debug.profilebegin("extrapolate")

    for index_6 = 0, math_min(
        1.25,
        arg18.rotVelocity.magnitude + (getCollisionPoint(P_1, arg18.posVelocity * 1.25) - P_1).Magnitude / arg18.posVelocity.magnitude
    ), 0.0625 do
        local v90 = arg18.extrapolate(index_6)

        if arg17 <= queryPoint(v90.p, -v90.lookVector, arg17) then
            return false
        end
    end

    debug.profileend()
    debug.profilebegin("testOffsets")

    for _, val_7 in ipairs(t_1) do
        local v91 = getCollisionPoint(P_1, RightVector_1 * val_7.x + UpVector_1 * val_7.y)

        if queryPoint(v91, (P_1 + v89 * arg17 - v91).Unit, arg17) == math.huge then
            return false
        end
    end

    debug.profileend()
    debug.profileend()

    return true
end

local function Popper(arg19, arg20, arg21) -- line: 453
    -- upvalues:
    --  [1] v34 (ref)
    --  [2] v35 (ref)
    --  [3] queryViewport (copy)
    --  [4] testPromotion (copy)

    debug.profilebegin("popper")
    local v92 = v35 and v35:GetRootPart() or v35
    v34 = v92
    v92 = arg20
    local v93, v94 = queryViewport(arg19, arg20)

    if v92 > v94 then
        v92 = v94
    end

    v92 = if not (v92 > v93) then v92 else if not testPromotion(arg19, arg20, arg21) then v92 else v93
    v34 = nil
    debug.profileend()

    return v92
end

return Popper
