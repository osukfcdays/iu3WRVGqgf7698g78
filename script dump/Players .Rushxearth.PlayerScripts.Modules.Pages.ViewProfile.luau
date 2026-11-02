local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local CONSTANTS_m = require(ReplicatedStorage.Modules.CONSTANTS)
local StatisticsLibrary_m = require(ReplicatedStorage.Modules.StatisticsLibrary)
local SeasonLibrary_m = require(ReplicatedStorage.Modules.SeasonLibrary)
local DuelLibrary_m = require(ReplicatedStorage.Modules.DuelLibrary)
local _ = require(ReplicatedStorage.Modules.ItemLibrary)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local ComplianceController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("ComplianceController")
)
local QueuePadController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("QueuePadController")
)
local FighterController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("FighterController")
)
local SeasonController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("SeasonController")
)
local PartyController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("PartyController")
)
local WeaponStatusHandler_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("WeaponStatusHandler")
)
local ButtonEffect_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("ButtonEffect")
)
local WeaponSlot_m = require(Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("WeaponSlot"))
local RankIcon_m = require(Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("RankIcon"))
local Page_m = require(Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("Page"))
local t = setmetatable({}, Page_m)
t.__index = t

function t._new() -- line: 24
    -- upvalues:
    --  [1] Page_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(Page_m.new(script.Name), t)
    t_1.LoadingFrame = t_1.PageFrame:WaitForChild("Loading")
    t_1.DotsFrame = t_1.LoadingFrame:WaitForChild("Dots")
    t_1.ActiveFrame = t_1.PageFrame:WaitForChild("Active")
    t_1.PlayerFrame = t_1.ActiveFrame:WaitForChild("Player")
    t_1.MostPlayedWeaponsFrame = t_1.PlayerFrame:WaitForChild("MostPlayedWeapons")
    t_1.MostPlayedMap = t_1.PlayerFrame:WaitForChild("MostPlayedMap")
    t_1.DisplayNameText = t_1.PlayerFrame:WaitForChild("DisplayName")
    t_1.ControlsIcon = t_1.DisplayNameText:WaitForChild("Controls")
    t_1.UsernameText = t_1.PlayerFrame:WaitForChild("Username")
    t_1.HeadshotIcon = t_1.PlayerFrame:WaitForChild("Headshot")
    t_1.BraggingFrame = t_1.PlayerFrame:WaitForChild("Bragging")
    t_1.LevelImage = t_1.BraggingFrame:WaitForChild("Level")
    t_1.LevelText = t_1.LevelImage:WaitForChild("Value")
    t_1.StreakImage = t_1.BraggingFrame:WaitForChild("Streak")
    t_1.StreakText = t_1.StreakImage:WaitForChild("Value")
    t_1.RankFrame = t_1.BraggingFrame:WaitForChild("Rank")
    t_1.RankContainer = t_1.RankFrame:WaitForChild("Container")
    t_1.RankText = t_1.RankFrame:WaitForChild("Title")
    t_1.WinsButton = t_1.PlayerFrame:WaitForChild("WinsButton")
    t_1.WinsButtonCasualBackground = t_1.WinsButton:WaitForChild("CasualBackground")
    t_1.WinsButtonRankedBackground = t_1.WinsButton:WaitForChild("RankedBackground")
    t_1.CasualFrame = t_1.PlayerFrame:WaitForChild("Casual")
    t_1.CasualWinsText = t_1.CasualFrame:WaitForChild("Wins")
    t_1.CasualWinsTitle = t_1.CasualFrame:WaitForChild("Wins")
    t_1.CasualWinPercentText = t_1.CasualFrame:WaitForChild("WinPercent")
    t_1.RankedFrame = t_1.PlayerFrame:WaitForChild("Ranked")
    t_1.RankedWinsText = t_1.RankedFrame:WaitForChild("Wins")
    t_1.RankedWinsTitle = t_1.RankedWinsText:WaitForChild("Title")
    t_1.RankedWinPercentText = t_1.RankedFrame:WaitForChild("WinPercent")
    t_1.ButtonsFrame = t_1.ActiveFrame:WaitForChild("Buttons")
    t_1.CloseButton = t_1.ButtonsFrame:WaitForChild("Close")
    t_1.ChallengeButton = t_1.ButtonsFrame:WaitForChild("Challenge")
    t_1.ChallengeOnFrame = t_1.ChallengeButton:WaitForChild("On")
    t_1.ChallengeOffFrame = t_1.ChallengeButton:WaitForChild("Off")
    t_1.InviteButton = t_1.ButtonsFrame:WaitForChild("Invite")
    t_1.InviteOnFrame = t_1.InviteButton:WaitForChild("On")
    t_1.InviteOffFrame = t_1.InviteButton:WaitForChild("Off")
    t_1._fetch_hash = 0
    t_1._weapon_slots = {}
    t_1._last_player_object = nil
    t_1._wins_tab_is_casual = nil
    t_1._wins_tab_hash = 0
    t_1._rank_icon = nil
    t_1:_Init()

    return t_1
end

function t.Fetch(arg1, arg2) -- line: 81
    -- upvalues:
    --  [1] WeaponStatusHandler_m (copy)
    --  [2] ReplicatedStorage (copy)
    --  [3] FighterController_m (copy)
    --  [4] SeasonLibrary_m (copy)
    --  [5] DuelLibrary_m (copy)
    --  [6] CONSTANTS_m (copy)
    --  [7] Utility_m (copy)
    --  [8] ComplianceController_m (copy)
    --  [9] StatisticsLibrary_m (copy)
    --  [10] QueuePadController_m (copy)
    --  [11] PartyController_m (copy)
    --  [12] RankIcon_m (copy)
    --  [13] WeaponSlot_m (copy)

    arg1._last_player_object = arg2
    arg1._fetch_hash += 1
    local FetchHash = arg1._fetch_hash
    arg1.DotsFrame:AddTag("UILoadingDots")
    arg1.LoadingFrame.Visible = true
    arg1.ActiveFrame.Visible = false

    for _, val in pairs(arg1._weapon_slots) do
        val:Destroy()
    end

    arg1._weapon_slots = {}

    if arg1._rank_icon then
        arg1._rank_icon:Destroy()
        arg1._rank_icon = nil
    end

    WeaponStatusHandler_m:ClearStatusElements(arg1.DisplayNameText)
    local v12 = ReplicatedStorage.Remotes.Misc.RequestProfile:InvokeServer(arg1._last_player_object)
    wait(0.25)

    if FetchHash ~= arg1._fetch_hash then
        return
    end

    if not v12 then
        arg1:CloseRequest()

        return
    end

    local v13 = FighterController_m:GetFighter(arg1._last_player_object)
    local v14 = SeasonLibrary_m:GetHighestELOLeaderboardRanking(
        v12.RankedCurrentELO,
        arg1._last_player_object.UserId
    )
    local v15 = SeasonLibrary_m:GetRank(v12.RankedCurrentELO, arg1._last_player_object.UserId)
    local StatisticDuelsWinStreak = arg1._last_player_object:GetAttribute("StatisticDuelsWinStreak")
    arg1.DotsFrame:RemoveTag("UILoadingDots")
    arg1.LoadingFrame.Visible = false
    arg1.ActiveFrame.Visible = true
    arg1.MostPlayedMap.Image = v12.FavoriteMap and DuelLibrary_m.Maps[v12.FavoriteMap] and DuelLibrary_m.Maps[v12.FavoriteMap].Image or ""
    arg1.UsernameText.Text = "@" .. arg1._last_player_object.Name
    local ControlsIcon = arg1.ControlsIcon
    local CONTROLSIMAGES = CONSTANTS_m.CONTROLS_IMAGES
    local v17 = v13

    if v17 then
        v17 = v13:Get("Controls")
    end

    ControlsIcon.Image = CONTROLSIMAGES[v17] or ""
    arg1.HeadshotIcon.Image = string.format(
        CONSTANTS_m.HEADSHOT_IMAGE,
        arg1._last_player_object.UserId
    )
    local StreakImage = arg1.StreakImage
    local v18 = StatisticDuelsWinStreak and StatisticDuelsWinStreak > 0
    StreakImage.Visible = v18
    arg1.StreakText.Text = Utility_m:PrettyNumber(StatisticDuelsWinStreak or 0)
    arg1.DisplayNameText.Text = ComplianceController_m:GetName(arg1._last_player_object)
    arg1.RankText.Text = if v14 and v14 <= SeasonLibrary_m.CurrentSeason.TopPlayerLeaderboardRank then "#" .. v14 else v15
    local CasualWinsTitle = arg1.CasualWinsTitle
    CasualWinsTitle.Text = if not v12.CasualWins then "win" else if v12.CasualWins == 1 then "win" else "wins"
    arg1.CasualWinsText.Text = StatisticsLibrary_m.Info.StatisticDuelsWon.TostringFunction(
        v12.CasualWins
    )
    arg1.CasualWinPercentText.Text = StatisticsLibrary_m.Info.StatisticDuelsWinPercent.TostringFunction(
        v12.CasualWinPercent
    )
    local RankedWinsTitle = arg1.RankedWinsTitle
    RankedWinsTitle.Text = if not v12.RankedWins then "win" else if v12.RankedWins == 1 then "win" else "wins"
    arg1.RankedWinsText.Text = StatisticsLibrary_m.Info.StatisticRankedDuelsWon.TostringFunction(
        v12.RankedWins
    )
    arg1.RankedWinPercentText.Text = StatisticsLibrary_m.Info.StatisticRankedDuelsWinPercent.TostringFunction(
        v12.RankedWinPercent
    )
    arg1.LevelText.Text = Utility_m:PrettyNumber(v12.Level)
    arg1.ChallengeButton.Visible = QueuePadController_m:CanChallenge(arg1._last_player_object)
    arg1.InviteButton.Visible = PartyController_m:CanInvitePlayerToParty(arg1._last_player_object)
    WeaponStatusHandler_m:ApplyItemStatusToText(
        arg1.DisplayNameText,
        arg1._last_player_object:GetAttribute("PlayerStatus")
    )
    arg1._rank_icon = RankIcon_m.new(v12.RankedCurrentELO, arg1._last_player_object.UserId)
    arg1._rank_icon:SetParent(arg1.RankContainer)

    for key_1, val_1 in pairs(v12.FavoriteWeapons) do
        local v22 = WeaponSlot_m.new(val_1.Name, val_1)
        v22.Frame.LayoutOrder = key_1
        v22.Frame.Parent = arg1.MostPlayedWeaponsFrame
        table.insert(arg1._weapon_slots, v22)
        v22:DisableButton()
    end

    arg1:_UpdateCooldowns()
    arg1:_UpdateTextBounds()
end

function t.SwitchWinsTab(arg3, arg4) -- line: 160
    -- upvalues:
    --  [1] SeasonController_m (copy)

    local v23 = SeasonController_m:IsRankedUnlocked()
    arg3.WinsButton.Visible = v23
    arg3.RankFrame.Visible = v23
    local v24 = arg4 or not v23
    arg3._wins_tab_is_casual = v24
    v24 = arg3.WinsButtonCasualBackground
    v24.BackgroundTransparency = if not arg3._wins_tab_is_casual then 0.75 else 0
    arg3.CasualFrame.Visible = arg3._wins_tab_is_casual
    local WinsButtonRankedBackground = arg3.WinsButtonRankedBackground
    WinsButtonRankedBackground.BackgroundTransparency = if arg3._wins_tab_is_casual then 0.75 else 0
    arg3.RankedFrame.Visible = not arg3._wins_tab_is_casual
end

function t.Open(arg5, ...) -- line: 177
    -- upvalues:
    --  [1] Page_m (copy)

    Page_m.Open(arg5, ...)
    arg5:SwitchWinsTab(true)
    task.spawn(arg5._SwitchWinsTabLoop, arg5)
end

function t.Close(arg6, ...) -- line: 183
    -- upvalues:
    --  [1] Page_m (copy)

    arg6._wins_tab_hash += 1
    Page_m.Close(arg6, ...)
end

function t._UpdateCooldowns(arg7) -- line: 192
    -- upvalues:
    --  [1] QueuePadController_m (copy)
    --  [2] PartyController_m (copy)

    local LastPlayerObject = arg7._last_player_object
    local v26 = LastPlayerObject
    local ChallengeOnFrame = arg7.ChallengeOnFrame

    if v26 then
        v26 = not QueuePadController_m:IsChallengeRequestOnCooldown(LastPlayerObject)
    end

    ChallengeOnFrame.Visible = v26
    arg7.ChallengeOffFrame.Visible = not arg7.ChallengeOnFrame.Visible
    v26 = LastPlayerObject
    local InviteOnFrame = arg7.InviteOnFrame

    if v26 then
        v26 = not PartyController_m:IsInviteRequestOnCooldown(LastPlayerObject)
    end

    InviteOnFrame.Visible = v26
    arg7.InviteOffFrame.Visible = not arg7.InviteOnFrame.Visible
end

function t._SwitchWinsTabLoop(arg8) -- line: 201
    arg8._wins_tab_hash += 1
    local WinsTabHash = arg8._wins_tab_hash

    while true do
        wait(5)

        if WinsTabHash ~= arg8._wins_tab_hash then
            return
        end

        if not arg8.WinsButton.Visible then
            continue
        end

        arg8:SwitchWinsTab(not arg8._wins_tab_is_casual)
    end
end

function t._UpdateTextBounds(arg9) -- line: 218
    arg9.ControlsIcon.Position = UDim2.new(0, arg9.DisplayNameText.TextBounds.X, 0.5, 0)
end

function t._Init(arg10) -- line: 222
    -- upvalues:
    --  [1] QueuePadController_m (copy)
    --  [2] PartyController_m (copy)
    --  [3] ButtonEffect_m (copy)

    arg10.CloseButton.MouseButton1Click:Connect(function() -- line: 223
        -- upvalues:
        --  [1] arg10 (copy)

        arg10:CloseRequest()
    end)
    arg10.ChallengeButton.MouseButton1Click:Connect(function() -- line: 227
        -- upvalues:
        --  [1] QueuePadController_m (ref)
        --  [2] arg10 (copy)

        QueuePadController_m:SendChallengeRequest(arg10._last_player_object)
    end)
    arg10.InviteButton.MouseButton1Click:Connect(function() -- line: 231
        -- upvalues:
        --  [1] PartyController_m (ref)
        --  [2] arg10 (copy)

        PartyController_m:SendPartyInvite(arg10._last_player_object)
    end)
    arg10.DisplayNameText:GetPropertyChangedSignal("TextBounds"):Connect(function() -- line: 235
        -- upvalues:
        --  [1] arg10 (copy)

        arg10:_UpdateTextBounds()
    end)
    arg10.WinsButton.MouseButton1Click:Connect(function() -- line: 239
        -- upvalues:
        --  [1] arg10 (copy)

        local v27 = arg10
        v27._wins_tab_hash += 1
        arg10:SwitchWinsTab(not arg10._wins_tab_is_casual)
    end)
    QueuePadController_m.ChallengeRequestCooldownChanged:Connect(function() -- line: 244
        -- upvalues:
        --  [1] arg10 (copy)

        arg10:_UpdateCooldowns()
    end)
    PartyController_m.InviteRequestCooldownChanged:Connect(function() -- line: 248
        -- upvalues:
        --  [1] arg10 (copy)

        arg10:_UpdateCooldowns()
    end)
    arg10:_UpdateCooldowns()
    arg10:_UpdateTextBounds()
    arg10:SwitchWinsTab(true)
    ButtonEffect_m:Add(arg10.CloseButton)
    ButtonEffect_m:Add(arg10.ChallengeButton)
    ButtonEffect_m:Add(arg10.InviteButton)
    ButtonEffect_m:Add(arg10.WinsButton)
end

return t._new()
