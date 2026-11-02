local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local MonetizationLibrary_m = require(ReplicatedStorage.Modules.MonetizationLibrary)
local CosmeticLibrary_m = require(ReplicatedStorage.Modules.CosmeticLibrary)
local EventLibrary_m = require(ReplicatedStorage.Modules.EventLibrary)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local ComplianceController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.ComplianceController
)
local PlayerDataController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.PlayerDataController
)
local EventController_m = require(Players.LocalPlayer.PlayerScripts.Controllers.EventController)
local ShopController_m = require(Players.LocalPlayer.PlayerScripts.Controllers.ShopController)
local MatchmakingQueueSlot_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("BaseMatchmakingQueueSlot"):WaitForChild(
        "MatchmakingQueueSlot"
    )
)
local ShopSlot_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("BaseShopSlot"):WaitForChild("ShopSlot")
)
local AdventCalendarSlot_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("AdventCalendarSlot")
)
local PromptSystem_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("PromptSystem")
)
local ButtonEffect_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("ButtonEffect")
)
local Pages_m = require(
    Players.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("Pages")
)
local RewardSlot_m = require(Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("RewardSlot"))
local TaskSlot_m = require(Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("TaskSlot"))
local Page_m = require(Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("Page"))
local t = setmetatable({}, Page_m)
t.__index = t

function t._new() -- line: 25
    -- upvalues:
    --  [1] Page_m (copy)
    --  [2] t (copy)
    --  [3] PromptSystem_m (copy)
    --  [4] AdventCalendarSlot_m (copy)

    local t_1 = setmetatable(Page_m.new(script.Name), t)
    t_1.CloseButton = t_1.PageFrame:WaitForChild("Close")
    t_1.PromptsFrame = t_1.PageFrame:WaitForChild("Prompts")
    t_1.LockedFrame = t_1.PageFrame:WaitForChild("Locked")
    t_1.LockedDescriptionText = t_1.LockedFrame:WaitForChild("Description")
    t_1.List = t_1.PageFrame:WaitForChild("List")
    t_1.Container = t_1.List:WaitForChild("Container")
    t_1.Layout = t_1.Container:WaitForChild("Layout")
    t_1.HeaderFrame = t_1.Container:WaitForChild("Header")
    t_1.HeaderPicture = t_1.HeaderFrame:WaitForChild("Picture")
    t_1.HeaderTitleText = t_1.HeaderFrame:WaitForChild("Title")
    t_1.HeaderCountdownText = t_1.HeaderFrame:WaitForChild("Countdown")
    t_1.EventTasksFrame = t_1.Container:WaitForChild("EventTasks")
    t_1.EventTasksLockedFrame = t_1.EventTasksFrame:WaitForChild("Locked")
    t_1.EventTasksLockedDescription = t_1.EventTasksLockedFrame:WaitForChild("Description")
    t_1.EventTasksUnlockedFrame = t_1.EventTasksFrame:WaitForChild("Unlocked")
    t_1.EventTasksContainer = t_1.EventTasksUnlockedFrame:WaitForChild("Container")
    t_1.EventTasksTitleText = t_1.EventTasksContainer:WaitForChild("Title")
    t_1.EventTasksSlotsFrame = t_1.EventTasksContainer:WaitForChild("Slots")
    t_1.EventTasksSlotsLayout = t_1.EventTasksSlotsFrame:WaitForChild("Layout")
    t_1.RushFrame = t_1.EventTasksUnlockedFrame:WaitForChild("Rush")
    t_1.RushContainer = t_1.RushFrame:WaitForChild("Container")
    t_1.RushTitleText = t_1.RushContainer:WaitForChild("Title")
    t_1.RushProgressFrame = t_1.RushContainer:WaitForChild("Progress")
    t_1.RushProgressBar = t_1.RushProgressFrame:WaitForChild("Bar")
    t_1.RushProgressCompleted = t_1.RushProgressFrame:WaitForChild("Completed")
    t_1.RushProgressText = t_1.RushProgressFrame:WaitForChild("Title")
    t_1.ShopEntriesFrame = t_1.Container:WaitForChild("ShopEntries")
    t_1.ShopEntriesContainer = t_1.ShopEntriesFrame:WaitForChild("Container")
    t_1.ShopEntriesTitleText = t_1.ShopEntriesContainer:WaitForChild("Title")
    t_1.ShopEntriesSlotsFrame = t_1.ShopEntriesContainer:WaitForChild("Slots")
    t_1.ShopEntriesSlotsLayout = t_1.ShopEntriesSlotsFrame:WaitForChild("Layout")
    t_1.AdventCalendarFrame = t_1.Container:WaitForChild("AdventCalendar")
    t_1.SkinBundleFrame = t_1.Container:WaitForChild("SkinBundle")
    t_1.SkinBundleContainer = t_1.SkinBundleFrame:WaitForChild("Container")
    t_1.SkinBundleRewardsFrame = t_1.SkinBundleContainer:WaitForChild("Rewards")
    t_1.PromptSystem = PromptSystem_m.new(t_1.PromptsFrame)
    t_1.AdventCalendarSlot = AdventCalendarSlot_m.new(t_1.AdventCalendarFrame)
    t_1._open_connections = {}
    t_1._task_slots = {}
    t_1._shop_slots = {}
    t_1:_Init()

    return t_1
end

function t.Open(arg1, ...) -- line: 80
    -- upvalues:
    --  [1] Page_m (copy)
    --  [2] PlayerDataController_m (copy)

    Page_m.Open(arg1, ...)
    arg1.AdventCalendarSlot:SetEnabled(true)
    local OpenConnections = arg1._open_connections
    local Tasks = PlayerDataController_m:GetDataChangedSignal("Tasks")
    table.insert(OpenConnections, Tasks:Connect(function() -- line: 85
        -- upvalues:
        --  [1] arg1 (copy)

        arg1:_GenerateTasks()
    end))
    local OpenConnections_1 = arg1._open_connections
    local EventTasks = PlayerDataController_m:GetDataChangedSignal("EventTasks")
    table.insert(OpenConnections_1, EventTasks:Connect(function() -- line: 89
        -- upvalues:
        --  [1] arg1 (copy)

        arg1:_GenerateTasks()
    end))
    local OpenConnections_2 = arg1._open_connections
    local CosmeticInventory = PlayerDataController_m:GetDataChangedSignal("CosmeticInventory")
    table.insert(OpenConnections_2, CosmeticInventory:Connect(function() -- line: 93
        -- upvalues:
        --  [1] arg1 (copy)

        arg1:_GenerateShopEntries()
    end))
    local OpenConnections_3 = arg1._open_connections
    local WeaponInventory = PlayerDataController_m:GetDataChangedSignal("WeaponInventory")
    table.insert(OpenConnections_3, WeaponInventory:Connect(function() -- line: 97
        -- upvalues:
        --  [1] arg1 (copy)

        arg1:_GenerateShopEntries()
    end))
    local OpenConnections_4 = arg1._open_connections
    local EventCurrencyRushProgress = PlayerDataController_m:GetDataChangedSignal(
        "EventCurrencyRushProgress"
    )
    table.insert(OpenConnections_4, EventCurrencyRushProgress:Connect(function() -- line: 101
        -- upvalues:
        --  [1] arg1 (copy)

        arg1:_UpdateRush()
    end))
    local OpenConnections_5 = arg1._open_connections
    local StatisticDuelsPlayed = PlayerDataController_m:GetDataChangedSignal("StatisticDuelsPlayed")
    table.insert(OpenConnections_5, StatisticDuelsPlayed:Connect(function() -- line: 105
        -- upvalues:
        --  [1] arg1 (copy)

        arg1:_UpdateLocked()
    end))
    task.spawn(function() -- line: 109
        -- upvalues:
        --  [1] arg1 (copy)

        local IsOpenHash = arg1._is_open_hash

        while true do
            if IsOpenHash ~= arg1._is_open_hash then
                break
            end

            arg1:_UpdateCountdown()
            wait(1)
        end
    end)
    arg1:_UpdateRush()
    arg1:_UpdateCountdown()
    arg1:_UpdateLocked()
    arg1:_GenerateTasks()
    arg1:_GenerateShopEntries()
end

function t.Close(arg2, ...) -- line: 125
    -- upvalues:
    --  [1] Page_m (copy)

    arg2.AdventCalendarSlot:SetEnabled(false)
    Page_m.Close(arg2, ...)
end

function t._UpdateLayouts(arg3) -- line: 134
    arg3.List.CanvasSize = UDim2.new(0, 0, 0, arg3.Layout.AbsoluteContentSize.Y)
    arg3.ShopEntriesFrame.Size = UDim2.new(
        1,
        0,
        0,
        arg3.ShopEntriesContainer.AbsoluteSize.Y * 0.3 + arg3.ShopEntriesSlotsLayout.AbsoluteContentSize.Y
    )
    local EventTasksFrame = arg3.EventTasksFrame
    EventTasksFrame.Size = if not arg3.EventTasksLockedFrame.Visible then UDim2.new(
        1,
        0,
        0,
        arg3.EventTasksContainer.AbsoluteSize.Y * 0.2 + arg3.EventTasksSlotsLayout.AbsoluteContentSize.Y + arg3.RushFrame.AbsoluteSize.Y
    ) else UDim2.new(1, 0, 0.075, 0)
end

function t._UpdateLocked(arg4) -- line: 141
    -- upvalues:
    --  [1] EventLibrary_m (copy)
    --  [2] PlayerDataController_m (copy)

    local v12 = EventLibrary_m.NUM_GAMES_NEEDED_TO_PARTICIPATE - PlayerDataController_m:GetStatistic(
        "StatisticDuelsPlayed"
    )
    arg4.List.Visible = v12 <= 0 and true
    local LockedFrame = arg4.LockedFrame
    LockedFrame.Visible = v12 > 0
    arg4.LockedDescriptionText.Text = "Play " .. v12 .. " more duels to gain access!"
end

function t._UpdateCountdown(arg5) -- line: 149
    -- upvalues:
    --  [1] EventController_m (copy)
    --  [2] Utility_m (copy)

    local v14 = EventController_m:GetTimeRemaining()
    local HeaderCountdownText = arg5.HeaderCountdownText
    HeaderCountdownText.Text = if v14 and v14 == 0 then "Ending any minute now!" else v14 and v14 > 0 and "Ending in " .. Utility_m:TimeFormat2(
        v14
    ) or "Here for a limited time only!"
end

function t._UpdateRush(arg6) -- line: 157
    -- upvalues:
    --  [1] PlayerDataController_m (copy)
    --  [2] EventLibrary_m (copy)

    local v16 = PlayerDataController_m:Get("EventCurrencyRushProgress")
    local clampedValue = math.clamp(v16 / EventLibrary_m.CURRENCY_RUSH_DAILY_LIMIT, 0, 1)
    local RushProgressText = arg6.RushProgressText
    RushProgressText.Text = clampedValue < 1 and v16 .. " / " .. EventLibrary_m.CURRENCY_RUSH_DAILY_LIMIT or ""
    local RushProgressCompleted = arg6.RushProgressCompleted
    RushProgressCompleted.Visible = clampedValue >= 1
    arg6.RushProgressBar.Size = UDim2.new(clampedValue, 0, 1, 2)
    local RushProgressBar_1 = arg6.RushProgressBar
    RushProgressBar_1.BackgroundColor3 = clampedValue < 1 and EventLibrary_m.EVENT_DETAILS.CURRENCY_COLOR or Color3.fromRGB(
        100,
        255,
        50
    )
end

function t._GenerateTasks(arg7, _) -- line: 167
    -- upvalues:
    --  [1] PlayerDataController_m (copy)
    --  [2] TaskSlot_m (copy)

    for _, val in pairs(arg7._task_slots) do
        val:Destroy()
    end

    arg7._task_slots = {}
    arg7.EventTasksLockedFrame.Visible = not PlayerDataController_m:AreTasksCompleted()
    arg7.EventTasksUnlockedFrame.Visible = not arg7.EventTasksLockedFrame.Visible
    local v19 = PlayerDataController_m:Get("EventTasks")
    local v20 = pairs
    local v21 = v19 or {}

    for _, val_1 in v20(v21) do
        local v22 = TaskSlot_m.new(val_1)
        v22:SetParent(arg7.EventTasksSlotsFrame)
        table.insert(arg7._task_slots, v22)
    end

    arg7:_UpdateLayouts()
end

function t._GenerateShopEntries(arg9) -- line: 188
    -- upvalues:
    --  [1] EventLibrary_m (copy)
    --  [2] ShopSlot_m (copy)
    --  [3] ShopController_m (copy)

    for _, val_2 in pairs(arg9._shop_slots) do
        val_2:Destroy()
    end

    arg9._shop_slots = {}
    local v23 = pairs
    local v24 = EventLibrary_m.IS_ACTIVE and EventLibrary_m.SHOP_ENTRIES_OVERVIEW or {}

    for _, val_3 in v23(v24) do
        local v25 = ShopSlot_m.new(ShopController_m:GetShopEntry(val_3))
        v25.Frame.Parent = arg9.ShopEntriesSlotsFrame
        table.insert(arg9._shop_slots, v25)
        v25.RewardSlot:OnClick(function() -- line: 200
            -- upvalues:
            --  [1] v25 (copy)
            --  [2] arg9 (copy)

            if v25.IsLocked or v25.IsOwned then
                return
            end

            arg9.PromptSystem:Open("InspectShopEntry", v25.ShopEntry.EntryName)
        end)
    end
end

function t._Setup(arg10) -- line: 210
    -- upvalues:
    --  [1] EventLibrary_m (copy)
    --  [2] MatchmakingQueueSlot_m (copy)
    --  [3] MonetizationLibrary_m (copy)
    --  [4] CosmeticLibrary_m (copy)
    --  [5] ComplianceController_m (copy)
    --  [6] RewardSlot_m (copy)
    --  [7] ShopController_m (copy)

    arg10.HeaderPicture.Image = EventLibrary_m.EVENT_DETAILS.OVERVIEW_BANNER_IMAGE
    arg10.HeaderTitleText.Text = string.upper(EventLibrary_m.EVENT_NAME or "???") .. " EVENT"
    arg10.EventTasksTitleText.Text = "Earn " .. EventLibrary_m.EVENT_DETAILS.CURRENCY_NAME_PLURAL .. "!"
    arg10.ShopEntriesTitleText.Text = "Spend " .. EventLibrary_m.EVENT_DETAILS.CURRENCY_NAME_PLURAL .. "!"
    arg10.RushTitleText.Text = string.upper(EventLibrary_m.EVENT_DETAILS.CURRENCY_NAME) .. " RUSH \226\128\148 Earn \195\151" .. EventLibrary_m.CURRENCY_RUSH_MULTIPLIER .. " " .. EventLibrary_m.EVENT_DETAILS.CURRENCY_NAME_PLURAL .. " every day!"
    arg10.EventTasksLockedDescription.Text = "Complete your Daily Tasks to start earning " .. EventLibrary_m.EVENT_DETAILS.CURRENCY_NAME_PLURAL .. "!"
    arg10.SkinBundleFrame.Visible = if EventLibrary_m.SKIN_BUNDLE_NAME == nil then false else true
    local v27 = pairs
    local v26 = EventLibrary_m.LTM_QUEUENAMES or {}

    for key_4, val_4 in v27(v26) do
        local Frame = Instance.new("Frame")
        Frame.Name = val_4
        Frame.AnchorPoint = Vector2.new(0.5, 0.5)
        Frame.Size = UDim2.new(0.995, 0, 0.2, 0)
        Frame.BackgroundTransparency = 1
        Frame.LayoutOrder = 10 + key_4
        Frame.Parent = arg10.Container
        MatchmakingQueueSlot_m.new(val_4, Frame).QueueStatus:Connect(function(arg11) -- line: 230
            -- upvalues:
            --  [1] arg10 (copy)

            if arg11 == "Success" then
                arg10:CloseRequest()

                return
            end

            arg10.PromptSystem:Open(
                "ErrorMessage",
                "Whoops!",
                arg11 or "Server failed to respond, please try again"
            )
        end)
    end

    if EventLibrary_m.SKIN_BUNDLE_NAME then
        for key_5, val_5 in pairs(
            MonetizationLibrary_m.Bundles[EventLibrary_m.SKIN_BUNDLE_NAME].RewardsWithIndividualProductIDs
        ) do
            if val_5[1] then
                local v28 = val_5[3]
                local v29 = CosmeticLibrary_m.Rewards[v28.Name]

                if
                    not v29
                    or v29.Type ~= "Lootbox"
                    or not ComplianceController_m:ArePaidRandomItemsRestricted()
                then
                    local v30 = RewardSlot_m.new(v28)
                    v30.Frame.LayoutOrder = key_5
                    v30:SetInteractable(false)
                    v30:SetNameText("")
                    v30:HideWeaponVisual()
                    v30:SetParent(arg10.SkinBundleRewardsFrame)
                end
            end
        end
    end

    ShopController_m:GetDailyShop()
end

function t._Init(arg12) -- line: 266
    -- upvalues:
    --  [1] Pages_m (copy)
    --  [2] EventLibrary_m (copy)
    --  [3] ButtonEffect_m (copy)

    arg12.CloseButton.MouseButton1Click:Connect(function() -- line: 267
        -- upvalues:
        --  [1] arg12 (copy)

        arg12:CloseRequest()
    end)
    arg12.Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() -- line: 271
        -- upvalues:
        --  [1] arg12 (copy)

        arg12:_UpdateLayouts()
    end)
    arg12.EventTasksSlotsLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() -- line: 275
        -- upvalues:
        --  [1] arg12 (copy)

        arg12:_UpdateLayouts()
    end)
    arg12.ShopEntriesSlotsLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() -- line: 279
        -- upvalues:
        --  [1] arg12 (copy)

        arg12:_UpdateLayouts()
    end)
    arg12.SkinBundleContainer.MouseButton1Click:Connect(function() -- line: 283
        -- upvalues:
        --  [1] Pages_m (ref)
        --  [2] EventLibrary_m (ref)

        Pages_m.PageSystem:OpenPage("Shop")
        Pages_m.PageSystem:WaitForPage("Shop"):InspectSkinBundle(EventLibrary_m.SKIN_BUNDLE_NAME)
    end)
    arg12.PromptSystem.PromptAdded:Connect(function(arg13) -- line: 288
        -- upvalues:
        --  [1] arg12 (copy)
        --  [2] Pages_m (ref)

        arg12.List.CanvasPosition = Vector2.new(0, 0)

        if arg13.InspectCurrencyPage then
            arg13.InspectCurrencyPage:Connect(function() -- line: 292
                -- upvalues:
                --  [1] Pages_m (ref)

                Pages_m.PageSystem:OpenPage("Shop")
                Pages_m.PageSystem:WaitForPage("Shop"):SetPage("Currency")
            end)
        end
    end)
    arg12:_Setup()
    arg12:_UpdateRush()
    arg12:_UpdateCountdown()
    arg12:_UpdateLocked()
    arg12:_UpdateLayouts()
    arg12:_GenerateTasks()
    arg12:_GenerateShopEntries()
    ButtonEffect_m:Add(arg12.CloseButton)
    ButtonEffect_m:Add(arg12.SkinBundleContainer, nil, { HoverRatio = 1.025, ReleaseRatio = 1.025 })
end

return t._new()
