local CameraShakeInstance_m = require(script.Parent.CameraShakeInstance)
local t = {
    Bump = function() --[[ Bump ]] -- line: 26
        -- upvalues:
        --  [1] CameraShakeInstance_m (copy)

        local v1 = CameraShakeInstance_m.new(2.5, 4, 0.1, 0.75)
        v1.PositionInfluence = Vector3.new(0.15, 0.15, 0.15)
        v1.RotationInfluence = Vector3.new(1, 1, 1)

        return v1
    end,
    Explosion = function() --[[ Explosion ]] -- line: 36
        -- upvalues:
        --  [1] CameraShakeInstance_m (copy)

        local v2 = CameraShakeInstance_m.new(5, 10, 0, 1.5)
        v2.PositionInfluence = Vector3.new(0.25, 0.25, 0.25)
        v2.RotationInfluence = Vector3.new(4, 1, 1)

        return v2
    end,
    Earthquake = function() --[[ Earthquake ]] -- line: 46
        -- upvalues:
        --  [1] CameraShakeInstance_m (copy)

        local v3 = CameraShakeInstance_m.new(0.6, 3.5, 2, 10)
        v3.PositionInfluence = Vector3.new(0.25, 0.25, 0.25)
        v3.RotationInfluence = Vector3.new(1, 1, 4)

        return v3
    end,
    BadTrip = function() --[[ BadTrip ]] -- line: 56
        -- upvalues:
        --  [1] CameraShakeInstance_m (copy)

        local v4 = CameraShakeInstance_m.new(10, 0.15, 5, 10)
        v4.PositionInfluence = Vector3.new(0, 0, 0.15)
        v4.RotationInfluence = Vector3.new(2, 1, 4)

        return v4
    end,
    HandheldCamera = function() --[[ HandheldCamera ]] -- line: 66
        -- upvalues:
        --  [1] CameraShakeInstance_m (copy)

        local v5 = CameraShakeInstance_m.new(1, 0.25, 5, 10)
        v5.PositionInfluence = Vector3.new(0, 0, 0)
        v5.RotationInfluence = Vector3.new(1, 0.5, 0.5)

        return v5
    end,
    Vibration = function() --[[ Vibration ]] -- line: 76
        -- upvalues:
        --  [1] CameraShakeInstance_m (copy)

        local v6 = CameraShakeInstance_m.new(0.4, 20, 2, 2)
        v6.PositionInfluence = Vector3.new(0, 0.15, 0)
        v6.RotationInfluence = Vector3.new(1.25, 0, 4)

        return v6
    end,
    RoughDriving = function() --[[ RoughDriving ]] -- line: 86
        -- upvalues:
        --  [1] CameraShakeInstance_m (copy)

        local v7 = CameraShakeInstance_m.new(1, 2, 1, 1)
        v7.PositionInfluence = Vector3.new(0, 0, 0)
        v7.RotationInfluence = Vector3.new(1, 1, 1)

        return v7
    end,
    Recoil = function() --[[ Recoil ]] -- line: 94
        -- upvalues:
        --  [1] CameraShakeInstance_m (copy)

        local v8 = CameraShakeInstance_m.new(2, 6, 0.05, 0.4)
        v8.PositionInfluence = Vector3.new(0, 0, 0)
        v8.RotationInfluence = Vector3.new(1, 1, 2)

        return v8
    end,
    ChainsawHold = function() --[[ ChainsawHold ]] -- line: 102
        -- upvalues:
        --  [1] CameraShakeInstance_m (copy)

        local v9 = CameraShakeInstance_m.new(3, 6, 0.1, 0.1)
        v9.PositionInfluence = Vector3.new(0.5, 0.5, 0.5)
        v9.RotationInfluence = Vector3.new(0.5, 0.5, 0.5)

        return v9
    end,
    BattleAxeSpin = function() --[[ BattleAxeSpin ]] -- line: 110
        -- upvalues:
        --  [1] CameraShakeInstance_m (copy)

        local v10 = CameraShakeInstance_m.new(5, 10, 0, 0.25)
        v10.PositionInfluence = Vector3.new(0.25, 0.25, 0.25)
        v10.RotationInfluence = Vector3.new(4, 1, 1)

        return v10
    end,
    SpearThrow = function() --[[ SpearThrow ]] -- line: 118
        -- upvalues:
        --  [1] CameraShakeInstance_m (copy)

        local v11 = CameraShakeInstance_m.new(4, 6, 0.05, 0.4)
        v11.PositionInfluence = Vector3.new(0, 0, 0)
        v11.RotationInfluence = Vector3.new(1, 1, 2)

        return v11
    end,
    GrapplerPull = function() --[[ GrapplerPull ]] -- line: 126
        -- upvalues:
        --  [1] CameraShakeInstance_m (copy)

        local v12 = CameraShakeInstance_m.new(3, 6, 0.05, 0.4)
        v12.PositionInfluence = Vector3.new(0, 0, 0)
        v12.RotationInfluence = Vector3.new(1, 1, 2)

        return v12
    end
}

return (setmetatable({}, {
    __index = function(_, arg2) --[[ __index ]] -- line: 136
        -- upvalues:
        --  [1] t (copy)

        local v13 = t[arg2]

        if type(v13) == "function" then
            return v13()
        end

        error("No preset found with index \"" .. arg2 .. "\"")
    end
}))
