local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local BetterDebris_m = require(ReplicatedStorage.Modules.BetterDebris)
local Ragdoll_m = require(ReplicatedStorage.Modules.Finishers.Ragdoll)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local t = setmetatable({}, Ragdoll_m)
t.__index = t

function t.new(...) -- line: 15
    -- upvalues:
    --  [1] Ragdoll_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(Ragdoll_m.new(...), t)
    t_1:_Init()

    return t_1
end

function t.PlayServer(arg1) -- line: 27
    -- upvalues:
    --  [1] BetterDebris_m (copy)

    if not arg1._is_humanoid then
        return
    end

    local RootPart = arg1._subject.RootPart

    for _, val in pairs(arg1:_GetObjects(true)) do
        if val:IsA("BasePart") and val ~= RootPart then
            val.CollisionGroup = "Noclip"
        end
    end

    local BodyGyro = Instance.new("BodyGyro")
    BodyGyro.CFrame = CFrame.new(
        Vector3.new(0, 0, 0),
        RootPart.CFrame.LookVector * Vector3.new(1, 0, 1)
    )
    BodyGyro.MaxTorque = Vector3.new(100000, 100000, 100000)
    BodyGyro.Parent = RootPart
    table.insert(arg1._destroy_these, BodyGyro)
    BetterDebris_m:AddItem(BodyGyro, 2.85)
    local BodyVelocity = Instance.new("BodyVelocity")
    BodyVelocity.MaxForce = Vector3.new(100000, 100000, 100000)
    BodyVelocity.Velocity = Vector3.new(0, 0, 0)
    BodyVelocity.Parent = RootPart
    table.insert(arg1._destroy_these, BodyGyro)
    BetterDebris_m:AddItem(BodyGyro, 2.85)
    local Animation = Instance.new("Animation")
    Animation.AnimationId = "rbxassetid://96799926007713"
    local Success, Result = pcall(arg1._subject.LoadAnimation, arg1._subject, Animation)

    if Success then
        Result:Play(0)
    end

    wait(2.8)
    arg1:_Ragdoll()
    arg1:_AnchorModel()
end

function t.PlayClient(arg2) -- line: 69
    -- upvalues:
    --  [1] BetterDebris_m (copy)
    --  [2] RunService (copy)
    --  [3] Utility_m (copy)

    if not arg2._is_humanoid then
        return
    end

    local Animation_1 = Instance.new("Animation")
    Animation_1.AnimationId = "rbxassetid://96799926007713"
    local v6 = script.Model:Clone()
    v6.PrimaryPart = v6.HumanoidRootPart
    v6.Parent = workspace
    table.insert(arg2._destroy_these, v6)
    BetterDebris_m:AddItem(v6, 2.85)
    table.insert(arg2._connections, RunService.RenderStepped:Connect(function() -- line: 83
        -- upvalues:
        --  [1] v6 (copy)
        --  [2] arg2 (copy)

        v6:PivotTo(arg2._subject.RootPart.CFrame)
    end))
    local v7 = pairs
    local _ = RunService.RenderStepped:Connect(function() -- line: 83
        -- upvalues:
        --  [1] v6 (copy)
        --  [2] arg2 (copy)

        v6:PivotTo(arg2._subject.RootPart.CFrame)
    end)

    for _, val_1 in v7(v6:GetDescendants()) do
        if val_1:IsA("BasePart") then
            val_1.CollisionGroup = "Noclip"
        end
    end

    local Success_1, Result_1 = pcall(
        v6.AnimationController.LoadAnimation,
        v6.AnimationController,
        Animation_1
    )

    if Success_1 then
        Result_1:Play(0)
    end

    wait(2)
    arg2:CreateSound(
        "rbxassetid://83406711884881",
        1,
        1 + 0.1 * math.random(),
        nil,
        true,
        5
    )
    Utility_m:PlayParticles(v6.Hole)
end

function t._Init(_) -- line: 109
end

return t
