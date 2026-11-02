local Emote_m = require(game:GetService("ReplicatedStorage").Modules.Emote)
local t = setmetatable({}, Emote_m)
t.__index = t

function t.new(...) -- line: 11
    -- upvalues:
    --  [1] Emote_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(Emote_m.new(1.75, script.Name, ...), t)
    t_1:_Init()

    return t_1
end

function t.PlayClient(arg1, ...) -- line: 23
    -- upvalues:
    --  [1] Emote_m (copy)

    Emote_m.PlayClient(arg1, ...)
    arg1:_PlayAnimation("rbxassetid://81555757574094")
    arg1:CreateSound(
        "rbxassetid://75485128790168",
        1,
        1 + 0.1 * math.random(),
        nil,
        true,
        5
    )
    wait(0.4)
    arg1:CreateSound(
        "rbxassetid://13158735106",
        1,
        1.2,
        nil,
        true,
        5
    )
    wait(0.2)
    arg1:CreateSound(
        "rbxassetid://13158735106",
        1,
        1,
        nil,
        true,
        5
    )
    wait(0.2)
    arg1:CreateSound(
        "rbxassetid://13158735106",
        1,
        1.3,
        nil,
        true,
        5
    )
end

function t._Init(_) -- line: 40
end

return t
