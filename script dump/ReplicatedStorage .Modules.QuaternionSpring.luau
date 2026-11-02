local Quaternion_m = require(
    game:GetService("ReplicatedStorage").Modules:WaitForChild("Quaternion")
)
local t = { _type = "QuaternionSpring" }

function t.new(arg1: any, n1: number?, n2: number?, f1: ((...any) -> ...any)?) -- line: 119
    -- upvalues:
    --  [1] Quaternion_m (copy)
    --  [2] t (copy)

    local v2 = arg1 or Quaternion_m.identity
    local v3 = f1 or os.clock

    return (setmetatable(
        {
            _clock = v3,
            _time = v3(),
            _position = v2,
            _velocity = Vector3.new(0, 0, 0),
            _target = v2,
            _damping = n1 or 1,
            _speed = n2 or 1,
            _initial = v2
        },
        t
    ))
end

function t.Reset(arg2, arg3) -- line: 148
    local v4 = arg3 or arg2._initial
    arg2._position = v4
    arg2._target = v4
    arg2._velocity = Vector3.new(0, 0, 0)
end

function t.Impulse(arg4: any, vec1: Vector3) -- line: 170
    arg4._velocity += vec1
end

local function _positionVelocity(arg5: any, n3: number) -- line: 177
    local Position = arg5._position
    local Velocity = arg5._velocity
    local Target = arg5._target
    local Damping = arg5._damping
    local Speed = arg5._speed
    local v5 = Speed * (n3 - arg5._time)
    local v6 = Damping * Damping
    local v10, v7, v9

    if v6 < 1 then
        v7 = math.sqrt(1 - v6)
        local v8 = math.exp(-Damping * v5) / v7
        v9 = v8 * math.cos(v7 * v5)
        v10 = v8 * math.sin(v7 * v5)
    elseif v6 == 1 then
        v7 = 1
        local exponential = math.exp(-Damping * v5)
        v9 = exponential
        v10 = exponential * v5
    else
        v7 = math.sqrt(v6 - 1)
        local v11 = 2 * v7
        local v12 = math.exp((-Damping + v7) * v5) / v11
        local v13 = math.exp((-Damping - v7) * v5) / v11
        v9 = v12 + v13
        v10 = v12 - v13
    end

    local v14 = v10 / Speed
    local v15 = Speed * v10
    local v16 = v7 * v9 - Damping * v10
    v10 = Position:Slerp(Target, 1 - (v7 * v9 + Damping * v10)):Integrate(Velocity, v14)
    local v19, v20 = Position:Difference(Target):ToAxisAngle()

    return v10, v19 * v20 * v15 + Velocity * v16
end

function t.TimeSkip(arg6: any, n4: number) -- line: 228
    -- upvalues:
    --  [1] _positionVelocity (copy)

    local v22 = arg6._clock()
    arg6._position, arg6._velocity = _positionVelocity(arg6, v22 + n4)
    arg6._time = v22
end

function t.__index(arg7: any, s1: string) -- line: 238
    -- upvalues:
    --  [1] t (copy)
    --  [2] _positionVelocity (copy)

    if t[s1] then
        return t[s1]
    end

    if s1 == "Position" or s1 == "p" then
        local v24, _ = _positionVelocity(arg7, arg7._clock())

        return v24
    end

    if s1 == "Velocity" or s1 == "v" then
        local _, v28 = _positionVelocity(arg7, arg7._clock())

        return v28
    end

    if s1 == "Target" or s1 == "t" then
        return arg7._target
    end

    if s1 == "Damping" or s1 == "d" then
        return arg7._damping
    end

    if s1 == "Speed" or s1 == "s" then
        return arg7._speed
    end

    if s1 == "Clock" then
        return arg7._clock
    end

    error(string.format("%q is not a valid member of QuaternionSpring.", (tostring(s1))), 2)
end

function t.__newindex(arg8: any, s2: string, arg9: any) -- line: 259
    -- upvalues:
    --  [1] _positionVelocity (copy)

    local v29 = arg8._clock()

    if s2 == "Position" or s2 == "p" then
        local _, v31 = _positionVelocity(arg8, v29)
        arg8._position = arg9
        arg8._velocity = v31
        arg8._time = v29

        return
    end

    if s2 == "Velocity" or s2 == "v" then
        local v32, _ = _positionVelocity(arg8, v29)
        arg8._position = v32
        arg8._velocity = arg9
        arg8._time = v29

        return
    end

    if s2 == "Target" or s2 == "t" then
        arg8._position, arg8._velocity = _positionVelocity(arg8, v29)
        arg8._target = arg9
        arg8._time = v29

        return
    end

    if s2 == "Damping" or s2 == "d" then
        arg8._position, arg8._velocity = _positionVelocity(arg8, v29)
        arg8._damping = arg9
        arg8._time = v29

        return
    end

    if s2 == "Speed" or s2 == "s" then
        arg8._position, arg8._velocity = _positionVelocity(arg8, v29)
        arg8._speed = if not (arg9 < 0) then arg9 else 0
        arg8._time = v29

        return
    end

    if s2 == "Clock" then
        arg8._position, arg8._velocity = _positionVelocity(arg8, v29)
        arg8._clock = arg9
        arg8._time = arg9()

        return
    end

    error(string.format("%q is not a valid member of QuaternionSpring.", (tostring(s2))), 2)
end

return t
