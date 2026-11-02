local ReplicatedStorage = game:GetService("ReplicatedStorage")
local t = {}
t.__index = t

function t._new() -- line: 6
    -- upvalues:
    --  [1] t (copy)

    local t_1 = setmetatable({}, t)
    t_1._last_update = -1
    t_1._time_remaining = nil
    t_1:_Init()

    return t_1
end

function t.GetTimeRemaining(arg1) -- line: 21
    if not arg1._time_remaining then
        return
    end

    return (math.max(0, (math.ceil(arg1._time_remaining - (tick() - arg1._last_update)))))
end

function t._UpdateTimer(arg2, arg3) -- line: 33
    arg2._last_update = tick()
    arg2._time_remaining = arg3
end

function t._Fetch(arg4) -- line: 38
    -- upvalues:
    --  [1] ReplicatedStorage (copy)

    arg4:_UpdateTimer(ReplicatedStorage.Remotes.Misc.RequestEventTimer:InvokeServer())
end

function t._Init(arg5) -- line: 42
    -- upvalues:
    --  [1] ReplicatedStorage (copy)

    ReplicatedStorage.Remotes.Misc.UpdateEventTimer.OnClientEvent:Connect(function(arguments) -- line: 43
        -- upvalues:
        --  [1] arg5 (copy)

        arg5:_UpdateTimer(arguments)
    end)
    task.defer(arg5._Fetch, arg5)
end

return t._new()
