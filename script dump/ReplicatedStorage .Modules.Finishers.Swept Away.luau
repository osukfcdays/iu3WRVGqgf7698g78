local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Ragdoll_m = require(ReplicatedStorage.Modules.Finishers.Ragdoll)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
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
    --  [2] Utility_m (copy)

    Ragdoll_m.PlayServer(arg1, ...)
    wait(0.5)
    local v2 = arg1._is_humanoid and arg1._subject.RootPart or arg1._subject
    local v3 = (arg1:_GetKnockbackDirection() + Vector3.new(0, 0.25, 0)).Unit * 75
    Utility_m:Knockback(v2, v3)
end

function t.PlayClient(arg2, ...) -- line: 36
    -- upvalues:
    --  [1] Ragdoll_m (copy)
    --  [2] RunService (copy)

    Ragdoll_m.PlayClient(arg2, ...)
    local v4 = arg2._is_humanoid and arg2._subject.RootPart or arg2._subject
    local v5 = arg2:_GetGroundPosition(v4.Position, arg2:_GetObjects(true))
    local v6 = arg2:CreateSound(
        "rbxassetid://137714378265704",
        1,
        1,
        v4,
        true
    )

    if v6 then
        v6.Looped = true
    end

    local v7 = script.Model:Clone()
    v7.Parent = arg2._subject
    table.insert(arg2._destroy_these, v7)
    local t_2 = {}

    for _, descendant in pairs(v7:GetDescendants()) do
        if descendant:IsA("BasePart") or descendant:IsA("ParticleEmitter") or descendant:IsA("Beam") then
            table.insert(t_2, descendant)
        end
    end

    local Position_1 = nil
    local v10 = arg2:_GetKnockbackDirection()
    local now = tick()
    local RenderSteppedConnection = RunService.RenderStepped:Connect(function() -- line: 64
        -- upvalues:
        --  [1] now (copy)
        --  [2] Position_1 (ref)
        --  [3] v4 (copy)
        --  [4] v7 (copy)
        --  [5] v5 (copy)
        --  [6] v10 (copy)
        --  [7] t_2 (copy)
        --  [8] v6 (copy)

        local clampedValue = math.clamp((tick() - now) / 1.5, 0, 1)
        local v11 = (1 - math.sin(3.141592653589793 * clampedValue)) ^ 10

        if not Position_1 or clampedValue < 0.4 then
            Position_1 = v4.Position
        end

        local v12 = v7
        local v14 = CFrame.new(Position_1.X, v5.Y, Position_1.Z) * CFrame.new(
            Vector3.new(0, 0, 0),
            -v10
        ).Rotation * CFrame.new(0, 0, clampedValue * 64 + -32)
        v12:PivotTo(v14 * CFrame.Angles(0, -1.5707963267948966, 0))
        local _ = v14 * CFrame.Angles(0, -1.5707963267948966, 0)

        for _, val in pairs(t_2) do
            val.LocalTransparencyModifier = v11
        end

        if v6 then
            v6.Volume = 1 - v11
        end
    end)
    table.insert(arg2._connections, RenderSteppedConnection)
    wait(0.75)
    arg2:CreateSound(
        "rbxassetid://108806529299457",
        1,
        1.25 + 0.25 * math.random(),
        v4,
        true
    )
    wait(0.75)
    RenderSteppedConnection:Disconnect()
    v7:Destroy()
end

function t._GetKnockbackDirection(arg3) -- line: 99
    return (Random.new(arg3._serial and arg3._serial.Seed or arg3._seed):NextUnitVector() * Vector3.new(1, 0, 1)).Unit
end

function t._Init(_) -- line: 103
end

return t
