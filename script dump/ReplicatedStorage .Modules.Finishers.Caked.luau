local ReplicatedStorage = game:GetService("ReplicatedStorage")
local BetterDebris_m = require(ReplicatedStorage.Modules.BetterDebris)
local Ragdoll_m = require(ReplicatedStorage.Modules.Finishers.Ragdoll)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local t = setmetatable({}, Ragdoll_m)
t.__index = t

function t.new(...) -- line: 10
    -- upvalues:
    --  [1] Ragdoll_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(Ragdoll_m.new(...), t)
    t_1:_Init()

    return t_1
end

function t.PlayServer(arg1, ...) -- line: 22
    -- upvalues:
    --  [1] Ragdoll_m (copy)
    --  [2] BetterDebris_m (copy)

    Ragdoll_m.PlayServer(arg1, ...)
    local v2 = arg1._is_humanoid and arg1._subject.RootPart or arg1._subject
    local BodyVelocity = Instance.new("BodyVelocity")
    BodyVelocity.MaxForce = Vector3.new(100000, 100000, 100000)
    BodyVelocity.Velocity = Random.new():NextUnitVector() * Vector3.new(1, 0, 1) * 24
    BodyVelocity.Parent = v2
    table.insert(arg1._destroy_these, BodyVelocity)
    BetterDebris_m:AddItem(BodyVelocity, 0.2)
end

function t.PlayClient(arg2, ...) -- line: 35
    -- upvalues:
    --  [1] Ragdoll_m (copy)
    --  [2] Utility_m (copy)

    Ragdoll_m.PlayClient(arg2, ...)
    local v3 = arg2._is_humanoid

    if v3 then
        v3 = arg2._subject.Parent:FindFirstChild("Head")
    end

    if not v3 then
        return
    end

    local v4 = script.Model:Clone()
    v4.PrimaryPart = v4.Primary
    v4:PivotTo(v3.CFrame)
    v4.Parent = v3
    table.insert(arg2._destroy_these, v4)
    local WeldConstraint = Instance.new("WeldConstraint")
    WeldConstraint.Part0 = v3
    WeldConstraint.Part1 = v4.Primary
    WeldConstraint.Parent = v4
    local v5 = script.Particles.Attachment:Clone()
    v5.Parent = v3
    table.insert(arg2._destroy_these, v5)
    Utility_m:PlayParticles(v5)
    arg2:CreateSound(
        "rbxassetid://106768039815049",
        1.25,
        1 + 0.1 * math.random(),
        nil,
        true,
        5
    )
    arg2:CreateSound(
        "rbxassetid://113457984699397",
        1.75,
        1 + 0.1 * math.random(),
        nil,
        true,
        5
    )
end

function t._Init(_) -- line: 68
end

return t
