local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local BetterDebris_m = require(ReplicatedStorage.Modules.BetterDebris)
local Finisher_m = require(ReplicatedStorage.Modules.Finisher)
local t = setmetatable({}, Finisher_m)
t.__index = t

function t.new(...) -- line: 14
    -- upvalues:
    --  [1] Finisher_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(Finisher_m.new(...), t)
    t_1:_Init()

    return t_1
end

function t.PlayServer(arg1) -- line: 26
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
    BetterDebris_m:AddItem(BodyGyro, 1.5)
    local Animation = Instance.new("Animation")
    Animation.AnimationId = "rbxassetid://135124706498215"
    local Success, Result = pcall(arg1._subject.LoadAnimation, arg1._subject, Animation)

    if Success then
        Result:Play(0)
    end

    wait(1.25)
    local Position = arg1._subject.RootPart.Position
    wait(0.25)
    BodyGyro:Destroy()
    arg1:_Ragdoll()
    arg1:_AnchorModel()
    local v2 = arg1._subject.RootPart.Position - Position

    if v2.Magnitude <= 0.01 then
        v2 = Vector3.new(0, 0, 0)
    else
        v2 = v2.Unit
    end

    arg1._subject.RootPart.Velocity = v2 * -256
end

function t.PlayClient(arg2) -- line: 66
    -- upvalues:
    --  [1] BetterDebris_m (copy)
    --  [2] RunService (copy)

    if not arg2._is_humanoid then
        return
    end

    local Animation_1 = Instance.new("Animation")
    Animation_1.AnimationId = "rbxassetid://135124706498215"
    local v6 = script.Model:Clone()
    v6.PrimaryPart = v6.HumanoidRootPart
    v6:PivotTo(arg2._subject.RootPart.CFrame)
    v6.Parent = workspace
    table.insert(arg2._destroy_these, v6)
    BetterDebris_m:AddItem(v6, 2.2)
    table.insert(arg2._connections, RunService.RenderStepped:Connect(function() -- line: 81
        -- upvalues:
        --  [1] v6 (copy)
        --  [2] arg2 (copy)

        v6:PivotTo(arg2._subject.RootPart.CFrame)
    end))
    local v7 = pairs
    local _ = RunService.RenderStepped:Connect(function() -- line: 81
        -- upvalues:
        --  [1] v6 (copy)
        --  [2] arg2 (copy)

        v6:PivotTo(arg2._subject.RootPart.CFrame)
    end)

    for _, val in v7(v6:GetDescendants()) do
        if val:IsA("BasePart") then
            val.CollisionGroup = "Noclip"
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

    arg2:CreateSound(
        "rbxassetid://77810366972840",
        1,
        1 + 0.1 * math.random(),
        nil,
        true,
        5
    )
    wait(1)
    arg2:CreateSound(
        "rbxassetid://76979641579471",
        1,
        1 + 0.1 * math.random(),
        nil,
        true,
        5
    )
end

function t._Init(_) -- line: 108
end

return t
