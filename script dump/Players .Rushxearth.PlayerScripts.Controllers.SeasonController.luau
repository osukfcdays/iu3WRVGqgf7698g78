local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local CONSTANTS_m = require(ReplicatedStorage.Modules.CONSTANTS)
local SeasonLibrary_m = require(ReplicatedStorage.Modules.SeasonLibrary)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local PlayerDataController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.PlayerDataController
)
local t = {}
t.__index = t

function t._new() -- line: 14
    -- upvalues:
    --  [1] t (copy)

    local t_1 = setmetatable({}, t)
    t_1._last_update = -1
    t_1._time_remaining = nil
    t_1:_Init()

    return t_1
end

function t.GetTimeRemaining(arg1) -- line: 29
    if not arg1._time_remaining then
        return nil
    end

    return (math.max(0, (math.ceil(arg1._time_remaining - (tick() - arg1._last_update)))))
end

function t.GetCountdownText(arg2) -- line: 33
    -- upvalues:
    --  [1] Utility_m (copy)
    --  [2] SeasonLibrary_m (copy)

    local v1 = arg2:GetTimeRemaining()

    if not v1 then
        return nil
    end

    local v2 = if not (v1 <= 0) then "in " else ""
    local v3 = if v1 <= 0 then "ANY SECOND NOW" else Utility_m:TimeFormat2((math.ceil(v1)))

    return string.format(
        "Season %s ends %s<font color=\"rgb(255,50,50)\" weight=\"700\">%s</font>",
        SeasonLibrary_m.CurrentSeason.Version,
        v2,
        v3
    )
end

function t.IsRankedUnlocked(_) -- line: 46
    -- upvalues:
    --  [1] PlayerDataController_m (copy)
    --  [2] Players (copy)
    --  [3] CONSTANTS_m (copy)
    --  [4] SeasonLibrary_m (copy)

    local StatisticDuelsWon = PlayerDataController_m:GetStatistic("StatisticDuelsWon")
    local v5 = PlayerDataController_m:Get("Level")
    local AccountAge = Players.LocalPlayer.AccountAge
    local StatisticTasksCompleted = PlayerDataController_m:GetStatistic("StatisticTasksCompleted")

    return if StatisticDuelsWon >= CONSTANTS_m.BEGINNER_QUEUE_WINS then v5 >= SeasonLibrary_m.CurrentSeason.LevelRequirement and AccountAge >= SeasonLibrary_m.CurrentSeason.AccountAgeRequirement and StatisticTasksCompleted >= SeasonLibrary_m.CurrentSeason.TasksCompletedRequirement else false
end

function t._UpdateTimer(arg4, arg5) -- line: 62
    arg4._last_update = tick()
    arg4._time_remaining = arg5
end

function t._Fetch(arg6) -- line: 67
    -- upvalues:
    --  [1] ReplicatedStorage (copy)

    arg6:_UpdateTimer(ReplicatedStorage.Remotes.Misc.RequestSeasonTimer:InvokeServer())
end

function t._Init(arg7) -- line: 71
    -- upvalues:
    --  [1] ReplicatedStorage (copy)

    ReplicatedStorage.Remotes.Misc.UpdateSeasonTimer.OnClientEvent:Connect(function(arguments) -- line: 72
        -- upvalues:
        --  [1] arg7 (copy)

        arg7:_UpdateTimer(arguments)
    end)
    task.defer(arg7._Fetch, arg7)
end

return t._new()
