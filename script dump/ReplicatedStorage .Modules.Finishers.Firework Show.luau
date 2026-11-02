local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Ragdoll_m = require(ReplicatedStorage.Modules.Finishers.Ragdoll)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local t = setmetatable({}, Ragdoll_m)
t.__index = t

function t.new(...) -- line: 15
    -- upvalues:
    --  [1] Ragdoll_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(Ragdoll_m.new(...), t)
    t_1:_Init()

    return t_1
end

function t.PlayServer(arg1) -- line: 27
    -- upvalues:
    --  [1] Ragdoll_m (copy)
    --  [2] RunService (copy)

    Ragdoll_m.PlayServer(arg1)

    if not arg1._is_humanoid then
        return
    end

    arg1:_AnchorModel(0, false)
    local RootPart = arg1._subject.RootPart
    local BodyVelocity = Instance.new("BodyVelocity")
    BodyVelocity.MaxForce = Vector3.new(100000, 100000, 100000)
    BodyVelocity.Velocity = Vector3.new(0, 64, 0)
    BodyVelocity.Parent = RootPart
    table.insert(arg1._destroy_these, BodyVelocity)
    wait(0.5)
    local now = tick()

    while true do
        if not (tick() < now + 0.75) then
            break
        end

        local clampedValue = math.clamp((tick() - now) / 0.75, 0, 1)
        BodyVelocity.Velocity = (CFrame.new(Vector3.new(0, 0, 0), Vector3.new(0, 1, 0)) * CFrame.Angles(
            6.283185307179586 * clampedValue,
            0,
            0
        )).LookVector * 64
        RunService.Heartbeat:Wait()
    end

    BodyVelocity.Velocity = Vector3.new(0, 64, 0)
    wait(1)
    BodyVelocity:Destroy()
    RootPart.Velocity = Vector3.new(0, 64, 0) + Vector3.new(
        math.random() - 0.5,
        0,
        math.random() - 0.5
    ) * 64 * 0.1
    arg1:_AnchorModel()
end

function t.PlayClient(arg2) -- line: 66
    -- upvalues:
    --  [1] Ragdoll_m (copy)
    --  [2] Utility_m (copy)

    Ragdoll_m.PlayClient(arg2)

    if not arg2._is_humanoid then
        return
    end

    local RootPart_1 = arg2._subject.RootPart
    local t_2 = {}

    for _, val in pairs(script.Trail:GetChildren()) do
        local v4 = val:Clone()
        v4.Parent = RootPart_1
        table.insert(arg2._destroy_these, v4)
        table.insert(t_2, v4)
    end

    arg2:CreateSound(
        "rbxassetid://108099224793848",
        1.25,
        1 + 0.1 * math.random(),
        nil,
        true,
        5
    )
    wait(2.25)

    for _, val_1 in pairs(t_2) do
        if val_1:IsA("ParticleEmitter") then
            val_1.Enabled = false
        end

        for _, val_2 in pairs(val_1:GetDescendants()) do
            if val_2:IsA("ParticleEmitter") then
                val_2.Enabled = false
            end
        end
    end

    local v7 = script.Explode.Attachment:Clone()
    v7.Parent = RootPart_1
    Utility_m:PlayParticles(v7)
    table.insert(arg2._destroy_these, v7)
    arg2:CreateSound(
        "rbxassetid://133816595599115",
        1.5,
        1 + 0.1 * math.random(),
        nil,
        true,
        5
    )
end

function t._Init(_) -- line: 111
end

return t
