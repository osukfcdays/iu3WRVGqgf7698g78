local ReplicatedStorage = game:GetService("ReplicatedStorage")
local BetterDebris_m = require(ReplicatedStorage.Modules.BetterDebris)
local Finisher_m = require(ReplicatedStorage.Modules.Finisher)
local t = setmetatable({}, Finisher_m)
t.__index = t

function t.new(...) -- line: 12
    -- upvalues:
    --  [1] Finisher_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(Finisher_m.new(...), t)
    t_1:_Init()

    return t_1
end

function t.PlayServer(arg1) -- line: 24
    -- upvalues:
    --  [1] BetterDebris_m (copy)

    if not arg1._is_humanoid then
        return
    end

    local Animation = Instance.new("Animation")
    Animation.AnimationId = "rbxassetid://89773418199914"
    local Success, Result = pcall(arg1._subject.LoadAnimation, arg1._subject, Animation)

    if Success then
        Result:Play(0)
    end

    local RootPart = arg1._subject.RootPart
    local BodyVelocity = Instance.new("BodyVelocity")
    BodyVelocity.Velocity = Vector3.new(0, 0, 0)
    BodyVelocity.MaxForce = Vector3.new(10000, 10000, 10000)
    BodyVelocity.Parent = RootPart
    table.insert(arg1._destroy_these, BodyVelocity)
    BetterDebris_m:AddItem(BodyVelocity, 0.3)
    local BodyGyro = Instance.new("BodyGyro")
    BodyGyro.CFrame = CFrame.new(
        Vector3.new(0, 0, 0),
        RootPart.CFrame.LookVector * Vector3.new(1, 0, 1)
    )
    BodyGyro.MaxTorque = Vector3.new(100000, 100000, 100000)
    BodyGyro.Parent = RootPart
    table.insert(arg1._destroy_these, BodyGyro)
    BetterDebris_m:AddItem(BodyGyro, 0.3)
    wait(0.3)
    BodyGyro:Destroy()
    BodyVelocity:Destroy()
    arg1:_Ragdoll()
    arg1:_AnchorModel()
end

function t.PlayClient(arg2) -- line: 63
    if not arg2._is_humanoid then
        return
    end

    local v2 = script.Peel:Clone()
    v2.MeshPart1.CollisionGroup = "IgnoreEntities"
    v2.MeshPart2.CollisionGroup = "IgnoreEntities"
    v2.MeshPart3.CollisionGroup = "IgnoreEntities"
    v2.Primary.CollisionGroup = "IgnoreEntities"
    v2.Parent = workspace
    v2:PivotTo(arg2._subject.RootPart.CFrame * CFrame.new(-0.5, -2.5, -1))
    table.insert(arg2._destroy_these, v2)
    arg2:CreateSound(
        "rbxassetid://8845788882",
        2,
        1,
        nil,
        true,
        5
    )
    wait(0.075)
    v2.PrimaryPart.Anchored = false
    v2.PrimaryPart.Velocity = ((CFrame.new(arg2._subject.RootPart.Position, v2.PrimaryPart.Position).LookVector * Vector3.new(1, 0, 1)).Unit + Vector3.new(0, 2, 0)) * 20
    v2.PrimaryPart.RotVelocity = Random.new():NextUnitVector() * (15 + 60 * math.random())
end

function t._Init(_) -- line: 90
end

return t
