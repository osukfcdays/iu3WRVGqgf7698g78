local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Ragdoll_m = require(ReplicatedStorage.Modules.Finishers.Ragdoll)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local t = setmetatable({}, Ragdoll_m)
t.__index = t

function t.new(...) -- line: 9
    -- upvalues:
    --  [1] Ragdoll_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(Ragdoll_m.new(...), t)
    t_1:_Init()

    return t_1
end

function t.PlayClient(arg1, ...) -- line: 21
    -- upvalues:
    --  [1] Ragdoll_m (copy)
    --  [2] Utility_m (copy)

    Ragdoll_m.PlayClient(arg1, ...)
    local v2 = arg1._is_humanoid and arg1._subject.RootPart or arg1._subject
    local v3 = script.Particles:Clone()
    v3.CFrame = v2.CFrame
    v3.Parent = arg1._subject
    table.insert(arg1._destroy_these, v3)
    local WeldConstraint = Instance.new("WeldConstraint")
    WeldConstraint.Part0 = v2
    WeldConstraint.Part1 = v3
    WeldConstraint.Parent = v3
    Utility_m:PlayParticles(v3)
    arg1:CreateSound(
        "rbxassetid://119051363107007",
        1.25,
        1 + 0.2 * math.random(),
        nil,
        true,
        5
    )
    arg1:CreateSound(
        "rbxassetid://70929054322985",
        1.25,
        1 + 0.2 * math.random(),
        nil,
        true,
        5
    )
end

function t._Init(_) -- line: 46
end

return t
