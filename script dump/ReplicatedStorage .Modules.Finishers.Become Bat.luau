local Finisher_m = require(game:GetService("ReplicatedStorage").Modules.Finisher)
local t = { 0.542, 0.867, 1.117, 1.383, 1.691, 2, 2.275, 2.575, 2.891 }
local t_1 = setmetatable({}, Finisher_m)
t_1.__index = t_1

function t_1.new(...) -- line: 10
    -- upvalues:
    --  [1] Finisher_m (copy)
    --  [2] t_1 (copy)

    local t_2 = setmetatable(Finisher_m.new(...), t_1)
    t_2:_Init()

    return t_2
end

function t_1.PlayServer(arg1) -- line: 22
    -- upvalues:
    --  [1] t (copy)

    arg1:_SetupProp(script.WingsProp)
    local v2 = arg1._is_humanoid and arg1._subject.RootPart or arg1._subject
    local v3 = arg1._subject.Parent

    if v3 then
        v3 = arg1._subject.Parent:FindFirstChild("UpperTorso")
    end

    v2.Anchored = true
    local v4 = nil

    if arg1._is_humanoid then
        local Animation = Instance.new("Animation")
        Animation.AnimationId = "rbxassetid://126992668612776"
        local Success, Result = pcall(arg1._subject.LoadAnimation, arg1._subject, Animation)

        if Success then
            Result:Play(0)
        end

        v4 = Result
    end

    local v5 = 1 + 0.25 * math.random()
    local v6 = 1.5 + 0.25 * math.random()
    arg1:CreateSound(
        "rbxassetid://113079133719959",
        v5,
        v6,
        nil,
        true,
        5
    )
    arg1:_InternalThread(task.spawn, function() -- line: 47
        -- upvalues:
        --  [1] t (ref)
        --  [2] arg1 (copy)

        for key, val in pairs(t) do
            wait(val - (t[key - 1] or 0))
            arg1:CreateSound(
                "rbxassetid://103418064116555",
                0.75 + 0.25 * math.random(),
                1 + 0.25 * math.random(),
                nil,
                true,
                5
            )
        end
    end)
    wait(3)
    local _ = v3.Position

    if v4 then
        v4:Stop(0)
    end

    v2.Anchored = false
    arg1:_Ragdoll()
    arg1:_AnchorModel()
end

function t_1._Init(_) -- line: 72
end

return t_1
