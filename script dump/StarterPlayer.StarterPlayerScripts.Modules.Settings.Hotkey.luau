local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local ControlsController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("ControlsController")
)
local ButtonEffect_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("ButtonEffect")
)
local SettingSlot_m = require(Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("SettingSlot"))
local t = setmetatable({}, SettingSlot_m)
t.__index = t

function t.new(...) -- line: 12
    -- upvalues:
    --  [1] SettingSlot_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(SettingSlot_m.new(...), t)
    t_1.HotkeyContainer = t_1.ControlsSettingFrame:WaitForChild("Container")
    t_1.HotkeyBackground = t_1.HotkeyContainer:WaitForChild("Background")
    t_1.HotkeyButton = t_1.HotkeyContainer:WaitForChild("Button")
    t_1.HotkeyValueText = t_1.HotkeyContainer:WaitForChild("Value")
    t_1._destroyed = false
    t_1._listening = false
    t_1._listen_connections = {}
    t_1:_Init()

    return t_1
end

function t.GetSelection(arg1) -- line: 33
    return arg1.HotkeyButton
end

function t.Destroy(arg2) -- line: 37
    -- upvalues:
    --  [1] SettingSlot_m (copy)

    arg2._destroyed = true

    for _, val in pairs(arg2._listen_connections) do
        val:Disconnect()
    end

    SettingSlot_m.Destroy(arg2)
end

function t._Update(arg3) -- line: 51
    arg3:_StopListening()
    local HotkeyValueText = arg3.HotkeyValueText
    HotkeyValueText.Text = typeof(arg3.Value) == "EnumItem" and arg3.Value.Name or arg3.Value or ""
end

function t._Input(arg4, arg5) -- line: 56
    arg4:_StopListening()
    arg4:SetValue(arg4.SettingsInfo.VerifyInput(arg5))
end

function t._StartListening(arg6) -- line: 61
    -- upvalues:
    --  [1] UserInputService (copy)

    if arg6._listening or arg6._destroyed then
        return
    end

    arg6._listening = true
    table.insert(arg6._listen_connections, UserInputService.InputBegan:Connect(function(
        input: InputObject
    ) -- line: 68
        -- upvalues:
        --  [1] arg6 (copy)

        arg6:_Input(
            if input.KeyCode ~= Enum.KeyCode.Unknown then input.KeyCode.Name else input.UserInputType.Name
        )
    end))
    table.insert(arg6._listen_connections, UserInputService.InputChanged:Connect(function(_) -- line: 72
    end))
    arg6.HotkeyBackground.ImageColor3 = Color3.fromRGB(127, 127, 127)
    arg6.HotkeyValueText.TextStrokeColor3 = Color3.fromRGB(64, 64, 64)
    arg6.HotkeyValueText.Text = "\226\128\162 \226\128\162 \226\128\162"
end

function t._StopListening(arg9) -- line: 81
    if not arg9._listening then
        return
    end

    arg9._listening = false

    for _, val_1 in pairs(arg9._listen_connections) do
        val_1:Disconnect()
    end

    arg9.HotkeyBackground.ImageColor3 = Color3.fromRGB(0, 150, 255)
    arg9.HotkeyValueText.TextStrokeColor3 = Color3.fromRGB(0, 75, 127)
end

function t._Setup(arg10) -- line: 96
    arg10.HotkeyButton.NextSelectionRight = arg10.HotkeyButton
    arg10.HotkeyButton.NextSelectionLeft = arg10.HotkeyButton
end

function t._Init(arg11) -- line: 101
    -- upvalues:
    --  [1] RunService (copy)
    --  [2] ControlsController_m (copy)
    --  [3] ButtonEffect_m (copy)

    arg11.Changed:Connect(function() -- line: 102
        -- upvalues:
        --  [1] arg11 (copy)

        arg11:_Update()
    end)
    arg11.HotkeyButton.MouseButton1Click:Connect(function() -- line: 106
        -- upvalues:
        --  [1] RunService (ref)
        --  [2] ControlsController_m (ref)
        --  [3] arg11 (copy)

        RunService.Heartbeat:Wait()

        if ControlsController_m.CurrentControls == "Touch" then
            return
        end

        arg11:_StartListening()
    end)
    arg11:_Setup()
    arg11:_Update()
    ButtonEffect_m:Add(arg11.HotkeyButton, true)
end

return t
