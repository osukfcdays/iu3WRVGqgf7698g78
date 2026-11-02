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
    arg1:_SetupProp(script.PortalProp)
    arg1:_PlayAnimation("rbxassetid://118879812674727", "rbxassetid://137721007241440", 2.45)
    wait(1.4)
    arg1:CreateSound(
        "rbxassetid://7127702569",
        1,
        1.2,
        nil,
        true,
        5
    )
end

function t._Init(_) -- line: 38
end

return t
