local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")
local CONSTANTS_m = require(ReplicatedStorage.Modules.CONSTANTS)
local CosmeticLibrary_m = require(ReplicatedStorage.Modules.CosmeticLibrary)
local SeasonLibrary_m = require(ReplicatedStorage.Modules.SeasonLibrary)
local InputLibrary_m = require(ReplicatedStorage.Modules.InputLibrary)
local EventLibrary_m = require(ReplicatedStorage.Modules.EventLibrary)
local TaskLibrary_m = require(ReplicatedStorage.Modules.TaskLibrary)
local ItemLibrary_m = require(ReplicatedStorage.Modules.ItemLibrary)
local PlayerDataController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("PlayerDataController")
)
local _ = require(Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("ShopController"))
local CosmeticViewportFrame_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("CosmeticViewportFrame")
)
local MobileInputs_m = require(
    Players.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("MobileInputs")
)
local EmoteViewportFrame_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("EmoteViewportFrame")
)
local Teleporting_m = require(
    Players.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("Teleporting")
)
local Equipment_m = require(
    Players.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("Equipment")
)
local Queue_m = require(
    Players.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("Queue")
)
local Pages_m = require(
    Players.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("Pages")
)
local ButtonEffect_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("ButtonEffect")
)
local UILibrary_m = require(Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("UILibrary"))
local LobbyButtonSlot = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild(
    "LobbyButtonSlot"
)
local t = {
    { "Backpack", "Backpack", "See your extra loot", "rbxassetid://18185474596" },
    { "Career", "Career", "Check out your collection & statistics", nil },
    { "Equipment", "Weapons", "View your weapons, career, emotes, & more", nil, "UIOpenPage1" },
    { "Tasks", "Tasks", "Complete tasks to earn keys", "rbxassetid://17653923757", "UIOpenPage2" },
    {
        "Shop",
        "Shop",
        "Unlock weapons, redeem codes, & more",
        "rbxassetid://17619445340",
        "UIOpenPage3"
    },
    {
        "BattlePass",
        "Pass",
        "Free weapons, skins, keys, & more",
        "rbxassetid://81577092220450",
        "UIOpenPage4"
    },
    { "Settings", "Settings", "Change crosshair & hotkeys", "rbxassetid://17619445191" },
    { "Rewards", "Codes", "Earn free rewards & redeem codes", "rbxassetid://84811629597038" },
    { "Recover", "Recover", "Recover your win streak", "rbxassetid://112615701583145" },
    { "EventOverview", "Event", "Here for a limited time only!", nil },
    { "EquipmentExit", "Leave", nil, "rbxassetid://17619444538", "UICancelAction" },
    {
        "Emotes",
        "Emotes",
        "Preview & equip your emotes",
        "rbxassetid://111957823189761",
        "UIOpenPage1"
    },
    {
        "Maps",
        "Maps",
        "View map details & map contracts",
        "rbxassetid://112880011932436",
        "UIOpenPage2"
    },
    {
        "DuelHistory",
        "History",
        "Check out your most recent duels",
        "rbxassetid://18678814606",
        "UIOpenPage3"
    },
    {
        "Collection",
        "Collection",
        "Quickly view your game progress",
        "rbxassetid://18186174849",
        "UIOpenPage4"
    },
    { "Contracts", "Contracts", "Earn free keys & cosmetics", "rbxassetid://17619445009" },
    { "Skins", "Skin", "Change how this weapon looks", nil, "UIOpenPage1" },
    { "Wraps", "Wrap", "Apply a wrap to this weapon", nil, "UIOpenPage2" },
    { "Charms", "Charm", "Equip a gun buddy", nil, "UIOpenPage3" },
    { "Finishers", "Finisher", "Play an effect on elimination", nil, "UIOpenPage4" }
}
local t_21 = {}
t_21.__index = t_21

function t_21._new() -- line: 59
    -- upvalues:
    --  [1] t_21 (copy)
    --  [2] UILibrary_m (copy)

    local t_22 = setmetatable({}, t_21)
    t_22.IsOpen = false
    t_22.Frame = UILibrary_m:GetTo("MainFrame", "Lobby", "Buttons")
    t_22._visibility_effect_hash = 0
    t_22._hover_effect_hash = 0
    t_22._buttons = {}
    t_22._button_callbacks = {}
    t_22._unhover_functions = {}
    t_22._wraps_cosmetic_viewport_frame = nil
    t_22._charms_cosmetic_viewport_frame = nil
    t_22._emotes_emote_viewport_frame = nil
    t_22:_Init()

    return t_22
end

function t_21._Unhover(arg1) -- line: 89
    for _, val in pairs(arg1._unhover_functions) do
        val()
    end
end

function t_21._UpdateVisibility(arg2) -- line: 95
    -- upvalues:
    --  [1] Pages_m (copy)
    --  [2] Equipment_m (copy)
    --  [3] Queue_m (copy)
    --  [4] Teleporting_m (copy)
    --  [5] MobileInputs_m (copy)
    --  [6] GuiService (copy)

    local v12 = not Pages_m.PageSystem.CurrentPage

    if v12 then
        v12 = not Equipment_m:IsUnlocking()

        if v12 then
            v12 = not Queue_m:IsVisible()

            if v12 then
                v12 = not Teleporting_m.Enabled and not MobileInputs_m.EditorEnabled and not GuiService.MenuIsOpen
            end
        end
    end

    arg2.IsOpen = v12
    v12 = arg2.Frame.Container
    v12:TweenPosition(
        arg2.IsOpen and UDim2.new(0.5, 0, 0.9625, -20) or UDim2.new(0.5, 0, 1.3, 20),
        "Out",
        "Quint",
        0.25,
        true
    )
    arg2:_Unhover()
end

function t_21._PlayButtonVisibilityEffect(arg3) -- line: 101
    -- upvalues:
    --  [1] GuiService (copy)

    arg3._visibility_effect_hash += 1
    local VisibilityEffectHash = arg3._visibility_effect_hash
    local t_23 = {}

    for _, val_1 in pairs(arg3._buttons) do
        if val_1.Visible then
            table.insert(t_23, val_1)
        end
    end

    table.sort(t_23, function(arg4, arg5) -- line: 113
        return arg4.LayoutOrder < arg5.LayoutOrder
    end)

    for key_2, val_2 in pairs(t_23) do
        if GuiService.ReducedMotionEnabled then
            val_2.Size = UDim2.new(1, 0, 1, 0)
            val_2:TweenSize(
                UDim2.new(1, 0, 1, 0),
                "Out",
                "Linear",
                0,
                true
            )
        else
            val_2.Size = UDim2.new(0, 0, 0, 0)
            val_2:TweenSize(
                UDim2.new(0, 0, 0, 0),
                "Out",
                "Linear",
                0,
                true
            )
            task.delay(0.1 * (key_2 - 1), function() -- line: 127
                -- upvalues:
                --  [1] VisibilityEffectHash (copy)
                --  [2] arg3 (copy)
                --  [3] val_2 (copy)

                if VisibilityEffectHash ~= arg3._visibility_effect_hash then
                    return
                end

                val_2:TweenSize(
                    UDim2.new(1, 0, 1, 0),
                    "Out",
                    "Back",
                    0.25,
                    true
                )
            end)
        end
    end
end

function t_21._UpdateButtonInformation(arg6) -- line: 137
    -- upvalues:
    --  [1] PlayerDataController_m (copy)
    --  [2] SeasonLibrary_m (copy)
    --  [3] Equipment_m (copy)
    --  [4] CONSTANTS_m (copy)
    --  [5] ItemLibrary_m (copy)
    --  [6] CosmeticLibrary_m (copy)
    --  [7] CosmeticViewportFrame_m (copy)
    --  [8] EmoteViewportFrame_m (copy)

    if arg6._wraps_cosmetic_viewport_frame then
        arg6._wraps_cosmetic_viewport_frame:Destroy()
        arg6._wraps_cosmetic_viewport_frame = nil
    end

    if arg6._charms_cosmetic_viewport_frame then
        arg6._charms_cosmetic_viewport_frame:Destroy()
        arg6._charms_cosmetic_viewport_frame = nil
    end

    if arg6._emotes_emote_viewport_frame then
        arg6._emotes_emote_viewport_frame:Destroy()
        arg6._emotes_emote_viewport_frame = nil
    end

    local v17 = PlayerDataController_m:Get("Seasons")[SeasonLibrary_m.CurrentSeason.Name]
    local v16 = v17

    if v16 then
        v16 = v17.BattlePass
    end

    v17 = v16 and v16.MaxPassTrackNum or 0
    arg6._buttons.BattlePass.Button.Container.Icon.Image = SeasonLibrary_m.PASS_TRACK_IMAGES[math.clamp(
        v17,
        1,
        #SeasonLibrary_m.PASS_TRACK_IMAGES
    )]
    v16 = PlayerDataController_m:GetWeaponData(Equipment_m:GetSelectedWeapon())
    local v19 = CONSTANTS_m.COSMETIC_IMAGES[if v16 then if not v16.Skin then "NONE_COSMETIC" else v16.Skin.Name or "NONE_COSMETIC" else "NONE_COSMETIC"]
    local v20 = v19
    local Icon_1 = arg6._buttons.Skins.Button.Container.Icon

    if not v20 then
        v20 = v16 and ItemLibrary_m:GetViewModelImageFromWeaponData(v16) or ""
    end

    Icon_1.Image = v20
    v20 = if not v19 then 0 else 0.875
    arg6._buttons.Skins.Button.Container.Icon.ImageTransparency = v20
    local Icon_3 = arg6._buttons.Skins.Button.Container.Icon
    local v21 = v19 and UDim2.new(0.4, 0, 0.4, 0) or UDim2.new(1.875, 0, 1.875, 0)
    Icon_3.Size = v21
    local v22 = v16 and v16.Finisher and v16.Finisher.Name or "NONE_COSMETIC"
    v17 = CONSTANTS_m.COSMETIC_IMAGES[v22]
    local Icon_4 = arg6._buttons.Finishers.Button.Container.Icon
    v21 = v17 or CosmeticLibrary_m.Cosmetics[v16.Finisher.Name].Image
    Icon_4.Image = v21
    v21 = if not v17 then 0 else 0.875
    arg6._buttons.Finishers.Button.Container.Icon.ImageTransparency = v21
    local Icon_6 = arg6._buttons.Finishers.Button.Container.Icon
    Icon_6.Size = v17 and UDim2.new(0.4, 0, 0.4, 0) or UDim2.new(0.75, 0, 0.75, 0)
    local UICorner = arg6._buttons.Finishers.Button.Container.Icon.UICorner
    UICorner.CornerRadius = v17 and UDim.new(0, 0) or UDim.new(1, 0)
    v22 = v16 and v16.Wrap and v16.Wrap.Name or "NONE_COSMETIC"
    local v25 = CONSTANTS_m.COSMETIC_IMAGES[v22]
    arg6._buttons.Wraps.Button.Container.Icon.Image = v25 or ""
    arg6._buttons.Wraps.Button.Container.Icon.ImageTransparency = if not v25 then 0 else 0.875
    local Icon_8 = arg6._buttons.Wraps.Button.Container.Icon
    Icon_8.Size = v25 and UDim2.new(0.4, 0, 0.4, 0) or UDim2.new(0.75, 0, 0.75, 0)

    if v22 ~= "NONE_COSMETIC" and v22 ~= "RANDOM_COSMETIC" then
        arg6._wraps_cosmetic_viewport_frame = CosmeticViewportFrame_m.new(v22)
        arg6._wraps_cosmetic_viewport_frame.Frame.Parent = arg6._buttons.Wraps.Button.Container
        local UICorner_1 = Instance.new("UICorner")
        UICorner_1.CornerRadius = UDim.new(1, 0)
        UICorner_1.Parent = arg6._wraps_cosmetic_viewport_frame.Frame
    end

    v22 = v16 and v16.Charm and v16.Charm.Name or "NONE_COSMETIC"
    local v28 = CONSTANTS_m.COSMETIC_IMAGES[v22]
    arg6._buttons.Charms.Button.Container.Icon.Image = v28 or ""
    arg6._buttons.Charms.Button.Container.Icon.ImageTransparency = if not v28 then 0 else 0.875
    local Icon_10 = arg6._buttons.Charms.Button.Container.Icon
    Icon_10.Size = v28 and UDim2.new(0.4, 0, 0.4, 0) or UDim2.new(0.75, 0, 0.75, 0)

    if v22 ~= "NONE_COSMETIC" and v22 ~= "RANDOM_COSMETIC" then
        arg6._charms_cosmetic_viewport_frame = CosmeticViewportFrame_m.new(v22)
        arg6._charms_cosmetic_viewport_frame.Frame.Parent = arg6._buttons.Charms.Button.Container
        local UICorner_2 = Instance.new("UICorner")
        UICorner_2.CornerRadius = UDim.new(1, 0)
        UICorner_2.Parent = arg6._charms_cosmetic_viewport_frame.Frame
    end

    v22 = PlayerDataController_m:Get("EquippedEmotes")
    local v31 = if not next(v22) then "NONE_COSMETIC" else nil
    local v32 = CONSTANTS_m.COSMETIC_IMAGES[v31]
    arg6._buttons.Emotes.Button.Container.Icon.Image = v32 or ""
    arg6._buttons.Emotes.Button.Container.Icon.ImageTransparency = if not v32 then 0 else 0.875
    local Icon_12 = arg6._buttons.Emotes.Button.Container.Icon
    Icon_12.Size = v32 and UDim2.new(0.4, 0, 0.4, 0) or UDim2.new(0.75, 0, 0.75, 0)

    if not v31 then
        local t_24 = {}

        for _, val_3 in pairs(v22) do
            table.insert(t_24, val_3.Name)
        end

        arg6._emotes_emote_viewport_frame = EmoteViewportFrame_m.new(t_24[math.random(#t_24)])
        arg6._emotes_emote_viewport_frame:HideShadow()
        arg6._emotes_emote_viewport_frame:SetParent(arg6._buttons.Emotes.Button.Container)
    end
end

function t_21._UpdateButtonVisibility(arg7) -- line: 231
    -- upvalues:
    --  [1] Equipment_m (copy)
    --  [2] PlayerDataController_m (copy)
    --  [3] SeasonLibrary_m (copy)
    --  [4] EventLibrary_m (copy)
    --  [5] ItemLibrary_m (copy)

    local IsOpen = Equipment_m.IsOpen
    local v35 = Equipment_m:IsOpenEffectDone()
    local v36 = IsOpen

    if v36 then
        v36 = Equipment_m:IsCareerPageOpen()
    end

    local v37 = IsOpen

    if v37 then
        v37 = Equipment_m:GetSelectedWeapon()
    end

    local v38 = if PlayerDataController_m:GetWeaponData(v37) == nil then false else true
    local v39 = not Equipment_m:IsCustomizing()
    local StatisticDuelsPlayed = PlayerDataController_m:GetStatistic("StatisticDuelsPlayed")
    local _ = PlayerDataController_m:GetStatistic("StatisticDuelsWon")
    local v40 = not IsOpen
    local Backpack = arg7._buttons.Backpack

    if v40 then
        v40 = #PlayerDataController_m:Get("UnclaimedRewards") > 0 and true
    end

    Backpack.Visible = v40
    arg7._buttons.Career.Visible = false
    arg7._buttons.Equipment.Visible = not IsOpen
    arg7._buttons.Tasks.Visible = not IsOpen
    local v41 = not IsOpen
    local Shop = arg7._buttons.Shop
    v41 = v41 and StatisticDuelsPlayed >= 3
    Shop.Visible = v41
    v41 = not IsOpen
    local BattlePass = arg7._buttons.BattlePass
    v41 = v41 and StatisticDuelsPlayed >= 10 and SeasonLibrary_m.CurrentSeason.BattlePassActive
    BattlePass.Visible = v41
    v41 = not IsOpen
    local Rewards = arg7._buttons.Rewards
    v41 = v41 and StatisticDuelsPlayed >= 5 and StatisticDuelsPlayed < 15
    Rewards.Visible = v41
    v41 = not IsOpen
    local Recover = arg7._buttons.Recover

    if v41 then
        v41 = #PlayerDataController_m:Get("StoredStreaks") > 0 and true
    end

    Recover.Visible = v41
    v41 = not IsOpen
    local EventOverview = arg7._buttons.EventOverview
    v41 = v41 and EventLibrary_m.IS_ACTIVE and StatisticDuelsPlayed >= EventLibrary_m.NUM_GAMES_NEEDED_TO_PARTICIPATE
    EventOverview.Visible = v41
    v41 = IsOpen and v35 and v39
    arg7._buttons.EquipmentExit.Visible = v41
    arg7._buttons.Contracts.Visible = false
    local v42 = IsOpen and v35 and v38 and v39
    arg7._buttons.Skins.Visible = v42
    v42 = IsOpen and v35 and v38 and v39
    arg7._buttons.Wraps.Visible = v42
    v42 = IsOpen and v35 and v38 and v39
    arg7._buttons.Charms.Visible = v42
    local Finishers = arg7._buttons.Finishers
    v42 = IsOpen and v35 and v38 and v39 and ItemLibrary_m.Items[v37] and ItemLibrary_m.Items[v37].CanEliminate
    Finishers.Visible = v42
    v42 = IsOpen and v35 and v36 and v39
    arg7._buttons.Emotes.Visible = v42
    arg7._buttons.Maps.Visible = false
    arg7._buttons.DuelHistory.Visible = false
    arg7._buttons.Collection.Visible = false
    local v43 = not IsOpen
    local Settings = arg7._buttons.Settings
    v43 = v43 and not arg7._buttons.Recover.Visible
    Settings.Visible = v43
    arg7:_UpdateButtonInformation()
    arg7:_PlayButtonVisibilityEffect()
    arg7:_Unhover()
end

function t_21._CreateButton(
    arg8,
    arg9,
    arg10,
    arg11,
    arg12,
    arg13,
    arg14
) -- line: 276
    -- upvalues:
    --  [1] LobbyButtonSlot (copy)
    --  [2] Players (copy)
    --  [3] PlayerDataController_m (copy)
    --  [4] TaskLibrary_m (copy)
    --  [5] Pages_m (copy)
    --  [6] SeasonLibrary_m (copy)
    --  [7] Equipment_m (copy)
    --  [8] CosmeticLibrary_m (copy)
    --  [9] ButtonEffect_m (copy)

    local v44 = LobbyButtonSlot:Clone()
    v44.Button.Container.Title.Text = arg11
    v44.Button.Container.Icon.Image = arg13 or ""
    v44.Button.Container.Bubble.Title.Text = arg12 or ""
    v44.Button.Inputs.Gamepad.Keybind:SetAttribute("InputName", arg14)
    v44.LayoutOrder = arg9
    local v45 = 0

    local function open() -- line: 286
        -- upvalues:
        --  [1] v44 (copy)
        --  [2] v45 (ref)
        --  [3] Players (ref)
        --  [4] arg12 (copy)

        if v44.Button.Container.NotificationBubble.Visible then
            return
        end

        v45 += 1
        local v46 = v45
        local isDescendant = v44:IsDescendantOf(Players)

        if isDescendant then
            v44.Button.Container:TweenPosition(
                UDim2.new(0.5, 0, 0.375, 0),
                "Out",
                "Quint",
                0.25,
                true
            )
        else
            v44.Button.Container.Position = UDim2.new(0.5, 0, 0.375, 0)
        end

        if arg12 then
            v44.Button.Container.Bubble.Visible = true
            v44.Button.Container.Bubble.Position = UDim2.new(0.5, 0, 0, 0)

            if isDescendant then
                v44.Button.Container.Bubble.Size = UDim2.new(0, 0, 0.125, 0)
                v44.Button.Container.Bubble:TweenSize(
                    UDim2.new(5, 0, 0.25, 0),
                    "Out",
                    "Quint",
                    0.25,
                    true
                )
            else
                v44.Button.Container.Bubble.Size = UDim2.new(5, 0, 0.25, 0)
            end

            task.spawn(function() -- line: 312
                -- upvalues:
                --  [1] v46 (copy)
                --  [2] v45 (ref)
                --  [3] v44 (ref)
                --  [4] Players (ref)

                wait(1)

                while true do
                    if v46 ~= v45 then
                        return
                    end

                    if v44:IsDescendantOf(Players) then
                        v44.Button.Container.Bubble:TweenPosition(
                            UDim2.new(0.5, 0, -0.125, 0),
                            "Out",
                            "Sine",
                            0.5,
                            true
                        )
                    end

                    wait(0.5)

                    if v46 ~= v45 then
                        return
                    end

                    if v44:IsDescendantOf(Players) then
                        v44.Button.Container.Bubble:TweenPosition(
                            UDim2.new(0.5, 0, 0, 0),
                            "In",
                            "Sine",
                            0.5,
                            true
                        )
                    end

                    wait(0.5)
                end
            end)
        end
    end

    v44.Button.MouseEnter:Connect(open)

    if
        arg10 == "Tasks"
        and PlayerDataController_m:Get("BeginnerTasksCompleted") < TaskLibrary_m.NUM_BEGINNER_TASKS
    then
        open()
    end

    if arg10 == "Shop" then
        local Button = v44.Button.Container.NotificationBubble.Title
        Button.Text = "Claim your FREE reward now!"
        local v48 = false
        v44.Button.MouseButton1Click:Connect(function() -- line: 352
            -- upvalues:
            --  [1] v48 (ref)

            v48 = true
        end)

        local function notification_bubble() -- line: 356
            -- upvalues:
            --  [1] v44 (copy)
            --  [2] v48 (ref)
            --  [3] Pages_m (ref)
            --  [4] PlayerDataController_m (ref)

            local v49 = not v48
            local NotificationBubble = v44.Button.Container.NotificationBubble

            if v49 then
                v49 = not Pages_m.PageSystem.CurrentPage

                if v49 then
                    v49 = not PlayerDataController_m:Get("ClaimedLoginRewardToday")

                    if v49 then
                        v49 = PlayerDataController_m:GetStatistic("StatisticDuelsPlayed") > 3 and true
                    end
                end
            end

            NotificationBubble.Visible = v49
        end

        PlayerDataController_m:GetDataChangedSignal("ClaimedLoginRewardToday"):Connect(
            notification_bubble
        )
        PlayerDataController_m:GetDataChangedSignal("StatisticDuelsPlayed"):Connect(
            notification_bubble
        )
        Pages_m.PageSystem.PageOpened:Connect(notification_bubble)
        Pages_m.PageSystem.PageClosed:Connect(notification_bubble)
        local Button_2 = v44.Button.Container.NotificationBubble
        local v54 = not v48

        if v54 then
            v54 = not Pages_m.PageSystem.CurrentPage

            if v54 then
                v54 = not PlayerDataController_m:Get("ClaimedLoginRewardToday")

                if v54 then
                    v54 = PlayerDataController_m:GetStatistic("StatisticDuelsPlayed") > 3 and true
                end
            end
        end

        Button_2.Visible = v54
    elseif arg10 == "Backpack" then
        local v55 = PlayerDataController_m:Get("UnclaimedRewards") or {}
        local v56 = #v55
        v55 = 0
        PlayerDataController_m:GetDataChangedSignal("UnclaimedRewards"):Connect(function() -- line: 369
            -- upvalues:
            --  [1] PlayerDataController_m (ref)
            --  [2] v55 (ref)
            --  [3] v56 (ref)
            --  [4] v44 (copy)

            local v58 = #(PlayerDataController_m:Get("UnclaimedRewards") or {})
            v55 = v55 + math.max(0, v58 - v56)
            v56 = v58
            v44.Button.Container.Notification.Visible = v55 > 0 and true
            v44.Button.Container.Notification.Title.Text = v55
        end)
        Pages_m.PageSystem.PageOpened:Connect(function() -- line: 379
            -- upvalues:
            --  [1] Pages_m (ref)
            --  [2] v55 (ref)
            --  [3] v44 (copy)

            if Pages_m.PageSystem.CurrentPage.Name == "Backpack" then
                v55 = 0
                v44.Button.Container.Notification.Visible = false
            end
        end)
    elseif arg10 == "Tasks" then
        local function update() -- line: 386
            -- upvalues:
            --  [1] PlayerDataController_m (ref)
            --  [2] v44 (copy)

            local v62 = #PlayerDataController_m:Get("Tasks") - PlayerDataController_m:GetNumTasksCompleted()
            v44.Button.Container.Notification.Visible = v62 > 0 and true
            v44.Button.Container.Notification.Title.Text = v62
        end

        PlayerDataController_m:GetDataChangedSignal("BonusTasks"):Connect(update)
        PlayerDataController_m:GetDataChangedSignal("Tasks"):Connect(update)
        local v67 = #PlayerDataController_m:Get("Tasks") - PlayerDataController_m:GetNumTasksCompleted()
        v44.Button.Container.Notification.Visible = v67 > 0 and true
        v44.Button.Container.Notification.Title.Text = v67
    elseif arg10 == "BattlePass" then
        local function update_1() --[[ update ]] -- line: 397
            -- upvalues:
            --  [1] PlayerDataController_m (ref)
            --  [2] SeasonLibrary_m (ref)
            --  [3] v44 (copy)

            local v69 = 0
            local v71 = PlayerDataController_m:Get("Seasons")[SeasonLibrary_m.CurrentSeason.Name]
            local v70 = v71

            if v70 then
                v70 = v71.BattlePass
            end

            v71 = v70 and v70.PassLevel or 0
            local v72 = v70 and v70.MaxPassTrackNum or 0

            for index = 1, v71 do
                for index_1 = 1, v72 do
                    if
                        SeasonLibrary_m.CurrentSeason.BattlePassRewards[index]
                        and SeasonLibrary_m.CurrentSeason.BattlePassRewards[index][index_1]
                    then
                        local v73 = v71 >= index and v72 >= index_1
                        local v74 = v70

                        if v74 then
                            v74 = v70.RewardsClaimed[tostring(index)]

                            if v74 then
                                v74 = v70.RewardsClaimed[tostring(index)][tostring(index_1)]
                            end
                        end

                        v69 = if not v73 then v69 else if v74 then v69 else v69 + 1
                    end
                end
            end

            local Notification_3 = v44.Button.Container.Notification
            Notification_3.Visible = v69 > 0
            v44.Button.Container.Notification.Title.Text = v69
        end

        PlayerDataController_m:GetDataChangedSignal("Seasons"):Connect(update_1)
        update_1()
    elseif
        arg10 == "Equipment"
        or arg10 == "Skins"
        or arg10 == "Wraps"
        or arg10 == "Charms"
        or arg10 == "Finishers"
        or arg10 == "Emotes"
    then
        local function update_cosmetic_notifications() -- line: 427
            -- upvalues:
            --  [1] PlayerDataController_m (ref)
            --  [2] Equipment_m (ref)
            --  [3] arg10 (copy)
            --  [4] CosmeticLibrary_m (ref)
            --  [5] v44 (copy)

            local v79 = PlayerDataController_m:Get("CosmeticNotifications")
            local v80 = PlayerDataController_m:GetUnlockedWeapons(true)
            local v81 = Equipment_m:GetSelectedWeapon()
            local v82 = if arg10 == "Equipment" then CosmeticLibrary_m:CountNotifications(
                v79,
                nil,
                v80
            ) else CosmeticLibrary_m:CountNotificationsByCosmeticType(
                v79,
                string.sub(arg10, 1, #arg10 - 1),
                v81,
                v80
            )
            local Notification_4 = v44.Button.Container.Notification
            Notification_4.Visible = v82 > 0
            v44.Button.Container.Notification.Title.Text = v82
        end

        PlayerDataController_m:GetDataChangedSignal("CosmeticNotifications"):Connect(
            update_cosmetic_notifications
        )
        PlayerDataController_m:GetDataChangedSignal("WeaponInventory"):Connect(
            update_cosmetic_notifications
        )
        Equipment_m.SelectedWeaponChanged:Connect(update_cosmetic_notifications)
        update_cosmetic_notifications()
    end

    if arg10 == "Equipment" then
        local function notification_bubble_1() --[[ notification_bubble ]] -- line: 447
            -- upvalues:
            --  [1] Pages_m (ref)
            --  [2] v44 (copy)
            --  [3] PlayerDataController_m (ref)

            if Pages_m.PageSystem.CurrentPage then
                v44.Button.Container.NotificationBubble.Visible = false

                return
            end

            local v90 = PlayerDataController_m:Get("UnlockTokens")
            local v91 = v90

            if v91 then
                v91 = if v90 > 0 then not PlayerDataController_m:OwnsAllWeapons(
                    "Standard",
                    true,
                    true
                ) else false
            end

            local v92 = 0

            for key_4, _ in pairs(PlayerDataController_m:Get("FreeWeaponUnlockCheck")) do
                if not PlayerDataController_m:GetWeaponData(key_4) then
                    v92 += 1

                    if v92 >= 2 then
                        break
                    end
                end
            end

            local NotificationBubble_1 = v44.Button.Container.NotificationBubble
            local v94 = v92 > 0 or v91
            NotificationBubble_1.Visible = v94
            local Title = v44.Button.Container.NotificationBubble.Title

            if v92 > 1 then
                v94 = "Unlock your new weapons now!"
            elseif v92 == 1 then
                v94 = "Unlock your new weapon now!"
            elseif v91 then
                v94 = "You have " .. v90 .. " free weapon unlock" .. (if v90 ~= 1 then "s" else "") .. "!" or ""
            else
                v94 = ""
            end

            Title.Text = v94
        end

        PlayerDataController_m:GetDataChangedSignal("FreeWeaponUnlockCheck"):Connect(
            notification_bubble_1
        )
        PlayerDataController_m:GetDataChangedSignal("WeaponInventory"):Connect(
            notification_bubble_1
        )
        PlayerDataController_m:GetDataChangedSignal("UnlockTokens"):Connect(notification_bubble_1)
        Pages_m.PageSystem.PageOpened:Connect(notification_bubble_1)
        Pages_m.PageSystem.PageClosed:Connect(notification_bubble_1)
        notification_bubble_1()
    end

    local UnhoverFunctions = arg8._unhover_functions

    UnhoverFunctions[arg10] = function() -- line: 482
        -- upvalues:
        --  [1] v45 (ref)
        --  [2] v44 (copy)

        v45 += 1
        v44.Button.Container:TweenPosition(
            UDim2.new(0.5, 0, 0.5, 0),
            "Out",
            "Quint",
            0.25,
            true
        )
        v44.Button.Container.Bubble.Visible = false
    end

    v44.Button.MouseLeave:Connect(arg8._unhover_functions[arg10])
    v44.Visible = false
    local Frame = arg8.Frame.Container.List
    v44.Parent = Frame
    local Buttons = arg8._buttons
    Buttons[arg10] = v44
    ButtonEffect_m:Add(v44.Button)

    local function update_background() -- line: 495
        -- upvalues:
        --  [1] v44 (copy)

        v44.Button.Container.Bubble.Background.Size = UDim2.new(
            0,
            v44.Button.Container.Bubble.Title.TextBounds.X + v44.Button.Container.Bubble.Background.AbsoluteSize.Y,
            1,
            0
        )
    end

    v44.Button.Container.Bubble.Title:GetPropertyChangedSignal("TextBounds"):Connect(
        update_background
    )
    v44.Button.Container.Bubble.Background:GetPropertyChangedSignal("AbsoluteSize"):Connect(
        update_background
    )
    local Button_6 = v44.Button.Container.Bubble.Background
    Button_6.Size = UDim2.new(
        0,
        v44.Button.Container.Bubble.Title.TextBounds.X + v44.Button.Container.Bubble.Background.AbsoluteSize.Y,
        1,
        0
    )
end

function t_21._OnButtonClicked(arg15, arg16, arg17) -- line: 504
    arg15._buttons[arg16].Button.MouseButton1Click:Connect(arg17)
    arg15._button_callbacks[arg16] = arg17
end

function t_21._Setup(arg18) -- line: 509
    -- upvalues:
    --  [1] t (copy)
    --  [2] Pages_m (copy)
    --  [3] Equipment_m (copy)
    --  [4] CONSTANTS_m (copy)
    --  [5] Players (copy)
    --  [6] ItemLibrary_m (copy)
    --  [7] EventLibrary_m (copy)

    for key_5, val_5 in pairs(t) do
        arg18:_CreateButton(key_5, table.unpack(val_5))
    end

    arg18:_OnButtonClicked("Career", function() -- line: 514
        -- upvalues:
        --  [1] Pages_m (ref)
        --  [2] Equipment_m (ref)

        Pages_m.PageSystem:CloseCurrentPage()
        Equipment_m:Open()
        Equipment_m:OpenCareerPage(true)
    end)
    arg18:_OnButtonClicked("Equipment", function() -- line: 520
        -- upvalues:
        --  [1] Pages_m (ref)
        --  [2] Equipment_m (ref)
        --  [3] CONSTANTS_m (ref)

        Pages_m.PageSystem:CloseCurrentPage()
        Equipment_m:Open()

        if Equipment_m:IsCareerPageOpen() then
            Equipment_m:SelectWeapon(CONSTANTS_m.DEFAULT_WEAPONS[1])
        end
    end)
    arg18:_OnButtonClicked("EquipmentExit", function() -- line: 529
        -- upvalues:
        --  [1] Equipment_m (ref)

        Equipment_m:CloseRequest()
    end)
    arg18:_OnButtonClicked("Tasks", function() -- line: 533
        -- upvalues:
        --  [1] Pages_m (ref)

        Pages_m.PageSystem:OpenPage("Tasks")
    end)
    arg18:_OnButtonClicked("Settings", function() -- line: 537
        -- upvalues:
        --  [1] Pages_m (ref)

        Pages_m.PageSystem:OpenPage("Settings")
    end)
    arg18:_OnButtonClicked("Charms", function() -- line: 541
        -- upvalues:
        --  [1] Equipment_m (ref)

        Equipment_m:StartCustomizing("Charm")
    end)
    arg18:_OnButtonClicked("Finishers", function() -- line: 545
        -- upvalues:
        --  [1] Equipment_m (ref)

        Equipment_m:StartCustomizing("Finisher")
    end)
    arg18:_OnButtonClicked("Wraps", function() -- line: 549
        -- upvalues:
        --  [1] Equipment_m (ref)

        Equipment_m:StartCustomizing("Wrap")
    end)
    arg18:_OnButtonClicked("Skins", function() -- line: 553
        -- upvalues:
        --  [1] Equipment_m (ref)

        Equipment_m:StartCustomizing("Skin")
    end)
    arg18:_OnButtonClicked("Contracts", function() -- line: 557
        -- upvalues:
        --  [1] Pages_m (ref)
        --  [2] Equipment_m (ref)

        Pages_m.PageSystem:OpenPage("Contracts")
        Pages_m.PageSystem:WaitForPage("Contracts"):SetWeapon(Equipment_m:GetSelectedWeapon())
    end)
    arg18:_OnButtonClicked("Shop", function() -- line: 562
        -- upvalues:
        --  [1] Pages_m (ref)

        Pages_m.PageSystem:OpenPage("Shop")
        Pages_m.PageSystem:WaitForPage("Shop"):SetPage("Home")
    end)
    arg18:_OnButtonClicked("Rewards", function() -- line: 567
        -- upvalues:
        --  [1] Pages_m (ref)

        Pages_m.PageSystem:OpenPage("Rewards")
    end)
    arg18:_OnButtonClicked("Backpack", function() -- line: 571
        -- upvalues:
        --  [1] Pages_m (ref)

        Pages_m.PageSystem:OpenPage("Backpack")
    end)
    arg18:_OnButtonClicked("Collection", function() -- line: 575
        -- upvalues:
        --  [1] Pages_m (ref)

        Pages_m.PageSystem:OpenPage("Collection")
    end)
    arg18:_OnButtonClicked("Recover", function() -- line: 579
        -- upvalues:
        --  [1] Pages_m (ref)

        Pages_m.PageSystem:OpenPage("StreakRecovery")
    end)
    arg18:_OnButtonClicked("EventOverview", function() -- line: 583
        -- upvalues:
        --  [1] Pages_m (ref)

        Pages_m.PageSystem:OpenPage("EventOverview")
    end)
    arg18:_OnButtonClicked("DuelHistory", function() -- line: 587
        -- upvalues:
        --  [1] Pages_m (ref)

        Pages_m.PageSystem:OpenPage("DuelHistory")
    end)
    arg18:_OnButtonClicked("Maps", function() -- line: 591
        -- upvalues:
        --  [1] Pages_m (ref)

        Pages_m.PageSystem:OpenPage("Maps")
    end)
    arg18:_OnButtonClicked("Emotes", function() -- line: 595
        -- upvalues:
        --  [1] Equipment_m (ref)

        Equipment_m:StartCustomizing("Emote")
    end)
    arg18:_OnButtonClicked("BattlePass", function() -- line: 599
        -- upvalues:
        --  [1] Pages_m (ref)

        Pages_m.PageSystem:OpenPage("BattlePass")
    end)
    arg18._buttons.Career.Button.Container.Icon.Image = string.format(
        CONSTANTS_m.HEADSHOT_IMAGE,
        Players.LocalPlayer.UserId
    )
    arg18._buttons.Equipment.Button.Container.Icon.Image = ItemLibrary_m.ViewModels["Assault Rifle"].Image
    arg18._buttons.Equipment.Button.Container.Icon.Size = UDim2.new(1.875, 0, 1.875, 0)
    arg18._buttons.EventOverview.Button.Container.Icon.Image = EventLibrary_m.EVENT_DETAILS.OVERVIEW_BUTTON_IMAGE
    arg18._buttons.EventOverview.Button.Container.Icon.Size = UDim2.new(1, 0, 1, 0)
    arg18._buttons.BattlePass.Button.Container.Icon.Position = UDim2.new(0.55, 0, 0.5, 0)
    arg18._buttons.BattlePass.Button.Container.Icon.Size = UDim2.new(0.875, 0, 0.875, 0)
    local UICorner_3 = Instance.new("UICorner")
    UICorner_3.CornerRadius = UDim.new(1, 0)
    UICorner_3.Parent = arg18._buttons.Career.Button.Container.Icon
    UICorner_3:Clone().Parent = arg18._buttons.Finishers.Button.Container.Icon
end

function t_21._Init(arg19) -- line: 617
    -- upvalues:
    --  [1] Equipment_m (copy)
    --  [2] Pages_m (copy)
    --  [3] Queue_m (copy)
    --  [4] Teleporting_m (copy)
    --  [5] MobileInputs_m (copy)
    --  [6] PlayerDataController_m (copy)
    --  [7] GuiService (copy)
    --  [8] UserInputService (copy)
    --  [9] t (copy)
    --  [10] InputLibrary_m (copy)

    arg19.Frame.Container.List.Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() -- line: 618
        -- upvalues:
        --  [1] arg19 (copy)

        local Background_1 = arg19.Frame.Container.Background
        Background_1.Visible = arg19.Frame.Container.List.Layout.AbsoluteContentSize.X > 0
        arg19.Frame.Container.Background.Size = UDim2.new(
            0.5,
            arg19.Frame.Container.List.Layout.AbsoluteContentSize.X,
            0.5,
            0
        )
    end)
    Equipment_m.Opened:Connect(function() -- line: 623
        -- upvalues:
        --  [1] arg19 (copy)

        arg19:_UpdateButtonVisibility()
    end)
    Equipment_m.SelectedWeaponChanged:Connect(function() -- line: 627
        -- upvalues:
        --  [1] arg19 (copy)

        arg19:_UpdateButtonVisibility()
    end)
    Equipment_m.CareerPageOpened:Connect(function() -- line: 631
        -- upvalues:
        --  [1] arg19 (copy)

        arg19:_UpdateButtonVisibility()
    end)
    Equipment_m.CustomizingChanged:Connect(function() -- line: 635
        -- upvalues:
        --  [1] arg19 (copy)

        arg19:_UpdateButtonVisibility()
    end)
    Equipment_m.FinishedOpenEffect:Connect(function() -- line: 639
        -- upvalues:
        --  [1] arg19 (copy)

        arg19:_UpdateButtonVisibility()
    end)
    Equipment_m.UnlockingChanged:Connect(function() -- line: 643
        -- upvalues:
        --  [1] arg19 (copy)

        arg19:_UpdateVisibility()
    end)
    Pages_m.PageSystem.PageOpened:Connect(function() -- line: 647
        -- upvalues:
        --  [1] arg19 (copy)

        arg19:_UpdateVisibility()
    end)
    Pages_m.PageSystem.PageClosed:Connect(function() -- line: 651
        -- upvalues:
        --  [1] arg19 (copy)

        arg19:_UpdateVisibility()
    end)
    Queue_m.VisibilityChanged:Connect(function() -- line: 655
        -- upvalues:
        --  [1] arg19 (copy)

        arg19:_UpdateVisibility()
    end)
    Teleporting_m.EnabledChanged:Connect(function() -- line: 659
        -- upvalues:
        --  [1] arg19 (copy)

        arg19:_UpdateVisibility()
    end)
    MobileInputs_m.EditorEnabledChanged:Connect(function() -- line: 663
        -- upvalues:
        --  [1] arg19 (copy)

        arg19:_UpdateVisibility()
    end)
    PlayerDataController_m:GetDataChangedSignal("Seasons"):Connect(function() -- line: 667
        -- upvalues:
        --  [1] arg19 (copy)

        arg19:_UpdateButtonInformation()
    end)
    PlayerDataController_m:GetDataChangedSignal("WeaponInventory"):Connect(function() -- line: 671
        -- upvalues:
        --  [1] arg19 (copy)

        arg19:_UpdateButtonInformation()
        arg19:_UpdateButtonVisibility()
    end)
    PlayerDataController_m:GetDataChangedSignal("UnclaimedRewards"):Connect(function() -- line: 676
        -- upvalues:
        --  [1] arg19 (copy)

        arg19:_UpdateButtonVisibility()
    end)
    PlayerDataController_m:GetDataChangedSignal("StoredStreaks"):Connect(function() -- line: 680
        -- upvalues:
        --  [1] arg19 (copy)

        arg19:_UpdateButtonVisibility()
    end)
    PlayerDataController_m:GetDataChangedSignal("StatisticDuelsPlayed"):Connect(function() -- line: 684
        -- upvalues:
        --  [1] arg19 (copy)

        arg19:_UpdateButtonVisibility()
    end)
    PlayerDataController_m:GetDataChangedSignal("StatisticDuelsWon"):Connect(function() -- line: 688
        -- upvalues:
        --  [1] arg19 (copy)

        arg19:_UpdateButtonVisibility()
    end)
    GuiService:GetPropertyChangedSignal("MenuIsOpen"):Connect(function() -- line: 692
        -- upvalues:
        --  [1] arg19 (copy)

        arg19:_UpdateVisibility()
    end)
    UserInputService.InputBegan:Connect(function(input: InputObject, gameProcessedEvent: boolean) -- line: 696
        -- upvalues:
        --  [1] arg19 (copy)
        --  [2] t (ref)
        --  [3] InputLibrary_m (ref)

        if gameProcessedEvent or not arg19.IsOpen or not arg19.Frame.Visible then
            return
        end

        for _, val_6 in pairs(t) do
            local v108 = val_6[1]
            local v109 = val_6[5]

            if v109 and arg19._buttons[v108].Visible and InputLibrary_m:InputIs(input, v109) then
                arg19._button_callbacks[v108]()

                return
            end
        end
    end)
    arg19:_Setup()
    arg19:_UpdateButtonVisibility()
    arg19:_UpdateVisibility()
end

return t_21._new()
