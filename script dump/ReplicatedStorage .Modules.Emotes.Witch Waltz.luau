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
    local _ = arg1:_SetupProp(script.BroomProp)
    arg1:_PlayAnimation("rbxassetid://111768394484614", "rbxassetid://92649987724159", 4.35)
    arg1:CreateSound(
        "rbxassetid://11169686206",
        0.75,
        1,
        nil,
        true,
        10
    )
end

function t._Init(_) -- line: 37
end

return t
