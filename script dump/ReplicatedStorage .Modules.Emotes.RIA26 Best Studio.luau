local ReplicatedStorage = game:GetService("ReplicatedStorage")
local _ = require(ReplicatedStorage.Modules.Utility)
local Emote_m = require(ReplicatedStorage.Modules.Emote)
local t = setmetatable({}, Emote_m)
t.__index = t

function t.new(...) -- line: 12
    -- upvalues:
    --  [1] Emote_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(Emote_m.new(7.4, script.Name, ...), t)
    t_1:_Init()

    return t_1
end

function t.PlayClient(arg1, ...) -- line: 24
    -- upvalues:
    --  [1] Emote_m (copy)

    Emote_m.PlayClient(arg1, ...)
    local _ = arg1:_SetupProp(script.AwardProp)
    arg1:_PlayAnimation("rbxassetid://84334527267845")
    arg1:CreateSound(
        "rbxassetid://82968610908198",
        1,
        0.95 + 0.1 * math.random(),
        nil,
        true,
        10
    )
end

function t._Init(_) -- line: 35
end

return t
