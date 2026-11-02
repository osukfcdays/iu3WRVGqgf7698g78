local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Ragdoll_m = require(ReplicatedStorage.Modules.Finishers.Ragdoll)
local BetterDebris_m = require(ReplicatedStorage.Modules.BetterDebris)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local t = { 38, 93, 113, 125, 130, 139, 150 }
local t_1 = setmetatable({}, Ragdoll_m)
t_1.__index = t_1

function t_1.new(...) -- line: 14
    -- upvalues:
    --  [1] Ragdoll_m (copy)
    --  [2] t_1 (copy)

    local t_2 = setmetatable(Ragdoll_m.new(...), t_1)
    t_2:_Init()

    return t_2
end

function t_1.PlayClient(arg1, ...) -- line: 26
    -- upvalues:
    --  [1] Ragdoll_m (copy)
    --  [2] Utility_m (copy)
    --  [3] RunService (copy)
    --  [4] t (copy)
    --  [5] BetterDebris_m (copy)

    Ragdoll_m.PlayClient(arg1, ...)
    local v2 = arg1._is_humanoid and arg1._subject.RootPart or arg1._subject
    local cframe = CFrame.Angles(0, math.random() * 3.141592653589793 * 2, 0)
    local v4 = script.Model:Clone()
    v4.Parent = workspace
    table.insert(arg1._destroy_these, v4)

    for _, child in pairs(v4.HumanoidRootPart.Attachment:GetChildren()) do
        if child:IsA("ParticleEmitter") then
            Utility_m:ScaleParticleEmitter(child, 2)
        end
    end

    local RenderSteppedConnection = RunService.RenderStepped:Connect(function() -- line: 42
        -- upvalues:
        --  [1] v4 (copy)
        --  [2] v2 (copy)
        --  [3] cframe (copy)

        v4:PivotTo(CFrame.new(v2.Position) * cframe)
    end)
    table.insert(arg1._connections, RenderSteppedConnection)
    local v8 = 1 + 0.05 * math.random()
    arg1:CreateSound(
        "rbxassetid://99054783153991",
        1,
        v8,
        nil,
        true,
        5
    )
    local Success, Result = pcall(
        v4.AnimationController.LoadAnimation,
        v4.AnimationController,
        v4.Animation
    )

    if Success then
        Result:Play(0)
        Result:AdjustSpeed(1.5)
        arg1:_InternalThread(task.spawn, function() -- line: 56
            -- upvalues:
            --  [1] t (ref)
            --  [2] v4 (copy)
            --  [3] Utility_m (ref)
            --  [4] arg1 (copy)

            local v9 = 0

            for key_1, val in pairs(t) do
                v9 += wait((val - 1 * key_1) / 60 / 1.5 - v9)
                local Attachment = v4.HumanoidRootPart.Attachment
                local v10 = math.random() - 0.5
                Attachment.Position = Vector3.new(v10, math.random() - 0.5, math.random() - 0.5) * 5
                Utility_m:PlayParticles(v4.HumanoidRootPart.Attachment)
                arg1:CreateSound(
                    "rbxassetid://11170608962",
                    0.75,
                    1 + 0.125 * key_1,
                    nil,
                    true,
                    5
                )
                arg1:CreateSound(
                    "rbxassetid://14796313153",
                    1,
                    1 + 0.125 * key_1,
                    nil,
                    true,
                    5
                )
            end
        end)

        if Result.IsPlaying then
            Result.Stopped:Wait()
        end
    end

    for _, descendant in pairs(v4:GetDescendants()) do
        if descendant:IsA("BasePart") then
            descendant.Transparency = 1
        end
    end

    BetterDebris_m:AddItem(v4, 3)
    RenderSteppedConnection:Disconnect()
end

function t_1._Init(_) -- line: 87
end

return t_1
