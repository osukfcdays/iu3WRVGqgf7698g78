local Emote_m = require(game:GetService("ReplicatedStorage").Modules.Emote)
local t = setmetatable({}, Emote_m)
t.__index = t

function t.new(...) -- line: 11
    -- upvalues:
    --  [1] Emote_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(Emote_m.new(2.1, script.Name, ...), t)
    t_1:_Init()

    return t_1
end

function t.PlayClient(arg1, ...) -- line: 23
    -- upvalues:
    --  [1] Emote_m (copy)

    Emote_m.PlayClient(arg1, ...)
    arg1:_PlayAnimation("rbxassetid://103862270973168")
    arg1:CreateSound(
        "rbxassetid://88377109323880",
        1,
        1 + 0.1 * math.random(),
        nil,
        true,
        5
    )
    wait(0.7)
    arg1:CreateSound(
        "rbxassetid://13160326139",
        1.25,
        1 + 0.1 * math.random(),
        nil,
        true,
        5
    )
end

function t._Init(_) -- line: 36
end

return t
