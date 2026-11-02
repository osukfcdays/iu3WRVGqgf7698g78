local t = {}

function t.new(arg1, arg2, arg3, arg4) -- line: 38
    -- upvalues:
    --  [1] t (copy)

    local v1 = arg1 or 0
    arg4 = arg4 or os.clock

    return (setmetatable(
        {
            _clock = arg4,
            _time0 = arg4(),
            _position0 = v1,
            _velocity0 = 0 * v1,
            _target = v1,
            _damper = arg2 or 1,
            _speed = arg3 or 1
        },
        t
    ))
end

function t.Impulse(arg5, arg6) -- line: 58
    arg5.Velocity += arg6
end

function t.TimeSkip(arg7, arg8) -- line: 67
    local v3 = arg7._clock()
    arg7._position0, arg7._velocity0 = arg7:_positionVelocity(v3 + arg8)
    arg7._time0 = v3
end

function t.__index(arg9, arg10) -- line: 143
    -- upvalues:
    --  [1] t (copy)

    if t[arg10] then
        return t[arg10]
    end

    if arg10 == "Value" or arg10 == "Position" or arg10 == "p" then
        local v5, _ = arg9:_positionVelocity(arg9._clock())

        return v5
    end

    if arg10 == "Velocity" or arg10 == "v" then
        local _, v8 = arg9:_positionVelocity(arg9._clock())

        return v8
    end

    if arg10 == "Target" or arg10 == "t" then
        return arg9._target
    end

    if arg10 == "Damper" or arg10 == "d" then
        return arg9._damper
    end

    if arg10 == "Speed" or arg10 == "s" then
        return arg9._speed
    end

    if arg10 == "Clock" then
        return arg9._clock
    end

    error(("%q is not a valid member of Spring"):format((tostring(arg10))), 2)
end

function t.__newindex(arg11, arg12, arg13) -- line: 165
    local v9 = arg11._clock()

    if arg12 == "Value" or arg12 == "Position" or arg12 == "p" then
        local _, v11 = arg11:_positionVelocity(v9)
        arg11._position0 = arg13
        arg11._velocity0 = v11
        arg11._time0 = v9

        return
    end

    if arg12 == "Velocity" or arg12 == "v" then
        local v12, _ = arg11:_positionVelocity(v9)
        arg11._position0 = v12
        arg11._velocity0 = arg13
        arg11._time0 = v9

        return
    end

    if arg12 == "Target" or arg12 == "t" then
        arg11._position0, arg11._velocity0 = arg11:_positionVelocity(v9)
        arg11._target = arg13
        arg11._time0 = v9

        return
    end

    if arg12 == "Damper" or arg12 == "d" then
        arg11._position0, arg11._velocity0 = arg11:_positionVelocity(v9)
        arg11._damper = arg13
        arg11._time0 = v9

        return
    end

    if arg12 == "Speed" or arg12 == "s" then
        arg11._position0, arg11._velocity0 = arg11:_positionVelocity(v9)
        arg11._speed = if arg13 < 0 then 0 else arg13
        arg11._time0 = v9

        return
    end

    if arg12 == "Clock" then
        arg11._position0, arg11._velocity0 = arg11:_positionVelocity(v9)
        arg11._clock = arg13
        arg11._time0 = arg13()

        return
    end

    error(("%q is not a valid member of Spring"):format((tostring(arg12))), 2)
end

function t._positionVelocity(arg14, arg15) -- line: 207
    local Position0 = arg14._position0
    local Velocity0 = arg14._velocity0
    local Target = arg14._target
    local Damper = arg14._damper
    local Speed = arg14._speed
    local v15 = Speed * (arg15 - arg14._time0)
    local v16 = Damper * Damper
    local v17, v19, v20

    if v16 < 1 then
        v17 = math.sqrt(1 - v16)
        local v18 = math.exp(-Damper * v15) / v17
        v19 = v18 * math.cos(v17 * v15)
        v20 = v18 * math.sin(v17 * v15)
    elseif v16 == 1 then
        v17 = 1
        local v21 = math.exp(-Damper * v15) / v17
        v19 = v21
        v20 = v21 * v15
    else
        v17 = math.sqrt(v16 - 1)
        local v22 = math.exp((-Damper + v17) * v15) / (2 * v17)
        local v23 = math.exp((-Damper - v17) * v15) / (2 * v17)
        v19 = v22 + v23
        v20 = v22 - v23
    end

    return (v17 * v19 + Damper * v20) * Position0 + (1 - (v17 * v19 + Damper * v20)) * Target + v20 / Speed * Velocity0, -Speed * v20 * Position0 + Speed * v20 * Target + (v17 * v19 - Damper * v20) * Velocity0
end

return t
