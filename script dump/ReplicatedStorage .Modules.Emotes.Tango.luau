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
    arg1:_PlayAnimation("rbxassetid://88145538779312", "rbxassetid://96300514550662", 1.2)
    arg1:CreateSound(
        "rbxassetid://139966463950646",
        1,
        1,
        nil,
        true
    ).Looped = true
    local v2 = arg1._humanoid

    if v2 then
        v2 = arg1._humanoid.Parent

        if v2 then
            v2 = arg1._humanoid.Parent:FindFirstChild("Head")
        end
    end

    local v3 = script.Rose:Clone()
    v3:PivotTo(v2.CFrame)
    v3.Parent = v2
    table.insert(arg1._destroy_these, v3)
    local WeldConstraint = Instance.new("WeldConstraint")
    WeldConstraint.Part0 = v2
    WeldConstraint.Part1 = v3.Primary
    WeldConstraint.Parent = v3
end

function t._Init(_) -- line: 46
end

return t
