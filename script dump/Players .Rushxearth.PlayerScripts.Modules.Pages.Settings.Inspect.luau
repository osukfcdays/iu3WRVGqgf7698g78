local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local SettingsLibrary_m = require(ReplicatedStorage.Modules.SettingsLibrary)
local InputLibrary_m = require(ReplicatedStorage.Modules.InputLibrary)
local ServerOsTime_m = require(ReplicatedStorage.Modules.ServerOsTime)
local DuelLibrary_m = require(ReplicatedStorage.Modules.DuelLibrary)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local PlayerDataController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.PlayerDataController
)
local SettingsController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.SettingsController
)
local Crosshair_m = require(Players.LocalPlayer.PlayerScripts.Modules.Crosshair)
local MobileButton = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("MobileButton")
local t = {}
t.__index = t

function t.new(arg1) -- line: 19
    -- upvalues:
    --  [1] t (copy)
    --  [2] Crosshair_m (copy)
    --  [3] MobileButton (copy)

    local t_1 = setmetatable({}, t)
    t_1.Page = arg1
    t_1.Frame = t_1.Page.Container:WaitForChild("Inspect")
    t_1.ServerDescriptionText = t_1.Frame:WaitForChild("ServerDescription")
    t_1.Container = t_1.Frame:WaitForChild("Container")
    t_1.DescriptionFrame = t_1.Container:WaitForChild("Description")
    t_1.DescriptionText = t_1.DescriptionFrame:WaitForChild("Description")
    t_1.DescriptionInvisibleText = t_1.DescriptionFrame:WaitForChild("InvisibleDescription")
    t_1.DescriptionTitleContainer = t_1.DescriptionFrame:WaitForChild("TitleContainer")
    t_1.DescriptionTitleIcon = t_1.DescriptionTitleContainer:WaitForChild("Icon")
    t_1.DescriptionTitleText = t_1.DescriptionTitleContainer:WaitForChild("Title")
    t_1.MapFrame = t_1.Container:WaitForChild("Map")
    t_1.MapContainer = t_1.MapFrame:WaitForChild("Container")
    t_1.MapBackground = t_1.MapContainer:WaitForChild("Background")
    t_1.MapCurrent = t_1.MapBackground:WaitForChild("Current")
    t_1.MapNext = t_1.MapBackground:WaitForChild("Next")
    t_1._current_settings_info = nil
    t_1._map_hash = 0
    t_1._map_num = 0
    t_1._crosshair = Crosshair_m.new()
    t_1._mobile_button = MobileButton:Clone()
    t_1._mobile_input_name_connections = {}
    t_1._current_mobile_input_name = nil
    t_1:_Init()

    return t_1
end

function t.Inspect(arg2, arg3) -- line: 55
    -- upvalues:
    --  [1] PlayerDataController_m (copy)

    if arg3 == arg2._current_settings_info or arg3 and arg3.InputType == "Divider" then
        return
    end

    for _, val in pairs(arg2._mobile_input_name_connections) do
        val:Disconnect()
    end

    arg2._mobile_input_name_connections = {}
    arg2._current_settings_info = arg3
    local v2 = arg2:_GetMobileInputNameFromSettingsName(
        arg2._current_settings_info and arg2._current_settings_info.Name
    ) or arg2._current_mobile_input_name or "mobile_shoot"
    arg2._current_mobile_input_name = v2
    v2 = arg2.DescriptionFrame
    v2.Visible = arg2._current_settings_info ~= nil
    arg2:_UpdateMapVisibility()
    arg2:_UpdateMobileButton()

    if not arg2._current_settings_info then
        return
    end

    arg2.DescriptionTitleIcon.Image = arg2._current_settings_info.Image
    local DescriptionTitleIcon = arg2.DescriptionTitleIcon
    DescriptionTitleIcon.Visible = arg2.DescriptionTitleIcon.Image ~= ""
    arg2.DescriptionTitleText.Text = arg2._current_settings_info.DisplayName
    arg2.DescriptionInvisibleText.Text = arg2._current_settings_info.Description

    if not arg2._current_mobile_input_name then
        return
    end

    table.insert(arg2._mobile_input_name_connections, PlayerDataController_m:GetSettingChangedSignal(
        "MobileButton " .. arg2._current_mobile_input_name .. " Enabled"
    ):Connect(function() -- line: 85
        -- upvalues:
        --  [1] arg2 (copy)

        arg2:_UpdateMobileButton()
    end))
    table.insert(arg2._mobile_input_name_connections, PlayerDataController_m:GetSettingChangedSignal(
        "Mobile Buttons Transparency"
    ):Connect(function() -- line: 89
        -- upvalues:
        --  [1] arg2 (copy)

        arg2:_UpdateMobileButton()
    end))
    table.insert(arg2._mobile_input_name_connections, PlayerDataController_m:GetSettingChangedSignal(
        "MobileButton " .. arg2._current_mobile_input_name .. " Transparency"
    ):Connect(function() -- line: 93
        -- upvalues:
        --  [1] arg2 (copy)

        arg2:_UpdateMobileButton()
    end))
    table.insert(arg2._mobile_input_name_connections, PlayerDataController_m.SettingsSliderChanged:Connect(
        function(arg4, arg5) -- line: 97
            -- upvalues:
            --  [1] arg2 (copy)

            local t_2 = {}
            local v10 = arg2
            t_2[arg4] = arg5
            v10:_UpdateMobileButton(t_2)
        end
    ))
end

function t.SetVisible(arg6, arg7) -- line: 102
    arg6.Frame.Visible = arg7
end

function t.SetPage(arg8, arg9) -- line: 106
    arg8:Inspect(nil)
    arg8:SetVisible(if arg9 == "Hotkeys" then false else true)
    arg8._crosshair:SetVisible(if arg9 ~= "Crosshair" then false else true)
    arg8:_UpdateMapVisibility()
    arg8:_UpdateMobileButton()
end

function t.Open(arg10) -- line: 114
    arg10._map_hash += 1
    task.spawn(arg10._PlayMapEffect, arg10)
    arg10:_UpdateServerDescription()
end

function t.Close(arg11) -- line: 120
    arg11._map_hash += 1
    arg11:Inspect(nil)
end

function t._UpdateServerDescription(arg12) -- line: 129
    -- upvalues:
    --  [1] Utility_m (copy)
    --  [2] ServerOsTime_m (copy)

    local ServerDescriptionText = arg12.ServerDescriptionText
    local PlaceVersion = game.PlaceVersion
    local v12 = Utility_m
    local v13 = ServerOsTime_m:Get()
    ServerDescriptionText.Text = "Version " .. PlaceVersion .. " \226\128\162 " .. v12:TimeFormat2(
        (math.floor(v13 - (workspace:GetAttribute("ServerStartTime") or 0)))
    )
end

function t._GetMobileInputNameFromSettingsName(_, arg14) -- line: 133
    if not arg14 or string.sub(arg14, 1, 13) ~= "MobileButton " then
        return nil
    end

    local substring = string.sub(arg14, 14, #arg14)
    local startIndex = string.find(substring, " ")

    if not startIndex then
        return nil
    end

    return (string.sub(substring, 1, startIndex - 1))
end

function t._UpdateMobileButton(arg15, arg16) -- line: 150
    -- upvalues:
    --  [1] SettingsController_m (copy)
    --  [2] PlayerDataController_m (copy)
    --  [3] InputLibrary_m (copy)

    local MobileButton_1 = arg15._mobile_button
    MobileButton_1.Visible = if arg15.Page.CurrentPage ~= "Touch" then false else arg15._current_mobile_input_name ~= nil

    if not arg15._mobile_button.Visible then
        return
    end

    local Transparency = SettingsController_m:GetMobileButtonSetting(
        arg15._current_mobile_input_name,
        "Mobile Buttons Transparency",
        "Transparency",
        arg16
    )
    local v16 = PlayerDataController_m:GetSetting(
        "MobileButton " .. arg15._current_mobile_input_name .. " Enabled"
    )
    local Image = InputLibrary_m.MobileButtons[arg15._current_mobile_input_name].Image
    arg15._mobile_button.Invisible.Visible = not v16
    arg15._mobile_button.IconContainer.ImageTransparency = math.clamp(Transparency * 2, 0, 1) * 1 + 0
    arg15._mobile_button.IconContainer.Icon.ImageTransparency = math.clamp(Transparency, 0, 1)
    arg15._mobile_button.IconContainer.Icon.Image = Image
end

function t._UpdateMapVisibility(arg17) -- line: 167
    local MapFrame = arg17.MapFrame
    MapFrame.Visible = arg17.Page.CurrentPage == "Crosshair" or (if arg17.Page.CurrentPage ~= "Touch" then false else arg17._current_mobile_input_name)
end

function t._GetMapImage(_, arg19) -- line: 171
    -- upvalues:
    --  [1] DuelLibrary_m (copy)

    return DuelLibrary_m.Maps[DuelLibrary_m.MapOrder[(arg19 - 1) % #DuelLibrary_m.MapOrder + 1]].Image
end

function t._PlayMapEffect(arg20) -- line: 175
    arg20._map_hash += 1
    local MapHash = arg20._map_hash

    while true do
        arg20._map_num += 1
        arg20.MapNext.Image = arg20:_GetMapImage(arg20._map_num + 1)
        arg20.MapCurrent.Image = arg20:_GetMapImage(arg20._map_num)
        arg20.MapCurrent.Position = UDim2.new(0.625, 0, 0.5, 0)
        arg20.MapCurrent:TweenPosition(
            UDim2.new(0.5, 0, 0.5, 0),
            "Out",
            "Quint",
            0.25,
            true
        )
        wait(5)

        if MapHash ~= arg20._map_hash then
            return
        end

        arg20.MapCurrent:TweenPosition(
            UDim2.new(0.375, 0, 0.5, 0),
            "In",
            "Quint",
            0.25,
            true
        )
        wait(0.25)

        if MapHash == arg20._map_hash then
            continue
        end

        return
    end
end

function t._UpdateCrosshairAppearance(arg21, arg22) -- line: 202
    -- upvalues:
    --  [1] SettingsLibrary_m (copy)
    --  [2] PlayerDataController_m (copy)

    arg21._crosshair:SetAppearance(
        SettingsLibrary_m:GenerateCrosshairAppearance(PlayerDataController_m, arg22)
    )
    arg21._crosshair:SetSpacing(arg21._crosshair:GetAppearanceSpacing())
end

function t._UpdateText(arg23) -- line: 207
    arg23.DescriptionText.Text = arg23.DescriptionInvisibleText.Text
    arg23.DescriptionText.Size = UDim2.new(
        0.9,
        0,
        arg23.DescriptionInvisibleText.Size.Y.Scale * math.ceil(
            arg23.DescriptionInvisibleText.TextBounds.X / arg23.DescriptionText.AbsoluteSize.X
        ),
        0
    )
end

function t._Setup(arg24) -- line: 212
    arg24._crosshair:SetParent(arg24.MapContainer)
    arg24._mobile_button.Parent = arg24.MapContainer
    arg24._mobile_button.AnchorPoint = Vector2.new(0.5, 0.5)
    arg24._mobile_button.Position = UDim2.new(0.5, 0, 0.5, 0)
    arg24._mobile_button.Size = UDim2.new(0.5, 0, 0.5, 0)
    arg24._mobile_button.Resize.Visible = false
end

function t._Init(arg25) -- line: 221
    -- upvalues:
    --  [1] PlayerDataController_m (copy)
    --  [2] SettingsLibrary_m (copy)

    arg25.DescriptionInvisibleText:GetPropertyChangedSignal("TextBounds"):Connect(function() -- line: 222
        -- upvalues:
        --  [1] arg25 (copy)

        arg25:_UpdateText()
    end)
    arg25.DescriptionInvisibleText:GetPropertyChangedSignal("Text"):Connect(function() -- line: 226
        -- upvalues:
        --  [1] arg25 (copy)

        arg25:_UpdateText()
    end)
    arg25.DescriptionInvisibleText:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- line: 230
        -- upvalues:
        --  [1] arg25 (copy)

        arg25:_UpdateText()
    end)
    arg25.DescriptionInvisibleText:GetPropertyChangedSignal("AbsolutePosition"):Connect(function() -- line: 234
        -- upvalues:
        --  [1] arg25 (copy)

        arg25:_UpdateText()
    end)
    arg25.DescriptionText:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- line: 238
        -- upvalues:
        --  [1] arg25 (copy)

        arg25:_UpdateText()
    end)
    PlayerDataController_m.SettingsSliderChanged:Connect(function(arg26, arg27) -- line: 242
        -- upvalues:
        --  [1] arg25 (copy)

        local t_3 = {}
        local v19 = arg25
        t_3[arg26] = arg27
        v19:_UpdateCrosshairAppearance(t_3)
    end)

    for key_1, val_1 in pairs(SettingsLibrary_m.Info) do
        if val_1.Section == "Crosshair" then
            PlayerDataController_m:GetSettingChangedSignal(key_1):Connect(function() -- line: 248
                -- upvalues:
                --  [1] arg25 (copy)

                arg25:_UpdateCrosshairAppearance()
            end)
        end
    end

    arg25:_Setup()
    arg25:_UpdateText()
    arg25:_UpdateCrosshairAppearance()
end

return t
