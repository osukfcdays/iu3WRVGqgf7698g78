local ReplicatedStorage = game:GetService("ReplicatedStorage")
local _ = require(ReplicatedStorage.Modules.Utility)
local Emote_m = require(ReplicatedStorage.Modules.Emote)
local t = setmetatable({}, Emote_m)
t.__index = t

function t.new(...) -- line: 12
    -- upvalues:
    --  [1] Emote_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(Emote_m.new(2.15, script.Name, ...), t)
    t_1:_Init()

    return t_1
end

function t.PlayClient(arg1, ...) -- line: 24
    -- upvalues:
    --  [1] Emote_m (copy)

    Emote_m.PlayClient(arg1, ...)
    local _ = arg1:_SetupProp(script.CakeProp)
    arg1:_PlayAnimation("rbxassetid://100896527733090")
    wait(1.2)
    arg1:CreateSound(
        "rbxassetid://18128895977",
        1.25,
        1,
        nil,
        true,
        5
    )
    arg1:CreateSound(
        "rbxassetid://99386279085681",
        1.25,
        1,
        nil,
        true,
        5
    )
end

function t._Init(_) -- line: 38
end

return t
