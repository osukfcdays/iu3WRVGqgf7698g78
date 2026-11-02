local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local BetterDebris_m = require(ReplicatedStorage.Modules.BetterDebris)
local Ragdoll_m = require(ReplicatedStorage.Modules.Finishers.Ragdoll)
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

function t.PlayServer(arg1, ...) -- line: 25
    -- upvalues:
    --  [1] Ragdoll_m (copy)
    --  [2] BetterDebris_m (copy)

    Ragdoll_m.PlayServer(arg1, ...)
    local v2 = arg1._is_humanoid and arg1._subject.RootPart or arg1._subject
    local BodyVelocity = Instance.new("BodyVelocity")
    BodyVelocity.MaxForce = Vector3.new(1000000, 1000000, 1000000)
    local v3 = CFrame.new(Vector3.new(0, 0, 0), Vector3.new(0, 1, 0)) * CFrame.Angles(
        0,
        0,
        math.random() * 3.141592653589793 * 2
    )
    BodyVelocity.Velocity = (v3 * CFrame.Angles(0, 0.7853981633974483 * (math.random() - 0.5), 0)).LookVector * 100
    BodyVelocity.Parent = v2
    BetterDebris_m:AddItem(BodyVelocity, 0.25)
end

function t.PlayClient(arg2, ...) -- line: 37
    -- upvalues:
    --  [1] Ragdoll_m (copy)
    --  [2] RunService (copy)

    Ragdoll_m.PlayClient(arg2, ...)
    local v4 = arg2._is_humanoid and arg2._subject.RootPart or arg2._subject
    local v5 = arg2._is_humanoid and arg2._subject.Parent.Head or arg2._subject
    local v6 = script.Particles:Clone()
    v6.CollisionGroup = "IgnorePlayers"
    local cframe_1 = CFrame.new(v4.Position)
    v6.CFrame = cframe_1 * CFrame.Angles(-1.5707963267948966, 0, 0) - Vector3.new(0, 3, 0)
    v6.Parent = workspace
    table.insert(arg2._destroy_these, v6)
    local v7 = 0
    v4 = tick()
    local v8 = nil
    local RenderSteppedConnection = RunService.RenderStepped:Connect(function(deltaTime: number) -- line: 53
        -- upvalues:
        --  [1] v7 (ref)
        --  [2] v6 (copy)
        --  [3] v8 (ref)
        --  [4] v4 (copy)
        --  [5] v5 (copy)

        v7 += deltaTime
        v6.Finish.Puddle.Size = NumberSequence.new(v7 * 5 + 1)

        if v8 then
            local Position = v8.Position
            local Unit = (v6.Finish.WorldPosition - v8.Position).Unit
            local Start = v6.Start
            local cframe_2 = CFrame.new(
                Position + Unit * math.clamp(
                    (tick() - v4 - 0.5) * 64,
                    0,
                    (v6.Finish.WorldPosition - v8.Position).Magnitude
                )
            )
            Start.WorldCFrame = cframe_2 * v8.Rotation

            return
        end

        v6.Start.WorldCFrame = v5.CFrame
    end)
    table.insert(arg2._connections, RenderSteppedConnection)
    arg2:CreateSound(
        "rbxassetid://93843878451088",
        1.5,
        1,
        nil,
        true,
        5
    )
    arg2:CreateSound(
        "rbxassetid://108905869931161",
        2,
        1,
        nil,
        true,
        5
    )
    wait(0.5)
    v8 = v5.CFrame
    wait((v8.Position - v6.Finish.WorldPosition).Magnitude / 64)
    RenderSteppedConnection:Disconnect()

    for _, descendant in pairs(v6:GetDescendants()) do
        if descendant:IsA("ParticleEmitter") or descendant:IsA("Beam") then
            local v10 = descendant.Name == "Puddle"
            descendant.Enabled = v10
        end
    end

    wait(2)
    v6.Finish.Puddle.Enabled = false
    wait(3)
end

function t._Init(_) -- line: 98
end

return t
