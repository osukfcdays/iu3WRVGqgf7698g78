local Emote_m = require(game:GetService("ReplicatedStorage").Modules.Emote)
local t = setmetatable({}, Emote_m)
t.__index = t

function t.new(...) -- line: 11
    -- upvalues:
    --  [1] Emote_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(Emote_m.new(6.2, script.Name, ...), t)
    t_1:_Init()

    return t_1
end

function t.PlayClient(arg1, ...) -- line: 23
    -- upvalues:
    --  [1] Emote_m (copy)

    Emote_m.PlayClient(arg1, ...)
    arg1:_PlayAnimation("rbxassetid://137924113002985")
    local v2 = arg1:_SetupMultipleProps(script.ItsTimeProp)
    wait(1.9)
    arg1:CreateSound(
        "rbxassetid://85464929329408",
        1,
        0.8 + 0.1 * math.random(),
        nil,
        true,
        5
    )
    wait(0.65)
    arg1:CreateSound(
        "rbxassetid://85464929329408",
        1,
        0.9 + 0.1 * math.random(),
        nil,
        true,
        5
    )
    wait(0.55)
    arg1:CreateSound(
        "rbxassetid://85464929329408",
        1,
        1 + 0.1 * math.random(),
        nil,
        true,
        5
    )
    wait(0.35)
    arg1:CreateSound(
        "rbxassetid://135970869546121",
        1.25,
        1 + 0.1 * math.random(),
        nil,
        true,
        5
    )
    wait(0.55)

    for _, val in pairs(v2) do
        val.LocalTransparencyModifier = 1
    end
end

function t._Init(_) -- line: 55
end

return t
