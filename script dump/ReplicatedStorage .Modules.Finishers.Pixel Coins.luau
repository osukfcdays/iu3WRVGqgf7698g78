local Finisher_m = require(game:GetService("ReplicatedStorage").Modules.Finisher)
local t = setmetatable({}, Finisher_m)
t.__index = t

function t.new(...) -- line: 8
    -- upvalues:
    --  [1] Finisher_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(Finisher_m.new(...), t)
    t_1:_Init()

    return t_1
end

function t.PlayServer(arg1) -- line: 20
    arg1:_AnchorModel(0)
end

function t.PlayClient(arg2) -- line: 24
    local Position = (arg2._is_humanoid and arg2._subject.RootPart or arg2._subject).Position
    local v3 = arg2._is_humanoid and arg2._subject.Parent or arg2._subject
    local Parent = v3.Parent
    arg2:CreateSound(
        "rbxassetid://111721022295307",
        1.25,
        0.95 + 0.1 * math.random(),
        Position,
        true,
        10
    )

    for _ = 1, 6 do
        v3.Parent = Parent
        wait(0.07)
        v3.Parent = nil
        wait(0.07)
    end

    arg2:CreateSound(
        "rbxassetid://122871435090543",
        1.5,
        0.9 + 0.2 * math.random(),
        Position,
        true,
        10
    )
    arg2:CreateSound(
        "rbxassetid://11188024605",
        1,
        0.9 + 0.2 * math.random(),
        Position,
        true,
        10
    )
    local v7 = script.Model:Clone()
    v7:PivotTo(CFrame.new(Position) * CFrame.Angles(0, math.random() * 3.141592653589793 * 2, 0))
    v7.Parent = workspace
    table.insert(arg2._destroy_these, v7)
    local Success, Result = pcall(
        v7.AnimationController.LoadAnimation,
        v7.AnimationController,
        v7.Animation
    )

    if Success then
        Result:Play(0)

        if Result.IsPlaying then
            Result.Stopped:Wait()
        end
    end

    v7:Destroy()
end

function t._Init(_) -- line: 66
end

return t
