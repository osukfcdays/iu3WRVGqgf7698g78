local ReplicatedStorage = game:GetService("ReplicatedStorage")
local _ = require(ReplicatedStorage.Modules.CONSTANTS)
local Finisher_m = require(ReplicatedStorage.Modules.Finisher)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local t = setmetatable({}, Finisher_m)
t.__index = t

function t.new(...) -- line: 10
    -- upvalues:
    --  [1] Finisher_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(Finisher_m.new(...), t)
    t_1:_Init()

    return t_1
end

function t.PlayServer(arg1) -- line: 22
    -- upvalues:
    --  [1] Utility_m (copy)

    local v2 = arg1._is_humanoid and arg1._subject.RootPart or arg1._subject
    local Attachment = Instance.new("Attachment")
    Attachment.Parent = v2
    local AngularVelocity = Instance.new("AngularVelocity")
    AngularVelocity.MaxTorque = 10000
    AngularVelocity.AngularVelocity = Random.new():NextUnitVector() * 5
    AngularVelocity.Attachment0 = Attachment
    AngularVelocity.Parent = v2
    table.insert(arg1._destroy_these, AngularVelocity)
    local v3 = script.Guide:Clone()
    v3.BodyForce.Force = Vector3.new(0, workspace.Gravity * v3:GetMass() * 0.875, 0)
    v3.CFrame = v2.CFrame
    v3.CollisionGroup = v2.CollisionGroup

    for _, val in pairs(arg1:_GetObjects(true)) do
        if val:IsA("BasePart") then
            val.Massless = true
            local NoCollisionConstraint = Instance.new("NoCollisionConstraint")
            NoCollisionConstraint.Part0 = v3
            NoCollisionConstraint.Part1 = val
            NoCollisionConstraint.Parent = v3
        end
    end

    local Attachment_1 = Instance.new("Attachment")
    Attachment_1.Parent = v2
    v2 = Instance.new("AlignPosition")
    v2.Attachment0 = Attachment_1
    v2.Attachment1 = v3.Attachment
    v2.MaxForce = 1000000
    v2.MaxVelocity = 32
    v2.Parent = v3
    v3.Parent = workspace
    table.insert(arg1._destroy_these, v3)
    Utility_m:Knockback(
        v3,
        Random.new():NextUnitVector() * Vector3.new(1, 0, 1) * 10 + Vector3.new(0, 15, 0)
    )
    arg1:_Ragdoll()
end

function t.PlayClient(arg2) -- line: 69
    arg2:CreateSound(
        "rbxassetid://115089214845604",
        1,
        1 + 0.1 * math.random(),
        nil,
        true,
        10
    )
end

function t._Init(_) -- line: 77
end

return t
