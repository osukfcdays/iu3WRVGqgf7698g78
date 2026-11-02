local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local Signal_m = require(ReplicatedStorage.Modules.Signal)
local t = {}
t.__index = t

function t._new() -- line: 9
    -- upvalues:
    --  [1] t (copy)
    --  [2] Signal_m (copy)

    local t_1 = setmetatable({}, t)
    t_1.TimerUpdated = Signal_m.new()
    t_1._finish_times = {}
    t_1._step_callbacks = {}
    t_1:_Init()

    return t_1
end

function t.GetTimeRemaining(arg1, arg2) -- line: 26
    if not arg1._finish_times[arg2] then
        return -1
    end

    return (math.max(0, (math.ceil(arg1._finish_times[arg2] - tick()))))
end

function t.GetTimeRemainingFormatted(arg3, arg4) -- line: 30
    -- upvalues:
    --  [1] Utility_m (copy)

    local v2 = arg3:GetTimeRemaining(arg4)

    if v2 == -1 then
        return "\226\128\162 \226\128\162 \226\128\162"
    end

    return (Utility_m:TimeFormat2(v2))
end

function t.SetTimeRemaining(arg5, arg6, arg7) -- line: 36
    arg5._finish_times[arg6] = tick() + arg7
    arg5.TimerUpdated:Fire(arg6)
end

function t.OnStep(arg8, arg9, arg10, arg11) -- line: 41
    arg8._step_callbacks[arg9] = if not arg10 then nil else if not arg11 then nil else {
        arg10,
        arg11
    }
    arg8:_Step(arg9)
end

function t._Step(arg12, arg13) -- line: 50
    local v4 = arg12._step_callbacks[arg13]

    if not v4 then
        return
    end

    local Success, Result = pcall(
        v4[2],
        arg12:GetTimeRemaining(v4[1]),
        arg12:GetTimeRemainingFormatted(v4[1])
    )

    if not Success then
        warn("ON STEP CALLBACK ERRORED:", Result)
    end
end

function t._StepLoop(arg14) -- line: 64
    for key, _ in pairs(arg14._step_callbacks) do
        arg14:_Step(key)
    end

    wait(1)
end

function t._FetchTimers(arg15) -- line: 74
    -- upvalues:
    --  [1] ReplicatedStorage (copy)

    arg15:SetTimeRemaining(
        "TaskRefresh",
        ReplicatedStorage.Remotes.Misc.RequestTaskRefreshTimeRemaining:InvokeServer()
    )
    arg15:SetTimeRemaining(
        "AdventCalendar",
        ReplicatedStorage.Remotes.Misc.RequestAdventCalendarTimeRemaining:InvokeServer()
    )
end

function t._Init(arg16) -- line: 79
    -- upvalues:
    --  [1] ReplicatedStorage (copy)

    ReplicatedStorage.Remotes.Misc.UpdateTaskRefreshTimeRemaining.OnClientEvent:Connect(function(
        arguments
    ) -- line: 80
        -- upvalues:
        --  [1] arg16 (copy)

        arg16:SetTimeRemaining("TaskRefresh", arguments)
    end)
    ReplicatedStorage.Remotes.Misc.UpdateAdventCalendarTimeRemaining.OnClientEvent:Connect(function(
        arguments_1
    ) -- line: 84
        -- upvalues:
        --  [1] arg16 (copy)

        arg16:SetTimeRemaining("AdventCalendar", arguments_1)
    end)
    task.spawn(arg16._StepLoop, arg16)
    task.spawn(arg16._FetchTimers, arg16)
end

return t._new()
