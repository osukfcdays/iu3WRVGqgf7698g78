local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local CONSTANTS_m = require(ReplicatedStorage.Modules.CONSTANTS)
local RotatingQueueLibrary_m = require(ReplicatedStorage.Modules.RotatingQueueLibrary)
local _ = require(ReplicatedStorage.Modules.CosmeticLibrary)
local SeasonLibrary_m = require(ReplicatedStorage.Modules.SeasonLibrary)
local EventLibrary_m = require(ReplicatedStorage.Modules.EventLibrary)
local DuelLibrary_m = require(ReplicatedStorage.Modules.DuelLibrary)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local LeaderboardController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("LeaderboardController")
)
local PlayerDataController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("PlayerDataController")
)
local ArcadeController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("ArcadeController")
)
local MatchmakingQueueSlot_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("BaseMatchmakingQueueSlot"):WaitForChild(
        "MatchmakingQueueSlot"
    )
)
local BaseMatchmakingQueueSlot_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("BaseMatchmakingQueueSlot")
)
local ButtonEffect_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("ButtonEffect")
)
local PromptSystem_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("PromptSystem")
)
local RewardSlot_m = require(Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("RewardSlot"))
local RankIcon_m = require(Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("RankIcon"))
local Page_m = require(Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("Page"))
local _ = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("MatchmakingQueueSlot")
local t = setmetatable({}, Page_m)
t.__index = t

function t._new() -- line: 28
    -- upvalues:
    --  [1] Page_m (copy)
    --  [2] t (copy)
    --  [3] PromptSystem_m (copy)
    --  [4] BaseMatchmakingQueueSlot_m (copy)

    local t_1 = setmetatable(Page_m.new(script.Name), t)
    t_1.PromptsFrame = t_1.PageFrame:WaitForChild("Prompts")
    t_1.PageContainer = t_1.PageFrame:WaitForChild("Container")
    t_1.CloseButton = t_1.PageContainer:WaitForChild("Close")
    t_1.List = t_1.PageContainer:WaitForChild("List")
    t_1.Container = t_1.List:WaitForChild("Container")
    t_1.Layout = t_1.Container:WaitForChild("Layout")
    t_1.CenterDuelsFrame = t_1.Container:WaitForChild("CenterDuels")
    t_1.DuelsFrame = t_1.Container:WaitForChild("Duels")
    t_1.DuelsContainer = t_1.DuelsFrame:WaitForChild("Container")
    t_1.DuelsContainerCloseButton = t_1.DuelsContainer:WaitForChild("Close")
    t_1.QueuesFrame = t_1.DuelsContainer:WaitForChild("Queues")
    t_1.RankedFrame = t_1.DuelsContainer:WaitForChild("Ranked")
    t_1.RankedButton = t_1.RankedFrame:WaitForChild("Button")
    t_1.RankedThumbnail = t_1.RankedButton:WaitForChild("Thumbnail")
    t_1.RankedLockedFrame = t_1.RankedButton:WaitForChild("Locked")
    t_1.RankedLockedText = t_1.RankedLockedFrame:WaitForChild("Description")
    t_1.RankedUnlockedFrame = t_1.RankedButton:WaitForChild("Unlocked")
    t_1.RankedIconContainer = t_1.RankedUnlockedFrame:WaitForChild("IconContainer")
    t_1.RankedSeasonText = t_1.RankedUnlockedFrame:WaitForChild("Season")
    t_1.RankedRankText = t_1.RankedUnlockedFrame:WaitForChild("Rank")
    t_1.RankedELOText = t_1.RankedUnlockedFrame:WaitForChild("ELO")
    t_1.AprilFoolsFrame = t_1.Container:WaitForChild("AprilFools")
    t_1.AprilFoolsContainer = t_1.AprilFoolsFrame:WaitForChild("Container")
    t_1.AprilFoolsSlotsFrame = t_1.AprilFoolsContainer:WaitForChild("Slots")
    t_1.AprilFoolsSlotsLayout = t_1.AprilFoolsSlotsFrame:WaitForChild("Layout")
    t_1.ArcadeServersFrame = t_1.Container:WaitForChild("ArcadeServers")
    t_1.ArcadeServersContainer = t_1.ArcadeServersFrame:WaitForChild("Container")
    t_1.ArcadeServersHeaderInfoButton = t_1.ArcadeServersContainer:WaitForChild("Header"):WaitForChild(
        "Info"
    )
    t_1.ArcadeServersHeaderInfoBubble = t_1.ArcadeServersHeaderInfoButton:WaitForChild("Bubble")
    t_1.ArcadeServersHeaderInfoBubbleTitle = t_1.ArcadeServersHeaderInfoBubble:WaitForChild("Title")
    t_1.ArcadeServersHeaderInfoBubbleBackground = t_1.ArcadeServersHeaderInfoBubble:WaitForChild(
        "Background"
    )
    t_1.RotatingFrame = t_1.Container:WaitForChild("Rotating")
    t_1.RotatingContainer = t_1.RotatingFrame:WaitForChild("Container")
    t_1.RotatingHeaderFrame = t_1.RotatingContainer:WaitForChild("Header")
    t_1.RotatingHeaderTitle = t_1.RotatingHeaderFrame:WaitForChild("Title")
    t_1.RotatingHeaderNewReleaseFrame = t_1.RotatingHeaderFrame:WaitForChild("NewRelease")
    t_1.RotatingSlotsFrame = t_1.RotatingContainer:WaitForChild("Slots")
    t_1.RotatingSlotsLayout = t_1.RotatingSlotsFrame:WaitForChild("Layout")
    t_1.EventFrame = t_1.Container:WaitForChild("Event")
    t_1.EventContainer = t_1.EventFrame:WaitForChild("Container")
    t_1.EventHeaderFrame = t_1.EventContainer:WaitForChild("Header")
    t_1.EventHeaderIcon = t_1.EventHeaderFrame:WaitForChild("Icon")
    t_1.EventRewardsFrame = t_1.EventHeaderFrame:WaitForChild("Rewards")
    t_1.EventSlotsFrame = t_1.EventContainer:WaitForChild("Slots")
    t_1.EventSlotsLayout = t_1.EventSlotsFrame:WaitForChild("Layout")
    t_1.PromptSystem = PromptSystem_m.new(t_1.PromptsFrame)
    t_1.RankedSlot = BaseMatchmakingQueueSlot_m.new(t_1.RankedFrame)
    t_1._matchmaking_queue_slots = {}
    t_1._rotating_matchmaking_queue_slots = {}
    t_1._rotating_batch_containers = {}
    t_1._rank_icon = nil
    t_1:_Init()

    return t_1
end

function t.ScrollTo(arg1, arg2, arg3) -- line: 94
    -- upvalues:
    --  [1] TweenService (copy)

    local v12 = if arg2 ~= "Arcade" then if arg2 ~= "Rotating" then if arg2 ~= "Event" then nil else arg1.EventFrame else arg1.RotatingFrame else arg1.ArcadeServersFrame

    if not v12 then
        return
    end

    task.delay(arg3 or 0, function() -- line: 104
        -- upvalues:
        --  [1] TweenService (ref)
        --  [2] arg1 (copy)
        --  [3] v12 (copy)

        TweenService:Create(
            arg1.List,
            TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
            {
                CanvasPosition = Vector2.new(
                    0,
                    v12.AbsolutePosition.Y - arg1.Container.AbsolutePosition.Y
                )
            }
        ):Play()
    end)
end

function t.Open(arg4, ...) -- line: 109
    -- upvalues:
    --  [1] Page_m (copy)

    Page_m.Open(arg4, ...)
    arg4.List.CanvasPosition = Vector2.zero
    task.defer(arg4._GenerateRotatingLoop, arg4)
end

function t._UpdateLayouts(arg5) -- line: 119
    arg5.RotatingFrame.Size = UDim2.new(1, 0, 0.1, arg5.RotatingSlotsLayout.AbsoluteContentSize.Y)
    arg5.EventFrame.Size = UDim2.new(1, 0, 0.11, arg5.EventSlotsLayout.AbsoluteContentSize.Y)
    arg5.AprilFoolsFrame.Size = UDim2.new(
        1,
        0,
        0.1,
        arg5.AprilFoolsSlotsLayout.AbsoluteContentSize.Y
    )
    arg5.ArcadeServersHeaderInfoBubbleBackground.Size = UDim2.new(
        0.04,
        arg5.ArcadeServersHeaderInfoBubbleTitle.TextBounds.X,
        1,
        0
    )
end

function t._UpdateArcadeServerHeaderInfo(arg6) -- line: 126
    arg6.ArcadeServersHeaderInfoButton.Visible = true
end

function t._UpdateLocked(arg7) -- line: 130
    -- upvalues:
    --  [1] PlayerDataController_m (copy)
    --  [2] SeasonLibrary_m (copy)

    local v15 = PlayerDataController_m:Get("Level") < SeasonLibrary_m.CurrentSeason.LevelRequirement and true
    arg7.RankedLockedFrame.Visible = v15
    arg7.RankedUnlockedFrame.Visible = not v15
end

function t._UpdateELO(arg8) -- line: 137
    -- upvalues:
    --  [1] SeasonLibrary_m (copy)
    --  [2] PlayerDataController_m (copy)
    --  [3] Players (copy)
    --  [4] Utility_m (copy)
    --  [5] RankIcon_m (copy)

    if arg8._rank_icon then
        arg8._rank_icon:Destroy()
        arg8._rank_icon = nil
    end

    local _ = SeasonLibrary_m.CurrentSeason.RankProfile
    local v17 = PlayerDataController_m:Get("Seasons")[SeasonLibrary_m.CurrentSeason.Name]
    local v16 = v17

    if v16 then
        v16 = v17.RankedPerformances[SeasonLibrary_m.UNIVERSAL_ELO_NAME]
    end

    if not v16 then
        return
    end

    arg8.RankedRankText.Text = SeasonLibrary_m:GetRank(v16.CurrentELO, Players.LocalPlayer.UserId)
    arg8.RankedELOText.Text = if not v16.CurrentELO then v16.DuelsPlayed .. " / " .. SeasonLibrary_m.CurrentSeason.RankProfile.NumPlacementDuels else Utility_m:PrettyNumber(
        v16.CurrentELO
    ) .. " ELO"

    if v16.CurrentELO then
        arg8._rank_icon = RankIcon_m.new(v16.CurrentELO, Players.LocalPlayer.UserId)
        arg8._rank_icon:SetParent(arg8.RankedIconContainer)
    end
end

function t._UpdateList(arg9) -- line: 162
    arg9.CloseButton.Position = UDim2.new(0.975, 0, 0.0225, arg9.PageFrame.AbsoluteSize.Y * 0.125)
    arg9.List.Position = UDim2.new(0.5, 9, 0, arg9.PageFrame.AbsoluteSize.Y * 0.125)
    arg9.List.Size = UDim2.new(0.85, 0, 0, arg9.PageFrame.AbsoluteSize.Y * 0.75)
    arg9.List.CanvasSize = UDim2.new(0, 0, 0, arg9.Layout.AbsoluteContentSize.Y)
end

function t._UpdateOnboarding(arg10) -- line: 169
    -- upvalues:
    --  [1] PlayerDataController_m (copy)
    --  [2] Utility_m (copy)
    --  [3] DuelLibrary_m (copy)

    local StatisticDuelsPlayed = PlayerDataController_m:GetStatistic("StatisticDuelsPlayed")
    arg10.RotatingFrame.Visible = StatisticDuelsPlayed >= 3 and true
    local ArcadeServersFrame = arg10.ArcadeServersFrame
    local v20 = StatisticDuelsPlayed >= 4
    ArcadeServersFrame.Visible = v20
    v20 = false
    local AprilFoolsFrame_1 = arg10.AprilFoolsFrame

    if StatisticDuelsPlayed >= 10 then
        v20 = Utility_m:IsAprilFoolsGamemodesEnabled()

        if v20 then
            v20 = DuelLibrary_m.APRIL_FOOLS_QUEUES and #DuelLibrary_m.APRIL_FOOLS_QUEUES > 0
        end
    end

    AprilFoolsFrame_1.Visible = v20
    local CenterDuelsFrame = arg10.CenterDuelsFrame
    v20 = StatisticDuelsPlayed < 3
    CenterDuelsFrame.Visible = v20
    arg10.DuelsContainerCloseButton.Visible = arg10.CenterDuelsFrame.Visible
    arg10.CloseButton.Visible = not arg10.CenterDuelsFrame.Visible
end

function t._UpdateBeginnerQueue(arg11) -- line: 180
    -- upvalues:
    --  [1] CONSTANTS_m (copy)
    --  [2] PlayerDataController_m (copy)

    local v21 = arg11._matchmaking_queue_slots[CONSTANTS_m.BEGINNER_QUEUE_NAME]

    if not v21 then
        arg11.RankedFrame.Visible = true

        return
    end

    local v22 = PlayerDataController_m:GetStatistic("StatisticDuelsWon") < CONSTANTS_m.BEGINNER_QUEUE_WINS and true
    v21.Frame.Visible = v22
    arg11.RankedFrame.Visible = not v22
    local QueuesFrame = arg11.QueuesFrame
    QueuesFrame.Position = if v22 then UDim2.new(1, 0, 0.2, 0) else UDim2.new(0.7, 0, 0.2, 0) or UDim2.new(
        1,
        0,
        0.2,
        0
    )
end

function t._RespondToQueueStatus(arg12, arg13) -- line: 195
    if arg13 == "Success" then
        arg12.Closed:Fire()

        return
    end

    arg12.PromptSystem:Open(
        "ErrorMessage",
        "Whoops!",
        arg13 or "Server failed to respond, please try again"
    )
end

function t._GenerateQueues(
    arg14,
    arg15,
    arg16,
    arg17,
    arg18,
    arg19,
    arg20
) -- line: 203
    -- upvalues:
    --  [1] MatchmakingQueueSlot_m (copy)

    if arg17 then
        for _, val in pairs(arg17) do
            val:Destroy()
        end

        table.clear(arg17)
    end

    local v24 = arg17 or {}
    local v25 = if not arg19 then 2 else 1

    for index = 1, math.ceil(#arg16 / v25) do
        local Frame = Instance.new("Frame")
        Frame.AnchorPoint = Vector2.new(0.5, 0.5)
        Frame.Size = UDim2.new(1, 0, 1, 0)
        Frame.BackgroundTransparency = 1
        Frame.Parent = arg15
        table.insert(v24, Frame)
        local UIListLayout = Instance.new("UIListLayout")
        UIListLayout.Padding = UDim.new(0.005, 0)
        UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        UIListLayout.FillDirection = Enum.FillDirection.Horizontal
        UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Top
        UIListLayout.Parent = Frame
        local v26 = arg16[v25 * (index - 1) + 1 + 1] and v25 or 1

        for index_1 = 1, v26 do
            local v27 = arg16[v25 * (index - 1) + index_1]
            local v28 = if arg20 then if index_1 ~= 1 then arg20 else 1 - arg20 else 1 / v26
            local Frame_1 = Instance.new("Frame")
            Frame_1.AnchorPoint = Vector2.new(0.5, 0.5)
            local New = UDim2.new
            local v29 = v28 - UIListLayout.Padding.Scale * v28 * (v26 - 1)
            local v30 = if arg19 then 1 else if not (index > 1) then 1 else if v26 ~= 1 then 1 else 0.75
            Frame_1.Size = New(v29, 0, v30, 0)
            Frame_1.BackgroundTransparency = 1
            Frame_1.Parent = Frame
            v28 = MatchmakingQueueSlot_m.new(v27, Frame_1)
            v28.QueueStatus:Connect(function(arg21) -- line: 244
                -- upvalues:
                --  [1] arg14 (copy)

                arg14:_RespondToQueueStatus(arg21)
            end)
            arg14._matchmaking_queue_slots[v27] = v28

            if arg18 then
                arg18(v27, Frame_1, v28)
            end
        end
    end
end

function t._GenerateRotating(arg22) -- line: 257
    -- upvalues:
    --  [1] RotatingQueueLibrary_m (copy)

    for _, val_1 in pairs(arg22._rotating_matchmaking_queue_slots) do
        val_1.Container:Destroy()
        val_1.MatchmakingQueueSlot:Destroy()
    end

    local function callback(arg23, arg24, arg25) -- line: 263
        -- upvalues:
        --  [1] arg22 (copy)

        arg22._rotating_matchmaking_queue_slots[arg23] = {
            Container = arg24,
            MatchmakingQueueSlot = arg25
        }
    end

    arg22:_GenerateQueues(
        arg22.RotatingSlotsFrame,
        RotatingQueueLibrary_m:GetCurrent().QueueNames,
        arg22._rotating_batch_containers,
        callback
    )
end

function t._GenerateRotatingLoop(arg26) -- line: 270
    -- upvalues:
    --  [1] RotatingQueueLibrary_m (copy)
    --  [2] Utility_m (copy)

    local IsOpenHash = arg26._is_open_hash
    local v31 = nil

    while true do
        if not arg26._is_open or IsOpenHash ~= arg26._is_open_hash then
            break
        end

        local v32 = RotatingQueueLibrary_m:GetCycle()

        if v32 ~= v31 then
            v31 = v32
            arg26:_GenerateRotating()
        end

        arg26.RotatingHeaderTitle.Text = "New gamemodes in " .. Utility_m:TimeFormat2(
            (math.ceil((RotatingQueueLibrary_m:GetTimeUntilNext())))
        )
        arg26.RotatingHeaderNewReleaseFrame.Visible = RotatingQueueLibrary_m:IsNewRelease()
        wait(1)
    end
end

function t._GenerateQueueSlot(arg27, arg28) -- line: 289
    -- upvalues:
    --  [1] Utility_m (copy)
    --  [2] MatchmakingQueueSlot_m (copy)
    --  [3] CONSTANTS_m (copy)

    local v35 = Utility_m:WaitForChildRecursive(arg27.Container, arg28, 2)

    if not v35 then
        return
    end

    local v36 = MatchmakingQueueSlot_m.new(arg28, v35)
    v36.QueueStatus:Connect(function(arg29) -- line: 298
        -- upvalues:
        --  [1] arg27 (copy)

        arg27:_RespondToQueueStatus(arg29)
    end)
    arg27._matchmaking_queue_slots[arg28] = v36

    if arg28 == CONSTANTS_m.BEGINNER_QUEUE_NAME then
        arg27:_UpdateBeginnerQueue()
    end
end

function t._Setup(arg30) -- line: 309
    -- upvalues:
    --  [1] SeasonLibrary_m (copy)
    --  [2] EventLibrary_m (copy)
    --  [3] CONSTANTS_m (copy)
    --  [4] DuelLibrary_m (copy)
    --  [5] RewardSlot_m (copy)
    --  [6] BaseMatchmakingQueueSlot_m (copy)
    --  [7] ArcadeController_m (copy)

    arg30.RankedLockedText.Text = "Unlocked at\nLevel " .. SeasonLibrary_m.CurrentSeason.LevelRequirement
    arg30.RankedSeasonText.Text = "Season " .. SeasonLibrary_m.CurrentSeason.Version
    arg30.RankedThumbnail.Image = SeasonLibrary_m.CurrentSeason.ThumbnailRankedCoverPhoto
    local EventHeaderIcon = arg30.EventHeaderIcon
    EventHeaderIcon.Image = EventLibrary_m.EVENT_DETAILS and EventLibrary_m.EVENT_DETAILS.LTM_HEADER_ICON or arg30.EventHeaderIcon.Image
    arg30.ArcadeServersHeaderInfoBubbleTitle.Text = string.format(
        "You must be Level %s+ to earn XP from Arcade Servers\nThis includes Career XP, Weapon XP, & Task progress",
        CONSTANTS_m.LEVEL_REQUIRED_FOR_REWARDS_FROM_ARCADE_SERVERS
    )

    for _, val_2 in pairs(DuelLibrary_m.MatchmakingQueueOrder) do
        task.defer(arg30._GenerateQueueSlot, arg30, val_2)
    end

    if DuelLibrary_m.APRIL_FOOLS_QUEUES and #DuelLibrary_m.APRIL_FOOLS_QUEUES > 0 then
        arg30:_GenerateQueues(arg30.AprilFoolsSlotsFrame, DuelLibrary_m.APRIL_FOOLS_QUEUES)
    end

    local EventFrame_1 = arg30.EventFrame
    local v38 = EventLibrary_m.IS_ACTIVE and EventLibrary_m.LTM_QUEUENAMES and #EventLibrary_m.LTM_QUEUENAMES > 0
    EventFrame_1.Visible = v38
    local EventRewardsFrame = arg30.EventRewardsFrame
    v38 = EventLibrary_m.LTM_QUEUES_REWARDS_DISPLAYED and #EventLibrary_m.LTM_QUEUES_REWARDS_DISPLAYED > 0
    EventRewardsFrame.Visible = v38

    if arg30.EventFrame.Visible then
        arg30:_GenerateQueues(
            arg30.EventSlotsFrame,
            EventLibrary_m.LTM_QUEUENAMES,
            nil,
            nil,
            EventLibrary_m.LTM_QUEUES_SMART_TILING_DISABLED,
            EventLibrary_m.LTM_QUEUES_SMART_TILING_X_SIZE_MULTIPLIER
        )

        for _, val_3 in pairs(EventLibrary_m.LTM_QUEUES_REWARDS_DISPLAYED) do
            local v39 = RewardSlot_m.new({ Name = val_3 })
            v39:EnableOwnedLogic(true)
            v39:SetParent(arg30.EventRewardsFrame)
        end
    end

    for _, val_4 in pairs(DuelLibrary_m.ArcadeModeOrder) do
        local v40 = DuelLibrary_m.ArcadeModes[val_4]
        local v41 = arg30.ArcadeServersContainer:WaitForChild(val_4)
        v41:WaitForChild("Button"):WaitForChild("Title").Text = v40.DisplayName
        v41:WaitForChild("Button"):WaitForChild("Description").Text = v40.Description
        v41:WaitForChild("Button"):WaitForChild("Thumbnail").Image = v40.Thumbnail
        BaseMatchmakingQueueSlot_m.new(v41).Clicked:Connect(function() -- line: 352
            -- upvalues:
            --  [1] ArcadeController_m (ref)
            --  [2] val_4 (copy)

            ArcadeController_m:ToArcadeServer(val_4)
        end)
    end
end

function t._Init(arg31) -- line: 358
    -- upvalues:
    --  [1] PlayerDataController_m (copy)
    --  [2] SeasonLibrary_m (copy)
    --  [3] Utility_m (copy)
    --  [4] LeaderboardController_m (copy)
    --  [5] ButtonEffect_m (copy)

    arg31.CloseButton.MouseButton1Click:Connect(function() -- line: 359
        -- upvalues:
        --  [1] arg31 (copy)

        arg31:CloseRequest()
    end)
    arg31.DuelsContainerCloseButton.MouseButton1Click:Connect(function() -- line: 363
        -- upvalues:
        --  [1] arg31 (copy)

        arg31:CloseRequest()
    end)
    arg31.ArcadeServersHeaderInfoButton.MouseButton1Click:Connect(function() -- line: 367
        -- upvalues:
        --  [1] arg31 (copy)

        arg31.ArcadeServersHeaderInfoBubble.Visible = not arg31.ArcadeServersHeaderInfoBubble.Visible
    end)
    arg31.Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() -- line: 371
        -- upvalues:
        --  [1] arg31 (copy)

        arg31:_UpdateList()
    end)
    arg31.PageFrame:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- line: 375
        -- upvalues:
        --  [1] arg31 (copy)

        arg31:_UpdateList()
    end)
    arg31.RankedSlot.Clicked:Connect(function() -- line: 379
        -- upvalues:
        --  [1] PlayerDataController_m (ref)
        --  [2] SeasonLibrary_m (ref)
        --  [3] arg31 (copy)
        --  [4] Utility_m (ref)

        if PlayerDataController_m:Get("Level") >= SeasonLibrary_m.CurrentSeason.LevelRequirement then
            arg31.OpenPage:Fire("Ranked")

            return
        end

        Utility_m:CreateSound(
            "rbxassetid://17153811469",
            2,
            1,
            script,
            true,
            5
        )
    end)
    arg31.RotatingSlotsLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() -- line: 387
        -- upvalues:
        --  [1] arg31 (copy)

        arg31:_UpdateLayouts()
    end)
    arg31.EventSlotsLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() -- line: 391
        -- upvalues:
        --  [1] arg31 (copy)

        arg31:_UpdateLayouts()
    end)
    arg31.AprilFoolsSlotsLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() -- line: 395
        -- upvalues:
        --  [1] arg31 (copy)

        arg31:_UpdateLayouts()
    end)
    arg31.ArcadeServersHeaderInfoBubbleTitle:GetPropertyChangedSignal("TextBounds"):Connect(function() -- line: 399
        -- upvalues:
        --  [1] arg31 (copy)

        arg31:_UpdateLayouts()
    end)
    PlayerDataController_m:GetDataChangedSignal("StatisticDuelsPlayed"):Connect(function() -- line: 403
        -- upvalues:
        --  [1] arg31 (copy)

        arg31:_UpdateOnboarding()
    end)
    PlayerDataController_m:GetDataChangedSignal("StatisticDuelsWon"):Connect(function() -- line: 407
        -- upvalues:
        --  [1] arg31 (copy)

        arg31:_UpdateBeginnerQueue()
    end)
    PlayerDataController_m:GetDataChangedSignal("Level"):Connect(function() -- line: 411
        -- upvalues:
        --  [1] arg31 (copy)

        arg31:_UpdateLocked()
        arg31:_UpdateArcadeServerHeaderInfo()
    end)
    PlayerDataController_m:GetDataChangedSignal("Seasons"):Connect(function() -- line: 416
        -- upvalues:
        --  [1] arg31 (copy)

        arg31:_UpdateELO()
    end)
    LeaderboardController_m:GetLeaderboardRefreshedSignal("Highest ELO"):Connect(function() -- line: 420
        -- upvalues:
        --  [1] arg31 (copy)

        arg31:_UpdateELO()
    end)
    arg31:_Setup()
    arg31:_UpdateList()
    arg31:_UpdateOnboarding()
    arg31:_UpdateELO()
    arg31:_UpdateLocked()
    arg31:_UpdateLayouts()
    arg31:_UpdateArcadeServerHeaderInfo()
    ButtonEffect_m:Add(arg31.CloseButton)
    ButtonEffect_m:Add(arg31.DuelsContainerCloseButton)
    ButtonEffect_m:Add(arg31.ArcadeServersHeaderInfoButton)
end

return t._new()
