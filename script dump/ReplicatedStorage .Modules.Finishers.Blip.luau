local ReplicatedStorage = game:GetService("ReplicatedStorage")
local BetterDebris_m = require(ReplicatedStorage.Modules.BetterDebris)
local Ragdoll_m = require(ReplicatedStorage.Modules.Finishers.Ragdoll)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local t = setmetatable({}, Ragdoll_m)
t.__index = t

function t.new(...) -- line: 13
    -- upvalues:
    --  [1] Ragdoll_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(Ragdoll_m.new(...), t)
    t_1:_Init()

    return t_1
end

function t.PlayServer(arg1, ...) -- line: 25
    -- upvalues:
    --  [1] Ragdoll_m (copy)
    --  [2] Utility_m (copy)
    --  [3] BetterDebris_m (copy)

    Ragdoll_m.PlayServer(arg1, ...)

    if not arg1._is_humanoid then
        return
    end

    local v2 = script.Part:Clone()
    v2.CFrame = arg1._subject.RootPart.CFrame
    v2.Parent = workspace
    Utility_m:PlayParticles(v2)
    BetterDebris_m:AddItem(v2, 10)
    table.insert(arg1._destroy_these, v2)
    local v3 = Random.new():NextUnitVector()
    local v6 = (v3 * Vector3.new(1, 0, 1) + Vector3.new(0, 1, 0) * math.abs(v3.Y)) * (16 + 16 * math.random())
    local Position = arg1._subject.Parent:GetPivot().Position
    local raycastResult = Utility_m:Raycast(
        Position,
        Position + v6,
        v6.Magnitude,
        { arg1._subject.Parent },
        Enum.RaycastFilterType.Exclude
    )
    local Parent = arg1._subject.Parent
    local cframe = CFrame.new(raycastResult.Position)
    Parent:PivotTo(
        cframe * CFrame.Angles(
            math.random() * 3.141592653589793 * 2,
            math.random() * 3.141592653589793 * 2,
            math.random() * 3.141592653589793 * 2
        )
    )
end

function t.PlayClient(arg2, ...) -- line: 47
    -- upvalues:
    --  [1] Ragdoll_m (copy)

    arg2:CreateSound(
        "rbxassetid://77408061407414",
        1,
        1 + 0.1 * math.random(),
        nil,
        true,
        5
    )
    Ragdoll_m.PlayClient(arg2, ...)
end

function t._Init(_) -- line: 56
end

return t
