local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local GamepadService = game:GetService("GamepadService")
local RunService = game:GetService("RunService")
local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")
local PermissionsLibrary_m = require(ReplicatedStorage.Modules.PermissionsLibrary)
local SettingsLibrary_m = require(ReplicatedStorage.Modules.SettingsLibrary)
local BountyLibrary_m = require(ReplicatedStorage.Modules.BountyLibrary)
local InputLibrary_m = require(ReplicatedStorage.Modules.InputLibrary)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local Signal_m = require(ReplicatedStorage.Modules.Signal)
local PlayerDataController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("PlayerDataController")
)
local SettingsController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("SettingsController")
)
local Inset_m = require(
    Players.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("Inset")
)
local ButtonEffect_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("ButtonEffect")
)
local UILibrary_m = require(Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("UILibrary"))
local SettingInputHotkeysDivider = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild(
    "SettingInputHotkeysDivider"
)
local SettingInputHotkeysSlot = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild(
    "SettingInputHotkeysSlot"
)
local SettingHotkeySlot = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild(
    "SettingHotkeySlot"
)
local Settings = Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("Settings")
local t = {}
t.__index = t

function t.new(arg1) -- line: 34
    -- upvalues:
    --  [1] t (copy)
    --  [2] Signal_m (copy)

    local t_1 = setmetatable({}, t)
    t_1.Hovered = Signal_m.new()
    t_1.ResetSettings = Signal_m.new()
    t_1.Page = arg1
    t_1.Frame = t_1.Page.Container:WaitForChild("Settings")
    t_1.WaitingFrame = t_1.Frame:WaitForChild("Waiting")
    t_1.DotsFrame = t_1.WaitingFrame:WaitForChild("Dots")
    t_1.Container = t_1.Frame:WaitForChild("Container")
    t_1.HotkeyHeaderFrame = t_1.Container:WaitForChild("HotkeyHeader")
    t_1.List = t_1.Container:WaitForChild("List")
    t_1.Container = t_1.List:WaitForChild("Container")
    t_1.Layout = t_1.Container:WaitForChild("Layout")
    t_1.HotkeyTopFrame = t_1.Container:WaitForChild("HotkeyTop")
    t_1.HotkeyBottomFrame = t_1.Container:WaitForChild("HotkeyBottom")
    t_1.ResetDefaultFrame = t_1.Container:WaitForChild("ResetDefault")
    t_1.ResetDefaultContainer = t_1.ResetDefaultFrame:WaitForChild("Container")
    t_1.ResetDefaultButton = t_1.ResetDefaultContainer:WaitForChild("Controls"):WaitForChild(
        "Confirm"
    ):WaitForChild("Button")
    t_1.ResetDefaultDescription = t_1.ResetDefaultContainer:WaitForChild("Details"):WaitForChild(
        "Display"
    ):WaitForChild("Description")
    t_1.MobileEditorFrame = t_1.Container:WaitForChild("MobileEditor")
    t_1.MobileEditorButton = t_1.MobileEditorFrame:WaitForChild("Container"):WaitForChild(
        "Controls"
    ):WaitForChild("Confirm"):WaitForChild("Button")
    t_1.SettingObjects = {}
    t_1._setting_objects_by_section = {}
    t_1._input_hotkeys_slots = {}
    t_1._is_listening_for_hotkey = false
    t_1._last_reset_click = 0
    t_1:_Init()

    return t_1
end

function t.SetPage(arg2, arg3) -- line: 74
    local Frame = arg2.Frame
    Frame.Size = if arg3 ~= "Hotkeys" then UDim2.new(0.5, 0, 0.9, 0) else UDim2.new(0.85, 0, 0.9, 0)
    local List = arg2.List
    List.Position = if arg3 ~= "Hotkeys" then UDim2.new(0.5, 0, 0, 0) else UDim2.new(
        0.5,
        0,
        0.075,
        0
    )
    arg2.List.CanvasPosition = Vector2.zero
    local Layout = arg2.Layout
    Layout.Padding = if arg3 ~= "Hotkeys" then UDim.new(0.01, 0) else UDim.new(0, 0)
    local HotkeyHeaderFrame = arg2.HotkeyHeaderFrame
    HotkeyHeaderFrame.Visible = arg3 == "Hotkeys"
    local HotkeyTopFrame = arg2.HotkeyTopFrame
    HotkeyTopFrame.Visible = arg3 == "Hotkeys"
    local HotkeyBottomFrame = arg2.HotkeyBottomFrame
    HotkeyBottomFrame.Visible = arg3 == "Hotkeys"
    local ResetDefaultFrame = arg2.ResetDefaultFrame
    ResetDefaultFrame.Size = if arg3 ~= "Hotkeys" then UDim2.new(1, 0, 0.2, 0) else UDim2.new(
        1,
        0,
        0.11764705882352942,
        0
    )
    arg2.ResetDefaultContainer.Size = if arg3 == "Hotkeys" then UDim2.new(
        0.5882352941176471,
        0,
        0.6,
        0
    ) else UDim2.new(1, 0, 0.6, 0)
    arg2.ResetDefaultDescription.Text = string.format(
        "Double tap to reset your %s settings back to default",
        arg3 or "???"
    )
    local MobileEditorFrame = arg2.MobileEditorFrame
    MobileEditorFrame.Visible = arg3 == "Touch"

    for key, val in pairs(arg2._setting_objects_by_section) do
        for _, val_1 in pairs(val) do
            local SettingFrame = val_1.SettingFrame
            local v8 = if arg3 ~= key then nil else arg2.Container
            SettingFrame.Parent = v8
        end
    end

    for _, val_2 in pairs(arg2._input_hotkeys_slots) do
        local v9 = if arg3 ~= "Hotkeys" then nil else arg2.Container
        val_2.Parent = v9
    end
end

function t.Close(arg4) -- line: 98
    for _, val_3 in pairs(arg4.SettingObjects) do
        if val_3.SettingsInfo.InputType == "Color" then
            val_3:SetOpen(false)
            val_3:CancelInputs(false)
        end
    end
end

function t._UpdateSize(arg5) -- line: 111
    -- upvalues:
    --  [1] UILibrary_m (copy)

    arg5.List.Size = UDim2.new(
        1,
        0,
        0,
        UILibrary_m.MainGui.AbsolutePosition.Y + UILibrary_m.MainGui.AbsoluteSize.Y - arg5.List.AbsolutePosition.Y
    )
end

function t._GenerateHotkeys(arg6) -- line: 115
    -- upvalues:
    --  [1] SettingsLibrary_m (copy)
    --  [2] SettingInputHotkeysDivider (copy)
    --  [3] InputLibrary_m (copy)
    --  [4] SettingInputHotkeysSlot (copy)
    --  [5] PlayerDataController_m (copy)
    --  [6] SettingsController_m (copy)
    --  [7] ButtonEffect_m (copy)
    --  [8] Utility_m (copy)
    --  [9] UserInputService (copy)
    --  [10] GamepadService (copy)
    --  [11] GuiService (copy)
    --  [12] SettingHotkeySlot (copy)
    --  [13] RunService (copy)

    local v11

    for key_4, val_4 in pairs(SettingsLibrary_m.HOTKEYS_GUIDE) do
        local v10 = key_4 % 2 == 0

        if val_4 == "Divider" then
            v11 = SettingInputHotkeysDivider:Clone()
            v11.AlternateBackground.Visible = v10
            v11.LayoutOrder = key_4
            v11.Parent = arg6.Container
            table.insert(arg6._input_hotkeys_slots, v11)
        else
            v11 = InputLibrary_m.Inputs[val_4]
            local t_6 = {}
            local v13 = SettingInputHotkeysSlot:Clone()
            v13.AlternateBackground.Visible = v10
            v13.Title.Text = v11.DisplayName
            v13.Icon.Image = v11.Image
            v13.LayoutOrder = key_4
            table.insert(arg6._input_hotkeys_slots, v13)

            local function v11() --[[ update_reset_button ]] -- line: 138
                -- upvalues:
                --  [1] t_6 (copy)
                --  [2] PlayerDataController_m (ref)
                --  [3] SettingsLibrary_m (ref)
                --  [4] v13 (copy)

                local v14 = false

                for _, val_5 in pairs(t_6) do
                    if PlayerDataController_m:GetSetting(val_5[2]) ~= SettingsLibrary_m.Info[val_5[2]].DefaultValue then
                        v14 = true
                        break
                    end
                end

                v13.Reset.Visible = v14
                local Icon = v13.Icon
                Icon.Position = if not v14 then UDim2.new(0.1, 0, 0.5, 0) else UDim2.new(
                    0.15,
                    0,
                    0.5,
                    0
                )
                local Title = v13.Title
                Title.Position = if not v14 then UDim2.new(0.125, 0, 0.5, 0) else UDim2.new(
                    0.175,
                    0,
                    0.5,
                    0
                )
            end

            v13.Reset.MouseButton1Click:Connect(function() -- line: 153
                -- upvalues:
                --  [1] t_6 (copy)
                --  [2] SettingsLibrary_m (ref)
                --  [3] SettingsController_m (ref)

                local t_2 = {}

                for _, val_6 in pairs(t_6) do
                    table.insert(t_2, { val_6[2], SettingsLibrary_m.Info[val_6[2]].DefaultValue })
                end

                SettingsController_m:ChangeSettings(t_2)
            end)
            ButtonEffect_m:Add(v13.Reset)

            function v10(arg7, arg8) --[[ setup ]] -- line: 165
                -- upvalues:
                --  [1] SettingsLibrary_m (ref)
                --  [2] Utility_m (ref)
                --  [3] PlayerDataController_m (ref)
                --  [4] arg6 (copy)
                --  [5] SettingsController_m (ref)
                --  [6] UserInputService (ref)
                --  [7] GamepadService (ref)
                --  [8] GuiService (ref)
                --  [9] v11 (copy)

                local t_4 = {}
                local v17 = nil

                local function set_text(arg9) -- line: 171
                    -- upvalues:
                    --  [1] v17 (ref)
                    --  [2] Utility_m (ref)
                    --  [3] arg7 (copy)

                    if arg9 == v17 then
                        return
                    end

                    v17 = arg9
                    local v18 = arg9

                    if v18 then
                        v18 = Utility_m:GetInputEnumFromName(arg9)
                    end

                    arg7.Listening.Visible = false
                    arg7.Keybind.Visible = true
                    arg7.Keybind:RemoveTag("UIKeybindContainer")

                    if v18 then
                        arg7.Keybind:SetAttribute("EnumType", (tostring(v18.EnumType)))
                        arg7.Keybind:SetAttribute("EnumName", arg9)
                        arg7.Keybind:AddTag("UIKeybindContainer")
                    end
                end

                local function set_action_buttons_visible(arg10) -- line: 190
                    -- upvalues:
                    --  [1] PlayerDataController_m (ref)
                    --  [2] arg8 (copy)
                    --  [3] arg7 (copy)

                    local v19 = if PlayerDataController_m:GetSetting(arg8) == "nil" then false else true
                    local Edit = arg7.Edit
                    Edit.Size = v19 and UDim2.new(0.5, 0, 1, 0) or UDim2.new(1, 0, 1, 0)
                    arg7.Edit.BackgroundHalf.Visible = v19
                    arg7.Edit.BackgroundFull.Visible = not v19
                    arg7.Edit.Visible = arg10
                    arg7.Unbind.Visible = v19 and arg10
                end

                local function clear_listen_connections() -- line: 200
                    -- upvalues:
                    --  [1] t_4 (ref)
                    --  [2] arg6 (ref)

                    for _, val_7 in pairs(t_4) do
                        val_7:Disconnect()
                    end

                    t_4 = {}
                    arg6._is_listening_for_hotkey = false
                end

                local _ = function(arg11) --[[ input_value ]] -- line: 209
                    -- upvalues:
                    --  [1] clear_listen_connections (copy)
                    --  [2] arg7 (copy)
                    --  [3] v17 (ref)
                    --  [4] set_text (copy)
                    --  [5] SettingsController_m (ref)
                    --  [6] arg8 (copy)

                    clear_listen_connections()
                    arg7.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                    v17 = nil
                    set_text(arg11)
                    SettingsController_m:ChangeSetting(arg8, arg11)
                end

                local v22 = SettingsLibrary_m.Info[arg8]
                arg7.Edit.MouseButton1Click:Connect(function() -- line: 219
                    -- upvalues:
                    --  [1] set_action_buttons_visible (copy)
                    --  [2] clear_listen_connections (copy)
                    --  [3] arg6 (ref)
                    --  [4] v17 (ref)
                    --  [5] t_4 (ref)
                    --  [6] UserInputService (ref)
                    --  [7] GamepadService (ref)
                    --  [8] GuiService (ref)
                    --  [9] v22 (copy)
                    --  [10] arg7 (copy)
                    --  [11] set_text (copy)
                    --  [12] SettingsController_m (ref)
                    --  [13] arg8 (copy)

                    set_action_buttons_visible(false)
                    clear_listen_connections()
                    arg6._is_listening_for_hotkey = true
                    v17 = nil
                    table.insert(t_4, UserInputService.InputBegan:Connect(function(
                        input: InputObject
                    ) -- line: 226
                        -- upvalues:
                        --  [1] GamepadService (ref)
                        --  [2] GuiService (ref)
                        --  [3] v22 (ref)
                        --  [4] clear_listen_connections (ref)
                        --  [5] arg7 (ref)
                        --  [6] v17 (ref)
                        --  [7] set_text (ref)
                        --  [8] SettingsController_m (ref)
                        --  [9] arg8 (ref)

                        local Name = if input.UserInputType ~= Enum.UserInputType.MouseButton1 then if input.KeyCode ~= Enum.KeyCode.Unknown then input.KeyCode.Name else input.UserInputType.Name else if GamepadService.GamepadCursorEnabled then Enum.KeyCode.ButtonR2.Name else if not GuiService.SelectedObject then if input.KeyCode ~= Enum.KeyCode.Unknown then input.KeyCode.Name else input.UserInputType.Name else Enum.KeyCode.ButtonR2.Name
                        local v24 = v22.VerifyInput(Name)
                        clear_listen_connections()
                        arg7.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                        v17 = nil
                        set_text(v24)
                        SettingsController_m:ChangeSetting(arg8, v24)
                    end))
                    arg7.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    arg7.Keybind.Visible = false
                    arg7.Listening.Visible = true
                    GuiService.SelectedObject = nil
                end)
                arg7.Unbind.MouseButton1Click:Connect(function() -- line: 246
                    -- upvalues:
                    --  [1] set_action_buttons_visible (copy)
                    --  [2] SettingsController_m (ref)
                    --  [3] arg8 (copy)

                    set_action_buttons_visible(false)
                    SettingsController_m:ChangeSetting(arg8, nil)
                end)
                arg7.MouseEnter:Connect(function() -- line: 251
                    -- upvalues:
                    --  [1] t_4 (ref)
                    --  [2] set_action_buttons_visible (copy)

                    if #t_4 == 0 then
                        set_action_buttons_visible(true)
                    end
                end)
                arg7.MouseLeave:Connect(function() -- line: 257
                    -- upvalues:
                    --  [1] set_action_buttons_visible (copy)

                    set_action_buttons_visible(false)
                end)

                local function update() -- line: 261
                    -- upvalues:
                    --  [1] set_text (copy)
                    --  [2] PlayerDataController_m (ref)
                    --  [3] arg8 (copy)
                    --  [4] v11 (ref)

                    set_text(PlayerDataController_m:GetSetting(arg8))
                    v11()
                end

                PlayerDataController_m:GetSettingChangedSignal(arg8):Connect(update)
                set_text(PlayerDataController_m:GetSetting(arg8))
                v11()
            end

            for key_8, val_8 in pairs(InputLibrary_m.HOTKEY_FORMATS) do
                for key_9, val_9 in pairs(val_8) do
                    local v29 = v13[key_8 .. key_9]
                    local formattedText = string.format(val_9, val_4)
                    local v30 = SettingHotkeySlot:Clone()
                    v30.Listening.Visible = false
                    v30.Edit.Visible = false
                    v30.Unbind.Visible = false
                    v30.Parent = v29
                    table.insert(t_6, { v29, formattedText })
                    task.defer(v10, v30, formattedText)
                end
            end

            if key_4 % 3 == 0 then
                RunService.RenderStepped:Wait()
            end
        end
    end
end

function t._GenerateSettings(arg13) -- line: 292
    -- upvalues:
    --  [1] SettingsLibrary_m (copy)
    --  [2] BountyLibrary_m (copy)
    --  [3] Players (copy)
    --  [4] PlayerDataController_m (copy)
    --  [5] PermissionsLibrary_m (copy)
    --  [6] Settings (copy)
    --  [7] SettingsController_m (copy)
    --  [8] RunService (copy)

    local t_7 = table.clone(SettingsLibrary_m.DEPENDENCIES)

    for _, val_10 in pairs(SettingsLibrary_m.OrderBySections) do
        local v31 = false

        for key_11, val_11 in pairs(val_10) do
            local Players_1 = BountyLibrary_m.Players

            if
                val_11.InputType ~= "Hotkey"
                and (if val_11.Name ~= "Bounty Rewards Disabled" then if not table.find(
                    SettingsLibrary_m.STAFF_SETTINGS,
                    val_11.Name
                ) then val_11.Name ~= "Staff Team Tools Disabled Leads" or not PermissionsLibrary_m.USE_GROUP_ROLES_INSTEAD_OF_DATASTORES else PlayerDataController_m:IsNosniyGamesTeamMember() and (val_11.Name ~= "Staff Team Tools Disabled Leads" or not PermissionsLibrary_m.USE_GROUP_ROLES_INSTEAD_OF_DATASTORES) else Players_1[tostring(
                    Players.LocalPlayer.UserId
                )] and (if not table.find(SettingsLibrary_m.STAFF_SETTINGS, val_11.Name) then val_11.Name ~= "Staff Team Tools Disabled Leads" or not PermissionsLibrary_m.USE_GROUP_ROLES_INSTEAD_OF_DATASTORES else PlayerDataController_m:IsNosniyGamesTeamMember() and (val_11.Name ~= "Staff Team Tools Disabled Leads" or not PermissionsLibrary_m.USE_GROUP_ROLES_INSTEAD_OF_DATASTORES)))
            then
                local v32 = t_7[val_11.Name]
                local v33 = require(Settings:WaitForChild(val_11.InputType)).new(val_11)
                v33:OverrideDescription("")
                v33.SettingFrame.LayoutOrder = key_11
                local v34 = arg13._setting_objects_by_section
                local v35 = arg13._setting_objects_by_section[val_11.Section]
                local Section = val_11.Section

                if not v35 then
                    v35 = {}
                end

                v34[Section] = v35
                arg13._setting_objects_by_section[val_11.Section][val_11.Name] = v33
                arg13.SettingObjects[val_11.Name] = v33
                v33.Hovered:Connect(function() -- line: 326
                    -- upvalues:
                    --  [1] arg13 (copy)
                    --  [2] v33 (copy)

                    arg13.Hovered:Fire(v33)
                end)

                if v33.SettingsInfo.InputType == "Divider" then
                    v31 = true

                    if key_11 > 1 then
                        v33:SetDividerSpacing(1.5)
                    end
                elseif v31 then
                    v33:Scale(0.95)
                end

                if v32 then
                    if not v32[3] then
                        local v36 = if not v31 then 0 else 1
                        v34 = val_11.Name

                        while true do
                            if not t_7[v34] then
                                break
                            end

                            v34 = t_7[v34][1]
                            v36 += 1
                            continue
                        end

                        v33:Scale(1 - v36 * 0.05)
                    end

                    local function is_visible(arg14) -- line: 358
                        -- upvalues:
                        --  [1] PlayerDataController_m (ref)
                        --  [2] t_7 (copy)
                        --  [3] is_visible (copy)

                        local v39 = if PlayerDataController_m:GetSetting(t_7[arg14][1]) ~= t_7[arg14][2] then false else true

                        if t_7[arg14][4] then
                            v39 = not v39
                        end

                        local v40 = if v39 then not t_7[t_7[arg14][1]] or is_visible(t_7[arg14][1]) else if t_7[arg14][2] ~= "any" then false else not t_7[t_7[arg14][1]] or is_visible(
                            t_7[arg14][1]
                        )

                        return v40
                    end

                    local function update_visibility() -- line: 369
                        -- upvalues:
                        --  [1] v33 (copy)
                        --  [2] is_visible (copy)
                        --  [3] val_11 (copy)

                        v33.SettingFrame.Visible = is_visible(val_11.Name)
                    end

                    PlayerDataController_m:GetDataChangedSignal("SettingsProfile"):Connect(
                        update_visibility
                    )

                    local function hook(arg15) -- line: 375
                        -- upvalues:
                        --  [1] PlayerDataController_m (ref)
                        --  [2] update_visibility (copy)
                        --  [3] t_7 (copy)
                        --  [4] hook (copy)

                        PlayerDataController_m:GetSettingChangedSignal(arg15):Connect(
                            update_visibility
                        )

                        if t_7[arg15] then
                            hook(t_7[arg15][1])
                        end
                    end

                    local v41 = v32[1]
                    PlayerDataController_m:GetSettingChangedSignal(v41):Connect(update_visibility)

                    if t_7[v41] then
                        hook(t_7[v41][1])
                    end

                    v33.SettingFrame.Visible = is_visible(val_11.Name)
                end

                local function update_1() --[[ update ]] -- line: 388
                    -- upvalues:
                    --  [1] v33 (copy)
                    --  [2] PlayerDataController_m (ref)
                    --  [3] val_11 (copy)

                    v33:SetValue(PlayerDataController_m:GetSetting(val_11.Name), true, true)
                end

                PlayerDataController_m:GetSettingChangedSignal(val_11.Name):Connect(update_1)
                PlayerDataController_m:GetDataChangedSignal("SettingsProfile"):Connect(update_1)
                local hook = PlayerDataController_m:GetSetting(val_11.Name)
                v33:SetValue(hook, true, true)
                v33.Replicate:Connect(function() -- line: 396
                    -- upvalues:
                    --  [1] SettingsController_m (ref)
                    --  [2] val_11 (copy)
                    --  [3] v33 (copy)

                    SettingsController_m:ChangeSetting(val_11.Name, v33.Value)
                end)

                if v33.SettingsInfo.InputType == "Slider" or v33.SettingsInfo.InputType == "Color" then
                    v33.SliderChanged:Connect(function(arg16) -- line: 401
                        -- upvalues:
                        --  [1] PlayerDataController_m (ref)
                        --  [2] val_11 (copy)

                        PlayerDataController_m.SettingsSliderChanged:Fire(val_11.Name, arg16)
                    end)
                end

                if key_11 % 3 == 0 then
                    RunService.RenderStepped:Wait()
                end
            end
        end
    end
end

function t._Generate(arg17) -- line: 413
    arg17.DotsFrame:AddTag("UILoadingDots")
    arg17.WaitingFrame.Visible = true
    arg17.Container.Visible = false
    arg17:_GenerateSettings()
    arg17:_GenerateHotkeys()
    arg17:SetPage(arg17.Page.CurrentPage)
    arg17.DotsFrame:RemoveTag("UILoadingDots")
    arg17.WaitingFrame.Visible = false
    arg17.Container.Visible = true
end

function t._Init(arg18) -- line: 427
    -- upvalues:
    --  [1] Inset_m (copy)
    --  [2] UILibrary_m (copy)
    --  [3] GuiService (copy)
    --  [4] ButtonEffect_m (copy)

    arg18.Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() -- line: 428
        -- upvalues:
        --  [1] arg18 (copy)

        arg18.List.CanvasSize = UDim2.new(0, 0, 0, arg18.Layout.AbsoluteContentSize.Y)
    end)
    arg18.List:GetPropertyChangedSignal("AbsolutePosition"):Connect(function() -- line: 432
        -- upvalues:
        --  [1] arg18 (copy)

        arg18:_UpdateSize()
    end)
    arg18.ResetDefaultButton.MouseButton1Click:Connect(function() -- line: 436
        -- upvalues:
        --  [1] arg18 (copy)

        if tick() < arg18._last_reset_click + 0.5 then
            arg18.ResetSettings:Fire()

            return
        end

        arg18._last_reset_click = tick()
    end)
    arg18.MobileEditorButton.MouseButton1Click:Connect(function() -- line: 444
        -- upvalues:
        --  [1] arg18 (copy)
        --  [2] Inset_m (ref)

        arg18.Page.Closed:Fire()
        task.defer(
            Inset_m.MobileEditorBar.SetVisible,
            Inset_m.MobileEditorBar,
            true,
            nil,
            true
        )
    end)
    UILibrary_m.MainGui:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- line: 449
        -- upvalues:
        --  [1] arg18 (copy)

        arg18:_UpdateSize()
    end)
    UILibrary_m.MainGui:GetPropertyChangedSignal("AbsolutePosition"):Connect(function() -- line: 453
        -- upvalues:
        --  [1] arg18 (copy)

        arg18:_UpdateSize()
    end)
    GuiService:GetPropertyChangedSignal("SelectedObject"):Connect(function() -- line: 457
        -- upvalues:
        --  [1] arg18 (copy)
        --  [2] GuiService (ref)

        if arg18.Page:IsOpen() and arg18._is_listening_for_hotkey then
            task.defer(function() -- line: 459
                -- upvalues:
                --  [1] GuiService (ref)

                GuiService.SelectedObject = nil
            end)
        end
    end)
    task.spawn(arg18._Generate, arg18)
    arg18:_UpdateSize()
    ButtonEffect_m:Add(arg18.ResetDefaultButton)
    ButtonEffect_m:Add(arg18.MobileEditorButton)
end

return t
