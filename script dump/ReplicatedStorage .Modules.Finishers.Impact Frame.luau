local ReplicatedStorage = game:GetService("ReplicatedStorage")
local BetterDebris_m = require(ReplicatedStorage.Modules.BetterDebris)
local Finisher_m = require(ReplicatedStorage.Modules.Finisher)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
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

    local RootPart = arg1._subject.RootPart
    local BodyVelocity = Instance.new("BodyVelocity")
    BodyVelocity.Velocity = Vector3.new(0, 0, 0)
    BodyVelocity.MaxForce = Vector3.new(10000, 0, 10000)
    BodyVelocity.Parent = RootPart
    table.insert(arg1._destroy_these, BodyVelocity)
    BetterDebris_m:AddItem(BodyVelocity, 0.5)
    local BodyGyro = Instance.new("BodyGyro")
    BodyGyro.CFrame = CFrame.new(
        Vector3.new(0, 0, 0),
        RootPart.CFrame.LookVector * Vector3.new(1, 0, 1)
    )
    BodyGyro.MaxTorque = Vector3.new(100000, 100000, 100000)
    BodyGyro.Parent = RootPart
    table.insert(arg1._destroy_these, BodyGyro)
    BetterDebris_m:AddItem(BodyGyro, 0.5)
    wait(0.5)
    BodyVelocity:Destroy()
    BodyGyro:Destroy()
    arg1:_Ragdoll()
    arg1:_AnchorModel()
    local BodyVelocity_1 = Instance.new("BodyVelocity")
    BodyVelocity_1.MaxForce = Vector3.new(100000, 100000, 100000)
    BodyVelocity_1.Velocity = RootPart.CFrame.RightVector * 64
    BodyVelocity_1.Parent = RootPart
    table.insert(arg1._destroy_these, BodyVelocity_1)
    BetterDebris_m:AddItem(BodyVelocity_1, 0.2)
end

function t.PlayClient(arg2) -- line: 61
    -- upvalues:
    --  [1] Utility_m (copy)

    if not arg2._is_humanoid then
        return
    end

    local Animation = Instance.new("Animation")
    Animation.AnimationId = "rbxassetid://101848673881346"
    local Success, Result = pcall(arg2._subject.LoadAnimation, arg2._subject, Animation)

    if Success then
        Result:Play(0)
    end

    wait(0.25)
    local v2 = script.Particles:Clone()
    v2.Parent = workspace
    local v3 = arg2._is_humanoid and arg2._subject.RootPart or arg2._subject
    v2.CFrame = v3.CFrame
    table.insert(arg2._destroy_these, v2)
    Utility_m:PlayParticles(v2)
    arg2:CreateSound(
        "rbxassetid://79427627396361",
        1.5,
        0.95 + 0.1 * math.random(),
        nil,
        true,
        5
    )
    local Highlight = Instance.new("Highlight")
    Highlight.FillColor = Color3.fromRGB(255, 255, 255)
    Highlight.OutlineColor = Color3.fromRGB(0, 0, 0)
    Highlight.OutlineTransparency = 0
    Highlight.FillTransparency = 0
    Highlight.DepthMode = Enum.HighlightDepthMode.Occluded
    Highlight.Parent = arg2._subject.Parent
    table.insert(arg2._destroy_these, Highlight)
    wait(0.05)
    Highlight.FillColor = Color3.fromRGB(0, 0, 0)
    Highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    wait(0.05)
    Highlight.FillColor = Color3.fromRGB(255, 255, 255)
    Highlight.OutlineColor = Color3.fromRGB(0, 0, 0)
    wait(0.05)
    Highlight:Destroy()
end

function t._Init(_) -- line: 113
end

return t
