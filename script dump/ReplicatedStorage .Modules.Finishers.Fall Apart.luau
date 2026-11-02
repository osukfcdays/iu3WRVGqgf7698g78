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
    arg1:_BreakJoints()
    arg1:_InternalThread(task.delay, 0.25, arg1._BreakJoints, arg1)
    arg1:_AnchorModel()

    for _, val in pairs(arg1:_GetObjects()) do
        if val:IsA("BasePart") then
            local AssemblyLinearVelocity = val.AssemblyLinearVelocity
            local v3 = math.random() - 0.5
            val.AssemblyLinearVelocity = AssemblyLinearVelocity + Vector3.new(
                v3,
                math.random(),
                math.random() - 0.5
            ) * 10
        end
    end
end

function t.PlayClient(_) -- line: 32
end

function t._Init(_) -- line: 40
end

return t
