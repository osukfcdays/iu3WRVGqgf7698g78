local Emote_m = require(game:GetService("ReplicatedStorage").Modules.Emote)
local t = setmetatable({}, Emote_m)
t.__index = t

function t.new(...) -- line: 11
    -- upvalues:
    --  [1] Emote_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(Emote_m.new(2.25, script.Name, ...), t)
    t_1:_Init()

    return t_1
end

function t.PlayClient(arg1, ...) -- line: 23
    -- upvalues:
    --  [1] Emote_m (copy)

    Emote_m.PlayClient(arg1, ...)
    local _ = arg1:_SetupProp(script.Props)
    arg1:_PlayAnimation("rbxassetid://76947942879532")
    arg1:CreateSound(
        "rbxassetid://13456860578",
        1.25,
        1,
        nil,
        true,
        5
    )
    wait(1.6)
    arg1:CreateSound(
        "rbxassetid://133211885821177",
        1.5,
        1 + 0.2 * math.random(),
        nil,
        true,
        5
    )
end

function t._Init(_) -- line: 37
end

return t
