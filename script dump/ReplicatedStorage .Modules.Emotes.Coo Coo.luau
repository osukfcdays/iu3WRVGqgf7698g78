local Emote_m = require(game:GetService("ReplicatedStorage").Modules.Emote)
local t = setmetatable({}, Emote_m)
t.__index = t

function t.new(...) -- line: 11
    -- upvalues:
    --  [1] Emote_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(Emote_m.new(4.25, script.Name, ...), t)
    t_1:_Init()

    return t_1
end

function t.PlayClient(arg1, ...) -- line: 23
    -- upvalues:
    --  [1] Emote_m (copy)

    Emote_m.PlayClient(arg1, ...)
    arg1:_PlayAnimation("rbxassetid://125921589993721")
    wait(0.4)
    arg1:CreateSound(
        "rbxassetid://134218301690577",
        0.5,
        1 + 0.1 * math.random(),
        nil,
        true,
        5
    )
    arg1:CreateSound(
        "rbxassetid://71288358864209",
        1,
        1 + 0.1 * math.random(),
        nil,
        true,
        5
    )
end

function t._Init(_) -- line: 36
end

return t
