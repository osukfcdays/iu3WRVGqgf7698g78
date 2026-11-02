local Ragdoll_m = require(game:GetService("ReplicatedStorage").Modules.Finishers.Ragdoll)
local t = setmetatable({}, Ragdoll_m)
t.__index = t

function t.new(...) -- line: 8
    -- upvalues:
    --  [1] Ragdoll_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(Ragdoll_m.new(...), t)
    t_1:_Init()

    return t_1
end

function t.PlayServer(arg1, ...) -- line: 20
    -- upvalues:
    --  [1] Ragdoll_m (copy)

    Ragdoll_m.PlayServer(arg1, ...)

    if not arg1._is_humanoid then
        return
    end

    arg1._subject.Parent:ScaleTo(arg1._subject.Parent:GetScale() * 0.5)
end

function t.PlayClient(arg2, ...) -- line: 30
    -- upvalues:
    --  [1] Ragdoll_m (copy)

    Ragdoll_m.PlayClient(arg2, ...)
    arg2:CreateSound(
        "rbxassetid://84840803158340",
        1.5,
        1 + 0.1 * math.random(),
        nil,
        true,
        5
    )
    local v4 = arg2._is_humanoid

    if v4 then
        v4 = arg2._subject.Parent:FindFirstChild("Head")
    end

    if not v4 then
        return
    end

    local v5 = script.Model:Clone()
    v5.PrimaryPart = v5.Primary
    v5:PivotTo(v4.CFrame)
    v5:ScaleTo(v5:GetScale() * v4.Size.Y / 1)
    v5.Parent = v4
    table.insert(arg2._destroy_these, v5)
    local WeldConstraint = Instance.new("WeldConstraint")
    WeldConstraint.Part0 = v4
    WeldConstraint.Part1 = v5.Primary
    WeldConstraint.Parent = v5
end

function t._Init(_) -- line: 58
end

return t
