local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Ragdoll_m = require(ReplicatedStorage.Modules.Finishers.Ragdoll)
local BetterDebris_m = require(ReplicatedStorage.Modules.BetterDebris)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local t = { 50, 55, 57, 58, 62, 63, 75, 78, 104, 107, 111, 115 }
local t_1 = { "rbxassetid://11800684674", "rbxassetid://11800684590", "rbxassetid://11800684481" }
local t_2 = setmetatable({}, Ragdoll_m)
t_2.__index = t_2

function t_2.new(...) -- line: 15
    -- upvalues:
    --  [1] Ragdoll_m (copy)
    --  [2] t_2 (copy)

    local t_3 = setmetatable(Ragdoll_m.new(...), t_2)
    t_3:_Init()

    return t_3
end

function t_2.PlayClient(arg1, ...) -- line: 27
    -- upvalues:
    --  [1] Ragdoll_m (copy)
    --  [2] Utility_m (copy)
    --  [3] RunService (copy)
    --  [4] t (copy)
    --  [5] t_1 (copy)
    --  [6] BetterDebris_m (copy)

    Ragdoll_m.PlayClient(arg1, ...)
    local v2 = arg1._is_humanoid and arg1._subject.RootPart or arg1._subject
    local cframe = CFrame.Angles(0, math.random() * 3.141592653589793 * 2, 0)
    local v4 = script.Model:Clone()
    v4.Parent = workspace
    table.insert(arg1._destroy_these, v4)

    for _, child in pairs(v4.HumanoidRootPart.Attachment:GetChildren()) do
        if child:IsA("ParticleEmitter") then
            Utility_m:ScaleParticleEmitter(child, 1.5)
        end
    end

    local RenderSteppedConnection = RunService.RenderStepped:Connect(function() -- line: 43
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
        Result:AdjustSpeed(1)
        arg1:_InternalThread(task.spawn, function() -- line: 55
            -- upvalues:
            --  [1] t (ref)
            --  [2] v4 (copy)
            --  [3] Utility_m (ref)
            --  [4] arg1 (copy)
            --  [5] t_1 (ref)

            local v8 = 0.08333333333333333

            for key_1, val in pairs(t) do
                v8 += wait((val - 1 * key_1) / 60 / 1 - v8)
                local Attachment = v4.HumanoidRootPart.Attachment
                local v9 = math.random() - 0.5
                Attachment.Position = Vector3.new(v9, math.random() - 0.5, math.random() - 0.5) * 5
                Utility_m:PlayParticles(v4.HumanoidRootPart.Attachment)
                local v11 = arg1
                local v12 = t_1
                local v13 = 0.4 + 0.4 * (key_1 / #t)
                v11:CreateSound(
                    v12[math.random(#t_1)],
                    v13,
                    0.9 + 0.2 * math.random(),
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

function t_2._Init(_) -- line: 85
end

return t_2
