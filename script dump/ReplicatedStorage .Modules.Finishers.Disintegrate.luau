local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local BetterDebris_m = require(ReplicatedStorage.Modules.BetterDebris)
local Ragdoll_m = require(ReplicatedStorage.Modules.Finishers.Ragdoll)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
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

function t.PlayServer(arg1, ...) -- line: 23
    -- upvalues:
    --  [1] Ragdoll_m (copy)
    --  [2] BetterDebris_m (copy)

    Ragdoll_m.PlayServer(arg1, ...)
    local v2 = arg1._is_humanoid and arg1._subject.RootPart or arg1._subject
    local v3 = arg1._eliminator

    if v3 then
        v3 = arg1._eliminator.Character

        if v3 then
            v3 = arg1._eliminator.Character:FindFirstChild("HumanoidRootPart")
        end
    end

    if not v3 then
        return
    end

    local BodyVelocity = Instance.new("BodyVelocity")
    BodyVelocity.MaxForce = Vector3.new(10000, 10000, 10000)
    BodyVelocity.Velocity = CFrame.new(v3.Position, v2.Position).LookVector * 100
    BodyVelocity.Parent = v2
    BetterDebris_m:AddItem(BodyVelocity, 3)
end

function t.PlayClient(arg2, ...) -- line: 40
    -- upvalues:
    --  [1] Ragdoll_m (copy)
    --  [2] RunService (copy)
    --  [3] Utility_m (copy)

    Ragdoll_m.PlayClient(arg2, ...)
    local v4 = arg2._is_humanoid and arg2._subject.RootPart or arg2._subject
    local v5 = arg2._eliminator

    if v5 then
        v5 = arg2._eliminator.Character

        if v5 then
            v5 = arg2._eliminator.Character:FindFirstChild("HumanoidRootPart")
        end
    end

    if not v5 then
        return
    end

    local v6 = script.Particles:Clone()
    v6.Parent = workspace
    table.insert(arg2._destroy_these, v6)
    arg2:CreateSound(
        "rbxassetid://87269038986811",
        1.25,
        0.95 + 0.1 * math.random(),
        v4,
        true,
        10
    )
    local RenderSteppedConnection = RunService.RenderStepped:Connect(function() -- line: 56
        -- upvalues:
        --  [1] v5 (copy)
        --  [2] v4 (copy)
        --  [3] v6 (copy)

        local cframe = CFrame.new(v5.Position, v4.Position)
        v6.Hit.WorldCFrame = CFrame.new(v4.Position) * cframe.Rotation
        v6.Start.WorldCFrame = cframe * CFrame.new(0, 0, -1)
    end)
    table.insert(arg2._connections, RenderSteppedConnection)
    local t_2 = {}

    for _, val in pairs(v6:GetDescendants()) do
        if val:IsA("Beam") then
            t_2[val] = { val.Width0, val.Width1 }
        end
    end

    Utility_m:RenderstepForLoop(0, 1, 0.01, function(arg3) -- line: 73
        -- upvalues:
        --  [1] t_2 (copy)

        local v9 = 1 - arg3 ^ 4

        for key_1, val_1 in pairs(t_2) do
            key_1.Width0 = val_1[1] * v9
            key_1.Width1 = val_1[2] * v9
        end
    end)

    for _, val_2 in pairs(v6:GetDescendants()) do
        if val_2:IsA("ParticleEmitter") or val_2:IsA("Beam") then
            val_2.Enabled = false
        end
    end

    wait(1)
    RenderSteppedConnection:Disconnect()
end

function t._Init(_) -- line: 97
end

return t
