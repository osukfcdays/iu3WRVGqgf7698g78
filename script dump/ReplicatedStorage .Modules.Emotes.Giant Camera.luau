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
    local _ = arg1:_SetupProp(script.CameraProp)
    arg1:_PlayAnimation("rbxassetid://73203002019666", "rbxassetid://81983459727703", 3.1)
    arg1:CreateSound(
        "rbxassetid://113889823753206",
        1,
        0.9 + 0.2 * math.random(),
        nil,
        true
    )
end

function t._Init(_) -- line: 36
end

return t
