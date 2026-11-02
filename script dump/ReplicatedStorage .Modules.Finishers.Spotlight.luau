local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Ragdoll_m = require(ReplicatedStorage.Modules.Finishers.Ragdoll)
local _ = require(ReplicatedStorage.Modules.BetterDebris)
local _ = require(ReplicatedStorage.Modules.Utility)
local t = setmetatable({}, Ragdoll_m)
t.__index = t

function t.new(...) -- line: 11
    -- upvalues:
    --  [1] Ragdoll_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(Ragdoll_m.new(...), t)
    t_1:_Init()

    return t_1
end

function t.PlayClient(arg1, ...) -- line: 23
    -- upvalues:
    --  [1] Ragdoll_m (copy)
    --  [2] RunService (copy)

    Ragdoll_m.PlayClient(arg1, ...)
    local v2 = arg1._is_humanoid and arg1._subject.RootPart or arg1._subject
    local cframe = CFrame.Angles(0, math.random() * 3.141592653589793 * 2, 0)
    local v4 = script.Model:Clone()
    v4.Parent = workspace
    table.insert(arg1._destroy_these, v4)
    local RenderSteppedConnection = RunService.RenderStepped:Connect(function() -- line: 33
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
        local Beam = v4.StageLight.Here.Beam
        local SpotLight = v4.StageLight.Here.SpotLight
        arg1:_InternalThread(task.spawn, function() -- line: 47
            -- upvalues:
            --  [1] Beam (copy)
            --  [2] SpotLight (copy)
            --  [3] arg1 (copy)
            --  [4] v2 (copy)

            Beam.Enabled = false
            SpotLight.Enabled = false
            wait(1.25)
            Beam.Enabled = true
            SpotLight.Enabled = true
            arg1:CreateSound(
                "rbxassetid://110123816156526",
                1.25,
                0.95 + 0.1 * math.random(),
                v2,
                true,
                10
            )
        end)

        if Result.IsPlaying then
            Result.Stopped:Wait()
        end
    end

    v4:Destroy()
    RenderSteppedConnection:Disconnect()
end

function t._Init(_) -- line: 72
end

return t
