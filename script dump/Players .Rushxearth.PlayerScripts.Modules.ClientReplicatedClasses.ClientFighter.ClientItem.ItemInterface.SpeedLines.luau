local t = {}
t.__index = t

function t.new(arg1) -- line: 4
    -- upvalues:
    --  [1] t (copy)

    local t_1 = setmetatable({}, t)
    t_1.ItemInterface = arg1
    t_1.SpeedLinesThin = t_1.ItemInterface.Frame:WaitForChild("SpeedLinesThin")
    t_1.SpeedLinesThick = t_1.ItemInterface.Frame:WaitForChild("SpeedLinesThick")
    t_1._destroyed = false
    t_1._speed_lines_end = 0
    t_1._next_speedlines_update = 0
    t_1:_Init()

    return t_1
end

function t.Create(arg2, arg3) -- line: 26
    arg2._speed_lines_end = if arg3 == -1 then 0 else math.max(arg2._speed_lines_end, tick() + arg3)
end

function t.Update(arg4, _, _, _) -- line: 30
    local v2 = tick() < arg4._speed_lines_end and true
    arg4.SpeedLinesThin.Visible = v2
    arg4.SpeedLinesThick.Visible = v2

    if not v2 or tick() < arg4._next_speedlines_update then
        return
    end

    arg4._next_speedlines_update = tick() + 0.03
    v2 = arg4.ItemInterface.Frame.AbsoluteSize.X / arg4.ItemInterface.Frame.AbsoluteSize.Y
    arg4.SpeedLinesThin.Rotation = (arg4.SpeedLinesThin.Rotation + (math.random() - 0.5) * 72) % 360
    arg4.SpeedLinesThin.Size = UDim2.new(v2, 0, v2, 0)
    arg4.SpeedLinesThick.Rotation = (arg4.SpeedLinesThick.Rotation + (math.random() - 0.5) * 72) % 360
    arg4.SpeedLinesThick.Size = arg4.SpeedLinesThin.Size
end

function t.Destroy(arg8) -- line: 51
    arg8._destroyed = true
end

function t._Init(_) -- line: 59
end

return t
