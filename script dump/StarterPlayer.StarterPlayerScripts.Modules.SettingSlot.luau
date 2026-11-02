local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Signal_m = require(ReplicatedStorage.Modules.Signal)
local ButtonEffect_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("ButtonEffect")
)
local SettingFrame = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("SettingFrame")
local t = {}
t.__index = t

function t.new(arg1, arg2) -- line: 13
    -- upvalues:
    --  [1] t (copy)
    --  [2] Signal_m (copy)
    --  [3] SettingFrame (copy)

    assert(not arg2, "TEMPLATES NO LONGER SUPPORTED")
    local t_1 = setmetatable({}, t)
    t_1.Changed = Signal_m.new()
    t_1.Replicate = Signal_m.new()
    t_1.Hovered = Signal_m.new()
    t_1.SettingFrame = SettingFrame:Clone()
    t_1.UIScale = t_1.SettingFrame:WaitForChild("UIScale")
    t_1.Background = t_1.SettingFrame:WaitForChild("Background")
    t_1.BackgroundGradient = t_1.Background:WaitForChild("UIGradient")
    t_1.Container = t_1.SettingFrame:WaitForChild("Container")
    t_1.DetailsFrame = t_1.Container:WaitForChild("Details")
    t_1.DetailsIconFrame = t_1.DetailsFrame:WaitForChild("Icon")
    t_1.DetailsIconLabel = t_1.DetailsIconFrame:WaitForChild("Icon")
    t_1.DetailsResetButton = t_1.DetailsIconFrame:WaitForChild("Reset")
    t_1.DetailsDisplayFrame = t_1.DetailsFrame:WaitForChild("Display")
    t_1.DetailsDisplayDescription = t_1.DetailsDisplayFrame:WaitForChild("Description")
    t_1.DetailsDisplayTitleContainer = t_1.DetailsDisplayFrame:WaitForChild("TitleContainer")
    t_1.DetailsDisplayTitleIcon = t_1.DetailsDisplayTitleContainer:WaitForChild("Icon")
    t_1.DetailsDisplayTitleText = t_1.DetailsDisplayTitleContainer:WaitForChild("Title")
    t_1.ControlsFrame = t_1.Container:WaitForChild("Controls")
    t_1.ControlsConfirmFrame = t_1.ControlsFrame:WaitForChild("Confirm")
    t_1.ControlsConfirmButton = t_1.ControlsConfirmFrame:WaitForChild("Button")
    t_1.ControlsContainer = t_1.ControlsFrame:WaitForChild("Container")
    t_1.ControlsSettingFrame = nil
    t_1.SettingsInfo = arg1
    t_1.Value = arg1.DefaultValue
    t_1._connections = {}
    t_1._value_change_cooldown = 0
    t_1._description_override = nil
    t_1:_Init()

    return t_1
end

function t.GetSelection(arg3) -- line: 58
    return arg3.ControlsSettingFrame
end

function t.Scale(arg4, arg5) -- line: 62
    arg4.UIScale.Scale = arg5
end

function t.ResizeYSize(arg6, arg7) -- line: 66
    arg6.SettingFrame.Size = UDim2.new(
        arg6.SettingFrame.Size.X.Scale,
        arg6.SettingFrame.Size.X.Offset,
        arg6.SettingFrame.Size.Y.Scale * arg7,
        arg6.SettingFrame.Size.Y.Offset * arg7
    )
    arg6.Container.Size = UDim2.new(1, 0, 1 / arg7, 0)
end

function t.OverrideDescription(arg8, arg9) -- line: 71
    arg8._description_override = arg9
    arg8:_UpdateDetails()
end

function t.SetSettingsInfo(arg10, arg11) -- line: 76
    arg10.SettingsInfo = arg11
    arg10:_UpdateDetails()
end

function t.SetValue(arg12, arg13, arg14, arg15) -- line: 81
    if if arg12.SettingsInfo.InputType == "Hotkey" then not arg15 and tick() < arg12._value_change_cooldown else arg13 == nil or not arg15 and tick() < arg12._value_change_cooldown then
        return
    end

    arg12.Value = arg13
    arg12.Changed:Fire(arg12.Value)

    if not arg14 then
        arg12._value_change_cooldown = tick() + 0.05
        arg12.Replicate:Fire(arg12.Value)
    end
end

function t.StoreValue(arg16, arg17) -- line: 95
    arg16.Value = arg17
    arg16.Changed:Fire(arg16.Value)
end

function t.InputValue(arg18, ...) -- line: 100
    if arg18.SettingsInfo.IsConfirmSetting then
        arg18:StoreValue(...)

        return
    end

    arg18:SetValue(...)
end

function t.CancelInputs(_) -- line: 108
end

function t.Destroy(arg20) -- line: 112
    for _, val in pairs(arg20._connections) do
        val:Disconnect()
    end

    arg20.Changed:Destroy()
    arg20.Replicate:Destroy()
    arg20.Hovered:Destroy()
    arg20.SettingFrame:Destroy()
end

function t._Confirm(arg21) -- line: 127
    arg21:SetValue(arg21.Value, nil, true)
end

function t._UpdateDetails(arg22, arg23) -- line: 131
    local v2 = arg23 or arg22.Value
    local v3 = arg22._description_override
    local DetailsDisplayDescription = arg22.DetailsDisplayDescription
    v3 = v3 or arg22.SettingsInfo.Description
    DetailsDisplayDescription.Text = v3
    local DetailsDisplayTitleContainer = arg22.DetailsDisplayTitleContainer
    v3 = if arg22.DetailsDisplayDescription.Text ~= "" then arg22.DetailsDisplayTitleContainer.Position else UDim2.new(
        arg22.DetailsDisplayTitleContainer.Position.X.Scale,
        arg22.DetailsDisplayTitleContainer.Position.X.Offset,
        0.5,
        0
    )
    DetailsDisplayTitleContainer.Position = v3
    local DetailsResetButton = arg22.DetailsResetButton
    v3 = if arg22.SettingsInfo.InputType == "Divider" then false else v2 ~= arg22.SettingsInfo.DefaultValue
    DetailsResetButton.Visible = v3
    v3 = false
    local DetailsIconLabel = arg22.DetailsIconLabel

    if arg22.DetailsIconLabel.Image ~= "" then
        v3 = not arg22.DetailsResetButton.Visible
    end

    DetailsIconLabel.Visible = v3
    v3 = not arg22.ControlsConfirmFrame.Visible
    local DetailsIconFrame = arg22.DetailsIconFrame
    v3 = v3 and (arg22.DetailsIconLabel.Visible or arg22.DetailsResetButton.Visible)
    DetailsIconFrame.Visible = v3
    local DetailsDisplayTitleIcon = arg22.DetailsDisplayTitleIcon
    v3 = if arg22.DetailsDisplayTitleIcon.Image == "" then false else not arg22.DetailsIconFrame.Visible or not arg22.DetailsIconLabel.Visible
    DetailsDisplayTitleIcon.Visible = v3
end

function t._Setup(arg24) -- line: 142
    arg24.DetailsIconLabel.Image = arg24.SettingsInfo.Image
    arg24.DetailsDisplayTitleIcon.Image = arg24.SettingsInfo.Image
    arg24.DetailsDisplayTitleText.Text = arg24.SettingsInfo.DisplayName
    arg24.ControlsConfirmFrame.Visible = arg24.SettingsInfo.IsConfirmSetting

    for _, child in pairs(arg24.ControlsContainer:GetChildren()) do
        if child.Name == arg24.SettingsInfo.InputType then
            child.Visible = true
            arg24.ControlsSettingFrame = child
        else
            child.Visible = false
            pcall(task.defer, child.Destroy, child)
        end
    end
end

function t._Init(arg25) -- line: 159
    -- upvalues:
    --  [1] ButtonEffect_m (copy)

    arg25.Changed:Connect(function() -- line: 160
        -- upvalues:
        --  [1] arg25 (copy)

        arg25:_UpdateDetails()
    end)
    arg25.SettingFrame.MouseEnter:Connect(function() -- line: 164
        -- upvalues:
        --  [1] arg25 (copy)

        arg25.Hovered:Fire()
    end)
    arg25.SettingFrame.SelectionChanged:Connect(function(arg26) -- line: 168
        -- upvalues:
        --  [1] arg25 (copy)

        if arg26 then
            arg25.Hovered:Fire()
        end
    end)
    arg25.DetailsResetButton.MouseButton1Click:Connect(function() -- line: 174
        -- upvalues:
        --  [1] arg25 (copy)

        arg25:SetValue(arg25.SettingsInfo.DefaultValue)
    end)
    arg25.ControlsConfirmButton.MouseButton1Click:Connect(function() -- line: 178
        -- upvalues:
        --  [1] arg25 (copy)

        arg25:_Confirm()
    end)
    arg25:_Setup()
    arg25:_UpdateDetails()
    ButtonEffect_m:Add(arg25.DetailsResetButton)
    task.defer(ButtonEffect_m.Add, ButtonEffect_m, arg25.ControlsConfirmButton)
end

return t
