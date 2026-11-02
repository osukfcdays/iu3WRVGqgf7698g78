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
    local _ = arg1:_SetupProp(script.HorseProp)
    arg1:_PlayAnimation("rbxassetid://90957073891780", "rbxassetid://131785768380910", 4.45)
    arg1:CreateSound(
        "rbxassetid://119722200205656",
        1,
        1,
        nil,
        true
    )
    arg1:CreateSound(
        "rbxassetid://100899302728675",
        0.5,
        1,
        nil,
        true
    ).Looped = true
end

function t._Init(_) -- line: 37
end

return t
