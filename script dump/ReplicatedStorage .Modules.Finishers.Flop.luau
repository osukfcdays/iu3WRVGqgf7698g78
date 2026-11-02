local ReplicatedStorage = game:GetService("ReplicatedStorage")
local _ = game:GetService("RunService")
local _ = require(ReplicatedStorage.Modules.BetterDebris)
local Ragdoll_m = require(ReplicatedStorage.Modules.Finishers.Ragdoll)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local t = {
    "rbxassetid://88375867455898",
    "rbxassetid://79484939092852",
    "rbxassetid://107671189154511"
}
local t_1 = setmetatable({}, Ragdoll_m)
t_1.__index = t_1

function t_1.new(...) -- line: 13
    -- upvalues:
    --  [1] Ragdoll_m (copy)
    --  [2] t_1 (copy)

    local t_2 = setmetatable(Ragdoll_m.new(...), t_1)
    t_2:_Init()

    return t_2
end

function t_1.PlayServer(arg1, ...) -- line: 25
    -- upvalues:
    --  [1] Ragdoll_m (copy)
    --  [2] Utility_m (copy)
    --  [3] t (copy)

    Ragdoll_m.PlayServer(arg1, ...)

    if not arg1._is_humanoid then
        return
    end

    arg1:_InternalThread(task.spawn, function() -- line: 32
        -- upvalues:
        --  [1] arg1 (copy)
        --  [2] Utility_m (ref)
        --  [3] t (ref)

        while true do
            wait(0.25)

            if arg1._destroyed then
                return
            end

            Utility_m:Knockback(arg1._subject.RootPart, Vector3.new(0, 20, 0))
            arg1:CreateSound(
                t[math.random(#t)],
                1.25,
                1 + 0.1 * math.random(),
                nil,
                true,
                5
            )
            wait(0.5)

            if not arg1._destroyed then
                continue
            end

            return
        end
    end)
end

function t_1._Init(_) -- line: 56
end

return t_1
