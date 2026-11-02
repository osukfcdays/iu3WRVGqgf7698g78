local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Finisher_m = require(ReplicatedStorage.Modules.Finisher)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local t = setmetatable({}, Finisher_m)
t.__index = t

function t.new(...) -- line: 9
    -- upvalues:
    --  [1] Finisher_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(Finisher_m.new(...), t)
    t_1:_Init()

    return t_1
end

function t.PlayClient(arg1) -- line: 21
    -- upvalues:
    --  [1] Utility_m (copy)

    arg1:_HideBody()
    local v2 = arg1._is_humanoid and arg1._subject.RootPart or arg1._subject

    if not v2 then
        return
    end

    local v3 = script.Particles.Attachment:Clone()
    v3.Parent = v2
    table.insert(arg1._destroy_these, v3)
    Utility_m:PlayParticles(v3)
    arg1:CreateSound(
        "rbxassetid://130069209812509",
        1,
        1 + 0.1 * math.random(),
        nil,
        true,
        5
    )
    arg1:CreateSound(
        "rbxassetid://82341777410026",
        1.5,
        1 + 0.1 * math.random(),
        nil,
        true,
        5
    )
    arg1:CreateSound(
        "rbxassetid://74282442822962",
        1,
        1 + 0.1 * math.random(),
        nil,
        true,
        5
    )
end

function t._Init(_) -- line: 44
end

return t
