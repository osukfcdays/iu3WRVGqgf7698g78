local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local MonetizationLibrary_m = require(ReplicatedStorage.Modules.MonetizationLibrary)
local CosmeticLibrary_m = require(ReplicatedStorage.Modules.CosmeticLibrary)
local SeasonLibrary_m = require(ReplicatedStorage.Modules.SeasonLibrary)
local ItemLibrary_m = require(ReplicatedStorage.Modules.ItemLibrary)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local MonetizationController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("MonetizationController")
)
local PlayerDataController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("PlayerDataController")
)
local ControlsController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("ControlsController")
)
local SeasonController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("SeasonController")
)
local WeaponStatusHandler_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("WeaponStatusHandler")
)
local ButtonEffect_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("ButtonEffect")
)
local PromptSystem_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("PromptSystem")
)
local BundleSlot_m = require(Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("BundleSlot"))
local RewardSlot_m = require(Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("RewardSlot"))
local Page_m = require(Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("Page"))
local BattlePassFooterSlot = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild(
    "BattlePassFooterSlot"
)
local BattlePassRewardSlot = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild(
    "BattlePassRewardSlot"
)
local BattlePassTrackSlot = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild(
    "BattlePassTrackSlot"
)
local tweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
local t = setmetatable({}, Page_m)
t.__index = t

function t._new() -- line: 36
    -- upvalues:
    --  [1] Page_m (copy)
    --  [2] t (copy)
    --  [3] PromptSystem_m (copy)
    --  [4] BundleSlot_m (copy)

    local t_1 = setmetatable(Page_m.new(script.Name), t)
    t_1.CloseButton = t_1.PageFrame:WaitForChild("TopRight"):WaitForChild("Close")
    t_1.PromptsFrame = t_1.PageFrame:WaitForChild("Prompts")
    t_1.BackgroundFrame = t_1.PageFrame:WaitForChild("Background")
    t_1.List = t_1.PageFrame:WaitForChild("List")
    t_1.Container = t_1.List:WaitForChild("Container")
    t_1.Layout = t_1.Container:WaitForChild("Layout")
    t_1.RewardsFrame = t_1.Container:WaitForChild("Rewards")
    t_1.TracksFrame = t_1.RewardsFrame:WaitForChild("Tracks")
    t_1.FooterFrame = t_1.TracksFrame:WaitForChild("Footer")
    t_1.FooterBackground = t_1.FooterFrame:WaitForChild("Background")
    t_1.FooterSlotsFrame = t_1.FooterFrame:WaitForChild("Slots")
    t_1.FooterSlotsLayout = t_1.FooterSlotsFrame:WaitForChild("Layout")
    t_1.HeaderFrame = t_1.TracksFrame:WaitForChild("Header")
    t_1.HeaderContainer = t_1.HeaderFrame:WaitForChild("Container")
    t_1.HeaderLevelText = t_1.HeaderContainer:WaitForChild("Value")
    t_1.HeaderXPFrame = t_1.HeaderContainer:WaitForChild("XP")
    t_1.HeaderXPBarFrame = t_1.HeaderXPFrame:WaitForChild("Bar")
    t_1.HeaderNextLevelText = t_1.HeaderXPBarFrame:WaitForChild("NextLevel")
    t_1.HeaderXPBarContainer = t_1.HeaderXPBarFrame:WaitForChild("Container")
    t_1.HeaderBubbleFrame = t_1.HeaderContainer:WaitForChild("Bubble")
    t_1.HeaderBubbleArrow = t_1.HeaderBubbleFrame:WaitForChild("Arrow")
    t_1.HeaderBubbleTitle = t_1.HeaderBubbleFrame:WaitForChild("Title")
    t_1.HeaderBubbleBackground = t_1.HeaderBubbleFrame:WaitForChild("Background")
    t_1.NextButton = t_1.HeaderContainer:WaitForChild("Next")
    t_1.NextBackground = t_1.NextButton:WaitForChild("Background")
    t_1.NextIcon = t_1.NextButton:WaitForChild("Icon")
    t_1.PreviousButton = t_1.HeaderContainer:WaitForChild("Previous")
    t_1.PreviousBackground = t_1.PreviousButton:WaitForChild("Background")
    t_1.PreviousIcon = t_1.PreviousButton:WaitForChild("Icon")
    t_1.PreviewFrame = t_1.Container:WaitForChild("Preview")
    t_1.PreviewContainer = t_1.PreviewFrame:WaitForChild("Container")
    t_1.PreviewRewardContainer = t_1.PreviewContainer:WaitForChild("RewardContainer")
    t_1.PreviewDetailsFrame = t_1.PreviewFrame:WaitForChild("Details")
    t_1.PreviewDetailsClaimed = t_1.PreviewDetailsFrame:WaitForChild("Claimed")
    t_1.PreviewDetailsTitle = t_1.PreviewDetailsFrame:WaitForChild("Title")
    t_1.PreviewDetailsDescription = t_1.PreviewDetailsFrame:WaitForChild("Description")
    t_1.PreviewUnlockFrame = t_1.PreviewFrame:WaitForChild("Unlock")
    t_1.PreviewUnlockContainer = t_1.PreviewUnlockFrame:WaitForChild("Container")
    t_1.PreviewUnlockDetailsFrame = t_1.PreviewUnlockContainer:WaitForChild("Details")
    t_1.PreviewUnlockTiersText = t_1.PreviewUnlockDetailsFrame:WaitForChild("Tiers")
    t_1.PreviewUnlockTitleText = t_1.PreviewUnlockDetailsFrame:WaitForChild("Title")
    t_1.PreviewUnlockButtonFrame = t_1.PreviewUnlockContainer:WaitForChild("Buy")
    t_1.PreviewUnlockButton = t_1.PreviewUnlockButtonFrame:WaitForChild("Button")
    t_1.PreviewUnlockButtonTitle = t_1.PreviewUnlockButton:WaitForChild("Title")
    t_1.PreviewUnlockViewContentsFrame = t_1.PreviewUnlockContainer:WaitForChild("ViewContents")
    t_1.PreviewUnlockViewContentsButton = t_1.PreviewUnlockViewContentsFrame:WaitForChild("Button")
    t_1.PreviewUnlockClaimFrame = t_1.PreviewUnlockContainer:WaitForChild("Claim")
    t_1.PreviewUnlockClaimButton = t_1.PreviewUnlockClaimFrame:WaitForChild("Button")
    t_1.BundlesFrame = t_1.Container:WaitForChild("Bundles")
    t_1.PrimeSeasonBundleFrame = t_1.BundlesFrame:WaitForChild("primeseason_bundle")
    t_1.ContrabandSeasonBundleFrame = t_1.BundlesFrame:WaitForChild("contrabandseason_bundle")
    t_1.EndingSoonFrame = t_1.Container:WaitForChild("EndingSoon")
    t_1.EndingSoonTitle = t_1.EndingSoonFrame:WaitForChild("Title")
    t_1.HidePartyDisplay = true
    t_1.PromptSystem = PromptSystem_m.new(t_1.PromptsFrame)
    t_1.PrimeSeasonBundleSlot = BundleSlot_m.new("primeseason_bundle")
    t_1.ContrabandSeasonBundleSlot = BundleSlot_m.new("contrabandseason_bundle")
    t_1._open_animation_disabled = true
    t_1._current_page = 1
    t_1._footer_slots = {}
    t_1._track_slots = {}
    t_1._xp_slots = {}
    t_1._reward_slots = {}
    t_1._preview_data = nil
    t_1._scroll_delta = 0
    t_1._refreshed_input_tags = false
    t_1._completed_all_tasks_thread = nil
    t_1:_Init()

    return t_1
end

function t.InspectBundle(arg1, arg2) -- line: 118
    arg1.PromptSystem:Open("InspectBundle", arg2)
end

function t.UnlockNow(arg3) -- line: 122
    -- upvalues:
    --  [1] MonetizationController_m (copy)

    if not arg3._preview_data then
        return
    end

    local v12 = arg3:_GetUnlockNowProductInfo(
        arg3._preview_data.Tier,
        arg3._preview_data.PassTrackNum
    )

    if v12 then
        MonetizationController_m:PromptProductPurchase(v12.ProductID)
    end
end

function t.Preview(arg4, arg5, arg6) -- line: 134
    -- upvalues:
    --  [1] SeasonLibrary_m (copy)
    --  [2] WeaponStatusHandler_m (copy)
    --  [3] TweenService (copy)
    --  [4] tweenInfo (copy)
    --  [5] ItemLibrary_m (copy)
    --  [6] PlayerDataController_m (copy)
    --  [7] RewardSlot_m (copy)
    --  [8] Utility_m (copy)
    --  [9] CosmeticLibrary_m (copy)
    --  [10] MonetizationController_m (copy)

    local v13 = SeasonLibrary_m.CurrentSeason.BattlePassRewards[arg5] and SeasonLibrary_m.CurrentSeason.BattlePassRewards[arg5][arg6]

    if arg4._preview_data and arg4._preview_data.RewardSlot then
        arg4._preview_data.RewardSlot:Destroy()
        arg4._preview_data.RewardSlot = nil
    end

    arg4._preview_data = nil
    arg4.PreviewDetailsTitle.Text = ""
    arg4.PreviewDetailsDescription.Text = ""
    WeaponStatusHandler_m:ClearStatusElements(arg4.PreviewDetailsTitle)
    WeaponStatusHandler_m:ClearStatusElements(arg4.PreviewDetailsDescription)
    WeaponStatusHandler_m:ClearStatusElements(arg4.PreviewUnlockTiersText)
    local t_2 = { BackgroundColor3 = nil }
    local v14 = ItemLibrary_m.StatusByPassTrackNum[arg6]
    local v15 = TweenService
    local BackgroundFrame = arg4.BackgroundFrame
    local v16 = tweenInfo

    if not v14 then
        v14 = ItemLibrary_m.Statuses.Standard
    end

    t_2.BackgroundColor3 = v14.Color
    v15:Create(BackgroundFrame, v16, t_2):Play()
    TweenService:Create(
        arg4.List,
        TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
        { CanvasPosition = Vector2.zero }
    ):Play()

    if not v13 or not arg5 or not arg6 then
        arg4.PreviewFrame.Visible = false
        arg4.PreviewFrame.Size = UDim2.new(1, 0, 0, 0)

        return
    end

    task.defer(arg4._SetPage, arg4, (math.ceil(arg5 / 7)))
    arg4._preview_data = { RewardData = v13, Tier = arg5, PassTrackNum = arg6, RewardSlot = nil }
    local v19 = PlayerDataController_m:Get("Seasons")[SeasonLibrary_m.CurrentSeason.Name]
    local v18 = v19

    if v18 then
        v18 = v19.BattlePass
    end

    v19 = v18 and v18.PassLevel or 0
    local v20 = v18 and v18.MaxPassTrackNum or 0
    local v21 = arg5 <= v19 and arg6 <= v20
    v20 = v18

    if v20 then
        v20 = v18.RewardsClaimed[tostring(arg5)]

        if v20 then
            v20 = v18.RewardsClaimed[tostring(arg5)][tostring(arg6)]
        end
    end

    v18 = arg4:_GetUnlockNowProductInfo(arg5, arg6)
    v19 = RewardSlot_m.new(v13)
    v19:ZoomOutViewportFrame()
    v19:UseHighResolutionImage()
    v19:HideBackground()
    v19:HideWeaponVisual()
    v19:SetNameText("")
    v19:SetInteractable(false)
    v19.Frame.Parent = arg4.PreviewRewardContainer
    arg4._preview_data.RewardSlot = v19
    arg4.PreviewDetailsClaimed.Visible = v20
    arg4.PreviewDetailsTitle.Text = v19:GetRewardBubbleTitle()
    arg4.PreviewDetailsDescription.Text = v19:GetRewardBubbleDescription()

    if ItemLibrary_m.Items[v13.Name] then
        local Status = ItemLibrary_m.Items[v13.Name].Status
        WeaponStatusHandler_m:ApplyItemStatusToText(arg4.PreviewDetailsTitle, Status)
        WeaponStatusHandler_m:ApplyItemStatusToText(arg4.PreviewDetailsDescription, Status)
    elseif ItemLibrary_m.Items[v13.Weapon] then
        local v23 = ItemLibrary_m.Items[v13.Weapon]
        local v24 = WeaponStatusHandler_m
        local PreviewDetailsDescription_1 = arg4.PreviewDetailsDescription
        v23 = v23 and ItemLibrary_m.Items[v13.Weapon].Status
        v24:ApplyItemStatusToText(PreviewDetailsDescription_1, v23)
    end

    local v25 = v21
    local PreviewUnlockClaimFrame = arg4.PreviewUnlockClaimFrame

    if v25 then
        v25 = not v20
    end

    PreviewUnlockClaimFrame.Visible = v25
    v25 = v18 and not v20
    arg4.PreviewUnlockButtonFrame.Visible = v25
    local PreviewUnlockTiersText = arg4.PreviewUnlockTiersText
    v25 = if v18 and v18.BattlePassLevelIncrement then string.format(
        "+%s Level%s",
        Utility_m:PrettyNumber(v18.BattlePassLevelIncrement),
        if v18.BattlePassLevelIncrement == 1 then "" else "s"
    ) else v18 and v18.BattlePassMaxPassTrackNum and v18.UnlockNowDisplayName or ""
    PreviewUnlockTiersText.Text = v25
    arg4.PreviewUnlockTitleText.Visible = if arg4.PreviewUnlockTiersText.Text == "" then false else true
    v25 = CosmeticLibrary_m.Rewards[v13.Name]
    local PreviewUnlockViewContentsFrame = arg4.PreviewUnlockViewContentsFrame
    v25 = v25 and CosmeticLibrary_m.Rewards[v13.Name].Type == "Lootbox"
    PreviewUnlockViewContentsFrame.Visible = v25

    if v18 then
        MonetizationController_m:SetRobuxText(
            arg4.PreviewUnlockButtonTitle,
            v18.ProductID,
            Enum.InfoType.Product
        )

        if v18.BattlePassMaxPassTrackNum and v18.UnlockNowWeaponStatusUIEffect then
            WeaponStatusHandler_m:ApplyItemStatusToText(
                arg4.PreviewUnlockTiersText,
                v18.UnlockNowWeaponStatusUIEffect
            )
        end
    end

    v21 = if not v20 then 0 else 0.2
    arg4.PreviewDetailsTitle.Position = UDim2.new(0.5 + v21, 0, 0.775, 0)
    arg4.PreviewDetailsDescription.Position = UDim2.new(0.5 + v21, 0, 0.9, 0)
    v19.Frame.Position = UDim2.new(0.5, 0, 0.75, 0)
    arg4.PreviewDetailsTitle:TweenPosition(
        UDim2.new(0.15 + v21, 0, 0.775, 0),
        "Out",
        "Quint",
        0.5,
        true
    )
    arg4.PreviewDetailsDescription:TweenPosition(
        UDim2.new(0.15 + v21, 0, 0.9, 0),
        "Out",
        "Quint",
        0.625,
        true
    )
    v19.Frame:TweenPosition(
        UDim2.new(0.5, 0, 0.5, 0),
        "Out",
        "Quint",
        0.375,
        true
    )
    arg4.PreviewFrame.Visible = true
    arg4.PreviewFrame:TweenSize(
        UDim2.new(1, 0, 0.3, 0),
        "Out",
        "Quint",
        0.25,
        true
    )
end

function t.Open(arg7, ...) -- line: 230
    -- upvalues:
    --  [1] Page_m (copy)
    --  [2] PlayerDataController_m (copy)
    --  [3] UserInputService (copy)
    --  [4] SeasonLibrary_m (copy)

    Page_m.Open(arg7, ...)
    local OpenConnections = arg7._open_connections
    local Seasons = PlayerDataController_m:GetDataChangedSignal("Seasons")
    table.insert(OpenConnections, Seasons:Connect(function() -- line: 233
        -- upvalues:
        --  [1] arg7 (copy)

        arg7:_Update()

        if arg7._preview_data then
            arg7:Preview(arg7._preview_data.Tier, arg7._preview_data.PassTrackNum)
        end
    end))
    table.insert(arg7._open_connections, UserInputService.InputBegan:Connect(function(
        input: InputObject,
        gameProcessedEvent: boolean
    ) -- line: 241
        -- upvalues:
        --  [1] arg7 (copy)

        if gameProcessedEvent then
            return
        end

        if input.KeyCode == Enum.KeyCode.ButtonL1 then
            arg7:_SetPage(arg7._current_page - 1)

            return
        end

        if input.KeyCode == Enum.KeyCode.ButtonR1 then
            arg7:_SetPage(arg7._current_page + 1)
        end
    end))
    table.insert(arg7._open_connections, UserInputService.InputChanged:Connect(function(_, _) -- line: 253
    end))
    table.insert(arg7._open_threads, task.spawn(function() -- line: 268
        -- upvalues:
        --  [1] arg7 (copy)

        while true do
            arg7:_UpdateEndingSoon()
            wait(1)
        end
    end))

    if not arg7._refreshed_input_tags then
        arg7._refreshed_input_tags = true
        local t_5 = { arg7.NextButton, arg7.PreviousButton }
        local _ = task.spawn(function() -- line: 268
            -- upvalues:
            --  [1] arg7 (copy)

            while true do
                arg7:_UpdateEndingSoon()
                wait(1)
            end
        end)

        for _, val in pairs(t_5) do
            local Inputs = val:WaitForChild("Inputs")
            Inputs.Parent = nil
            Inputs.Parent = val
        end
    end

    arg7.PrimeSeasonBundleSlot.Frame.Position = UDim2.new(0.5, 0, 4, 0)
    arg7.ContrabandSeasonBundleSlot.Frame.Position = UDim2.new(0.5, 0, 4, 0)
    arg7.PrimeSeasonBundleSlot.Frame:TweenPosition(
        UDim2.new(0.5, 0, 0.5, 0),
        "Out",
        "Quint",
        1,
        true
    )
    arg7.ContrabandSeasonBundleSlot.Frame:TweenPosition(
        UDim2.new(0.5, 0, 0.5, 0),
        "Out",
        "Quint",
        1.5,
        true
    )
    local v30 = PlayerDataController_m:Get("Seasons")[SeasonLibrary_m.CurrentSeason.Name]
    local v29 = v30

    if v29 then
        v29 = v30.BattlePass
    end

    v30 = v29 and v29.PassLevel or 0
    v29 = math.ceil(v30 / 7)
    arg7:Preview(nil)
    arg7:_SetPage(v29)
    arg7:_Update()
end

function t.Close(arg12, ...) -- line: 300
    -- upvalues:
    --  [1] Page_m (copy)

    arg12:_Clear()
    Page_m.Close(arg12, ...)
end

function t._UpdateEndingSoon(arg13) -- line: 309
    -- upvalues:
    --  [1] SeasonController_m (copy)

    arg13.EndingSoonFrame.Visible = if SeasonController_m:GetTimeRemaining() == nil then false else true
    arg13.EndingSoonTitle.Text = (SeasonController_m:GetCountdownText() or "") .. " \226\128\148 Complete the Season Pass and collect your rewards before they're gone forever!"
end

function t._UpdateVisuals(arg14) -- line: 314
    local v33 = arg14.HeaderXPBarContainer.AbsolutePosition.X + arg14.HeaderXPBarContainer.AbsoluteSize.X - arg14.HeaderBubbleFrame.AbsolutePosition.X
    local absoluteValue = math.abs(v33)
    local minimum = math.min(
        absoluteValue,
        arg14.HeaderBubbleFrame.AbsoluteSize.X / 2 - arg14.HeaderBubbleArrow.AbsoluteSize.X - 8
    )
    arg14.HeaderBubbleArrow.Position = UDim2.new(0, minimum * math.sign(v33), 1, -2)
    arg14.HeaderBubbleBackground.Size = UDim2.new(0.05, arg14.HeaderBubbleTitle.TextBounds.X, 1, 0)
    arg14.List.CanvasSize = UDim2.new(0, 0, 0, arg14.Layout.AbsoluteContentSize.Y)
    arg14.FooterBackground.Size = UDim2.new(
        0,
        (arg14.FooterSlotsLayout.AbsoluteContentSize.X + arg14.FooterSlotsLayout.Padding.Scale * arg14.FooterSlotsFrame.AbsoluteSize.X) * 1.00878,
        1,
        0
    )
end

function t._UpdateListVisibility(arg15) -- line: 324
    arg15.List.Visible = not arg15.PromptSystem.CurrentPrompt
end

function t._GetUnlockNowProductInfo(_, arg17, arg18) -- line: 328
    -- upvalues:
    --  [1] PlayerDataController_m (copy)
    --  [2] SeasonLibrary_m (copy)
    --  [3] MonetizationLibrary_m (copy)

    local v35 = PlayerDataController_m:Get("Seasons")[SeasonLibrary_m.CurrentSeason.Name]
    local v34 = v35

    if v34 then
        v34 = v35.BattlePass
    end

    v35 = v34 and v34.MaxPassTrackNum or 0

    if arg18 > v35 then
        return MonetizationLibrary_m.Bundles.primeseason_bundle
    end

    v35 = v34 and v34.PassLevel or 0
    v34 = arg17 - v35

    if v34 > 0 then
        for _, val_1 in pairs(MonetizationLibrary_m.BATTLE_PASS_LEVELS) do
            v35 = MonetizationLibrary_m.Products[val_1]

            if v34 <= v35.BattlePassLevelIncrement then
                return v35
            end
        end

        return nil
    end
end

function t._GetMaxPage(_) -- line: 353
    -- upvalues:
    --  [1] SeasonLibrary_m (copy)

    return (math.ceil(SeasonLibrary_m.CurrentSeason.NumBattlePassTiers / 7))
end

function t._SetPage(arg20, arg21) -- line: 357
    local CurrentPage = arg20._current_page
    local v36 = arg20:_GetMaxPage()
    arg20._current_page = math.clamp(arg21, 1, v36)

    if CurrentPage == arg20._current_page then
        return
    end

    local v37 = math.sign(arg20._current_page - CurrentPage)

    if v37 == 0 then
        v37 = nil
    end

    arg20:_Update(v37)
end

function t._Clear(arg22) -- line: 372
    for _, val_2 in pairs(arg22._reward_slots) do
        val_2:Destroy()
    end

    for _, val_3 in pairs(arg22._track_slots) do
        val_3:Destroy()
    end

    for _, val_4 in pairs(arg22._footer_slots) do
        val_4:Destroy()
    end

    for _, val_5 in pairs(arg22._xp_slots) do
        val_5:Destroy()
    end

    arg22._reward_slots = {}
    arg22._track_slots = {}
    arg22._footer_slots = {}
    arg22._xp_slots = {}

    if arg22._completed_all_tasks_thread then
        task.cancel(arg22._completed_all_tasks_thread)
        arg22._completed_all_tasks_thread = nil
    end
end

function t._Update(arg23, arg24) -- line: 404
    -- upvalues:
    --  [1] SeasonLibrary_m (copy)
    --  [2] BattlePassTrackSlot (copy)
    --  [3] ItemLibrary_m (copy)
    --  [4] PlayerDataController_m (copy)
    --  [5] BattlePassFooterSlot (copy)
    --  [6] BattlePassRewardSlot (copy)
    --  [7] RewardSlot_m (copy)
    --  [8] CosmeticLibrary_m (copy)
    --  [9] Utility_m (copy)

    arg23:_Clear()

    for index = 1, SeasonLibrary_m.CurrentSeason.NumBattlePassTracks do
        local v38 = BattlePassTrackSlot:Clone()
        v38.Side.Background.ImageColor3 = ItemLibrary_m.StatusByPassTrackNum[index].PassColor
        v38.Side["Icon" .. index].Visible = true
        v38.LayoutOrder = index
        v38.Parent = arg23.TracksFrame
        arg23._track_slots[index] = v38
    end

    local v39 = PlayerDataController_m:Get("Seasons")
    local v40 = v39[SeasonLibrary_m.CurrentSeason.Name]
    v39 = v40

    if v39 then
        v39 = v40.BattlePass
    end

    v40 = v39 and v39.PassLevel or 0
    local v41 = v39 and v39.MaxPassTrackNum or 0
    local v42 = false
    arg23.HeaderLevelText.Text = v40
    arg23.HeaderNextLevelText.Text = "Level " .. v40 + 1

    for index_1 = 1, 7 do
        local v43 = (arg23._current_page - 1) * 7 + index_1

        if not (v43 > SeasonLibrary_m.CurrentSeason.NumBattlePassTiers) then
            local v44 = v40 >= v43 and true
            local v45 = BattlePassFooterSlot:Clone()
            v45.Tier.Text = v43
            v45.LayoutOrder = index_1
            local Bar = v45.Bar
            local v46 = v44 and Color3.fromRGB(100, 255, 50) or Color3.fromRGB(255, 255, 255)
            Bar.BackgroundColor3 = v46
            v45.Bar.BackgroundTransparency = if v44 then 0 else 0.75
            v45.Parent = arg23.FooterSlotsFrame
            table.insert(arg23._footer_slots, v45)

            for index_2 = 1, SeasonLibrary_m.CurrentSeason.NumBattlePassTracks do
                v45 = SeasonLibrary_m.CurrentSeason.BattlePassRewards[v43] and SeasonLibrary_m.CurrentSeason.BattlePassRewards[v43][index_2]
                local v48 = ItemLibrary_m.StatusByPassTrackNum[index_2]
                local v49 = v39

                if v49 then
                    v49 = v39.RewardsClaimed[tostring(v43)]

                    if v49 then
                        v49 = v39.RewardsClaimed[tostring(v43)][tostring(index_2)]
                    end
                end

                local v51 = v49 or v44 and v41 >= index_2
                local v52 = BattlePassRewardSlot:Clone()
                v52.Container.Claimed.Visible = v51
                v52.Container.Unclaimed.Visible = not v51
                v52.Container.Unclaimed.Status.ImageColor3 = v48.PassColor
                v52.Container.Unclaimed.Background.ImageColor3 = v48.DarkPassColor
                v52.Container.Claimed.Status.ImageColor3 = v48.DarkPassColor
                v52.Container.Claimed.Claimed.Visible = v49 and v45
                v52.Container.Claimed.Background.ImageColor3 = v48.DarkPassColor
                v52.Container.Claimed.Container.GroupTransparency = if v49 then 0.75 else 0
                local v53 = v45 and not v49
                v52.Container.Claimed.ClaimNowBubble.Visible = v53
                v52.LayoutOrder = index_1
                v52.Parent = arg23._track_slots[index_2]

                if v45 then
                    v49 = RewardSlot_m.new(v45)
                    local Frame_6 = v49.Frame
                    local v54 = v51 and v52.Container.Claimed.Container or v52.Container.Unclaimed.Container
                    Frame_6.Parent = v54
                    table.insert(arg23._reward_slots, v49)
                    v49:OnClick(function() -- line: 466
                        -- upvalues:
                        --  [1] arg23 (copy)
                        --  [2] v43 (copy)
                        --  [3] index_2 (copy)

                        arg23:Preview(v43, index_2)
                    end)
                    v48 = if (v45.Quantity or 1) ~= 1 then false else true
                    local v55 = CosmeticLibrary_m.Rewards[v45.Name]
                    local v56 = CosmeticLibrary_m.Cosmetics[v45.Name]
                    local v57 = ItemLibrary_m.Items[v45.Name]
                    v55 = v55 and CosmeticLibrary_m.Rewards[v45.Name].Type == "Currency"

                    if v48 and not v56 and not v57 and not v55 then
                        v49:SetNameText("")
                    end
                end

                if arg24 then
                    v51 = (index_1 + index_2 - 1) / 7
                    v51 = if not (arg24 < 0) then v51 else 1 - v51
                    v52.Container.Position = UDim2.new(0.5 + 0.5 * arg24, 0, 0.5, 0)
                    v52.Container:TweenPosition(
                        UDim2.new(0.5, 0, 0.5, 0),
                        "Out",
                        "Quint",
                        v51 * 0.5 + 0.25,
                        true
                    )
                end

                if not v42 and index_2 == 1 and v45 then
                    v42 = true
                end
            end
        end
    end

    v42 = v39 and v39.NumPassTasksCompleted or 0
    v41 = v39 and v39.PassTaskProgress and v39.PassTaskProgress.RoundsWon or 0
    v40 = v39 and v39.PassTaskProgress and v39.PassTaskProgress.Playtime or 0
    v39 = v42 >= SeasonLibrary_m:GetCurrentSeasonWeek() * SeasonLibrary_m.CurrentSeason.BattlePassTasksPerWeek and true
    local maximum = math.max(
        v41 / SeasonLibrary_m.CurrentSeason.BattlePassTaskRequirements.RoundsWon,
        v40 / SeasonLibrary_m.CurrentSeason.BattlePassTaskRequirements.Playtime
    )
    arg23.HeaderXPBarContainer.Size = UDim2.new(math.clamp(maximum, 0, 1), 0, 1, 0)

    local function update_bubble_title() -- line: 507
        -- upvalues:
        --  [1] v39 (copy)
        --  [2] arg23 (copy)
        --  [3] Utility_m (ref)
        --  [4] SeasonLibrary_m (ref)
        --  [5] v40 (copy)
        --  [6] v41 (copy)

        if v39 then
            arg23.HeaderBubbleTitle.Text = string.format(
                "All done! You can level up again in <font transparency=\"0\" weight=\"800\">%s</font>",
                Utility_m:TimeFormat2((math.ceil((SeasonLibrary_m:GetTimeUntilNextSeasonWeek()))))
            )

            return
        end

        local formattedText = string.format("%.1f", v40 / 60)
        arg23.HeaderBubbleTitle.Text = string.format(
            "Win (<font transparency=\"0\" weight=\"800\">%s</font> / %s) rounds in duels or play for (<font transparency=\"0\" weight=\"800\">%s</font> / %s) minutes to level up",
            v41,
            SeasonLibrary_m.CurrentSeason.BattlePassTaskRequirements.RoundsWon,
            if formattedText == "0.0" then "0" else formattedText,
            string.format(
                "%.0f",
                SeasonLibrary_m.CurrentSeason.BattlePassTaskRequirements.Playtime / 60
            )
        )
    end

    update_bubble_title()

    if v39 then
        arg23._completed_all_tasks_thread = task.spawn(function() -- line: 526
            -- upvalues:
            --  [1] update_bubble_title (copy)

            while true do
                wait(1)
                update_bubble_title()
            end
        end)
    end

    local v64 = arg23._current_page < arg23:_GetMaxPage() and true
    local v65 = arg23._current_page > 1
    arg23.NextBackground.BackgroundTransparency = if not v64 then 0.75 else 0
    arg23.NextIcon.ImageTransparency = if not v64 then 0.75 else 0
    arg23.PreviousBackground.BackgroundTransparency = if not v65 then 0.75 else 0
    arg23.PreviousIcon.ImageTransparency = if not v65 then 0.75 else 0
end

function t._Setup(arg25) -- line: 543
    arg25.PrimeSeasonBundleSlot:SetParent(arg25.PrimeSeasonBundleFrame)
    arg25.ContrabandSeasonBundleSlot:SetParent(arg25.ContrabandSeasonBundleFrame)
end

function t._Init(arg26) -- line: 548
    -- upvalues:
    --  [1] ReplicatedStorage (copy)
    --  [2] ControlsController_m (copy)
    --  [3] ButtonEffect_m (copy)

    arg26.CloseButton.MouseButton1Click:Connect(function() -- line: 549
        -- upvalues:
        --  [1] arg26 (copy)

        arg26:CloseRequest()
    end)
    arg26.PromptSystem.PromptAdded:Connect(function() -- line: 553
        -- upvalues:
        --  [1] arg26 (copy)

        arg26:_UpdateListVisibility()
    end)
    arg26.PromptSystem.PromptRemoved:Connect(function() -- line: 557
        -- upvalues:
        --  [1] arg26 (copy)

        arg26:_UpdateListVisibility()
    end)
    arg26.NextButton.MouseButton1Click:Connect(function() -- line: 561
        -- upvalues:
        --  [1] arg26 (copy)

        arg26:_SetPage(arg26._current_page + 1)
    end)
    arg26.PreviousButton.MouseButton1Click:Connect(function() -- line: 565
        -- upvalues:
        --  [1] arg26 (copy)

        arg26:_SetPage(arg26._current_page - 1)
    end)
    arg26.Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() -- line: 569
        -- upvalues:
        --  [1] arg26 (copy)

        arg26:_UpdateVisuals()
    end)
    arg26.FooterSlotsLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() -- line: 573
        -- upvalues:
        --  [1] arg26 (copy)

        arg26:_UpdateVisuals()
    end)
    arg26.HeaderBubbleTitle:GetPropertyChangedSignal("TextBounds"):Connect(function() -- line: 577
        -- upvalues:
        --  [1] arg26 (copy)

        arg26:_UpdateVisuals()
    end)
    arg26.HeaderXPBarContainer:GetPropertyChangedSignal("AbsolutePosition"):Connect(function() -- line: 581
        -- upvalues:
        --  [1] arg26 (copy)

        arg26:_UpdateVisuals()
    end)
    arg26.HeaderXPBarContainer:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- line: 585
        -- upvalues:
        --  [1] arg26 (copy)

        arg26:_UpdateVisuals()
    end)
    arg26.HeaderBubbleFrame:GetPropertyChangedSignal("AbsolutePosition"):Connect(function() -- line: 589
        -- upvalues:
        --  [1] arg26 (copy)

        arg26:_UpdateVisuals()
    end)
    arg26.HeaderBubbleFrame:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- line: 593
        -- upvalues:
        --  [1] arg26 (copy)

        arg26:_UpdateVisuals()
    end)
    arg26.HeaderBubbleArrow:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- line: 597
        -- upvalues:
        --  [1] arg26 (copy)

        arg26:_UpdateVisuals()
    end)
    arg26.PreviewUnlockClaimButton.MouseButton1Click:Connect(function() -- line: 601
        -- upvalues:
        --  [1] ReplicatedStorage (ref)
        --  [2] arg26 (copy)

        ReplicatedStorage.Remotes.Data.ClaimBattlePassReward:FireServer(
            arg26._preview_data.Tier,
            arg26._preview_data.PassTrackNum
        )
    end)
    arg26.PreviewUnlockButton.MouseButton1Click:Connect(function() -- line: 605
        -- upvalues:
        --  [1] arg26 (copy)

        arg26:UnlockNow()
    end)
    arg26.PreviewUnlockViewContentsButton.MouseButton1Click:Connect(function() -- line: 609
        -- upvalues:
        --  [1] arg26 (copy)

        arg26.PromptSystem:Open(
            "InspectLootbox",
            arg26._preview_data.RewardData.Name,
            arg26._preview_data.RewardData.Weapon
        )
    end)
    arg26.PrimeSeasonBundleSlot.Tapped:Connect(function() -- line: 613
        -- upvalues:
        --  [1] ControlsController_m (ref)
        --  [2] arg26 (copy)

        if ControlsController_m.CurrentControls == "Touch" then
            arg26:InspectBundle(arg26.PrimeSeasonBundleSlot.Name)

            return
        end

        arg26.PrimeSeasonBundleSlot:PurchaseRequest()
    end)
    arg26.ContrabandSeasonBundleSlot.Tapped:Connect(function() -- line: 622
        -- upvalues:
        --  [1] ControlsController_m (ref)
        --  [2] arg26 (copy)

        if ControlsController_m.CurrentControls == "Touch" then
            arg26:InspectBundle(arg26.ContrabandSeasonBundleSlot.Name)

            return
        end

        arg26.ContrabandSeasonBundleSlot:PurchaseRequest()
    end)
    arg26:_Setup()
    arg26:_UpdateVisuals()
    ButtonEffect_m:Add(arg26.CloseButton)
    ButtonEffect_m:Add(arg26.NextButton)
    ButtonEffect_m:Add(arg26.PreviousButton)
    ButtonEffect_m:Add(arg26.PreviewUnlockButton)
    ButtonEffect_m:Add(arg26.PreviewUnlockClaimButton)
    ButtonEffect_m:Add(arg26.PreviewUnlockViewContentsButton)
end

return t._new()
