local _ = game:GetService("TweenService")
local WrapGroupObject_m = require(
    game:GetService("Players").LocalPlayer.PlayerScripts.Modules.WrapGroupObject
)
local t = { 0.086, 0.156, 0.128 }
local t_1 = { 1, 1, 0.639 }
local CurrentCamera = workspace.CurrentCamera
local t_2 = setmetatable({}, WrapGroupObject_m)
t_2.__index = t_2

function t_2.new(...) -- line: 22
    -- upvalues:
    --  [1] WrapGroupObject_m (copy)
    --  [2] t_2 (copy)

    local t_3 = setmetatable(WrapGroupObject_m.new(...), t_2)
    t_3._color_objects = {}
    t_3._color_sequence_objects = {}
    t_3._brick_color_objects = {}
    t_3:_Init()

    return t_3
end

function t_2.Update(arg1, _) -- line: 38
    -- upvalues:
    --  [1] t (copy)
    --  [2] t_1 (copy)

    local _ = workspace:GetServerTimeNow()
    local v2 = arg1:_GetOffset() % 1

    for _, val in pairs(arg1._color_objects) do
        local v3 = val:GetAttribute("WrapGroup") or 1
        val.Color = Color3.fromHSV(v2, t[v3], t_1[v3])
    end

    for _, val_1 in pairs(arg1._color_sequence_objects) do
        local v4 = val_1:GetAttribute("WrapGroup") or 1
        val_1.Color = ColorSequence.new(Color3.fromHSV(v2, t[v4], t_1[v4]))
    end

    for _, val_2 in pairs(arg1._brick_color_objects) do
        local v5 = val_2:GetAttribute("WrapGroup") or 1
        val_2.Color = BrickColor.new(Color3.fromHSV(v2, t[v5], t_1[v5]))
    end
end

function t_2._NormalizeAngle(_, arg4) -- line: 65
    return (math.abs(arg4 % 6.283185307179586 / 6.283185307179586 * 2 - 1))
end

function t_2._GetOffset(arg5) -- line: 69
    -- upvalues:
    --  [1] CurrentCamera (copy)

    local Position = CurrentCamera.CFrame.Position
    local v6, v7, v8 = CurrentCamera.CFrame:ToEulerAnglesXYZ()
    local v10 = arg5:_NormalizeAngle(v6)
    local v12 = arg5:_NormalizeAngle(v7)

    return (Position + Vector3.new(v10, v12, arg5:_NormalizeAngle(v8)) * 32).Magnitude / 128
end

function t_2._Evaluate(arg6, arg7) -- line: 76
    if arg7:IsA("BasePart") then
        table.insert(arg6._color_objects, arg7)

        return
    end

    if arg7:IsA("ParticleEmitter") or arg7:IsA("Beam") or arg7:IsA("Trail") then
        table.insert(arg6._color_sequence_objects, arg7)

        return
    end

    if arg7:IsA("RopeConstraint") or arg7:IsA("RodConstraint") then
        table.insert(arg6._brick_color_objects, arg7)
    end
end

function t_2._Setup(arg8) -- line: 86
    arg8:_Evaluate(arg8.Object)

    for _, val_3 in arg8.ExtraObjects do
        arg8:_Evaluate(val_3)
    end
end

function t_2._Init(arg9) -- line: 93
    arg9:_Setup()
end

return t_2
