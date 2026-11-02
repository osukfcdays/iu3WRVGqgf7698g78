local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local GamepadService = game:GetService("GamepadService")
local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")
local CONSTANTS_m = require(ReplicatedStorage.Modules.CONSTANTS)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local Signal_m = require(ReplicatedStorage.Modules.Signal)
local t = {}
local t_1 = { Desktop = "MouseKeyboard", Mobile = "Touch", Console = "Gamepad", VR = "VR" }
t[Enum.UserInputType.MouseButton1] = "MouseKeyboard"
t[Enum.UserInputType.MouseButton2] = "MouseKeyboard"
t[Enum.UserInputType.MouseButton3] = "MouseKeyboard"
t[Enum.UserInputType.Keyboard] = "MouseKeyboard"
t[Enum.UserInputType.Touch] = "Touch"
t[Enum.UserInputType.Gamepad1] = "Gamepad"
t[Enum.UserInputType.Gamepad2] = "Gamepad"
t[Enum.UserInputType.Gamepad3] = "Gamepad"
t[Enum.UserInputType.Gamepad4] = "Gamepad"
t[Enum.UserInputType.Gamepad5] = "Gamepad"
t[Enum.UserInputType.Gamepad6] = "Gamepad"
t[Enum.UserInputType.Gamepad7] = "Gamepad"
t[Enum.UserInputType.Gamepad8] = "Gamepad"
local t_2 = {}
t_2[Enum.KeyCode.W] = "MouseKeyboard"
t_2[Enum.KeyCode.A] = "MouseKeyboard"
t_2[Enum.KeyCode.S] = "MouseKeyboard"
t_2[Enum.KeyCode.D] = "MouseKeyboard"
local t_3 = {
    ["Mouse & Keyboard"] = "MouseKeyboard",
    ["Touch Buttons"] = "Touch",
    Controller = "Gamepad"
}
local t_4 = {}
t_4.__index = t_4

function t_4._new() -- line: 35
    -- upvalues:
    --  [1] t_4 (copy)
    --  [2] Signal_m (copy)
    --  [3] t_1 (copy)
    --  [4] CONSTANTS_m (copy)

    local t_5 = setmetatable({}, t_4)
    t_5.ControlsChanged = Signal_m.new()
    t_5.CurrentControls = t_1[CONSTANTS_m.DEVICE]
    t_5._toggled_inputs = {}
    t_5._is_verification_disabled = false
    t_5._set_controls_hash = 0
    t_5._control_scheme_setting = nil
    t_5:_Init()

    return t_5
end

function t_4.IsInputDown(arg1, arg2) -- line: 57
    -- upvalues:
    --  [1] UserInputService (copy)

    local v1

    if arg2.EnumType == Enum.KeyCode then
        v1 = UserInputService:IsKeyDown(arg2)

        if not v1 then
            if arg2.EnumType == Enum.UserInputType then
                v1 = UserInputService:IsMouseButtonPressed(arg2)

                if not v1 then
                    v1 = if arg2.EnumType == Enum.KeyCode then if arg1.CurrentControls ~= "Gamepad" then arg1.CurrentControls == "VR" and UserInputService:IsGamepadButtonDown(
                        UserInputService:GetLastInputType(),
                        arg2
                    ) or arg1:IsToggled(arg2) else UserInputService:IsGamepadButtonDown(
                        UserInputService:GetLastInputType(),
                        arg2
                    ) or arg1:IsToggled(arg2) else arg1:IsToggled(arg2)
                end
            else
                v1 = if arg2.EnumType == Enum.KeyCode then if arg1.CurrentControls ~= "Gamepad" then arg1.CurrentControls == "VR" and UserInputService:IsGamepadButtonDown(
                    UserInputService:GetLastInputType(),
                    arg2
                ) or arg1:IsToggled(arg2) else UserInputService:IsGamepadButtonDown(
                    UserInputService:GetLastInputType(),
                    arg2
                ) or arg1:IsToggled(arg2) else arg1:IsToggled(arg2)
            end
        end
    elseif arg2.EnumType == Enum.UserInputType then
        v1 = UserInputService:IsMouseButtonPressed(arg2)

        if not v1 then
            v1 = if arg2.EnumType == Enum.KeyCode then if arg1.CurrentControls ~= "Gamepad" then arg1.CurrentControls == "VR" and UserInputService:IsGamepadButtonDown(
                UserInputService:GetLastInputType(),
                arg2
            ) or arg1:IsToggled(arg2) else UserInputService:IsGamepadButtonDown(
                UserInputService:GetLastInputType(),
                arg2
            ) or arg1:IsToggled(arg2) else arg1:IsToggled(arg2)
        end
    else
        v1 = if arg2.EnumType == Enum.KeyCode then if arg1.CurrentControls ~= "Gamepad" then arg1.CurrentControls == "VR" and UserInputService:IsGamepadButtonDown(
            UserInputService:GetLastInputType(),
            arg2
        ) or arg1:IsToggled(arg2) else UserInputService:IsGamepadButtonDown(
            UserInputService:GetLastInputType(),
            arg2
        ) or arg1:IsToggled(arg2) else arg1:IsToggled(arg2)
    end

    return v1
end

function t_4.IsToggled(arg3, arg4) -- line: 65
    return arg3._toggled_inputs[arg4]
end

function t_4.ToggleInput(arg5, arg6, arg7) -- line: 70
    arg5._toggled_inputs[arg6] = arg7 or nil
end

function t_4.SetControls(arg8, arg9) -- line: 74
    -- upvalues:
    --  [1] t_3 (copy)

    arg9 = if not arg8._control_scheme_setting then arg9 else if arg8._control_scheme_setting == "Automatic" then arg9 else t_3[arg8._control_scheme_setting] or arg9

    if not arg9 or arg9 == arg8.CurrentControls or arg9 == "VR" or arg8.CurrentControls == "VR" then
        return
    end

    arg8._set_controls_hash += 1
    local SetControlsHash = arg8._set_controls_hash
    task.defer(function() -- line: 90
        -- upvalues:
        --  [1] SetControlsHash (copy)
        --  [2] arg8 (copy)
        --  [3] arg9 (ref)

        if SetControlsHash ~= arg8._set_controls_hash then
            return
        end

        arg8.CurrentControls = arg9
        arg8.ControlsChanged:Fire()
    end)
end

function t_4.DisableVerification(arg10, arg11) -- line: 100
    arg10._is_verification_disabled = arg11
end

function t_4._ProcessInput(arg12, arg13, arg14) -- line: 108
    -- upvalues:
    --  [1] Utility_m (copy)
    --  [2] GamepadService (copy)
    --  [3] GuiService (copy)
    --  [4] t (copy)
    --  [5] t_2 (copy)

    if
        arg12._is_verification_disabled
        or arg14
        or Utility_m:IsTextBoxFocused()
        or GamepadService.GamepadCursorEnabled
        or GuiService.SelectedObject
        or (arg13.KeyCode == Enum.KeyCode.Thumbstick1 or arg13.KeyCode == Enum.KeyCode.Thumbstick2) and (arg13.Position * Vector3.new(1, 1, 0)).Magnitude < 0.75
    then
        return
    end

    arg12:SetControls(t[arg13.UserInputType] or t_2[arg13.KeyCode])
end

function t_4._SetupControlSchemeSetting(arg15) -- line: 126
    -- upvalues:
    --  [1] Players (copy)

    local PlayerDataController_m = require(
        Players.LocalPlayer.PlayerScripts.Controllers.PlayerDataController
    )

    local function verify() -- line: 129
        -- upvalues:
        --  [1] arg15 (copy)
        --  [2] PlayerDataController_m (copy)

        arg15._control_scheme_setting = PlayerDataController_m:GetSetting("Control Scheme")
        arg15:SetControls(arg15.CurrentControls)
    end

    PlayerDataController_m:GetSettingChangedSignal("Control Scheme"):Connect(verify)
    task.defer(verify)
end

function t_4._Init(arg16) -- line: 138
    -- upvalues:
    --  [1] UserInputService (copy)

    UserInputService.InputBegan:Connect(function(...) -- line: 139
        -- upvalues:
        --  [1] arg16 (copy)

        arg16:_ProcessInput(...)
    end)
    UserInputService.InputChanged:Connect(function(...) -- line: 143
        -- upvalues:
        --  [1] arg16 (copy)

        arg16:_ProcessInput(...)
    end)
    UserInputService.InputEnded:Connect(function(...) -- line: 147
        -- upvalues:
        --  [1] arg16 (copy)

        arg16:_ProcessInput(...)
    end)
    task.defer(arg16._SetupControlSchemeSetting, arg16)
end

return t_4._new()
