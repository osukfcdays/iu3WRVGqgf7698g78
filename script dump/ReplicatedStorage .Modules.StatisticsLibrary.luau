local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CONSTANTS_m = require(ReplicatedStorage.Modules.CONSTANTS)
local DuelLibrary_m = require(ReplicatedStorage.Modules.DuelLibrary)
local ShopLibrary_m = require(ReplicatedStorage.Modules.ShopLibrary)
local ItemLibrary_m = require(ReplicatedStorage.Modules.ItemLibrary)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local t = { Info = {}, Order = {}, Items = {}, Maps = {}, CareerStatistics = {} }
t.STATISTICS_DIRECTORY_INFO = { { "WeaponStatistics", t.Items }, { "MapStatistics", t.Maps } }

function t.GetStatisticsDirectoryInfo(arg1, arg2) -- line: 20
    for key, val in pairs(arg1.STATISTICS_DIRECTORY_INFO) do
        local v1, _ = table.unpack(val)

        if v1 == arg2 then
            return val, key
        end
    end
end

function t.GetPercent(_, arg4, arg5) -- line: 30
    if arg4 == 0 then
        return -1
    end

    return arg5 / arg4
end

function t.GetCareerStatistics(_, arg7) -- line: 34
    -- upvalues:
    --  [1] t (copy)

    local t_4 = {}
    local t_5 = {}
    local t_6 = {}

    for key_1, val_1 in pairs(t.Items) do
        for _, val_2 in pairs(val_1.DataNames) do
            t_5[val_2] = true
            local v3 = t_4[val_2] or arg7[key_1] or nil
            t_4[val_2] = v3
        end
    end

    for key_3, _ in pairs(t.Info) do
        if not t_5[key_3] then
            t_6[key_3] = true
        end
    end

    local t_7 = {}

    for key_4, _ in pairs(t_4) do
        table.insert(t_7, key_4)
    end

    for key_5, _ in pairs(t_6) do
        table.insert(t_7, key_5)
    end

    for index = #t_7, 1, -1 do
        if not t.Info[t_7[index]].IsCareerStatistic then
            table.remove(t_7, index)
        end
    end

    table.sort(t_7, function(arg8, arg9) -- line: 72
        -- upvalues:
        --  [1] t (ref)

        return t.Info[arg8].Index < t.Info[arg9].Index
    end)

    return t_7
end

local function pretty_number_tostring(arg10) -- line: 80
    -- upvalues:
    --  [1] Utility_m (copy)

    return Utility_m:PrettyNumber((math.floor(arg10 + 0.5)))
end

function ReplicatedStorage(arg11) --[[ percent_tostring ]] -- line: 84
    if arg11 == -1 then
        return "N/A"
    end

    return math.floor(arg11 * 1000) / 10 .. "%"
end

local function playtime_tostring(arg12) -- line: 88
    -- upvalues:
    --  [1] Utility_m (copy)

    return Utility_m:TimeFormat2(arg12 < 60 and arg12 or math.floor(arg12 / 60) * 60, nil, true)
end

local function playtime_precise_tostring(arg13) -- line: 92
    return string.format("%.3f", arg13) .. "s"
end

local function raw_value(arg14) -- line: 96
    return arg14
end

local function date_tostring(arg15) -- line: 100
    return arg15 and arg15 > 0 and DateTime.fromUnixTimestamp(arg15):FormatLocalTime("ll", "en-us") or "???"
end

local _ = function(
    arg16,
    arg17,
    arg18,
    arg19,
    arg20,
    arg21,
    arg22,
    arg23,
    arg24
) --[[ add_statistic ]] -- line: 104
    -- upvalues:
    --  [1] t (copy)
    --  [2] pretty_number_tostring (copy)

    local v9 = if arg20 == true then nil else arg20 and "Statistic" .. arg20 or nil
    local v10 = v9 and t.Info[v9]
    local v11 = arg20 == true
    local v12 = arg22 or 0
    local t_8 = {
        Index = #t.Order + 1,
        IsCareerStatistic = arg16,
        OnlyDisplayAboveZero = arg17,
        DataName = "Statistic" .. arg18,
        DisplayName = arg19,
        FullDisplayName = nil,
        IsStatisticFolder = nil,
        ParentDataName = nil,
        DefaultValue = nil,
        ValueType = nil,
        TostringFunction = nil,
        Image = nil
    }
    local v13 = arg23

    if not v13 then
        v13 = (v10 and v10.FullDisplayName .. " " or "") .. arg19
    end

    t_8.FullDisplayName = v13
    t_8.IsStatisticFolder = v11
    t_8.ParentDataName = v9
    t_8.DefaultValue = v12
    t_8.ValueType = typeof(v12)
    v13 = arg24 or pretty_number_tostring
    t_8.TostringFunction = v13
    v13 = arg21 or v10 and v10.Image or ""
    t_8.Image = v13
    t.Info[t_8.DataName] = t_8
    table.insert(t.Order, t_8.DataName)
end

local t_9 = {
    Index = #t.Order + 1,
    IsCareerStatistic = true,
    OnlyDisplayAboveZero = nil,
    DataName = "StatisticJoinedTime",
    DisplayName = "Joined",
    FullDisplayName = "Joined",
    IsStatisticFolder = false,
    ParentDataName = nil,
    DefaultValue = -1,
    ValueType = "number",
    TostringFunction = date_tostring or pretty_number_tostring,
    Image = ""
}
t.Info[t_9.DataName] = t_9
table.insert(t.Order, t_9.DataName)
date_tostring = {
    Index = #t.Order + 1,
    IsCareerStatistic = true,
    OnlyDisplayAboveZero = nil,
    DataName = "StatisticPlaytime",
    DisplayName = "Playtime",
    FullDisplayName = "Playtime",
    IsStatisticFolder = false,
    ParentDataName = nil,
    DefaultValue = 0,
    ValueType = "number",
    TostringFunction = playtime_tostring or pretty_number_tostring,
    Image = "rbxassetid://17156089790"
}
t.Info[date_tostring.DataName] = date_tostring
table.insert(t.Order, date_tostring.DataName)
date_tostring = t.Info.StatisticPlaytime
t_9 = {
    Index = #t.Order + 1,
    IsCareerStatistic = nil,
    OnlyDisplayAboveZero = nil,
    DataName = "StatisticPlaytimeUnequipped",
    DisplayName = "while unequipped",
    FullDisplayName = nil,
    IsStatisticFolder = false,
    ParentDataName = "StatisticPlaytime",
    DefaultValue = 0,
    ValueType = "number",
    TostringFunction = nil,
    Image = nil
}
local v15 = date_tostring and date_tostring.FullDisplayName .. " " or ""
t_9.FullDisplayName = v15 .. "while unequipped"
t_9.TostringFunction = playtime_tostring or pretty_number_tostring
t_9.Image = date_tostring and date_tostring.Image or ""
t.Info[t_9.DataName] = t_9
table.insert(t.Order, t_9.DataName)
playtime_tostring = {
    Index = #t.Order + 1,
    IsCareerStatistic = true,
    OnlyDisplayAboveZero = nil,
    DataName = "StatisticTasksCompleted",
    DisplayName = "Tasks Completed",
    FullDisplayName = "Tasks Completed",
    IsStatisticFolder = false,
    ParentDataName = nil,
    DefaultValue = 0,
    ValueType = "number",
    TostringFunction = pretty_number_tostring,
    Image = ""
}
t.Info[playtime_tostring.DataName] = playtime_tostring
table.insert(t.Order, playtime_tostring.DataName)
playtime_tostring = {
    Index = #t.Order + 1,
    IsCareerStatistic = true,
    OnlyDisplayAboveZero = nil,
    DataName = "StatisticContractsCompleted",
    DisplayName = "Contracts Completed",
    FullDisplayName = "Contracts Completed",
    IsStatisticFolder = false,
    ParentDataName = nil,
    DefaultValue = 0,
    ValueType = "number",
    TostringFunction = pretty_number_tostring,
    Image = ""
}
t.Info[playtime_tostring.DataName] = playtime_tostring
table.insert(t.Order, playtime_tostring.DataName)
playtime_tostring = {
    Index = #t.Order + 1,
    IsCareerStatistic = true,
    OnlyDisplayAboveZero = nil,
    DataName = "StatisticFavoriteWeapon",
    DisplayName = "Most Played Weapon",
    FullDisplayName = "Most Played Weapon",
    IsStatisticFolder = false,
    ParentDataName = nil,
    DefaultValue = "N/A",
    ValueType = "string",
    TostringFunction = raw_value or pretty_number_tostring,
    Image = ""
}
t.Info[playtime_tostring.DataName] = playtime_tostring
table.insert(t.Order, playtime_tostring.DataName)
playtime_tostring = t.Info.StatisticFavoriteWeapon
date_tostring = {
    Index = #t.Order + 1,
    IsCareerStatistic = true,
    OnlyDisplayAboveZero = nil,
    DataName = "StatisticFavoriteWeaponPrimary",
    DisplayName = "primary",
    FullDisplayName = nil,
    IsStatisticFolder = false,
    ParentDataName = "StatisticFavoriteWeapon",
    DefaultValue = "N/A",
    ValueType = "string",
    TostringFunction = nil,
    Image = nil
}
t_9 = playtime_tostring and playtime_tostring.FullDisplayName .. " " or ""
date_tostring.FullDisplayName = t_9 .. "primary"
date_tostring.TostringFunction = raw_value or pretty_number_tostring
date_tostring.Image = playtime_tostring and playtime_tostring.Image or ""
t.Info[date_tostring.DataName] = date_tostring
table.insert(t.Order, date_tostring.DataName)
playtime_tostring = t.Info.StatisticFavoriteWeapon
date_tostring = {
    Index = #t.Order + 1,
    IsCareerStatistic = true,
    OnlyDisplayAboveZero = nil,
    DataName = "StatisticFavoriteWeaponSecondary",
    DisplayName = "secondary",
    FullDisplayName = nil,
    IsStatisticFolder = false,
    ParentDataName = "StatisticFavoriteWeapon",
    DefaultValue = "N/A",
    ValueType = "string",
    TostringFunction = nil,
    Image = nil
}
t_9 = playtime_tostring and playtime_tostring.FullDisplayName .. " " or ""
date_tostring.FullDisplayName = t_9 .. "secondary"
date_tostring.TostringFunction = raw_value or pretty_number_tostring
date_tostring.Image = playtime_tostring and playtime_tostring.Image or ""
t.Info[date_tostring.DataName] = date_tostring
table.insert(t.Order, date_tostring.DataName)
playtime_tostring = t.Info.StatisticFavoriteWeapon
date_tostring = {
    Index = #t.Order + 1,
    IsCareerStatistic = true,
    OnlyDisplayAboveZero = nil,
    DataName = "StatisticFavoriteWeaponMelee",
    DisplayName = "melee",
    FullDisplayName = nil,
    IsStatisticFolder = false,
    ParentDataName = "StatisticFavoriteWeapon",
    DefaultValue = "N/A",
    ValueType = "string",
    TostringFunction = nil,
    Image = nil
}
t_9 = playtime_tostring and playtime_tostring.FullDisplayName .. " " or ""
date_tostring.FullDisplayName = t_9 .. "melee"
date_tostring.TostringFunction = raw_value or pretty_number_tostring
date_tostring.Image = playtime_tostring and playtime_tostring.Image or ""
t.Info[date_tostring.DataName] = date_tostring
table.insert(t.Order, date_tostring.DataName)
playtime_tostring = t.Info.StatisticFavoriteWeapon
date_tostring = {
    Index = #t.Order + 1,
    IsCareerStatistic = true,
    OnlyDisplayAboveZero = nil,
    DataName = "StatisticFavoriteWeaponUtility",
    DisplayName = "utility",
    FullDisplayName = nil,
    IsStatisticFolder = false,
    ParentDataName = "StatisticFavoriteWeapon",
    DefaultValue = "N/A",
    ValueType = "string",
    TostringFunction = nil,
    Image = nil
}
t_9 = playtime_tostring and playtime_tostring.FullDisplayName .. " " or ""
date_tostring.FullDisplayName = t_9 .. "utility"
date_tostring.TostringFunction = raw_value or pretty_number_tostring
date_tostring.Image = playtime_tostring and playtime_tostring.Image or ""
t.Info[date_tostring.DataName] = date_tostring
table.insert(t.Order, date_tostring.DataName)
playtime_tostring = {
    Index = #t.Order + 1,
    IsCareerStatistic = true,
    OnlyDisplayAboveZero = nil,
    DataName = "StatisticFavoriteMap",
    DisplayName = "Most Played Map",
    FullDisplayName = "Most Played Map",
    IsStatisticFolder = false,
    ParentDataName = nil,
    DefaultValue = "N/A",
    ValueType = "string",
    TostringFunction = raw_value or pretty_number_tostring,
    Image = ""
}
t.Info[playtime_tostring.DataName] = playtime_tostring
table.insert(t.Order, playtime_tostring.DataName)
playtime_tostring = t.Info.StatisticFavoriteMap
date_tostring = {
    Index = #t.Order + 1,
    IsCareerStatistic = true,
    OnlyDisplayAboveZero = nil,
    DataName = "StatisticFavoriteMap2",
    DisplayName = "2nd",
    FullDisplayName = nil,
    IsStatisticFolder = false,
    ParentDataName = "StatisticFavoriteMap",
    DefaultValue = "N/A",
    ValueType = "string",
    TostringFunction = nil,
    Image = nil
}
t_9 = playtime_tostring and playtime_tostring.FullDisplayName .. " " or ""
date_tostring.FullDisplayName = t_9 .. "2nd"
date_tostring.TostringFunction = raw_value or pretty_number_tostring
date_tostring.Image = playtime_tostring and playtime_tostring.Image or ""
t.Info[date_tostring.DataName] = date_tostring
table.insert(t.Order, date_tostring.DataName)
playtime_tostring = t.Info.StatisticFavoriteMap
date_tostring = {
    Index = #t.Order + 1,
    IsCareerStatistic = true,
    OnlyDisplayAboveZero = nil,
    DataName = "StatisticFavoriteMap3",
    DisplayName = "3rd",
    FullDisplayName = nil,
    IsStatisticFolder = false,
    ParentDataName = "StatisticFavoriteMap",
    DefaultValue = "N/A",
    ValueType = "string",
    TostringFunction = nil,
    Image = nil
}
t_9 = playtime_tostring and playtime_tostring.FullDisplayName .. " " or ""
date_tostring.FullDisplayName = t_9 .. "3rd"
date_tostring.TostringFunction = raw_value or pretty_number_tostring
date_tostring.Image = playtime_tostring and playtime_tostring.Image or ""
t.Info[date_tostring.DataName] = date_tostring
table.insert(t.Order, date_tostring.DataName)
playtime_tostring = t.Info.StatisticFavoriteMap
date_tostring = {
    Index = #t.Order + 1,
    IsCareerStatistic = true,
    OnlyDisplayAboveZero = nil,
    DataName = "StatisticFavoriteMap4",
    DisplayName = "4th",
    FullDisplayName = nil,
    IsStatisticFolder = false,
    ParentDataName = "StatisticFavoriteMap",
    DefaultValue = "N/A",
    ValueType = "string",
    TostringFunction = nil,
    Image = nil
}
t_9 = playtime_tostring and playtime_tostring.FullDisplayName .. " " or ""
date_tostring.FullDisplayName = t_9 .. "4th"
date_tostring.TostringFunction = raw_value or pretty_number_tostring
date_tostring.Image = playtime_tostring and playtime_tostring.Image or ""
t.Info[date_tostring.DataName] = date_tostring
table.insert(t.Order, date_tostring.DataName)
playtime_tostring = {
    Index = #t.Order + 1,
    IsCareerStatistic = true,
    OnlyDisplayAboveZero = nil,
    DataName = "StatisticDuelsPlayed",
    DisplayName = "Duels Played",
    FullDisplayName = "Duels Played",
    IsStatisticFolder = false,
    ParentDataName = nil,
    DefaultValue = 0,
    ValueType = "number",
    TostringFunction = pretty_number_tostring,
    Image = ""
}
t.Info[playtime_tostring.DataName] = playtime_tostring
table.insert(t.Order, playtime_tostring.DataName)
playtime_tostring = t.Info.StatisticDuelsPlayed
raw_value = {
    Index = #t.Order + 1,
    IsCareerStatistic = true,
    OnlyDisplayAboveZero = nil,
    DataName = "StatisticDuelsWon",
    DisplayName = "wins",
    FullDisplayName = nil,
    IsStatisticFolder = false,
    ParentDataName = "StatisticDuelsPlayed",
    DefaultValue = 0,
    ValueType = "number",
    TostringFunction = nil,
    Image = nil
}
date_tostring = playtime_tostring and playtime_tostring.FullDisplayName .. " " or ""
raw_value.FullDisplayName = date_tostring .. "wins"
raw_value.TostringFunction = pretty_number_tostring
raw_value.Image = playtime_tostring and playtime_tostring.Image or ""
t.Info[raw_value.DataName] = raw_value
table.insert(t.Order, raw_value.DataName)
playtime_tostring = t.Info.StatisticDuelsPlayed
raw_value = {
    Index = #t.Order + 1,
    IsCareerStatistic = true,
    OnlyDisplayAboveZero = nil,
    DataName = "StatisticDuelsLost",
    DisplayName = "losses",
    FullDisplayName = nil,
    IsStatisticFolder = false,
    ParentDataName = "StatisticDuelsPlayed",
    DefaultValue = 0,
    ValueType = "number",
    TostringFunction = nil,
    Image = nil
}
date_tostring = playtime_tostring and playtime_tostring.FullDisplayName .. " " or ""
raw_value.FullDisplayName = date_tostring .. "losses"
raw_value.TostringFunction = pretty_number_tostring
raw_value.Image = playtime_tostring and playtime_tostring.Image or ""
t.Info[raw_value.DataName] = raw_value
table.insert(t.Order, raw_value.DataName)
playtime_tostring = t.Info.StatisticDuelsPlayed
raw_value = {
    Index = #t.Order + 1,
    IsCareerStatistic = true,
    OnlyDisplayAboveZero = nil,
    DataName = "StatisticDuelsWinPercent",
    DisplayName = "win %",
    FullDisplayName = nil,
    IsStatisticFolder = false,
    ParentDataName = "StatisticDuelsPlayed",
    DefaultValue = -1,
    ValueType = "number",
    TostringFunction = nil,
    Image = nil
}
date_tostring = playtime_tostring and playtime_tostring.FullDisplayName .. " " or ""
raw_value.FullDisplayName = date_tostring .. "win %"
raw_value.TostringFunction = ReplicatedStorage or pretty_number_tostring
raw_value.Image = playtime_tostring and playtime_tostring.Image or ""
t.Info[raw_value.DataName] = raw_value
table.insert(t.Order, raw_value.DataName)
playtime_tostring = t.Info.StatisticDuelsPlayed
raw_value = {
    Index = #t.Order + 1,
    IsCareerStatistic = true,
    OnlyDisplayAboveZero = nil,
    DataName = "StatisticDuelsWonFlawless",
    DisplayName = "flawless wins",
    FullDisplayName = nil,
    IsStatisticFolder = false,
    ParentDataName = "StatisticDuelsPlayed",
    DefaultValue = 0,
    ValueType = "number",
    TostringFunction = nil,
    Image = nil
}
date_tostring = playtime_tostring and playtime_tostring.FullDisplayName .. " " or ""
raw_value.FullDisplayName = date_tostring .. "flawless wins"
raw_value.TostringFunction = pretty_number_tostring
raw_value.Image = playtime_tostring and playtime_tostring.Image or ""
t.Info[raw_value.DataName] = raw_value
table.insert(t.Order, raw_value.DataName)
playtime_tostring = t.Info.StatisticDuelsPlayed
raw_value = {
    Index = #t.Order + 1,
    IsCareerStatistic = true,
    OnlyDisplayAboveZero = nil,
    DataName = "StatisticDuelsLostFlawless",
    DisplayName = "flawless losses",
    FullDisplayName = nil,
    IsStatisticFolder = false,
    ParentDataName = "StatisticDuelsPlayed",
    DefaultValue = 0,
    ValueType = "number",
    TostringFunction = nil,
    Image = nil
}
date_tostring = playtime_tostring and playtime_tostring.FullDisplayName .. " " or ""
raw_value.FullDisplayName = date_tostring .. "flawless losses"
raw_value.TostringFunction = pretty_number_tostring
raw_value.Image = playtime_tostring and playtime_tostring.Image or ""
t.Info[raw_value.DataName] = raw_value
table.insert(t.Order, raw_value.DataName)
playtime_tostring = t.Info.StatisticDuelsPlayed
raw_value = {
    Index = #t.Order + 1,
    IsCareerStatistic = true,
    OnlyDisplayAboveZero = nil,
    DataName = "StatisticDuelsWonSuddenDeath",
    DisplayName = "sudden death wins",
    FullDisplayName = nil,
    IsStatisticFolder = false,
    ParentDataName = "StatisticDuelsPlayed",
    DefaultValue = 0,
    ValueType = "number",
    TostringFunction = nil,
    Image = nil
}
date_tostring = playtime_tostring and playtime_tostring.FullDisplayName .. " " or ""
raw_value.FullDisplayName = date_tostring .. "sudden death wins"
raw_value.TostringFunction = pretty_number_tostring
raw_value.Image = playtime_tostring and playtime_tostring.Image or ""
t.Info[raw_value.DataName] = raw_value
table.insert(t.Order, raw_value.DataName)
playtime_tostring = t.Info.StatisticDuelsPlayed
raw_value = {
    Index = #t.Order + 1,
    IsCareerStatistic = true,
    OnlyDisplayAboveZero = nil,
    DataName = "StatisticDuelsLostSuddenDeath",
    DisplayName = "sudden death losses",
    FullDisplayName = nil,
    IsStatisticFolder = false,
    ParentDataName = "StatisticDuelsPlayed",
    DefaultValue = 0,
    ValueType = "number",
    TostringFunction = nil,
    Image = nil
}
date_tostring = playtime_tostring and playtime_tostring.FullDisplayName .. " " or ""
raw_value.FullDisplayName = date_tostring .. "sudden death losses"
raw_value.TostringFunction = pretty_number_tostring
raw_value.Image = playtime_tostring and playtime_tostring.Image or ""
t.Info[raw_value.DataName] = raw_value
table.insert(t.Order, raw_value.DataName)
playtime_tostring = t.Info.StatisticDuelsPlayed
raw_value = {
    Index = #t.Order + 1,
    IsCareerStatistic = true,
    OnlyDisplayAboveZero = nil,
    DataName = "StatisticDuelsWinStreak",
    DisplayName = "current win streak",
    FullDisplayName = nil,
    IsStatisticFolder = false,
    ParentDataName = "StatisticDuelsPlayed",
    DefaultValue = 0,
    ValueType = "number",
    TostringFunction = nil,
    Image = nil
}
date_tostring = playtime_tostring and playtime_tostring.FullDisplayName .. " " or ""
raw_value.FullDisplayName = date_tostring .. "current win streak"
raw_value.TostringFunction = pretty_number_tostring
raw_value.Image = playtime_tostring and playtime_tostring.Image or ""
t.Info[raw_value.DataName] = raw_value
table.insert(t.Order, raw_value.DataName)
playtime_tostring = t.Info.StatisticDuelsPlayed
raw_value = {
    Index = #t.Order + 1,
    IsCareerStatistic = true,
    OnlyDisplayAboveZero = nil,
    DataName = "StatisticDuelsWinStreakHighest",
    DisplayName = "highest ever win streak",
    FullDisplayName = nil,
    IsStatisticFolder = false,
    ParentDataName = "StatisticDuelsPlayed",
    DefaultValue = 0,
    ValueType = "number",
    TostringFunction = nil,
    Image = nil
}
date_tostring = playtime_tostring and playtime_tostring.FullDisplayName .. " " or ""
raw_value.FullDisplayName = date_tostring .. "highest ever win streak"
raw_value.TostringFunction = pretty_number_tostring
raw_value.Image = playtime_tostring and playtime_tostring.Image or ""
t.Info[raw_value.DataName] = raw_value
table.insert(t.Order, raw_value.DataName)
playtime_tostring = t.Info.StatisticDuelsPlayed
raw_value = {
    Index = #t.Order + 1,
    IsCareerStatistic = true,
    OnlyDisplayAboveZero = nil,
    DataName = "StatisticDuelsWinStreaksTaken",
    DisplayName = "highest win streak ended",
    FullDisplayName = nil,
    IsStatisticFolder = false,
    ParentDataName = "StatisticDuelsPlayed",
    DefaultValue = 0,
    ValueType = "number",
    TostringFunction = nil,
    Image = nil
}
date_tostring = playtime_tostring and playtime_tostring.FullDisplayName .. " " or ""
raw_value.FullDisplayName = date_tostring .. "highest win streak ended"
raw_value.TostringFunction = pretty_number_tostring
raw_value.Image = playtime_tostring and playtime_tostring.Image or ""
t.Info[raw_value.DataName] = raw_value
table.insert(t.Order, raw_value.DataName)
playtime_tostring = t.Info.StatisticDuelsPlayed
raw_value = {
    Index = #t.Order + 1,
    IsCareerStatistic = true,
    OnlyDisplayAboveZero = nil,
    DataName = "StatisticDuelsWinStreaksTakenTotal",
    DisplayName = "total win streaks ended",
    FullDisplayName = nil,
    IsStatisticFolder = false,
    ParentDataName = "StatisticDuelsPlayed",
    DefaultValue = 0,
    ValueType = "number",
    TostringFunction = nil,
    Image = nil
}
date_tostring = playtime_tostring and playtime_tostring.FullDisplayName .. " " or ""
raw_value.FullDisplayName = date_tostring .. "total win streaks ended"
raw_value.TostringFunction = pretty_number_tostring
raw_value.Image = playtime_tostring and playtime_tostring.Image or ""
t.Info[raw_value.DataName] = raw_value
table.insert(t.Order, raw_value.DataName)
playtime_tostring = t.Info.StatisticDuelsPlayed
raw_value = {
    Index = #t.Order + 1,
    IsCareerStatistic = true,
    OnlyDisplayAboveZero = nil,
    DataName = "StatisticDuelsMVPs",
    DisplayName = "MVPs",
    FullDisplayName = nil,
    IsStatisticFolder = false,
    ParentDataName = "StatisticDuelsPlayed",
    DefaultValue = 0,
    ValueType = "number",
    TostringFunction = nil,
    Image = nil
}
date_tostring = playtime_tostring and playtime_tostring.FullDisplayName .. " " or ""
raw_value.FullDisplayName = date_tostring .. "MVPs"
raw_value.TostringFunction = pretty_number_tostring
raw_value.Image = playtime_tostring and playtime_tostring.Image or ""
t.Info[raw_value.DataName] = raw_value
table.insert(t.Order, raw_value.DataName)
playtime_tostring = {
    Index = #t.Order + 1,
    IsCareerStatistic = true,
    OnlyDisplayAboveZero = nil,
    DataName = "StatisticRoundsPlayed",
    DisplayName = "Rounds Played",
    FullDisplayName = "Rounds Played",
    IsStatisticFolder = false,
    ParentDataName = nil,
    DefaultValue = 0,
    ValueType = "number",
    TostringFunction = pretty_number_tostring,
    Image = ""
}
t.Info[playtime_tostring.DataName] = playtime_tostring
table.insert(t.Order, playtime_tostring.DataName)
_ = t.Info.StatisticRoundsPlayed
playtime_tostring = {
    Index = #t.Order + 1,
    IsCareerStatistic = true,
    OnlyDisplayAboveZero = nil,
    DataName = "StatisticRoundsWon",
    DisplayName = "wins",
    FullDisplayName = "Rounds Won",
    IsStatisticFolder = false,
    ParentDataName = "StatisticRoundsPlayed",
    DefaultValue = 0,
    ValueType = "number",
    TostringFunction = pretty_number_tostring,
    Image = "rbxassetid://100786023219923"
}
t.Info[playtime_tostring.DataName] = playtime_tostring
table.insert(t.Order, playtime_tostring.DataName)
playtime_tostring = t.Info.StatisticRoundsPlayed
raw_value = {
    Index = #t.Order + 1,
    IsCareerStatistic = true,
    OnlyDisplayAboveZero = nil,
    DataName = "StatisticRoundsLost",
    DisplayName = "losses",
    FullDisplayName = nil,
    IsStatisticFolder = false,
    ParentDataName = "StatisticRoundsPlayed",
    DefaultValue = 0,
    ValueType = "number",
    TostringFunction = nil,
    Image = nil
}
date_tostring = playtime_tostring and playtime_tostring.FullDisplayName .. " " or ""
raw_value.FullDisplayName = date_tostring .. "losses"
raw_value.TostringFunction = pretty_number_tostring
raw_value.Image = playtime_tostring and playtime_tostring.Image or ""
t.Info[raw_value.DataName] = raw_value
table.insert(t.Order, raw_value.DataName)
playtime_tostring = t.Info.StatisticRoundsPlayed
raw_value = {
    Index = #t.Order + 1,
    IsCareerStatistic = true,
    OnlyDisplayAboveZero = nil,
    DataName = "StatisticRoundsWinPercent",
    DisplayName = "win %",
    FullDisplayName = nil,
    IsStatisticFolder = false,
    ParentDataName = "StatisticRoundsPlayed",
    DefaultValue = -1,
    ValueType = "number",
    TostringFunction = nil,
    Image = nil
}
date_tostring = playtime_tostring and playtime_tostring.FullDisplayName .. " " or ""
raw_value.FullDisplayName = date_tostring .. "win %"
raw_value.TostringFunction = ReplicatedStorage or pretty_number_tostring
raw_value.Image = playtime_tostring and playtime_tostring.Image or ""
t.Info[raw_value.DataName] = raw_value
table.insert(t.Order, raw_value.DataName)
playtime_tostring = {
    Index = #t.Order + 1,
    IsCareerStatistic = true,
    OnlyDisplayAboveZero = nil,
    DataName = "StatisticRankedDuelsPlayed",
    DisplayName = "Ranked Duels Played",
    FullDisplayName = "Ranked Duels Played",
    IsStatisticFolder = false,
    ParentDataName = nil,
    DefaultValue = 0,
    ValueType = "number",
    TostringFunction = pretty_number_tostring,
    Image = ""
}
t.Info[playtime_tostring.DataName] = playtime_tostring
table.insert(t.Order, playtime_tostring.DataName)
playtime_tostring = t.Info.StatisticRankedDuelsPlayed
raw_value = {
    Index = #t.Order + 1,
    IsCareerStatistic = true,
    OnlyDisplayAboveZero = nil,
    DataName = "StatisticRankedDuelsWon",
    DisplayName = "ranked wins",
    FullDisplayName = nil,
    IsStatisticFolder = false,
    ParentDataName = "StatisticRankedDuelsPlayed",
    DefaultValue = 0,
    ValueType = "number",
    TostringFunction = nil,
    Image = nil
}
date_tostring = playtime_tostring and playtime_tostring.FullDisplayName .. " " or ""
raw_value.FullDisplayName = date_tostring .. "ranked wins"
raw_value.TostringFunction = pretty_number_tostring
raw_value.Image = playtime_tostring and playtime_tostring.Image or ""
t.Info[raw_value.DataName] = raw_value
table.insert(t.Order, raw_value.DataName)
playtime_tostring = t.Info.StatisticRankedDuelsPlayed
raw_value = {
    Index = #t.Order + 1,
    IsCareerStatistic = true,
    OnlyDisplayAboveZero = nil,
    DataName = "StatisticRankedDuelsLost",
    DisplayName = "ranked losses",
    FullDisplayName = nil,
    IsStatisticFolder = false,
    ParentDataName = "StatisticRankedDuelsPlayed",
    DefaultValue = 0,
    ValueType = "number",
    TostringFunction = nil,
    Image = nil
}
date_tostring = playtime_tostring and playtime_tostring.FullDisplayName .. " " or ""
raw_value.FullDisplayName = date_tostring .. "ranked losses"
raw_value.TostringFunction = pretty_number_tostring
raw_value.Image = playtime_tostring and playtime_tostring.Image or ""
t.Info[raw_value.DataName] = raw_value
table.insert(t.Order, raw_value.DataName)
playtime_tostring = t.Info.StatisticRankedDuelsPlayed
raw_value = {
    Index = #t.Order + 1,
    IsCareerStatistic = true,
    OnlyDisplayAboveZero = nil,
    DataName = "StatisticRankedDuelsWinPercent",
    DisplayName = "ranked win %",
    FullDisplayName = nil,
    IsStatisticFolder = false,
    ParentDataName = "StatisticRankedDuelsPlayed",
    DefaultValue = -1,
    ValueType = "number",
    TostringFunction = nil,
    Image = nil
}
date_tostring = playtime_tostring and playtime_tostring.FullDisplayName .. " " or ""
raw_value.FullDisplayName = date_tostring .. "ranked win %"
raw_value.TostringFunction = ReplicatedStorage or pretty_number_tostring
raw_value.Image = playtime_tostring and playtime_tostring.Image or ""
t.Info[raw_value.DataName] = raw_value
table.insert(t.Order, raw_value.DataName)
playtime_tostring = {
    Index = #t.Order + 1,
    IsCareerStatistic = true,
    OnlyDisplayAboveZero = nil,
    DataName = "StatisticRankedRoundsPlayed",
    DisplayName = "Ranked Rounds Played",
    FullDisplayName = "Ranked Rounds Played",
    IsStatisticFolder = false,
    ParentDataName = nil,
    DefaultValue = 0,
    ValueType = "number",
    TostringFunction = pretty_number_tostring,
    Image = ""
}
t.Info[playtime_tostring.DataName] = playtime_tostring
table.insert(t.Order, playtime_tostring.DataName)
playtime_tostring = t.Info.StatisticRankedRoundsPlayed
raw_value = {
    Index = #t.Order + 1,
    IsCareerStatistic = true,
    OnlyDisplayAboveZero = nil,
    DataName = "StatisticRankedRoundsWon",
    DisplayName = "ranked wins",
    FullDisplayName = "Ranked Rounds Won",
    IsStatisticFolder = false,
    ParentDataName = "StatisticRankedRoundsPlayed",
    DefaultValue = 0,
    ValueType = "number",
    TostringFunction = pretty_number_tostring,
    Image = playtime_tostring and playtime_tostring.Image or ""
}
t.Info[raw_value.DataName] = raw_value
table.insert(t.Order, raw_value.DataName)
playtime_tostring = t.Info.StatisticRankedRoundsPlayed
raw_value = {
    Index = #t.Order + 1,
    IsCareerStatistic = true,
    OnlyDisplayAboveZero = nil,
    DataName = "StatisticRankedRoundsLost",
    DisplayName = "ranked losses",
    FullDisplayName = nil,
    IsStatisticFolder = false,
    ParentDataName = "StatisticRankedRoundsPlayed",
    DefaultValue = 0,
    ValueType = "number",
    TostringFunction = nil,
    Image = nil
}
date_tostring = playtime_tostring and playtime_tostring.FullDisplayName .. " " or ""
raw_value.FullDisplayName = date_tostring .. "ranked losses"
raw_value.TostringFunction = pretty_number_tostring
raw_value.Image = playtime_tostring and playtime_tostring.Image or ""
t.Info[raw_value.DataName] = raw_value
table.insert(t.Order, raw_value.DataName)
playtime_tostring = t.Info.StatisticRankedRoundsPlayed
raw_value = {
    Index = #t.Order + 1,
    IsCareerStatistic = true,
    OnlyDisplayAboveZero = nil,
    DataName = "StatisticRankedRoundsWinPercent",
    DisplayName = "ranked win %",
    FullDisplayName = nil,
    IsStatisticFolder = false,
    ParentDataName = "StatisticRankedRoundsPlayed",
    DefaultValue = -1,
    ValueType = "number",
    TostringFunction = nil,
    Image = nil
}
date_tostring = playtime_tostring and playtime_tostring.FullDisplayName .. " " or ""
raw_value.FullDisplayName = date_tostring .. "ranked win %"
raw_value.TostringFunction = ReplicatedStorage or pretty_number_tostring
raw_value.Image = playtime_tostring and playtime_tostring.Image or ""
t.Info[raw_value.DataName] = raw_value
table.insert(t.Order, raw_value.DataName)
playtime_tostring = {
    Index = #t.Order + 1,
    IsCareerStatistic = true,
    OnlyDisplayAboveZero = nil,
    DataName = "StatisticDamageDealt",
    DisplayName = "Damage Dealt",
    FullDisplayName = "Damage Dealt",
    IsStatisticFolder = false,
    ParentDataName = nil,
    DefaultValue = 0,
    ValueType = "number",
    TostringFunction = pretty_number_tostring,
    Image = "rbxassetid://18404346057"
}
t.Info[playtime_tostring.DataName] = playtime_tostring
table.insert(t.Order, playtime_tostring.DataName)
playtime_tostring = t.Info.StatisticDamageDealt
raw_value = {
    Index = #t.Order + 1,
    IsCareerStatistic = true,
    OnlyDisplayAboveZero = nil,
    DataName = "StatisticDamageDealtSliding",
    DisplayName = "while sliding",
    FullDisplayName = nil,
    IsStatisticFolder = false,
    ParentDataName = "StatisticDamageDealt",
    DefaultValue = 0,
    ValueType = "number",
    TostringFunction = nil,
    Image = nil
}
date_tostring = playtime_tostring and playtime_tostring.FullDisplayName .. " " or ""
raw_value.FullDisplayName = date_tostring .. "while sliding"
raw_value.TostringFunction = pretty_number_tostring
raw_value.Image = playtime_tostring and playtime_tostring.Image or ""
t.Info[raw_value.DataName] = raw_value
table.insert(t.Order, raw_value.DataName)
playtime_tostring = t.Info.StatisticDamageDealt
raw_value = {
    Index = #t.Order + 1,
    IsCareerStatistic = true,
    OnlyDisplayAboveZero = nil,
    DataName = "StatisticDamageDealtCrouching",
    DisplayName = "while crouching",
    FullDisplayName = nil,
    IsStatisticFolder = false,
    ParentDataName = "StatisticDamageDealt",
    DefaultValue = 0,
    ValueType = "number",
    TostringFunction = nil,
    Image = nil
}
date_tostring = playtime_tostring and playtime_tostring.FullDisplayName .. " " or ""
raw_value.FullDisplayName = date_tostring .. "while crouching"
raw_value.TostringFunction = pretty_number_tostring
raw_value.Image = playtime_tostring and playtime_tostring.Image or ""
t.Info[raw_value.DataName] = raw_value
table.insert(t.Order, raw_value.DataName)
playtime_tostring = t.Info.StatisticDamageDealt
raw_value = {
    Index = #t.Order + 1,
    IsCareerStatistic = true,
    OnlyDisplayAboveZero = nil,
    DataName = "StatisticDamageDealtAirborne",
    DisplayName = "while airborne",
    FullDisplayName = nil,
    IsStatisticFolder = false,
    ParentDataName = "StatisticDamageDealt",
    DefaultValue = 0,
    ValueType = "number",
    TostringFunction = nil,
    Image = nil
}
date_tostring = playtime_tostring and playtime_tostring.FullDisplayName .. " " or ""
raw_value.FullDisplayName = date_tostring .. "while airborne"
raw_value.TostringFunction = pretty_number_tostring
raw_value.Image = playtime_tostring and playtime_tostring.Image or ""
t.Info[raw_value.DataName] = raw_value
table.insert(t.Order, raw_value.DataName)
playtime_tostring = t.Info.StatisticDamageDealt
raw_value = {
    Index = #t.Order + 1,
    IsCareerStatistic = true,
    OnlyDisplayAboveZero = nil,
    DataName = "StatisticDamageDealtBlinded",
    DisplayName = "while blinded",
    FullDisplayName = nil,
    IsStatisticFolder = false,
    ParentDataName = "StatisticDamageDealt",
    DefaultValue = 0,
    ValueType = "number",
    TostringFunction = nil,
    Image = nil
}
date_tostring = playtime_tostring and playtime_tostring.FullDisplayName .. " " or ""
raw_value.FullDisplayName = date_tostring .. "while blinded"
raw_value.TostringFunction = pretty_number_tostring
raw_value.Image = playtime_tostring and playtime_tostring.Image or ""
t.Info[raw_value.DataName] = raw_value
table.insert(t.Order, raw_value.DataName)
playtime_tostring = t.Info.StatisticDamageDealt
raw_value = {
    Index = #t.Order + 1,
    IsCareerStatistic = true,
    OnlyDisplayAboveZero = nil,
    DataName = "StatisticDamageDealtDead",
    DisplayName = "while dead",
    FullDisplayName = nil,
    IsStatisticFolder = false,
    ParentDataName = "StatisticDamageDealt",
    DefaultValue = 0,
    ValueType = "number",
    TostringFunction = nil,
    Image = nil
}
date_tostring = playtime_tostring and playtime_tostring.FullDisplayName .. " " or ""
raw_value.FullDisplayName = date_tostring .. "while dead"
raw_value.TostringFunction = pretty_number_tostring
raw_value.Image = playtime_tostring and playtime_tostring.Image or ""
t.Info[raw_value.DataName] = raw_value
table.insert(t.Order, raw_value.DataName)
playtime_tostring = t.Info.StatisticDamageDealt
raw_value = {
    Index = #t.Order + 1,
    IsCareerStatistic = true,
    OnlyDisplayAboveZero = nil,
    DataName = "StatisticDamageDealtNoscope",
    DisplayName = "while noscoping",
    FullDisplayName = nil,
    IsStatisticFolder = false,
    ParentDataName = "StatisticDamageDealt",
    DefaultValue = 0,
    ValueType = "number",
    TostringFunction = nil,
    Image = nil
}
date_tostring = playtime_tostring and playtime_tostring.FullDisplayName .. " " or ""
raw_value.FullDisplayName = date_tostring .. "while noscoping"
raw_value.TostringFunction = pretty_number_tostring
raw_value.Image = playtime_tostring and playtime_tostring.Image or ""
t.Info[raw_value.DataName] = raw_value
table.insert(t.Order, raw_value.DataName)
playtime_tostring = t.Info.StatisticDamageDealt
raw_value = {
    Index = #t.Order + 1,
    IsCareerStatistic = true,
    OnlyDisplayAboveZero = nil,
    DataName = "StatisticDamageDealtDashing",
    DisplayName = "while dashing",
    FullDisplayName = nil,
    IsStatisticFolder = false,
    ParentDataName = "StatisticDamageDealt",
    DefaultValue = 0,
    ValueType = "number",
    TostringFunction = nil,
    Image = nil
}
date_tostring = playtime_tostring and playtime_tostring.FullDisplayName .. " " or ""
raw_value.FullDisplayName = date_tostring .. "while dashing"
raw_value.TostringFunction = pretty_number_tostring
raw_value.Image = playtime_tostring and playtime_tostring.Image or ""
t.Info[raw_value.DataName] = raw_value
table.insert(t.Order, raw_value.DataName)
playtime_tostring = t.Info.StatisticDamageDealt
raw_value = {
    Index = #t.Order + 1,
    IsCareerStatistic = true,
    OnlyDisplayAboveZero = nil,
    DataName = "StatisticDamageDealtDeflecting",
    DisplayName = "from deflecting",
    FullDisplayName = nil,
    IsStatisticFolder = false,
    ParentDataName = "StatisticDamageDealt",
    DefaultValue = 0,
    ValueType = "number",
    TostringFunction = nil,
    Image = nil
}
date_tostring = playtime_tostring and playtime_tostring.FullDisplayName .. " " or ""
raw_value.FullDisplayName = date_tostring .. "from deflecting"
raw_value.TostringFunction = pretty_number_tostring
raw_value.Image = playtime_tostring and playtime_tostring.Image or ""
t.Info[raw_value.DataName] = raw_value
table.insert(t.Order, raw_value.DataName)
playtime_tostring = t.Info.StatisticDamageDealt
raw_value = {
    Index = #t.Order + 1,
    IsCareerStatistic = true,
    OnlyDisplayAboveZero = nil,
    DataName = "StatisticDamageDealtBouncing",
    DisplayName = "after a bounce",
    FullDisplayName = nil,
    IsStatisticFolder = false,
    ParentDataName = "StatisticDamageDealt",
    DefaultValue = 0,
    ValueType = "number",
    TostringFunction = nil,
    Image = nil
}
date_tostring = playtime_tostring and playtime_tostring.FullDisplayName .. " " or ""
raw_value.FullDisplayName = date_tostring .. "after a bounce"
raw_value.TostringFunction = pretty_number_tostring
raw_value.Image = playtime_tostring and playtime_tostring.Image or ""
t.Info[raw_value.DataName] = raw_value
table.insert(t.Order, raw_value.DataName)
playtime_tostring = t.Info.StatisticDamageDealt
raw_value = {
    Index = #t.Order + 1,
    IsCareerStatistic = true,
    OnlyDisplayAboveZero = nil,
    DataName = "StatisticDamageDealtGunMode",
    DisplayName = "in gun mode",
    FullDisplayName = nil,
    IsStatisticFolder = false,
    ParentDataName = "StatisticDamageDealt",
    DefaultValue = 0,
    ValueType = "number",
    TostringFunction = nil,
    Image = nil
}
date_tostring = playtime_tostring and playtime_tostring.FullDisplayName .. " " or ""
raw_value.FullDisplayName = date_tostring .. "in gun mode"
raw_value.TostringFunction = pretty_number_tostring
raw_value.Image = playtime_tostring and playtime_tostring.Image or ""
t.Info[raw_value.DataName] = raw_value
table.insert(t.Order, raw_value.DataName)
playtime_tostring = t.Info.StatisticDamageDealt
raw_value = {
    Index = #t.Order + 1,
    IsCareerStatistic = true,
    OnlyDisplayAboveZero = nil,
    DataName = "StatisticDamageDealtBladeMode",
    DisplayName = "in blade mode",
    FullDisplayName = nil,
    IsStatisticFolder = false,
    ParentDataName = "StatisticDamageDealt",
    DefaultValue = 0,
    ValueType = "number",
    TostringFunction = nil,
    Image = nil
}
date_tostring = playtime_tostring and playtime_tostring.FullDisplayName .. " " or ""
raw_value.FullDisplayName = date_tostring .. "in blade mode"
raw_value.TostringFunction = pretty_number_tostring
raw_value.Image = playtime_tostring and playtime_tostring.Image or ""
t.Info[raw_value.DataName] = raw_value
table.insert(t.Order, raw_value.DataName)
playtime_tostring = {
    Index = #t.Order + 1,
    IsCareerStatistic = true,
    OnlyDisplayAboveZero = nil,
    DataName = "StatisticEliminations",
    DisplayName = "Eliminations",
    FullDisplayName = "Eliminations",
    IsStatisticFolder = false,
    ParentDataName = nil,
    DefaultValue = 0,
    ValueType = "number",
    TostringFunction = pretty_number_tostring,
    Image = "rbxassetid://17736790660"
}
t.Info[playtime_tostring.DataName] = playtime_tostring
table.insert(t.Order, playtime_tostring.DataName)
playtime_tostring = t.Info.StatisticEliminations
raw_value = {
    Index = #t.Order + 1,
    IsCareerStatistic = true,
    OnlyDisplayAboveZero = nil,
    DataName = "StatisticEliminationsSliding",
    DisplayName = "while sliding",
    FullDisplayName = nil,
    IsStatisticFolder = false,
    ParentDataName = "StatisticEliminations",
    DefaultValue = 0,
    ValueType = "number",
    TostringFunction = nil,
    Image = nil
}
date_tostring = playtime_tostring and playtime_tostring.FullDisplayName .. " " or ""
raw_value.FullDisplayName = date_tostring .. "while sliding"
raw_value.TostringFunction = pretty_number_tostring
raw_value.Image = playtime_tostring and playtime_tostring.Image or ""
t.Info[raw_value.DataName] = raw_value
table.insert(t.Order, raw_value.DataName)
playtime_tostring = t.Info.StatisticEliminations
raw_value = {
    Index = #t.Order + 1,
    IsCareerStatistic = true,
    OnlyDisplayAboveZero = nil,
    DataName = "StatisticEliminationsCrouching",
    DisplayName = "while crouching",
    FullDisplayName = nil,
    IsStatisticFolder = false,
    ParentDataName = "StatisticEliminations",
    DefaultValue = 0,
    ValueType = "number",
    TostringFunction = nil,
    Image = nil
}
date_tostring = playtime_tostring and playtime_tostring.FullDisplayName .. " " or ""
raw_value.FullDisplayName = date_tostring .. "while crouching"
raw_value.TostringFunction = pretty_number_tostring
raw_value.Image = playtime_tostring and playtime_tostring.Image or ""
t.Info[raw_value.DataName] = raw_value
table.insert(t.Order, raw_value.DataName)
playtime_tostring = t.Info.StatisticEliminations
raw_value = {
    Index = #t.Order + 1,
    IsCareerStatistic = true,
    OnlyDisplayAboveZero = nil,
    DataName = "StatisticEliminationsAirborne",
    DisplayName = "while airborne",
    FullDisplayName = nil,
    IsStatisticFolder = false,
    ParentDataName = "StatisticEliminations",
    DefaultValue = 0,
    ValueType = "number",
    TostringFunction = nil,
    Image = nil
}
date_tostring = playtime_tostring and playtime_tostring.FullDisplayName .. " " or ""
raw_value.FullDisplayName = date_tostring .. "while airborne"
raw_value.TostringFunction = pretty_number_tostring
raw_value.Image = playtime_tostring and playtime_tostring.Image or ""
t.Info[raw_value.DataName] = raw_value
table.insert(t.Order, raw_value.DataName)
playtime_tostring = t.Info.StatisticEliminations
raw_value = {
    Index = #t.Order + 1,
    IsCareerStatistic = true,
    OnlyDisplayAboveZero = nil,
    DataName = "StatisticEliminationsBlinded",
    DisplayName = "while blinded",
    FullDisplayName = nil,
    IsStatisticFolder = false,
    ParentDataName = "StatisticEliminations",
    DefaultValue = 0,
    ValueType = "number",
    TostringFunction = nil,
    Image = nil
}
date_tostring = playtime_tostring and playtime_tostring.FullDisplayName .. " " or ""
raw_value.FullDisplayName = date_tostring .. "while blinded"
raw_value.TostringFunction = pretty_number_tostring
raw_value.Image = playtime_tostring and playtime_tostring.Image or ""
t.Info[raw_value.DataName] = raw_value
table.insert(t.Order, raw_value.DataName)
playtime_tostring = t.Info.StatisticEliminations
raw_value = {
    Index = #t.Order + 1,
    IsCareerStatistic = true,
    OnlyDisplayAboveZero = nil,
    DataName = "StatisticEliminationsDead",
    DisplayName = "while dead",
    FullDisplayName = nil,
    IsStatisticFolder = false,
    ParentDataName = "StatisticEliminations",
    DefaultValue = 0,
    ValueType = "number",
    TostringFunction = nil,
    Image = nil
}
date_tostring = playtime_tostring and playtime_tostring.FullDisplayName .. " " or ""
raw_value.FullDisplayName = date_tostring .. "while dead"
raw_value.TostringFunction = pretty_number_tostring
raw_value.Image = playtime_tostring and playtime_tostring.Image or ""
t.Info[raw_value.DataName] = raw_value
table.insert(t.Order, raw_value.DataName)
playtime_tostring = t.Info.StatisticEliminations
raw_value = {
    Index = #t.Order + 1,
    IsCareerStatistic = true,
    OnlyDisplayAboveZero = nil,
    DataName = "StatisticEliminationsNoscope",
    DisplayName = "while noscoping",
    FullDisplayName = nil,
    IsStatisticFolder = false,
    ParentDataName = "StatisticEliminations",
    DefaultValue = 0,
    ValueType = "number",
    TostringFunction = nil,
    Image = nil
}
date_tostring = playtime_tostring and playtime_tostring.FullDisplayName .. " " or ""
raw_value.FullDisplayName = date_tostring .. "while noscoping"
raw_value.TostringFunction = pretty_number_tostring
raw_value.Image = playtime_tostring and playtime_tostring.Image or ""
t.Info[raw_value.DataName] = raw_value
table.insert(t.Order, raw_value.DataName)
playtime_tostring = t.Info.StatisticEliminations
raw_value = {
    Index = #t.Order + 1,
    IsCareerStatistic = true,
    OnlyDisplayAboveZero = nil,
    DataName = "StatisticEliminationsDashing",
    DisplayName = "while dashing",
    FullDisplayName = nil,
    IsStatisticFolder = false,
    ParentDataName = "StatisticEliminations",
    DefaultValue = 0,
    ValueType = "number",
    TostringFunction = nil,
    Image = nil
}
date_tostring = playtime_tostring and playtime_tostring.FullDisplayName .. " " or ""
raw_value.FullDisplayName = date_tostring .. "while dashing"
raw_value.TostringFunction = pretty_number_tostring
raw_value.Image = playtime_tostring and playtime_tostring.Image or ""
t.Info[raw_value.DataName] = raw_value
table.insert(t.Order, raw_value.DataName)
playtime_tostring = t.Info.StatisticEliminations
raw_value = {
    Index = #t.Order + 1,
    IsCareerStatistic = true,
    OnlyDisplayAboveZero = nil,
    DataName = "StatisticEliminationsDeflecting",
    DisplayName = "from deflecting",
    FullDisplayName = nil,
    IsStatisticFolder = false,
    ParentDataName = "StatisticEliminations",
    DefaultValue = 0,
    ValueType = "number",
    TostringFunction = nil,
    Image = nil
}
date_tostring = playtime_tostring and playtime_tostring.FullDisplayName .. " " or ""
raw_value.FullDisplayName = date_tostring .. "from deflecting"
raw_value.TostringFunction = pretty_number_tostring
raw_value.Image = playtime_tostring and playtime_tostring.Image or ""
t.Info[raw_value.DataName] = raw_value
table.insert(t.Order, raw_value.DataName)
playtime_tostring = t.Info.StatisticEliminations
raw_value = {
    Index = #t.Order + 1,
    IsCareerStatistic = true,
    OnlyDisplayAboveZero = nil,
    DataName = "StatisticEliminationsBouncing",
    DisplayName = "after a bounce",
    FullDisplayName = nil,
    IsStatisticFolder = false,
    ParentDataName = "StatisticEliminations",
    DefaultValue = 0,
    ValueType = "number",
    TostringFunction = nil,
    Image = nil
}
date_tostring = playtime_tostring and playtime_tostring.FullDisplayName .. " " or ""
raw_value.FullDisplayName = date_tostring .. "after a bounce"
raw_value.TostringFunction = pretty_number_tostring
raw_value.Image = playtime_tostring and playtime_tostring.Image or ""
t.Info[raw_value.DataName] = raw_value
table.insert(t.Order, raw_value.DataName)
playtime_tostring = t.Info.StatisticEliminations
raw_value = {
    Index = #t.Order + 1,
    IsCareerStatistic = true,
    OnlyDisplayAboveZero = nil,
    DataName = "StatisticEliminationsGunMode",
    DisplayName = "in gun mode",
    FullDisplayName = nil,
    IsStatisticFolder = false,
    ParentDataName = "StatisticEliminations",
    DefaultValue = 0,
    ValueType = "number",
    TostringFunction = nil,
    Image = nil
}
date_tostring = playtime_tostring and playtime_tostring.FullDisplayName .. " " or ""
raw_value.FullDisplayName = date_tostring .. "in gun mode"
raw_value.TostringFunction = pretty_number_tostring
raw_value.Image = playtime_tostring and playtime_tostring.Image or ""
t.Info[raw_value.DataName] = raw_value
table.insert(t.Order, raw_value.DataName)
playtime_tostring = t.Info.StatisticEliminations
raw_value = {
    Index = #t.Order + 1,
    IsCareerStatistic = true,
    OnlyDisplayAboveZero = nil,
    DataName = "StatisticEliminationsBladeMode",
    DisplayName = "in blade mode",
    FullDisplayName = nil,
    IsStatisticFolder = false,
    ParentDataName = "StatisticEliminations",
    DefaultValue = 0,
    ValueType = "number",
    TostringFunction = nil,
    Image = nil
}
date_tostring = playtime_tostring and playtime_tostring.FullDisplayName .. " " or ""
raw_value.FullDisplayName = date_tostring .. "in blade mode"
raw_value.TostringFunction = pretty_number_tostring
raw_value.Image = playtime_tostring and playtime_tostring.Image or ""
t.Info[raw_value.DataName] = raw_value
table.insert(t.Order, raw_value.DataName)
playtime_tostring = {
    Index = #t.Order + 1,
    IsCareerStatistic = true,
    OnlyDisplayAboveZero = nil,
    DataName = "StatisticDeaths",
    DisplayName = "Deaths",
    FullDisplayName = "Deaths",
    IsStatisticFolder = false,
    ParentDataName = nil,
    DefaultValue = 0,
    ValueType = "number",
    TostringFunction = pretty_number_tostring,
    Image = ""
}
t.Info[playtime_tostring.DataName] = playtime_tostring
table.insert(t.Order, playtime_tostring.DataName)

function playtime_tostring(arg25) -- line: 194
    if arg25 == -1 then
        return "N/A"
    end

    return (string.format("%.2f", arg25))
end

raw_value = t.Info.StatisticDeaths
date_tostring = {
    Index = #t.Order + 1,
    IsCareerStatistic = true,
    OnlyDisplayAboveZero = nil,
    DataName = "StatisticDeathsRatio",
    DisplayName = "eliminations ratio",
    FullDisplayName = nil,
    IsStatisticFolder = false,
    ParentDataName = "StatisticDeaths",
    DefaultValue = -1,
    ValueType = "number",
    TostringFunction = nil,
    Image = nil
}
t_9 = raw_value and raw_value.FullDisplayName .. " " or ""
date_tostring.FullDisplayName = t_9 .. "eliminations ratio"
date_tostring.TostringFunction = playtime_tostring or pretty_number_tostring
date_tostring.Image = raw_value and raw_value.Image or ""
t.Info[date_tostring.DataName] = date_tostring
table.insert(t.Order, date_tostring.DataName)
playtime_tostring = {
    Index = #t.Order + 1,
    IsCareerStatistic = true,
    OnlyDisplayAboveZero = nil,
    DataName = "StatisticAssists",
    DisplayName = "Assists",
    FullDisplayName = "Assists",
    IsStatisticFolder = false,
    ParentDataName = nil,
    DefaultValue = 0,
    ValueType = "number",
    TostringFunction = pretty_number_tostring,
    Image = ""
}
t.Info[playtime_tostring.DataName] = playtime_tostring
table.insert(t.Order, playtime_tostring.DataName)
playtime_tostring = t.Info.StatisticAssists
raw_value = {
    Index = #t.Order + 1,
    IsCareerStatistic = true,
    OnlyDisplayAboveZero = nil,
    DataName = "StatisticAssistsDead",
    DisplayName = "while dead",
    FullDisplayName = nil,
    IsStatisticFolder = false,
    ParentDataName = "StatisticAssists",
    DefaultValue = 0,
    ValueType = "number",
    TostringFunction = nil,
    Image = nil
}
date_tostring = playtime_tostring and playtime_tostring.FullDisplayName .. " " or ""
raw_value.FullDisplayName = date_tostring .. "while dead"
raw_value.TostringFunction = pretty_number_tostring
raw_value.Image = playtime_tostring and playtime_tostring.Image or ""
t.Info[raw_value.DataName] = raw_value
table.insert(t.Order, raw_value.DataName)
playtime_tostring = {
    Index = #t.Order + 1,
    IsCareerStatistic = true,
    OnlyDisplayAboveZero = nil,
    DataName = "StatisticDamageReceived",
    DisplayName = "Damage Received",
    FullDisplayName = "Damage Received",
    IsStatisticFolder = false,
    ParentDataName = nil,
    DefaultValue = 0,
    ValueType = "number",
    TostringFunction = pretty_number_tostring,
    Image = ""
}
t.Info[playtime_tostring.DataName] = playtime_tostring
table.insert(t.Order, playtime_tostring.DataName)
playtime_tostring = {
    Index = #t.Order + 1,
    IsCareerStatistic = true,
    OnlyDisplayAboveZero = nil,
    DataName = "StatisticHealsReceived",
    DisplayName = "Heals Received",
    FullDisplayName = "Heals Received",
    IsStatisticFolder = false,
    ParentDataName = nil,
    DefaultValue = 0,
    ValueType = "number",
    TostringFunction = pretty_number_tostring,
    Image = ""
}
t.Info[playtime_tostring.DataName] = playtime_tostring
table.insert(t.Order, playtime_tostring.DataName)
playtime_tostring = {
    Index = #t.Order + 1,
    IsCareerStatistic = true,
    OnlyDisplayAboveZero = nil,
    DataName = "StatisticHealsGiven",
    DisplayName = "Heals Given",
    FullDisplayName = "Heals Given",
    IsStatisticFolder = false,
    ParentDataName = nil,
    DefaultValue = 0,
    ValueType = "number",
    TostringFunction = pretty_number_tostring,
    Image = "rbxassetid://102083156692899"
}
t.Info[playtime_tostring.DataName] = playtime_tostring
table.insert(t.Order, playtime_tostring.DataName)
playtime_tostring = t.Info.StatisticHealsGiven
raw_value = {
    Index = #t.Order + 1,
    IsCareerStatistic = true,
    OnlyDisplayAboveZero = nil,
    DataName = "StatisticHealsGivenTeammates",
    DisplayName = "to teammates",
    FullDisplayName = nil,
    IsStatisticFolder = false,
    ParentDataName = "StatisticHealsGiven",
    DefaultValue = 0,
    ValueType = "number",
    TostringFunction = nil,
    Image = nil
}
date_tostring = playtime_tostring and playtime_tostring.FullDisplayName .. " " or ""
raw_value.FullDisplayName = date_tostring .. "to teammates"
raw_value.TostringFunction = pretty_number_tostring
raw_value.Image = playtime_tostring and playtime_tostring.Image or ""
t.Info[raw_value.DataName] = raw_value
table.insert(t.Order, raw_value.DataName)
playtime_tostring = {
    Index = #t.Order + 1,
    IsCareerStatistic = true,
    OnlyDisplayAboveZero = nil,
    DataName = "StatisticUses",
    DisplayName = "Uses",
    FullDisplayName = "Uses",
    IsStatisticFolder = false,
    ParentDataName = nil,
    DefaultValue = 0,
    ValueType = "number",
    TostringFunction = pretty_number_tostring,
    Image = ""
}
t.Info[playtime_tostring.DataName] = playtime_tostring
table.insert(t.Order, playtime_tostring.DataName)
playtime_tostring = t.Info.StatisticUses
raw_value = {
    Index = #t.Order + 1,
    IsCareerStatistic = true,
    OnlyDisplayAboveZero = nil,
    DataName = "StatisticUsesQuick",
    DisplayName = "quick uses",
    FullDisplayName = nil,
    IsStatisticFolder = false,
    ParentDataName = "StatisticUses",
    DefaultValue = 0,
    ValueType = "number",
    TostringFunction = nil,
    Image = nil
}
date_tostring = playtime_tostring and playtime_tostring.FullDisplayName .. " " or ""
raw_value.FullDisplayName = date_tostring .. "quick uses"
raw_value.TostringFunction = pretty_number_tostring
raw_value.Image = playtime_tostring and playtime_tostring.Image or ""
t.Info[raw_value.DataName] = raw_value
table.insert(t.Order, raw_value.DataName)
playtime_tostring = t.Info.StatisticUses
raw_value = {
    Index = #t.Order + 1,
    IsCareerStatistic = true,
    OnlyDisplayAboveZero = nil,
    DataName = "StatisticUsesHits",
    DisplayName = "hits",
    FullDisplayName = nil,
    IsStatisticFolder = false,
    ParentDataName = "StatisticUses",
    DefaultValue = 0,
    ValueType = "number",
    TostringFunction = nil,
    Image = nil
}
date_tostring = playtime_tostring and playtime_tostring.FullDisplayName .. " " or ""
raw_value.FullDisplayName = date_tostring .. "hits"
raw_value.TostringFunction = pretty_number_tostring
raw_value.Image = playtime_tostring and playtime_tostring.Image or ""
t.Info[raw_value.DataName] = raw_value
table.insert(t.Order, raw_value.DataName)
playtime_tostring = t.Info.StatisticUses
raw_value = {
    Index = #t.Order + 1,
    IsCareerStatistic = true,
    OnlyDisplayAboveZero = nil,
    DataName = "StatisticUsesHitPercent",
    DisplayName = "hit %",
    FullDisplayName = nil,
    IsStatisticFolder = false,
    ParentDataName = "StatisticUses",
    DefaultValue = -1,
    ValueType = "number",
    TostringFunction = nil,
    Image = nil
}
date_tostring = playtime_tostring and playtime_tostring.FullDisplayName .. " " or ""
raw_value.FullDisplayName = date_tostring .. "hit %"
raw_value.TostringFunction = ReplicatedStorage or pretty_number_tostring
raw_value.Image = playtime_tostring and playtime_tostring.Image or ""
t.Info[raw_value.DataName] = raw_value
table.insert(t.Order, raw_value.DataName)
playtime_tostring = t.Info.StatisticUses
raw_value = {
    Index = #t.Order + 1,
    IsCareerStatistic = true,
    OnlyDisplayAboveZero = nil,
    DataName = "StatisticUsesCriticalHits",
    DisplayName = "critical hits",
    FullDisplayName = nil,
    IsStatisticFolder = false,
    ParentDataName = "StatisticUses",
    DefaultValue = 0,
    ValueType = "number",
    TostringFunction = nil,
    Image = nil
}
date_tostring = playtime_tostring and playtime_tostring.FullDisplayName .. " " or ""
raw_value.FullDisplayName = date_tostring .. "critical hits"
raw_value.TostringFunction = pretty_number_tostring
raw_value.Image = playtime_tostring and playtime_tostring.Image or ""
t.Info[raw_value.DataName] = raw_value
table.insert(t.Order, raw_value.DataName)
playtime_tostring = t.Info.StatisticUses
raw_value = {
    Index = #t.Order + 1,
    IsCareerStatistic = true,
    OnlyDisplayAboveZero = nil,
    DataName = "StatisticUsesCriticalHitPercent",
    DisplayName = "critical hit %",
    FullDisplayName = nil,
    IsStatisticFolder = false,
    ParentDataName = "StatisticUses",
    DefaultValue = -1,
    ValueType = "number",
    TostringFunction = nil,
    Image = nil
}
date_tostring = playtime_tostring and playtime_tostring.FullDisplayName .. " " or ""
raw_value.FullDisplayName = date_tostring .. "critical hit %"
raw_value.TostringFunction = ReplicatedStorage or pretty_number_tostring
raw_value.Image = playtime_tostring and playtime_tostring.Image or ""
t.Info[raw_value.DataName] = raw_value
table.insert(t.Order, raw_value.DataName)
ReplicatedStorage = t.Info.StatisticUses
playtime_tostring = {
    Index = #t.Order + 1,
    IsCareerStatistic = true,
    OnlyDisplayAboveZero = nil,
    DataName = "StatisticUsesHitsSelf",
    DisplayName = "self hits",
    FullDisplayName = nil,
    IsStatisticFolder = false,
    ParentDataName = "StatisticUses",
    DefaultValue = 0,
    ValueType = "number",
    TostringFunction = nil,
    Image = nil
}
raw_value = ReplicatedStorage and ReplicatedStorage.FullDisplayName .. " " or ""
playtime_tostring.FullDisplayName = raw_value .. "self hits"
playtime_tostring.TostringFunction = pretty_number_tostring
playtime_tostring.Image = ReplicatedStorage and ReplicatedStorage.Image or ""
t.Info[playtime_tostring.DataName] = playtime_tostring
table.insert(t.Order, playtime_tostring.DataName)
ReplicatedStorage = t.Info.StatisticUses
playtime_tostring = {
    Index = #t.Order + 1,
    IsCareerStatistic = true,
    OnlyDisplayAboveZero = nil,
    DataName = "StatisticUsesHitsDirect",
    DisplayName = "direct hits",
    FullDisplayName = nil,
    IsStatisticFolder = false,
    ParentDataName = "StatisticUses",
    DefaultValue = 0,
    ValueType = "number",
    TostringFunction = nil,
    Image = nil
}
raw_value = ReplicatedStorage and ReplicatedStorage.FullDisplayName .. " " or ""
playtime_tostring.FullDisplayName = raw_value .. "direct hits"
playtime_tostring.TostringFunction = pretty_number_tostring
playtime_tostring.Image = ReplicatedStorage and ReplicatedStorage.Image or ""
t.Info[playtime_tostring.DataName] = playtime_tostring
table.insert(t.Order, playtime_tostring.DataName)
ReplicatedStorage = {
    Index = #t.Order + 1,
    IsCareerStatistic = true,
    OnlyDisplayAboveZero = nil,
    DataName = "StatisticInspects",
    DisplayName = "Inspects",
    FullDisplayName = "Inspects",
    IsStatisticFolder = false,
    ParentDataName = nil,
    DefaultValue = 0,
    ValueType = "number",
    TostringFunction = pretty_number_tostring,
    Image = ""
}
t.Info[ReplicatedStorage.DataName] = ReplicatedStorage
table.insert(t.Order, ReplicatedStorage.DataName)
ReplicatedStorage = t.Info.StatisticInspects
playtime_tostring = {
    Index = #t.Order + 1,
    IsCareerStatistic = true,
    OnlyDisplayAboveZero = nil,
    DataName = "StatisticInspectsAfterElimination",
    DisplayName = "after an elimination",
    FullDisplayName = nil,
    IsStatisticFolder = false,
    ParentDataName = "StatisticInspects",
    DefaultValue = 0,
    ValueType = "number",
    TostringFunction = nil,
    Image = nil
}
raw_value = ReplicatedStorage and ReplicatedStorage.FullDisplayName .. " " or ""
playtime_tostring.FullDisplayName = raw_value .. "after an elimination"
playtime_tostring.TostringFunction = pretty_number_tostring
playtime_tostring.Image = ReplicatedStorage and ReplicatedStorage.Image or ""
t.Info[playtime_tostring.DataName] = playtime_tostring
table.insert(t.Order, playtime_tostring.DataName)
ReplicatedStorage = {
    Index = #t.Order + 1,
    IsCareerStatistic = true,
    OnlyDisplayAboveZero = nil,
    DataName = "StatisticAmmoUsed",
    DisplayName = "Ammo Used",
    FullDisplayName = "Ammo Used",
    IsStatisticFolder = false,
    ParentDataName = nil,
    DefaultValue = 0,
    ValueType = "number",
    TostringFunction = pretty_number_tostring,
    Image = ""
}
t.Info[ReplicatedStorage.DataName] = ReplicatedStorage
table.insert(t.Order, ReplicatedStorage.DataName)
ReplicatedStorage = {
    Index = #t.Order + 1,
    IsCareerStatistic = true,
    OnlyDisplayAboveZero = nil,
    DataName = "StatisticReloads",
    DisplayName = "Reloads",
    FullDisplayName = "Reloads",
    IsStatisticFolder = false,
    ParentDataName = nil,
    DefaultValue = 0,
    ValueType = "number",
    TostringFunction = pretty_number_tostring,
    Image = ""
}
t.Info[ReplicatedStorage.DataName] = ReplicatedStorage
table.insert(t.Order, ReplicatedStorage.DataName)
ReplicatedStorage = {
    Index = #t.Order + 1,
    IsCareerStatistic = true,
    OnlyDisplayAboveZero = nil,
    DataName = "StatisticAirblasts",
    DisplayName = "Airblasts",
    FullDisplayName = "Airblasts",
    IsStatisticFolder = false,
    ParentDataName = nil,
    DefaultValue = 0,
    ValueType = "number",
    TostringFunction = pretty_number_tostring,
    Image = ""
}
t.Info[ReplicatedStorage.DataName] = ReplicatedStorage
table.insert(t.Order, ReplicatedStorage.DataName)
ReplicatedStorage = t.Info.StatisticAirblasts
playtime_tostring = {
    Index = #t.Order + 1,
    IsCareerStatistic = true,
    OnlyDisplayAboveZero = nil,
    DataName = "StatisticAirblastsHits",
    DisplayName = "players blasted",
    FullDisplayName = nil,
    IsStatisticFolder = false,
    ParentDataName = "StatisticAirblasts",
    DefaultValue = 0,
    ValueType = "number",
    TostringFunction = nil,
    Image = nil
}
raw_value = ReplicatedStorage and ReplicatedStorage.FullDisplayName .. " " or ""
playtime_tostring.FullDisplayName = raw_value .. "players blasted"
playtime_tostring.TostringFunction = pretty_number_tostring
playtime_tostring.Image = ReplicatedStorage and ReplicatedStorage.Image or ""
t.Info[playtime_tostring.DataName] = playtime_tostring
table.insert(t.Order, playtime_tostring.DataName)
ReplicatedStorage = t.Info.StatisticAirblasts
playtime_tostring = {
    Index = #t.Order + 1,
    IsCareerStatistic = true,
    OnlyDisplayAboveZero = nil,
    DataName = "StatisticAirblastsSmokesCleared",
    DisplayName = "smokes blasted",
    FullDisplayName = nil,
    IsStatisticFolder = false,
    ParentDataName = "StatisticAirblasts",
    DefaultValue = 0,
    ValueType = "number",
    TostringFunction = nil,
    Image = nil
}
raw_value = ReplicatedStorage and ReplicatedStorage.FullDisplayName .. " " or ""
playtime_tostring.FullDisplayName = raw_value .. "smokes blasted"
playtime_tostring.TostringFunction = pretty_number_tostring
playtime_tostring.Image = ReplicatedStorage and ReplicatedStorage.Image or ""
t.Info[playtime_tostring.DataName] = playtime_tostring
table.insert(t.Order, playtime_tostring.DataName)
ReplicatedStorage = {
    Index = #t.Order + 1,
    IsCareerStatistic = true,
    OnlyDisplayAboveZero = nil,
    DataName = "StatisticDashes",
    DisplayName = "Dashes",
    FullDisplayName = "Dashes",
    IsStatisticFolder = false,
    ParentDataName = nil,
    DefaultValue = 0,
    ValueType = "number",
    TostringFunction = pretty_number_tostring,
    Image = ""
}
t.Info[ReplicatedStorage.DataName] = ReplicatedStorage
table.insert(t.Order, ReplicatedStorage.DataName)
ReplicatedStorage = {
    Index = #t.Order + 1,
    IsCareerStatistic = true,
    OnlyDisplayAboveZero = nil,
    DataName = "StatisticWallsBuilt",
    DisplayName = "Walls Built",
    FullDisplayName = "Walls Built",
    IsStatisticFolder = false,
    ParentDataName = nil,
    DefaultValue = 0,
    ValueType = "number",
    TostringFunction = pretty_number_tostring,
    Image = ""
}
t.Info[ReplicatedStorage.DataName] = ReplicatedStorage
table.insert(t.Order, ReplicatedStorage.DataName)
ReplicatedStorage = t.Info.StatisticWallsBuilt
playtime_tostring = {
    Index = #t.Order + 1,
    IsCareerStatistic = true,
    OnlyDisplayAboveZero = nil,
    DataName = "StatisticWallsBuiltBricksLayed",
    DisplayName = "bricks layed",
    FullDisplayName = nil,
    IsStatisticFolder = false,
    ParentDataName = "StatisticWallsBuilt",
    DefaultValue = 0,
    ValueType = "number",
    TostringFunction = nil,
    Image = nil
}
raw_value = ReplicatedStorage and ReplicatedStorage.FullDisplayName .. " " or ""
playtime_tostring.FullDisplayName = raw_value .. "bricks layed"
playtime_tostring.TostringFunction = pretty_number_tostring
playtime_tostring.Image = ReplicatedStorage and ReplicatedStorage.Image or ""
t.Info[playtime_tostring.DataName] = playtime_tostring
table.insert(t.Order, playtime_tostring.DataName)
ReplicatedStorage = {
    Index = #t.Order + 1,
    IsCareerStatistic = true,
    OnlyDisplayAboveZero = nil,
    DataName = "StatisticDeflects",
    DisplayName = "Deflects",
    FullDisplayName = "Deflects",
    IsStatisticFolder = false,
    ParentDataName = nil,
    DefaultValue = 0,
    ValueType = "number",
    TostringFunction = pretty_number_tostring,
    Image = ""
}
t.Info[ReplicatedStorage.DataName] = ReplicatedStorage
table.insert(t.Order, ReplicatedStorage.DataName)
ReplicatedStorage = t.Info.StatisticDeflects
playtime_tostring = {
    Index = #t.Order + 1,
    IsCareerStatistic = true,
    OnlyDisplayAboveZero = nil,
    DataName = "StatisticDeflectsHits",
    DisplayName = "hits",
    FullDisplayName = nil,
    IsStatisticFolder = false,
    ParentDataName = "StatisticDeflects",
    DefaultValue = 0,
    ValueType = "number",
    TostringFunction = nil,
    Image = nil
}
raw_value = ReplicatedStorage and ReplicatedStorage.FullDisplayName .. " " or ""
playtime_tostring.FullDisplayName = raw_value .. "hits"
playtime_tostring.TostringFunction = pretty_number_tostring
playtime_tostring.Image = ReplicatedStorage and ReplicatedStorage.Image or ""
t.Info[playtime_tostring.DataName] = playtime_tostring
table.insert(t.Order, playtime_tostring.DataName)
ReplicatedStorage = t.Info.StatisticDeflects
playtime_tostring = {
    Index = #t.Order + 1,
    IsCareerStatistic = true,
    OnlyDisplayAboveZero = nil,
    DataName = "StatisticDeflectsCriticalHits",
    DisplayName = "critical hits",
    FullDisplayName = nil,
    IsStatisticFolder = false,
    ParentDataName = "StatisticDeflects",
    DefaultValue = 0,
    ValueType = "number",
    TostringFunction = nil,
    Image = nil
}
raw_value = ReplicatedStorage and ReplicatedStorage.FullDisplayName .. " " or ""
playtime_tostring.FullDisplayName = raw_value .. "critical hits"
playtime_tostring.TostringFunction = pretty_number_tostring
playtime_tostring.Image = ReplicatedStorage and ReplicatedStorage.Image or ""
t.Info[playtime_tostring.DataName] = playtime_tostring
table.insert(t.Order, playtime_tostring.DataName)
ReplicatedStorage = {
    Index = #t.Order + 1,
    IsCareerStatistic = true,
    OnlyDisplayAboveZero = nil,
    DataName = "StatisticExtinguishes",
    DisplayName = "Extinguishes",
    FullDisplayName = "Extinguishes",
    IsStatisticFolder = false,
    ParentDataName = nil,
    DefaultValue = 0,
    ValueType = "number",
    TostringFunction = pretty_number_tostring,
    Image = ""
}
t.Info[ReplicatedStorage.DataName] = ReplicatedStorage
table.insert(t.Order, ReplicatedStorage.DataName)
ReplicatedStorage = t.Info.StatisticExtinguishes
playtime_tostring = {
    Index = #t.Order + 1,
    IsCareerStatistic = true,
    OnlyDisplayAboveZero = nil,
    DataName = "StatisticExtinguishesPlayers",
    DisplayName = "players",
    FullDisplayName = nil,
    IsStatisticFolder = false,
    ParentDataName = "StatisticExtinguishes",
    DefaultValue = 0,
    ValueType = "number",
    TostringFunction = nil,
    Image = nil
}
raw_value = ReplicatedStorage and ReplicatedStorage.FullDisplayName .. " " or ""
playtime_tostring.FullDisplayName = raw_value .. "players"
playtime_tostring.TostringFunction = pretty_number_tostring
playtime_tostring.Image = ReplicatedStorage and ReplicatedStorage.Image or ""
t.Info[playtime_tostring.DataName] = playtime_tostring
table.insert(t.Order, playtime_tostring.DataName)
ReplicatedStorage = t.Info.StatisticExtinguishes
playtime_tostring = {
    Index = #t.Order + 1,
    IsCareerStatistic = true,
    OnlyDisplayAboveZero = nil,
    DataName = "StatisticExtinguishesMolotovs",
    DisplayName = "molotovs",
    FullDisplayName = nil,
    IsStatisticFolder = false,
    ParentDataName = "StatisticExtinguishes",
    DefaultValue = 0,
    ValueType = "number",
    TostringFunction = nil,
    Image = nil
}
raw_value = ReplicatedStorage and ReplicatedStorage.FullDisplayName .. " " or ""
playtime_tostring.FullDisplayName = raw_value .. "molotovs"
playtime_tostring.TostringFunction = pretty_number_tostring
playtime_tostring.Image = ReplicatedStorage and ReplicatedStorage.Image or ""
t.Info[playtime_tostring.DataName] = playtime_tostring
table.insert(t.Order, playtime_tostring.DataName)
ReplicatedStorage = t.Info.StatisticExtinguishes
playtime_tostring = {
    Index = #t.Order + 1,
    IsCareerStatistic = true,
    OnlyDisplayAboveZero = nil,
    DataName = "StatisticExtinguishesFlareGuns",
    DisplayName = "flare guns",
    FullDisplayName = nil,
    IsStatisticFolder = false,
    ParentDataName = "StatisticExtinguishes",
    DefaultValue = 0,
    ValueType = "number",
    TostringFunction = nil,
    Image = nil
}
raw_value = ReplicatedStorage and ReplicatedStorage.FullDisplayName .. " " or ""
playtime_tostring.FullDisplayName = raw_value .. "flare guns"
playtime_tostring.TostringFunction = pretty_number_tostring
playtime_tostring.Image = ReplicatedStorage and ReplicatedStorage.Image or ""
t.Info[playtime_tostring.DataName] = playtime_tostring
table.insert(t.Order, playtime_tostring.DataName)
ReplicatedStorage = t.Info.StatisticExtinguishes
playtime_tostring = {
    Index = #t.Order + 1,
    IsCareerStatistic = true,
    OnlyDisplayAboveZero = nil,
    DataName = "StatisticExtinguishesFlamethrowers",
    DisplayName = "flamethrowers",
    FullDisplayName = nil,
    IsStatisticFolder = false,
    ParentDataName = "StatisticExtinguishes",
    DefaultValue = 0,
    ValueType = "number",
    TostringFunction = nil,
    Image = nil
}
raw_value = ReplicatedStorage and ReplicatedStorage.FullDisplayName .. " " or ""
playtime_tostring.FullDisplayName = raw_value .. "flamethrowers"
playtime_tostring.TostringFunction = pretty_number_tostring
playtime_tostring.Image = ReplicatedStorage and ReplicatedStorage.Image or ""
t.Info[playtime_tostring.DataName] = playtime_tostring
table.insert(t.Order, playtime_tostring.DataName)
ReplicatedStorage = {
    Index = #t.Order + 1,
    IsCareerStatistic = true,
    OnlyDisplayAboveZero = nil,
    DataName = "StatisticBlinds",
    DisplayName = "Players Blinded",
    FullDisplayName = "Players Blinded",
    IsStatisticFolder = false,
    ParentDataName = nil,
    DefaultValue = 0,
    ValueType = "number",
    TostringFunction = pretty_number_tostring,
    Image = "rbxassetid://17814211801"
}
t.Info[ReplicatedStorage.DataName] = ReplicatedStorage
table.insert(t.Order, ReplicatedStorage.DataName)
ReplicatedStorage = t.Info.StatisticBlinds
playtime_tostring = {
    Index = #t.Order + 1,
    IsCareerStatistic = true,
    OnlyDisplayAboveZero = nil,
    DataName = "StatisticBlindsSelf",
    DisplayName = "self blinded",
    FullDisplayName = nil,
    IsStatisticFolder = false,
    ParentDataName = "StatisticBlinds",
    DefaultValue = 0,
    ValueType = "number",
    TostringFunction = nil,
    Image = nil
}
raw_value = ReplicatedStorage and ReplicatedStorage.FullDisplayName .. " " or ""
playtime_tostring.FullDisplayName = raw_value .. "self blinded"
playtime_tostring.TostringFunction = pretty_number_tostring
playtime_tostring.Image = ReplicatedStorage and ReplicatedStorage.Image or ""
t.Info[playtime_tostring.DataName] = playtime_tostring
table.insert(t.Order, playtime_tostring.DataName)
ReplicatedStorage = t.Info.StatisticBlinds
playtime_tostring = {
    Index = #t.Order + 1,
    IsCareerStatistic = true,
    OnlyDisplayAboveZero = nil,
    DataName = "StatisticBlindsEnemies",
    DisplayName = "enemies blinded",
    FullDisplayName = "Enemies Blinded",
    IsStatisticFolder = false,
    ParentDataName = "StatisticBlinds",
    DefaultValue = 0,
    ValueType = "number",
    TostringFunction = pretty_number_tostring,
    Image = ReplicatedStorage and ReplicatedStorage.Image or ""
}
t.Info[playtime_tostring.DataName] = playtime_tostring
table.insert(t.Order, playtime_tostring.DataName)
ReplicatedStorage = t.Info.StatisticBlinds
playtime_tostring = {
    Index = #t.Order + 1,
    IsCareerStatistic = true,
    OnlyDisplayAboveZero = nil,
    DataName = "StatisticBlindsTeammates",
    DisplayName = "teammates blinded",
    FullDisplayName = nil,
    IsStatisticFolder = false,
    ParentDataName = "StatisticBlinds",
    DefaultValue = 0,
    ValueType = "number",
    TostringFunction = nil,
    Image = nil
}
raw_value = ReplicatedStorage and ReplicatedStorage.FullDisplayName .. " " or ""
playtime_tostring.FullDisplayName = raw_value .. "teammates blinded"
playtime_tostring.TostringFunction = pretty_number_tostring
playtime_tostring.Image = ReplicatedStorage and ReplicatedStorage.Image or ""
t.Info[playtime_tostring.DataName] = playtime_tostring
table.insert(t.Order, playtime_tostring.DataName)
ReplicatedStorage = {
    Index = #t.Order + 1,
    IsCareerStatistic = true,
    OnlyDisplayAboveZero = nil,
    DataName = "StatisticSmokeds",
    DisplayName = "Players Smoked",
    FullDisplayName = "Players Smoked",
    IsStatisticFolder = false,
    ParentDataName = nil,
    DefaultValue = 0,
    ValueType = "number",
    TostringFunction = pretty_number_tostring,
    Image = "rbxassetid://18387088796"
}
t.Info[ReplicatedStorage.DataName] = ReplicatedStorage
table.insert(t.Order, ReplicatedStorage.DataName)
ReplicatedStorage = t.Info.StatisticSmokeds
playtime_tostring = {
    Index = #t.Order + 1,
    IsCareerStatistic = true,
    OnlyDisplayAboveZero = nil,
    DataName = "StatisticSmokedsSelf",
    DisplayName = "self smoked",
    FullDisplayName = nil,
    IsStatisticFolder = false,
    ParentDataName = "StatisticSmokeds",
    DefaultValue = 0,
    ValueType = "number",
    TostringFunction = nil,
    Image = nil
}
raw_value = ReplicatedStorage and ReplicatedStorage.FullDisplayName .. " " or ""
playtime_tostring.FullDisplayName = raw_value .. "self smoked"
playtime_tostring.TostringFunction = pretty_number_tostring
playtime_tostring.Image = ReplicatedStorage and ReplicatedStorage.Image or ""
t.Info[playtime_tostring.DataName] = playtime_tostring
table.insert(t.Order, playtime_tostring.DataName)
ReplicatedStorage = t.Info.StatisticSmokeds
playtime_tostring = {
    Index = #t.Order + 1,
    IsCareerStatistic = true,
    OnlyDisplayAboveZero = nil,
    DataName = "StatisticSmokedsEnemies",
    DisplayName = "enemies smoked",
    FullDisplayName = "Enemies Smoked",
    IsStatisticFolder = false,
    ParentDataName = "StatisticSmokeds",
    DefaultValue = 0,
    ValueType = "number",
    TostringFunction = pretty_number_tostring,
    Image = ReplicatedStorage and ReplicatedStorage.Image or ""
}
t.Info[playtime_tostring.DataName] = playtime_tostring
table.insert(t.Order, playtime_tostring.DataName)
ReplicatedStorage = t.Info.StatisticSmokeds
playtime_tostring = {
    Index = #t.Order + 1,
    IsCareerStatistic = true,
    OnlyDisplayAboveZero = nil,
    DataName = "StatisticSmokedsTeammates",
    DisplayName = "teammates smoked",
    FullDisplayName = nil,
    IsStatisticFolder = false,
    ParentDataName = "StatisticSmokeds",
    DefaultValue = 0,
    ValueType = "number",
    TostringFunction = nil,
    Image = nil
}
raw_value = ReplicatedStorage and ReplicatedStorage.FullDisplayName .. " " or ""
playtime_tostring.FullDisplayName = raw_value .. "teammates smoked"
playtime_tostring.TostringFunction = pretty_number_tostring
playtime_tostring.Image = ReplicatedStorage and ReplicatedStorage.Image or ""
t.Info[playtime_tostring.DataName] = playtime_tostring
table.insert(t.Order, playtime_tostring.DataName)
ReplicatedStorage = {
    Index = #t.Order + 1,
    IsCareerStatistic = true,
    OnlyDisplayAboveZero = nil,
    DataName = "StatisticFreezes",
    DisplayName = "Players Frozen",
    FullDisplayName = "Players Frozen",
    IsStatisticFolder = false,
    ParentDataName = nil,
    DefaultValue = 0,
    ValueType = "number",
    TostringFunction = pretty_number_tostring,
    Image = "rbxassetid://18428668944"
}
t.Info[ReplicatedStorage.DataName] = ReplicatedStorage
table.insert(t.Order, ReplicatedStorage.DataName)
ReplicatedStorage = t.Info.StatisticFreezes
playtime_tostring = {
    Index = #t.Order + 1,
    IsCareerStatistic = true,
    OnlyDisplayAboveZero = nil,
    DataName = "StatisticFreezesSelf",
    DisplayName = "self freezes",
    FullDisplayName = nil,
    IsStatisticFolder = false,
    ParentDataName = "StatisticFreezes",
    DefaultValue = 0,
    ValueType = "number",
    TostringFunction = nil,
    Image = nil
}
raw_value = ReplicatedStorage and ReplicatedStorage.FullDisplayName .. " " or ""
playtime_tostring.FullDisplayName = raw_value .. "self freezes"
playtime_tostring.TostringFunction = pretty_number_tostring
playtime_tostring.Image = ReplicatedStorage and ReplicatedStorage.Image or ""
t.Info[playtime_tostring.DataName] = playtime_tostring
table.insert(t.Order, playtime_tostring.DataName)
ReplicatedStorage = t.Info.StatisticFreezes
playtime_tostring = {
    Index = #t.Order + 1,
    IsCareerStatistic = true,
    OnlyDisplayAboveZero = nil,
    DataName = "StatisticFreezesEnemies",
    DisplayName = "enemies frozen",
    FullDisplayName = "Enemies Frozen",
    IsStatisticFolder = false,
    ParentDataName = "StatisticFreezes",
    DefaultValue = 0,
    ValueType = "number",
    TostringFunction = pretty_number_tostring,
    Image = ReplicatedStorage and ReplicatedStorage.Image or ""
}
t.Info[playtime_tostring.DataName] = playtime_tostring
table.insert(t.Order, playtime_tostring.DataName)
ReplicatedStorage = {
    Index = #t.Order + 1,
    IsCareerStatistic = true,
    OnlyDisplayAboveZero = nil,
    DataName = "StatisticEmpowers",
    DisplayName = "Players Empowered",
    FullDisplayName = "Players Empowered",
    IsStatisticFolder = false,
    ParentDataName = nil,
    DefaultValue = 0,
    ValueType = "number",
    TostringFunction = pretty_number_tostring,
    Image = "rbxassetid://86874311663826"
}
t.Info[ReplicatedStorage.DataName] = ReplicatedStorage
table.insert(t.Order, ReplicatedStorage.DataName)
ReplicatedStorage = t.Info.StatisticEmpowers
playtime_tostring = {
    Index = #t.Order + 1,
    IsCareerStatistic = true,
    OnlyDisplayAboveZero = nil,
    DataName = "StatisticEmpowersSelf",
    DisplayName = "self empowers",
    FullDisplayName = nil,
    IsStatisticFolder = false,
    ParentDataName = "StatisticEmpowers",
    DefaultValue = 0,
    ValueType = "number",
    TostringFunction = nil,
    Image = nil
}
raw_value = ReplicatedStorage and ReplicatedStorage.FullDisplayName .. " " or ""
playtime_tostring.FullDisplayName = raw_value .. "self empowers"
playtime_tostring.TostringFunction = pretty_number_tostring
playtime_tostring.Image = ReplicatedStorage and ReplicatedStorage.Image or ""
t.Info[playtime_tostring.DataName] = playtime_tostring
table.insert(t.Order, playtime_tostring.DataName)
ReplicatedStorage = t.Info.StatisticEmpowers
playtime_tostring = {
    Index = #t.Order + 1,
    IsCareerStatistic = true,
    OnlyDisplayAboveZero = nil,
    DataName = "StatisticEmpowersTeammates",
    DisplayName = "teammates empowered",
    FullDisplayName = nil,
    IsStatisticFolder = false,
    ParentDataName = "StatisticEmpowers",
    DefaultValue = 0,
    ValueType = "number",
    TostringFunction = nil,
    Image = nil
}
raw_value = ReplicatedStorage and ReplicatedStorage.FullDisplayName .. " " or ""
playtime_tostring.FullDisplayName = raw_value .. "teammates empowered"
playtime_tostring.TostringFunction = pretty_number_tostring
playtime_tostring.Image = ReplicatedStorage and ReplicatedStorage.Image or ""
t.Info[playtime_tostring.DataName] = playtime_tostring
table.insert(t.Order, playtime_tostring.DataName)
ReplicatedStorage = {
    Index = #t.Order + 1,
    IsCareerStatistic = true,
    OnlyDisplayAboveZero = nil,
    DataName = "StatisticAbsorbs",
    DisplayName = "Damage Absorbed",
    FullDisplayName = "Damage Absorbed",
    IsStatisticFolder = false,
    ParentDataName = nil,
    DefaultValue = 0,
    ValueType = "number",
    TostringFunction = pretty_number_tostring,
    Image = "rbxassetid://106392169866153"
}
t.Info[ReplicatedStorage.DataName] = ReplicatedStorage
table.insert(t.Order, ReplicatedStorage.DataName)
ReplicatedStorage = t.Info.StatisticAbsorbs
playtime_tostring = {
    Index = #t.Order + 1,
    IsCareerStatistic = true,
    OnlyDisplayAboveZero = nil,
    DataName = "StatisticAbsorbsBehind",
    DisplayName = "from behind",
    FullDisplayName = nil,
    IsStatisticFolder = false,
    ParentDataName = "StatisticAbsorbs",
    DefaultValue = 0,
    ValueType = "number",
    TostringFunction = nil,
    Image = nil
}
raw_value = ReplicatedStorage and ReplicatedStorage.FullDisplayName .. " " or ""
playtime_tostring.FullDisplayName = raw_value .. "from behind"
playtime_tostring.TostringFunction = pretty_number_tostring
playtime_tostring.Image = ReplicatedStorage and ReplicatedStorage.Image or ""
t.Info[playtime_tostring.DataName] = playtime_tostring
table.insert(t.Order, playtime_tostring.DataName)
ReplicatedStorage = {
    Index = #t.Order + 1,
    IsCareerStatistic = true,
    OnlyDisplayAboveZero = nil,
    DataName = "StatisticBounces",
    DisplayName = "Players Bounced",
    FullDisplayName = "Players Bounced",
    IsStatisticFolder = false,
    ParentDataName = nil,
    DefaultValue = 0,
    ValueType = "number",
    TostringFunction = pretty_number_tostring,
    Image = "rbxassetid://18436038478"
}
t.Info[ReplicatedStorage.DataName] = ReplicatedStorage
table.insert(t.Order, ReplicatedStorage.DataName)
ReplicatedStorage = t.Info.StatisticBounces
playtime_tostring = {
    Index = #t.Order + 1,
    IsCareerStatistic = true,
    OnlyDisplayAboveZero = nil,
    DataName = "StatisticBouncesSelf",
    DisplayName = "self bounces",
    FullDisplayName = nil,
    IsStatisticFolder = false,
    ParentDataName = "StatisticBounces",
    DefaultValue = 0,
    ValueType = "number",
    TostringFunction = nil,
    Image = nil
}
raw_value = ReplicatedStorage and ReplicatedStorage.FullDisplayName .. " " or ""
playtime_tostring.FullDisplayName = raw_value .. "self bounces"
playtime_tostring.TostringFunction = pretty_number_tostring
playtime_tostring.Image = ReplicatedStorage and ReplicatedStorage.Image or ""
t.Info[playtime_tostring.DataName] = playtime_tostring
table.insert(t.Order, playtime_tostring.DataName)
ReplicatedStorage = t.Info.StatisticBounces
playtime_tostring = {
    Index = #t.Order + 1,
    IsCareerStatistic = true,
    OnlyDisplayAboveZero = nil,
    DataName = "StatisticBouncesTeammates",
    DisplayName = "teammates bounced",
    FullDisplayName = nil,
    IsStatisticFolder = false,
    ParentDataName = "StatisticBounces",
    DefaultValue = 0,
    ValueType = "number",
    TostringFunction = nil,
    Image = nil
}
raw_value = ReplicatedStorage and ReplicatedStorage.FullDisplayName .. " " or ""
playtime_tostring.FullDisplayName = raw_value .. "teammates bounced"
playtime_tostring.TostringFunction = pretty_number_tostring
playtime_tostring.Image = ReplicatedStorage and ReplicatedStorage.Image or ""
t.Info[playtime_tostring.DataName] = playtime_tostring
table.insert(t.Order, playtime_tostring.DataName)
ReplicatedStorage = t.Info.StatisticBounces
playtime_tostring = {
    Index = #t.Order + 1,
    IsCareerStatistic = true,
    OnlyDisplayAboveZero = nil,
    DataName = "StatisticBouncesEnemies",
    DisplayName = "enemies bounced",
    FullDisplayName = nil,
    IsStatisticFolder = false,
    ParentDataName = "StatisticBounces",
    DefaultValue = 0,
    ValueType = "number",
    TostringFunction = nil,
    Image = nil
}
raw_value = ReplicatedStorage and ReplicatedStorage.FullDisplayName .. " " or ""
playtime_tostring.FullDisplayName = raw_value .. "enemies bounced"
playtime_tostring.TostringFunction = pretty_number_tostring
playtime_tostring.Image = ReplicatedStorage and ReplicatedStorage.Image or ""
t.Info[playtime_tostring.DataName] = playtime_tostring
table.insert(t.Order, playtime_tostring.DataName)
ReplicatedStorage = {
    Index = #t.Order + 1,
    IsCareerStatistic = true,
    OnlyDisplayAboveZero = nil,
    DataName = "StatisticVortexesSpawned",
    DisplayName = "Vortexes Spawned",
    FullDisplayName = "Vortexes Spawned",
    IsStatisticFolder = false,
    ParentDataName = nil,
    DefaultValue = 0,
    ValueType = "number",
    TostringFunction = pretty_number_tostring,
    Image = ""
}
t.Info[ReplicatedStorage.DataName] = ReplicatedStorage
table.insert(t.Order, ReplicatedStorage.DataName)
ReplicatedStorage = {
    Index = #t.Order + 1,
    IsCareerStatistic = true,
    OnlyDisplayAboveZero = nil,
    DataName = "StatisticPortalsSpawned",
    DisplayName = "Portals Spawned",
    FullDisplayName = "Portals Spawned",
    IsStatisticFolder = false,
    ParentDataName = nil,
    DefaultValue = 0,
    ValueType = "number",
    TostringFunction = pretty_number_tostring,
    Image = "rbxassetid://76793585944473"
}
t.Info[ReplicatedStorage.DataName] = ReplicatedStorage
table.insert(t.Order, ReplicatedStorage.DataName)
ReplicatedStorage = {
    Index = #t.Order + 1,
    IsCareerStatistic = true,
    OnlyDisplayAboveZero = nil,
    DataName = "StatisticWarps",
    DisplayName = "Warps",
    FullDisplayName = "Warps",
    IsStatisticFolder = false,
    ParentDataName = nil,
    DefaultValue = 0,
    ValueType = "number",
    TostringFunction = pretty_number_tostring,
    Image = "rbxassetid://17735783844"
}
t.Info[ReplicatedStorage.DataName] = ReplicatedStorage
table.insert(t.Order, ReplicatedStorage.DataName)
ReplicatedStorage = {
    Index = #t.Order + 1,
    IsCareerStatistic = true,
    OnlyDisplayAboveZero = nil,
    DataName = "StatisticLeaps",
    DisplayName = "Leaps",
    FullDisplayName = "Leaps",
    IsStatisticFolder = false,
    ParentDataName = nil,
    DefaultValue = 0,
    ValueType = "number",
    TostringFunction = pretty_number_tostring,
    Image = ""
}
t.Info[ReplicatedStorage.DataName] = ReplicatedStorage
table.insert(t.Order, ReplicatedStorage.DataName)
ReplicatedStorage = {
    Index = #t.Order + 1,
    IsCareerStatistic = true,
    OnlyDisplayAboveZero = nil,
    DataName = "StatisticSlams",
    DisplayName = "Slams",
    FullDisplayName = "Slams",
    IsStatisticFolder = false,
    ParentDataName = nil,
    DefaultValue = 0,
    ValueType = "number",
    TostringFunction = pretty_number_tostring,
    Image = ""
}
t.Info[ReplicatedStorage.DataName] = ReplicatedStorage
table.insert(t.Order, ReplicatedStorage.DataName)
ReplicatedStorage = t.Info.StatisticSlams
playtime_tostring = {
    Index = #t.Order + 1,
    IsCareerStatistic = true,
    OnlyDisplayAboveZero = nil,
    DataName = "StatisticSlamsHits",
    DisplayName = "hits",
    FullDisplayName = nil,
    IsStatisticFolder = false,
    ParentDataName = "StatisticSlams",
    DefaultValue = 0,
    ValueType = "number",
    TostringFunction = nil,
    Image = nil
}
raw_value = ReplicatedStorage and ReplicatedStorage.FullDisplayName .. " " or ""
playtime_tostring.FullDisplayName = raw_value .. "hits"
playtime_tostring.TostringFunction = pretty_number_tostring
playtime_tostring.Image = ReplicatedStorage and ReplicatedStorage.Image or ""
t.Info[playtime_tostring.DataName] = playtime_tostring
table.insert(t.Order, playtime_tostring.DataName)
ReplicatedStorage = {
    Index = #t.Order + 1,
    IsCareerStatistic = true,
    OnlyDisplayAboveZero = nil,
    DataName = "StatisticHooks",
    DisplayName = "Hooks",
    FullDisplayName = "Hooks",
    IsStatisticFolder = false,
    ParentDataName = nil,
    DefaultValue = 0,
    ValueType = "number",
    TostringFunction = pretty_number_tostring,
    Image = "rbxassetid://101933751328343"
}
t.Info[ReplicatedStorage.DataName] = ReplicatedStorage
table.insert(t.Order, ReplicatedStorage.DataName)
ReplicatedStorage = t.Info.StatisticHooks
playtime_tostring = {
    Index = #t.Order + 1,
    IsCareerStatistic = true,
    OnlyDisplayAboveZero = nil,
    DataName = "StatisticHooksEnvironment",
    DisplayName = "environment",
    FullDisplayName = nil,
    IsStatisticFolder = false,
    ParentDataName = "StatisticHooks",
    DefaultValue = 0,
    ValueType = "number",
    TostringFunction = nil,
    Image = nil
}
raw_value = ReplicatedStorage and ReplicatedStorage.FullDisplayName .. " " or ""
playtime_tostring.FullDisplayName = raw_value .. "environment"
playtime_tostring.TostringFunction = pretty_number_tostring
playtime_tostring.Image = ReplicatedStorage and ReplicatedStorage.Image or ""
t.Info[playtime_tostring.DataName] = playtime_tostring
table.insert(t.Order, playtime_tostring.DataName)
ReplicatedStorage = t.Info.StatisticHooks
playtime_tostring = {
    Index = #t.Order + 1,
    IsCareerStatistic = true,
    OnlyDisplayAboveZero = nil,
    DataName = "StatisticHooksEnemies",
    DisplayName = "enemies",
    FullDisplayName = "Enemies Hooked",
    IsStatisticFolder = false,
    ParentDataName = "StatisticHooks",
    DefaultValue = 0,
    ValueType = "number",
    TostringFunction = pretty_number_tostring,
    Image = ReplicatedStorage and ReplicatedStorage.Image or ""
}
t.Info[playtime_tostring.DataName] = playtime_tostring
table.insert(t.Order, playtime_tostring.DataName)
ReplicatedStorage = {
    Index = #t.Order + 1,
    IsCareerStatistic = true,
    OnlyDisplayAboveZero = nil,
    DataName = "StatisticThrows",
    DisplayName = "Throws",
    FullDisplayName = "Throws",
    IsStatisticFolder = false,
    ParentDataName = nil,
    DefaultValue = 0,
    ValueType = "number",
    TostringFunction = pretty_number_tostring,
    Image = ""
}
t.Info[ReplicatedStorage.DataName] = ReplicatedStorage
table.insert(t.Order, ReplicatedStorage.DataName)
ReplicatedStorage = t.Info.StatisticThrows
playtime_tostring = {
    Index = #t.Order + 1,
    IsCareerStatistic = true,
    OnlyDisplayAboveZero = nil,
    DataName = "StatisticThrowsPierces",
    DisplayName = "enemies pierced",
    FullDisplayName = nil,
    IsStatisticFolder = false,
    ParentDataName = "StatisticThrows",
    DefaultValue = 0,
    ValueType = "number",
    TostringFunction = nil,
    Image = nil
}
raw_value = ReplicatedStorage and ReplicatedStorage.FullDisplayName .. " " or ""
playtime_tostring.FullDisplayName = raw_value .. "enemies pierced"
playtime_tostring.TostringFunction = pretty_number_tostring
playtime_tostring.Image = ReplicatedStorage and ReplicatedStorage.Image or ""
t.Info[playtime_tostring.DataName] = playtime_tostring
table.insert(t.Order, playtime_tostring.DataName)
ReplicatedStorage = t.Info.StatisticThrows
playtime_tostring = {
    Index = #t.Order + 1,
    IsCareerStatistic = true,
    OnlyDisplayAboveZero = nil,
    DataName = "StatisticThrowsWalls",
    DisplayName = "walls hit",
    FullDisplayName = nil,
    IsStatisticFolder = false,
    ParentDataName = "StatisticThrows",
    DefaultValue = 0,
    ValueType = "number",
    TostringFunction = nil,
    Image = nil
}
raw_value = ReplicatedStorage and ReplicatedStorage.FullDisplayName .. " " or ""
playtime_tostring.FullDisplayName = raw_value .. "walls hit"
playtime_tostring.TostringFunction = pretty_number_tostring
playtime_tostring.Image = ReplicatedStorage and ReplicatedStorage.Image or ""
t.Info[playtime_tostring.DataName] = playtime_tostring
table.insert(t.Order, playtime_tostring.DataName)
ReplicatedStorage = {
    Index = #t.Order + 1,
    IsCareerStatistic = true,
    OnlyDisplayAboveZero = nil,
    DataName = "StatisticPaintGrenades",
    DisplayName = "Paint Grenades",
    FullDisplayName = "Paint Grenades",
    IsStatisticFolder = false,
    ParentDataName = nil,
    DefaultValue = 0,
    ValueType = "number",
    TostringFunction = pretty_number_tostring,
    Image = ""
}
t.Info[ReplicatedStorage.DataName] = ReplicatedStorage
table.insert(t.Order, ReplicatedStorage.DataName)
ReplicatedStorage = t.Info.StatisticPaintGrenades
playtime_tostring = {
    Index = #t.Order + 1,
    IsCareerStatistic = true,
    OnlyDisplayAboveZero = nil,
    DataName = "StatisticPaintGrenadesHits",
    DisplayName = "hits",
    FullDisplayName = nil,
    IsStatisticFolder = false,
    ParentDataName = "StatisticPaintGrenades",
    DefaultValue = 0,
    ValueType = "number",
    TostringFunction = nil,
    Image = nil
}
raw_value = ReplicatedStorage and ReplicatedStorage.FullDisplayName .. " " or ""
playtime_tostring.FullDisplayName = raw_value .. "hits"
playtime_tostring.TostringFunction = pretty_number_tostring
playtime_tostring.Image = ReplicatedStorage and ReplicatedStorage.Image or ""
t.Info[playtime_tostring.DataName] = playtime_tostring
table.insert(t.Order, playtime_tostring.DataName)
ReplicatedStorage = {
    Index = #t.Order + 1,
    IsCareerStatistic = true,
    OnlyDisplayAboveZero = nil,
    DataName = "StatisticBackstabs",
    DisplayName = "Backstabs",
    FullDisplayName = "Backstabs",
    IsStatisticFolder = false,
    ParentDataName = nil,
    DefaultValue = 0,
    ValueType = "number",
    TostringFunction = pretty_number_tostring,
    Image = ""
}
t.Info[ReplicatedStorage.DataName] = ReplicatedStorage
table.insert(t.Order, ReplicatedStorage.DataName)
ReplicatedStorage = {
    Index = #t.Order + 1,
    IsCareerStatistic = true,
    OnlyDisplayAboveZero = nil,
    DataName = "StatisticZombies",
    DisplayName = "Monsters",
    FullDisplayName = "Monsters",
    IsStatisticFolder = true,
    ParentDataName = nil,
    DefaultValue = 0,
    ValueType = "number",
    TostringFunction = pretty_number_tostring,
    Image = ""
}
t.Info[ReplicatedStorage.DataName] = ReplicatedStorage
table.insert(t.Order, ReplicatedStorage.DataName)
ReplicatedStorage = t.Info.StatisticZombies
playtime_tostring = {
    Index = #t.Order + 1,
    IsCareerStatistic = true,
    OnlyDisplayAboveZero = true,
    DataName = "StatisticZombiesDamageDealt",
    DisplayName = "damage dealt",
    FullDisplayName = nil,
    IsStatisticFolder = false,
    ParentDataName = "StatisticZombies",
    DefaultValue = 0,
    ValueType = "number",
    TostringFunction = nil,
    Image = nil
}
raw_value = ReplicatedStorage and ReplicatedStorage.FullDisplayName .. " " or ""
playtime_tostring.FullDisplayName = raw_value .. "damage dealt"
playtime_tostring.TostringFunction = pretty_number_tostring
playtime_tostring.Image = ReplicatedStorage and ReplicatedStorage.Image or ""
t.Info[playtime_tostring.DataName] = playtime_tostring
table.insert(t.Order, playtime_tostring.DataName)
ReplicatedStorage = t.Info.StatisticZombies
playtime_tostring = {
    Index = #t.Order + 1,
    IsCareerStatistic = true,
    OnlyDisplayAboveZero = true,
    DataName = "StatisticZombiesEliminations",
    DisplayName = "eliminations",
    FullDisplayName = nil,
    IsStatisticFolder = false,
    ParentDataName = "StatisticZombies",
    DefaultValue = 0,
    ValueType = "number",
    TostringFunction = nil,
    Image = nil
}
raw_value = ReplicatedStorage and ReplicatedStorage.FullDisplayName .. " " or ""
playtime_tostring.FullDisplayName = raw_value .. "eliminations"
playtime_tostring.TostringFunction = pretty_number_tostring
playtime_tostring.Image = ReplicatedStorage and ReplicatedStorage.Image or ""
t.Info[playtime_tostring.DataName] = playtime_tostring
table.insert(t.Order, playtime_tostring.DataName)
ReplicatedStorage = t.Info.StatisticZombies
playtime_tostring = {
    Index = #t.Order + 1,
    IsCareerStatistic = true,
    OnlyDisplayAboveZero = true,
    DataName = "StatisticZombieTowerCompletions",
    DisplayName = "Zombie Tower wins",
    FullDisplayName = nil,
    IsStatisticFolder = false,
    ParentDataName = "StatisticZombies",
    DefaultValue = 0,
    ValueType = "number",
    TostringFunction = nil,
    Image = nil
}
raw_value = ReplicatedStorage and ReplicatedStorage.FullDisplayName .. " " or ""
playtime_tostring.FullDisplayName = raw_value .. "Zombie Tower wins"
playtime_tostring.TostringFunction = pretty_number_tostring
playtime_tostring.Image = ReplicatedStorage and ReplicatedStorage.Image or ""
t.Info[playtime_tostring.DataName] = playtime_tostring
table.insert(t.Order, playtime_tostring.DataName)
ReplicatedStorage = t.Info.StatisticZombies
playtime_tostring = {
    Index = #t.Order + 1,
    IsCareerStatistic = true,
    OnlyDisplayAboveZero = true,
    DataName = "StatisticZombieTowerSpeedrun",
    DisplayName = "Zombie Tower speedrun",
    FullDisplayName = nil,
    IsStatisticFolder = false,
    ParentDataName = "StatisticZombies",
    DefaultValue = -1,
    ValueType = "number",
    TostringFunction = nil,
    Image = nil
}
raw_value = ReplicatedStorage and ReplicatedStorage.FullDisplayName .. " " or ""
playtime_tostring.FullDisplayName = raw_value .. "Zombie Tower speedrun"
playtime_tostring.TostringFunction = playtime_precise_tostring or pretty_number_tostring
playtime_tostring.Image = ReplicatedStorage and ReplicatedStorage.Image or ""
t.Info[playtime_tostring.DataName] = playtime_tostring
table.insert(t.Order, playtime_tostring.DataName)
ReplicatedStorage = t.Info.StatisticZombies
playtime_tostring = {
    Index = #t.Order + 1,
    IsCareerStatistic = true,
    OnlyDisplayAboveZero = true,
    DataName = "StatisticGargoyleTowerCompletions",
    DisplayName = "Gargoyle Tower wins",
    FullDisplayName = nil,
    IsStatisticFolder = false,
    ParentDataName = "StatisticZombies",
    DefaultValue = 0,
    ValueType = "number",
    TostringFunction = nil,
    Image = nil
}
raw_value = ReplicatedStorage and ReplicatedStorage.FullDisplayName .. " " or ""
playtime_tostring.FullDisplayName = raw_value .. "Gargoyle Tower wins"
playtime_tostring.TostringFunction = pretty_number_tostring
playtime_tostring.Image = ReplicatedStorage and ReplicatedStorage.Image or ""
t.Info[playtime_tostring.DataName] = playtime_tostring
table.insert(t.Order, playtime_tostring.DataName)
ReplicatedStorage = t.Info.StatisticZombies
playtime_tostring = {
    Index = #t.Order + 1,
    IsCareerStatistic = true,
    OnlyDisplayAboveZero = true,
    DataName = "StatisticGargoyleTowerSpeedrun",
    DisplayName = "Gargoyle Tower speedrun",
    FullDisplayName = nil,
    IsStatisticFolder = false,
    ParentDataName = "StatisticZombies",
    DefaultValue = -1,
    ValueType = "number",
    TostringFunction = nil,
    Image = nil
}
raw_value = ReplicatedStorage and ReplicatedStorage.FullDisplayName .. " " or ""
playtime_tostring.FullDisplayName = raw_value .. "Gargoyle Tower speedrun"
playtime_tostring.TostringFunction = playtime_precise_tostring or pretty_number_tostring
playtime_tostring.Image = ReplicatedStorage and ReplicatedStorage.Image or ""
t.Info[playtime_tostring.DataName] = playtime_tostring
table.insert(t.Order, playtime_tostring.DataName)

function ReplicatedStorage(arg26, arg27, arg28) --[[ add_item ]] -- line: 270
    -- upvalues:
    --  [1] t (copy)

    local t_148 = {}

    for _, val_6 in pairs(arg27) do
        table.insert(t_148, "Statistic" .. val_6)
    end

    t.Items[arg26] = { DataNames = t_148, Descriptions = arg28 }
end

ReplicatedStorage(
    "MISSING_WEAPON",
    {
        "Playtime",
        "PlaytimeUnequipped",
        "RoundsPlayed",
        "RoundsWon",
        "RoundsLost",
        "RoundsWinPercent",
        "RankedRoundsPlayed",
        "RankedRoundsWon",
        "RankedRoundsLost",
        "RankedRoundsWinPercent",
        "DamageDealt",
        "DamageDealtSliding",
        "DamageDealtCrouching",
        "DamageDealtAirborne",
        "DamageDealtBlinded",
        "DamageDealtDead",
        "Eliminations",
        "EliminationsSliding",
        "EliminationsCrouching",
        "EliminationsAirborne",
        "EliminationsBlinded",
        "EliminationsDead",
        "Deaths",
        "DeathsRatio",
        "Assists",
        "AssistsDead",
        "Uses",
        "UsesHits",
        "UsesHitPercent",
        "UsesCriticalHits",
        "UsesCriticalHitPercent",
        "Inspects",
        "InspectsAfterElimination",
        "AmmoUsed",
        "Reloads",
        "Zombies",
        "ZombiesDamageDealt",
        "ZombiesEliminations"
    },
    { { 1, "Note to self" } }
)
ReplicatedStorage(
    "Flare Gun",
    {
        "Playtime",
        "PlaytimeUnequipped",
        "RoundsPlayed",
        "RoundsWon",
        "RoundsLost",
        "RoundsWinPercent",
        "RankedRoundsPlayed",
        "RankedRoundsWon",
        "RankedRoundsLost",
        "RankedRoundsWinPercent",
        "DamageDealt",
        "DamageDealtSliding",
        "DamageDealtCrouching",
        "DamageDealtAirborne",
        "DamageDealtBlinded",
        "DamageDealtDead",
        "Eliminations",
        "EliminationsSliding",
        "EliminationsCrouching",
        "EliminationsAirborne",
        "EliminationsBlinded",
        "EliminationsDead",
        "Deaths",
        "DeathsRatio",
        "Assists",
        "AssistsDead",
        "Uses",
        "UsesHits",
        "UsesHitPercent",
        "Inspects",
        "InspectsAfterElimination",
        "AmmoUsed",
        "Zombies",
        "ZombiesDamageDealt",
        "ZombiesEliminations"
    },
    { { 2, "Shoots a fireball that constantly burns nearby enemies" } }
)
ReplicatedStorage(
    "Assault Rifle",
    {
        "Playtime",
        "PlaytimeUnequipped",
        "RoundsPlayed",
        "RoundsWon",
        "RoundsLost",
        "RoundsWinPercent",
        "RankedRoundsPlayed",
        "RankedRoundsWon",
        "RankedRoundsLost",
        "RankedRoundsWinPercent",
        "DamageDealt",
        "DamageDealtSliding",
        "DamageDealtCrouching",
        "DamageDealtAirborne",
        "DamageDealtBlinded",
        "DamageDealtDead",
        "Eliminations",
        "EliminationsSliding",
        "EliminationsCrouching",
        "EliminationsAirborne",
        "EliminationsBlinded",
        "EliminationsDead",
        "Deaths",
        "DeathsRatio",
        "Assists",
        "AssistsDead",
        "Uses",
        "UsesHits",
        "UsesHitPercent",
        "UsesCriticalHits",
        "UsesCriticalHitPercent",
        "Inspects",
        "InspectsAfterElimination",
        "AmmoUsed",
        "Reloads",
        "Zombies",
        "ZombiesDamageDealt",
        "ZombiesEliminations"
    },
    { { 2, "A standard rifle useful in all scenarios" } }
)
ReplicatedStorage(
    "Handgun",
    {
        "Playtime",
        "PlaytimeUnequipped",
        "RoundsPlayed",
        "RoundsWon",
        "RoundsLost",
        "RoundsWinPercent",
        "RankedRoundsPlayed",
        "RankedRoundsWon",
        "RankedRoundsLost",
        "RankedRoundsWinPercent",
        "DamageDealt",
        "DamageDealtSliding",
        "DamageDealtCrouching",
        "DamageDealtAirborne",
        "DamageDealtBlinded",
        "DamageDealtDead",
        "Eliminations",
        "EliminationsSliding",
        "EliminationsCrouching",
        "EliminationsAirborne",
        "EliminationsBlinded",
        "EliminationsDead",
        "Deaths",
        "DeathsRatio",
        "Assists",
        "AssistsDead",
        "Uses",
        "UsesHits",
        "UsesHitPercent",
        "UsesCriticalHits",
        "UsesCriticalHitPercent",
        "Inspects",
        "InspectsAfterElimination",
        "AmmoUsed",
        "Reloads",
        "Zombies",
        "ZombiesDamageDealt",
        "ZombiesEliminations"
    },
    { { 2, "A reliable sidearm useful in all scenarios" } }
)
ReplicatedStorage(
    "Burst Rifle",
    {
        "Playtime",
        "PlaytimeUnequipped",
        "RoundsPlayed",
        "RoundsWon",
        "RoundsLost",
        "RoundsWinPercent",
        "RankedRoundsPlayed",
        "RankedRoundsWon",
        "RankedRoundsLost",
        "RankedRoundsWinPercent",
        "DamageDealt",
        "DamageDealtSliding",
        "DamageDealtCrouching",
        "DamageDealtAirborne",
        "DamageDealtBlinded",
        "DamageDealtDead",
        "Eliminations",
        "EliminationsSliding",
        "EliminationsCrouching",
        "EliminationsAirborne",
        "EliminationsBlinded",
        "EliminationsDead",
        "Deaths",
        "DeathsRatio",
        "Assists",
        "AssistsDead",
        "Uses",
        "UsesHits",
        "UsesHitPercent",
        "UsesCriticalHits",
        "UsesCriticalHitPercent",
        "Inspects",
        "InspectsAfterElimination",
        "AmmoUsed",
        "Reloads",
        "Zombies",
        "ZombiesDamageDealt",
        "ZombiesEliminations"
    },
    { { 2, "Hit and run with this three-round burst rifle" } }
)
ReplicatedStorage(
    "Sniper",
    {
        "Playtime",
        "PlaytimeUnequipped",
        "RoundsPlayed",
        "RoundsWon",
        "RoundsLost",
        "RoundsWinPercent",
        "RankedRoundsPlayed",
        "RankedRoundsWon",
        "RankedRoundsLost",
        "RankedRoundsWinPercent",
        "DamageDealt",
        "DamageDealtSliding",
        "DamageDealtCrouching",
        "DamageDealtAirborne",
        "DamageDealtBlinded",
        "DamageDealtDead",
        "DamageDealtNoscope",
        "Eliminations",
        "EliminationsSliding",
        "EliminationsCrouching",
        "EliminationsAirborne",
        "EliminationsBlinded",
        "EliminationsDead",
        "EliminationsNoscope",
        "Deaths",
        "DeathsRatio",
        "Assists",
        "AssistsDead",
        "Uses",
        "UsesHits",
        "UsesHitPercent",
        "UsesCriticalHits",
        "UsesCriticalHitPercent",
        "Inspects",
        "InspectsAfterElimination",
        "AmmoUsed",
        "Reloads",
        "Zombies",
        "ZombiesDamageDealt",
        "ZombiesEliminations"
    },
    { { 2, "Long ranged rifle that can deal devastating damage" } }
)
ReplicatedStorage(
    "RPG",
    {
        "Playtime",
        "PlaytimeUnequipped",
        "RoundsPlayed",
        "RoundsWon",
        "RoundsLost",
        "RoundsWinPercent",
        "RankedRoundsPlayed",
        "RankedRoundsWon",
        "RankedRoundsLost",
        "RankedRoundsWinPercent",
        "DamageDealt",
        "DamageDealtSliding",
        "DamageDealtCrouching",
        "DamageDealtAirborne",
        "DamageDealtBlinded",
        "DamageDealtDead",
        "Eliminations",
        "EliminationsSliding",
        "EliminationsCrouching",
        "EliminationsAirborne",
        "EliminationsBlinded",
        "EliminationsDead",
        "Deaths",
        "DeathsRatio",
        "Assists",
        "AssistsDead",
        "Uses",
        "UsesHitsSelf",
        "UsesHits",
        "UsesHitPercent",
        "UsesHitsDirect",
        "Inspects",
        "InspectsAfterElimination",
        "AmmoUsed",
        "Reloads",
        "Zombies",
        "ZombiesDamageDealt",
        "ZombiesEliminations"
    },
    { { 1, "A powerful explosive launcher" } }
)
ReplicatedStorage(
    "Shorty",
    {
        "Playtime",
        "PlaytimeUnequipped",
        "RoundsPlayed",
        "RoundsWon",
        "RoundsLost",
        "RoundsWinPercent",
        "RankedRoundsPlayed",
        "RankedRoundsWon",
        "RankedRoundsLost",
        "RankedRoundsWinPercent",
        "DamageDealt",
        "DamageDealtSliding",
        "DamageDealtCrouching",
        "DamageDealtAirborne",
        "DamageDealtBlinded",
        "DamageDealtDead",
        "Eliminations",
        "EliminationsSliding",
        "EliminationsCrouching",
        "EliminationsAirborne",
        "EliminationsBlinded",
        "EliminationsDead",
        "Deaths",
        "DeathsRatio",
        "Assists",
        "AssistsDead",
        "Uses",
        "UsesHits",
        "UsesHitPercent",
        "UsesCriticalHits",
        "UsesCriticalHitPercent",
        "Inspects",
        "InspectsAfterElimination",
        "AmmoUsed",
        "Reloads",
        "Zombies",
        "ZombiesDamageDealt",
        "ZombiesEliminations"
    },
    { { 2, "A quick sidearm that can be deadly up close" } }
)
ReplicatedStorage(
    "Shotgun",
    {
        "Playtime",
        "PlaytimeUnequipped",
        "RoundsPlayed",
        "RoundsWon",
        "RoundsLost",
        "RoundsWinPercent",
        "RankedRoundsPlayed",
        "RankedRoundsWon",
        "RankedRoundsLost",
        "RankedRoundsWinPercent",
        "DamageDealt",
        "DamageDealtSliding",
        "DamageDealtCrouching",
        "DamageDealtAirborne",
        "DamageDealtBlinded",
        "DamageDealtDead",
        "Eliminations",
        "EliminationsSliding",
        "EliminationsCrouching",
        "EliminationsAirborne",
        "EliminationsBlinded",
        "EliminationsDead",
        "Deaths",
        "DeathsRatio",
        "Assists",
        "AssistsDead",
        "Uses",
        "UsesHits",
        "UsesHitPercent",
        "UsesCriticalHits",
        "UsesCriticalHitPercent",
        "Inspects",
        "InspectsAfterElimination",
        "AmmoUsed",
        "Reloads",
        "Zombies",
        "ZombiesDamageDealt",
        "ZombiesEliminations"
    },
    { { 1, "Deadly up close" } }
)
ReplicatedStorage(
    "Bow",
    {
        "Playtime",
        "PlaytimeUnequipped",
        "RoundsPlayed",
        "RoundsWon",
        "RoundsLost",
        "RoundsWinPercent",
        "RankedRoundsPlayed",
        "RankedRoundsWon",
        "RankedRoundsLost",
        "RankedRoundsWinPercent",
        "DamageDealt",
        "DamageDealtSliding",
        "DamageDealtCrouching",
        "DamageDealtAirborne",
        "DamageDealtBlinded",
        "DamageDealtDead",
        "Eliminations",
        "EliminationsSliding",
        "EliminationsCrouching",
        "EliminationsAirborne",
        "EliminationsBlinded",
        "EliminationsDead",
        "Deaths",
        "DeathsRatio",
        "Assists",
        "AssistsDead",
        "Uses",
        "UsesHits",
        "UsesHitPercent",
        "UsesCriticalHits",
        "UsesCriticalHitPercent",
        "Inspects",
        "InspectsAfterElimination",
        "AmmoUsed",
        "Reloads",
        "Zombies",
        "ZombiesDamageDealt",
        "ZombiesEliminations"
    },
    {
        { 2, "Projectile weapon that rewards accuracy" },
        { 2, "Charge up your arrows to deal heavy damage" },
        { 1, "Allows you to double jump" }
    }
)
ReplicatedStorage(
    "Uzi",
    {
        "Playtime",
        "PlaytimeUnequipped",
        "RoundsPlayed",
        "RoundsWon",
        "RoundsLost",
        "RoundsWinPercent",
        "RankedRoundsPlayed",
        "RankedRoundsWon",
        "RankedRoundsLost",
        "RankedRoundsWinPercent",
        "DamageDealt",
        "DamageDealtSliding",
        "DamageDealtCrouching",
        "DamageDealtAirborne",
        "DamageDealtBlinded",
        "DamageDealtDead",
        "Eliminations",
        "EliminationsSliding",
        "EliminationsCrouching",
        "EliminationsAirborne",
        "EliminationsBlinded",
        "EliminationsDead",
        "Deaths",
        "DeathsRatio",
        "Assists",
        "AssistsDead",
        "Uses",
        "UsesHits",
        "UsesHitPercent",
        "UsesCriticalHits",
        "UsesCriticalHitPercent",
        "Inspects",
        "InspectsAfterElimination",
        "AmmoUsed",
        "Reloads",
        "Zombies",
        "ZombiesDamageDealt",
        "ZombiesEliminations"
    },
    { { 2, "Light enemies up with this automatic sidearm" }, { 1, "Slightly inaccurate" } }
)
ReplicatedStorage(
    "Revolver",
    {
        "Playtime",
        "PlaytimeUnequipped",
        "RoundsPlayed",
        "RoundsWon",
        "RoundsLost",
        "RoundsWinPercent",
        "RankedRoundsPlayed",
        "RankedRoundsWon",
        "RankedRoundsLost",
        "RankedRoundsWinPercent",
        "DamageDealt",
        "DamageDealtSliding",
        "DamageDealtCrouching",
        "DamageDealtAirborne",
        "DamageDealtBlinded",
        "DamageDealtDead",
        "Eliminations",
        "EliminationsSliding",
        "EliminationsCrouching",
        "EliminationsAirborne",
        "EliminationsBlinded",
        "EliminationsDead",
        "Deaths",
        "DeathsRatio",
        "Assists",
        "AssistsDead",
        "Uses",
        "UsesHits",
        "UsesHitPercent",
        "UsesCriticalHits",
        "UsesCriticalHitPercent",
        "Inspects",
        "InspectsAfterElimination",
        "AmmoUsed",
        "Reloads",
        "Zombies",
        "ZombiesDamageDealt",
        "ZombiesEliminations"
    },
    { { 1, "A slow but powerful handgun" }, { 2, "Fan the hammer to unload the entire chamber" } }
)
ReplicatedStorage(
    "Paintball Gun",
    {
        "Playtime",
        "PlaytimeUnequipped",
        "RoundsPlayed",
        "RoundsWon",
        "RoundsLost",
        "RoundsWinPercent",
        "RankedRoundsPlayed",
        "RankedRoundsWon",
        "RankedRoundsLost",
        "RankedRoundsWinPercent",
        "DamageDealt",
        "DamageDealtSliding",
        "DamageDealtCrouching",
        "DamageDealtAirborne",
        "DamageDealtBlinded",
        "DamageDealtDead",
        "Eliminations",
        "EliminationsSliding",
        "EliminationsCrouching",
        "EliminationsAirborne",
        "EliminationsBlinded",
        "EliminationsDead",
        "Deaths",
        "DeathsRatio",
        "Assists",
        "AssistsDead",
        "Uses",
        "UsesHits",
        "UsesHitPercent",
        "UsesCriticalHits",
        "UsesCriticalHitPercent",
        "Inspects",
        "InspectsAfterElimination",
        "AmmoUsed",
        "Reloads",
        "PaintGrenades",
        "PaintGrenadesHits",
        "Zombies",
        "ZombiesDamageDealt",
        "ZombiesEliminations"
    },
    { { 2, "Splatter your enemies screens with this colorful rifle" } }
)
ReplicatedStorage(
    "Slingshot",
    {
        "Playtime",
        "PlaytimeUnequipped",
        "RoundsPlayed",
        "RoundsWon",
        "RoundsLost",
        "RoundsWinPercent",
        "RankedRoundsPlayed",
        "RankedRoundsWon",
        "RankedRoundsLost",
        "RankedRoundsWinPercent",
        "DamageDealt",
        "DamageDealtSliding",
        "DamageDealtCrouching",
        "DamageDealtAirborne",
        "DamageDealtBlinded",
        "DamageDealtDead",
        "DamageDealtBouncing",
        "Eliminations",
        "EliminationsSliding",
        "EliminationsCrouching",
        "EliminationsAirborne",
        "EliminationsBlinded",
        "EliminationsDead",
        "EliminationsBouncing",
        "Deaths",
        "DeathsRatio",
        "Assists",
        "AssistsDead",
        "Uses",
        "UsesHits",
        "UsesHitPercent",
        "UsesCriticalHits",
        "UsesCriticalHitPercent",
        "Inspects",
        "InspectsAfterElimination",
        "AmmoUsed",
        "Zombies",
        "ZombiesDamageDealt",
        "ZombiesEliminations"
    },
    { { 1, "Unleash a barrage of bouncy balls" } }
)
ReplicatedStorage(
    "Grenade Launcher",
    {
        "Playtime",
        "PlaytimeUnequipped",
        "RoundsPlayed",
        "RoundsWon",
        "RoundsLost",
        "RoundsWinPercent",
        "RankedRoundsPlayed",
        "RankedRoundsWon",
        "RankedRoundsLost",
        "RankedRoundsWinPercent",
        "DamageDealt",
        "DamageDealtSliding",
        "DamageDealtCrouching",
        "DamageDealtAirborne",
        "DamageDealtBlinded",
        "DamageDealtDead",
        "Eliminations",
        "EliminationsSliding",
        "EliminationsCrouching",
        "EliminationsAirborne",
        "EliminationsBlinded",
        "EliminationsDead",
        "Deaths",
        "DeathsRatio",
        "Assists",
        "AssistsDead",
        "Uses",
        "UsesHitsSelf",
        "UsesHits",
        "UsesHitPercent",
        "UsesHitsDirect",
        "Inspects",
        "InspectsAfterElimination",
        "AmmoUsed",
        "Reloads",
        "Zombies",
        "ZombiesDamageDealt",
        "ZombiesEliminations"
    },
    {
        { 2, "Quickly rain explosives on your enemies" },
        { 2, "Switch between impact grenades and bouncy grenades" }
    }
)
ReplicatedStorage(
    "Minigun",
    {
        "Playtime",
        "PlaytimeUnequipped",
        "RoundsPlayed",
        "RoundsWon",
        "RoundsLost",
        "RoundsWinPercent",
        "RankedRoundsPlayed",
        "RankedRoundsWon",
        "RankedRoundsLost",
        "RankedRoundsWinPercent",
        "DamageDealt",
        "DamageDealtSliding",
        "DamageDealtCrouching",
        "DamageDealtAirborne",
        "DamageDealtBlinded",
        "DamageDealtDead",
        "Eliminations",
        "EliminationsSliding",
        "EliminationsCrouching",
        "EliminationsAirborne",
        "EliminationsBlinded",
        "EliminationsDead",
        "Deaths",
        "DeathsRatio",
        "Assists",
        "AssistsDead",
        "Uses",
        "UsesHits",
        "UsesHitPercent",
        "UsesCriticalHits",
        "UsesCriticalHitPercent",
        "Inspects",
        "InspectsAfterElimination",
        "AmmoUsed",
        "Zombies",
        "ZombiesDamageDealt",
        "ZombiesEliminations"
    },
    { { 1, "Probably dangerous" } }
)
ReplicatedStorage(
    "Exogun",
    {
        "Playtime",
        "PlaytimeUnequipped",
        "RoundsPlayed",
        "RoundsWon",
        "RoundsLost",
        "RoundsWinPercent",
        "RankedRoundsPlayed",
        "RankedRoundsWon",
        "RankedRoundsLost",
        "RankedRoundsWinPercent",
        "DamageDealt",
        "DamageDealtSliding",
        "DamageDealtCrouching",
        "DamageDealtAirborne",
        "DamageDealtBlinded",
        "DamageDealtDead",
        "Eliminations",
        "EliminationsSliding",
        "EliminationsCrouching",
        "EliminationsAirborne",
        "EliminationsBlinded",
        "EliminationsDead",
        "Deaths",
        "DeathsRatio",
        "Assists",
        "AssistsDead",
        "Uses",
        "UsesHits",
        "UsesHitPercent",
        "UsesCriticalHits",
        "UsesCriticalHitPercent",
        "Inspects",
        "InspectsAfterElimination",
        "AmmoUsed",
        "Reloads",
        "Zombies",
        "ZombiesDamageDealt",
        "ZombiesEliminations"
    },
    { { 1, "Pew pew pew" } }
)
ReplicatedStorage(
    "Fists",
    {
        "Playtime",
        "PlaytimeUnequipped",
        "RoundsPlayed",
        "RoundsWon",
        "RoundsLost",
        "RoundsWinPercent",
        "RankedRoundsPlayed",
        "RankedRoundsWon",
        "RankedRoundsLost",
        "RankedRoundsWinPercent",
        "DamageDealt",
        "DamageDealtSliding",
        "DamageDealtCrouching",
        "DamageDealtAirborne",
        "DamageDealtBlinded",
        "DamageDealtDead",
        "Eliminations",
        "EliminationsSliding",
        "EliminationsCrouching",
        "EliminationsAirborne",
        "EliminationsBlinded",
        "EliminationsDead",
        "Deaths",
        "DeathsRatio",
        "Assists",
        "AssistsDead",
        "Uses",
        "UsesQuick",
        "UsesHits",
        "UsesHitPercent",
        "Inspects",
        "InspectsAfterElimination",
        "Zombies",
        "ZombiesDamageDealt",
        "ZombiesEliminations"
    },
    { { 1, "Allows you to double jump" } }
)
ReplicatedStorage(
    "Knife",
    {
        "Playtime",
        "PlaytimeUnequipped",
        "RoundsPlayed",
        "RoundsWon",
        "RoundsLost",
        "RoundsWinPercent",
        "RankedRoundsPlayed",
        "RankedRoundsWon",
        "RankedRoundsLost",
        "RankedRoundsWinPercent",
        "DamageDealt",
        "DamageDealtSliding",
        "DamageDealtCrouching",
        "DamageDealtAirborne",
        "DamageDealtBlinded",
        "DamageDealtDead",
        "Eliminations",
        "EliminationsSliding",
        "EliminationsCrouching",
        "EliminationsAirborne",
        "EliminationsBlinded",
        "EliminationsDead",
        "Deaths",
        "DeathsRatio",
        "Assists",
        "AssistsDead",
        "Uses",
        "UsesQuick",
        "UsesHits",
        "UsesHitPercent",
        "UsesCriticalHits",
        "UsesCriticalHitPercent",
        "Inspects",
        "InspectsAfterElimination",
        "Backstabs",
        "Zombies",
        "ZombiesDamageDealt",
        "ZombiesEliminations"
    },
    { { 2, "Backstab enemies for an instant elimination" } }
)
ReplicatedStorage(
    "Chainsaw",
    {
        "Playtime",
        "PlaytimeUnequipped",
        "RoundsPlayed",
        "RoundsWon",
        "RoundsLost",
        "RoundsWinPercent",
        "RankedRoundsPlayed",
        "RankedRoundsWon",
        "RankedRoundsLost",
        "RankedRoundsWinPercent",
        "DamageDealt",
        "DamageDealtSliding",
        "DamageDealtCrouching",
        "DamageDealtAirborne",
        "DamageDealtBlinded",
        "DamageDealtDead",
        "Eliminations",
        "EliminationsSliding",
        "EliminationsCrouching",
        "EliminationsAirborne",
        "EliminationsBlinded",
        "EliminationsDead",
        "Deaths",
        "DeathsRatio",
        "Assists",
        "AssistsDead",
        "Uses",
        "UsesQuick",
        "UsesHits",
        "UsesHitPercent",
        "Inspects",
        "InspectsAfterElimination",
        "AmmoUsed",
        "Zombies",
        "ZombiesDamageDealt",
        "ZombiesEliminations"
    },
    { { 2, "Mow enemies down at frightening speeds" } }
)
ReplicatedStorage(
    "Katana",
    {
        "Playtime",
        "PlaytimeUnequipped",
        "RoundsPlayed",
        "RoundsWon",
        "RoundsLost",
        "RoundsWinPercent",
        "RankedRoundsPlayed",
        "RankedRoundsWon",
        "RankedRoundsLost",
        "RankedRoundsWinPercent",
        "DamageDealt",
        "DamageDealtSliding",
        "DamageDealtCrouching",
        "DamageDealtAirborne",
        "DamageDealtBlinded",
        "DamageDealtDead",
        "DamageDealtDeflecting",
        "Eliminations",
        "EliminationsSliding",
        "EliminationsCrouching",
        "EliminationsAirborne",
        "EliminationsBlinded",
        "EliminationsDead",
        "EliminationsDeflecting",
        "Deaths",
        "DeathsRatio",
        "Assists",
        "AssistsDead",
        "Uses",
        "UsesQuick",
        "UsesHits",
        "UsesHitPercent",
        "Inspects",
        "InspectsAfterElimination",
        "Deflects",
        "DeflectsHits",
        "DeflectsCriticalHits",
        "Zombies",
        "ZombiesDamageDealt",
        "ZombiesEliminations"
    },
    { { 2, "Can deflect bullets back at enemies" } }
)
ReplicatedStorage(
    "Scythe",
    {
        "Playtime",
        "PlaytimeUnequipped",
        "RoundsPlayed",
        "RoundsWon",
        "RoundsLost",
        "RoundsWinPercent",
        "RankedRoundsPlayed",
        "RankedRoundsWon",
        "RankedRoundsLost",
        "RankedRoundsWinPercent",
        "DamageDealt",
        "DamageDealtSliding",
        "DamageDealtCrouching",
        "DamageDealtAirborne",
        "DamageDealtBlinded",
        "DamageDealtDead",
        "DamageDealtDashing",
        "Eliminations",
        "EliminationsSliding",
        "EliminationsCrouching",
        "EliminationsAirborne",
        "EliminationsBlinded",
        "EliminationsDead",
        "EliminationsDashing",
        "Deaths",
        "DeathsRatio",
        "Assists",
        "AssistsDead",
        "Uses",
        "UsesQuick",
        "UsesHits",
        "UsesHitPercent",
        "Inspects",
        "InspectsAfterElimination",
        "Dashes",
        "Zombies",
        "ZombiesDamageDealt",
        "ZombiesEliminations"
    },
    { { 2, "Allows you to quickly dash in any direction" } }
)
ReplicatedStorage(
    "Trowel",
    {
        "Playtime",
        "PlaytimeUnequipped",
        "RoundsPlayed",
        "RoundsWon",
        "RoundsLost",
        "RoundsWinPercent",
        "RankedRoundsPlayed",
        "RankedRoundsWon",
        "RankedRoundsLost",
        "RankedRoundsWinPercent",
        "DamageDealt",
        "DamageDealtSliding",
        "DamageDealtCrouching",
        "DamageDealtAirborne",
        "DamageDealtBlinded",
        "DamageDealtDead",
        "Eliminations",
        "EliminationsSliding",
        "EliminationsCrouching",
        "EliminationsAirborne",
        "EliminationsBlinded",
        "EliminationsDead",
        "Deaths",
        "DeathsRatio",
        "Assists",
        "AssistsDead",
        "Uses",
        "UsesQuick",
        "UsesHits",
        "UsesHitPercent",
        "Inspects",
        "InspectsAfterElimination",
        "WallsBuilt",
        "WallsBuiltBricksLayed",
        "Zombies",
        "ZombiesDamageDealt",
        "ZombiesEliminations"
    },
    {
        { 1, "Build walls to defend yourself" },
        { 2, "Send the bricks flying to harden them in place" }
    }
)
ReplicatedStorage(
    "Grenade",
    {
        "Playtime",
        "PlaytimeUnequipped",
        "RoundsPlayed",
        "RoundsWon",
        "RoundsLost",
        "RoundsWinPercent",
        "RankedRoundsPlayed",
        "RankedRoundsWon",
        "RankedRoundsLost",
        "RankedRoundsWinPercent",
        "DamageDealt",
        "DamageDealtSliding",
        "DamageDealtCrouching",
        "DamageDealtAirborne",
        "DamageDealtBlinded",
        "DamageDealtDead",
        "Eliminations",
        "EliminationsSliding",
        "EliminationsCrouching",
        "EliminationsAirborne",
        "EliminationsBlinded",
        "EliminationsDead",
        "Deaths",
        "DeathsRatio",
        "Assists",
        "AssistsDead",
        "Uses",
        "UsesQuick",
        "UsesHitsSelf",
        "UsesHits",
        "UsesHitPercent",
        "UsesCriticalHits",
        "UsesCriticalHitPercent",
        "Inspects",
        "InspectsAfterElimination",
        "Zombies",
        "ZombiesDamageDealt",
        "ZombiesEliminations"
    },
    { { 1, "Quick & reliable explosive" } }
)
ReplicatedStorage(
    "Molotov",
    {
        "Playtime",
        "PlaytimeUnequipped",
        "RoundsPlayed",
        "RoundsWon",
        "RoundsLost",
        "RoundsWinPercent",
        "RankedRoundsPlayed",
        "RankedRoundsWon",
        "RankedRoundsLost",
        "RankedRoundsWinPercent",
        "DamageDealt",
        "DamageDealtSliding",
        "DamageDealtCrouching",
        "DamageDealtAirborne",
        "DamageDealtBlinded",
        "DamageDealtDead",
        "Eliminations",
        "EliminationsSliding",
        "EliminationsCrouching",
        "EliminationsAirborne",
        "EliminationsBlinded",
        "EliminationsDead",
        "Deaths",
        "DeathsRatio",
        "Assists",
        "AssistsDead",
        "Uses",
        "UsesQuick",
        "UsesHits",
        "UsesHitPercent",
        "UsesCriticalHits",
        "UsesCriticalHitPercent",
        "Inspects",
        "InspectsAfterElimination",
        "Zombies",
        "ZombiesDamageDealt",
        "ZombiesEliminations"
    },
    { { 2, "An unethical way of setting your enemies on fire" } }
)
ReplicatedStorage(
    "Flashbang",
    {
        "Playtime",
        "PlaytimeUnequipped",
        "RoundsPlayed",
        "RoundsWon",
        "RoundsLost",
        "RoundsWinPercent",
        "RankedRoundsPlayed",
        "RankedRoundsWon",
        "RankedRoundsLost",
        "RankedRoundsWinPercent",
        "DamageDealt",
        "DamageDealtSliding",
        "DamageDealtCrouching",
        "DamageDealtAirborne",
        "DamageDealtBlinded",
        "DamageDealtDead",
        "Eliminations",
        "EliminationsSliding",
        "EliminationsCrouching",
        "EliminationsAirborne",
        "EliminationsBlinded",
        "EliminationsDead",
        "Deaths",
        "DeathsRatio",
        "Assists",
        "AssistsDead",
        "Uses",
        "UsesQuick",
        "UsesHits",
        "UsesHitPercent",
        "UsesCriticalHits",
        "UsesCriticalHitPercent",
        "Inspects",
        "InspectsAfterElimination",
        "Blinds",
        "BlindsSelf",
        "BlindsEnemies",
        "BlindsTeammates",
        "Zombies",
        "ZombiesDamageDealt",
        "ZombiesEliminations"
    },
    { { 1, "Blinds enemies for a long time" } }
)
ReplicatedStorage(
    "Smoke Grenade",
    {
        "Playtime",
        "PlaytimeUnequipped",
        "RoundsPlayed",
        "RoundsWon",
        "RoundsLost",
        "RoundsWinPercent",
        "RankedRoundsPlayed",
        "RankedRoundsWon",
        "RankedRoundsLost",
        "RankedRoundsWinPercent",
        "DamageDealt",
        "DamageDealtSliding",
        "DamageDealtCrouching",
        "DamageDealtAirborne",
        "DamageDealtBlinded",
        "DamageDealtDead",
        "Eliminations",
        "EliminationsSliding",
        "EliminationsCrouching",
        "EliminationsAirborne",
        "EliminationsBlinded",
        "EliminationsDead",
        "Deaths",
        "DeathsRatio",
        "Assists",
        "AssistsDead",
        "Uses",
        "UsesQuick",
        "UsesHits",
        "UsesHitPercent",
        "UsesCriticalHits",
        "UsesCriticalHitPercent",
        "Inspects",
        "InspectsAfterElimination",
        "Smokeds",
        "SmokedsSelf",
        "SmokedsEnemies",
        "SmokedsTeammates",
        "Extinguishes",
        "ExtinguishesPlayers",
        "ExtinguishesMolotovs",
        "ExtinguishesFlareGuns",
        "ExtinguishesFlamethrowers",
        "Zombies",
        "ZombiesDamageDealt",
        "ZombiesEliminations"
    },
    { { 3, "Creates a smoke cloud which obscures vision and extinguishes all flames" } }
)
ReplicatedStorage(
    "Medkit",
    {
        "Playtime",
        "PlaytimeUnequipped",
        "RoundsPlayed",
        "RoundsWon",
        "RoundsLost",
        "RoundsWinPercent",
        "RankedRoundsPlayed",
        "RankedRoundsWon",
        "RankedRoundsLost",
        "RankedRoundsWinPercent",
        "Deaths",
        "Uses",
        "UsesQuick",
        "Inspects",
        "InspectsAfterElimination",
        "HealsGiven"
    },
    { { 2, "Allows you to heal in the midst of a battle" } }
)
ReplicatedStorage(
    "Subspace Tripmine",
    {
        "Playtime",
        "PlaytimeUnequipped",
        "RoundsPlayed",
        "RoundsWon",
        "RoundsLost",
        "RoundsWinPercent",
        "RankedRoundsPlayed",
        "RankedRoundsWon",
        "RankedRoundsLost",
        "RankedRoundsWinPercent",
        "DamageDealt",
        "DamageDealtSliding",
        "DamageDealtCrouching",
        "DamageDealtAirborne",
        "DamageDealtBlinded",
        "DamageDealtDead",
        "Eliminations",
        "EliminationsSliding",
        "EliminationsCrouching",
        "EliminationsAirborne",
        "EliminationsBlinded",
        "EliminationsDead",
        "Deaths",
        "DeathsRatio",
        "Assists",
        "AssistsDead",
        "Uses",
        "UsesQuick",
        "UsesHitsSelf",
        "UsesHits",
        "UsesHitPercent",
        "UsesCriticalHits",
        "UsesCriticalHitPercent",
        "Inspects",
        "InspectsAfterElimination",
        "Zombies",
        "ZombiesDamageDealt",
        "ZombiesEliminations"
    },
    { { 3, "An invisible explosive that deals heavy damage and sends enemies flying" } }
)
ReplicatedStorage(
    "Flamethrower",
    {
        "Playtime",
        "PlaytimeUnequipped",
        "RoundsPlayed",
        "RoundsWon",
        "RoundsLost",
        "RoundsWinPercent",
        "RankedRoundsPlayed",
        "RankedRoundsWon",
        "RankedRoundsLost",
        "RankedRoundsWinPercent",
        "DamageDealt",
        "DamageDealtSliding",
        "DamageDealtCrouching",
        "DamageDealtAirborne",
        "DamageDealtBlinded",
        "DamageDealtDead",
        "Eliminations",
        "EliminationsSliding",
        "EliminationsCrouching",
        "EliminationsAirborne",
        "EliminationsBlinded",
        "EliminationsDead",
        "Deaths",
        "DeathsRatio",
        "Assists",
        "AssistsDead",
        "Uses",
        "UsesHits",
        "UsesHitPercent",
        "Inspects",
        "InspectsAfterElimination",
        "AmmoUsed",
        "Airblasts",
        "AirblastsHits",
        "AirblastsSmokesCleared",
        "Zombies",
        "ZombiesDamageDealt",
        "ZombiesEliminations"
    },
    { { 1, "Set your enemies on fire" }, { 2, "Use the Airblast to push enemies & smoke clouds" } }
)
ReplicatedStorage(
    "Freeze Ray",
    {
        "Playtime",
        "PlaytimeUnequipped",
        "RoundsPlayed",
        "RoundsWon",
        "RoundsLost",
        "RoundsWinPercent",
        "RankedRoundsPlayed",
        "RankedRoundsWon",
        "RankedRoundsLost",
        "RankedRoundsWinPercent",
        "Eliminations",
        "EliminationsSliding",
        "EliminationsCrouching",
        "EliminationsAirborne",
        "EliminationsBlinded",
        "EliminationsDead",
        "Deaths",
        "DeathsRatio",
        "Assists",
        "AssistsDead",
        "Uses",
        "UsesQuick",
        "UsesHits",
        "UsesHitPercent",
        "Inspects",
        "InspectsAfterElimination",
        "AmmoUsed",
        "Freezes",
        "FreezesSelf",
        "FreezesEnemies"
    },
    { { 2, "Freeze your enemies with this splash projectile weapon" } }
)
ReplicatedStorage(
    "Elixir",
    {
        "Playtime",
        "PlaytimeUnequipped",
        "RoundsPlayed",
        "RoundsWon",
        "RoundsLost",
        "RoundsWinPercent",
        "RankedRoundsPlayed",
        "RankedRoundsWon",
        "RankedRoundsLost",
        "RankedRoundsWinPercent",
        "DamageDealt",
        "DamageDealtSliding",
        "DamageDealtCrouching",
        "DamageDealtAirborne",
        "DamageDealtBlinded",
        "DamageDealtDead",
        "Eliminations",
        "EliminationsSliding",
        "EliminationsCrouching",
        "EliminationsAirborne",
        "EliminationsBlinded",
        "EliminationsDead",
        "Deaths",
        "DeathsRatio",
        "Assists",
        "AssistsDead",
        "Uses",
        "UsesQuick",
        "UsesHitsSelf",
        "UsesHits",
        "UsesHitPercent",
        "UsesCriticalHits",
        "UsesCriticalHitPercent",
        "Inspects",
        "InspectsAfterElimination",
        "HealsGiven",
        "HealsGivenTeammates",
        "Zombies",
        "ZombiesDamageDealt",
        "ZombiesEliminations"
    },
    {
        { 2, "Splash your enemies to deal damage over time" },
        { 2, "Splash your teammates to heal over time" }
    }
)
ReplicatedStorage(
    "War Horn",
    {
        "Playtime",
        "PlaytimeUnequipped",
        "RoundsPlayed",
        "RoundsWon",
        "RoundsLost",
        "RoundsWinPercent",
        "RankedRoundsPlayed",
        "RankedRoundsWon",
        "RankedRoundsLost",
        "RankedRoundsWinPercent",
        "Deaths",
        "Uses",
        "UsesQuick",
        "Inspects",
        "InspectsAfterElimination",
        "Empowers",
        "EmpowersSelf",
        "EmpowersTeammates"
    },
    { { 2, "Charge your team into battle with this global speed boost" } }
)
ReplicatedStorage(
    "Satchel",
    {
        "Playtime",
        "PlaytimeUnequipped",
        "RoundsPlayed",
        "RoundsWon",
        "RoundsLost",
        "RoundsWinPercent",
        "RankedRoundsPlayed",
        "RankedRoundsWon",
        "RankedRoundsLost",
        "RankedRoundsWinPercent",
        "DamageDealt",
        "DamageDealtSliding",
        "DamageDealtCrouching",
        "DamageDealtAirborne",
        "DamageDealtBlinded",
        "DamageDealtDead",
        "Eliminations",
        "EliminationsSliding",
        "EliminationsCrouching",
        "EliminationsAirborne",
        "EliminationsBlinded",
        "EliminationsDead",
        "Deaths",
        "DeathsRatio",
        "Assists",
        "AssistsDead",
        "Uses",
        "UsesQuick",
        "UsesHitsSelf",
        "UsesHits",
        "UsesHitPercent",
        "Inspects",
        "InspectsAfterElimination",
        "Zombies",
        "ZombiesDamageDealt",
        "ZombiesEliminations"
    },
    {
        { 2, "Stick multiple explosive charges onto walls" },
        { 2, "Detonate or shoot the satchels to cause a chain explosion" },
        { 1, "Can stick to Riot Shields" }
    }
)
ReplicatedStorage(
    "Battle Axe",
    {
        "Playtime",
        "PlaytimeUnequipped",
        "RoundsPlayed",
        "RoundsWon",
        "RoundsLost",
        "RoundsWinPercent",
        "RankedRoundsPlayed",
        "RankedRoundsWon",
        "RankedRoundsLost",
        "RankedRoundsWinPercent",
        "DamageDealt",
        "DamageDealtSliding",
        "DamageDealtCrouching",
        "DamageDealtAirborne",
        "DamageDealtBlinded",
        "DamageDealtDead",
        "DamageDealtDashing",
        "Eliminations",
        "EliminationsSliding",
        "EliminationsCrouching",
        "EliminationsAirborne",
        "EliminationsBlinded",
        "EliminationsDead",
        "EliminationsDashing",
        "Deaths",
        "DeathsRatio",
        "Assists",
        "AssistsDead",
        "Uses",
        "UsesQuick",
        "UsesHits",
        "UsesHitPercent",
        "Inspects",
        "InspectsAfterElimination",
        "Dashes",
        "Zombies",
        "ZombiesDamageDealt",
        "ZombiesEliminations"
    },
    { { 2, "Use the spin attack to slice through the competition" } }
)
ReplicatedStorage(
    "Riot Shield",
    {
        "Playtime",
        "PlaytimeUnequipped",
        "RoundsPlayed",
        "RoundsWon",
        "RoundsLost",
        "RoundsWinPercent",
        "RankedRoundsPlayed",
        "RankedRoundsWon",
        "RankedRoundsLost",
        "RankedRoundsWinPercent",
        "DamageDealt",
        "DamageDealtSliding",
        "DamageDealtCrouching",
        "DamageDealtAirborne",
        "DamageDealtBlinded",
        "DamageDealtDead",
        "DamageDealtDeflecting",
        "Eliminations",
        "EliminationsSliding",
        "EliminationsCrouching",
        "EliminationsAirborne",
        "EliminationsBlinded",
        "EliminationsDead",
        "EliminationsDeflecting",
        "Deaths",
        "DeathsRatio",
        "Assists",
        "AssistsDead",
        "Uses",
        "UsesQuick",
        "UsesHits",
        "UsesHitPercent",
        "Inspects",
        "InspectsAfterElimination",
        "Absorbs",
        "AbsorbsBehind",
        "Zombies",
        "ZombiesDamageDealt",
        "ZombiesEliminations"
    },
    {
        { 2, "Shove your enemies out of the way" },
        { 1, "Absorbs most damage sources" },
        { 2, "Absorbs damage from behind while unequipped" }
    }
)
ReplicatedStorage(
    "Scepter",
    {
        "Playtime",
        "PlaytimeUnequipped",
        "RoundsPlayed",
        "RoundsWon",
        "RoundsLost",
        "RoundsWinPercent",
        "RankedRoundsPlayed",
        "RankedRoundsWon",
        "RankedRoundsLost",
        "RankedRoundsWinPercent",
        "DamageDealt",
        "DamageDealtSliding",
        "DamageDealtCrouching",
        "DamageDealtAirborne",
        "DamageDealtBlinded",
        "DamageDealtDead",
        "Eliminations",
        "EliminationsSliding",
        "EliminationsCrouching",
        "EliminationsAirborne",
        "EliminationsBlinded",
        "EliminationsDead",
        "Deaths",
        "DeathsRatio",
        "Assists",
        "AssistsDead",
        "Uses",
        "UsesHits",
        "UsesHitPercent",
        "UsesCriticalHits",
        "UsesCriticalHitPercent",
        "Inspects",
        "InspectsAfterElimination",
        "AmmoUsed",
        "Zombies",
        "ZombiesDamageDealt",
        "ZombiesEliminations"
    },
    { { 2, "Casts a magic spell that grows in speed & power" } }
)
ReplicatedStorage(
    "Daggers",
    {
        "Playtime",
        "PlaytimeUnequipped",
        "RoundsPlayed",
        "RoundsWon",
        "RoundsLost",
        "RoundsWinPercent",
        "RankedRoundsPlayed",
        "RankedRoundsWon",
        "RankedRoundsLost",
        "RankedRoundsWinPercent",
        "DamageDealt",
        "DamageDealtSliding",
        "DamageDealtCrouching",
        "DamageDealtAirborne",
        "DamageDealtBlinded",
        "DamageDealtDead",
        "Eliminations",
        "EliminationsSliding",
        "EliminationsCrouching",
        "EliminationsAirborne",
        "EliminationsBlinded",
        "EliminationsDead",
        "Deaths",
        "DeathsRatio",
        "Assists",
        "AssistsDead",
        "Uses",
        "UsesHits",
        "UsesHitPercent",
        "UsesCriticalHits",
        "UsesCriticalHitPercent",
        "Inspects",
        "InspectsAfterElimination",
        "AmmoUsed",
        "Reloads",
        "Zombies",
        "ZombiesDamageDealt",
        "ZombiesEliminations"
    },
    {
        { 2, "Burst your enemies down with these nimble projectiles" },
        { 1, "Allows you to double jump" }
    }
)
ReplicatedStorage(
    "Energy Pistols",
    {
        "Playtime",
        "PlaytimeUnequipped",
        "RoundsPlayed",
        "RoundsWon",
        "RoundsLost",
        "RoundsWinPercent",
        "RankedRoundsPlayed",
        "RankedRoundsWon",
        "RankedRoundsLost",
        "RankedRoundsWinPercent",
        "DamageDealt",
        "DamageDealtSliding",
        "DamageDealtCrouching",
        "DamageDealtAirborne",
        "DamageDealtBlinded",
        "DamageDealtDead",
        "Eliminations",
        "EliminationsSliding",
        "EliminationsCrouching",
        "EliminationsAirborne",
        "EliminationsBlinded",
        "EliminationsDead",
        "Deaths",
        "DeathsRatio",
        "Assists",
        "AssistsDead",
        "Uses",
        "UsesHits",
        "UsesHitPercent",
        "UsesCriticalHits",
        "UsesCriticalHitPercent",
        "Inspects",
        "InspectsAfterElimination",
        "AmmoUsed",
        "Zombies",
        "ZombiesDamageDealt",
        "ZombiesEliminations"
    },
    { { 1, "Harness the power of laser beams" } }
)
ReplicatedStorage(
    "Energy Rifle",
    {
        "Playtime",
        "PlaytimeUnequipped",
        "RoundsPlayed",
        "RoundsWon",
        "RoundsLost",
        "RoundsWinPercent",
        "RankedRoundsPlayed",
        "RankedRoundsWon",
        "RankedRoundsLost",
        "RankedRoundsWinPercent",
        "DamageDealt",
        "DamageDealtSliding",
        "DamageDealtCrouching",
        "DamageDealtAirborne",
        "DamageDealtBlinded",
        "DamageDealtDead",
        "DamageDealtBouncing",
        "Eliminations",
        "EliminationsSliding",
        "EliminationsCrouching",
        "EliminationsAirborne",
        "EliminationsBlinded",
        "EliminationsDead",
        "EliminationsBouncing",
        "Deaths",
        "DeathsRatio",
        "Assists",
        "AssistsDead",
        "Uses",
        "UsesHits",
        "UsesHitPercent",
        "UsesCriticalHits",
        "UsesCriticalHitPercent",
        "Inspects",
        "InspectsAfterElimination",
        "AmmoUsed",
        "Zombies",
        "ZombiesDamageDealt",
        "ZombiesEliminations"
    },
    { { 2, "Shoots a beam of energy that can bounce off walls" } }
)
ReplicatedStorage(
    "Spray",
    {
        "Playtime",
        "PlaytimeUnequipped",
        "RoundsPlayed",
        "RoundsWon",
        "RoundsLost",
        "RoundsWinPercent",
        "RankedRoundsPlayed",
        "RankedRoundsWon",
        "RankedRoundsLost",
        "RankedRoundsWinPercent",
        "DamageDealt",
        "DamageDealtSliding",
        "DamageDealtCrouching",
        "DamageDealtAirborne",
        "DamageDealtBlinded",
        "DamageDealtDead",
        "Eliminations",
        "EliminationsSliding",
        "EliminationsCrouching",
        "EliminationsAirborne",
        "EliminationsBlinded",
        "EliminationsDead",
        "Deaths",
        "DeathsRatio",
        "Assists",
        "AssistsDead",
        "Uses",
        "UsesHits",
        "UsesHitPercent",
        "UsesCriticalHits",
        "UsesCriticalHitPercent",
        "Inspects",
        "InspectsAfterElimination",
        "AmmoUsed",
        "Reloads",
        "Zombies",
        "ZombiesDamageDealt",
        "ZombiesEliminations"
    },
    {
        { 2, "This five-round burst pistol might be illegal" },
        {
            3,
            "Loaded with illegally-modified armor-piercing-rounds that break through shields & deflects"
        }
    }
)
ReplicatedStorage(
    "Crossbow",
    {
        "Playtime",
        "PlaytimeUnequipped",
        "RoundsPlayed",
        "RoundsWon",
        "RoundsLost",
        "RoundsWinPercent",
        "RankedRoundsPlayed",
        "RankedRoundsWon",
        "RankedRoundsLost",
        "RankedRoundsWinPercent",
        "DamageDealt",
        "DamageDealtSliding",
        "DamageDealtCrouching",
        "DamageDealtAirborne",
        "DamageDealtBlinded",
        "DamageDealtDead",
        "Eliminations",
        "EliminationsSliding",
        "EliminationsCrouching",
        "EliminationsAirborne",
        "EliminationsBlinded",
        "EliminationsDead",
        "Deaths",
        "DeathsRatio",
        "Assists",
        "AssistsDead",
        "Uses",
        "UsesHits",
        "UsesHitPercent",
        "UsesCriticalHits",
        "UsesCriticalHitPercent",
        "Inspects",
        "InspectsAfterElimination",
        "AmmoUsed",
        "Reloads",
        "Zombies",
        "ZombiesDamageDealt",
        "ZombiesEliminations"
    },
    { { 1, "An agile, long-ranged weapon" } }
)
ReplicatedStorage(
    "Gunblade",
    {
        "Playtime",
        "PlaytimeUnequipped",
        "RoundsPlayed",
        "RoundsWon",
        "RoundsLost",
        "RoundsWinPercent",
        "RankedRoundsPlayed",
        "RankedRoundsWon",
        "RankedRoundsLost",
        "RankedRoundsWinPercent",
        "DamageDealt",
        "DamageDealtSliding",
        "DamageDealtCrouching",
        "DamageDealtAirborne",
        "DamageDealtBlinded",
        "DamageDealtDead",
        "DamageDealtGunMode",
        "DamageDealtBladeMode",
        "Eliminations",
        "EliminationsSliding",
        "EliminationsCrouching",
        "EliminationsAirborne",
        "EliminationsBlinded",
        "EliminationsDead",
        "EliminationsGunMode",
        "EliminationsBladeMode",
        "Deaths",
        "DeathsRatio",
        "Assists",
        "AssistsDead",
        "Uses",
        "UsesHits",
        "UsesHitPercent",
        "UsesCriticalHits",
        "UsesCriticalHitPercent",
        "Inspects",
        "InspectsAfterElimination",
        "AmmoUsed",
        "Dashes",
        "Zombies",
        "ZombiesDamageDealt",
        "ZombiesEliminations"
    },
    {
        { 2, "Shoot an enemy to switch to Blade Mode" },
        { 2, "Slash an enemy to switch to Gun Mode" },
        { 1, "Aim while in Gun Mode" },
        { 1, "Dash while in Blade Mode" }
    }
)
ReplicatedStorage(
    "Jump Pad",
    {
        "Playtime",
        "PlaytimeUnequipped",
        "RoundsPlayed",
        "RoundsWon",
        "RoundsLost",
        "RoundsWinPercent",
        "RankedRoundsPlayed",
        "RankedRoundsWon",
        "RankedRoundsLost",
        "RankedRoundsWinPercent",
        "Deaths",
        "Uses",
        "UsesQuick",
        "Inspects",
        "InspectsAfterElimination",
        "Bounces",
        "BouncesSelf",
        "BouncesTeammates",
        "BouncesEnemies"
    },
    { { 2, "Place down a jump pad for all players to use" } }
)
ReplicatedStorage(
    "Glass Cannon",
    {
        "Playtime",
        "PlaytimeUnequipped",
        "RoundsPlayed",
        "RoundsWon",
        "RoundsLost",
        "RoundsWinPercent",
        "RankedRoundsPlayed",
        "RankedRoundsWon",
        "RankedRoundsLost",
        "RankedRoundsWinPercent",
        "DamageDealt",
        "DamageDealtSliding",
        "DamageDealtCrouching",
        "DamageDealtAirborne",
        "DamageDealtBlinded",
        "DamageDealtDead",
        "Eliminations",
        "EliminationsSliding",
        "EliminationsCrouching",
        "EliminationsAirborne",
        "EliminationsBlinded",
        "EliminationsDead",
        "Deaths",
        "DeathsRatio",
        "Assists",
        "AssistsDead",
        "Uses",
        "UsesHits",
        "UsesHitPercent",
        "UsesCriticalHits",
        "UsesCriticalHitPercent",
        "Inspects",
        "InspectsAfterElimination",
        "AmmoUsed",
        "Zombies",
        "ZombiesDamageDealt",
        "ZombiesEliminations"
    },
    { { 2, "The weakest yet strongest weapon" } }
)
ReplicatedStorage(
    "Glast Shard",
    {
        "Playtime",
        "PlaytimeUnequipped",
        "RoundsPlayed",
        "RoundsWon",
        "RoundsLost",
        "RoundsWinPercent",
        "RankedRoundsPlayed",
        "RankedRoundsWon",
        "RankedRoundsLost",
        "RankedRoundsWinPercent",
        "DamageDealt",
        "DamageDealtSliding",
        "DamageDealtCrouching",
        "DamageDealtAirborne",
        "DamageDealtBlinded",
        "DamageDealtDead",
        "Eliminations",
        "EliminationsSliding",
        "EliminationsCrouching",
        "EliminationsAirborne",
        "EliminationsBlinded",
        "EliminationsDead",
        "Deaths",
        "DeathsRatio",
        "Assists",
        "AssistsDead",
        "Uses",
        "UsesQuick",
        "UsesHits",
        "UsesHitPercent",
        "UsesCriticalHits",
        "UsesCriticalHitPercent",
        "Inspects",
        "InspectsAfterElimination",
        "Zombies",
        "ZombiesDamageDealt",
        "ZombiesEliminations"
    },
    { { 2, "Literally a piece of glass" } }
)
ReplicatedStorage(
    "RNG Dice",
    {
        "Playtime",
        "PlaytimeUnequipped",
        "RoundsPlayed",
        "RoundsWon",
        "RoundsLost",
        "RoundsWinPercent",
        "RankedRoundsPlayed",
        "RankedRoundsWon",
        "RankedRoundsLost",
        "RankedRoundsWinPercent",
        "Deaths",
        "Uses",
        "UsesQuick",
        "Inspects",
        "InspectsAfterElimination"
    },
    { { 2, "Is today your lucky day?" } }
)
ReplicatedStorage(
    "Distortion",
    {
        "Playtime",
        "PlaytimeUnequipped",
        "RoundsPlayed",
        "RoundsWon",
        "RoundsLost",
        "RoundsWinPercent",
        "RankedRoundsPlayed",
        "RankedRoundsWon",
        "RankedRoundsLost",
        "RankedRoundsWinPercent",
        "DamageDealt",
        "DamageDealtSliding",
        "DamageDealtCrouching",
        "DamageDealtAirborne",
        "DamageDealtBlinded",
        "DamageDealtDead",
        "Eliminations",
        "EliminationsSliding",
        "EliminationsCrouching",
        "EliminationsAirborne",
        "EliminationsBlinded",
        "EliminationsDead",
        "Deaths",
        "DeathsRatio",
        "Assists",
        "AssistsDead",
        "Uses",
        "UsesHits",
        "UsesHitPercent",
        "UsesCriticalHits",
        "UsesCriticalHitPercent",
        "Inspects",
        "InspectsAfterElimination",
        "VortexesSpawned",
        "Zombies",
        "ZombiesDamageDealt",
        "ZombiesEliminations"
    },
    { { 2, "Trap players inside a gravitational vortex" } }
)
ReplicatedStorage(
    "Warper",
    {
        "Playtime",
        "PlaytimeUnequipped",
        "RoundsPlayed",
        "RoundsWon",
        "RoundsLost",
        "RoundsWinPercent",
        "RankedRoundsPlayed",
        "RankedRoundsWon",
        "RankedRoundsLost",
        "RankedRoundsWinPercent",
        "Deaths",
        "Uses",
        "Inspects",
        "InspectsAfterElimination",
        "PortalsSpawned"
    },
    { { 2, "Spawn two portals and instantly warp from one place to another" } }
)
ReplicatedStorage(
    "Warpstone",
    {
        "Playtime",
        "PlaytimeUnequipped",
        "RoundsPlayed",
        "RoundsWon",
        "RoundsLost",
        "RoundsWinPercent",
        "RankedRoundsPlayed",
        "RankedRoundsWon",
        "RankedRoundsLost",
        "RankedRoundsWinPercent",
        "DamageDealt",
        "DamageDealtSliding",
        "DamageDealtCrouching",
        "DamageDealtAirborne",
        "DamageDealtBlinded",
        "DamageDealtDead",
        "Eliminations",
        "EliminationsSliding",
        "EliminationsCrouching",
        "EliminationsAirborne",
        "EliminationsBlinded",
        "EliminationsDead",
        "Deaths",
        "DeathsRatio",
        "Assists",
        "AssistsDead",
        "Uses",
        "UsesQuick",
        "UsesHits",
        "UsesHitPercent",
        "UsesCriticalHits",
        "UsesCriticalHitPercent",
        "Inspects",
        "InspectsAfterElimination",
        "Warps",
        "Zombies",
        "ZombiesDamageDealt",
        "ZombiesEliminations"
    },
    { { 2, "Throw this odd stone to instantly warp away from danger" } }
)
ReplicatedStorage(
    "Maul",
    {
        "Playtime",
        "PlaytimeUnequipped",
        "RoundsPlayed",
        "RoundsWon",
        "RoundsLost",
        "RoundsWinPercent",
        "RankedRoundsPlayed",
        "RankedRoundsWon",
        "RankedRoundsLost",
        "RankedRoundsWinPercent",
        "DamageDealt",
        "DamageDealtSliding",
        "DamageDealtCrouching",
        "DamageDealtAirborne",
        "DamageDealtBlinded",
        "DamageDealtDead",
        "DamageDealtDashing",
        "Eliminations",
        "EliminationsSliding",
        "EliminationsCrouching",
        "EliminationsAirborne",
        "EliminationsBlinded",
        "EliminationsDead",
        "EliminationsDashing",
        "Deaths",
        "DeathsRatio",
        "Assists",
        "AssistsDead",
        "Uses",
        "UsesQuick",
        "UsesHits",
        "UsesHitPercent",
        "Inspects",
        "InspectsAfterElimination",
        "Leaps",
        "Slams",
        "SlamsHits",
        "Zombies",
        "ZombiesDamageDealt",
        "ZombiesEliminations"
    },
    {
        { 2, "A slow, powerful weapon that pushes enemies" },
        { 2, "Use your ability while grounded to leap into the air" },
        { 2, "Use your ability while airborne to slam into the ground" }
    }
)
ReplicatedStorage(
    "Permafrost",
    {
        "Playtime",
        "PlaytimeUnequipped",
        "RoundsPlayed",
        "RoundsWon",
        "RoundsLost",
        "RoundsWinPercent",
        "RankedRoundsPlayed",
        "RankedRoundsWon",
        "RankedRoundsLost",
        "RankedRoundsWinPercent",
        "DamageDealt",
        "DamageDealtSliding",
        "DamageDealtCrouching",
        "DamageDealtAirborne",
        "DamageDealtBlinded",
        "DamageDealtDead",
        "Eliminations",
        "EliminationsSliding",
        "EliminationsCrouching",
        "EliminationsAirborne",
        "EliminationsBlinded",
        "EliminationsDead",
        "Deaths",
        "DeathsRatio",
        "Assists",
        "AssistsDead",
        "Uses",
        "UsesHits",
        "UsesHitPercent",
        "UsesCriticalHits",
        "UsesCriticalHitPercent",
        "Inspects",
        "InspectsAfterElimination",
        "AmmoUsed",
        "Reloads",
        "Freezes",
        "FreezesSelf",
        "FreezesEnemies",
        "Zombies",
        "ZombiesDamageDealt",
        "ZombiesEliminations"
    },
    {
        { 2, "Slow your enemies down with these chilled bullets" },
        { 2, "Throw whatever's left of your magazine to freeze your enemies" }
    }
)
ReplicatedStorage(
    "Spear",
    {
        "Playtime",
        "PlaytimeUnequipped",
        "RoundsPlayed",
        "RoundsWon",
        "RoundsLost",
        "RoundsWinPercent",
        "RankedRoundsPlayed",
        "RankedRoundsWon",
        "RankedRoundsLost",
        "RankedRoundsWinPercent",
        "DamageDealt",
        "DamageDealtSliding",
        "DamageDealtCrouching",
        "DamageDealtAirborne",
        "DamageDealtBlinded",
        "DamageDealtDead",
        "Eliminations",
        "EliminationsSliding",
        "EliminationsCrouching",
        "EliminationsAirborne",
        "EliminationsBlinded",
        "EliminationsDead",
        "Deaths",
        "DeathsRatio",
        "Assists",
        "AssistsDead",
        "Uses",
        "UsesQuick",
        "UsesHits",
        "UsesHitPercent",
        "UsesCriticalHits",
        "UsesCriticalHitPercent",
        "Inspects",
        "InspectsAfterElimination",
        "AmmoUsed",
        "Throws",
        "ThrowsPierces",
        "ThrowsWalls",
        "Zombies",
        "ZombiesDamageDealt",
        "ZombiesEliminations"
    },
    {
        { 1, "Poke enemies from a distance" },
        { 2, "Throw this at your enemies to pierce through them" },
        { 2, "Throw this at a wall for it to stick and help you jump over" }
    }
)
ReplicatedStorage(
    "Grappler",
    {
        "Playtime",
        "PlaytimeUnequipped",
        "RoundsPlayed",
        "RoundsWon",
        "RoundsLost",
        "RoundsWinPercent",
        "RankedRoundsPlayed",
        "RankedRoundsWon",
        "RankedRoundsLost",
        "RankedRoundsWinPercent",
        "Deaths",
        "Uses",
        "UsesQuick",
        "Inspects",
        "InspectsAfterElimination",
        "Hooks",
        "HooksEnvironment",
        "HooksEnemies"
    },
    { { 1, "Pull yourself towards any wall" }, { 1, "Pull enemies towards you" } }
)
ReplicatedStorage(
    "Wildcat",
    {
        "Playtime",
        "PlaytimeUnequipped",
        "RoundsPlayed",
        "RoundsWon",
        "RoundsLost",
        "RoundsWinPercent",
        "RankedRoundsPlayed",
        "RankedRoundsWon",
        "RankedRoundsLost",
        "RankedRoundsWinPercent",
        "DamageDealt",
        "DamageDealtSliding",
        "DamageDealtCrouching",
        "DamageDealtAirborne",
        "DamageDealtBlinded",
        "DamageDealtDead",
        "Eliminations",
        "EliminationsSliding",
        "EliminationsCrouching",
        "EliminationsAirborne",
        "EliminationsBlinded",
        "EliminationsDead",
        "Deaths",
        "DeathsRatio",
        "Assists",
        "AssistsDead",
        "Uses",
        "UsesHits",
        "UsesHitPercent",
        "UsesCriticalHits",
        "UsesCriticalHitPercent",
        "Inspects",
        "InspectsAfterElimination",
        "AmmoUsed",
        "Reloads",
        "Zombies",
        "ZombiesDamageDealt",
        "ZombiesEliminations"
    },
    {
        { 2, "Pull downwards while shooting to control the recoil" },
        { 3, "Jungle-style magazines allow you to reload quicker than usual" }
    }
)

local function add_map(arg29, arg30) -- line: 947
    -- upvalues:
    --  [1] t (copy)

    local t_339 = {
        "Playtime",
        "RoundsPlayed",
        "RoundsWon",
        "RoundsLost",
        "RoundsWinPercent",
        "RankedRoundsPlayed",
        "RankedRoundsWon",
        "RankedRoundsLost",
        "RankedRoundsWinPercent",
        "DamageDealt",
        "DamageDealtSliding",
        "DamageDealtCrouching",
        "DamageDealtAirborne",
        "DamageDealtBlinded",
        "DamageDealtDead",
        "Eliminations",
        "EliminationsSliding",
        "EliminationsCrouching",
        "EliminationsAirborne",
        "EliminationsBlinded",
        "EliminationsDead",
        "Deaths",
        "DeathsRatio",
        "Assists",
        "AssistsDead"
    }
    local v204 = arg30 or {}

    for _, val_7 in pairs(v204) do
        table.insert(t_339, val_7)
    end

    local t_340 = {}

    for _, val_8 in pairs(t_339) do
        table.insert(t_340, "Statistic" .. val_8)
    end

    t.Maps[arg29] = { DataNames = t_340 }
end

for key_9, _ in pairs(DuelLibrary_m.Maps) do
    add_map(
        key_9,
        if key_9 ~= "Zombie Tower" then nil else {
            "Zombies",
            "ZombiesDamageDealt",
            "ZombiesEliminations",
            "ZombiesEliminations"
        }
    )
end

local function generate_visible_career_statistics() -- line: 980
    -- upvalues:
    --  [1] ShopLibrary_m (copy)
    --  [2] CONSTANTS_m (copy)
    --  [3] t (copy)

    local t_342 = {}

    for _, val_10 in pairs(
        ShopLibrary_m:GetReleasedOwnableWeapons(CONSTANTS_m.WEAPON_EARLY_ACCESS_TIME_OFFSET)
    ) do
        t_342[val_10] = true
    end

    t.CareerStatistics = t:GetCareerStatistics(t_342)
end

generate_visible_career_statistics()

local _ = function() --[[ assert_items ]] -- line: 993
    -- upvalues:
    --  [1] ItemLibrary_m (copy)
    --  [2] t (copy)

    for key_11, _ in pairs(ItemLibrary_m.Items) do
        assert(t.Items[key_11], key_11)
    end
end

for key_12, _ in pairs(ItemLibrary_m.Items) do
    assert(t.Items[key_12], key_12)
end

return t
