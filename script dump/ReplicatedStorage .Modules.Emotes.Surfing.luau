local ReplicatedStorage = game:GetService("ReplicatedStorage")
local _ = require(ReplicatedStorage.Modules.Utility)
local Emote_m = require(ReplicatedStorage.Modules.Emote)
local t = setmetatable({}, Emote_m)
t.__index = t

function t.new(...) -- line: 14
    -- upvalues:
    --  [1] Emote_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(Emote_m.new(nil, script.Name, ...), t)
    t_1:_Init()

    return t_1
end

function t.PlayClient(arg1, ...) -- line: 26
    -- upvalues:
    --  [1] Emote_m (copy)

    Emote_m.PlayClient(arg1, ...)
    local _ = arg1:_SetupProp(script.SurfProp)
    arg1:_PlayAnimation("rbxassetid://126498832296593", "rbxassetid://88575062377123", 4)
    arg1:CreateSound(
        "rbxassetid://108806529299457",
        1,
        1 + 0.05 * math.random(),
        nil,
        true
    )
    arg1:CreateSound(
        "rbxassetid://137714378265704",
        1,
        1,
        nil,
        true
    ).Looped = true
end

function t._Init(_) -- line: 38
end

return t
