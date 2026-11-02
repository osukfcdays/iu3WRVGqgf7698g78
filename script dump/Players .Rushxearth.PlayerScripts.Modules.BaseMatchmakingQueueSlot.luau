local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local _ = require(ReplicatedStorage.Modules.CONSTANTS)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local Signal_m = require(ReplicatedStorage.Modules.Signal)
local ButtonEffect_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("ButtonEffect")
)
local color = Color3.fromRGB(200, 200, 200)
local color_1 = Color3.fromRGB(255, 255, 255)
local t = {}
t.__index = t

function t.new(arg1, arg2, arg3) -- line: 15
    -- upvalues:
    --  [1] t (copy)
    --  [2] Signal_m (copy)

    local t_1 = setmetatable({}, t)
    t_1.Clicked = Signal_m.new()
    t_1.Frame = arg1
    t_1._destroyed = false
    t_1._stroke_thickness = arg2 or 4
    t_1._always_bright = arg3 or false
    t_1._hover_hash = 0
    t_1._tween_alpha = 0
    t_1:_Init()

    return t_1
end

function t.Set(arg4, arg5) -- line: 37
    -- upvalues:
    --  [1] color (copy)
    --  [2] color_1 (copy)

    if arg4._destroyed then
        return
    end

    local v2 = if not arg4._always_bright then arg5 else 1
    arg4.Frame.Button.Thumbnail.ImageTransparency = 0.375 - 0.375 * v2
    arg4.Frame.Button.Thumbnail.ImageColor3 = color:Lerp(color_1, v2)
    arg4.Frame.Button.Stroke.Size = UDim2.new(
        1,
        2 - arg4._stroke_thickness * 2 * arg5,
        1,
        2 - arg4._stroke_thickness * 2 * arg5
    )
    arg4.Frame.Button.Stroke.UIStroke.Thickness = arg4._stroke_thickness * arg5
end

function t.Tween(arg6, arg7) -- line: 50
    -- upvalues:
    --  [1] Utility_m (copy)

    if arg6._destroyed then
        return
    end

    arg6._hover_hash += 1
    local HoverHash = arg6._hover_hash
    local v3 = Utility_m
    v3:RenderstepForLoop(arg6._tween_alpha, arg7, 0.15 * (if not (arg7 < arg6._tween_alpha) then 1 else -1), function(
        arg8
    ) -- line: 58
        -- upvalues:
        --  [1] HoverHash (copy)
        --  [2] arg6 (copy)

        if HoverHash ~= arg6._hover_hash or arg6._destroyed then
            return true
        end

        arg6._tween_alpha = arg8
        arg6:Set(1 - (1 - arg6._tween_alpha) ^ 3)
    end)
end

function t.Destroy(arg9) -- line: 68
    arg9._destroyed = true
    arg9.Clicked:Destroy()
    arg9.Frame:Destroy()
end

function t._Init(arg10) -- line: 78
    -- upvalues:
    --  [1] ButtonEffect_m (copy)

    arg10.Frame.Button.MouseLeave:Connect(function() -- line: 79
        -- upvalues:
        --  [1] arg10 (copy)

        arg10:Tween(0)
    end)
    arg10.Frame.Button.SelectionLost:Connect(function() -- line: 83
        -- upvalues:
        --  [1] arg10 (copy)

        arg10:Tween(0)
    end)
    arg10.Frame.Button.MouseEnter:Connect(function() -- line: 87
        -- upvalues:
        --  [1] arg10 (copy)

        arg10:Tween(1)
    end)
    arg10.Frame.Button.SelectionGained:Connect(function() -- line: 91
        -- upvalues:
        --  [1] arg10 (copy)

        arg10:Tween(1)
    end)
    arg10.Frame.Button.MouseButton1Click:Connect(function() -- line: 95
        -- upvalues:
        --  [1] arg10 (copy)

        arg10.Clicked:Fire()
    end)
    arg10:Set(0)
    ButtonEffect_m:Add(arg10.Frame.Button, nil, { ReleaseRatio = 0.975, HoverRatio = 0.975 })
end

return t
