local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local SettingsLibrary_m = require(ReplicatedStorage.Modules.SettingsLibrary)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local Signal_m = require(ReplicatedStorage.Modules.Signal)
local PlayerDataController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("PlayerDataController")
)
local SettingsController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("SettingsController")
)
local MobileInputs_m = require(
    Players.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("MobileInputs")
)
local InsetButtonsBar_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("InsetButtonsBar")
)
local ButtonEffect_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("ButtonEffect")
)
local Pages_m = require(
    Players.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("Pages")
)
local UILibrary_m = require(Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("UILibrary"))
local InsetBarButtonShareBubble = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild(
    "InsetBarButtonShareBubble"
)
local t = {
    { "Close", "Finish editing", "rbxassetid://108220438104376" },
    { "Settings", "Edit your settings", "rbxassetid://14641612286" },
    { "Reset", "Double tap to reset this layout", "rbxassetid://81857929131936" },
    { "Share", "Share & import this layout", "rbxassetid://13733474711" }
}
local t_5 = {}
local t_6 = {}
t_5.__index = t_5

function t_5.new(arg1) -- line: 27
    -- upvalues:
    --  [1] t_5 (copy)
    --  [2] InsetButtonsBar_m (copy)
    --  [3] UILibrary_m (copy)
    --  [4] Signal_m (copy)
    --  [5] InsetBarButtonShareBubble (copy)

    local t_7 = setmetatable({}, t_5)
    t_7.Inset = arg1
    t_7.Bar = InsetButtonsBar_m.new(
        UILibrary_m.BUTTON_BACKGROUND_TRANSPARENCY,
        UILibrary_m.BUTTON_BACKGROUND_COLOR,
        UILibrary_m.BUTTON_ICON_COLOR
    )
    t_7._last_reset_click = 0
    t_7._reset_button_hash = 0
    t_7._interruption_internal = Signal_m.new()
    t_7._share_bubble_frame = InsetBarButtonShareBubble:Clone()
    t_7._was_from_settings = false
    t_7:_Init()

    return t_7
end

function t_5.SetVisible(arg2, arg3, arg4, arg5) -- line: 48
    -- upvalues:
    --  [1] MobileInputs_m (copy)

    arg2._was_from_settings = if arg3 then arg2._was_from_settings or arg5 else false
    arg2.Bar.Buttons.Close.Frame.Visible = not arg2._was_from_settings
    arg2.Bar.Frame.Visible = arg3
    local Frame = arg2.Bar.Frame
    local v9 = arg4 or arg2.Bar.Frame.Size
    Frame.Size = v9
    arg2.Bar:Toggle(true)
    arg2:_CloseButtonAnimation()
    MobileInputs_m.EditorLogic:SetEnabled(arg3)

    if not arg3 then
        arg2._interruption_internal:Fire()
    end
end

function t_5._UpdateShareBubble(arg6) -- line: 68
    local ShareBubbleFrame = arg6._share_bubble_frame
    ShareBubbleFrame.Position = UDim2.new(
        0,
        arg6.Bar.Buttons.Share.Frame.AbsolutePosition.X - arg6.Inset.InsetGui.AbsolutePosition.X + arg6.Bar.Buttons.Share.Frame.AbsoluteSize.X / 2,
        0,
        arg6.Bar.Buttons.Share.Frame.AbsolutePosition.Y + arg6.Bar.Buttons.Share.Frame.AbsoluteSize.Y - arg6.Inset.InsetGui.AbsolutePosition.Y
    )
    arg6._share_bubble_frame.Size = UDim2.new(
        0,
        arg6.Bar.Buttons.Share.Frame.AbsoluteSize.X * 15,
        0,
        arg6.Bar.Buttons.Share.Frame.AbsoluteSize.Y * 3
    )
end

function t_5._CloseButtonAnimation(arg7) -- line: 73
    -- upvalues:
    --  [1] Players (copy)

    local Close = arg7.Bar.Buttons.Close

    if Close.Frame:IsDescendantOf(Players) then
        Close.Frame.Button.Icon.Size = UDim2.new(0, 0, 0, 0)
        Close.Frame.Button.Icon:TweenSize(
            UDim2.new(0.5, 0, 0.5, 0),
            "Out",
            "Quint",
            0.25,
            true
        )

        return
    end

    Close.Frame.Button.Icon.Size = UDim2.new(0.5, 0, 0.5, 0)
end

function t_5._UpdateProfileButtons(arg8) -- line: 84
    -- upvalues:
    --  [1] PlayerDataController_m (copy)

    local v10 = PlayerDataController_m:Get("MobileButtonSettings")
    local v11 = PlayerDataController_m:Get("SettingsProfile")

    for key, _ in pairs(v10) do
        local v12 = if v11 ~= key then false else true
        local v13 = arg8.Bar.Buttons["Profile" .. key]
        v13.Frame.Button.IsSelected.Visible = v12
        local Title = v13.Frame.Button.Title
        local v14 = v12 and arg8.Bar:GetBackgroundColor() or arg8.Bar:GetVisualColor()
        Title.TextColor3 = v14
        local Icon_3 = v13.Frame.Button.Icon
        v14 = v12 and arg8.Bar:GetBackgroundColor() or arg8.Bar:GetVisualColor()
        Icon_3.ImageColor3 = v14
    end
end

function t_5._Setup(arg9) -- line: 98
    -- upvalues:
    --  [1] t (copy)
    --  [2] PlayerDataController_m (copy)
    --  [3] MobileInputs_m (copy)
    --  [4] t_6 (copy)
    --  [5] SettingsLibrary_m (copy)
    --  [6] SettingsController_m (copy)
    --  [7] Pages_m (copy)
    --  [8] Utility_m (copy)

    for key_1, val_1 in pairs(t) do
        arg9.Bar:CreateButton(key_1, table.unpack(val_1))
    end

    local v15 = PlayerDataController_m:Get("MobileButtonSettings")
    local v19, v21

    for key_2, _ in pairs(v15) do
        v19 = arg9.Bar:CreateButton(
            #t + key_2,
            "Profile" .. key_2,
            "Switch to layout #" .. key_2,
            key_2
        )
        v21 = Instance.new("Frame")
        local New = Vector2.new(0.5, 0.5)
        v21.AnchorPoint = New
        local New_1 = UDim2.new(0.75, 0, 0.75, 0)
        v21.Size = New_1
        local New_2 = UDim2.new(0.5, 0, 0.5, 0)
        v21.Position = New_2
        v21.ZIndex = 0
        v21.Name = "IsSelected"
        local Bar_1 = arg9.Bar:GetVisualColor()
        v21.BackgroundColor3 = Bar_1
        local Frame_1 = v19.Frame.Button
        v21.Parent = Frame_1
        local New_3 = Instance.new("UICorner")
        New_3.CornerRadius = UDim.new(1, 0)
        New_3.Parent = v21
        v19.Clicked:Connect(function() -- line: 121
            -- upvalues:
            --  [1] MobileInputs_m (ref)
            --  [2] key_2 (copy)

            MobileInputs_m:SwitchProfile(key_2)
        end)
    end

    local v28

    for key_3, val_3 in pairs(t_6) do
        local v19 = SettingsLibrary_m.Info[val_3]
        local v24 = #t + #v15 + key_3
        local v21 = arg9.Bar:CreateButton(v24, "Settings" .. key_3, nil, v19.Image)
        v21.Clicked:Connect(function() -- line: 131
            -- upvalues:
            --  [1] SettingsController_m (ref)
            --  [2] val_3 (copy)
            --  [3] PlayerDataController_m (ref)

            SettingsController_m:ChangeSetting(val_3, not PlayerDataController_m:GetSetting(val_3))
        end)
        v28 = 0

        local function v24(arg10) --[[ update_value ]] -- line: 137
            -- upvalues:
            --  [1] arg9 (copy)
            --  [2] val_3 (copy)
            --  [3] v28 (ref)
            --  [4] PlayerDataController_m (ref)
            --  [5] v21 (copy)
            --  [6] v19 (copy)

            arg9._interruption_internal:Fire(val_3)
            v28 += 1
            local v29 = PlayerDataController_m:GetSetting(val_3)
            local Icon_4 = v21.Frame.Button.Icon
            Icon_4.ImageColor3 = v29 and Color3.fromRGB(100, 255, 50) or Color3.fromRGB(255, 50, 50)
            local v31 = v21
            local v32

            if not arg10 then
                v32 = nil
            else
                v32 = string.format
                local v33 = if not v29 then "255,50,50" else "100,255,50"
                local v34 = if not v29 then "OFF" else "ON"
                v32 = v32(
                    "%s <font weight=\"900\" color=\"rgb(%s)\">%s</font>",
                    v19.DisplayName,
                    v33,
                    v34
                )
            end

            v31:PlayBubbleEffect(v32)
        end

        PlayerDataController_m:GetSettingChangedSignal(val_3):Connect(function() -- line: 148
            -- upvalues:
            --  [1] v24 (copy)

            v24(true)
        end)
        v24(false)
        arg9._interruption_internal:Connect(function(arg11) -- line: 154
            -- upvalues:
            --  [1] val_3 (copy)
            --  [2] v21 (copy)

            if arg11 ~= val_3 then
                v21:PlayBubbleEffect(nil)
            end
        end)
    end

    local _ = function() --[[ close_bar ]] -- line: 161
        -- upvalues:
        --  [1] arg9 (copy)

        arg9:SetVisible(false)
        arg9.Inset.MainBar:SetVisible(true, arg9.Bar.Frame.Size)
    end

    arg9.Bar.Buttons.Close.Clicked:Connect(function() -- line: 167
        -- upvalues:
        --  [1] arg9 (copy)

        arg9:SetVisible(false)
        arg9.Inset.MainBar:SetVisible(true, arg9.Bar.Frame.Size)
    end)
    arg9.Bar.Buttons.Settings.Clicked:Connect(function() -- line: 171
        -- upvalues:
        --  [1] arg9 (copy)
        --  [2] Pages_m (ref)

        arg9:SetVisible(false)
        arg9.Inset.MainBar:SetVisible(true, arg9.Bar.Frame.Size)
        Pages_m.PageSystem:OpenPage("Settings", true)
        Pages_m.PageSystem:WaitForPage("Settings"):SetPage("Touch")
    end)
    arg9.Bar.Buttons.Reset.Clicked:Connect(function() -- line: 177
        -- upvalues:
        --  [1] arg9 (copy)
        --  [2] Utility_m (ref)
        --  [3] MobileInputs_m (ref)

        if tick() > arg9._last_reset_click + 0.5 then
            arg9._last_reset_click = tick()

            return
        end

        local v37 = arg9
        v37._reset_button_hash += 1
        local ResetButtonHash = arg9._reset_button_hash
        task.spawn(
            Utility_m.RenderstepForLoop,
            Utility_m,
            0,
            100,
            5,
            function(arg12) -- line: 186
                -- upvalues:
                --  [1] arg9 (ref)
                --  [2] ResetButtonHash (copy)

                if arg9._reset_button_hash ~= ResetButtonHash then
                    return true
                end

                arg9.Bar.Buttons.Reset.Frame.Button.Icon.Rotation = -360 * (1 - (1 - (1 - arg12 / 100) ^ 3))
            end
        )
        MobileInputs_m.EditorLogic:ResetLayout()
    end)
    arg9.Bar.Buttons.Share.Clicked:Connect(function() -- line: 199
        -- upvalues:
        --  [1] arg9 (copy)
        --  [2] MobileInputs_m (ref)
        --  [3] PlayerDataController_m (ref)

        arg9._share_bubble_frame.Import.Box.Text = ""
        arg9._share_bubble_frame.Export.Text = MobileInputs_m.Buttons:EncryptProfile()
        arg9._share_bubble_frame.ExportTitle.Text = "Share layout #" .. PlayerDataController_m:Get(
            "SettingsProfile"
        ) .. " by copying this: "
        arg9._share_bubble_frame.Visible = true
        arg9._interruption_internal:Fire("Share")
    end)
    arg9.Bar.Buttons.Share.Frame:GetPropertyChangedSignal("AbsolutePosition"):Connect(function() -- line: 207
        -- upvalues:
        --  [1] arg9 (copy)

        arg9:_UpdateShareBubble()
    end)
    arg9.Bar.Buttons.Share.Frame:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- line: 211
        -- upvalues:
        --  [1] arg9 (copy)

        arg9:_UpdateShareBubble()
    end)
    arg9._interruption_internal:Connect(function(arg13) -- line: 215
        -- upvalues:
        --  [1] arg9 (copy)

        if arg13 ~= "Share" then
            arg9._share_bubble_frame.Visible = false
        end
    end)
    arg9._share_bubble_frame.ZIndex = 999999
    arg9._share_bubble_frame.Parent = arg9.Inset.InsetGui
    arg9.Bar.Frame.Parent = arg9.Inset.LeftButtonsFrame
end

function t_5._Init(arg14) -- line: 226
    -- upvalues:
    --  [1] MobileInputs_m (copy)
    --  [2] PlayerDataController_m (copy)
    --  [3] ButtonEffect_m (copy)

    arg14.Inset.InsetGui:GetPropertyChangedSignal("AbsolutePosition"):Connect(function() -- line: 227
        -- upvalues:
        --  [1] arg14 (copy)

        arg14:_UpdateShareBubble()
    end)
    arg14.Inset.InsetGui:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- line: 231
        -- upvalues:
        --  [1] arg14 (copy)

        arg14:_UpdateShareBubble()
    end)
    arg14._share_bubble_frame.Close.MouseButton1Click:Connect(function() -- line: 235
        -- upvalues:
        --  [1] arg14 (copy)

        arg14._share_bubble_frame.Visible = false
    end)
    arg14._share_bubble_frame.Import.Button.MouseButton1Click:Connect(function() -- line: 239
        -- upvalues:
        --  [1] MobileInputs_m (ref)
        --  [2] arg14 (copy)

        MobileInputs_m.EditorLogic:ImportProfile(arg14._share_bubble_frame.Import.Box.Text)
    end)
    PlayerDataController_m:GetDataChangedSignal("MobileButtonSettings"):Connect(function() -- line: 243
        -- upvalues:
        --  [1] arg14 (copy)

        arg14:_UpdateProfileButtons()
    end)
    PlayerDataController_m:GetDataChangedSignal("SettingsProfile"):Connect(function() -- line: 247
        -- upvalues:
        --  [1] arg14 (copy)

        arg14:_UpdateProfileButtons()
    end)
    arg14:_Setup()
    arg14:_UpdateShareBubble()
    arg14:_UpdateProfileButtons()
    arg14:SetVisible(false)
    ButtonEffect_m:Add(arg14._share_bubble_frame.Import.Button, true)
end

return t_5
