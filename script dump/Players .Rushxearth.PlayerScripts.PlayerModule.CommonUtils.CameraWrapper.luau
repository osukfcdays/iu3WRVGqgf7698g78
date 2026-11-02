local ConnectionUtil_m = require(script.Parent.ConnectionUtil)
local t = {}
t.__index = t

function t.new() -- line: 39
    -- upvalues:
    --  [1] ConnectionUtil_m (copy)
    --  [2] t (copy)

    return (setmetatable(
        {
            _camera = game.Workspace.CurrentCamera,
            _callbacks = {},
            _connectionUtil = ConnectionUtil_m.new(),
            _enabled = false
        },
        t
    ))
end

function t._connectCallbacks(arg1) -- line: 52
    arg1._camera = game.Workspace.CurrentCamera

    if not arg1._camera then
        return
    end

    for key, val in arg1._callbacks do
        arg1._connectionUtil:trackConnection(
            key,
            arg1._camera:GetPropertyChangedSignal(key):Connect(val)
        )
        val()
    end
end

function t.Enable(arg2) -- line: 65
    if arg2._enabled then
        return
    end

    arg2._enabled = true
    arg2._cameraChangedConnection = game.Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(
        function() -- line: 72
            -- upvalues:
            --  [1] arg2 (copy)

            arg2:_connectCallbacks()
        end
    )
    arg2:_connectCallbacks()
end

function t.Disable(arg3) -- line: 79
    if not arg3._enabled then
        return
    end

    arg3._enabled = false

    if arg3._cameraChangedConnection then
        arg3._cameraChangedConnection:Disconnect()
        arg3._cameraChangedConnection = nil
    end

    arg3._connectionUtil:disconnectAll()
end

function t.Connect(t1: table, s1: string, f1: (...any) -> ...any) -- line: 94
    t1._callbacks[s1] = f1

    if not t1._camera then
        return
    end

    t1._connectionUtil:trackConnection(s1, t1._camera:GetPropertyChangedSignal(s1):Connect(f1))
end

function t.Disconnect(t2: table, s2: string) -- line: 104
    t2._connectionUtil:disconnect(s2)
    t2._callbacks[s2] = nil
end

function t.getCamera(arg4) -- line: 110
    return arg4._camera
end

return t
