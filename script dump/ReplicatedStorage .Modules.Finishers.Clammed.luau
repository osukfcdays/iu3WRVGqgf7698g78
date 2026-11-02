local ReplicatedStorage = game:GetService("ReplicatedStorage")
local _ = game:GetService("TweenService")
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
    if not arg1._is_humanoid then
        return
    end

    arg1._subject.RootPart.Anchored = true
    local Animation = Instance.new("Animation")
    Animation.AnimationId = "rbxassetid://106864398124698"
    local Success, Result = pcall(arg1._subject.LoadAnimation, arg1._subject, Animation)

    if Success then
        Result:Play(0)
    end

    wait(2.15)
    arg1:_HideBody()
end

function t.PlayClient(arg2) -- line: 47
    -- upvalues:
    --  [1] BetterDebris_m (copy)
    --  [2] RunService (copy)

    if not arg2._is_humanoid then
        return
    end

    local Animation_1 = Instance.new("Animation")
    Animation_1.AnimationId = "rbxassetid://106864398124698"
    local v5 = script.Model:Clone()
    v5.PrimaryPart = v5.HumanoidRootPart
    v5:PivotTo(arg2._subject.RootPart.CFrame)
    v5.Parent = workspace
    table.insert(arg2._destroy_these, v5)
    BetterDebris_m:AddItem(v5, 2.15)

    for _, val in pairs(v5:GetDescendants()) do
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

    arg2:_InternalThread(task.spawn, function() -- line: 74
        -- upvalues:
        --  [1] arg2 (copy)

        wait(1.3)
        arg2:CreateSound(
            "rbxassetid://113843062064513",
            0.75,
            1 + 0.1 * math.random(),
            nil,
            true,
            5
        )
        arg2:CreateSound(
            "rbxassetid://95086117365305",
            0.75,
            1 + 0.1 * math.random(),
            nil,
            true,
            5
        )
    end)
    local RenderSteppedConnection = RunService.RenderStepped:Connect(function() -- line: 80
        -- upvalues:
        --  [1] v5 (copy)
        --  [2] arg2 (copy)

        v5:PivotTo(arg2._subject.RootPart.CFrame)
    end)
    table.insert(arg2._connections, RenderSteppedConnection)
    wait(2.15)
    RenderSteppedConnection:Disconnect()
end

function t._Init(_) -- line: 95
end

return t
