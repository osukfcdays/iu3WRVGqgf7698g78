local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local BetterDebris_m = require(ReplicatedStorage.Modules.BetterDebris)
local Ragdoll_m = require(ReplicatedStorage.Modules.Finishers.Ragdoll)
local t = setmetatable({}, Ragdoll_m)
t.__index = t

function t.new(...) -- line: 10
    -- upvalues:
    --  [1] Ragdoll_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(Ragdoll_m.new(...), t)
    t_1:_Init()

    return t_1
end

function t.PlayServer(arg1, ...) -- line: 22
    -- upvalues:
    --  [1] Ragdoll_m (copy)
    --  [2] BetterDebris_m (copy)

    Ragdoll_m.PlayServer(arg1, ...)
    local BodyVelocity = Instance.new("BodyVelocity")
    BodyVelocity.MaxForce = Vector3.new(0, 10000, 0)
    BodyVelocity.Velocity = Vector3.new(0, -100, 0)
    BodyVelocity.Parent = arg1._is_humanoid and arg1._subject.RootPart or arg1._subject
    BetterDebris_m:AddItem(BodyVelocity, 3)
end

function t.PlayClient(arg2, ...) -- line: 32
    -- upvalues:
    --  [1] Ragdoll_m (copy)
    --  [2] RunService (copy)

    Ragdoll_m.PlayClient(arg2, ...)
    local v3 = arg2._is_humanoid and arg2._subject.RootPart or arg2._subject
    local v4 = script.Particles:Clone()
    v4.Parent = v3
    table.insert(arg2._destroy_these, v4)
    local RenderSteppedConnection = RunService.RenderStepped:Connect(function() -- line: 41
        -- upvalues:
        --  [1] v4 (copy)
        --  [2] v3 (copy)

        v4.CFrame = CFrame.new(v3.Position)
    end)
    table.insert(arg2._connections, RenderSteppedConnection)
    arg2:CreateSound(
        "rbxassetid://71853893910123",
        2,
        1,
        nil,
        true,
        5
    )
    wait(3)
    RenderSteppedConnection:Disconnect()

    for _, descendant in pairs(v4:GetDescendants()) do
        if descendant:IsA("ParticleEmitter") or descendant:IsA("Beam") then
            descendant.Enabled = false
        end
    end
end

function t._Init(_) -- line: 64
end

return t
