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
    local t_2 = {}

    for _, child in pairs(script.Particles:GetChildren()) do
        local v3 = child:Clone()
        local v4 = arg1._is_humanoid and arg1._subject.RootPart or arg1._subject
        v3.Parent = v4
        table.insert(arg1._destroy_these, v3)
        table.insert(t_2, v3)
    end

    Utility_m:PlayParticles(t_2)
    arg1:CreateSound(
        "rbxassetid://123015928077499",
        1.25,
        1 + 0.1 * math.random(),
        nil,
        true,
        5
    )
end

function t._Init(_) -- line: 42
end

return t
