local ReplicatedStorage = game:GetService("ReplicatedStorage")
local _ = require(ReplicatedStorage.Modules.Utility)
local Emote_m = require(ReplicatedStorage.Modules.Emote)
local t = setmetatable({}, Emote_m)
t.__index = t

function t.new(...) -- line: 12
    -- upvalues:
    --  [1] Emote_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(Emote_m.new(2.75, script.Name, ...), t)
    t_1:_Init()

    return t_1
end

function t.PlayClient(arg1, ...) -- line: 24
    -- upvalues:
    --  [1] Emote_m (copy)

    Emote_m.PlayClient(arg1, ...)
    local _ = arg1:_SetupProp(script.BlockProp)
    arg1:_PlayAnimation("rbxassetid://95053547196006")
    wait(1.5)
    arg1:CreateSound(
        "rbxassetid://113804909921716",
        1,
        1,
        nil,
        true,
        5
    )
    wait(0.35)
    arg1:CreateSound(
        "rbxassetid://85894619049999",
        1,
        1,
        nil,
        true,
        5
    )
    arg1:CreateSound(
        "rbxassetid://79780131367448",
        1,
        1,
        nil,
        true,
        5
    )
end

function t._Init(_) -- line: 40
end

return t
