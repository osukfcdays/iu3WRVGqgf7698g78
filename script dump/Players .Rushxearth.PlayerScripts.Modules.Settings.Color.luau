local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local Signal_m = require(ReplicatedStorage.Modules.Signal)
local ColorWheel_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("ColorPicker"):WaitForChild("ColorWheel")
)
local ButtonEffect_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("ButtonEffect")
)
local UILibrary_m = require(Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("UILibrary"))
local SettingSlot_m = require(Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("SettingSlot"))
local t = setmetatable({}, SettingSlot_m)
t.__index = t

function t.new(...) -- line: 15
    -- upvalues:
    --  [1] SettingSlot_m (copy)
    --  [2] t (copy)
    --  [3] Signal_m (copy)
    --  [4] ColorWheel_m (copy)

    local t_1 = setmetatable(SettingSlot_m.new(...), t)
    t_1.SliderChanged = Signal_m.new()
    t_1.EditButton = t_1.ControlsSettingFrame:WaitForChild("Edit")
    t_1.EditButtonBackground = t_1.EditButton:WaitForChild("Background")
    t_1.ColorWheelFrame = t_1.ControlsSettingFrame:WaitForChild("ColorWheel")
    t_1.ColorWheel = ColorWheel_m.new(t_1.ColorWheelFrame)
    t_1._close_connection = nil
    t_1._open_time = 0
    t_1._is_open = false
    t_1:_Init()

    return t_1
end

function t.SetOpen(arg1, arg2) -- line: 40
    -- upvalues:
    --  [1] UserInputService (copy)
    --  [2] UILibrary_m (copy)

    assert(
        if typeof(arg2) ~= "boolean" then false else true,
        "Argument 1 invalid, expected a boolean"
    )
    arg1._is_open = arg2
    arg1.ColorWheelFrame.Visible = arg1._is_open
    arg1.SettingFrame.ZIndex = if arg1._is_open then 999 else 1
    arg1.EditButton.Interactable = not arg1._is_open

    if arg1._close_connection then
        arg1._close_connection:Disconnect()
        arg1._close_connection = nil
    end

    if arg1._is_open then
        arg1._open_time = tick()
        arg1._close_connection = UserInputService.InputEnded:Connect(function(arg3, _) -- line: 56
            -- upvalues:
            --  [1] arg1 (copy)
            --  [2] UILibrary_m (ref)

            if
                tick() - arg1._open_time < 0.25
                or arg3.UserInputType ~= Enum.UserInputType.MouseButton1 and arg3.UserInputType ~= Enum.UserInputType.Touch and arg3.KeyCode ~= Enum.KeyCode.ButtonA
            then
                return
            end

            if not UILibrary_m:IsMouseWithinBounds(
                arg1.ColorWheelFrame.AbsolutePosition,
                arg1.ColorWheelFrame.AbsoluteSize
            ) then
                arg1:SetOpen(false)
            end
        end)
    end
end

function t.SetAlwaysOpen(arg5) -- line: 68
    arg5:SetOpen(true)
    arg5.ColorWheelFrame.Position = UDim2.new(0.325, 0, 0, 0)
end

function t.Destroy(arg6) -- line: 73
    -- upvalues:
    --  [1] SettingSlot_m (copy)

    arg6.ColorWheel:Destroy()
    arg6.SliderChanged:Destroy()
    SettingSlot_m.Destroy(arg6)
end

function t._Update(arg7) -- line: 84
    -- upvalues:
    --  [1] Utility_m (copy)

    arg7.ColorWheel:SetStartingColor(arg7.Value)
    arg7.EditButtonBackground.ImageColor3 = Utility_m:Color3FromHex(arg7.Value)
end

function t._Init(arg8) -- line: 89
    -- upvalues:
    --  [1] ButtonEffect_m (copy)

    arg8.Changed:Connect(function() -- line: 90
        -- upvalues:
        --  [1] arg8 (copy)

        arg8:_Update()
    end)
    arg8.ColorWheel.Updated:Connect(function(arg9, arg10) -- line: 94
        -- upvalues:
        --  [1] arg8 (copy)

        if arg10 then
            arg8:StoreValue(arg9)
        else
            arg8:SetValue(arg9)
        end

        arg8.SliderChanged:Fire(arg9)
    end)
    arg8.EditButton.MouseButton1Click:Connect(function() -- line: 104
        -- upvalues:
        --  [1] arg8 (copy)

        arg8:SetOpen(not arg8._is_open)
    end)
    arg8:_Update()
    ButtonEffect_m:Add(arg8.EditButton)
end

return t
