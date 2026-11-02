local v1 = nil

local function acquireRunnerThreadAndCallEventHandler(arg1, ...) -- line: 44
    -- upvalues:
    --  [1] v1 (ref)

    local v2 = v1
    v1 = nil
    arg1(...)
    v1 = v2
end

local function runEventHandlerInFreeThread(...) -- line: 55
    -- upvalues:
    --  [1] acquireRunnerThreadAndCallEventHandler (copy)

    acquireRunnerThreadAndCallEventHandler(...)

    while true do
        acquireRunnerThreadAndCallEventHandler(coroutine.yield())
    end
end

local t = {}
t.__index = t

function t.Disconnect(arg2) -- line: 81
    if not arg2.Connected then
        return
    end

    arg2.Connected = false

    if arg2._signal._handlerListHead == arg2 then
        arg2._signal._handlerListHead = arg2._next

        return
    end

    local v4 = arg2._signal._handlerListHead

    while v4 do
        if v4._next == arg2 then
            break
        end

        v4 = v4._next
    end

    if v4 then
        v4._next = arg2._next
    end
end

t.Destroy = t.Disconnect
setmetatable(t, {
    __index = function(_, arg4) --[[ __index ]] -- line: 108
        error(("Attempt to get Connection::%s (not a valid member)"):format((tostring(arg4))), 2)
    end,
    __newindex = function(_, arg6, _) --[[ __newindex ]] -- line: 111
        error(("Attempt to set Connection::%s (not a valid member)"):format((tostring(arg6))), 2)
    end
})
local t_2 = {}
t_2.__index = t_2

function t_2.new() -- line: 153
    -- upvalues:
    --  [1] t_2 (copy)

    return (setmetatable(
        { _handlerListHead = false, _proxyHandler = nil, _yieldedThreads = nil },
        t_2
    ))
end

function t_2.Wrap(u1: userdata) -- line: 176
    -- upvalues:
    --  [1] t_2 (copy)

    assert(
        if typeof(u1) ~= "RBXScriptSignal" then false else true,
        "Argument #1 to Signal.Wrap must be a RBXScriptSignal; got " .. typeof(u1)
    )
    local v6 = t_2.new()
    v6._proxyHandler = u1:Connect(function(...) -- line: 183
        -- upvalues:
        --  [1] v6 (copy)

        v6:Fire(...)
    end)

    return v6
end

function t_2.Is(arg8) -- line: 196
    -- upvalues:
    --  [1] t_2 (copy)

    return if type(arg8) == "table" then if getmetatable(arg8) ~= t_2 then false else true else false
end

function t_2.Connect(arg9, arg10) -- line: 213
    -- upvalues:
    --  [1] t (copy)

    local t_4 = setmetatable({ Connected = true, _signal = arg9, _fn = arg10, _next = false }, t)

    if arg9._handlerListHead then
        t_4._next = arg9._handlerListHead
        arg9._handlerListHead = t_4

        return t_4
    end

    arg9._handlerListHead = t_4

    return t_4
end

function t_2.ConnectOnce(arg11, arg12) -- line: 236
    return arg11:Once(arg12)
end

function t_2.Once(arg13, arg14) -- line: 255
    local v8 = false
    local v9 = nil
    v9 = arg13:Connect(function(...) -- line: 259
        -- upvalues:
        --  [1] v8 (ref)
        --  [2] v9 (ref)
        --  [3] arg14 (copy)

        if v8 then
            return
        end

        v8 = true
        v9:Disconnect()
        arg14(...)
    end)

    return v9
end

function t_2.GetConnections(arg15) -- line: 272
    local t_5 = {}
    local v10 = arg15._handlerListHead

    while v10 do
        table.insert(t_5, v10)
        v10 = v10._next
    end

    return t_5
end

function t_2.DisconnectAll(arg16) -- line: 292
    local v11 = arg16._handlerListHead

    while v11 do
        v11.Connected = false
        v11 = v11._next
    end

    arg16._handlerListHead = false
    v11 = rawget(arg16, "_yieldedThreads")

    if v11 then
        for key in v11 do
            if coroutine.status(key) == "suspended" then
                task.cancel(key)
            end
        end

        table.clear(arg16._yieldedThreads)
    end
end

function t_2.Fire(arg17, ...) -- line: 327
    -- upvalues:
    --  [1] v1 (ref)
    --  [2] runEventHandlerInFreeThread (copy)

    local v12 = arg17._handlerListHead

    while v12 do
        if v12.Connected then
            if not v1 then
                v1 = coroutine.create(runEventHandlerInFreeThread)
            end

            task.spawn(v1, v12._fn, ...)
        end

        v12 = v12._next
    end
end

function t_2.FireDeferred(arg18, ...) -- line: 348
    local v13 = arg18._handlerListHead

    while v13 do
        local v14 = v13
        task.defer(function(...) -- line: 352
            -- upvalues:
            --  [1] v14 (copy)

            if v14.Connected then
                v14._fn(...)
            end
        end, ...)
        v13 = v13._next
    end
end

function t_2.Wait(arg19) -- line: 376
    local v15 = rawget(arg19, "_yieldedThreads")

    if not v15 then
        v15 = {}
        rawset(arg19, "_yieldedThreads", v15)
    end

    local thread = coroutine.running()
    v15[thread] = true
    arg19:Once(function(...) -- line: 386
        -- upvalues:
        --  [1] v15 (ref)
        --  [2] thread (copy)

        v15[thread] = nil
        task.spawn(thread, ...)
    end)

    return coroutine.yield()
end

function t_2.Destroy(arg20) -- line: 406
    arg20:DisconnectAll()
    local v16 = rawget(arg20, "_proxyHandler")

    if v16 then
        v16:Disconnect()
    end
end

setmetatable(t_2, {
    __index = function(_, arg22) --[[ __index ]] -- line: 417
        error(("Attempt to get Signal::%s (not a valid member)"):format((tostring(arg22))), 2)
    end,
    __newindex = function(_, arg24, _) --[[ __newindex ]] -- line: 420
        error(("Attempt to set Signal::%s (not a valid member)"):format((tostring(arg24))), 2)
    end
})

return table.freeze({ new = t_2.new, Wrap = t_2.Wrap, Is = t_2.Is })
