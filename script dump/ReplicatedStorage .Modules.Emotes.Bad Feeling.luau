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
    arg1:_PlayAnimation("rbxassetid://113081315310439", "rbxassetid://105533660677821", 1.3)
    local v2 = script.Part.Attachment:Clone()
    v2.Name = "BadFeeling"
    v2.Parent = arg1._humanoid.Parent:FindFirstChild("Head")
    table.insert(arg1._destroy_these, v2)
    arg1:CreateSound(
        "rbxassetid://104971481474038",
        0.75,
        1,
        nil,
        true
    ).Looped = true
end

function t._Init(_) -- line: 41
end

return t
