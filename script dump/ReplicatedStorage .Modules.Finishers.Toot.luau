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

function t.PlayClient(arg1, ...) -- line: 21
    -- upvalues:
    --  [1] Ragdoll_m (copy)
    --  [2] Utility_m (copy)

    Ragdoll_m.PlayClient(arg1, ...)
    wait(0.75)
    local v2 = script.Particles.Attachment:Clone()
    v2.Parent = arg1._is_humanoid and arg1._subject.Parent.LowerTorso or arg1._subject
    table.insert(arg1._destroy_these, v2)
    Utility_m:PlayParticles(v2)
    arg1:CreateSound(
        "rbxassetid://16924073325",
        1,
        1 + 0.2 * math.random(),
        nil,
        true,
        5
    )
end

function t._Init(_) -- line: 39
end

return t
