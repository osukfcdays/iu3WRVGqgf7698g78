local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
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
    --  [1] TweenService (copy)

    if not arg1._is_humanoid then
        return
    end

    arg1._subject.RootPart.Anchored = true
    local RootPart = arg1._subject.RootPart
    RootPart.CFrame = RootPart.CFrame * CFrame.Angles(0, math.random() * 3.141592653589793 * 2, 0)
    local v3 = TweenService
    local RootPart_1 = arg1._subject.RootPart
    local tweenInfo = TweenInfo.new(1.6, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
    v3:Create(
        RootPart_1,
        tweenInfo,
        {
            CFrame = arg1._subject.RootPart.CFrame * CFrame.Angles(0, 3.141592653589793, 0) * CFrame.new(
                0,
                0,
                -10
            )
        }
    ):Play()
    local Animation = Instance.new("Animation")
    Animation.AnimationId = "rbxassetid://84375821263857"
    local Success, Result = pcall(arg1._subject.LoadAnimation, arg1._subject, Animation)

    if Success then
        Result:Play(0)
    end

    wait(1.6)
    arg1:_HideBody()
end

function t.PlayClient(arg2) -- line: 49
    -- upvalues:
    --  [1] BetterDebris_m (copy)
    --  [2] RunService (copy)

    if not arg2._is_humanoid then
        return
    end

    local Animation_1 = Instance.new("Animation")
    Animation_1.AnimationId = "rbxassetid://84375821263857"
    local v9 = script.Model:Clone()
    v9.PrimaryPart = v9.HumanoidRootPart
    v9:PivotTo(arg2._subject.RootPart.CFrame)
    v9.Parent = workspace
    table.insert(arg2._destroy_these, v9)
    BetterDebris_m:AddItem(v9, 1.6)

    for _, val in pairs(v9:GetDescendants()) do
        if val:IsA("BasePart") then
            val.CollisionGroup = "Noclip"
        end
    end

    local Success_1, Result_1 = pcall(
        v9.AnimationController.LoadAnimation,
        v9.AnimationController,
        Animation_1
    )

    if Success_1 then
        Result_1:Play(0)
    end

    arg2:_InternalThread(task.spawn, function() -- line: 76
        -- upvalues:
        --  [1] arg2 (copy)

        arg2:CreateSound(
            "rbxassetid://86826830376840",
            0.75,
            1,
            nil,
            true,
            5
        )
        wait(0.15)
        arg2:CreateSound(
            "rbxassetid://7127702569",
            1,
            1.2,
            nil,
            true,
            5
        )
        wait(1.4500000000000002)
        arg2:CreateSound(
            "rbxassetid://7127702569",
            1,
            0.8,
            nil,
            true,
            5
        )
    end)
    local RenderSteppedConnection = RunService.RenderStepped:Connect(function() -- line: 88
        -- upvalues:
        --  [1] v9 (copy)
        --  [2] arg2 (copy)

        v9:PivotTo(arg2._subject.RootPart.CFrame)
    end)
    table.insert(arg2._connections, RenderSteppedConnection)
    wait(1.6)
    RenderSteppedConnection:Disconnect()
end

function t._Init(_) -- line: 103
end

return t
