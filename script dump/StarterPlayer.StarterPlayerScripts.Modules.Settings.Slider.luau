local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local _ = game:GetService("GuiService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local _ = require(ReplicatedStorage.Modules.CONSTANTS)
local Signal_m = require(ReplicatedStorage.Modules.Signal)
local ButtonEffect_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("ButtonEffect")
)
local UILibrary_m = require(Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("UILibrary"))
local SettingSlot_m = require(Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("SettingSlot"))
local t = setmetatable({}, SettingSlot_m)
t.__index = t

function t.new(...) -- line: 16
    -- upvalues:
    --  [1] SettingSlot_m (copy)
    --  [2] t (copy)
    --  [3] Signal_m (copy)

    local t_1 = setmetatable(SettingSlot_m.new(...), t)
    t_1.SliderChanged = Signal_m.new()
    t_1.InputBox = t_1.ControlsSettingFrame:WaitForChild("SliderInput"):WaitForChild("Box")
    t_1.ControlsSettingButtonsFrame = t_1.ControlsSettingFrame:WaitForChild("Buttons")
    t_1.IncreaseButton = t_1.ControlsSettingButtonsFrame:WaitForChild("Increase")
    t_1.DecreaseButton = t_1.ControlsSettingButtonsFrame:WaitForChild("Decrease")
    t_1.SliderContainer = t_1.ControlsSettingFrame:WaitForChild("Container")
    t_1.Slider = t_1.SliderContainer:WaitForChild("Slider")
    t_1.Dragger = t_1.Slider:WaitForChild("Dragger")
    t_1._dragging = false
    t_1._dragging_connection = nil
    t_1._console_dragging_connection = nil
    t_1._console_alpha = nil
    t_1._console_drag_velocity = 0
    t_1:_Init()

    return t_1
end

function t.IncreaseValue(arg1, arg2) -- line: 44
    local maximum = math.max(
        1 / arg1.SettingsInfo.Increment,
        (arg1.SettingsInfo.Max - arg1.SettingsInfo.Min) * 0.1
    )
    arg1:InputValue((arg1.SettingsInfo.VerifyInput(arg1.Value + maximum * arg2)))
end

function t.CancelInputs(arg3) -- line: 51
    if arg3._console_dragging_connection then
        arg3:_StopDraggingConsole()

        return
    end

    arg3:_StopDragging()
end

function t.Destroy(arg4) -- line: 59
    -- upvalues:
    --  [1] SettingSlot_m (copy)

    if arg4._dragging_connection then
        arg4._dragging_connection:Disconnect()
        arg4._dragging_connection = nil
    end

    if arg4._console_dragging_connection then
        arg4._console_dragging_connection:Disconnect()
        arg4._console_dragging_connection = nil
    end

    arg4.SliderChanged:Destroy()
    SettingSlot_m.Destroy(arg4)
end

function t._GetDisplayValue(arg5, arg6) -- line: 79
    if arg5.SettingsInfo.IsPercent then
        return math.floor(arg6 * 100 + 0.5) .. "%"
    end

    return arg6
end

function t._UpdateSliderPosition(arg7) -- line: 83
    arg7.SliderContainer.Size = UDim2.new(
        0,
        (arg7.ControlsSettingFrame.AbsolutePosition.X + arg7.ControlsSettingFrame.AbsoluteSize.X - arg7.SettingFrame.AbsolutePosition.X) / arg7.UIScale.Scale,
        0.42,
        0
    )
end

function t._Update(arg8) -- line: 89
    local udim2 = UDim2.new(arg8:_GetAlphaFromValue(arg8.Value), 0, 0.5, 0)
    arg8.InputBox.Text = arg8:_GetDisplayValue(arg8.Value)

    if arg8.Dragger:IsDescendantOf(game) then
        arg8.Dragger:TweenPosition(
            udim2,
            "Out",
            "Quint",
            0.25,
            true
        )

        return
    end

    arg8.Dragger.Position = udim2
end

function t._VerifyInputBox(arg9) -- line: 101
    local v7 = tonumber(arg9.InputBox.Text)
    v7 = arg9.SettingsInfo.VerifyInput(
        if arg9.SettingsInfo.IsPercent then if not v7 then arg9.InputBox.Text else v7 / 100 or arg9.InputBox.Text else arg9.InputBox.Text
    ) or arg9.Value
    arg9.InputBox.Text = arg9:_GetDisplayValue(v7)
    arg9:InputValue(v7)
end

function t._GetAlphaFromValue(arg10, arg11) -- line: 111
    return (arg11 - arg10.SettingsInfo.Min) / (arg10.SettingsInfo.Max - arg10.SettingsInfo.Min)
end

function t._GetAlphaFromMouse(arg12) -- line: 115
    -- upvalues:
    --  [1] UILibrary_m (copy)

    local mouseLocation = UILibrary_m:GetMouseLocation()

    return (math.clamp(
        (mouseLocation.X - arg12.Slider.AbsolutePosition.X) / arg12.Slider.AbsoluteSize.X,
        0,
        1
    ))
end

function t._GetValueFromAlpha(arg13, arg14) -- line: 125
    return (arg13.SettingsInfo.VerifyInput(
        arg13.SettingsInfo.Min + arg14 * (arg13.SettingsInfo.Max - arg13.SettingsInfo.Min)
    ))
end

function t._GetValueFromMouse(arg15) -- line: 132
    return arg15:_GetValueFromAlpha(arg15:_GetAlphaFromMouse())
end

function t._UpdateDrag(arg16) -- line: 136
    local v9 = arg16:_GetValueFromMouse()
    local v10 = arg16:_GetAlphaFromMouse()
    local v11 = (v9 - arg16.SettingsInfo.Min) / (arg16.SettingsInfo.Max - arg16.SettingsInfo.Min)
    local udim2_2 = UDim2.new(v11 + (v10 - v11) * 0.5, 0, 0.5, 0)
    arg16.Dragger:TweenPosition(
        udim2_2,
        "Out",
        "Quint",
        0.25,
        true
    )
    arg16.InputBox.Text = arg16:_GetDisplayValue(v9)
    arg16.SliderChanged:Fire(v9)
end

function t._StartDragging(arg17) -- line: 147
    -- upvalues:
    --  [1] UserInputService (copy)

    if arg17._dragging or tick() < arg17._value_change_cooldown then
        return
    end

    arg17._dragging = true
    arg17._dragging_connection = UserInputService.InputChanged:Connect(function() -- line: 154
        -- upvalues:
        --  [1] arg17 (copy)

        arg17:_UpdateDrag()
    end)
end

function t._StopDragging(arg18) -- line: 159
    if not arg18._dragging then
        return
    end

    arg18._dragging = false

    if arg18._dragging_connection then
        arg18._dragging_connection:Disconnect()
    end

    arg18:InputValue(arg18:_GetValueFromMouse())
end

function t._StartDraggingConsole(arg19) -- line: 173
    -- upvalues:
    --  [1] UserInputService (copy)
    --  [2] RunService (copy)

    if arg19._dragging or tick() < arg19._value_change_cooldown then
        return
    end

    arg19._dragging = true
    arg19._console_alpha = arg19:_GetAlphaFromValue(arg19.Value)
    arg19._dragging_connection = UserInputService.InputChanged:Connect(function(input: InputObject) -- line: 181
        -- upvalues:
        --  [1] arg19 (copy)

        if input.KeyCode ~= Enum.KeyCode.Thumbstick1 then
            return
        end

        if math.abs(input.Position.X) < 0.1 then
            arg19._console_drag_velocity = 0

            return
        end

        arg19._console_drag_velocity = input.Position.X * 0.01
    end)
    arg19._console_dragging_connection = RunService.RenderStepped:Connect(function(
        deltaTime: number
    ) -- line: 193
        -- upvalues:
        --  [1] arg19 (copy)

        arg19._console_alpha = math.clamp(
            arg19._console_alpha + arg19._console_drag_velocity * deltaTime * 60,
            0,
            1
        )
        local v14 = arg19:_GetValueFromAlpha(arg19._console_alpha)
        arg19.Dragger.Position = UDim2.new(arg19._console_alpha, 0, 0.5, 0)
        arg19.InputBox.Text = arg19:_GetDisplayValue(v14)
        arg19.SliderChanged:Fire(v14)
    end)
end

function t._StopDraggingConsole(arg22) -- line: 204
    if not arg22._dragging then
        return
    end

    arg22._dragging = false

    if arg22._dragging_connection then
        arg22._dragging_connection:Disconnect()
    end

    if arg22._console_dragging_connection then
        arg22._console_dragging_connection:Disconnect()
    end

    arg22:InputValue(arg22:_GetValueFromAlpha(arg22._console_alpha))
    arg22._console_alpha = nil
end

function t._Setup(arg23) -- line: 224
    -- upvalues:
    --  [1] UserInputService (copy)

    arg23:ResizeYSize(1.5)
    arg23.Dragger.MouseButton1Down:Connect(function() -- line: 236
        -- upvalues:
        --  [1] arg23 (copy)

        arg23:_StartDragging()
    end)
    table.insert(arg23._connections, UserInputService.InputEnded:Connect(function(
        input_1: InputObject
    ) -- line: 240
        -- upvalues:
        --  [1] arg23 (copy)

        if
            input_1.UserInputType == Enum.UserInputType.MouseButton1
            or input_1.UserInputType == Enum.UserInputType.Touch
        then
            arg23:_StopDragging()
        end
    end))
end

function t._Init(arg25) -- line: 248
    -- upvalues:
    --  [1] ButtonEffect_m (copy)

    arg25.Changed:Connect(function() -- line: 249
        -- upvalues:
        --  [1] arg25 (copy)

        arg25:_Update()
    end)
    arg25.SliderChanged:Connect(function(arg26) -- line: 253
        -- upvalues:
        --  [1] arg25 (copy)

        arg25:_UpdateDetails(arg26)
    end)
    arg25.InputBox.FocusLost:Connect(function() -- line: 257
        -- upvalues:
        --  [1] arg25 (copy)

        arg25:_VerifyInputBox()
    end)
    arg25.IncreaseButton.MouseButton1Click:Connect(function() -- line: 261
        -- upvalues:
        --  [1] arg25 (copy)

        arg25:IncreaseValue(1)
    end)
    arg25.DecreaseButton.MouseButton1Click:Connect(function() -- line: 265
        -- upvalues:
        --  [1] arg25 (copy)

        arg25:IncreaseValue(-1)
    end)
    arg25.IncreaseButton.MouseEnter:Connect(function() -- line: 269
        -- upvalues:
        --  [1] arg25 (copy)

        arg25.IncreaseButton.ZIndex = 1
        arg25.DecreaseButton.ZIndex = 0
    end)
    arg25.DecreaseButton.MouseEnter:Connect(function() -- line: 274
        -- upvalues:
        --  [1] arg25 (copy)

        arg25.IncreaseButton.ZIndex = 0
        arg25.DecreaseButton.ZIndex = 1
    end)
    arg25.SettingFrame:GetPropertyChangedSignal("AbsolutePosition"):Connect(function() -- line: 279
        -- upvalues:
        --  [1] arg25 (copy)

        arg25:_UpdateSliderPosition()
    end)
    arg25.ControlsSettingFrame:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- line: 283
        -- upvalues:
        --  [1] arg25 (copy)

        arg25:_UpdateSliderPosition()
    end)
    arg25.ControlsSettingFrame:GetPropertyChangedSignal("AbsolutePosition"):Connect(function() -- line: 287
        -- upvalues:
        --  [1] arg25 (copy)

        arg25:_UpdateSliderPosition()
    end)
    arg25.UIScale:GetPropertyChangedSignal("Scale"):Connect(function() -- line: 291
        -- upvalues:
        --  [1] arg25 (copy)

        arg25:_UpdateSliderPosition()
    end)
    arg25:_Setup()
    arg25:_Update()
    arg25:_UpdateSliderPosition()
    ButtonEffect_m:Add(arg25.Dragger)
    ButtonEffect_m:Add(arg25.IncreaseButton)
    ButtonEffect_m:Add(arg25.DecreaseButton)
end

return t
