local ReplicatedStorage = game:GetService("ReplicatedStorage")
local _ = require(ReplicatedStorage.Modules.Utility)
local Emote_m = require(ReplicatedStorage.Modules.Emote)
local t = setmetatable({}, Emote_m)
t.__index = t

function t.new(...) -- line: 12
    -- upvalues:
    --  [1] Emote_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(Emote_m.new(4.75, script.Name, ...), t)
    t_1:_Init()

    return t_1
end

function t.PlayClient(arg1, ...) -- line: 24
    -- upvalues:
    --  [1] Emote_m (copy)

    Emote_m.PlayClient(arg1, ...)
    local v2 = arg1:_SetupMultipleProps(script.ShovelProp)
    arg1:_PlayAnimation("rbxassetid://113838171758638")
    local children = script.Objects:GetChildren()
    local v5 = children[Random.new(arg1._serial and arg1._serial.Seed or arg1._seed):NextInteger(
        1,
        #script.Objects:GetChildren()
    )]:Clone()
    local v9 = v2.Item.CFrame * CFrame.Angles(
        math.random() * 3.141592653589793 * 2,
        math.random() * 3.141592653589793 * 2,
        math.random() * 3.141592653589793 * 2
    )
    v5:PivotTo(v9)
    v5.Parent = v2.Item

    for _, child in pairs(v5:GetChildren()) do
        child.CanCollide = false
        child.CanTouch = false
        child.CanQuery = false
        local WeldConstraint = Instance.new("WeldConstraint")
        WeldConstraint.Part0 = child
        WeldConstraint.Part1 = v2.Item
        WeldConstraint.Parent = child
        child.Anchored = false
    end

    arg1:CreateSound(
        "rbxassetid://109469242170265",
        0.5,
        1,
        nil,
        true,
        10
    )
    wait(0.55)
    arg1:CreateSound(
        "rbxassetid://121837464389656",
        1,
        1,
        nil,
        true,
        10
    )
    wait(0.35)
    arg1:CreateSound(
        "rbxassetid://83701499105576",
        1,
        1,
        nil,
        true,
        10
    )
    wait(0.6)
    arg1:CreateSound(
        "rbxassetid://83701499105576",
        0.9,
        1.1,
        nil,
        true,
        10
    )
    wait(0.6)
    arg1:CreateSound(
        "rbxassetid://83701499105576",
        0.8,
        1.2,
        nil,
        true,
        10
    )
end

function t._Init(_) -- line: 61
end

return t
