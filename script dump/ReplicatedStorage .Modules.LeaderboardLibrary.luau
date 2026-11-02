local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CONSTANTS_m = require(ReplicatedStorage.Modules.CONSTANTS)
local SeasonLibrary_m = require(ReplicatedStorage.Modules.SeasonLibrary)
local _ = require(ReplicatedStorage.Modules.Utility)
local t = { REFRESH_TIME = 60, Info = {}, Order = {}, DisplayInfo = {} }

local _ = function(
    arg1,
    arg2,
    arg3,
    arg4,
    arg5,
    arg6,
    arg7
) --[[ add_leaderboard ]] -- line: 18
    -- upvalues:
    --  [1] CONSTANTS_m (copy)
    --  [2] t (copy)

    if arg6 and CONSTANTS_m.IS_CLIENT then
        return
    end

    local t_1 = {
        Name = arg1,
        DataStoreKey = arg2,
        NumPlayers = arg3,
        IsAscending = arg4,
        UpdateCycle = arg5,
        HiddenFromClient = arg6,
        IsReadOnly = arg7
    }
    t.Info[t_1.Name] = t_1
    table.insert(t.Order, t_1.Name)
end

local t_2 = {
    Name = "Highest ELO",
    DataStoreKey = "HighestELO3_" .. SeasonLibrary_m.CurrentSeason.Version,
    NumPlayers = 250,
    IsAscending = false,
    UpdateCycle = nil,
    HiddenFromClient = nil,
    IsReadOnly = nil
}
t.Info[t_2.Name] = t_2
table.insert(t.Order, t_2.Name)

if not CONSTANTS_m.IS_CLIENT then
    local t_3 = {
        Name = "Highest ELO Last Season",
        DataStoreKey = "HighestELO3_" .. SeasonLibrary_m.CurrentSeason.Version - 1,
        NumPlayers = 250,
        IsAscending = false,
        UpdateCycle = nil,
        HiddenFromClient = true,
        IsReadOnly = true
    }
    t.Info[t_3.Name] = t_3
    table.insert(t.Order, t_3.Name)
end

if not CONSTANTS_m.IS_CLIENT then
    local t_4 = {
        Name = "Top Players Before Season 0 Reset",
        DataStoreKey = "HighestELO_0",
        NumPlayers = 100,
        IsAscending = false,
        UpdateCycle = nil,
        HiddenFromClient = true,
        IsReadOnly = true
    }
    t.Info[t_4.Name] = t_4
    table.insert(t.Order, t_4.Name)
end

local t_5 = {
    Name = "Current Highest Win Streak",
    DataStoreKey = "WinStreakCurrent_1",
    NumPlayers = 100,
    IsAscending = false,
    UpdateCycle = 86400,
    HiddenFromClient = nil,
    IsReadOnly = nil
}
t.Info[t_5.Name] = t_5
table.insert(t.Order, t_5.Name)
local t_6 = {
    Name = "Most Eliminations",
    DataStoreKey = "Eliminations_1",
    NumPlayers = 100,
    IsAscending = false,
    UpdateCycle = nil,
    HiddenFromClient = nil,
    IsReadOnly = nil
}
t.Info[t_6.Name] = t_6
table.insert(t.Order, t_6.Name)
local t_7 = {
    Name = "Most Wins",
    DataStoreKey = "Wins_1",
    NumPlayers = 100,
    IsAscending = false,
    UpdateCycle = nil,
    HiddenFromClient = nil,
    IsReadOnly = nil
}
t.Info[t_7.Name] = t_7
table.insert(t.Order, t_7.Name)
local t_8 = {
    Name = "Highest Level",
    DataStoreKey = "Level_1",
    NumPlayers = 100,
    IsAscending = false,
    UpdateCycle = nil,
    HiddenFromClient = nil,
    IsReadOnly = nil
}
t.Info[t_8.Name] = t_8
table.insert(t.Order, t_8.Name)

if not CONSTANTS_m.IS_CLIENT then
    local t_9 = {
        Name = "Highest Win Streak Ever",
        DataStoreKey = "WinStreakHighest_1",
        NumPlayers = 100,
        IsAscending = false,
        UpdateCycle = nil,
        HiddenFromClient = true,
        IsReadOnly = nil
    }
    t.Info[t_9.Name] = t_9
    table.insert(t.Order, t_9.Name)
end

if not CONSTANTS_m.IS_CLIENT then
    local t_10 = {
        Name = "Current Highest True Streak",
        DataStoreKey = "TrueStreakCurrent_1",
        NumPlayers = 100,
        IsAscending = false,
        UpdateCycle = nil,
        HiddenFromClient = true,
        IsReadOnly = nil
    }
    t.Info[t_10.Name] = t_10
    table.insert(t.Order, t_10.Name)
end

if not CONSTANTS_m.IS_CLIENT then
    local t_11 = {
        Name = "Most Robux Spent",
        DataStoreKey = "RobuxSpent_1",
        NumPlayers = 100,
        IsAscending = false,
        UpdateCycle = nil,
        HiddenFromClient = true,
        IsReadOnly = nil
    }
    t.Info[t_11.Name] = t_11
    table.insert(t.Order, t_11.Name)
end

if not CONSTANTS_m.IS_CLIENT then
    local t_12 = {
        Name = "Most Ranked Wins",
        DataStoreKey = "RankedWins_" .. SeasonLibrary_m.CurrentSeason.Version,
        NumPlayers = 100,
        IsAscending = false,
        UpdateCycle = nil,
        HiddenFromClient = true,
        IsReadOnly = nil
    }
    t.Info[t_12.Name] = t_12
    table.insert(t.Order, t_12.Name)
end

if not CONSTANTS_m.IS_CLIENT then
    local t_13 = {
        Name = "Highest Ranked Win Percent",
        DataStoreKey = "RankedWinPercent_" .. SeasonLibrary_m.CurrentSeason.Version,
        NumPlayers = 100,
        IsAscending = false,
        UpdateCycle = nil,
        HiddenFromClient = true,
        IsReadOnly = nil
    }
    t.Info[t_13.Name] = t_13
    table.insert(t.Order, t_13.Name)
end

if not CONSTANTS_m.IS_CLIENT then
    local t_14 = {
        Name = "Largest Data Size",
        DataStoreKey = "DataSize_1",
        NumPlayers = 100,
        IsAscending = false,
        UpdateCycle = nil,
        HiddenFromClient = true,
        IsReadOnly = nil
    }
    t.Info[t_14.Name] = t_14
    table.insert(t.Order, t_14.Name)
end

local function add_leaderboard_display(
    arg8,
    arg9,
    arg10,
    arg11,
    arg12,
    arg13,
    arg14,
    arg15,
    arg16
) -- line: 56
    -- upvalues:
    --  [1] t (copy)

    local t_15 = {
        Name = arg8,
        DisplayID = arg9,
        DisplayName = arg10,
        Icon = arg11,
        IconFilled = arg12,
        SanitizeUsernames = arg13,
        LiveDisplayEnabled = arg14,
        TextPosition = arg15 or UDim2.new(0.5, 0, 0.5, 0),
        ColorSequence = arg16 or ColorSequence.new(Color3.fromRGB(255, 255, 255)),
        DarkColorSequence = nil
    }
    t.DisplayInfo[arg8] = t_15
    local t_16 = {}

    for _, val in pairs(t_15.ColorSequence.Keypoints) do
        table.insert(
            t_16,
            ColorSequenceKeypoint.new(
                val.Time,
                Color3.new(val.Value.R * 0.75, val.Value.G * 0.75, val.Value.B * 0.75)
            )
        )
    end

    t_15.DarkColorSequence = ColorSequence.new(t_16)
end

add_leaderboard_display(
    "Current Highest Win Streak",
    nil,
    "Win Streaks                   ",
    "rbxassetid://17175092502",
    "rbxassetid://17175117593",
    nil,
    true,
    UDim2.new(0.5, 0, 0.65, 0),
    ColorSequence.new(Color3.fromRGB(255, 0, 0), Color3.fromRGB(255, 157, 0))
)
add_leaderboard_display(
    "Most Eliminations",
    nil,
    "Most Eliminations",
    "rbxassetid://17736782213",
    "rbxassetid://17736752966",
    nil,
    nil,
    UDim2.new(0.5, 0, 0.5, 0),
    ColorSequence.new(Color3.fromRGB(106, 22, 22), Color3.fromRGB(255, 51, 51))
)
add_leaderboard_display(
    "Most Wins",
    nil,
    "Most Wins",
    "rbxassetid://17175095665",
    "rbxassetid://17175117401",
    nil,
    nil,
    UDim2.new(0.5, 0, 0.4, 0),
    ColorSequence.new(
        {
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 204, 0)),
            ColorSequenceKeypoint.new(0.542, Color3.fromRGB(255, 209, 27)),
            ColorSequenceKeypoint.new(0.856, Color3.fromRGB(255, 229, 131)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
        }
    )
)
add_leaderboard_display(
    "Highest Level",
    nil,
    "Highest Level",
    "rbxassetid://81461991645938",
    "rbxassetid://72402714013244",
    nil,
    nil,
    UDim2.new(0.5, 0, 0.5, 0),
    ColorSequence.new(
        {
            ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 89, 255)),
            ColorSequenceKeypoint.new(0.342, Color3.fromRGB(2, 173, 253)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(151, 250, 255))
        }
    )
)
add_leaderboard_display(
    "Highest Win Streak Ever",
    nil,
    "Best Win Streaks",
    "rbxassetid://17175092502",
    "rbxassetid://17175117593",
    nil,
    nil,
    UDim2.new(0.5, 0, 0.65, 0),
    ColorSequence.new(Color3.fromRGB(255, 0, 0), Color3.fromRGB(255, 157, 0))
)
add_leaderboard_display(
    "Highest ELO",
    "RankedLB",
    "Ranked                             ",
    "rbxassetid://117835427046796",
    "rbxassetid://89838302386905",
    true,
    true
)

return t
