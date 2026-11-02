local Emote_m = require(game:GetService("ReplicatedStorage").Modules.Emote)
local t = {
    "rbxassetid://72355887565329",
    "rbxassetid://85536457035481",
    "rbxassetid://74879924699654",
    "rbxassetid://72451632738218",
    "rbxassetid://131835698918357"
}
local t_1 = setmetatable({}, Emote_m)
t_1.__index = t_1

function t_1.new(...) -- line: 11
    -- upvalues:
    --  [1] Emote_m (copy)
    --  [2] t_1 (copy)

    local t_2 = setmetatable(Emote_m.new(nil, script.Name, ...), t_1)
    t_2:_Init()

    return t_2
end

function t_1.PlayClient(arg1, ...) -- line: 23
    -- upvalues:
    --  [1] Emote_m (copy)
    --  [2] t (copy)

    Emote_m.PlayClient(arg1, ...)
    arg1:_PlayAnimation(
        t[Random.new(arg1._seed):NextInteger(1, #t)],
        nil,
        nil,
        nil,
        8
    )
end

function t_1._Init(_) -- line: 32
end

return t_1
