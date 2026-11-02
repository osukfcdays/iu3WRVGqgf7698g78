local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local MonetizationLibrary_m = require(ReplicatedStorage.Modules.MonetizationLibrary)
local SeasonLibrary_m = require(ReplicatedStorage.Modules.SeasonLibrary)
local BetterDebris_m = require(ReplicatedStorage.Modules.BetterDebris)
local EventLibrary_m = require(ReplicatedStorage.Modules.EventLibrary)
local ItemLibrary_m = require(ReplicatedStorage.Modules.ItemLibrary)
local _ = require(ReplicatedStorage.Modules.ShopLibrary)
local PlayerDataController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.PlayerDataController
)
local Spotlight_m = require(Players.LocalPlayer.PlayerScripts.Modules.UserInterface.Spotlight)
local VideoAdRewards_m = require(Players.LocalPlayer.PlayerScripts.Modules.VideoAdRewards)
local ButtonEffect_m = require(Players.LocalPlayer.PlayerScripts.Modules.ButtonEffect)
local RewardSlot_m = require(Players.LocalPlayer.PlayerScripts.Modules.RewardSlot)
local t = {
    "lootbox_Skin Case",
    "lootbox_Skin Case 2",
    "lootbox_Skin Case 3",
    "lootbox_Wrap Box",
    "lootbox_Wrap Box 2",
    "lootbox_Wrap Box 3",
    "lootbox_Charm Capsule",
    "lootbox_Finisher Pack",
    "lootbox_Finisher Pack 2",
    "loose_arena",
    "loose_randomwrap",
    "loose_universalwrap"
}
local t_1 = {}
t_1.__index = t_1

function t_1.new(arg1) -- line: 27
    -- upvalues:
    --  [1] t_1 (copy)
    --  [2] VideoAdRewards_m (copy)

    local t_2 = setmetatable({}, t_1)
    t_2.Pages = arg1
    t_2.Frame = t_2.Pages.Frame:WaitForChild("Home")
    t_2.Container = t_2.Frame:WaitForChild("Container")
    t_2.EventFrame = t_2.Container:WaitForChild("Event")
    t_2.OtherFrame = t_2.Container:WaitForChild("Other")
    t_2.LooseFrame = t_2.OtherFrame:WaitForChild("Loose")
    t_2.CarouselFrame = t_2.OtherFrame:WaitForChild("Carousel")
    t_2.CarouselContainer = t_2.CarouselFrame:WaitForChild("Container")
    t_2.VideoAdRewardsFrame = t_2.CarouselContainer:WaitForChild("VideoAdRewards")
    t_2.CarouselButtons = t_2.CarouselFrame:WaitForChild("Buttons")
    t_2.CarouselButtonsContainer = t_2.CarouselButtons:WaitForChild("Container")
    t_2.CarouselButtonsLayout = t_2.CarouselButtonsContainer:WaitForChild("Layout")
    t_2.CarouselButtonsBackground = t_2.CarouselButtons:WaitForChild("Background")
    t_2.VideoAdRewardsButton = t_2.CarouselButtonsContainer:WaitForChild("VideoAdRewards")
    t_2.RedirectFrame = t_2.OtherFrame:WaitForChild("Redirect")
    t_2.RedirectDailyButton = t_2.RedirectFrame:WaitForChild("Daily"):WaitForChild("Container")
    t_2.RedirectWeaponsButton = t_2.RedirectFrame:WaitForChild("Weapons"):WaitForChild("Container")
    t_2.RedirectKeysButton = t_2.RedirectFrame:WaitForChild("Keys"):WaitForChild("Container")
    t_2.BattlePassFrame = t_2.OtherFrame:WaitForChild("BattlePass")
    t_2.BattlePassContainer = t_2.BattlePassFrame:WaitForChild("Container")
    t_2.BattlePassBackground = t_2.BattlePassContainer:WaitForChild("Background")
    t_2.BattlePassNotHoveringFrame = t_2.BattlePassContainer:WaitForChild("NotHovering")
    t_2.BattlePassNotHoveringIcon = t_2.BattlePassNotHoveringFrame:WaitForChild("Icon")
    t_2.BattlePassIsHoveringFrame = t_2.BattlePassContainer:WaitForChild("IsHovering")
    t_2.BattlePassIsHoveringIcon = t_2.BattlePassIsHoveringFrame:WaitForChild("Icon")
    t_2.BattlePassRewardsFrame = t_2.BattlePassIsHoveringFrame:WaitForChild("Rewards")
    t_2.VideoAdRewards = VideoAdRewards_m.new()
    t_2._is_open_hash = 0
    t_2._current_carousel_index = 0
    t_2._last_carousel_index_change_time = 0
    t_2._shop_slots = {}
    t_2._carousel_buttons = {}
    t_2._pause_carousel_until = 0
    t_2._season_pass_reward_slots = {}
    t_2:_Init()

    return t_2
end

function t_1.GetVisualIndex(arg2) -- line: 76
    local v1 = 0

    for index = 1, arg2._current_carousel_index do
        if arg2._carousel_buttons[index].Visible then
            v1 += 1
        end
    end

    return v1
end

function t_1.SetCarouselIndexByName(arg3, arg4) -- line: 88
    for key, val in pairs(arg3._carousel_buttons) do
        if val.Name == arg4 then
            arg3:SetCarouselIndex(key)

            return
        end
    end
end

function t_1.SetCarouselIndex(arg5, arg6) -- line: 97
    -- upvalues:
    --  [1] Players (copy)

    arg5._current_carousel_index = (arg6 - 1) % #arg5._carousel_buttons + 1
    local v2 = UDim2.new(0.5 - 0.975 * (arg5:GetVisualIndex() - 1), 0, -0.025, 0)

    if arg5.CarouselContainer:IsDescendantOf(Players) then
        arg5.CarouselContainer:TweenPosition(
            v2,
            "Out",
            "Quint",
            0.75,
            true
        )
    else
        arg5.CarouselContainer.Position = v2
    end

    for key_1, val_1 in pairs(arg5._carousel_buttons) do
        v2 = if key_1 ~= arg5._current_carousel_index then false else true
        local ImageLabel = val_1.ImageLabel
        local v3 = v2 and UDim2.new(0.5, 0, 0.5, 0) or UDim2.new(0.3, 0, 0.3, 0)
        ImageLabel.Size = v3
        v3 = if not v2 then 0.75 else 0
        val_1.ImageLabel.ImageTransparency = v3
    end

    arg5.VideoAdRewards:WeakUpdate()
end

function t_1.PauseCarousel(arg7, arg8) -- line: 118
    arg7._pause_carousel_until = tick() + arg8
end

function t_1.Open(arg9) -- line: 122
    arg9._is_open_hash += 1
    arg9:_UpdateShopSlots()
    arg9:_ScrollToDefault()
    task.spawn(arg9._CarouselLoop, arg9)
    task.spawn(arg9._SeasonPassLoop, arg9)
    arg9.VideoAdRewards:Update()
end

function t_1.Close(arg10) -- line: 131
    arg10:_UpdateShopSlots()
    arg10._is_open_hash += 1
end

function t_1.Setup(arg11) -- line: 136
    -- upvalues:
    --  [1] MonetizationLibrary_m (copy)

    local v4 = MonetizationLibrary_m.VIDEO_AD_REWARDS_ENABLED and #MonetizationLibrary_m.VideoAdRewards > 0
    arg11.VideoAdRewardsFrame.Visible = v4
    arg11.VideoAdRewardsButton.Visible = v4
    task.defer(arg11.VideoAdRewards.Update, arg11.VideoAdRewards)
    arg11:_SetupCarouselSlot("VideoAdRewards")

    for _, val_2 in pairs(arg11.Pages.Shop.BUNDLE_NAMES) do
        arg11:_SetupCarouselSlot(val_2, true)
    end

    arg11:SetCarouselIndex(1)
    arg11:_ScrollToDefault()
end

function t_1._UpdateSeasonPassVisuals(arg12) -- line: 156
    -- upvalues:
    --  [1] PlayerDataController_m (copy)
    --  [2] SeasonLibrary_m (copy)
    --  [3] ItemLibrary_m (copy)

    local v6 = PlayerDataController_m:Get("Seasons")[SeasonLibrary_m.CurrentSeason.Name]
    local v5 = v6

    if v5 then
        v5 = v6.BattlePass
    end

    v6 = v5 and v5.MaxPassTrackNum or 0
    v5 = SeasonLibrary_m.PASS_TRACK_IMAGES[math.clamp(v6, 1, #SeasonLibrary_m.PASS_TRACK_IMAGES)]
    arg12.BattlePassIsHoveringIcon.Image = v5
    arg12.BattlePassNotHoveringIcon.Image = v5
    arg12.BattlePassBackground.ImageColor3 = ItemLibrary_m.StatusByPassTrackNum[v6].PassColor
end

function t_1._SeasonPassLoop(arg13) -- line: 167
    -- upvalues:
    --  [1] RewardSlot_m (copy)
    --  [2] BetterDebris_m (copy)
    --  [3] SeasonLibrary_m (copy)

    for _, val_3 in pairs(arg13._season_pass_reward_slots) do
        val_3:Destroy()
    end

    arg13._season_pass_reward_slots = {}

    local function create_slot(arg14, arg15, arg16) -- line: 178
        -- upvalues:
        --  [1] RewardSlot_m (ref)
        --  [2] arg13 (copy)
        --  [3] BetterDebris_m (ref)

        local v7 = (arg15 - -1.5) / 0.5
        local v8 = RewardSlot_m.new(arg14)
        v8:SetInteractable(false)
        v8:SetNameText("")
        v8:SetParent(arg13.BattlePassRewardsFrame)
        table.insert(arg13._season_pass_reward_slots, v8)
        BetterDebris_m:AddItem(v8, v7)
        v8.Frame.Position = UDim2.new(arg15, 0, arg16, 0)
        v8.Frame:TweenPosition(
            UDim2.new(-1.5, 0, arg16, 0),
            "InOut",
            "Linear",
            v7,
            true
        )
        task.delay(v7, function() -- line: 191
            -- upvalues:
            --  [1] arg13 (ref)
            --  [2] v8 (copy)

            local index_1 = table.find(arg13._season_pass_reward_slots, v8)

            if index_1 then
                table.remove(arg13._season_pass_reward_slots, index_1)
            end
        end)
    end

    local IsOpenHash = arg13._is_open_hash
    local v9 = 0

    for index_2 = 1, SeasonLibrary_m.CurrentSeason.NumBattlePassTiers do
        for index_3 = 1, SeasonLibrary_m.CurrentSeason.NumBattlePassTracks do
            local v10 = SeasonLibrary_m.CurrentSeason.BattlePassRewards[index_2][index_3]

            if v10 then
                create_slot(v10, math.min(7, v9) * 1 + 0.5, index_3 - 1 + 0.5)
            end
        end

        v9 += 1

        if v9 > 7 then
            wait(2)
        end

        if IsOpenHash ~= arg13._is_open_hash then
            return
        end
    end
end

function t_1._UpdateCarouselButtonsBackground(arg17) -- line: 231
    arg17.CarouselButtonsBackground.Size = UDim2.new(
        0,
        arg17.CarouselButtonsLayout.AbsoluteContentSize.X,
        1,
        0
    )
end

function t_1._SetupCarouselSlot(arg18, arg19, arg20) -- line: 235
    -- upvalues:
    --  [1] ButtonEffect_m (copy)
    --  [2] MonetizationLibrary_m (copy)

    local v11 = arg18.CarouselButtonsContainer:WaitForChild(arg19)
    v11.MouseButton1Click:Connect(function() -- line: 238
        -- upvalues:
        --  [1] arg18 (copy)
        --  [2] v11 (copy)

        arg18._last_carousel_index_change_time = tick()
        arg18:SetCarouselIndex(table.find(arg18._carousel_buttons, v11))
    end)
    ButtonEffect_m:Add(v11)
    table.insert(arg18._carousel_buttons, v11)

    if arg20 then
        local v14 = MonetizationLibrary_m.Bundles[arg19]
        local v15 = arg18.CarouselContainer:WaitForChild(arg19)
        local Container = v15:WaitForChild("Container")
        Container.MouseButton1Click:Connect(function() -- line: 251
            -- upvalues:
            --  [1] arg18 (copy)
            --  [2] arg19 (copy)
            --  [3] v15 (copy)

            arg18.Pages.Shop:InspectBundle(arg19, v15)
        end)
        Container.Button.Bubble.Title.RichText = true
        Container.Button.Bubble.Title.Text = v14.BubbleText or ""
        Container.Button.Bubble.Visible = if Container.Button.Bubble.Title.Text == "" then false else true
        ButtonEffect_m:Add(Container, nil, { HoverRatio = 1.01, ReleaseRatio = 1.01 })
    end

    table.sort(arg18._carousel_buttons, function(arg21, arg22) -- line: 262
        return arg21.LayoutOrder < arg22.LayoutOrder
    end)
end

function t_1._ScrollToDefault(arg23) -- line: 267
    arg23:SetCarouselIndexByName("VideoAdRewards")
end

function t_1._CarouselLoop(_) -- line: 275
end

function t_1._UpdateShopSlots(arg25) -- line: 305
    -- upvalues:
    --  [1] t (copy)
    --  [2] EventLibrary_m (copy)

    for _, val_4 in pairs(arg25._shop_slots) do
        val_4:Destroy()
    end

    arg25._shop_slots = {}

    if not arg25.Pages.Shop:IsOpen() then
        return
    end

    local v18 = pairs
    local v19 = t
    local v20 = EventLibrary_m.IS_ACTIVE and EventLibrary_m.SHOP_ENTRIES_OVERVIEW or nil

    for key_5, val_5 in v18({ v19, v20 }) do
        for _, val_6 in pairs(val_5) do
            local v21 = if key_5 ~= 2 then arg25.LooseFrame else arg25.EventFrame
            local v23 = arg25.Pages.Shop:CreateShopSlot(nil, v21:WaitForChild(val_6), val_6)

            if v23 then
                table.insert(arg25._shop_slots, v23)
            end
        end
    end
end

function t_1._Setup(arg26) -- line: 328
    -- upvalues:
    --  [1] EventLibrary_m (copy)

    arg26.VideoAdRewards.Frame.Parent = arg26.VideoAdRewardsFrame
    local EventFrame = arg26.EventFrame
    local v24 = EventLibrary_m.IS_ACTIVE and EventLibrary_m.SHOP_ENTRIES_OVERVIEW and #EventLibrary_m.SHOP_ENTRIES_OVERVIEW > 0
    EventFrame.Visible = v24

    for key_7, val_7 in pairs(
        if EventLibrary_m.IS_ACTIVE then if not EventLibrary_m.SHOP_ENTRIES_OVERVIEW then {} else EventLibrary_m.SHOP_ENTRIES_OVERVIEW or {} else {}
    ) do
        local Frame_2 = Instance.new("Frame")
        Frame_2.BackgroundTransparency = 1
        Frame_2.Size = UDim2.new(1, 0, 1, 0)
        Frame_2.LayoutOrder = key_7
        Frame_2.ZIndex = -key_7
        Frame_2.Name = val_7
        Frame_2.Parent = arg26.EventFrame
    end
end

function t_1._Init(arg27) -- line: 343
    -- upvalues:
    --  [1] Spotlight_m (copy)
    --  [2] PlayerDataController_m (copy)
    --  [3] ButtonEffect_m (copy)

    arg27.CarouselButtonsLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() -- line: 344
        -- upvalues:
        --  [1] arg27 (copy)

        arg27:_UpdateCarouselButtonsBackground()
    end)
    arg27.RedirectDailyButton.MouseButton1Click:Connect(function() -- line: 348
        -- upvalues:
        --  [1] arg27 (copy)

        arg27.Pages.Shop:SetPage("Daily")
    end)
    arg27.RedirectWeaponsButton.MouseButton1Click:Connect(function() -- line: 352
        -- upvalues:
        --  [1] arg27 (copy)

        arg27.Pages.Shop:SetPage("Weapons")
    end)
    arg27.RedirectKeysButton.MouseButton1Click:Connect(function() -- line: 356
        -- upvalues:
        --  [1] arg27 (copy)

        arg27.Pages.Shop:SetPage("Currency")
    end)
    arg27.BattlePassContainer.MouseButton1Click:Connect(function() -- line: 360
        -- upvalues:
        --  [1] arg27 (copy)

        arg27.Pages.Shop:SetPage("BattlePass")
    end)
    arg27.VideoAdRewards.PlayedAd:Connect(function() -- line: 364
        -- upvalues:
        --  [1] arg27 (copy)

        arg27:PauseCarousel(25)
    end)
    arg27.BattlePassContainer.MouseEnter:Connect(function() -- line: 368
        -- upvalues:
        --  [1] arg27 (copy)
        --  [2] Spotlight_m (ref)

        arg27.BattlePassIsHoveringFrame.Visible = true
        arg27.BattlePassNotHoveringFrame.Visible = false
        Spotlight_m:ChangeSubject(arg27.BattlePassContainer)
    end)
    arg27.BattlePassContainer.MouseLeave:Connect(function() -- line: 374
        -- upvalues:
        --  [1] arg27 (copy)
        --  [2] Spotlight_m (ref)

        arg27.BattlePassIsHoveringFrame.Visible = false
        arg27.BattlePassNotHoveringFrame.Visible = true
        Spotlight_m:ChangeSubject(nil, arg27.BattlePassContainer)
    end)
    PlayerDataController_m:GetDataChangedSignal("CosmeticInventory"):Connect(function() -- line: 380
        -- upvalues:
        --  [1] arg27 (copy)

        arg27:_UpdateShopSlots()
    end)
    PlayerDataController_m:GetDataChangedSignal("WeaponInventory"):Connect(function() -- line: 384
        -- upvalues:
        --  [1] arg27 (copy)

        arg27:_UpdateShopSlots()
    end)
    PlayerDataController_m:GetDataChangedSignal("Seasons"):Connect(function() -- line: 388
        -- upvalues:
        --  [1] arg27 (copy)

        arg27:_UpdateSeasonPassVisuals()
    end)
    arg27:_Setup()
    arg27:_UpdateSeasonPassVisuals()
    arg27:_UpdateCarouselButtonsBackground()
    ButtonEffect_m:Add(arg27.RedirectKeysButton)
    ButtonEffect_m:Add(arg27.RedirectDailyButton)
    ButtonEffect_m:Add(arg27.RedirectWeaponsButton)
    ButtonEffect_m:Add(arg27.BattlePassContainer, nil, { HoverRatio = 1.01, ReleaseRatio = 1.01 })
end

return t_1
