local Success, Result = pcall(function() -- line: 10
    return UserSettings():IsUserFeatureEnabled("UserExcludeNonCollidableForPathfinding")
end)
local Success_1, Result_1 = pcall(function() -- line: 14
    return UserSettings():IsUserFeatureEnabled("UserClickToMoveSupportAgentCanClimb2")
end)
local UserInputService = game:GetService("UserInputService")
local PathfindingService = game:GetService("PathfindingService")
local Players = game:GetService("Players")
local _ = game:GetService("Debris")
local StarterGui = game:GetService("StarterGui")
local Workspace = game:GetService("Workspace")
local CollectionService = game:GetService("CollectionService")
local GuiService = game:GetService("GuiService")
local UserRaycastUpdateAPI2 = require(
    script.Parent.Parent:WaitForChild("CommonUtils"):WaitForChild("FlagUtil")
).getUserFlag("UserRaycastUpdateAPI2")
local v1 = true
local v2 = true
local v3 = false
local v4 = 1
local v5 = 8
local t = {}
t[Enum.KeyCode.W] = true
t[Enum.KeyCode.A] = true
t[Enum.KeyCode.S] = true
t[Enum.KeyCode.D] = true
t[Enum.KeyCode.Up] = true
t[Enum.KeyCode.Down] = true
local LocalPlayer = Players.LocalPlayer
local ClickToMoveDisplay_m = require(script.Parent:WaitForChild("ClickToMoveDisplay"))
local raycastParams = RaycastParams.new()
raycastParams.FilterType = Enum.RaycastFilterType.Exclude
local t_1 = {}

if not UserRaycastUpdateAPI2 then
    local function FindCharacterAncestor(arg1) -- line: 65
        -- upvalues:
        --  [1] FindCharacterAncestor (copy)

        if arg1 then
            local Humanoid = arg1:FindFirstChildOfClass("Humanoid")

            if Humanoid then
                return arg1, Humanoid
            end

            return FindCharacterAncestor(arg1.Parent)
        else
            return
        end
    end

    t_1.FindCharacterAncestor = FindCharacterAncestor

    local function Raycast(arg2: any, b1: boolean, t1: table) -- line: 77
        -- upvalues:
        --  [1] Workspace (copy)
        --  [2] FindCharacterAncestor (copy)
        --  [3] Raycast (copy)

        local v10, v8, v9
        local v7 = t1 or {}
        t1 = v7
        v7, v8, v9, v10 = Workspace:FindPartOnRayWithIgnoreList(arg2, t1)

        if v7 then
            if b1 and v7.CanCollide == false then
                local v11

                if v7 then
                    local Humanoid_1 = v7:FindFirstChildOfClass("Humanoid")

                    if Humanoid_1 then
                        v11 = Humanoid_1
                    else
                        local _ = v7.CanCollide
                        local _, v13 = FindCharacterAncestor(v7.Parent)
                        v11 = v13
                    end
                else
                    v11 = nil
                end

                if v11 == nil then
                    table.insert(t1, v7)

                    return Raycast(arg2, b1, t1)
                end
            end

            return v7, v8, v9, v10
        end

        return nil, nil
    end

    t_1.Raycast = Raycast
end

local t_2 = {}

local _ = function(u1: userdata) --[[ findPlayerHumanoid ]] -- line: 99
    -- upvalues:
    --  [1] t_2 (copy)

    local v14 = u1

    if v14 then
        v14 = u1.Character
    end

    if v14 then
        local v15 = t_2[u1]

        if v15 and v15.Parent == v14 then
            return v15
        end

        t_2[u1] = nil
        local Humanoid_2 = v14:FindFirstChildOfClass("Humanoid")

        if Humanoid_2 then
            t_2[u1] = Humanoid_2
        end

        return Humanoid_2
    end
end

local t_12 = nil
local v17 = nil

local _ = function() --[[ GetCharacter ]] -- line: 123
    -- upvalues:
    --  [1] LocalPlayer (copy)

    return LocalPlayer and LocalPlayer.Character
end

local v19 = nil
local v20 = nil

local function UpdateIgnoreTag(arg3) -- line: 127
    -- upvalues:
    --  [1] v17 (ref)
    --  [2] v19 (ref)
    --  [3] v20 (ref)
    --  [4] t_12 (ref)
    --  [5] LocalPlayer (copy)
    --  [6] CollectionService (copy)

    if arg3 == v17 then
        return
    end

    if v19 then
        v19:Disconnect()
        v19 = nil
    end

    if v20 then
        v20:Disconnect()
        v20 = nil
    end

    v17 = arg3
    local v21 = LocalPlayer and LocalPlayer.Character
    t_12 = { v21 }

    if v17 ~= nil then
        for _, val in ipairs((CollectionService:GetTagged(v17))) do
            table.insert(t_12, val)
        end

        v19 = CollectionService:GetInstanceAddedSignal(v17):Connect(function(arg4) -- line: 147
            -- upvalues:
            --  [1] t_12 (ref)

            table.insert(t_12, arg4)
        end)
        v20 = CollectionService:GetInstanceRemovedSignal(v17):Connect(function(arg5) -- line: 151
            -- upvalues:
            --  [1] t_12 (ref)

            for index = 1, #t_12 do
                if t_12[index] == arg5 then
                    t_12[index] = t_12[#t_12]
                    table.remove(t_12)

                    return
                end
            end
        end)
    end
end

local _ = function() --[[ getIgnoreList ]] -- line: 163
    -- upvalues:
    --  [1] t_12 (ref)
    --  [2] LocalPlayer (copy)

    if t_12 then
        return t_12
    end

    t_12 = {}
    assert(t_12, "")
    local v24 = LocalPlayer
    local v25 = t_12

    if v24 then
        v24 = LocalPlayer.Character
    end

    table.insert(v25, v24)

    return t_12
end

local _ = function(vec1: Vector3, vec2: Vector3) --[[ minV ]] -- line: 173
    local minimum = math.min(vec1.X, vec2.X)
    local minimum_1 = math.min(vec1.Y, vec2.Y)
    local minimum_2 = math.min(vec1.Z, vec2.Z)

    return (Vector3.new(minimum, minimum_1, minimum_2))
end

local _ = function(arg6, arg7) --[[ maxV ]] -- line: 176
    local maximum = math.max(arg6.X, arg7.X)
    local maximum_1 = math.max(arg6.Y, arg7.Y)
    local maximum_2 = math.max(arg6.Z, arg7.Z)

    return (Vector3.new(maximum, maximum_1, maximum_2))
end

local function getCollidableExtentsSize(u2: userdata?) -- line: 179
    if u2 == nil or u2.PrimaryPart == nil then
        return
    end

    assert(u2, "")
    assert(u2.PrimaryPart, "")
    local v26 = u2.PrimaryPart.CFrame:Inverse()
    local v27 = Vector3.new(Infinity, Infinity, Infinity)
    local v28 = Vector3.new(-Infinity, -Infinity, -Infinity)

    for _, descendant in pairs(u2:GetDescendants()) do
        if descendant:IsA("BasePart") and descendant.CanCollide then
            local v30 = v26 * descendant.CFrame
            local vec3 = Vector3.new(
                descendant.Size.X / 2,
                descendant.Size.Y / 2,
                descendant.Size.Z / 2
            )

            for _, val_1 in ipairs(
                {
                    Vector3.new(vec3.X, vec3.Y, vec3.Z),
                    Vector3.new(vec3.X, vec3.Y, -vec3.Z),
                    Vector3.new(vec3.X, -vec3.Y, vec3.Z),
                    Vector3.new(vec3.X, -vec3.Y, -vec3.Z),
                    Vector3.new(-vec3.X, vec3.Y, vec3.Z),
                    Vector3.new(-vec3.X, vec3.Y, -vec3.Z),
                    Vector3.new(-vec3.X, -vec3.Y, vec3.Z),
                    (Vector3.new(-vec3.X, -vec3.Y, -vec3.Z))
                }
            ) do
                local v31 = v30 * val_1
                local v32 = v27
                local minimum_3 = math.min(v32.X, v31.X)
                local minimum_4 = math.min(v32.Y, v31.Y)
                v27 = Vector3.new(minimum_3, minimum_4, (math.min(v32.Z, v31.Z)))
                local v33 = v28
                local maximum_3 = math.max(v33.X, v31.X)
                local maximum_4 = math.max(v33.Y, v31.Y)
                v28 = Vector3.new(maximum_3, maximum_4, (math.max(v33.Z, v31.Z)))
            end
        end
    end

    local v34 = v28 - v27

    if v34.X < 0 or v34.Y < 0 or v34.Z < 0 then
        return nil
    end

    return v34
end

local v35 = Success and Result
local v36 = Success_1 and Result_1

local function Pather(arg8: any, arg9: any, b2: boolean?) -- line: 214
    -- upvalues:
    --  [1] v3 (ref)
    --  [2] LocalPlayer (copy)
    --  [3] t_2 (copy)
    --  [4] v4 (ref)
    --  [5] v35 (copy)
    --  [6] getCollidableExtentsSize (copy)
    --  [7] v36 (copy)
    --  [8] PathfindingService (copy)
    --  [9] v1 (ref)
    --  [10] ClickToMoveDisplay_m (copy)
    --  [11] v5 (ref)
    --  [12] UserRaycastUpdateAPI2 (copy)
    --  [13] raycastParams (copy)
    --  [14] t_12 (ref)
    --  [15] Workspace (copy)

    local t_5 = {
        Cancelled = false,
        Started = false,
        Finished = Instance.new("BindableEvent"),
        PathFailed = Instance.new("BindableEvent"),
        PathComputing = false,
        PathComputed = false,
        OriginalTargetPoint = arg8,
        TargetPoint = arg8,
        TargetSurfaceNormal = arg9,
        DiedConn = nil,
        SeatedConn = nil,
        BlockedConn = nil,
        TeleportedConn = nil,
        CurrentPoint = 0,
        HumanoidOffsetFromPath = Vector3.new(0, 0, 0),
        CurrentWaypointPosition = nil,
        CurrentWaypointPlaneNormal = Vector3.new(0, 0, 0),
        CurrentWaypointPlaneDistance = 0,
        CurrentWaypointNeedsJump = false,
        CurrentHumanoidPosition = Vector3.new(0, 0, 0),
        CurrentHumanoidVelocity = 0,
        NextActionMoveDirection = Vector3.new(0, 0, 0),
        NextActionJump = false,
        Timeout = 0
    }
    local v37, v38

    if b2 ~= nil then
        v37 = b2
        v38 = b2
    else
        v37 = v3
        v38 = true
    end

    local v39 = LocalPlayer
    local v40 = v39

    if v40 then
        v40 = v39.Character
    end

    local v41, v42

    if v40 then
        v41 = t_2[v39]

        if v41 and v41.Parent == v40 then
            v42 = v41
        else
            t_2[v39] = nil
            local Humanoid_3 = v40:FindFirstChildOfClass("Humanoid")

            if Humanoid_3 then
                t_2[v39] = Humanoid_3
            end

            v42 = Humanoid_3
        end
    else
        v42 = nil
    end

    t_5.Humanoid = v42
    t_5.OriginPoint = nil
    t_5.AgentCanFollowPath = false
    t_5.DirectPath = false
    t_5.DirectPathRiseFirst = false
    t_5.stopTraverseFunc = nil
    t_5.setPointFunc = nil
    t_5.pointList = nil
    local v43 = t_5.Humanoid

    if v43 then
        v43 = t_5.Humanoid.RootPart
    end

    if v43 then
        t_5.OriginPoint = v43.CFrame.Position
        local v44 = 2
        v40 = 5
        v41 = true
        local SeatPart = t_5.Humanoid.SeatPart
        local v45

        if SeatPart and SeatPart:IsA("VehicleSeat") then
            v45 = SeatPart:FindFirstAncestorOfClass("Model")

            if v45 then
                local PrimaryPart = v45.PrimaryPart
                v45.PrimaryPart = SeatPart

                if v38 then
                    local extentsSize = v45:GetExtentsSize()
                    v44 = v4 * 0.5 * math.sqrt(
                        extentsSize.X * extentsSize.X + extentsSize.Z * extentsSize.Z
                    )
                    v40 = v4 * extentsSize.Y
                    v41 = false
                    t_5.AgentCanFollowPath = true
                    t_5.DirectPath = v38
                end

                v45.PrimaryPart = PrimaryPart
            end
        else
            v45 = nil
            local v47

            if v35 then
                v47 = LocalPlayer

                if v47 then
                    v47 = LocalPlayer.Character
                end

                if v47 ~= nil then
                    v45 = getCollidableExtentsSize(v47)
                end
            end

            if v45 == nil then
                v47 = LocalPlayer and LocalPlayer.Character
                v45 = v47:GetExtentsSize()
            end

            assert(v45, "")
            v44 = v4 * 0.5 * math.sqrt(v45.X * v45.X + v45.Z * v45.Z)
            v40 = v4 * v45.Y
            v41 = t_5.Humanoid.JumpPower > 0 and true
            t_5.AgentCanFollowPath = true
            t_5.DirectPath = v37
            t_5.DirectPathRiseFirst = t_5.Humanoid.Sit
        end

        if v36 then
            t_5.pathResult = PathfindingService:CreatePath(
                { AgentRadius = v44, AgentHeight = v40, AgentCanJump = v41, AgentCanClimb = true }
            )
        else
            t_5.pathResult = PathfindingService:CreatePath(
                { AgentRadius = v44, AgentHeight = v40, AgentCanJump = v41 }
            )
        end
    end

    function t_5.Cleanup(_) -- line: 332
        -- upvalues:
        --  [1] t_5 (copy)

        if t_5.stopTraverseFunc then
            t_5.stopTraverseFunc()
            t_5.stopTraverseFunc = nil
        end

        if t_5.BlockedConn then
            t_5.BlockedConn:Disconnect()
            t_5.BlockedConn = nil
        end

        if t_5.DiedConn then
            t_5.DiedConn:Disconnect()
            t_5.DiedConn = nil
        end

        if t_5.SeatedConn then
            t_5.SeatedConn:Disconnect()
            t_5.SeatedConn = nil
        end

        if t_5.TeleportedConn then
            t_5.TeleportedConn:Disconnect()
            t_5.TeleportedConn = nil
        end

        t_5.Started = false
    end

    function t_5.Cancel(_) -- line: 361
        -- upvalues:
        --  [1] t_5 (copy)

        t_5.Cancelled = true
        t_5:Cleanup()
    end

    function t_5.IsActive(_) -- line: 366
        -- upvalues:
        --  [1] t_5 (copy)

        return t_5.AgentCanFollowPath and t_5.Started and not t_5.Cancelled
    end

    function t_5.OnPathInterrupted(_) -- line: 370
        -- upvalues:
        --  [1] t_5 (copy)

        t_5.Cancelled = true
        t_5:OnPointReached(false)
    end

    function t_5.ComputePath(_) -- line: 376
        -- upvalues:
        --  [1] t_5 (copy)

        if t_5.OriginPoint then
            if t_5.PathComputed or t_5.PathComputing then
                return
            end

            t_5.PathComputing = true

            if t_5.AgentCanFollowPath then
                if t_5.DirectPath then
                    local v50 = t_5
                    local waypoint = PathWaypoint.new(t_5.OriginPoint, Enum.PathWaypointAction.Walk)
                    local New = PathWaypoint.new
                    local TargetPoint = t_5.TargetPoint
                    local v51 = t_5.DirectPathRiseFirst and Enum.PathWaypointAction.Jump or Enum.PathWaypointAction.Walk
                    v50.pointList = { waypoint, New(TargetPoint, v51) }
                    t_5.PathComputed = true
                else
                    t_5.pathResult:ComputeAsync(t_5.OriginPoint, t_5.TargetPoint)
                    t_5.pointList = t_5.pathResult:GetWaypoints()
                    t_5.BlockedConn = t_5.pathResult.Blocked:Connect(function(
                        blockedWaypointIdx: number
                    ) -- line: 390
                        -- upvalues:
                        --  [1] t_5 (ref)

                        t_5:OnPathBlocked(blockedWaypointIdx)
                    end)
                    t_5.PathComputed = if t_5.pathResult.Status ~= Enum.PathStatus.Success then false else true
                end
            end

            t_5.PathComputing = false
        end
    end

    function t_5.IsValidPath(_) -- line: 398
        -- upvalues:
        --  [1] t_5 (copy)

        t_5:ComputePath()
        local v56 = t_5.PathComputed

        if v56 then
            v56 = t_5.AgentCanFollowPath
        end

        return v56
    end

    t_5.Recomputing = false

    function t_5.OnPathBlocked(_, arg18) -- line: 404
        -- upvalues:
        --  [1] t_5 (copy)
        --  [2] v1 (ref)
        --  [3] ClickToMoveDisplay_m (ref)

        if not (if not (arg18 >= t_5.CurrentPoint) then false else true) or t_5.Recomputing then
            return
        end

        t_5.Recomputing = true

        if t_5.stopTraverseFunc then
            t_5.stopTraverseFunc()
            t_5.stopTraverseFunc = nil
        end

        t_5.OriginPoint = t_5.Humanoid.RootPart.CFrame.p
        t_5.pathResult:ComputeAsync(t_5.OriginPoint, t_5.TargetPoint)
        t_5.pointList = t_5.pathResult:GetWaypoints()

        if #t_5.pointList > 0 then
            t_5.HumanoidOffsetFromPath = t_5.pointList[1].Position - t_5.OriginPoint
        end

        local v59 = t_5
        v59.PathComputed = t_5.pathResult.Status == Enum.PathStatus.Success

        if v1 then
            t_5.stopTraverseFunc, t_5.setPointFunc = ClickToMoveDisplay_m.CreatePathDisplay(
                t_5.pointList
            )
        end

        if t_5.PathComputed then
            t_5.CurrentPoint = 1
            t_5:OnPointReached(true)
        else
            t_5.PathFailed:Fire()
            t_5:Cleanup()
        end

        t_5.Recomputing = false
    end

    function t_5.OnRenderStepped(_: table, n1: number) -- line: 440
        -- upvalues:
        --  [1] t_5 (copy)
        --  [2] v5 (ref)

        if t_5.Started and not t_5.Cancelled then
            t_5.Timeout += n1

            if t_5.Timeout > v5 then
                t_5:OnPointReached(false)

                return
            end

            t_5.CurrentHumanoidPosition = t_5.Humanoid.RootPart.Position + t_5.HumanoidOffsetFromPath
            t_5.CurrentHumanoidVelocity = t_5.Humanoid.RootPart.Velocity

            while true do
                if not t_5.Started or not t_5:IsCurrentWaypointReached() then
                    break
                end

                t_5:OnPointReached(true)
            end

            if t_5.Started then
                t_5.NextActionMoveDirection = t_5.CurrentWaypointPosition - t_5.CurrentHumanoidPosition

                if t_5.NextActionMoveDirection.Magnitude > 1E-06 then
                    t_5.NextActionMoveDirection = t_5.NextActionMoveDirection.Unit
                else
                    t_5.NextActionMoveDirection = Vector3.new(0, 0, 0)
                end

                if t_5.CurrentWaypointNeedsJump then
                    t_5.NextActionJump = true
                    t_5.CurrentWaypointNeedsJump = false

                    return
                end

                t_5.NextActionJump = false
            end
        end
    end

    function t_5.IsCurrentWaypointReached(_) -- line: 478
        -- upvalues:
        --  [1] t_5 (copy)

        local v65 = if t_5.CurrentWaypointPlaneNormal ~= Vector3.new(0, 0, 0) then t_5.CurrentWaypointPlaneNormal:Dot(
            t_5.CurrentHumanoidPosition
        ) - t_5.CurrentWaypointPlaneDistance < math.max(
            1,
            0.0625 * -t_5.CurrentWaypointPlaneNormal:Dot(t_5.CurrentHumanoidVelocity)
        ) and true else true

        if v65 then
            t_5.CurrentWaypointPosition = nil
            t_5.CurrentWaypointPlaneNormal = Vector3.new(0, 0, 0)
            t_5.CurrentWaypointPlaneDistance = 0
        end

        return v65
    end

    function t_5.OnPointReached(_, arg21) -- line: 504
        -- upvalues:
        --  [1] t_5 (copy)

        if arg21 and not t_5.Cancelled then
            if t_5.setPointFunc then
                t_5.setPointFunc(t_5.CurrentPoint)
            end

            local v66 = t_5.CurrentPoint + 1

            if v66 > #t_5.pointList then
                if t_5.stopTraverseFunc then
                    t_5.stopTraverseFunc()
                end

                t_5.Finished:Fire()
                t_5:Cleanup()

                return
            end

            local v67 = t_5.pointList[t_5.CurrentPoint]
            local v68 = t_5.pointList[v66]
            local v69 = t_5.Humanoid:GetState()

            if if v69 ~= Enum.HumanoidStateType.FallingDown then if v69 == Enum.HumanoidStateType.Freefall then true else if v69 == Enum.HumanoidStateType.Jumping then true else false else true then
                v69 = if v68.Action ~= Enum.PathWaypointAction.Jump then false else true

                if not v69 and t_5.CurrentPoint > 1 then
                    local v71 = v67.Position - t_5.pointList[t_5.CurrentPoint - 1].Position
                    local v72 = v68.Position - v67.Position
                    v69 = Vector2.new(v71.x, v71.z).Unit:Dot(Vector2.new(v72.x, v72.z).Unit) < 0.996 and true
                end

                if v69 then
                    t_5.Humanoid.FreeFalling:Wait()
                    wait(0.1)
                end
            end

            t_5:MoveToNextWayPoint(v67, v68, v66)

            return
        end

        t_5.PathFailed:Fire()
        t_5:Cleanup()
    end

    function t_5.MoveToNextWayPoint(_: table, u3: userdata, u4: userdata, n2: number) -- line: 567
        -- upvalues:
        --  [1] t_5 (copy)
        --  [2] v36 (ref)

        t_5.CurrentWaypointPlaneNormal = u3.Position - u4.Position

        if not v36 or u4.Label ~= "Climb" then
            t_5.CurrentWaypointPlaneNormal = Vector3.new(
                t_5.CurrentWaypointPlaneNormal.X,
                0,
                t_5.CurrentWaypointPlaneNormal.Z
            )
        end

        if t_5.CurrentWaypointPlaneNormal.Magnitude > 1E-06 then
            t_5.CurrentWaypointPlaneNormal = t_5.CurrentWaypointPlaneNormal.Unit
            t_5.CurrentWaypointPlaneDistance = t_5.CurrentWaypointPlaneNormal:Dot(u4.Position)
        else
            t_5.CurrentWaypointPlaneNormal = Vector3.new(0, 0, 0)
            t_5.CurrentWaypointPlaneDistance = 0
        end

        local v75 = t_5
        v75.CurrentWaypointNeedsJump = u4.Action == Enum.PathWaypointAction.Jump
        t_5.CurrentWaypointPosition = u4.Position
        t_5.CurrentPoint = n2
        t_5.Timeout = 0
    end

    function t_5.Start(_, arg23) -- line: 599
        -- upvalues:
        --  [1] t_5 (copy)
        --  [2] ClickToMoveDisplay_m (ref)
        --  [3] v1 (ref)

        if not t_5.AgentCanFollowPath then
            t_5.PathFailed:Fire()

            return
        end

        if t_5.Started then
            return
        end

        t_5.Started = true
        ClickToMoveDisplay_m.CancelFailureAnimation()

        if v1 and (arg23 == nil or arg23) then
            t_5.stopTraverseFunc, t_5.setPointFunc = ClickToMoveDisplay_m.CreatePathDisplay(
                t_5.pointList,
                t_5.OriginalTargetPoint
            )
        end

        if #t_5.pointList > 0 then
            t_5.HumanoidOffsetFromPath = Vector3.new(
                0,
                t_5.pointList[1].Position.Y - t_5.OriginPoint.Y,
                0
            )
            t_5.CurrentHumanoidPosition = t_5.Humanoid.RootPart.Position + t_5.HumanoidOffsetFromPath
            t_5.CurrentHumanoidVelocity = t_5.Humanoid.RootPart.Velocity
            t_5.SeatedConn = t_5.Humanoid.Seated:Connect(function(_, _) -- line: 626
                -- upvalues:
                --  [1] t_5 (ref)

                t_5:OnPathInterrupted()
            end)
            t_5.DiedConn = t_5.Humanoid.Died:Connect(function() -- line: 627
                -- upvalues:
                --  [1] t_5 (ref)

                t_5:OnPathInterrupted()
            end)
            t_5.TeleportedConn = t_5.Humanoid.RootPart:GetPropertyChangedSignal("CFrame"):Connect(
                function() -- line: 628
                    -- upvalues:
                    --  [1] t_5 (ref)

                    t_5:OnPathInterrupted()
                end
            )
            t_5.CurrentPoint = 1
            t_5:OnPointReached(true)

            return
        end

        t_5.PathFailed:Fire()

        if t_5.stopTraverseFunc then
            t_5.stopTraverseFunc()
        end
    end

    v43 = t_5.TargetPoint + t_5.TargetSurfaceNormal * 1.5

    if UserRaycastUpdateAPI2 then
        local v84 = raycastParams

        if t_12 then
            v40 = t_12
        else
            t_12 = {}
            assert(t_12, "")
            local v85 = LocalPlayer
            local v86 = t_12

            if v85 then
                v85 = LocalPlayer.Character
            end

            table.insert(v86, v85)
            v40 = t_12
        end

        v84.FilterDescendantsInstances = v40
        v38 = Workspace:Raycast(v43, Vector3.new(-0, -50, -0), raycastParams)

        if v38 then
            t_5.TargetPoint = v38.Position
        end
    else
        local ray = Ray.new(v43, Vector3.new(0, -50, 0))
        local v87 = Workspace
        local v88

        if t_12 then
            v88 = t_12
        else
            t_12 = {}
            assert(t_12, "")
            local v89 = LocalPlayer
            local v90 = t_12

            if v89 then
                v89 = LocalPlayer.Character
            end

            table.insert(v90, v89)
            v88 = t_12
        end

        local v91, v92 = v87:FindPartOnRayWithIgnoreList(ray, v88)

        if v91 then
            t_5.TargetPoint = v92
        end
    end

    t_5:ComputePath()

    return t_5
end

local _ = function() --[[ CheckAlive ]] -- line: 664
    -- upvalues:
    --  [1] LocalPlayer (copy)
    --  [2] t_2 (copy)

    local v93 = LocalPlayer
    local v94 = v93

    if v94 then
        v94 = v93.Character
    end

    local v96

    if v94 then
        local v95 = t_2[v93]

        if v95 and v95.Parent == v94 then
            v96 = v95
        else
            t_2[v93] = nil
            local Humanoid_4 = v94:FindFirstChildOfClass("Humanoid")

            if Humanoid_4 then
                t_2[v93] = Humanoid_4
            end

            v96 = Humanoid_4
        end
    else
        v96 = nil
    end

    v93 = if v96 == nil then false else v96.Health > 0

    return v93
end

local function GetEquippedTool(u5: userdata?) -- line: 669
    if u5 ~= nil then
        for _, val_2 in pairs(u5:GetChildren()) do
            if val_2:IsA("Tool") then
                return val_2
            end
        end
    end
end

local v98 = nil
local v99 = nil
local v100 = nil

local _ = function() --[[ CleanupPath ]] -- line: 684
    -- upvalues:
    --  [1] v98 (ref)
    --  [2] v99 (ref)
    --  [3] v100 (ref)

    if v98 then
        v98:Cancel()
        v98 = nil
    end

    if v99 then
        v99:Disconnect()
        v99 = nil
    end

    if v100 then
        v100:Disconnect()
        v100 = nil
    end
end

local function HandleMoveTo(
    arg26,
    arg27,
    arg28,
    arg29,
    arg30
) -- line: 702
    -- upvalues:
    --  [1] v98 (ref)
    --  [2] v99 (ref)
    --  [3] v100 (ref)
    --  [4] GetEquippedTool (copy)
    --  [5] v2 (ref)
    --  [6] ClickToMoveDisplay_m (copy)

    if v98 then
        if v98 then
            v98:Cancel()
            v98 = nil
        end

        if v99 then
            v99:Disconnect()
            v99 = nil
        end

        if v100 then
            v100:Disconnect()
            v100 = nil
        end
    end

    v98 = arg26
    arg26:Start(arg30)
    v99 = arg26.Finished.Event:Connect(function() -- line: 709
        -- upvalues:
        --  [1] v98 (ref)
        --  [2] v99 (ref)
        --  [3] v100 (ref)
        --  [4] arg28 (copy)
        --  [5] GetEquippedTool (ref)
        --  [6] arg29 (copy)

        if v98 then
            v98:Cancel()
            v98 = nil
        end

        if v99 then
            v99:Disconnect()
            v99 = nil
        end

        if v100 then
            v100:Disconnect()
            v100 = nil
        end

        if arg28 then
            local v101 = GetEquippedTool(arg29)

            if v101 then
                v101:Activate()
            end
        end
    end)
    v100 = arg26.PathFailed.Event:Connect(function() -- line: 718
        -- upvalues:
        --  [1] v98 (ref)
        --  [2] v99 (ref)
        --  [3] v100 (ref)
        --  [4] arg30 (copy)
        --  [5] v2 (ref)
        --  [6] ClickToMoveDisplay_m (ref)
        --  [7] arg27 (copy)

        if v98 then
            v98:Cancel()
            v98 = nil
        end

        if v99 then
            v99:Disconnect()
            v99 = nil
        end

        if v100 then
            v100:Disconnect()
            v100 = nil
        end

        if arg30 == nil or arg30 then
            local v102 = v2

            if v102 then
                local v103 = v98

                if v103 then
                    v103 = v98:IsActive()
                end

                v102 = not v103
            end

            if v102 then
                ClickToMoveDisplay_m.PlayFailureAnimation()
            end

            ClickToMoveDisplay_m.DisplayFailureWaypoint(arg27)
        end
    end)
end

local _ = function(arg31) --[[ ShowPathFailedFeedback ]] -- line: 730
    -- upvalues:
    --  [1] v98 (ref)
    --  [2] v2 (ref)
    --  [3] ClickToMoveDisplay_m (copy)

    if v98 and v98:IsActive() then
        v98:Cancel()
    end

    if v2 then
        ClickToMoveDisplay_m.PlayFailureAnimation()
    end

    ClickToMoveDisplay_m.DisplayFailureWaypoint(arg31)
end

function OnTap(t4: table, vec4: Vector3?, b3: boolean?) -- line: 740
    -- upvalues:
    --  [1] Workspace (copy)
    --  [2] LocalPlayer (copy)
    --  [3] t_2 (copy)
    --  [4] UserRaycastUpdateAPI2 (copy)
    --  [5] t_12 (ref)
    --  [6] raycastParams (copy)
    --  [7] StarterGui (copy)
    --  [8] Players (copy)
    --  [9] v98 (ref)
    --  [10] v99 (ref)
    --  [11] v100 (ref)
    --  [12] Pather (copy)
    --  [13] HandleMoveTo (copy)
    --  [14] v2 (ref)
    --  [15] ClickToMoveDisplay_m (copy)
    --  [16] t_1 (copy)
    --  [17] GetEquippedTool (copy)

    local CurrentCamera = Workspace.CurrentCamera
    local Character = LocalPlayer.Character
    local v104 = LocalPlayer
    local v105 = v104

    if v105 then
        v105 = v104.Character
    end

    local v106, v107

    if v105 then
        v106 = t_2[v104]

        if v106 and v106.Parent == v105 then
            v107 = v106
        else
            t_2[v104] = nil
            local Humanoid_5 = v105:FindFirstChildOfClass("Humanoid")

            if Humanoid_5 then
                t_2[v104] = Humanoid_5
            end

            v107 = Humanoid_5
        end
    else
        v107 = nil
    end

    if not (if v107 == nil then false else v107.Health > 0) then
        return
    end

    if #t4 == 1 or vec4 then
        if CurrentCamera then
            local ray_1 = CurrentCamera:ScreenPointToRay(t4[1].X, t4[1].Y)
            local v116

            if UserRaycastUpdateAPI2 then
                local v109 = nil
                local v110 = nil

                if t_12 then
                    v106 = t_12
                else
                    t_12 = {}
                    assert(t_12, "")
                    local v111 = t_12
                    local v112 = LocalPlayer

                    if v112 then
                        v112 = LocalPlayer.Character
                    end

                    table.insert(v111, v112)
                    v106 = t_12
                end

                if not v106 then
                    v106 = {}
                end

                local raycastResult

                repeat
                    local v113 = true
                    raycastParams.FilterDescendantsInstances = v106
                    raycastResult = Workspace:Raycast(
                        ray_1.Origin,
                        ray_1.Direction * 1000,
                        raycastParams
                    )

                    if raycastResult then
                        local v115 = raycastResult.Instance

                        if not v115.CanCollide then
                            repeat
                                v109 = v115:FindFirstChildOfClass("Humanoid")
                                v110 = v115
                                v115 = v115.Parent
                            until v109 or not v115

                            if not v109 and v115 then
                                v110 = nil
                                v113 = false
                                table.insert(v106, v115)
                            end
                        end
                    end
                until v113

                if
                    b3
                    and v109
                    and StarterGui:GetCore("AvatarContextMenuEnabled")
                    and Players:GetPlayerFromCharacter(v109.Parent)
                then
                    if v98 then
                        v98:Cancel()
                        v98 = nil
                    end

                    if v99 then
                        v99:Disconnect()
                        v99 = nil
                    end

                    if v100 then
                        v100:Disconnect()
                        v100 = nil
                    end

                    return
                end

                if not raycastResult or not Character then
                    return
                end

                v109 = raycastResult.Position

                if vec4 then
                    v109 = vec4
                    v110 = nil
                end

                if v98 then
                    v98:Cancel()
                    v98 = nil
                end

                if v99 then
                    v99:Disconnect()
                    v99 = nil
                end

                if v100 then
                    v100:Disconnect()
                    v100 = nil
                end

                v116 = Pather(v109, raycastResult.Normal)

                if v116:IsValidPath() then
                    HandleMoveTo(v116, v109, v110, Character)

                    return
                end

                v116:Cleanup()

                if v98 and v98:IsActive() then
                    v98:Cancel()
                end

                if v2 then
                    ClickToMoveDisplay_m.PlayFailureAnimation()
                end

                ClickToMoveDisplay_m.DisplayFailureWaypoint(v109)

                return
            else
                local v117 = Ray.new(ray_1.Origin, ray_1.Direction * 1000)
                local Raycast_1 = t_1.Raycast

                if t_12 then
                    v116 = t_12
                else
                    t_12 = {}
                    assert(t_12, "")
                    local v118 = LocalPlayer
                    local v119 = t_12

                    if v118 then
                        v118 = LocalPlayer.Character
                    end

                    table.insert(v119, v118)
                    v116 = t_12
                end

                local v120, v121
                v120, v117, v121 = Raycast_1(v117, true, v116)
                local v122 = v120
                v116, v122 = t_1.FindCharacterAncestor(v122)

                if
                    b3
                    and v122
                    and StarterGui:GetCore("AvatarContextMenuEnabled")
                    and Players:GetPlayerFromCharacter(v122.Parent)
                then
                    if v98 then
                        v98:Cancel()
                        v98 = nil
                    end

                    if v99 then
                        v99:Disconnect()
                        v99 = nil
                    end

                    if v100 then
                        v100:Disconnect()
                        v100 = nil
                    end

                    return
                end

                if vec4 then
                    v117 = vec4
                    v116 = nil
                end

                if v117 and Character then
                    if v98 then
                        v98:Cancel()
                        v98 = nil
                    end

                    if v99 then
                        v99:Disconnect()
                        v99 = nil
                    end

                    if v100 then
                        v100:Disconnect()
                        v100 = nil
                    end

                    local v124 = Pather(v117, v121)

                    if v124:IsValidPath() then
                        HandleMoveTo(v124, v117, v116, Character)

                        return
                    end

                    v124:Cleanup()

                    if v98 and v98:IsActive() then
                        v98:Cancel()
                    end

                    if v2 then
                        ClickToMoveDisplay_m.PlayFailureAnimation()
                    end

                    ClickToMoveDisplay_m.DisplayFailureWaypoint(v117)

                    return
                end
            end
        end
    elseif #t4 >= 2 and CurrentCamera then
        local v125 = GetEquippedTool(Character)

        if v125 then
            v125:Activate()
        end
    end
end

local _ = function(arg32) --[[ DisconnectEvent ]] -- line: 850
    if arg32 then
        arg32:Disconnect()
    end
end

local Keyboard_m = require(script.Parent:WaitForChild("Keyboard"))
local t_9 = setmetatable({}, Keyboard_m)
t_9.__index = t_9

function t_9.new(arg33) -- line: 861
    -- upvalues:
    --  [1] Keyboard_m (copy)
    --  [2] t_9 (copy)

    local t_10 = setmetatable(Keyboard_m.new(arg33), t_9)
    t_10.fingerTouches = {}
    t_10.numUnsunkTouches = 0
    t_10.mouse2DownTime = tick()
    t_10.mouse2DownPos = Vector2.new()
    t_10.mouse2UpTime = tick()
    t_10.keyboardMoveVector = Vector3.new(0, 0, 0)
    t_10.tapConn = nil
    t_10.inputBeganConn = nil
    t_10.inputChangedConn = nil
    t_10.inputEndedConn = nil
    t_10.humanoidDiedConn = nil
    t_10.characterChildAddedConn = nil
    t_10.onCharacterAddedConn = nil
    t_10.characterChildRemovedConn = nil
    t_10.renderSteppedConn = nil
    t_10.menuOpenedConnection = nil
    t_10.preferredInputChangedConnection = nil
    t_10.running = false
    t_10.wasdEnabled = false

    return t_10
end

function t_9.DisconnectEvents(arg34) -- line: 892
    local TapConn = arg34.tapConn

    if TapConn then
        TapConn:Disconnect()
    end

    local InputBeganConn = arg34.inputBeganConn

    if InputBeganConn then
        InputBeganConn:Disconnect()
    end

    local InputChangedConn = arg34.inputChangedConn

    if InputChangedConn then
        InputChangedConn:Disconnect()
    end

    local InputEndedConn = arg34.inputEndedConn

    if InputEndedConn then
        InputEndedConn:Disconnect()
    end

    local HumanoidDiedConn = arg34.humanoidDiedConn

    if HumanoidDiedConn then
        HumanoidDiedConn:Disconnect()
    end

    local CharacterChildAddedConn = arg34.characterChildAddedConn

    if CharacterChildAddedConn then
        CharacterChildAddedConn:Disconnect()
    end

    local OnCharacterAddedConn = arg34.onCharacterAddedConn

    if OnCharacterAddedConn then
        OnCharacterAddedConn:Disconnect()
    end

    local RenderSteppedConn = arg34.renderSteppedConn

    if RenderSteppedConn then
        RenderSteppedConn:Disconnect()
    end

    local CharacterChildRemovedConn = arg34.characterChildRemovedConn

    if CharacterChildRemovedConn then
        CharacterChildRemovedConn:Disconnect()
    end

    local MenuOpenedConnection = arg34.menuOpenedConnection

    if MenuOpenedConnection then
        MenuOpenedConnection:Disconnect()
    end

    local PreferredInputChangedConnection = arg34.preferredInputChangedConnection

    if PreferredInputChangedConnection then
        PreferredInputChangedConnection:Disconnect()
    end
end

function t_9.OnTouchBegan(arg35, arg36, arg37) -- line: 906
    if arg35.fingerTouches[arg36] == nil and not arg37 then
        arg35.numUnsunkTouches += 1
    end

    arg35.fingerTouches[arg36] = arg37
end

function t_9.OnTouchChanged(arg38, arg39, arg40) -- line: 913
    if arg38.fingerTouches[arg39] == nil then
        arg38.fingerTouches[arg39] = arg40

        if not arg40 then
            arg38.numUnsunkTouches += 1
        end
    end
end

function t_9.OnTouchEnded(arg41, arg42, _) -- line: 922
    if arg41.fingerTouches[arg42] ~= nil and arg41.fingerTouches[arg42] == false then
        arg41.numUnsunkTouches -= 1
    end

    arg41.fingerTouches[arg42] = nil
end

function t_9.OnPreferredInputChanged(_) -- line: 929
    -- upvalues:
    --  [1] LocalPlayer (copy)
    --  [2] UserInputService (copy)

    local Character_1 = LocalPlayer.Character

    if Character_1 then
        local v128 = UserInputService.PreferredInput == Enum.PreferredInput.Touch

        for _, val_3 in pairs(Character_1:GetChildren()) do
            if val_3:IsA("Tool") then
                val_3.ManualActivationOnly = v128
            end
        end
    end
end

function t_9.OnCharacterAdded(arg45, arg46) -- line: 941
    -- upvalues:
    --  [1] UserInputService (copy)
    --  [2] t (copy)
    --  [3] v98 (ref)
    --  [4] v99 (ref)
    --  [5] v100 (ref)
    --  [6] ClickToMoveDisplay_m (copy)
    --  [7] GuiService (copy)

    arg45:DisconnectEvents()
    arg45.inputBeganConn = UserInputService.InputBegan:Connect(function(
        input: InputObject,
        gameProcessedEvent: boolean
    ) -- line: 944
        -- upvalues:
        --  [1] arg45 (copy)
        --  [2] t (ref)
        --  [3] v98 (ref)
        --  [4] v99 (ref)
        --  [5] v100 (ref)
        --  [6] ClickToMoveDisplay_m (ref)

        if input.UserInputType == Enum.UserInputType.Touch then
            arg45:OnTouchBegan(input, gameProcessedEvent)
        end

        if
            arg45.wasdEnabled
            and gameProcessedEvent == false
            and input.UserInputType == Enum.UserInputType.Keyboard
            and t[input.KeyCode]
        then
            if v98 then
                v98:Cancel()
                v98 = nil
            end

            if v99 then
                v99:Disconnect()
                v99 = nil
            end

            if v100 then
                v100:Disconnect()
                v100 = nil
            end

            ClickToMoveDisplay_m.CancelFailureAnimation()
        end

        if input.UserInputType == Enum.UserInputType.MouseButton2 then
            arg45.mouse2DownTime = tick()
            arg45.mouse2DownPos = input.Position
        end
    end)
    arg45.inputChangedConn = UserInputService.InputChanged:Connect(function(
        input_1: InputObject,
        gameProcessedEvent_1: boolean
    ) -- line: 961
        -- upvalues:
        --  [1] arg45 (copy)

        if input_1.UserInputType == Enum.UserInputType.Touch then
            arg45:OnTouchChanged(input_1, gameProcessedEvent_1)
        end
    end)
    arg45.inputEndedConn = UserInputService.InputEnded:Connect(function(
        input_2: InputObject,
        gameProcessedEvent_2: boolean
    ) -- line: 967
        -- upvalues:
        --  [1] arg45 (copy)
        --  [2] v98 (ref)

        if input_2.UserInputType == Enum.UserInputType.Touch then
            arg45:OnTouchEnded(input_2, gameProcessedEvent_2)
        end

        if input_2.UserInputType == Enum.UserInputType.MouseButton2 then
            arg45.mouse2UpTime = tick()
            local Position = input_2.Position
            local v132 = v98 or arg45.keyboardMoveVector.Magnitude <= 0

            if
                arg45.mouse2UpTime - arg45.mouse2DownTime < 0.25
                and (Position - arg45.mouse2DownPos).magnitude < 5
                and v132
            then
                OnTap({ Position })
            end
        end
    end)
    arg45.tapConn = UserInputService.TouchTap:Connect(function(
        touchPositions,
        gameProcessedEvent_3: boolean
    ) -- line: 984
        if not gameProcessedEvent_3 then
            OnTap(touchPositions, nil, true)
        end
    end)
    arg45.menuOpenedConnection = GuiService.MenuOpened:Connect(function() -- line: 990
        -- upvalues:
        --  [1] v98 (ref)
        --  [2] v99 (ref)
        --  [3] v100 (ref)

        if v98 then
            v98:Cancel()
            v98 = nil
        end

        if v99 then
            v99:Disconnect()
            v99 = nil
        end

        if v100 then
            v100:Disconnect()
            v100 = nil
        end
    end)

    local function OnCharacterChildAdded(arg55) -- line: 994
        -- upvalues:
        --  [1] UserInputService (ref)
        --  [2] arg45 (copy)

        if UserInputService.PreferredInput == Enum.PreferredInput.Touch and arg55:IsA("Tool") then
            arg55.ManualActivationOnly = true
        end

        if arg55:IsA("Humanoid") then
            local HumanoidDiedConn_1 = arg45.humanoidDiedConn

            if HumanoidDiedConn_1 then
                HumanoidDiedConn_1:Disconnect()
            end

            arg45.humanoidDiedConn = arg55.Died:Connect(function() -- line: 1002
            end)
        end
    end

    arg45.characterChildAddedConn = arg46.ChildAdded:Connect(function(child_1: Instance) -- line: 1010
        -- upvalues:
        --  [1] OnCharacterChildAdded (copy)

        OnCharacterChildAdded(child_1)
    end)
    arg45.characterChildRemovedConn = arg46.ChildRemoved:Connect(function(child_2: Instance) -- line: 1013
        -- upvalues:
        --  [1] UserInputService (ref)

        if UserInputService.PreferredInput == Enum.PreferredInput.Touch and child_2:IsA("Tool") then
            child_2.ManualActivationOnly = false
        end
    end)

    for _, child in pairs(arg46:GetChildren()) do
        OnCharacterChildAdded(child)
    end

    local PreferredInput = UserInputService:GetPropertyChangedSignal("PreferredInput")
    arg45.preferredInputChangedConnection = PreferredInput:Connect(function() -- line: 1024
        -- upvalues:
        --  [1] arg45 (copy)

        arg45:OnPreferredInputChanged()
    end)
end

function t_9.Start(arg58) -- line: 1029
    arg58:Enable(true)
end

function t_9.Stop(arg59) -- line: 1033
    arg59:Enable(false)
end

function t_9.CleanupPath(_) -- line: 1037
    -- upvalues:
    --  [1] v98 (ref)
    --  [2] v99 (ref)
    --  [3] v100 (ref)

    if v98 then
        v98:Cancel()
        v98 = nil
    end

    if v99 then
        v99:Disconnect()
        v99 = nil
    end

    if v100 then
        v100:Disconnect()
        v100 = nil
    end
end

function t_9.Enable(t5: table, b4: boolean, b5: boolean, arg61: any) -- line: 1041
    -- upvalues:
    --  [1] LocalPlayer (copy)
    --  [2] v98 (ref)
    --  [3] v99 (ref)
    --  [4] v100 (ref)
    --  [5] UserInputService (copy)
    --  [6] Keyboard_m (copy)

    if b4 then
        if not t5.running then
            if LocalPlayer.Character then
                t5:OnCharacterAdded(LocalPlayer.Character)
            end

            t5.onCharacterAddedConn = LocalPlayer.CharacterAdded:Connect(function(character: Model) -- line: 1047
                -- upvalues:
                --  [1] t5 (copy)

                t5:OnCharacterAdded(character)
            end)
            t5.running = true
        end

        t5.touchJumpController = arg61

        if t5.touchJumpController then
            t5.touchJumpController:Enable(t5.jumpEnabled)
        end
    else
        if t5.running then
            t5:DisconnectEvents()

            if v98 then
                v98:Cancel()
                v98 = nil
            end

            if v99 then
                v99:Disconnect()
                v99 = nil
            end

            if v100 then
                v100:Disconnect()
                v100 = nil
            end

            if UserInputService.PreferredInput == Enum.PreferredInput.Touch then
                local Character_2 = LocalPlayer.Character

                if Character_2 then
                    for _, val_4 in pairs(Character_2:GetChildren()) do
                        if val_4:IsA("Tool") then
                            val_4.ManualActivationOnly = false
                        end
                    end
                end
            end

            t5.running = false
        end

        if t5.touchJumpController and not t5.jumpEnabled then
            t5.touchJumpController:Enable(true)
        end

        t5.touchJumpController = nil
    end

    Keyboard_m.Enable(t5, b4)
    t5.wasdEnabled = b4 and b5 or false
    t5.enabled = b4
end

function t_9.OnRenderStepped(arg63, arg64) -- line: 1086
    -- upvalues:
    --  [1] v98 (ref)

    arg63.isJumping = false

    if v98 then
        v98:OnRenderStepped(arg64)

        if v98 then
            arg63.moveVector = v98.NextActionMoveDirection
            arg63.moveVectorIsCameraRelative = false

            if v98.NextActionJump then
                arg63.isJumping = true
            end
        else
            arg63.moveVector = arg63.keyboardMoveVector
            arg63.moveVectorIsCameraRelative = true
        end
    else
        arg63.moveVector = arg63.keyboardMoveVector
        arg63.moveVectorIsCameraRelative = true
    end

    if arg63.jumpRequested then
        arg63.isJumping = true
    end
end

function t_9.UpdateMovement(arg65, arg66) -- line: 1121
    if arg66 == Enum.UserInputState.Cancel then
        arg65.keyboardMoveVector = Vector3.new(0, 0, 0)

        return
    end

    if arg65.wasdEnabled then
        arg65.keyboardMoveVector = Vector3.new(
            arg65.leftValue + arg65.rightValue,
            0,
            arg65.forwardValue + arg65.backwardValue
        )
    end
end

function t_9.UpdateJump(_) -- line: 1130
end

function t_9.SetShowPath(_, arg69) -- line: 1135
    -- upvalues:
    --  [1] v1 (ref)

    v1 = arg69
end

function t_9.GetShowPath(_) -- line: 1139
    -- upvalues:
    --  [1] v1 (ref)

    return v1
end

function t_9.SetWaypointTexture(_, arg72) -- line: 1143
    -- upvalues:
    --  [1] ClickToMoveDisplay_m (copy)

    ClickToMoveDisplay_m.SetWaypointTexture(arg72)
end

function t_9.GetWaypointTexture(_) -- line: 1147
    -- upvalues:
    --  [1] ClickToMoveDisplay_m (copy)

    return ClickToMoveDisplay_m.GetWaypointTexture()
end

function t_9.SetWaypointRadius(_, arg75) -- line: 1151
    -- upvalues:
    --  [1] ClickToMoveDisplay_m (copy)

    ClickToMoveDisplay_m.SetWaypointRadius(arg75)
end

function t_9.GetWaypointRadius(_) -- line: 1155
    -- upvalues:
    --  [1] ClickToMoveDisplay_m (copy)

    return ClickToMoveDisplay_m.GetWaypointRadius()
end

function t_9.SetEndWaypointTexture(_, arg78) -- line: 1159
    -- upvalues:
    --  [1] ClickToMoveDisplay_m (copy)

    ClickToMoveDisplay_m.SetEndWaypointTexture(arg78)
end

function t_9.GetEndWaypointTexture(_) -- line: 1163
    -- upvalues:
    --  [1] ClickToMoveDisplay_m (copy)

    return ClickToMoveDisplay_m.GetEndWaypointTexture()
end

function t_9.SetWaypointsAlwaysOnTop(_, arg81) -- line: 1167
    -- upvalues:
    --  [1] ClickToMoveDisplay_m (copy)

    ClickToMoveDisplay_m.SetWaypointsAlwaysOnTop(arg81)
end

function t_9.GetWaypointsAlwaysOnTop(_) -- line: 1171
    -- upvalues:
    --  [1] ClickToMoveDisplay_m (copy)

    return ClickToMoveDisplay_m.GetWaypointsAlwaysOnTop()
end

function t_9.SetFailureAnimationEnabled(_, arg84) -- line: 1175
    -- upvalues:
    --  [1] v2 (ref)

    v2 = arg84
end

function t_9.GetFailureAnimationEnabled(_) -- line: 1179
    -- upvalues:
    --  [1] v2 (ref)

    return v2
end

function t_9.SetIgnoredPartsTag(_, arg87) -- line: 1183
    -- upvalues:
    --  [1] UpdateIgnoreTag (copy)

    UpdateIgnoreTag(arg87)
end

function t_9.GetIgnoredPartsTag(_) -- line: 1187
    -- upvalues:
    --  [1] v17 (ref)

    return v17
end

function t_9.SetUseDirectPath(_, arg90) -- line: 1191
    -- upvalues:
    --  [1] v3 (ref)

    v3 = arg90
end

function t_9.GetUseDirectPath(_) -- line: 1195
    -- upvalues:
    --  [1] v3 (ref)

    return v3
end

function t_9.SetAgentSizeIncreaseFactor(_: table, n3: number) -- line: 1199
    -- upvalues:
    --  [1] v4 (ref)

    v4 = n3 / 100 + 1
end

function t_9.GetAgentSizeIncreaseFactor(_) -- line: 1203
    -- upvalues:
    --  [1] v4 (ref)

    return (v4 - 1) * 100
end

function t_9.SetUnreachableWaypointTimeout(_, arg94) -- line: 1207
    -- upvalues:
    --  [1] v5 (ref)

    v5 = arg94
end

function t_9.GetUnreachableWaypointTimeout(_) -- line: 1211
    -- upvalues:
    --  [1] v5 (ref)

    return v5
end

function t_9.SetUserJumpEnabled(arg96, arg97) -- line: 1215
    arg96.jumpEnabled = arg97

    if arg96.touchJumpController then
        arg96.touchJumpController:Enable(arg97)
    end
end

function t_9.GetUserJumpEnabled(arg98) -- line: 1222
    return arg98.jumpEnabled
end

function t_9.MoveTo(_, arg100, arg101, arg102) -- line: 1226
    -- upvalues:
    --  [1] LocalPlayer (copy)
    --  [2] Pather (copy)
    --  [3] HandleMoveTo (copy)

    local Character_3 = LocalPlayer.Character

    if Character_3 == nil then
        return false
    end

    local v137 = Pather(arg100, Vector3.new(0, 1, 0), arg102)

    if v137 and v137:IsValidPath() then
        HandleMoveTo(
            v137,
            arg100,
            nil,
            Character_3,
            arg101
        )

        return true
    end

    return false
end

return t_9
