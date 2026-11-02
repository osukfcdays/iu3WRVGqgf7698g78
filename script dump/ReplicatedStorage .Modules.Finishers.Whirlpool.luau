local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Ragdoll_m = require(ReplicatedStorage.Modules.Finishers.Ragdoll)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local Spring_m = require(ReplicatedStorage.Modules.Spring)
local t = setmetatable({}, Ragdoll_m)
t.__index = t

function t.new(...) -- line: 11
    -- upvalues:
    --  [1] Ragdoll_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(Ragdoll_m.new(...), t)
    t_1:_Init()

    return t_1
end

function t.PlayServer(arg1, ...) -- line: 23
    -- upvalues:
    --  [1] Ragdoll_m (copy)
    --  [2] RunService (copy)

    Ragdoll_m.PlayServer(arg1, ...)
    arg1:_AnchorModel(0, false)
    local v2 = arg1._is_humanoid and arg1._subject.RootPart or arg1._subject
    local Position = v2.Position
    local BodyPosition = Instance.new("BodyPosition")
    BodyPosition.MaxForce = Vector3.new(0, 100000, 0)
    BodyPosition.Position = Position
    BodyPosition.Parent = v2
    table.insert(arg1._destroy_these, BodyPosition)
    local Attachment = Instance.new("Attachment")
    Attachment.Parent = v2
    table.insert(arg1._destroy_these, Attachment)
    local VectorForce = Instance.new("VectorForce")
    VectorForce.RelativeTo = Enum.ActuatorRelativeTo.World
    VectorForce.Attachment0 = Attachment
    VectorForce.Parent = v2
    table.insert(arg1._destroy_these, VectorForce)
    table.insert(arg1._connections, RunService.Heartbeat:Connect(function() -- line: 46
        -- upvalues:
        --  [1] v2 (copy)
        --  [2] Position (copy)
        --  [3] VectorForce (copy)

        local cframe = CFrame.new(
            v2.Position * Vector3.new(1, 0, 1),
            Position * Vector3.new(1, 0, 1)
        )
        local v3 = if cframe == cframe then cframe else CFrame.new(
            Vector3.new(0, 0, 0),
            (Random.new():NextUnitVector() * Vector3.new(1, 0, 1)).Unit
        )
        local v4 = (v3.RightVector * 0.15 + v3.LookVector) * 5000
        VectorForce.Force = v4.Unit * math.min(v4.Magnitude, 5000)
    end))
end

function t.PlayClient(arg2, ...) -- line: 55
    -- upvalues:
    --  [1] Ragdoll_m (copy)
    --  [2] Spring_m (copy)
    --  [3] RunService (copy)
    --  [4] Utility_m (copy)

    Ragdoll_m.PlayClient(arg2, ...)
    local v6 = arg2._is_humanoid and arg2._subject.RootPart or arg2._subject
    local Position_1 = v6.Position
    local v7 = script.Model:Clone()
    v7.Parent = arg2._subject
    table.insert(arg2._destroy_these, v7)
    local v8 = arg2:_GetObjects(true)
    local v9 = Spring_m.new(v6.Position, 1, 2)
    table.insert(arg2._connections, RunService.RenderStepped:Connect(function() -- line: 68
        -- upvalues:
        --  [1] v9 (copy)
        --  [2] arg2 (copy)
        --  [3] Position_1 (copy)
        --  [4] v8 (copy)
        --  [5] v7 (copy)

        v9.Target = arg2:_GetGroundPosition(Position_1, v8)
        v7:PivotTo(CFrame.new(v9.Value.X, v9.Target.Y, v9.Value.Z))
    end))
    local v12 = 1 + 0.1 * math.random()
    arg2:CreateSound(
        "rbxassetid://115011821762260",
        1.25,
        v12,
        nil,
        true,
        5
    )
    local v13 = 1 + 0.1 * math.random()
    arg2:CreateSound(
        "rbxassetid://138046245903208",
        0.375,
        v13,
        nil,
        true,
        5
    )
    wait(2)
    Utility_m:RenderstepForLoop(0, 100, 0.5, function(arg3) -- line: 78
        -- upvalues:
        --  [1] arg2 (copy)

        local v14 = 1 - (1 - arg3 / 100) ^ 3

        for _, val in pairs(arg2:_GetObjects(true)) do
            if val:IsA("BasePart") then
                val.LocalTransparencyModifier = v14
            end
        end
    end)
end

function t._Init(_) -- line: 93
end

return t
