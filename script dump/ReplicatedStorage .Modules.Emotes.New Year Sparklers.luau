local Emote_m = require(game:GetService("ReplicatedStorage").Modules.Emote)
local t = setmetatable({}, Emote_m)
t.__index = t

function t.new(...) -- line: 13
    -- upvalues:
    --  [1] Emote_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(Emote_m.new(nil, script.Name, ...), t)
    t_1:_Init()

    return t_1
end

function t.PlayClient(arg1, ...) -- line: 25
    -- upvalues:
    --  [1] Emote_m (copy)

    Emote_m.PlayClient(arg1, ...)
    arg1:_PlayAnimation("rbxassetid://93712852727557", "rbxassetid://97084758451290", 3.6)
    local v2 = arg1:_SetupMultipleProps(script.SparklersProp)
    wait(1.1)

    for _, descendant in pairs(v2.stick1:GetDescendants()) do
        if descendant:IsA("ParticleEmitter") or descendant:IsA("Trail") then
            descendant.Enabled = true
        end
    end

    arg1:CreateSound(
        "rbxassetid://15573552175",
        3,
        1 + 0.1 * math.random(),
        nil,
        true,
        5
    )
    arg1:CreateSound(
        "rbxassetid://75644699023746",
        1,
        1,
        nil,
        true
    ).Looped = true
    wait(1.65)

    for _, descendant_1 in pairs(v2.stick2:GetDescendants()) do
        if descendant_1:IsA("ParticleEmitter") or descendant_1:IsA("Trail") then
            descendant_1.Enabled = true
        end
    end

    arg1:CreateSound(
        "rbxassetid://15573552175",
        3,
        1 + 0.1 * math.random(),
        nil,
        true,
        5
    )
end

function t._Init(_) -- line: 57
end

return t
