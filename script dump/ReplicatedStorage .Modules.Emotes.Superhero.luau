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
    arg1:_PlayAnimation("rbxassetid://115000869501227", "rbxassetid://83376670167687", 4.15)
    arg1:CreateSound(
        "rbxassetid://80133530921906",
        1.5,
        1,
        nil,
        true
    )
    wait(15.54)
    arg1:CreateSound(
        "rbxassetid://98970356172671",
        1.5,
        1,
        nil,
        true
    ).Looped = true
end

function t._Init(_) -- line: 38
end

return t
