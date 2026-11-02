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

    Ragdoll_m.PlayServer(arg1, ...)
    local v2 = arg1._is_humanoid and arg1._subject.RootPart or arg1._subject
    v2.CFrame = CFrame.new(arg1:_GetGroundPosition(v2.Position, arg1:_GetObjects(true))) * v2.CFrame.Rotation + Vector3.new(0, 2, 0)
end

function t.PlayClient(arg2, ...) -- line: 31
    -- upvalues:
    --  [1] Ragdoll_m (copy)
    --  [2] Utility_m (copy)
    --  [3] Spring_m (copy)
    --  [4] RunService (copy)

    Ragdoll_m.PlayClient(arg2, ...)
    local v4 = arg2._is_humanoid and arg2._subject.RootPart or arg2._subject
    local cframe = CFrame.Angles(0, math.random() * 3.141592653589793 * 2, 0)
    local v6 = script.Model:Clone()
    v6.Parent = arg2._subject
    table.insert(arg2._destroy_these, v6)
    local v7 = script.Particles:Clone()
    v7.CFrame = CFrame.new(v4.Position)
    v7.Parent = v4
    table.insert(arg2._destroy_these, v7)
    Utility_m:PlayParticles(v7)
    local WeldConstraint = Instance.new("WeldConstraint")
    WeldConstraint.Part0 = v7
    WeldConstraint.Part1 = v4
    WeldConstraint.Parent = v7
    local v8 = arg2:_GetObjects(true)
    local v9 = Spring_m.new(v4.Position, 1, 2)
    table.insert(arg2._connections, RunService.RenderStepped:Connect(function() -- line: 55
        -- upvalues:
        --  [1] v9 (copy)
        --  [2] arg2 (copy)
        --  [3] v4 (copy)
        --  [4] v8 (copy)
        --  [5] v6 (copy)
        --  [6] cframe (copy)

        v9.Target = arg2:_GetGroundPosition(v4.Position, v8)
        v6:PivotTo(CFrame.new(v9.Value.X, v9.Target.Y, v9.Value.Z) * cframe)
    end))
    local v13 = 1.1 + 0.1 * math.random()
    arg2:CreateSound(
        "rbxassetid://17812496122",
        1,
        v13,
        nil,
        true,
        5
    )
end

function t._Init(_) -- line: 67
end

return t
