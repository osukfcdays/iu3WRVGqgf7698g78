local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local _ = game:GetService("GuiService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CONSTANTS_m = require(ReplicatedStorage.Modules.CONSTANTS)
local BetterDebris_m = require(ReplicatedStorage.Modules.BetterDebris)
local InputLibrary_m = require(ReplicatedStorage.Modules.InputLibrary)
local ItemLibrary_m = require(ReplicatedStorage.Modules.ItemLibrary)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local PlayerDataController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("PlayerDataController")
)
local MechanicsController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("MechanicsController")
)
local SettingsController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("SettingsController")
)
local SpectateController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("SpectateController")
)
local _ = require(Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("FighterController"))
local CameraController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("CameraController")
)
local EmoteController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("EmoteController")
)
local InfiniteParticles_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("InfiniteParticles")
)
local UILibrary_m = require(Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("UILibrary"))
local MobileButtonCooldownSlot = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild(
    "MobileButtonCooldownSlot"
)
local MobileButton = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("MobileButton")
local t = {}
t.__index = t

function t.new(arg1, arg2) -- line: 30
    -- upvalues:
    --  [1] t (copy)
    --  [2] MobileButton (copy)
    --  [3] InputLibrary_m (copy)
    --  [4] InfiniteParticles_m (copy)

    local t_1 = setmetatable({}, t)
    t_1.Buttons = arg1
    t_1.Name = arg2
    t_1.Frame = MobileButton:Clone()
    t_1.InvisibleFrame = t_1.Frame:WaitForChild("Invisible")
    t_1.ResizeIcon = t_1.Frame:WaitForChild("Resize")
    t_1.WeaponIcon = t_1.Frame:WaitForChild("Weapon")
    t_1.IconContainer = t_1.Frame:WaitForChild("IconContainer")
    t_1.Icon = t_1.IconContainer:WaitForChild("Icon")
    t_1.AmmoFrame = t_1.Frame:WaitForChild("Ammo")
    t_1.AmmoIcon = t_1.AmmoFrame:WaitForChild("Icon")
    t_1.AmmoTitle = t_1.AmmoFrame:WaitForChild("Title")
    t_1.AmmoTitleStroke = t_1.AmmoTitle:WaitForChild("UIStroke")
    t_1._local_fighter = nil
    t_1._item_index = InputLibrary_m.MobileInputNameToItemIndex[t_1.Name]
    t_1._info = InputLibrary_m.MobileButtons[t_1.Name]
    t_1._is_active = false
    t_1._is_scoped = false
    t_1._is_resizing = false
    t_1._resize_connection = nil
    t_1._is_dragging = false
    t_1._drag_connection = nil
    t_1._drag_delta = nil
    t_1._drag_original_position = nil
    t_1._current_cooldown_frame = nil
    t_1._infinite_particles = InfiniteParticles_m.new(t_1.AmmoTitle)
    t_1:_Init()

    return t_1
end

function t.IsReallyVisible(arg3) -- line: 69
    local v10 = arg3.Frame.Visible

    if v10 then
        v10 = arg3.Buttons:IsReallyVisible()
    end

    return v10
end

function t.IsWithin(arg4, arg5, arg6) -- line: 73
    -- upvalues:
    --  [1] UILibrary_m (copy)

    return UILibrary_m:IsWithinBounds(
        arg5,
        arg6,
        arg4.Frame.AbsolutePosition,
        arg4.Frame.AbsoluteSize
    )
end

function t.SetScoped(arg7, arg8) -- line: 77
    if arg7._is_scoped == arg8 then
        return
    end

    arg7._is_scoped = arg8
    arg7:UpdateVisuals()
end

function t.SetActive(arg9, arg10) -- line: 86
    arg9._is_active = arg10
    arg9:UpdateVisuals()
end

function t.Input(arg11, arg12, arg13) -- line: 91
    -- upvalues:
    --  [1] CameraController_m (copy)
    --  [2] MechanicsController_m (copy)

    if not arg13 and (arg11.Buttons.MobileInputs.EditorEnabled or not arg11:_IsVisible(arg11.Name)) then
        return
    end

    arg11:SetActive(arg12)

    if arg11.Name == "mobile_switchcamerapov" then
        if arg12 then
            CameraController_m.CameraState:TogglePOV()

            return
        end
    elseif
        arg11.Name == "mobile_crouch"
        and MechanicsController_m.IsSliding
        and arg11:_IsEasySlideEnabled()
    then
        if arg12 then
            MechanicsController_m:MobileInput("mobile_jump", true)

            return
        end
    elseif arg11.Name == "mobile_slide" and MechanicsController_m.IsSliding then
        if arg12 then
            MechanicsController_m:MobileInput("mobile_jump", true)

            return
        end
    else
        MechanicsController_m:MobileInput(arg11.Name, arg12)
    end
end

function t.InputEnded(arg14, _) -- line: 115
    if arg14._is_resizing then
        arg14._resize_connection:Disconnect()
        arg14._resize_connection = nil
        arg14._is_resizing = false
    end

    if arg14._is_dragging then
        arg14._drag_connection:Disconnect()
        arg14._drag_connection = nil
        arg14._drag_delta = nil
        arg14._drag_original_position = nil
        arg14._is_dragging = false
    end
end

function t.Button1Down(arg16, arg17) -- line: 135
    arg16.Buttons.MobileInputs.DoubleTap:ResetTapWindow()

    if arg16:_IsToggleMode() then
        arg16:Input(not arg16._is_active)

        return
    end

    task.spawn(function() -- line: 143
        -- upvalues:
        --  [1] arg17 (copy)
        --  [2] arg16 (copy)

        if not arg17 then
            return
        end

        while true do
            if arg17.UserInputState == Enum.UserInputState.End then
                break
            end

            arg17:GetPropertyChangedSignal("UserInputState"):Wait()
        end

        arg16:Button1Up()
    end)
    arg16:Input(true)
end

function t.Button1Up(arg18) -- line: 158
    arg18:Input(false)
end

function t.UpdateVisuals(arg19) -- line: 162
    -- upvalues:
    --  [1] SettingsController_m (copy)

    local v11 = arg19._is_active or arg19._item_index and arg19._local_fighter and arg19._local_fighter.EquippedItem and arg19._local_fighter.EquippedItem == arg19._local_fighter.Items[arg19._item_index]
    local v12 = v11 and not arg19.Buttons.MobileInputs.EditorEnabled
    v11 = SettingsController_m:GetMobileButtonSetting(
        arg19.Name,
        "Mobile Buttons Transparency",
        "Transparency"
    )
    local v13 = if arg19._is_scoped and SettingsController_m:GetMobileButtonSetting(
        arg19.Name,
        "Opaque Buttons While Scoped"
    ) then 0 else if not v12 then v11 else v11 * 2 - 1
    local clampedValue = math.clamp(v13, 0, 1)
    local clampedValue_1 = math.clamp(v13 * 2, 0, 1)
    local clampedValue_2 = math.clamp(v13 * 2 - 1, 0, 1)
    arg19.InvisibleFrame.Visible = not arg19:_IsVisibleSetting()
    arg19.IconContainer.ImageTransparency = clampedValue_1 * 1 + 0
    arg19.Icon.ImageTransparency = clampedValue
    local Icon = arg19.Icon
    Icon.ImageColor3 = v12 and Color3.fromRGB(0, 190, 255) or Color3.fromRGB(0, 0, 0)
    arg19.WeaponIcon.ImageTransparency = clampedValue_2 * 1 + 0
    arg19.AmmoIcon.ImageTransparency = clampedValue_2 * 1 + 0
    arg19.AmmoTitle.TextTransparency = clampedValue_2 * 1 + 0
    arg19.AmmoTitleStroke.Transparency = clampedValue_2 * 0.125 + 0.875
end

function t.UpdateWeaponIcon(arg20) -- line: 181
    -- upvalues:
    --  [1] ItemLibrary_m (copy)
    --  [2] CONSTANTS_m (copy)

    local v15 = arg20:_GetClientItem()
    local WeaponIcon = arg20.WeaponIcon
    WeaponIcon.Image = if not arg20._item_index then "" else not arg20.Buttons.MobileInputs.EditorEnabled and v15 and v15.ViewModel:GetImage() or ItemLibrary_m.Items[CONSTANTS_m.DEFAULT_WEAPONS[arg20._item_index]].Image or ""
end

function t.UpdatePositionAndSize(arg21, arg22) -- line: 190
    -- upvalues:
    --  [1] PlayerDataController_m (copy)

    arg21:ResetPositionAndSize()
    local v17 = arg22 or PlayerDataController_m:Get("MobileButtonSettings")[PlayerDataController_m:Get(
        "SettingsProfile"
    )]

    if not v17 then
        return
    end

    local v19 = v17[arg21.Name]

    if not v19 then
        return
    end

    arg21.Frame.Position = UDim2.new(0, v19.Position[1], 0, v19.Position[2])
    arg21.Frame.Size = UDim2.new(0, v19.Size[1], 0, v19.Size[2])
end

function t.ResetPositionAndSize(arg23) -- line: 209
    local v20 = math.min(arg23.Buttons.Frame.AbsoluteSize.X, arg23.Buttons.Frame.AbsoluteSize.Y) <= 500 and true
    local v21 = v20 and UDim2.new() or UDim2.new(0, 0, 0, -45)
    local v22 = if not v20 then 1.7894736842105263 else 1
    local v23 = if not v20 then 1.7142857142857142 else 1
    arg23.Frame.Position = v21 + UDim2.new(
        arg23._info.DefaultPosition.X.Scale,
        arg23._info.DefaultPosition.X.Offset * v22,
        arg23._info.DefaultPosition.Y.Scale,
        arg23._info.DefaultPosition.Y.Offset * v22
    )
    arg23.Frame.Size = UDim2.new(
        0,
        arg23._info.DefaultSize.X.Offset * v23,
        0,
        arg23._info.DefaultSize.Y.Offset * v23
    )
end

function t.UpdateVisibility(arg24) -- line: 228
    arg24.Frame.Visible = arg24:_IsVisible()

    if not arg24.Frame.Visible then
        arg24:SetActive(false)
    end
end

function t.UpdateMobileInputSettings(arg25) -- line: 236
    if not arg25._info.IsCoreInput and not arg25._info.QuickAttackType then
        arg25:Input(false, true)
    end

    arg25:UpdateVisibility()
end

function t.Update(arg26, arg27) -- line: 244
    arg26._infinite_particles:Update(arg27)
end

function t._GetClientItem(arg28) -- line: 252
    return arg28._item_index and arg28._local_fighter and arg28._local_fighter.Items[arg28._item_index]
end

function t._UpdateAmmo(arg29) -- line: 256
    -- upvalues:
    --  [1] PlayerDataController_m (copy)
    --  [2] ItemLibrary_m (copy)

    local v25 = not arg29.Buttons.MobileInputs.EditorEnabled

    if v25 then
        v25 = arg29:_GetClientItem()
    end

    if not v25 then
        arg29.AmmoFrame.Visible = false

        return
    end

    local v26, v27, v28, v29 = v25:GetAmmoVariables()
    local v30 = PlayerDataController_m:GetSetting("Touch Button Ammo")
    local v31 = if v28 then "\226\136\158" else v26 or ""
    local v32 = v26 and v26 <= 0 and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(255, 255, 255)
    local v33 = if not v26 then "rgb(255,255,255)" else if not (v26 <= 0) then "rgb(255,255,255)" else "rgb(255,50,50)"
    local v34 = if not v29 then v27 or "" else "\226\136\158"
    local v35 = v27 and v27 <= 0 and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(255, 255, 255)
    local v36 = if not v27 then "rgb(255,255,255)" else if not (v27 <= 0) then "rgb(255,255,255)" else "rgb(255,50,50)"
    arg29.AmmoFrame.Visible = v26 and v30
    local AmmoTitle = arg29.AmmoTitle
    local formattedText = string.format("<font color=\"%s\">%s</font>", v33, v31)
    local v37 = if v34 ~= "" then string.format(
        "<font size=\"8\" color=\"%s\"> %s</font>",
        v36,
        v34
    ) else ""
    AmmoTitle.Text = formattedText .. v37
    local AmmoIcon = arg29.AmmoIcon
    AmmoIcon.ImageColor3 = v27 and v35 or v32
    local AmmoIcon_1 = arg29.AmmoIcon
    AmmoIcon_1.Image = v25.Info.AmmoType and ItemLibrary_m.Ammos[v25.Info.AmmoType].Image or ""
    arg29._infinite_particles:SetActive(v28, v29)
end

function t._GetMobileInputSettingsFromEquippedItem(arg30) -- line: 283
    -- upvalues:
    --  [1] InputLibrary_m (copy)

    local v39 = arg30._local_fighter

    if v39 then
        v39 = arg30._local_fighter.EquippedItem

        if v39 then
            v39 = arg30._local_fighter.EquippedItem:GetMobileInputSettings()
        end
    end

    return v39 and v39[InputLibrary_m.MobileButtons[arg30.Name].InputName]
end

function t._IsEasySlideEnabled(_) -- line: 289
    -- upvalues:
    --  [1] PlayerDataController_m (copy)

    local v41 = PlayerDataController_m:GetSetting("Easy Slide Mobile")

    if v41 then
        v41 = not PlayerDataController_m:GetSetting("MobileButton mobile_slide Enabled")
    end

    return v41
end

function t._IsVisibleSetting(arg32) -- line: 293
    -- upvalues:
    --  [1] PlayerDataController_m (copy)

    return PlayerDataController_m:GetSetting("MobileButton " .. arg32.Name .. " Enabled")
end

function t._IsToggleMode(arg33) -- line: 297
    return arg33._info.AlwaysToggle or (if arg33:_GetMobileInputSettingsFromEquippedItem() ~= true then false else true)
end

function t._IsVisible(arg34) -- line: 301
    -- upvalues:
    --  [1] SpectateController_m (copy)
    --  [2] CameraController_m (copy)
    --  [3] EmoteController_m (copy)

    if arg34.Buttons.MobileInputs.EditorEnabled then
        return true
    end

    if not arg34._local_fighter or not arg34:_IsVisibleSetting() then
        return false
    end

    if SpectateController_m.CurrentDuelSubject then
        if
            SpectateController_m.CurrentDuelSubject.DuelInterface.Voting:IsOpen()
            or not SpectateController_m.CurrentDuelSubject.LocalDueler and not arg34._info.VisibleWhileSpectatingForeignDuel
        then
            return false
        end
    end

    if
        not arg34._info.AlwaysVisible and arg34:_GetMobileInputSettingsFromEquippedItem() == nil
        or arg34._info.HideIfDead and not arg34._local_fighter:IsAlive()
    then
        return false
    end

    if
        arg34.Name == "mobile_quickmelee"
        and #arg34._local_fighter.Items < arg34._local_fighter:GetQuickAttackIndex(
            arg34._info.QuickAttackType
        )
    then
        return false
    end

    local v45 = #arg34._local_fighter.Items

    if
        arg34.Name == "mobile_quickutility" and v45 < arg34._local_fighter:GetQuickAttackIndex(
            arg34._info.QuickAttackType
        )
        or arg34.Name == "mobile_equipnext" and #arg34._local_fighter.Items < 2
        or arg34.Name == "mobile_switchcamerapov" and not CameraController_m:GetPublicState() and (not SpectateController_m.CurrentDuelSubject or SpectateController_m.CurrentDuelSubject.LocalDueler)
        or arg34.Name == "mobile_openplayerlist" and not SpectateController_m.CurrentDuelSubject
        or arg34.Name == "mobile_equipprimary" and #arg34._local_fighter.Items < 1
        or arg34.Name == "mobile_equipsecondary" and #arg34._local_fighter.Items < 2
        or arg34.Name == "mobile_equipmelee" and #arg34._local_fighter.Items < 3
        or arg34.Name == "mobile_equiputility" and #arg34._local_fighter.Items < 4
        or arg34.Name == "mobile_useemote" and not EmoteController_m:CanEmote()
    then
        return false
    end

    return true
end

function t._UpdateCameraSinking(arg35) -- line: 376
    -- upvalues:
    --  [1] SettingsController_m (copy)

    arg35.Frame.Active = not SettingsController_m:GetMobileButtonSetting(
        arg35.Name,
        "Camera Mobile Button Sinking",
        "Camera Sinking"
    )
end

function t._UpdateEditorVisuals(arg36) -- line: 380
    arg36.ResizeIcon.Visible = arg36.Buttons.MobileInputs.EditorEnabled

    if arg36._current_cooldown_frame then
        arg36._current_cooldown_frame.Visible = not arg36.Buttons.MobileInputs.EditorEnabled
    end
end

function t._SetupEditorLogic(arg37) -- line: 388
    -- upvalues:
    --  [1] UILibrary_m (copy)
    --  [2] RunService (copy)
    --  [3] UserInputService (copy)

    local function update_resize() -- line: 389
        -- upvalues:
        --  [1] arg37 (copy)
        --  [2] UILibrary_m (ref)

        local v47 = arg37.Frame.AbsolutePosition + arg37.Frame.AbsoluteSize * arg37.Frame.AnchorPoint - UILibrary_m:GetMouseLocation()
        local maximum = math.max(math.sqrt(v47.X ^ 2 + v47.Y ^ 2) * 2, 35)
        arg37.Frame.Size = UDim2.new(0, maximum, 0, maximum)
    end

    local v48 = nil

    local function update_drag(arg38) -- line: 398
        -- upvalues:
        --  [1] arg37 (copy)
        --  [2] v48 (ref)

        local v49 = arg37
        local DragDelta = v49._drag_delta
        local v50 = if v48 then arg38.Position - v48 else Vector3.new(0, 0, 0)
        v49._drag_delta = DragDelta + v50
        v48 = arg38.Position
        arg37.Frame.Position = UDim2.new(
            0,
            math.clamp(
                arg37._drag_original_position.X + arg37._drag_delta.X,
                0,
                arg37.Buttons.Frame.AbsoluteSize.X
            ),
            0,
            (math.clamp(
                arg37._drag_original_position.Y + arg37._drag_delta.Y,
                0,
                arg37.Buttons.Frame.AbsoluteSize.Y
            ))
        )
    end

    arg37.Frame.Resize.MouseButton1Down:Connect(function() -- line: 410
        -- upvalues:
        --  [1] arg37 (copy)
        --  [2] RunService (ref)
        --  [3] update_resize (copy)

        if not arg37.Buttons.MobileInputs.EditorEnabled or arg37._is_resizing then
            return
        end

        arg37.Buttons.MobileInputs.EditorLogic:PendEdits()
        arg37._is_resizing = true
        arg37._resize_connection = RunService.RenderStepped:Connect(update_resize)
    end)
    arg37.Frame.MouseButton1Down:Connect(function() -- line: 421
        -- upvalues:
        --  [1] arg37 (copy)
        --  [2] v48 (ref)
        --  [3] UserInputService (ref)
        --  [4] update_drag (copy)

        if not arg37.Buttons.MobileInputs.EditorEnabled or arg37._is_dragging then
            return
        end

        arg37.Buttons.MobileInputs.EditorLogic:PendEdits()
        v48 = nil
        arg37._is_dragging = true
        arg37._drag_original_position = arg37.Frame.AbsolutePosition + arg37.Frame.AbsoluteSize * arg37.Frame.AnchorPoint - arg37.Buttons.Frame.AbsolutePosition
        arg37._drag_delta = Vector3.new(0, 0, 0)
        arg37._drag_connection = UserInputService.InputChanged:Connect(update_drag)
    end)
end

function t._HookFighter(arg39) -- line: 436
    -- upvalues:
    --  [1] MechanicsController_m (copy)
    --  [2] PlayerDataController_m (copy)
    --  [3] SettingsController_m (copy)
    --  [4] MobileButtonCooldownSlot (copy)
    --  [5] BetterDebris_m (copy)
    --  [6] TweenService (copy)
    --  [7] Utility_m (copy)

    arg39._local_fighter = MechanicsController_m:WaitForLocalFighter()
    arg39._local_fighter:GetDataChangedSignal("InfiniteAmmo"):Connect(function() -- line: 439
        -- upvalues:
        --  [1] arg39 (copy)

        arg39:_UpdateAmmo()
    end)
    arg39._local_fighter:GetDataChangedSignal("InfiniteAmmoReserve"):Connect(function() -- line: 443
        -- upvalues:
        --  [1] arg39 (copy)

        arg39:_UpdateAmmo()
    end)
    PlayerDataController_m:GetSettingChangedSignal("Touch Button Ammo"):Connect(function() -- line: 447
        -- upvalues:
        --  [1] arg39 (copy)

        arg39:_UpdateAmmo()
    end)

    if arg39._item_index then
        local t_2 = {}
        local t_3 = {}
        local t_4 = {}
        local v54 = nil

        local function cleanup_cooldown_effect() -- line: 457
            -- upvalues:
            --  [1] t_2 (ref)
            --  [2] t_3 (ref)
            --  [3] arg39 (copy)

            for _, val in pairs(t_2) do
                val:Disconnect()
            end

            for _, val_1 in pairs(t_3) do
                val_1:Destroy()
            end

            t_2 = {}
            t_3 = {}
            arg39._current_cooldown_frame = nil
        end

        local function cooldown_effect(arg40) -- line: 471
            -- upvalues:
            --  [1] cleanup_cooldown_effect (copy)
            --  [2] SettingsController_m (ref)
            --  [3] arg39 (copy)
            --  [4] MobileButtonCooldownSlot (ref)
            --  [5] BetterDebris_m (ref)
            --  [6] t_3 (ref)
            --  [7] t_2 (ref)
            --  [8] TweenService (ref)

            if arg40.IsReversed then
                return
            end

            cleanup_cooldown_effect()
            local v55, v56, v57 = arg40.GetVariables()
            local v58 = SettingsController_m:GetMobileButtonSetting(
                arg39.Name,
                "Mobile Buttons Transparency",
                "Transparency"
            ) * 2 - 1
            local v59 = MobileButtonCooldownSlot:Clone()
            v59.Right.Frame.UIStroke.Transparency = v58
            v59.Left.Frame.UIStroke.Transparency = v58
            v59.Icon.Image = ""
            v59.Parent = arg39.Frame
            BetterDebris_m:AddItem(v59, v55)
            table.insert(t_3, v59)
            arg39._current_cooldown_frame = v59
            local UIGradient = v59.Right.Frame.UIStroke.UIGradient
            local UIGradient_1 = v59.Left.Frame.UIStroke.UIGradient

            local _ = function(arg41) --[[ set ]] -- line: 493
                -- upvalues:
                --  [1] UIGradient (copy)
                --  [2] UIGradient_1 (copy)

                arg41 = 1 - arg41
                local clampedValue_4 = math.clamp(arg41 * 2, 0, 1)
                local clampedValue_5 = math.clamp(arg41 * 2 - 1, 0, 1)
                UIGradient.Rotation = clampedValue_4 * 180 + -180
                UIGradient_1.Rotation = clampedValue_5 * 180 + 0
            end

            local NumberValue = Instance.new("NumberValue")
            NumberValue.Value = v56
            table.insert(t_3, NumberValue)
            table.insert(t_2, NumberValue:GetPropertyChangedSignal("Value"):Connect(function() -- line: 507
                -- upvalues:
                --  [1] NumberValue (copy)
                --  [2] UIGradient (copy)
                --  [3] UIGradient_1 (copy)

                local v61 = 1 - NumberValue.Value
                local clampedValue_6 = math.clamp(v61 * 2, 0, 1)
                local clampedValue_7 = math.clamp(v61 * 2 - 1, 0, 1)
                UIGradient.Rotation = clampedValue_6 * 180 + -180
                UIGradient_1.Rotation = clampedValue_7 * 180 + 0
            end))
            local v62 = TweenService
            local tweenInfo = TweenInfo.new(
                v55,
                Enum.EasingStyle.Linear,
                Enum.EasingDirection.InOut
            )
            v62:Create(NumberValue, tweenInfo, { Value = v57 }):Play()
            arg39:_UpdateEditorVisuals()
        end

        local function update_client_item() -- line: 516
            -- upvalues:
            --  [1] arg39 (copy)
            --  [2] v54 (ref)
            --  [3] cleanup_cooldown_effect (copy)
            --  [4] t_2 (ref)
            --  [5] t_4 (ref)
            --  [6] TweenService (ref)
            --  [7] Utility_m (ref)
            --  [8] cooldown_effect (copy)

            local v63 = arg39._local_fighter.Items[arg39._item_index]

            if v63 == v54 then
                return
            end

            cleanup_cooldown_effect()

            for _, val_2 in pairs(t_2) do
                val_2:Disconnect()
            end

            t_4 = {}
            v54 = v63
            arg39:_UpdateAmmo()

            if not v54 then
                return
            end

            table.insert(t_4, v54:GetDataChangedSignal("Ammo"):Connect(function() -- line: 537
                -- upvalues:
                --  [1] arg39 (ref)

                arg39:_UpdateAmmo()
            end))
            table.insert(t_4, v54:GetDataChangedSignal("AmmoReserve"):Connect(function() -- line: 541
                -- upvalues:
                --  [1] arg39 (ref)

                arg39:_UpdateAmmo()
            end))
            table.insert(t_4, v54.EquipFailedEffect:Connect(function() -- line: 545
                -- upvalues:
                --  [1] arg39 (ref)
                --  [2] TweenService (ref)
                --  [3] Utility_m (ref)

                if not arg39:IsReallyVisible() then
                    return
                end

                arg39.WeaponIcon.ImageColor3 = Color3.fromRGB(127, 0, 0)
                arg39.WeaponIcon.Position = UDim2.new(0.5, 0, 0.75, 0)
                TweenService:Create(
                    arg39.WeaponIcon,
                    TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
                    {
                        ImageColor3 = Color3.fromRGB(255, 255, 255),
                        Position = UDim2.new(0.5, 0, 0.5, 0)
                    }
                ):Play()
                Utility_m:CreateSound(
                    "rbxassetid://17153811469",
                    2,
                    1,
                    script,
                    true,
                    5
                )
            end))
            table.insert(t_4, v54.Cooldowns.CooldownAdded:Connect(cooldown_effect))
            local _ = v54.Cooldowns.CooldownAdded:Connect(cooldown_effect)

            for _, val_3 in pairs(v54.Cooldowns.Cooldowns) do
                task.spawn(cooldown_effect, val_3)
            end
        end

        arg39._local_fighter.ItemAdded:Connect(update_client_item)
        arg39._local_fighter.ItemRemoved:Connect(update_client_item)
        update_client_item()
    end

    arg39:UpdateVisibility()
    arg39:UpdateVisuals()
    arg39:UpdateWeaponIcon()
end

function t._HookPages(arg42) -- line: 573
    -- upvalues:
    --  [1] Players (copy)

    require(Players.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("Pages")).PageSystem.PagesActivity:Connect(
        function() -- line: 576
            -- upvalues:
            --  [1] arg42 (copy)

            arg42:Button1Up()
        end
    )
end

function t._Setup(arg43) -- line: 581
    -- upvalues:
    --  [1] MechanicsController_m (copy)
    --  [2] InputLibrary_m (copy)

    arg43.Frame.Name = arg43.Name
    local Icon_1 = arg43.Icon
    Icon_1.Image = if not arg43._item_index then arg43._info.Image else "rbxassetid://16793449322"

    if arg43.Name == "mobile_crouch" then
        local function update_icon() -- line: 586
            -- upvalues:
            --  [1] MechanicsController_m (ref)
            --  [2] arg43 (copy)
            --  [3] InputLibrary_m (ref)

            if not MechanicsController_m.IsSliding then
                task.spawn(
                    MechanicsController_m.MobileInput,
                    MechanicsController_m,
                    "mobile_jump",
                    false
                )
            end

            local Icon_2 = arg43.Icon
            Icon_2.Image = not arg43:_IsEasySlideEnabled() and arg43._info.Image or MechanicsController_m.IsSliding and InputLibrary_m.MobileButtons.mobile_jump.Image or MechanicsController_m.IsSprinting and InputLibrary_m.MobileButtons.mobile_slide.Image or arg43._info.Image
        end

        MechanicsController_m.StateChanged:Connect(update_icon)
        update_icon()

        return
    end

    if arg43.Name == "mobile_slide" then
        MechanicsController_m.StateChanged:Connect(function() --[[ update_icon ]] -- line: 600
            -- upvalues:
            --  [1] arg43 (copy)
            --  [2] MechanicsController_m (ref)
            --  [3] InputLibrary_m (ref)

            local Icon_3 = arg43.Icon
            Icon_3.Image = MechanicsController_m.IsSliding and InputLibrary_m.MobileButtons.mobile_jump.Image or arg43._info.Image
        end)
        local Icon_4 = arg43.Icon
        Icon_4.Image = MechanicsController_m.IsSliding and InputLibrary_m.MobileButtons.mobile_jump.Image or arg43._info.Image
    end
end

function t._Init(arg44) -- line: 610
    -- upvalues:
    --  [1] PlayerDataController_m (copy)

    arg44.Buttons.MobileInputs.EditorEnabledChanged:Connect(function() -- line: 611
        -- upvalues:
        --  [1] arg44 (copy)

        arg44:_UpdateEditorVisuals()
        arg44:UpdateVisuals()
    end)
    PlayerDataController_m:GetSettingChangedSignal("MobileButton " .. arg44.Name .. " Enabled"):Connect(
        function() -- line: 616
            -- upvalues:
            --  [1] arg44 (copy)

            arg44:UpdateVisuals()
            arg44:UpdateVisibility()
        end
    )
    PlayerDataController_m:GetSettingChangedSignal("Camera Mobile Button Sinking"):Connect(function() -- line: 621
        -- upvalues:
        --  [1] arg44 (copy)

        arg44:_UpdateCameraSinking()
    end)
    PlayerDataController_m:GetSettingChangedSignal(
        "MobileButton " .. arg44.Name .. " Camera Sinking"
    ):Connect(function() -- line: 625
        -- upvalues:
        --  [1] arg44 (copy)

        arg44:_UpdateCameraSinking()
    end)
    PlayerDataController_m:GetSettingChangedSignal("Mobile Buttons Transparency"):Connect(function() -- line: 629
        -- upvalues:
        --  [1] arg44 (copy)

        arg44:UpdateVisuals()
    end)
    PlayerDataController_m:GetSettingChangedSignal("MobileButton " .. arg44.Name .. " Transparency"):Connect(
        function() -- line: 633
            -- upvalues:
            --  [1] arg44 (copy)

            arg44:UpdateVisuals()
        end
    )
    PlayerDataController_m:GetSettingChangedSignal("MobileButton " .. arg44.Name .. " Override"):Connect(
        function() -- line: 637
            -- upvalues:
            --  [1] arg44 (copy)

            arg44:_UpdateCameraSinking()
            arg44:UpdateVisuals()
        end
    )
    arg44:_Setup()
    arg44:_SetupEditorLogic()
    arg44:_UpdateEditorVisuals()
    arg44:_UpdateCameraSinking()
    arg44:_UpdateAmmo()
    arg44:UpdateVisuals()
    arg44:UpdateWeaponIcon()
    arg44:UpdatePositionAndSize()
    arg44:UpdateVisibility()
    task.defer(arg44._HookPages, arg44)
    task.defer(arg44._HookFighter, arg44)
end

return t
