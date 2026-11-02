local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local CONSTANTS_m = require(ReplicatedStorage.Modules.CONSTANTS)
local CosmeticLibrary_m = require(ReplicatedStorage.Modules.CosmeticLibrary)
local ShopLibrary_m = require(ReplicatedStorage.Modules.ShopLibrary)
local ItemLibrary_m = require(ReplicatedStorage.Modules.ItemLibrary)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local PlayerDataController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.PlayerDataController
)
local EquipmentButtonSlot_m = require(Players.LocalPlayer.PlayerScripts.Modules.EquipmentButtonSlot)
local ButtonEffect_m = require(Players.LocalPlayer.PlayerScripts.Modules.ButtonEffect)
local UILibrary_m = require(Players.LocalPlayer.PlayerScripts.Modules.UILibrary)
local EquipmentQuickActionButton = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild(
    "EquipmentQuickActionButton"
)
local EquipmentUnlockMeBubble = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild(
    "EquipmentUnlockMeBubble"
)
local EquipmentClassSlot = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild(
    "EquipmentClassSlot"
)
local t = {}
t.__index = t

function t.new(arg1) -- line: 26
    -- upvalues:
    --  [1] t (copy)

    local t_1 = setmetatable({}, t)
    t_1.Interface = arg1
    t_1.Frame = t_1.Interface.Frame:WaitForChild("Left")
    t_1.Background = t_1.Frame:WaitForChild("Background")
    t_1.List = t_1.Frame:WaitForChild("List")
    t_1.Container = t_1.List:WaitForChild("Container")
    t_1.Layout = t_1.Container:WaitForChild("Layout")
    t_1.TopBufferFrame = t_1.Container:WaitForChild("TopBuffer")
    t_1._generate_deferred = false
    t_1._cleanup = {}
    t_1._weapon_slots = {}
    t_1._career_slot = nil
    t_1._unlock_me_bubbles = {}
    t_1._previous_canvas_position = nil
    t_1:_Init()

    return t_1
end

function t.SetVisible(arg2, arg3) -- line: 53
    arg2.Frame:TweenPosition(
        arg3 and UDim2.new(0, 0, 0.5, 0) or UDim2.new(-0.375, 0, 0.5, 0),
        "Out",
        "Quint",
        0.25,
        true
    )
end

function t.ScrollTo(arg4, arg5, arg6) -- line: 57
    -- upvalues:
    --  [1] UILibrary_m (copy)
    --  [2] TweenService (copy)

    task.delay(arg6 or 0, function() -- line: 58
        -- upvalues:
        --  [1] arg4 (copy)
        --  [2] arg5 (copy)
        --  [3] UILibrary_m (ref)
        --  [4] TweenService (ref)

        local minimum = math.min(
            arg4.List.AbsoluteCanvasSize.Y,
            arg5.AbsolutePosition.Y + UILibrary_m.MainGui.AbsolutePosition.Y * 2 - arg4.Container.AbsolutePosition.Y
        )
        local v2 = TweenService
        local List = arg4.List
        local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
        v2:Create(List, tweenInfo, { CanvasPosition = Vector2.new(0, minimum) }):Play()
    end)
end

function t.OnStateChanged(arg7) -- line: 64
    arg7:_UpdateActive()
    arg7:_UpdateUnlockMeBubbles()
end

function t.OnOpen(arg8) -- line: 69
    arg8:_GenerateDeferred()
end

function t.Update(arg9, _) -- line: 73
    for _, val in pairs(arg9._unlock_me_bubbles) do
        local Y = val.Bubble.AbsoluteSize.Y
        local v4 = val.Bubble.Parent.AbsoluteSize.Y - val.Bubble.AbsoluteSize.Y
        local clampedValue = math.clamp(
            val.WeaponSlot.Frame.AbsolutePosition.Y + val.WeaponSlot.Frame.AbsoluteSize.Y / 2 - val.Bubble.Parent.AbsolutePosition.Y,
            Y,
            v4
        )
        val.Bubble.Position = UDim2.new(0.7, 0, 0, clampedValue)
        val.Bubble.Button.Arrow.Position = if v4 <= clampedValue then UDim2.new(0.5, 0, 1, -2) else if not (Y >= clampedValue) then UDim2.new(
            0,
            2,
            0.5,
            0
        ) else UDim2.new(0.5, 0, 0, 2)
    end
end

function t._Update(arg11) -- line: 90
    if arg11.Interface.Equipment:IsCustomizing() then
        return
    end

    task.defer(function() -- line: 95
        -- upvalues:
        --  [1] arg11 (copy)

        arg11.TopBufferFrame.Size = UDim2.new(
            1,
            0,
            0,
            (math.max(
                arg11.List.AbsoluteSize.Y * 0.375,
                arg11.List.AbsoluteSize.Y - (arg11.Layout.AbsoluteContentSize.Y - arg11.TopBufferFrame.AbsoluteSize.Y)
            ))
        )
        arg11.List.CanvasSize = UDim2.new(0, 0, 0, arg11.Layout.AbsoluteContentSize.Y)
        arg11.Background.Size = UDim2.new(
            0.7,
            0,
            0,
            arg11.Background.AbsolutePosition.Y + arg11.Background.AbsoluteSize.Y - (arg11.TopBufferFrame.AbsolutePosition.Y + arg11.TopBufferFrame.AbsoluteSize.Y)
        )
    end)
end

function t._UpdateUnlockMeBubbles(arg12) -- line: 102
    -- upvalues:
    --  [1] PlayerDataController_m (copy)
    --  [2] EquipmentUnlockMeBubble (copy)
    --  [3] ButtonEffect_m (copy)

    for _, val_1 in pairs(arg12._unlock_me_bubbles) do
        val_1.Bubble:Destroy()
    end

    arg12._unlock_me_bubbles = {}

    if not arg12.Interface.Equipment.IsOpen or arg12.Interface.Equipment:IsUnlocking() then
        return
    end

    local v6 = arg12.Interface.Equipment:GetSelectedWeapon()

    for key_2, _ in pairs(PlayerDataController_m:Get("FreeWeaponUnlockCheck")) do
        if key_2 ~= v6 and not PlayerDataController_m:GetWeaponData(key_2) then
            local v8 = arg12._weapon_slots[key_2]

            if v8 then
                local v9 = EquipmentUnlockMeBubble:Clone()
                v9.Parent = arg12.Frame
                table.insert(arg12._unlock_me_bubbles, { Bubble = v9, WeaponSlot = v8 })
                ButtonEffect_m:Add(v9.Button)
                v9.Button.MouseButton1Click:Connect(function() -- line: 131
                    -- upvalues:
                    --  [1] arg12 (copy)
                    --  [2] v8 (copy)
                    --  [3] key_2 (copy)

                    arg12:ScrollTo(v8.Frame)
                    arg12.Interface.Equipment:SelectWeapon(key_2)
                end)
            end
        end
    end
end

function t._UpdateActive(arg13) -- line: 138
    local v10 = arg13.Interface.Equipment:IsCareerPageOpen()
    local v11 = arg13.Interface.Equipment:GetSelectedWeapon()

    if arg13._career_slot then
        arg13._career_slot:SetActive(v10)
    end

    for key_3, val_3 in pairs(arg13._weapon_slots) do
        val_3:SetActive(key_3 == v11)
    end
end

function t._GetOrder(_) -- line: 151
    -- upvalues:
    --  [1] PlayerDataController_m (copy)
    --  [2] ShopLibrary_m (copy)
    --  [3] CONSTANTS_m (copy)
    --  [4] ItemLibrary_m (copy)
    --  [5] Utility_m (copy)

    local v14 = PlayerDataController_m:GetUnlockedWeapons(true)
    local v15 = PlayerDataController_m:GetFavoritedWeapons()
    local t_4 = {}
    local t_5 = {}

    for _, val_4 in pairs(
        ShopLibrary_m:GetReleasedOwnableWeapons(
            CONSTANTS_m.WEAPON_REVEAL_TIME_OFFSET,
            ShopLibrary_m.OwnableWeaponsAlphabetized
        )
    ) do
        table.insert(t_5, val_4)

        if ShopLibrary_m:GetTimeUntilWeaponRelease(val_4) > 0 then
            t_4[val_4] = true
        end
    end

    table.sort(t_5, function(arg15, arg16) -- line: 167
        -- upvalues:
        --  [1] v15 (copy)
        --  [2] v14 (copy)
        --  [3] ItemLibrary_m (ref)
        --  [4] Utility_m (ref)

        local v17 = v15[arg15]

        if v17 ~= v15[arg16] then
            return v17
        end

        local v18 = v14[arg15]

        if v18 ~= v14[arg16] then
            return v18
        end

        local Slot = ItemLibrary_m.Classes[ItemLibrary_m.Items[arg15].Class].Slot
        local Slot_1 = ItemLibrary_m.Classes[ItemLibrary_m.Items[arg16].Class].Slot

        if Slot ~= Slot_1 then
            return Slot_1 > Slot
        end

        local Value = ItemLibrary_m.Statuses[ItemLibrary_m.Items[arg15].Status].Value
        local Value_1 = ItemLibrary_m.Statuses[ItemLibrary_m.Items[arg16].Status].Value

        if Value ~= Value_1 then
            return Value_1 > Value
        end

        return Utility_m:StringLessThan(arg15, arg16)
    end)

    return t_5, v14, v15, t_4
end

function t._Generate(arg17) -- line: 203
    -- upvalues:
    --  [1] PlayerDataController_m (copy)
    --  [2] CosmeticLibrary_m (copy)
    --  [3] EquipmentQuickActionButton (copy)
    --  [4] ButtonEffect_m (copy)
    --  [5] ItemLibrary_m (copy)
    --  [6] EquipmentClassSlot (copy)
    --  [7] Utility_m (copy)
    --  [8] CONSTANTS_m (copy)
    --  [9] Players (copy)
    --  [10] EquipmentButtonSlot_m (copy)
    --  [11] ShopLibrary_m (copy)

    for _, val_5 in pairs(arg17._weapon_slots) do
        val_5:Destroy()
    end

    for _, val_6 in pairs(arg17._cleanup) do
        val_6:Destroy()
    end

    arg17._weapon_slots = {}
    arg17._cleanup = {}

    if arg17._career_slot then
        arg17._career_slot:Destroy()
        arg17._career_slot = nil
    end

    arg17._previous_canvas_position = arg17._previous_canvas_position or arg17.List.CanvasPosition

    if not arg17.Interface.Equipment.IsOpen or arg17.Interface.Equipment:IsCustomizing() then
        return
    end

    local v22 = PlayerDataController_m:Get("CosmeticNotifications")
    local v23 = CosmeticLibrary_m:CountNotifications(v22)
    local v24 = CosmeticLibrary_m:CountNotificationsByCosmeticType(v22, "Emote")
    local v25, v26, v27, v28 = arg17:_GetOrder()
    local v29 = false
    local t_6 = {}
    local t_7 = {}

    local function create_quick_action_button_slot(arg18, arg19, arg20, arg21) -- line: 239
        -- upvalues:
        --  [1] t_6 (copy)
        --  [2] t_7 (copy)
        --  [3] EquipmentQuickActionButton (ref)
        --  [4] ButtonEffect_m (ref)

        local Career = t_6.___career

        if not Career or t_7[arg18] then
            return
        end

        local v30 = EquipmentQuickActionButton:Clone()
        v30.LayoutOrder = arg19
        v30.Icon.Image = arg20
        v30.Parent = Career.Container.QuickActions.Container
        ButtonEffect_m:Add(v30)
        v30.MouseButton1Click:Connect(arg21)
        t_7[arg18] = v30
    end

    local function get_class_slot(
        arg22,
        arg23,
        arg24,
        arg25,
        arg26
    ) -- line: 255
        -- upvalues:
        --  [1] t_6 (copy)
        --  [2] ItemLibrary_m (ref)
        --  [3] EquipmentClassSlot (ref)
        --  [4] arg17 (copy)
        --  [5] v23 (copy)
        --  [6] Utility_m (ref)
        --  [7] ButtonEffect_m (ref)
        --  [8] PlayerDataController_m (ref)
        --  [9] create_quick_action_button_slot (copy)
        --  [10] CosmeticLibrary_m (ref)

        if not t_6[arg22] then
            local v31 = ItemLibrary_m.Classes[arg22]
            local v32 = arg23 or v31 and v31.Slot or -999999
            local v33 = arg24 or v31 and v31.Name or ""
            local v34 = arg25 or v31 and v31.ImageDiagonalLeft or ""
            local v35 = arg26 or v31 and v31.ImageDiagonalRight or ""
            local v36 = EquipmentClassSlot:Clone()
            v36.Container.Footer.Visible = false
            v36.Container.QuickActions.Visible = false
            v36.Container.DismissNotifications.Visible = false
            local v37 = v33
            local Header = v36.Container.Header

            if v37 then
                v37 = v33 ~= ""
            end

            Header.Visible = v37
            v36.Container.Header.Title.Left.Image = v34
            v36.Container.Header.Title.Right.Image = v35
            v36.Container.Header.Title.Text = v33
            v36.LayoutOrder = v32
            v36.ZIndex = v36.LayoutOrder
            v36.Parent = arg17.Container
            table.insert(arg17._cleanup, v36)
            t_6[arg22] = v36
            local Layout = v36.Container.Layout
            local Title_1 = v36.Container.Header.Title
            local Left = v36.Container.Header.Title.Left
            local Right = v36.Container.Header.Title.Right

            local function update() -- line: 285
                -- upvalues:
                --  [1] v36 (copy)
                --  [2] Layout (copy)
                --  [3] Left (copy)
                --  [4] Title_1 (copy)
                --  [5] Right (copy)

                v36.Size = UDim2.new(1, 0, 0, Layout.AbsoluteContentSize.Y)
                Left.Position = UDim2.new(0.5, -Title_1.TextBounds.X / 2, 0.5, 0)
                Right.Position = UDim2.new(0.5, Title_1.TextBounds.X / 2, 0.5, 0)
            end

            local Header_1 = v36.Container.Header
            Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(update)
            Header_1:GetPropertyChangedSignal("AbsoluteSize"):Connect(update)
            Title_1:GetPropertyChangedSignal("TextBounds"):Connect(update)
            update()

            if arg22 == "___career" then
                v36.Container.QuickActions.Visible = true
                local DismissNotifications = v36.Container.DismissNotifications
                DismissNotifications.Visible = v23 > 0
                v36.Container.DismissNotifications.Button.Title.Text = string.format(
                    "Dismiss <font weight=\"800\">%s</font> Notification%s",
                    Utility_m:PrettyNumber(v23),
                    if v23 == 1 then "" else "s"
                )
                local t_8 = {
                    HoverRatio = UDim2.new(0, 10, 0, 10),
                    ReleaseRatio = UDim2.new(0, 10, 0, 10)
                }
                ButtonEffect_m:Add(v36.Container.DismissNotifications.Button, nil, t_8)
                v36.Container.DismissNotifications.Button.MouseButton1Click:Connect(function() -- line: 303
                    -- upvalues:
                    --  [1] PlayerDataController_m (ref)

                    PlayerDataController_m:SilenceCosmeticNotification(nil, nil)
                end)
                create_quick_action_button_slot("___career", -1, CosmeticLibrary_m.Types.Emote.Image, function() -- line: 307
                    -- upvalues:
                    --  [1] arg17 (ref)

                    arg17.Interface.Equipment:StartCustomizing("Emote")
                end)
            end
        end

        return t_6[arg22].Container
    end

    local formattedText = string.format(CONSTANTS_m.HEADSHOT_IMAGE, Players.LocalPlayer.UserId)
    local v49 = get_class_slot("___career", -3)
    arg17._career_slot = EquipmentButtonSlot_m.new(
        "___career",
        -999998,
        true,
        "Career",
        formattedText,
        nil,
        v24
    )
    arg17._career_slot:SetCareerIcon()
    arg17._career_slot:SetParent(v49)
    arg17._career_slot.Button.MouseButton1Click:Connect(function() -- line: 324
        -- upvalues:
        --  [1] arg17 (copy)

        arg17.Interface.Equipment:OpenCareerPage(true)
    end)
    local t_9 = {}
    local v53

    for key_7, val_7 in pairs(v25) do
        local formattedText = ItemLibrary_m.Items[val_7]
        local v24 = ItemLibrary_m.Classes[formattedText.Class]
        v53 = PlayerDataController_m:GetWeaponData(val_7)
        local v54 = v26[val_7]
        local v55 = not v54

        if v55 then
            v55 = v28[val_7]
        end

        local v56 = v27[val_7]
        local v57 = if not v55 then if not v56 then formattedText.Class else "___favorited" else "___comingsoon"
        local v58 = if not v55 then if not v56 then get_class_slot(v57) else get_class_slot(v57, -1) else get_class_slot(
            v57,
            -2,
            "Coming Soon",
            "rbxassetid://18195730712",
            "rbxassetid://18195730712"
        )
        v56 = if not v55 then val_7 else "???"
        local v59 = v53 and ItemLibrary_m:GetViewModelImageFromWeaponData(v53) or ItemLibrary_m:GetViewModelImage(
            val_7
        ) or ""
        v53 = v54

        if v53 then
            v53 = CosmeticLibrary_m:CountNotificationsByWeapon(v22, val_7)
        end

        local v60 = EquipmentButtonSlot_m.new(
            val_7,
            key_7,
            v54,
            v56,
            v59,
            formattedText.Status,
            v53
        )
        v60:SetParent(v58)
        arg17._weapon_slots[val_7] = v60
        local v61 = t_9[v57] or {}
        t_9[v57] = v61
        table.insert(t_9[v57], v60)
        v60.Button.MouseButton1Click:Connect(function() -- line: 354
            -- upvalues:
            --  [1] arg17 (copy)
            --  [2] val_7 (copy)

            arg17.Interface.Equipment:SelectWeapon(val_7)
        end)
        create_quick_action_button_slot(formattedText.Class, v24.Slot, v24.ImageDiagonalRight, function() -- line: 359
            -- upvalues:
            --  [1] t_9 (copy)
            --  [2] formattedText (copy)
            --  [3] CONSTANTS_m (ref)
            --  [4] v24 (copy)
            --  [5] arg17 (copy)

            local v62 = if not t_9[formattedText.Class] then CONSTANTS_m.DEFAULT_WEAPONS[v24.Slot] else t_9[formattedText.Class][1].Name
            arg17.Interface.Equipment:SelectWeapon(v62)
            arg17:ScrollTo(arg17._weapon_slots[v62].Frame)
        end)
        v29 = v29 or v55
    end

    local v63 = #ShopLibrary_m.OwnableWeapons - #v25
    local Comingsoon = t_6.___comingsoon
    local v64

    if Comingsoon then
        local Footer = Comingsoon.Container.Footer
        v64 = v29 and v63 > 0
        Footer.Visible = v64
        local Title_2 = Comingsoon.Container.Footer.Title
        v53 = if v63 ~= 1 then "s" else ""
        Title_2.Text = "+" .. v63 .. " more weapon" .. v53 .. "!"
    end

    v64 = arg17._previous_canvas_position
    local List_2 = arg17.List
    v64 = v64 or arg17.List.CanvasPosition
    List_2.CanvasPosition = v64
    arg17._previous_canvas_position = nil
    arg17:_UpdateActive()
    arg17:_UpdateUnlockMeBubbles()
end

function t._GenerateDeferred(arg27) -- line: 387
    if arg27._generate_deferred then
        return
    end

    arg27._generate_deferred = true
    task.defer(function() -- line: 394
        -- upvalues:
        --  [1] arg27 (copy)

        arg27._generate_deferred = false
        arg27:_Generate()
    end)
end

function t._Setup(arg28) -- line: 400
    arg28.Frame.Visible = true
end

function t._Init(arg29) -- line: 404
    -- upvalues:
    --  [1] PlayerDataController_m (copy)

    arg29.Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() -- line: 405
        -- upvalues:
        --  [1] arg29 (copy)

        arg29:_Update()
    end)
    arg29.Background:GetPropertyChangedSignal("AbsolutePosition"):Connect(function() -- line: 409
        -- upvalues:
        --  [1] arg29 (copy)

        arg29:_Update()
    end)
    arg29.Background:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- line: 413
        -- upvalues:
        --  [1] arg29 (copy)

        arg29:_Update()
    end)
    arg29.TopBufferFrame:GetPropertyChangedSignal("AbsolutePosition"):Connect(function() -- line: 417
        -- upvalues:
        --  [1] arg29 (copy)

        arg29:_Update()
    end)
    arg29.TopBufferFrame:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- line: 421
        -- upvalues:
        --  [1] arg29 (copy)

        arg29:_Update()
    end)
    arg29.Interface.Equipment.UnlockingChanged:Connect(function() -- line: 425
        -- upvalues:
        --  [1] arg29 (copy)

        arg29:_UpdateUnlockMeBubbles()
    end)
    arg29.Interface.Equipment.CustomizingChanged:Connect(function() -- line: 429
        -- upvalues:
        --  [1] arg29 (copy)

        arg29:_GenerateDeferred()
    end)
    PlayerDataController_m:GetDataChangedSignal("FreeWeaponUnlockCheck"):Connect(function() -- line: 433
        -- upvalues:
        --  [1] arg29 (copy)

        arg29:_UpdateUnlockMeBubbles()
    end)
    PlayerDataController_m:GetDataChangedSignal("WeaponInventory"):Connect(function() -- line: 437
        -- upvalues:
        --  [1] arg29 (copy)

        arg29:_GenerateDeferred()
    end)
    PlayerDataController_m:GetDataChangedSignal("CosmeticNotifications"):Connect(function() -- line: 441
        -- upvalues:
        --  [1] arg29 (copy)

        arg29:_GenerateDeferred()
    end)
    PlayerDataController_m.StatisticsUpdated:Connect(function() -- line: 445
        -- upvalues:
        --  [1] arg29 (copy)

        arg29:_GenerateDeferred()
    end)
    arg29:_Setup()
    arg29:_Update()
    arg29:_GenerateDeferred()
end

return t
