local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Ragdoll_m = require(ReplicatedStorage.Modules.Finishers.Ragdoll)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
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

function t.PlayServer(arg1, ...) -- line: 21
    -- upvalues:
    --  [1] Ragdoll_m (copy)
    --  [2] Utility_m (copy)

    Ragdoll_m.PlayServer(arg1, ...)
    local v2 = arg1._is_humanoid and arg1._subject.Parent.Head or arg1._subject
    local v3 = Random.new():NextUnitVector() * Vector3.new(1, 0, 1) * 50 + Vector3.new(0, 25, 0)
    Utility_m:Knockback(v2, v3)
    arg1:CreateSound(
        "rbxassetid://127579435864391",
        1,
        1.5 + 0.25 * math.random(),
        nil,
        true,
        5
    )
end

function t._Init(_) -- line: 36
end

return t
