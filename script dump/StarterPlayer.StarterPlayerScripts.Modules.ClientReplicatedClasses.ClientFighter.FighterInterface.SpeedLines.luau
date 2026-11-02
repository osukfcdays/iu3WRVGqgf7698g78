local t = {}
t.__index = t

function t.new(arg1) -- line: 4
    -- upvalues:
    --  [1] t (copy)

    local t_1 = setmetatable({}, t)
    t_1.FighterInterface = arg1
    t_1.SpeedLinesThin = t_1.FighterInterface.Frame:WaitForChild("SpeedLinesThin")
    t_1.SpeedLinesThick = t_1.FighterInterface.Frame:WaitForChild("SpeedLinesThick")
    t_1._next_speedlines_update = 0
    t_1:_Init()

    return t_1
end

function t.Update(arg2, _, arg4) -- line: 22
    local v1 = arg2.FighterInterface.ClientFighter.Entity and arg2.FighterInterface.ClientFighter.Entity:GetBoost(
        "Speed"
    ) or 0
    local v2 = v1 > 0 and true
    arg2.SpeedLinesThin.Visible = v2
    arg2.SpeedLinesThick.Visible = v2

    if not v2 or tick() < arg2._next_speedlines_update then
        return
    end

    arg2._next_speedlines_update = tick() + 0.03
    v2 = math.sqrt(
        arg2.FighterInterface.Frame.AbsoluteSize.X ^ 2 + arg2.FighterInterface.Frame.AbsoluteSize.Y ^ 2
    )
    local v3 = if arg4.MoveSpeed <= 1 then 1 else 1 - math.clamp(v1, 0, 1) * 1
    local minimum = math.min(0.9, v3)
    arg2.SpeedLinesThin.Rotation = (arg2.SpeedLinesThin.Rotation + (math.random() - 0.5) * 72) % 360
    arg2.SpeedLinesThin.Size = UDim2.new(0, v2, 0, v2)
    arg2.SpeedLinesThick.Rotation = (arg2.SpeedLinesThick.Rotation + (math.random() - 0.5) * 72) % 360
    arg2.SpeedLinesThick.Size = arg2.SpeedLinesThin.Size
    arg2.SpeedLinesThin.ImageTransparency = minimum
    arg2.SpeedLinesThick.ImageTransparency = minimum
end

function t.Destroy(_) -- line: 48
end

function t._Init(_) -- line: 56
end

return t
