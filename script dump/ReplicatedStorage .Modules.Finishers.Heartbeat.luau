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
    local v2 = script.Particles.Attachment:Clone()
    v2.Parent = arg1._is_humanoid and arg1._subject.Parent.UpperTorso or arg1._subject
    table.insert(arg1._destroy_these, v2)

    for _, child in pairs(v2:GetChildren()) do
        if child:IsA("ParticleEmitter") then
            Utility_m:ScaleParticleEmitter(child, 0.25)
        end
    end

    Utility_m:PlayParticles(v2)
    wait(0.5)

    for index = 1, 3 do
        arg1:CreateSound(
            "rbxassetid://127325407221199",
            1.5 - index * 0.25,
            1,
            nil,
            true,
            5
        )
        wait(0.9)
    end

    arg1:CreateSound(
        "rbxassetid://106567630436220",
        0.75,
        1,
        nil,
        true,
        5
    )
end

function t._Init(_) -- line: 51
end

return t
