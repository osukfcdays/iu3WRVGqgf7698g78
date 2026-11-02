local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Ragdoll_m = require(ReplicatedStorage.Modules.Finishers.Ragdoll)
local t = setmetatable({}, Ragdoll_m)
t.__index = t

function t.new(...) -- line: 9
    -- upvalues:
    --  [1] Ragdoll_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(Ragdoll_m.new(...), t)
    t_1:_Init()

    return t_1
end

function t.PlayClient(arg1, ...) -- line: 21
    -- upvalues:
    --  [1] Ragdoll_m (copy)
    --  [2] RunService (copy)

    Ragdoll_m.PlayClient(arg1, ...)
    local v2 = arg1._is_humanoid and arg1._subject.RootPart or arg1._subject
    local v3 = script.Model:Clone()
    v3.Parent = v2
    table.insert(arg1._destroy_these, v3)
    local t_2 = {
        v3.heavenRays.dots1,
        v3.heavenRays.Enabled.rays1,
        v3.heavenRays.Enabled.rays2,
        v3.heavenRays.Enabled.rays3
    }
    local now = tick()
    table.insert(arg1._connections, RunService.RenderStepped:Connect(function() -- line: 33
        -- upvalues:
        --  [1] v3 (copy)
        --  [2] v2 (copy)
        --  [3] t_2 (copy)
        --  [4] now (copy)

        v3:PivotTo(CFrame.new(v2.Position))
        local _ = CFrame.new(v2.Position)

        for _, val in pairs(t_2) do
            val.LocalTransparencyModifier = 1 - math.clamp((tick() - now) / 2, 0, 1) ^ 3
        end
    end))
    arg1:CreateSound(
        "rbxassetid://122372195490308",
        1.25,
        0.95 + 0.1 * math.random(),
        v2,
        true,
        10
    )
end

function t._Init(_) -- line: 50
end

return t
