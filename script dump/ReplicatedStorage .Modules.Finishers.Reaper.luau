local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local _ = game:GetService("Players")
local Ragdoll_m = require(ReplicatedStorage.Modules.Finishers.Ragdoll)
local _ = require(ReplicatedStorage.Modules.BetterDebris)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local t = setmetatable({}, Ragdoll_m)
t.__index = t

function t.new(...) -- line: 12
    -- upvalues:
    --  [1] Ragdoll_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(Ragdoll_m.new(...), t)
    t_1:_Init()

    return t_1
end

function t.PlayServer(arg1, ...) -- line: 24
    -- upvalues:
    --  [1] Ragdoll_m (copy)

    local v2 = arg1._is_humanoid and arg1._subject.RootPart or arg1._subject
    v2.Anchored = true
    wait(0.9)
    v2.Anchored = false
    v2 = arg1._is_humanoid

    if v2 then
        v2 = arg1._subject.Parent:FindFirstChild("Waist", true)
    end

    if v2 then
        v2:Destroy()
    end

    Ragdoll_m.PlayServer(arg1, ...)
    v2 = arg1._is_humanoid

    if v2 then
        v2 = arg1._subject.Parent:FindFirstChild("UpperTorso")
    end

    if v2 then
        v2.Velocity = (Random.new():NextUnitVector() * Vector3.new(1, 0, 1) + Vector3.new(
            0,
            math.random(),
            0
        )) * (50 + 150 * math.random())
    end
end

function t.PlayClient(arg2) -- line: 48
    -- upvalues:
    --  [1] RunService (copy)
    --  [2] Utility_m (copy)

    local v5 = arg2._is_humanoid and arg2._subject.RootPart or arg2._subject
    local cframe = CFrame.Angles(0, math.random() * 3.141592653589793 * 2, 0)

    if arg2._is_humanoid then
        local Animation = Instance.new("Animation")
        Animation.AnimationId = "rbxassetid://4769412289"
        local Success, Result = pcall(arg2._subject.LoadAnimation, arg2._subject, Animation)

        if Success then
            Result:Play(0)
            Result:AdjustSpeed(0.16666666666666666)
        end
    end

    local v7 = script.Model:Clone()
    v7.Parent = workspace
    table.insert(arg2._destroy_these, v7)
    local RenderSteppedConnection = RunService.RenderStepped:Connect(function() -- line: 68
        -- upvalues:
        --  [1] v7 (copy)
        --  [2] v5 (copy)
        --  [3] cframe (copy)

        v7:PivotTo(CFrame.new(v5.Position) * cframe)
    end)
    table.insert(arg2._connections, RenderSteppedConnection)
    local Success_1, Result_1 = pcall(
        v7.AnimationController.LoadAnimation,
        v7.AnimationController,
        v7.Animation
    )

    if Success_1 then
        Result_1:Play(0)
        arg2:CreateSound(
            "rbxassetid://85156927480464",
            2,
            1,
            nil,
            true,
            5
        )
        wait(0.7)
        arg2:CreateSound(
            "rbxassetid://14111617408",
            2,
            1,
            nil,
            true,
            5
        )
        arg2:CreateSound(
            "rbxassetid://14111617269",
            1.5,
            1,
            nil,
            true,
            5
        )
        wait(0.2)
        Utility_m:PlayParticles(v7.HumanoidRootPart.Particles)

        if Result_1.IsPlaying then
            Result_1.Stopped:Wait()
        end

        v7:Destroy()
        wait(3)
    end

    RenderSteppedConnection:Disconnect()
end

function t._Init(_) -- line: 106
end

return t
