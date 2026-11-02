local CONSTANTS_m = require(game:GetService("ReplicatedStorage").Modules.CONSTANTS)
local t = {}
t.__index = t

function t._new() -- line: 8
    -- upvalues:
    --  [1] t (copy)

    local t_1 = setmetatable({}, t)
    t_1._last_fetch = tick()
    t_1._last_server_time = workspace:GetServerTimeNow()
    t_1:_Init()

    return t_1
end

function t.Get(arg1) -- line: 23
    -- upvalues:
    --  [1] CONSTANTS_m (copy)

    if CONSTANTS_m.IS_SERVER then
        return (os.time())
    end

    return arg1._last_server_time + (tick() - arg1._last_fetch)
end

function t.GetRounded(arg2) -- line: 27
    -- upvalues:
    --  [1] CONSTANTS_m (copy)

    if CONSTANTS_m.IS_SERVER then
        return (os.time())
    end

    return (math.floor(arg2:Get() + 0.5))
end

function t.WaitUntil(arg3, arg4) -- line: 31
    wait(arg4 - arg3:Get())
end

function t._Init(_) -- line: 39
end

return t._new()
