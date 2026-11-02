local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Ragdoll_m = require(ReplicatedStorage.Modules.Finishers.Ragdoll)
local _ = require(ReplicatedStorage.Modules.BetterDebris)
local _ = require(ReplicatedStorage.Modules.Utility)
local t = setmetatable({}, Ragdoll_m)
t.__index = t

function t.new(...) -- line: 13
    -- upvalues:
    --  [1] Ragdoll_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(Ragdoll_m.new(...), t)
    t_1:_Init()

    return t_1
end

function t.PlayClient(arg1, ...) -- line: 25
    -- upvalues:
    --  [1] Ragdoll_m (copy)
    --  [2] RunService (copy)

    Ragdoll_m.PlayClient(arg1, ...)
    local v2 = arg1._is_humanoid and arg1._subject.RootPart or arg1._subject
    local cframe = CFrame.Angles(0, math.random() * 3.141592653589793 * 2, 0)
    local v4 = script.Model:Clone()
    v4.Parent = workspace
    table.insert(arg1._destroy_these, v4)
    local RenderSteppedConnection = RunService.RenderStepped:Connect(function() -- line: 35
        -- upvalues:
        --  [1] v4 (copy)
        --  [2] v2 (copy)
        --  [3] cframe (copy)

        v4:PivotTo(CFrame.new(v2.Position) * cframe)
    end)
    table.insert(arg1._connections, RenderSteppedConnection)
    local Success, Result = pcall(
        v4.AnimationController.LoadAnimation,
        v4.AnimationController,
        v4.Animation
    )

    if Success then
        Result:Play(0)
        Result:AdjustSpeed(0.5)
        wait(0.266)
        arg1:CreateSound(
            "rbxassetid://8970814590",
            1,
            1,
            nil,
            true,
            5
        )
        wait(0.334)
        arg1:CreateSound(
            "rbxassetid://8970814590",
            1,
            1.25,
            nil,
            true,
            5
        )
        wait(0.134)
        arg1:CreateSound(
            "rbxassetid://8970814590",
            1,
            1.5,
            nil,
            true,
            5
        )
        wait(2)
        Result:AdjustSpeed(0.25)

        if Result.IsPlaying then
            Result.Stopped:Wait()
        end
    end

    v4:Destroy()
    RenderSteppedConnection:Disconnect()
end

function t._Init(_) -- line: 76
end

return t
