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

function t.PlayClient(arg1, ...) -- line: 20
    -- upvalues:
    --  [1] Ragdoll_m (copy)

    Ragdoll_m.PlayClient(arg1, ...)
    local v2 = arg1._is_humanoid and arg1._subject.RootPart or arg1._subject
    local v3 = script.Particles:Clone()
    v3.CFrame = v2.CFrame
    v3.Parent = workspace
    table.insert(arg1._destroy_these, v3)
    local WeldConstraint = Instance.new("WeldConstraint")
    WeldConstraint.Part0 = v2
    WeldConstraint.Part1 = v3
    WeldConstraint.Parent = v3
    local v4 = 0.95 + 0.1 * math.random()
    arg1:CreateSound(
        "rbxassetid://110334213997451",
        0.75,
        v4,
        nil,
        true,
        10
    )
    local v5 = 0.95 + 0.1 * math.random()
    arg1:CreateSound(
        "rbxassetid://85939220046386",
        1,
        v5,
        nil,
        true,
        10
    )
    local v6 = true
    arg1:_InternalThread(task.spawn, function() -- line: 40
        -- upvalues:
        --  [1] v6 (ref)
        --  [2] v3 (copy)
        --  [3] arg1 (copy)

        while true do
            if not v6 then
                break
            end

            local v7 = script.Props:GetChildren()[math.random(#script.Props:GetChildren())]:Clone()
            v7:PivotTo(
                v3.CFrame * CFrame.Angles(
                    math.random() * 3.141592653589793 * 2,
                    math.random() * 3.141592653589793 * 2,
                    math.random() * 3.141592653589793 * 2
                )
            )
            v7:ScaleTo(v7:GetScale() * (1 + 2 * math.random()))

            for _, val in pairs(v7:GetChildren()) do
                if val ~= v7.Primary then
                    local WeldConstraint_1 = Instance.new("WeldConstraint")
                    WeldConstraint_1.Part0 = val
                    WeldConstraint_1.Part1 = v7.Primary
                    WeldConstraint_1.Parent = v7.Primary
                end
            end

            v7.Primary.Velocity = (Random.new():NextUnitVector() + Vector3.new(0, 2, 0)).Unit * (40 + 60 * math.random())
            v7.Primary.RotVelocity = Random.new():NextUnitVector() * (5 + 20 * math.random())
            v7.Parent = v3
            table.insert(arg1._destroy_these, v7)
            wait(0.1 + 0.6 * math.random())
        end
    end)
    wait(7.5)
    v6 = false

    for _, descendant in pairs(v3:GetDescendants()) do
        if descendant:IsA("ParticleEmitter") then
            descendant.Enabled = false
        end
    end
end

function t._Init(_) -- line: 80
end

return t
