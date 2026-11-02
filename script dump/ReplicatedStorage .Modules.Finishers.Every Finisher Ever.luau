local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Finisher_m = require(ReplicatedStorage.Modules.Finisher)
local Finishers = ReplicatedStorage.Modules.Finishers
local t = setmetatable({}, Finisher_m)
t.__index = t

function t.new(...) -- line: 10
    -- upvalues:
    --  [1] Finisher_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(Finisher_m.new(...), t)
    t_1._finishers = {}
    t_1:_Init()

    return t_1
end

function t.PlayServer(arg1) -- line: 24
    local BindableEvent = Instance.new("BindableEvent")
    local v2 = 0
    local v3 = 0

    for _, val in pairs(arg1._finishers) do
        v2 += 1
        arg1:_InternalThread(task.spawn, function() -- line: 32
            -- upvalues:
            --  [1] val (copy)
            --  [2] v3 (ref)
            --  [3] BindableEvent (copy)

            pcall(val.PlayServer, val)
            v3 += 1
            BindableEvent:Fire()
        end)
    end

    while v2 > v3 do
        BindableEvent.Event:Wait()
    end
end

function t.PlayClient(arg2) -- line: 44
    local BindableEvent_1 = Instance.new("BindableEvent")
    local v4 = 0
    local v5 = 0

    for _, val_1 in pairs(arg2._finishers) do
        v4 += 1
        arg2:_InternalThread(task.spawn, function() -- line: 52
            -- upvalues:
            --  [1] val_1 (copy)
            --  [2] v5 (ref)
            --  [3] BindableEvent_1 (copy)

            pcall(val_1.PlayClient, val_1)
            v5 += 1
            BindableEvent_1:Fire()
        end)
    end

    while v4 > v5 do
        BindableEvent_1.Event:Wait()
    end
end

function t.Destroy(arg3) -- line: 64
    -- upvalues:
    --  [1] Finisher_m (copy)

    for _, val_2 in pairs(arg3._finishers) do
        val_2:Destroy()
    end

    Finisher_m.Destroy(arg3)
end

function t._Setup(arg4) -- line: 76
    -- upvalues:
    --  [1] Finishers (copy)

    for _, child in pairs(Finishers:GetChildren()) do
        if child ~= script then
            table.insert(
                arg4._finishers,
                require(child).new(arg4._subject, arg4._is_final_finisher, arg4._eliminator)
            )
        end
    end
end

function t._Init(arg5) -- line: 84
    arg5:_Setup()
end

return t
