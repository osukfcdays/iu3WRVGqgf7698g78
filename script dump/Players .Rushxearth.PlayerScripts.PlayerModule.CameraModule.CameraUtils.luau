local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local UserGameSettings = UserSettings():GetService("UserGameSettings")
local t = {}

local _ = function(n1: number) --[[ round ]] -- line: 12
    return (math.floor(n1 + 0.5))
end

local t_1 = {}
t_1.__index = t_1

function t_1.new(arg1, arg2) -- line: 21
    -- upvalues:
    --  [1] t_1 (copy)

    return (setmetatable({ freq = arg1, goal = arg2, pos = arg2, vel = 0 }, t_1))
end

function t_1.step(t1: table, n2: number) -- line: 31
    local v1 = t1.freq * 2 * 3.141592653589793
    local Goal = t1.goal
    local Vel = t1.vel
    local v2 = t1.pos - Goal
    local exponential = math.exp(-v1 * n2)
    local v3 = (v2 * (v1 * n2 + 1) + Vel * n2) * exponential + Goal
    t1.pos, t1.vel = v3, (Vel * (1 - v1 * n2) - v2 * (v1 * v1 * n2)) * exponential

    return v3
end

t.Spring = t_1

function t.map(
    n3: number,
    n4: number,
    n5: number,
    n6: number,
    n7: number
) -- line: 53
    return (n3 - n4) * (n7 - n6) / (n5 - n4) + n6
end

function t.mapClamp(
    n8: number,
    n9: number,
    n10: number,
    n11: number,
    n12: number
) -- line: 58
    local v4 = (n8 - n9) * (n12 - n11) / (n10 - n9) + n11
    local minimum = math.min(n11, n12)
    local maximum = math.max(n11, n12)

    return (math.clamp(v4, minimum, maximum))
end

function t.getLooseBoundingSphere(t2: table) -- line: 67
    local t_3 = table.create(#t2)

    for key, val in pairs(t2) do
        t_3[key] = val.Position
    end

    local v5 = t_3[1]
    local v6 = v5
    local v7 = 0

    for _, val_1 in ipairs(t_3) do
        local Magnitude = (val_1 - v5).Magnitude

        if v7 < Magnitude then
            v6 = val_1
            v7 = Magnitude
        end
    end

    v7 = v6
    v5 = 0

    for _, val_2 in ipairs(t_3) do
        local Magnitude_1 = (val_2 - v6).Magnitude

        if v5 < Magnitude_1 then
            v7 = val_2
            v5 = Magnitude_1
        end
    end

    v5 = (v6 + v7) * 0.5
    local v8 = (v6 - v7).Magnitude * 0.5

    for _, val_3 in ipairs(t_3) do
        v7 = (val_3 - v5).Magnitude

        if v7 > v8 then
            v5 += (v7 - v8) * 0.5 * (val_3 - v5).Unit
            v8 = (v7 + v8) * 0.5
        end
    end

    return v5, v8
end

function t.sanitizeAngle(n13: number) -- line: 123
    return (n13 + 3.141592653589793) % 6.283185307179586 - 3.141592653589793
end

function t.Round(n14: number, n15: number) -- line: 128
    local v9 = 10 ^ n15

    return math.floor(n14 * v9 + 0.5) / v9
end

function t.IsFinite(n16: number) -- line: 133
    return if n16 ~= n16 then false else if n16 == math.huge then false else n16 ~= -math.huge
end

function t.IsFiniteVector3(vec1: Vector3) -- line: 137
    -- upvalues:
    --  [1] t (copy)

    return t.IsFinite(vec1.X) and t.IsFinite(vec1.Y) and t.IsFinite(vec1.Z)
end

function t.GetAngleBetweenXZVectors(vec2: Vector3, vec3: Vector3) -- line: 142
    return (math.atan2(vec3.X * vec2.Z - vec3.Z * vec2.X, vec3.X * vec2.X + vec3.Z * vec2.Z))
end

function t.RotateVectorByAngleAndRound(vec4: Vector3, n17: number, n18: number) -- line: 146
    if vec4.Magnitude > 0 then
        vec4 = vec4.Unit
        local angle = math.atan2(vec4.Z, vec4.X)

        return math.floor((math.atan2(vec4.Z, vec4.X) + n17) / n18 + 0.5) * n18 - angle
    end

    return 0
end

local _ = function(n19: number) --[[ SCurveTranform ]] -- line: 160
    n19 = math.clamp(n19, -1, 1)

    if n19 >= 0 then
        return n19 * 0.35 / (0.35 - n19 + 1)
    end

    return -(-n19 * 0.8 / (n19 + 0.8 + 1))
end

local _ = function(n20: number) --[[ toSCurveSpace ]] -- line: 169
    return (math.abs(n20) * 2 - 1) * 1.1 - 0.1
end

local _ = function(n21: number) --[[ fromSCurveSpace ]] -- line: 173
    return n21 / 2 + 0.5
end

function t.GamepadLinearToCurve(u1: Vector2) -- line: 177
    local _ = function(arg3) --[[ onAxis ]] -- line: 178
        local v12 = 1
        v12 = if not (arg3 < 0) then v12 else -1
        local absoluteValue_1 = math.abs(arg3)
        local clampedValue = math.clamp((math.abs(absoluteValue_1) * 2 - 1) * 1.1 - 0.1, -1, 1)
        local v14 = if clampedValue >= 0 then clampedValue * 0.35 / (0.35 - clampedValue + 1) else -(-clampedValue * 0.8 / (clampedValue + 0.8 + 1))

        return (math.clamp((v14 / 2 + 0.5) * v12, -1, 1))
    end

    local X = u1.X
    local v15 = 1
    local New = Vector2.new
    v15 = if not (X < 0) then v15 else -1
    local absoluteValue_4 = math.abs(X)
    local clampedValue_1 = math.clamp((math.abs(absoluteValue_4) * 2 - 1) * 1.1 - 0.1, -1, 1)
    local v17 = if clampedValue_1 >= 0 then clampedValue_1 * 0.35 / (0.35 - clampedValue_1 + 1) else -(-clampedValue_1 * 0.8 / (clampedValue_1 + 0.8 + 1))
    local clampedValue_2 = math.clamp((v17 / 2 + 0.5) * v15, -1, 1)
    v15 = u1.Y
    local v18 = if v15 < 0 then -1 else 1
    local absoluteValue_5 = math.abs(v15)
    local clampedValue_3 = math.clamp((math.abs(absoluteValue_5) * 2 - 1) * 1.1 - 0.1, -1, 1)
    local v20 = if clampedValue_3 >= 0 then clampedValue_3 * 0.35 / (0.35 - clampedValue_3 + 1) else -(-clampedValue_3 * 0.8 / (clampedValue_3 + 0.8 + 1))

    return New(clampedValue_2, (math.clamp((v20 / 2 + 0.5) * v18, -1, 1)))
end

function t.ConvertCameraModeEnumToStandard(arg4) -- line: 191
    return if arg4 ~= Enum.TouchCameraMovementMode.Default then if arg4 ~= Enum.ComputerCameraMovementMode.Default then if arg4 == Enum.TouchCameraMovementMode.Classic then Enum.ComputerCameraMovementMode.Classic else if arg4 == Enum.DevTouchCameraMovementMode.Classic then Enum.ComputerCameraMovementMode.Classic else if arg4 == Enum.DevComputerCameraMovementMode.Classic then Enum.ComputerCameraMovementMode.Classic else if arg4 ~= Enum.ComputerCameraMovementMode.Classic then if arg4 == Enum.TouchCameraMovementMode.Follow then Enum.ComputerCameraMovementMode.Follow else if arg4 == Enum.DevTouchCameraMovementMode.Follow then Enum.ComputerCameraMovementMode.Follow else if arg4 == Enum.DevComputerCameraMovementMode.Follow then Enum.ComputerCameraMovementMode.Follow else if arg4 ~= Enum.ComputerCameraMovementMode.Follow then if arg4 == Enum.TouchCameraMovementMode.Orbital then Enum.ComputerCameraMovementMode.Orbital else if arg4 == Enum.DevTouchCameraMovementMode.Orbital then Enum.ComputerCameraMovementMode.Orbital else if arg4 == Enum.DevComputerCameraMovementMode.Orbital then Enum.ComputerCameraMovementMode.Orbital else if arg4 ~= Enum.ComputerCameraMovementMode.Orbital then if arg4 == Enum.ComputerCameraMovementMode.CameraToggle then Enum.ComputerCameraMovementMode.CameraToggle else if arg4 ~= Enum.DevComputerCameraMovementMode.CameraToggle then if arg4 == Enum.DevTouchCameraMovementMode.UserChoice then Enum.DevComputerCameraMovementMode.UserChoice else if arg4 ~= Enum.DevComputerCameraMovementMode.UserChoice then Enum.ComputerCameraMovementMode.Classic else Enum.DevComputerCameraMovementMode.UserChoice else Enum.ComputerCameraMovementMode.CameraToggle else Enum.ComputerCameraMovementMode.Orbital else Enum.ComputerCameraMovementMode.Follow else Enum.ComputerCameraMovementMode.Classic else Enum.ComputerCameraMovementMode.Classic else Enum.ComputerCameraMovementMode.Follow
end

local _ = function() --[[ getMouse ]] -- line: 240
    -- upvalues:
    --  [1] Players (copy)

    local LocalPlayer = Players.LocalPlayer

    if not LocalPlayer then
        Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
        LocalPlayer = Players.LocalPlayer
    end

    assert(LocalPlayer)

    return LocalPlayer:GetMouse()
end

local v22 = ""
local v23 = nil

function t.setMouseIconOverride(s1: string) -- line: 252
    -- upvalues:
    --  [1] Players (copy)
    --  [2] v23 (ref)
    --  [3] v22 (ref)

    local LocalPlayer_1 = Players.LocalPlayer

    if not LocalPlayer_1 then
        Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
        LocalPlayer_1 = Players.LocalPlayer
    end

    assert(LocalPlayer_1)
    local mouse = LocalPlayer_1:GetMouse()

    if mouse.Icon ~= v23 then
        v22 = mouse.Icon
    end

    mouse.Icon = s1
    v23 = s1
end

function t.restoreMouseIcon() -- line: 263
    -- upvalues:
    --  [1] Players (copy)
    --  [2] v23 (ref)
    --  [3] v22 (ref)

    local LocalPlayer_2 = Players.LocalPlayer

    if not LocalPlayer_2 then
        Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
        LocalPlayer_2 = Players.LocalPlayer
    end

    assert(LocalPlayer_2)
    local mouse_1 = LocalPlayer_2:GetMouse()

    if mouse_1.Icon == v23 then
        mouse_1.Icon = v22
    end

    v23 = nil
end

local MouseBehavior_Default = Enum.MouseBehavior.Default
local v26 = nil

function t.setMouseBehaviorOverride(arg5) -- line: 274
    -- upvalues:
    --  [1] UserInputService (copy)
    --  [2] v26 (ref)
    --  [3] MouseBehavior_Default (ref)

    if UserInputService.MouseBehavior ~= v26 then
        MouseBehavior_Default = UserInputService.MouseBehavior
    end

    UserInputService.MouseBehavior = arg5
    v26 = arg5
end

function t.restoreMouseBehavior() -- line: 283
    -- upvalues:
    --  [1] UserInputService (copy)
    --  [2] v26 (ref)
    --  [3] MouseBehavior_Default (ref)

    if UserInputService.MouseBehavior == v26 then
        UserInputService.MouseBehavior = MouseBehavior_Default
    end

    v26 = nil
end

local RotationType_MovementRelative = Enum.RotationType.MovementRelative
local v27 = nil

function t.setRotationTypeOverride(arg6) -- line: 292
    -- upvalues:
    --  [1] UserGameSettings (copy)
    --  [2] v27 (ref)
    --  [3] RotationType_MovementRelative (ref)

    if UserGameSettings.RotationType ~= v27 then
        RotationType_MovementRelative = UserGameSettings.RotationType
    end

    UserGameSettings.RotationType = arg6
    v27 = arg6
end

function t.restoreRotationType() -- line: 301
    -- upvalues:
    --  [1] UserGameSettings (copy)
    --  [2] v27 (ref)
    --  [3] RotationType_MovementRelative (ref)

    if UserGameSettings.RotationType == v27 then
        UserGameSettings.RotationType = RotationType_MovementRelative
    end

    v27 = nil
end

return t
