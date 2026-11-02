local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local BetterDebris_m = require(ReplicatedStorage.Modules.BetterDebris)
local Ragdoll_m = require(ReplicatedStorage.Modules.Finishers.Ragdoll)
local _ = require(ReplicatedStorage.Modules.Utility)
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
    local BodyGyro = Instance.new("BodyGyro")
    BodyGyro.CFrame = CFrame.new(
        Vector3.new(0, 0, 0),
        RootPart.CFrame.LookVector * Vector3.new(1, 0, 1)
    )
    BodyGyro.MaxTorque = Vector3.new(100000, 100000, 100000)
    BodyGyro.Parent = RootPart
    table.insert(arg1._destroy_these, BodyGyro)
    BetterDebris_m:AddItem(BodyGyro, 4)
    local BodyVelocity = Instance.new("BodyVelocity")
    BodyVelocity.MaxForce = Vector3.new(100000, 0, 100000)
    BodyVelocity.Velocity = Vector3.new(0, 0, 0)
    BodyVelocity.Parent = RootPart
    table.insert(arg1._destroy_these, BodyGyro)
    BetterDebris_m:AddItem(BodyGyro, 4)
    local Animation = Instance.new("Animation")
    Animation.AnimationId = "rbxassetid://139485945992954"
    local Success, Result = pcall(arg1._subject.LoadAnimation, arg1._subject, Animation)

    if Success then
        Result:Play(0)
    end

    wait(1.95)
    arg1:_Ragdoll()
    arg1:_AnchorModel()
end

function t.PlayClient(arg2) -- line: 63
    -- upvalues:
    --  [1] BetterDebris_m (copy)
    --  [2] RunService (copy)

    if not arg2._is_humanoid then
        return
    end

    local Animation_1 = Instance.new("Animation")
    Animation_1.AnimationId = "rbxassetid://139485945992954"
    local v5 = script.Model:Clone()
    v5.PrimaryPart = v5.HumanoidRootPart
    v5.Parent = workspace
    table.insert(arg2._destroy_these, v5)
    BetterDebris_m:AddItem(v5, 4)
    table.insert(arg2._connections, RunService.RenderStepped:Connect(function() -- line: 77
        -- upvalues:
        --  [1] v5 (copy)
        --  [2] arg2 (copy)

        v5:PivotTo(arg2._subject.RootPart.CFrame)
    end))
    local v6 = pairs
    local _ = RunService.RenderStepped:Connect(function() -- line: 77
        -- upvalues:
        --  [1] v5 (copy)
        --  [2] arg2 (copy)

        v5:PivotTo(arg2._subject.RootPart.CFrame)
    end)

    for _, val in v6(v5:GetDescendants()) do
        if val:IsA("BasePart") then
            val.CollisionGroup = "Noclip"
        end
    end

    local Success_1, Result_1 = pcall(
        v5.AnimationController.LoadAnimation,
        v5.AnimationController,
        Animation_1
    )

    if Success_1 then
        Result_1:Play(0)
    end

    wait(1.95)
    arg2:CreateSound(
        "rbxassetid://137835445333923",
        1,
        1.25 + 0.25 * math.random(),
        nil,
        true,
        10
    )
end

function t._Init(_) -- line: 102
end

return t
