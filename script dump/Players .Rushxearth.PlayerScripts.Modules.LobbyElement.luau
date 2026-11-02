local Signal_m = require(game:GetService("ReplicatedStorage").Modules.Signal)
local t = {}
t.__index = t

function t.new() -- line: 8
    -- upvalues:
    --  [1] t (copy)
    --  [2] Signal_m (copy)

    local t_1 = setmetatable({}, t)
    t_1.EnabledChanged = Signal_m.new()
    t_1.IsEnabled = false
    t_1._original_pivots = {}
    t_1:_Init()

    return t_1
end

function t.SetEnabled(arg1, arg2) -- line: 26
    if arg2 == arg1.IsEnabled then
        return
    end

    arg1.IsEnabled = arg2
    arg1.EnabledChanged:Fire(arg1.IsEnabled)
end

function t.Update(_, _) -- line: 35
end

function t._GetOriginalPivot(arg5, arg6) -- line: 43
    local v1 = arg5._original_pivots[arg6]
    local OriginalPivots = arg5._original_pivots

    if not v1 then
        v1 = arg6:GetPivot()
    end

    OriginalPivots[arg6] = v1

    return arg5._original_pivots[arg6]
end

function t._Init(_) -- line: 48
end

return t
