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

function t.PlayClient(arg1) -- line: 21
    -- upvalues:
    --  [1] Utility_m (copy)

    arg1:_HideBody()
    local v2 = arg1._is_humanoid and arg1._subject.RootPart or arg1._subject
    local v3 = script.Particles:Clone()
    v3.CFrame = v2.CFrame
    v3.Parent = workspace
    table.insert(arg1._destroy_these, v3)
    Utility_m:PlayParticles(v3)
    arg1:CreateSound(
        "rbxassetid://91581971640099",
        1,
        1,
        nil,
        true,
        5
    )
    arg1:CreateSound(
        "rbxassetid://90656022565955",
        1.5,
        1,
        nil,
        true,
        5
    )
    arg1:CreateSound(
        "rbxassetid://108364426842582",
        1.5,
        1,
        nil,
        true,
        5
    )
    wait(3)
end

function t._Init(_) -- line: 44
end

return t
