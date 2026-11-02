local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Ragdoll_m = require(ReplicatedStorage.Modules.Finishers.Ragdoll)
local Spring_m = require(ReplicatedStorage.Modules.Spring)
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

function t.PlayClient(arg1, ...) -- line: 22
    -- upvalues:
    --  [1] Ragdoll_m (copy)
    --  [2] Spring_m (copy)
    --  [3] RunService (copy)

    Ragdoll_m.PlayClient(arg1, ...)
    local v2 = arg1._is_humanoid and arg1._subject.RootPart or arg1._subject
    local v3 = script.Model:Clone()
    v3.Parent = arg1._subject
    table.insert(arg1._destroy_these, v3)
    local v4 = arg1:_GetObjects(true)
    local v5 = Spring_m.new(v2.Position, 1, 2)
    local t_2 = {}
    local now = tick()
    table.insert(arg1._connections, RunService.RenderStepped:Connect(function() -- line: 36
        -- upvalues:
        --  [1] v5 (copy)
        --  [2] arg1 (copy)
        --  [3] v2 (copy)
        --  [4] v4 (copy)
        --  [5] v3 (copy)
        --  [6] now (copy)
        --  [7] t_2 (copy)

        v5.Target = arg1:_GetGroundPosition(v2.Position, v4) + Vector3.new(0, 0.01, 0)
        v3:PivotTo(CFrame.new(v5.Value.X, v5.Target.Y, v5.Value.Z))
        local clampedValue = math.clamp((tick() - now) / 4, 0, 1)
        local clampedValue_1 = math.clamp(clampedValue * 2, 0, 1)
        local clampedValue_2 = math.clamp(clampedValue * 2 - 1, 0, 1)

        for _, val in pairs(arg1:_GetObjects(true)) do
            if val:IsA("BasePart") then
                local v9 = t_2[val]
                local v10 = t_2
                v9 = v9 or val.Color
                v10[val] = v9
                val.Material = Enum.Material.Glass
                val.MaterialVariant = ""
                val.Color = t_2[val]:Lerp(Color3.fromRGB(143, 76, 42), clampedValue_1):Lerp(
                    Color3.fromRGB(61, 32, 18),
                    clampedValue_2
                )
            end
        end
    end))
    local v15 = 1 + 0.1 * math.random()
    arg1:CreateSound(
        "rbxassetid://120630457366669",
        1,
        v15,
        nil,
        true,
        10
    )
    local v16 = 1 + 0.1 * math.random()
    arg1:CreateSound(
        "rbxassetid://126523239993274",
        0.75,
        v16,
        nil,
        true,
        10
    )
end

function t._Init(_) -- line: 62
end

return t
