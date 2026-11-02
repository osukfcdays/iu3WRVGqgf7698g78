local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local StatisticsLibrary_m = require(ReplicatedStorage.Modules.StatisticsLibrary)
local SeasonLibrary_m = require(ReplicatedStorage.Modules.SeasonLibrary)
local _ = require(ReplicatedStorage.Modules.Utility)
local PlayerDataController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.PlayerDataController
)
local EquipmentMetricCard_m = require(Players.LocalPlayer.PlayerScripts.Modules.EquipmentMetricCard)
local UILibrary_m = require(Players.LocalPlayer.PlayerScripts.Modules.UILibrary)
local SecondaryActions_m = require(script:WaitForChild("SecondaryActions"))
local PrimaryActions_m = require(script:WaitForChild("PrimaryActions"))
local LockedActions_m = require(script:WaitForChild("LockedActions"))
local Performance_m = require(script:WaitForChild("Performance"))
local Overview_m = require(script:WaitForChild("Overview"))
local Details_m = require(script:WaitForChild("Details"))
local Level_m = require(script:WaitForChild("Level"))
local udim2 = UDim2.new(1.375, 0, 0.5, 0)
local udim2_1 = UDim2.new(1, 0, 0.5, 0)
local t = {}
t.__index = t

function t.new(arg1) -- line: 25
    -- upvalues:
    --  [1] t (copy)
    --  [2] SecondaryActions_m (copy)
    --  [3] PrimaryActions_m (copy)
    --  [4] LockedActions_m (copy)
    --  [5] Performance_m (copy)
    --  [6] Overview_m (copy)
    --  [7] Details_m (copy)
    --  [8] Level_m (copy)

    local t_1 = setmetatable({}, t)
    t_1.Interface = arg1
    t_1.Frame = t_1.Interface.Frame:WaitForChild("Right")
    t_1.List = t_1.Frame:WaitForChild("List")
    t_1.Container = t_1.List:WaitForChild("Container")
    t_1.Layout = t_1.Container:WaitForChild("Layout")
    t_1.TopBufferFrame = t_1.Container:WaitForChild("TopBuffer")
    t_1.SecondaryActions = SecondaryActions_m.new(t_1)
    t_1.PrimaryActions = PrimaryActions_m.new(t_1)
    t_1.LockedActions = LockedActions_m.new(t_1)
    t_1.Performance = Performance_m.new(t_1)
    t_1.Overview = Overview_m.new(t_1)
    t_1.Details = Details_m.new(t_1)
    t_1.Level = Level_m.new(t_1)
    t_1._is_visible = false
    t_1._last_state = nil
    local t_2 = { Performance = t_1.Performance.MetricCard, Overview = t_1.Overview.MetricCard }
    t_1._metric_cards = t_2
    t_1:_Init()

    return t_1
end

function t.SetVisible(arg2, arg3) -- line: 55
    -- upvalues:
    --  [1] udim2_1 (copy)
    --  [2] udim2 (copy)

    arg2._is_visible = arg3
    arg2.Frame:TweenPosition(
        arg2._is_visible and udim2_1 or udim2,
        "Out",
        "Quint",
        0.25,
        true
    )
end

function t.SetMetricCardVisible(arg4, arg5, arg6) -- line: 60
    arg4._metric_cards[arg5]:SetOpened(arg6)
    arg4.PrimaryActions:SetMetricActionVisible(arg5, not arg6)
    arg4.SecondaryActions:SetMetricActionVisible(arg5, not arg6)
end

function t.ResetMetricCards(arg7) -- line: 66
    for key, _ in pairs(arg7._metric_cards) do
        arg7:SetMetricCardVisible(key, false)
    end
end

function t.ScrollTo(arg8, arg9, arg10) -- line: 72
    -- upvalues:
    --  [1] UILibrary_m (copy)
    --  [2] TweenService (copy)

    task.delay(arg10 or 0, function() -- line: 73
        -- upvalues:
        --  [1] arg8 (copy)
        --  [2] arg9 (copy)
        --  [3] UILibrary_m (ref)
        --  [4] TweenService (ref)

        local minimum = math.min(
            arg8.List.AbsoluteCanvasSize.Y,
            arg9.AbsolutePosition.Y + UILibrary_m.MainGui.AbsolutePosition.Y * 2 - arg8.Container.AbsolutePosition.Y
        )
        local v9 = TweenService
        local List = arg8.List
        local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
        v9:Create(List, tweenInfo, { CanvasPosition = Vector2.new(0, minimum) }):Play()
    end)
end

function t.OnStateChanged(arg11, ...) -- line: 79
    arg11.SecondaryActions:OnStateChanged(...)
    arg11.PrimaryActions:OnStateChanged(...)
    arg11.LockedActions:OnStateChanged(...)
    arg11.Performance:OnStateChanged(...)
    arg11.Overview:OnStateChanged(...)
    arg11.Details:OnStateChanged(...)
    arg11.Level:OnStateChanged(...)
    arg11:_OpenEffect()
end

function t.OnOpen(arg12, ...) -- line: 90
    arg12.SecondaryActions:OnOpen(...)
    arg12.PrimaryActions:OnOpen(...)
    arg12.Performance:OnOpen(...)
    arg12.Overview:OnOpen(...)
end

function t._OpenEffect(arg13) -- line: 101
    -- upvalues:
    --  [1] PlayerDataController_m (copy)
    --  [2] udim2 (copy)

    local v11 = arg13.Interface.Equipment:GetSelectedWeapon()
    local v12 = PlayerDataController_m:GetWeaponData(v11)
    local v13 = v11

    if v13 then
        v13 = not v12
    end

    arg13.List:TweenSize(
        v13 and UDim2.new(1, 0, 1, 0) or UDim2.new(0.7, 0, 1, 0),
        "Out",
        "Quint",
        0.25,
        true
    )
    v13 = arg13.Interface.Equipment:GetStateID()

    if v13 ~= arg13._last_state then
        arg13._last_state = v13
        arg13.Frame.Position = udim2
        arg13:SetVisible(arg13._is_visible)
    end
end

function t._Update(arg14) -- line: 117
    arg14.TopBufferFrame.Size = UDim2.new(
        1,
        0,
        0,
        (math.max(
            arg14.List.AbsoluteSize.Y * 0.375,
            arg14.List.AbsoluteSize.Y - (arg14.Layout.AbsoluteContentSize.Y - arg14.TopBufferFrame.AbsoluteSize.Y)
        ))
    )
    arg14.List.CanvasSize = UDim2.new(0, 0, 0, arg14.Layout.AbsoluteContentSize.Y)
end

function t._SetupPreviousSeasons(arg15) -- line: 122
    -- upvalues:
    --  [1] PlayerDataController_m (copy)
    --  [2] SeasonLibrary_m (copy)
    --  [3] EquipmentMetricCard_m (copy)
    --  [4] StatisticsLibrary_m (copy)

    local v15 = PlayerDataController_m:Get("Seasons")
    local t_4 = {}

    for key_1, _ in pairs(SeasonLibrary_m.Seasons) do
        if v15[key_1] then
            table.insert(t_4, key_1)
        end
    end

    table.sort(t_4, function(arg16, arg17) -- line: 132
        -- upvalues:
        --  [1] SeasonLibrary_m (ref)

        return SeasonLibrary_m.Seasons[arg16].Version < SeasonLibrary_m.Seasons[arg17].Version
    end)

    for _, val_2 in pairs(t_4) do
        local v17 = v15[val_2] and v15[val_2].RankedPerformances and v15[val_2].RankedPerformances[SeasonLibrary_m.UNIVERSAL_ELO_NAME]

        if v17 and not ((v17.DuelsPlayed or 0) <= 0) then
            local v18 = SeasonLibrary_m.Seasons[val_2]
            local v19 = "season_" .. val_2
            local v20 = "Season " .. v18.Version
            local v21 = "The " .. v18.Name .. " Season"
            local v18 = EquipmentMetricCard_m.new(v20, "rbxassetid://117835427046796")
            v18:SetParent(arg15.Container)
            arg15._metric_cards[v19] = v18
            v18.Opened:Connect(function() -- line: 153
                -- upvalues:
                --  [1] arg15 (copy)
                --  [2] v18 (copy)

                arg15:ScrollTo(v18:GetScrollToElement())
            end)
            v18.Clicked:Connect(function() -- line: 157
                -- upvalues:
                --  [1] arg15 (copy)
                --  [2] v19 (copy)

                arg15:SetMetricCardVisible(v19, false)
            end)

            if v17.DuelsPlayed then
                v18:Add(
                    "Duels Played",
                    StatisticsLibrary_m.Info.StatisticRankedDuelsPlayed.TostringFunction(
                        v17.DuelsPlayed
                    )
                )
            end

            if v17.DuelsWon then
                v18:Add(
                    "Duels Won",
                    StatisticsLibrary_m.Info.StatisticRankedDuelsWon.TostringFunction(v17.DuelsWon)
                )
            end

            if v17.DuelsLost then
                v18:Add(
                    "Duels Lost",
                    StatisticsLibrary_m.Info.StatisticRankedDuelsLost.TostringFunction(
                        v17.DuelsLost
                    )
                )
            end

            if v17.DuelsWinPercent then
                v18:Add(
                    "Duels Win %",
                    StatisticsLibrary_m.Info.StatisticRankedDuelsWinPercent.TostringFunction(
                        v17.DuelsWinPercent
                    )
                )
            end

            if v17.CurrentELO then
                v18:Add(
                    "Final ELO",
                    StatisticsLibrary_m.Info.StatisticRankedDuelsPlayed.TostringFunction(
                        v17.CurrentELO
                    )
                )
            end

            if v17.HighestELO then
                v18:Add(
                    "Highest ELO",
                    StatisticsLibrary_m.Info.StatisticRankedDuelsPlayed.TostringFunction(
                        v17.HighestELO
                    )
                )
            end

            if v17.LowestELO then
                v18:Add(
                    "Lowest ELO",
                    StatisticsLibrary_m.Info.StatisticRankedDuelsPlayed.TostringFunction(
                        v17.LowestELO
                    )
                )
            end

            if v17.EndOfSeasonRewardsClaimed then
                v18:AddSeasonRewards(v17.EndOfSeasonRewardsClaimed)
            end

            arg15.SecondaryActions:CreateMetricAction(v19, "rbxassetid://117835427046796", v20, v21)
        end
    end
end

function t._Setup(arg18) -- line: 197
    arg18.Visible = true
end

function t._Init(arg19) -- line: 201
    -- upvalues:
    --  [1] PlayerDataController_m (copy)

    arg19.List:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- line: 202
        -- upvalues:
        --  [1] arg19 (copy)

        arg19:_Update()
    end)
    arg19.Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() -- line: 206
        -- upvalues:
        --  [1] arg19 (copy)

        arg19:_Update()
    end)
    arg19.TopBufferFrame:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- line: 210
        -- upvalues:
        --  [1] arg19 (copy)

        arg19:_Update()
    end)
    arg19.Performance.MetricCard.Opened:Connect(function() -- line: 214
        -- upvalues:
        --  [1] arg19 (copy)

        arg19:ScrollTo(arg19.Performance.MetricCard:GetScrollToElement())
    end)
    arg19.Overview.MetricCard.Opened:Connect(function() -- line: 218
        -- upvalues:
        --  [1] arg19 (copy)

        arg19:ScrollTo(arg19.Overview.MetricCard:GetScrollToElement())
    end)
    PlayerDataController_m:GetDataChangedSignal("WeaponInventory"):Connect(function() -- line: 222
        -- upvalues:
        --  [1] arg19 (copy)

        arg19:_OpenEffect()
    end)
    arg19:_Setup()
    arg19:_SetupPreviousSeasons()
    arg19:_Update()
end

return t
