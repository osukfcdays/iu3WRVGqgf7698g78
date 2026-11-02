local ReplicatedStorage = game:GetService("ReplicatedStorage")
local BetterDebris_m = require(ReplicatedStorage.Modules.BetterDebris)
local Finisher_m = require(ReplicatedStorage.Modules.Finisher)
local t = setmetatable({}, Finisher_m)
t.__index = t

function t.new(...) -- line: 11
    -- upvalues:
    --  [1] Finisher_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(Finisher_m.new(...), t)
    t_1:_Init()

    return t_1
end

function t.PlayServer(arg1) -- line: 23
    -- upvalues:
    --  [1] BetterDebris_m (copy)

    local RootPart = arg1._subject.RootPart
    local BodyVelocity = Instance.new("BodyVelocity")
    BodyVelocity.Velocity = Vector3.new(0, 0, 0)
    BodyVelocity.MaxForce = Vector3.new(10000, 0, 10000)
    BodyVelocity.Parent = RootPart
    table.insert(arg1._destroy_these, BodyVelocity)
    BetterDebris_m:AddItem(BodyVelocity, 1.1)
    local BodyGyro = Instance.new("BodyGyro")
    BodyGyro.CFrame = CFrame.new(
        Vector3.new(0, 0, 0),
        RootPart.CFrame.LookVector * Vector3.new(1, 0, 1)
    )
    BodyGyro.MaxTorque = Vector3.new(100000, 100000, 100000)
    BodyGyro.Parent = RootPart
    table.insert(arg1._destroy_these, BodyGyro)
    BetterDebris_m:AddItem(BodyGyro, 1.1)
    wait(1.1)
    arg1:_Ragdoll()
    arg1:_AnchorModel()
end

function t.PlayClient(arg2) -- line: 46
    if not arg2._is_humanoid then
        return
    end

    local Animation = Instance.new("Animation")
    Animation.AnimationId = "rbxassetid://125438067163571"
    local Success, Result = pcall(arg2._subject.LoadAnimation, arg2._subject, Animation)

    if Success then
        Result:Play(0)
    end
end

function t._Init(_) -- line: 65
end

return t
