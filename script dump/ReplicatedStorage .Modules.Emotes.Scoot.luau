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
    local _ = arg1:_SetupProp(script.ScooterProp)
    arg1:_PlayAnimation("rbxassetid://95363177241235", "rbxassetid://79488716810610", 2.5)
    arg1:CreateSound(
        "rbxassetid://140276633173520",
        1,
        1,
        nil,
        true
    ).Looped = true
end

function t._Init(_) -- line: 36
end

return t
