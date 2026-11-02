local Finisher_m = require(game:GetService("ReplicatedStorage").Modules.Finisher)
local t = setmetatable({}, Finisher_m)
t.__index = t

function t.new(...) -- line: 10
    -- upvalues:
    --  [1] Finisher_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(Finisher_m.new(...), t)
    t_1:_Init()

    return t_1
end

function t.PlayServer(arg1) -- line: 22
    if not arg1._is_humanoid then
        return
    end

    arg1:_AnchorModel(false, 0)
    local v2 = script.Model:Clone()
    v2:SetPrimaryPartCFrame(arg1._subject.RootPart.CFrame)
    v2.PrimaryPart.Anchored = true
    v2.Parent = arg1._subject
    table.insert(arg1._destroy_these, v2)
    local WeldConstraint = Instance.new("WeldConstraint")
    WeldConstraint.Part0 = v2.PrimaryPart
    WeldConstraint.Part1 = arg1._subject.RootPart
    WeldConstraint.Parent = v2
    v2.PrimaryPart.Anchored = false
    local Animation = Instance.new("Animation")
    Animation.AnimationId = "rbxassetid://72904319869602"
    table.insert(arg1._destroy_these, Animation)
    local Success, Result = pcall(arg1._subject.LoadAnimation, arg1._subject, Animation)

    if Success then
        table.insert(arg1._destroy_these, Result)
        Result:Play(0)
    end

    arg1._subject.RootPart.Velocity = Random.new():NextUnitVector() * (24 + 8 * math.random())
    arg1._subject.RootPart.RotVelocity = Vector3.new(0, 1, 0) * (0 + 36 * math.random())
end

function t.PlayClient(arg2) -- line: 57
    if not arg2._is_humanoid then
        return
    end

    arg2:CreateSound(
        "rbxassetid://88366458741976",
        1,
        1 + 0.25 * math.random(),
        arg2._subject.RootPart,
        true,
        10
    )
end

function t._Init(_) -- line: 69
end

return t
