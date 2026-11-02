local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CONSTANTS_m = require(ReplicatedStorage.Modules.CONSTANTS)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local ColorPicker_m = require(Players.LocalPlayer.PlayerScripts.Modules.ColorPicker)
local UILibrary_m = require(Players.LocalPlayer.PlayerScripts.Modules.UILibrary)
local color = Color3.fromRGB(255, 255, 255)
local color_1 = Color3.fromRGB(0, 0, 0)
local t = setmetatable({}, ColorPicker_m)
t.__index = t

function t.new(...) -- line: 16
    -- upvalues:
    --  [1] ColorPicker_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(ColorPicker_m.new(...), t)
    t_1.ColorWheelFrame = t_1.Frame:WaitForChild("ColorWheel")
    t_1.Picture = t_1.ColorWheelFrame:WaitForChild("Picture")
    t_1.PictureIcon = t_1.Picture:WaitForChild("Icon")
    t_1.Cursor = t_1.ColorWheelFrame:WaitForChild("Cursor")
    t_1.CursorImage = t_1.Cursor:WaitForChild("ImageLabel")
    t_1.ValueSliderFrame = t_1.Frame:WaitForChild("ValueSlider")
    t_1.ValueColor = t_1.ValueSliderFrame:WaitForChild("Color")
    t_1.Slider = t_1.ValueSliderFrame:WaitForChild("Slider")
    t_1._color_picker_connection = nil
    t_1._ignore_next_cursor_and_slider_update = false
    t_1:_Init()

    return t_1
end

function t.Destroy(arg1) -- line: 40
    -- upvalues:
    --  [1] ColorPicker_m (copy)

    arg1:_ClearConnections()
    ColorPicker_m.Destroy(arg1)
end

function t._ClearConnections(arg2) -- line: 49
    if arg2._color_picker_connection then
        arg2._color_picker_connection:Disconnect()
        arg2._color_picker_connection = nil
    end
end

function t._UpdateValueColor(arg3) -- line: 56
    -- upvalues:
    --  [1] Utility_m (copy)
    --  [2] color (copy)
    --  [3] color_1 (copy)

    local v2, v3, v4 = Utility_m:Color3FromHex(arg3.Value):ToHSV()
    arg3.ValueColor.BackgroundColor3 = Color3.fromHSV(v2, v3, 1)
    arg3.PictureIcon.ImageColor3 = Color3.new(v4, v4, v4)
    arg3.CursorImage.ImageColor3 = if v4 < 0.35 then color else color_1
end

function t._UpdateFromCursorAndSlider(arg4) -- line: 65
    -- upvalues:
    --  [1] Utility_m (copy)

    local v8 = arg4.Cursor.AbsolutePosition + arg4.Cursor.AbsoluteSize / 2 - (arg4.Picture.AbsolutePosition + arg4.Picture.AbsoluteSize / 2)
    local v9 = v8.Magnitude / (arg4.Picture.AbsoluteSize.Y / 2)
    local v11 = math.atan(v8.Y / v8.X) + (if v8.X < 0 then 3.141592653589793 else 0)
    local v10 = if v11 == v11 then (v11 + 1.5707963267948966) / 6.283185307179586 else 0
    local clampedValue = math.clamp(v10, 0, 1)
    local clampedValue_1 = math.clamp(v9, 0, 1)
    local clampedValue_3 = math.clamp(1 - arg4.Slider.Position.Y.Scale, 0, 1)
    local color_3 = Color3.fromHSV(clampedValue, clampedValue_1, clampedValue_3)
    arg4:SetColor(Utility_m:HexFromColor3(color_3), true)
end

function t._RepositionCursorAndSlider(arg5) -- line: 80
    -- upvalues:
    --  [1] Utility_m (copy)

    if arg5._ignore_next_cursor_and_slider_update then
        task.defer(function() -- line: 82
            -- upvalues:
            --  [1] arg5 (copy)

            arg5._ignore_next_cursor_and_slider_update = false
        end)

        return
    end

    local v17 = Utility_m:Color3FromHex(arg5.Value)
    local v18, v19, v20 = v17:ToHSV(v17)
    local v21 = v18 * 6.283185307179586 - 1.5707963267948966
    local v22 = v19 * (arg5.Picture.AbsoluteSize.Y / 2)
    local v23 = math.cos(v21) * v22 / arg5.Picture.AbsoluteSize.X
    local v24 = math.sin(v21) * v22 / arg5.Picture.AbsoluteSize.Y
    arg5.Slider.Position = UDim2.new(0.5, 0, 1 - v20, 0)
    arg5.Cursor.Position = UDim2.new(0.5 + v23, 0, 0.5 + v24, 0)
end

function t._Setup(arg6) -- line: 102
    -- upvalues:
    --  [1] CONSTANTS_m (copy)
    --  [2] RunService (copy)
    --  [3] UILibrary_m (copy)

    arg6.Cursor.Visible = true
    arg6.Slider.Visible = true

    if CONSTANTS_m.DEVICE == "Console" then
        return
    end

    arg6.ColorWheelFrame.InputBegan:Connect(function(input: InputObject) -- line: 109
        -- upvalues:
        --  [1] arg6 (copy)
        --  [2] RunService (ref)
        --  [3] UILibrary_m (ref)

        if
            input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch
        then
            arg6:_ClearConnections()
            arg6._color_picker_connection = RunService.RenderStepped:Connect(function() -- line: 113
                -- upvalues:
                --  [1] UILibrary_m (ref)
                --  [2] arg6 (ref)

                local v25 = UILibrary_m:GetMouseLocation() - (arg6.Picture.AbsolutePosition + arg6.Picture.AbsoluteSize / 2)
                local clampedValue_4 = math.clamp(v25.Magnitude, 0, arg6.Picture.AbsoluteSize.Y / 2)
                local v27 = math.atan(v25.Y / v25.X) + (if v25.X < 0 then 3.141592653589793 else 0)
                local v28 = math.cos(v27) * clampedValue_4 / arg6.Picture.AbsoluteSize.X
                local v29 = math.sin(v27) * clampedValue_4 / arg6.Picture.AbsoluteSize.Y
                arg6._ignore_next_cursor_and_slider_update = true
                arg6.Cursor.Position = UDim2.new(0.5 + v28, 0, 0.5 + v29, 0)
                arg6.Cursor.Visible = true
                arg6:_UpdateFromCursorAndSlider()
            end)
        end
    end)
    arg6.ColorWheelFrame.InputEnded:Connect(function(input_1: InputObject) -- line: 129
        -- upvalues:
        --  [1] arg6 (copy)

        if
            input_1.UserInputType == Enum.UserInputType.MouseButton1
            or input_1.UserInputType == Enum.UserInputType.Touch
        then
            arg6:_ClearConnections()
            arg6:SetColor(arg6.Value)
        end
    end)
    arg6.ValueSliderFrame.InputBegan:Connect(function(input_2: InputObject) -- line: 136
        -- upvalues:
        --  [1] arg6 (copy)
        --  [2] RunService (ref)
        --  [3] UILibrary_m (ref)

        if
            input_2.UserInputType == Enum.UserInputType.MouseButton1
            or input_2.UserInputType == Enum.UserInputType.Touch
        then
            arg6:_ClearConnections()
            arg6._color_picker_connection = RunService.RenderStepped:Connect(function() -- line: 140
                -- upvalues:
                --  [1] UILibrary_m (ref)
                --  [2] arg6 (ref)

                local clampedValue_5 = math.clamp(
                    (UILibrary_m:GetMouseLocation().Y - arg6.ValueSliderFrame.AbsolutePosition.Y) / arg6.ValueSliderFrame.AbsoluteSize.Y,
                    0,
                    1
                )
                arg6._ignore_next_cursor_and_slider_update = true
                arg6.Slider.Position = UDim2.new(0.5, 0, clampedValue_5, 0)
                arg6.Slider.Visible = true
                arg6:_UpdateFromCursorAndSlider()
            end)
        end
    end)
    arg6.ValueSliderFrame.InputEnded:Connect(function(input_3: InputObject) -- line: 155
        -- upvalues:
        --  [1] arg6 (copy)

        if
            input_3.UserInputType == Enum.UserInputType.MouseButton1
            or input_3.UserInputType == Enum.UserInputType.Touch
        then
            arg6:_ClearConnections()
            arg6:SetColor(arg6.Value)
        end
    end)
end

function t._Init(arg11) -- line: 164
    arg11.Updated:Connect(function() -- line: 165
        -- upvalues:
        --  [1] arg11 (copy)

        arg11:_UpdateValueColor()
        arg11:_RepositionCursorAndSlider()
    end)
    arg11.Changed:Connect(function() -- line: 170
        -- upvalues:
        --  [1] arg11 (copy)

        arg11:_UpdateValueColor()
        arg11:_RepositionCursorAndSlider()
    end)
    arg11:_Setup()
    arg11:_RepositionCursorAndSlider()
end

return t
