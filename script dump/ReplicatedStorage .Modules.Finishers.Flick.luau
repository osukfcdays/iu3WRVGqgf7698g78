local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Ragdoll_m = require(ReplicatedStorage.Modules.Finishers.Ragdoll)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local Spring_m = require(ReplicatedStorage.Modules.Spring)
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

function t.PlayServer(arg1, ...) -- line: 27
    -- upvalues:
    --  [1] Ragdoll_m (copy)
    --  [2] Utility_m (copy)

    Ragdoll_m.PlayServer(arg1, ...)
    wait(1)
    local v2 = arg1._is_humanoid and arg1._subject.RootPart or arg1._subject
    local v3 = arg1:_GetKnockbackDirection() * 75
    Utility_m:Knockback(v2, v3)
end

function t.PlayClient(arg2, ...) -- line: 38
    -- upvalues:
    --  [1] Ragdoll_m (copy)
    --  [2] Spring_m (copy)
    --  [3] RunService (copy)
    --  [4] Utility_m (copy)

    Ragdoll_m.PlayClient(arg2, ...)
    local v4 = arg2._is_humanoid and arg2._subject.RootPart or arg2._subject
    local v5 = arg2:_GetKnockbackDirection()
    local v6 = script.Model:Clone()
    v6.Parent = arg2._subject
    table.insert(arg2._destroy_these, v6)
    local v7 = Spring_m.new(v4.Position + -v5 * Vector3.new(5, -5, 5) * 2, 1, 10)
    local now = tick()

    while true do
        if not (tick() < now + 1) then
            break
        end

        v7.Target = v4.Position + -v5 * Vector3.new(1, -1, 1)
        v6:PivotTo(
            CFrame.new(v7.Value) * CFrame.new(Vector3.new(0, 0, 0), v5 * Vector3.new(1, 0, 1))
        )
        RunService.RenderStepped:Wait()
    end

    arg2:CreateSound(
        "rbxassetid://120809068918800",
        1.25,
        1,
        nil,
        true,
        5
    )
    arg2:CreateSound(
        "rbxassetid://92760487729234",
        2.5,
        1,
        nil,
        true,
        5
    )
    v6.Before.Transparency = 1
    v6.After.Transparency = 0
    local v9 = v6.After.Size * 2
    local v10 = v5 * Vector3.new(1, 0, 1)
    local v11 = v6.After.CFrame
    local Size = v6.After.Size
    local absoluteValue = math.abs(v5.Y)
    local v12 = (v10 + Vector3.new(0, absoluteValue, 0)) * 2
    Utility_m:RenderstepForLoop(0, 100, 4, function(arg3) -- line: 68
        -- upvalues:
        --  [1] v6 (copy)
        --  [2] v9 (copy)
        --  [3] Size (copy)
        --  [4] v11 (copy)
        --  [5] v12 (copy)

        local v13 = 1 - (1 - arg3 / 100) ^ 3
        v6.After.Size = v9:Lerp(Size, v13)
        v6.After.CFrame = v11 + v12:Lerp(Vector3.new(0, 0, 0), v13)
    end)
    local v15 = v6.After.CFrame
    local v16 = v6.After.CFrame - Vector3.new(0, 10, 0)
    Utility_m:RenderstepForLoop(0, 100, 4, function(arg4) -- line: 78
        -- upvalues:
        --  [1] v6 (copy)
        --  [2] v15 (copy)
        --  [3] v16 (copy)

        v6.After.CFrame = v15:Lerp(v16, (arg4 / 100) ^ 3)
    end)
end

function t._GetKnockbackDirection(arg5) -- line: 89
    return (Random.new(arg5._serial and arg5._serial.Seed or arg5._seed):NextUnitVector() * Vector3.new(1, 0, 1) + Vector3.new(0, 1, 0)).Unit
end

function t._Init(_) -- line: 93
end

return t
