local Emote_m = require(game:GetService("ReplicatedStorage").Modules.Emote)
local t = setmetatable({}, Emote_m)
t.__index = t

function t.new(...) -- line: 11
    -- upvalues:
    --  [1] Emote_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(Emote_m.new(3.85, script.Name, ...), t)
    t_1:_Init()

    return t_1
end

function t.PlayClient(arg1, ...) -- line: 23
    -- upvalues:
    --  [1] Emote_m (copy)

    Emote_m.PlayClient(arg1, ...)
    arg1:_PlayAnimation("rbxassetid://119282539520778")
    wait(0.4)
    arg1:CreateSound(
        "rbxassetid://79768694812211",
        0.8,
        0.9,
        nil,
        true,
        5
    )
    wait(0.6)
    arg1:CreateSound(
        "rbxassetid://79768694812211",
        1,
        1.1,
        nil,
        true,
        5
    )
    wait(0.95)
    arg1:CreateSound(
        "rbxassetid://79768694812211",
        0.8,
        0.8,
        nil,
        true,
        5
    )
    wait(0.4)
    arg1:CreateSound(
        "rbxassetid://79768694812211",
        1,
        1,
        nil,
        true,
        5
    )
end

function t._Init(_) -- line: 41
end

return t
