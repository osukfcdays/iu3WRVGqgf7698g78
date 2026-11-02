local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local Players = game:GetService("Players")
local CONSTANTS_m = require(ReplicatedStorage.Modules.CONSTANTS)
local CosmeticLibrary_m = require(ReplicatedStorage.Modules.CosmeticLibrary)
local ServerOsTime_m = require(ReplicatedStorage.Modules.ServerOsTime)
local t = { { "ranked_1v1", "ranked" }, { "ranked_2v2", "ranked" }, { "ranked_3v3", "ranked" } }
local t_32 = { UNIVERSAL_ELO_NAME = "ranked" }
local t_33 = { "rbxassetid://81577092220450" }
t_33[2] = "rbxassetid://74965952714478"
t_32.PASS_TRACK_IMAGES = t_33
t_32.SEASON_PASS_LEVELS_IN_SEASON_BUNDLE = 20
t_32.PASS_XP_PER_LEVEL_VISUAL = 10
t_32.Seasons = {}
t_32.SeasonsByVersion = {}
t_32.CurrentSeason = nil
t_32.RankProfiles = {}

function t_32.IsRankedQueue(arg1, arg2, arg3) -- line: 61
    local v1 = arg3 or arg1.CurrentSeason.Name

    for _, val in pairs(arg1.Seasons[v1].RankedQueues) do
        if val[1] == arg2 then
            return val[2]
        end
    end
end

function t_32.GetCurrentSeasonWeek(_) -- line: 71
    -- upvalues:
    --  [1] ServerOsTime_m (copy)
    --  [2] t_32 (copy)

    local v2 = ServerOsTime_m:Get()

    return (math.ceil((v2 - t_32.CurrentSeason.StartTime) / 604800))
end

function t_32.GetTimeUntilNextSeasonWeek(_) -- line: 75
    -- upvalues:
    --  [1] ServerOsTime_m (copy)
    --  [2] t_32 (copy)

    local v3 = ServerOsTime_m:Get()
    local v4 = math.ceil((v3 - t_32.CurrentSeason.StartTime) / 604800) * 7 * 24 * 60 * 60 + t_32.CurrentSeason.StartTime

    return v4 - ServerOsTime_m:Get()
end

function t_32.GetHighestELOLeaderboardRanking(_, arg7, arg8) -- line: 79
    -- upvalues:
    --  [1] CONSTANTS_m (copy)
    --  [2] ServerStorage (copy)
    --  [3] Players (copy)

    local v5 = if not CONSTANTS_m.IS_SERVER then require(
        Players.LocalPlayer.PlayerScripts.Controllers.LeaderboardController
    ) else require(ServerStorage.Services.LeaderboardService)

    if arg8 then
        return v5:GetRankingByUserID("Highest ELO", arg8)
    end

    if arg7 then
        return v5:GetRankingByValue("Highest ELO", arg7)
    end
end

function t_32.GetRank(
    arg9,
    arg10,
    arg11,
    arg12,
    arg13
) -- line: 89
    if not arg10 then
        return "Unranked"
    end

    local v6 = arg13 or arg9.CurrentSeason.RankProfile.Name
    local v7 = arg9.RankProfiles[v6]
    assert(v7 ~= nil)
    v6 = nil

    for key_1, val_1 in pairs(v7.RanksOrder) do
        local v9 = v7.Ranks[val_1]

        if arg10 < v9.RequiredELO and not v9.RequiredELOLeaderboardRanking then
            v6 = key_1 - 1
            break
        end
    end

    if not v6 then
        local v10 = arg12 or arg9:GetHighestELOLeaderboardRanking(arg10, arg11)

        for index = #v7.RanksOrder, 1, -1 do
            local v11 = v7.Ranks[v7.RanksOrder[index]]

            if
                not v11.RequiredELOLeaderboardRanking
                or arg10 >= v11.RequiredELO and (v10 or math.huge) <= v11.RequiredELOLeaderboardRanking
            then
                v6 = index
                break
            end
        end
    end

    return v7.RanksOrder[math.clamp(v6, 1, #v7.RanksOrder)]
end

function t_32.GetGloryPayout(arg14, arg15, arg16) -- line: 129
    local v12 = arg14.Seasons[arg15]
    local v13 = 0
    local v14 = 0
    local v15 = pairs
    local v16 = arg16.RankedPerformances or {}

    for _, val_2 in v15(v16) do
        v14 += 1

        if val_2.CurrentELO then
            local v17 = v12.GloryPayoutWinsInfluence * math.clamp(
                val_2.DuelsWon / v12.GloryPayoutMaxWins,
                0,
                1
            )
            v13 += v12.MaxGloryPayout * (v12.GloryPayoutELOInfluence * math.clamp(
                val_2.CurrentELO / v12.GloryPayoutMaxELO,
                0,
                1
            ) + v17)
        end
    end

    if v14 <= 0 then
        return 0
    end

    v14 = math.floor(v13 / v14)
    local sign = math.sign(v13)

    return (math.clamp(math.max(sign, v14), 0, v12.MaxGloryPayout))
end

function t_32.GetRewardSeasonPassPosition(_, arg18) -- line: 160
    -- upvalues:
    --  [1] t_32 (copy)

    for index_1 = 1, t_32.CurrentSeason.NumBattlePassTiers do
        for index_2 = 1, t_32.CurrentSeason.NumBattlePassTracks do
            local v20 = t_32.CurrentSeason.BattlePassRewards[index_1]

            if v20 then
                v20 = t_32.CurrentSeason.BattlePassRewards[index_1][index_2]
            end

            if v20 and v20.Name == arg18 then
                return index_1, index_2
            end
        end
    end
end

function t_32.FormatSeasonRankCharm(
    arg19,
    arg20,
    arg21,
    arg22,
    arg23
) -- line: 172
    -- upvalues:
    --  [1] t_32 (copy)

    assert(arg21)
    local v21 = arg23 and "#" .. arg23 or ""
    local v22 = t_32:GetRank(arg22, nil, arg23 or math.huge, arg19.Seasons[arg21].RankProfile.Name)

    for _, descendant in pairs(arg20:GetDescendants()) do
        if descendant:HasTag("CharmLeaderboardRank") then
            descendant.Text = v21
        end
    end

    if arg20:FindFirstChild("Extra") then
        for _, val_3 in pairs(arg20.Extra:GetChildren()) do
            if val_3.Name ~= v22 then
                task.defer(val_3.Destroy, val_3)
            end
        end
    end
end

local function add_rank_profile(arg24, arg25, arg26, arg27) -- line: 193
    -- upvalues:
    --  [1] t_32 (copy)

    t_32.RankProfiles[arg24] = {
        Name = arg24,
        NumPlacementDuels = arg25,
        PlacementELOMin = arg26,
        PlacementELOMax = arg27,
        LowestRankELO = math.huge,
        HighestRankELO = -math.huge,
        Ranks = {},
        RanksOrder = {},
        Groups = {},
        GroupsOrder = {}
    }
end

add_rank_profile("ranks_version1", 10, 100, 2500)

local function add_rank_group(
    arg28,
    arg29,
    arg30,
    arg31,
    arg32
) -- line: 214
    -- upvalues:
    --  [1] t_32 (copy)

    local t_35 = { Name = arg29, Color = arg30, Image = arg31, SecondaryColor = nil, Ranks = nil }
    local v25 = arg32 or Color3.fromRGB(0, 0, 0)
    t_35.SecondaryColor = v25
    t_35.Ranks = {}
    t_32.RankProfiles[arg28].Groups[arg29] = t_35
    table.insert(t_32.RankProfiles[arg28].GroupsOrder, arg29)
end

add_rank_group(
    "ranks_version1",
    "Unranked",
    Color3.fromRGB(255, 255, 255),
    "rbxassetid://111599878354131"
)
add_rank_group(
    "ranks_version1",
    "Bronze",
    Color3.fromRGB(184, 117, 69),
    "rbxassetid://73543520622815"
)
add_rank_group(
    "ranks_version1",
    "Silver",
    Color3.fromRGB(200, 200, 200),
    "rbxassetid://107898816876115"
)
add_rank_group("ranks_version1", "Gold", Color3.fromRGB(255, 215, 0), "rbxassetid://90039594400813")
add_rank_group(
    "ranks_version1",
    "Platinum",
    Color3.fromRGB(65, 255, 248),
    "rbxassetid://73345783863790"
)
add_rank_group(
    "ranks_version1",
    "Diamond",
    Color3.fromRGB(50, 159, 255),
    "rbxassetid://112183171942172"
)
add_rank_group(
    "ranks_version1",
    "Onyx",
    Color3.fromRGB(255, 114, 0),
    "rbxassetid://127982903682334"
)
add_rank_group(
    "ranks_version1",
    "Nemesis",
    Color3.fromRGB(191, 0, 255),
    "rbxassetid://116941545385923"
)
add_rank_group(
    "ranks_version1",
    "Archnemesis",
    Color3.fromRGB(0, 0, 0),
    "rbxassetid://133793956251748",
    Color3.fromRGB(31, 81, 78)
)

local function add_rank(
    arg33,
    arg34,
    arg35,
    arg36,
    arg37,
    arg38,
    arg39
) -- line: 239
    -- upvalues:
    --  [1] t_32 (copy)

    local v26 = t_32.RankProfiles[arg33]
    local t_36 = {
        RankGroupName = arg34,
        DisplayName = arg35,
        RequiredELO = arg36,
        RequiredELOLeaderboardRanking = arg39,
        Image = arg37
    }
    v26.Ranks[arg35] = t_36
    table.insert(v26.RanksOrder, arg35)

    if not arg38 then
        v26.LowestRankELO = math.min(v26.LowestRankELO, t_36.RequiredELO)
        v26.HighestRankELO = math.max(v26.HighestRankELO, t_36.RequiredELO)
    end

    if t_36.RankGroupName then
        table.insert(v26.Groups[t_36.RankGroupName].Ranks, arg35)
    end
end

local RanksVersion1 = t_32.RankProfiles.ranks_version1
local t_37 = {
    RankGroupName = "Unranked",
    DisplayName = "Unranked",
    RequiredELO = -1,
    RequiredELOLeaderboardRanking = nil,
    Image = "rbxassetid://111599878354131"
}
RanksVersion1.Ranks.Unranked = t_37
table.insert(RanksVersion1.RanksOrder, "Unranked")

if t_37.RankGroupName then
    table.insert(RanksVersion1.Groups[t_37.RankGroupName].Ranks, "Unranked")
end

add_rank(
    "ranks_version1",
    "Bronze",
    "Bronze 1",
    0,
    "rbxassetid://106623367501544"
)
add_rank(
    "ranks_version1",
    "Bronze",
    "Bronze 2",
    200,
    "rbxassetid://131795064007344"
)
add_rank(
    "ranks_version1",
    "Bronze",
    "Bronze 3",
    400,
    "rbxassetid://73543520622815"
)
add_rank(
    "ranks_version1",
    "Silver",
    "Silver 1",
    600,
    "rbxassetid://80716950169934"
)
add_rank(
    "ranks_version1",
    "Silver",
    "Silver 2",
    800,
    "rbxassetid://136100661820261"
)
add_rank(
    "ranks_version1",
    "Silver",
    "Silver 3",
    1000,
    "rbxassetid://107898816876115"
)
add_rank(
    "ranks_version1",
    "Gold",
    "Gold 1",
    1200,
    "rbxassetid://134520747948636"
)
add_rank(
    "ranks_version1",
    "Gold",
    "Gold 2",
    1400,
    "rbxassetid://114166096331502"
)
add_rank(
    "ranks_version1",
    "Gold",
    "Gold 3",
    1600,
    "rbxassetid://90039594400813"
)
add_rank(
    "ranks_version1",
    "Platinum",
    "Platinum 1",
    1800,
    "rbxassetid://133903971285645"
)
add_rank(
    "ranks_version1",
    "Platinum",
    "Platinum 2",
    2000,
    "rbxassetid://82834564754747"
)
add_rank(
    "ranks_version1",
    "Platinum",
    "Platinum 3",
    2200,
    "rbxassetid://73345783863790"
)
add_rank(
    "ranks_version1",
    "Diamond",
    "Diamond 1",
    2400,
    "rbxassetid://113997689031026"
)
add_rank(
    "ranks_version1",
    "Diamond",
    "Diamond 2",
    2600,
    "rbxassetid://88059506918419"
)
add_rank(
    "ranks_version1",
    "Diamond",
    "Diamond 3",
    2800,
    "rbxassetid://112183171942172"
)
add_rank(
    "ranks_version1",
    "Onyx",
    "Onyx 1",
    3000,
    "rbxassetid://104871954739030"
)
add_rank(
    "ranks_version1",
    "Onyx",
    "Onyx 2",
    3200,
    "rbxassetid://109012386782238"
)
add_rank(
    "ranks_version1",
    "Onyx",
    "Onyx 3",
    3400,
    "rbxassetid://127982903682334"
)
local RanksVersion1_1 = t_32.RankProfiles.ranks_version1
local t_38 = {
    RankGroupName = "Nemesis",
    DisplayName = "Nemesis",
    RequiredELO = 3600,
    RequiredELOLeaderboardRanking = nil,
    Image = "rbxassetid://116941545385923"
}
RanksVersion1_1.Ranks.Nemesis = t_38
table.insert(RanksVersion1_1.RanksOrder, "Nemesis")

if t_38.RankGroupName then
    table.insert(RanksVersion1_1.Groups[t_38.RankGroupName].Ranks, "Nemesis")
end

local RanksVersion1_2 = t_32.RankProfiles.ranks_version1
local t_39 = {
    RankGroupName = "Archnemesis",
    DisplayName = "Archnemesis",
    RequiredELO = 3600,
    RequiredELOLeaderboardRanking = 200,
    Image = "rbxassetid://133793956251748"
}
RanksVersion1_2.Ranks.Archnemesis = t_39
table.insert(RanksVersion1_2.RanksOrder, "Archnemesis")

if t_39.RankGroupName then
    table.insert(RanksVersion1_2.Groups[t_39.RankGroupName].Ranks, "Archnemesis")
end

local function add_season(
    arg40,
    arg41,
    arg42,
    arg43,
    arg44
) -- line: 284
    -- upvalues:
    --  [1] ServerOsTime_m (copy)
    --  [2] t_32 (copy)

    local t_40 = { ResetCounter = arg41, Name = arg42, Version = arg43 }
    t_40.StartTime = if arg44 > ServerOsTime_m:Get() then arg44 - 604800 else arg44
    t_40.RankProfile = nil
    t_40.RankedQueues = nil
    t_40.BypassTrustworthySpendRequirement = nil
    t_40.AccountAgeRequirement = nil
    t_40.LevelRequirement = nil
    t_40.MaximumPartyELODifference = nil
    t_40.DailyELOShields = nil
    t_40.ELOShieldMaxELOAllowed = nil
    t_40.ELODecayThreshold = nil
    t_40.ELODecayPerInactiveDay = nil
    t_40.ELODecayInactivePeriodDays = nil
    t_40.ParticipationPrizes = nil
    t_40.ParticipationPointsPerWin = nil
    t_40.ParticipationPointsPerLoss = nil
    t_40.MatchmakingStompRewardName = nil
    t_40.GloryPayoutMaxWins = nil
    t_40.GloryPayoutWinsInfluence = nil
    t_40.GloryPayoutMaxELO = nil
    t_40.GloryPayoutELOInfluence = nil
    t_40.MaxGloryPayout = nil
    t_40.TopPlayerRewardSkinName = nil
    t_40.TopPlayerLeaderboardRank = nil
    t_40.ThumbnailRankedCoverPhoto = nil
    t_40.ThumbnailRanked1v1 = nil
    t_40.ThumbnailRanked2v2 = nil
    t_40.ThumbnailRanked3v3 = nil
    t_40.BattlePassActive = false
    t_40.BattlePassTasksPerWeek = nil
    t_40.BattlePassTaskRequirements = nil
    t_40.BattlePassRewards = nil
    t_40.NumBattlePassTiers = nil
    t_40.NumBattlePassTracks = nil
    t_40.ContrabandBundleSkinName = nil
    t_40.ContrabandBundleFinisherName = nil
    t_40.ContrabandBundleWrapName = nil
    t_40.ContrabandBundleCharmName = nil
    t_40.ContrabandBundleEmoteName = nil
    t_32.Seasons[arg42] = t_40
    t_32.SeasonsByVersion[arg43] = t_40

    if arg40 then
        assert(not t_32.CurrentSeason)
        t_32.CurrentSeason = t_40
    end
end

add_season(
    false,
    5,
    "Zero",
    0,
    1740718800
)
add_season(
    false,
    0,
    "Warp",
    1,
    1758859200
)
add_season(
    false,
    0,
    "Polar",
    2,
    1765515600
)
add_season(
    true,
    0,
    "Fame",
    3,
    1777003200
)

local function add_season_ranked_details(
    arg45,
    arg46,
    arg47,
    arg48,
    arg49,
    arg50,
    arg51,
    arg52,
    arg53,
    arg54,
    arg55,
    arg56,
    arg57,
    arg58,
    arg59,
    arg60,
    arg61,
    arg62,
    arg63,
    arg64,
    arg65,
    arg66,
    arg67,
    arg68,
    arg69,
    arg70,
    arg71,
    arg72
) -- line: 347
    -- upvalues:
    --  [1] t_32 (copy)
    --  [2] CosmeticLibrary_m (copy)

    local v28 = t_32.Seasons[arg45]

    for _, val_4 in pairs(arg60) do
        local Name = val_4[2].Name
        local v29 = CosmeticLibrary_m.Cosmetics[Name]

        if v29 and not CosmeticLibrary_m.Types[v29.Type].NotCosmetic then
            CosmeticLibrary_m:ExternallySetCosmeticDescription(
                Name,
                "Earned by playing Ranked Season " .. v28.Version
            )
        end
    end

    if arg67 and arg68 then
        CosmeticLibrary_m:ExternallySetCosmeticDescription(
            arg67,
            "Given to the Top " .. arg68 .. " players from Ranked Season " .. v28.Version
        )
    end

    v28.RankProfile = t_32.RankProfiles[arg46]
    v28.RankedQueues = arg47
    v28.BypassTrustworthySpendRequirement = arg48
    v28.AccountAgeRequirement = arg49
    v28.LevelRequirement = arg50
    v28.TasksCompletedRequirement = arg51
    v28.MaximumPartyELODifference = arg52
    v28.DailyELOShields = arg53
    v28.ELOShieldMaxELOAllowed = arg54
    v28.ELODecayThreshold = arg55
    v28.ELODecayPerInactiveDay = arg56
    v28.ELODecayInactivePeriodDays = arg57
    v28.ParticipationPrizes = arg60
    v28.ParticipationPointsPerWin = arg58
    v28.ParticipationPointsPerLoss = arg59
    v28.MatchmakingStompRewardName = arg61
    v28.GloryPayoutMaxWins = arg62
    v28.GloryPayoutWinsInfluence = arg63
    v28.GloryPayoutMaxELO = arg64
    v28.GloryPayoutELOInfluence = arg65
    v28.MaxGloryPayout = arg66
    v28.TopPlayerRewardSkinName = arg67
    v28.TopPlayerLeaderboardRank = arg68
    v28.ThumbnailRankedCoverPhoto = arg69
    v28.ThumbnailRanked1v1 = arg70
    v28.ThumbnailRanked2v2 = arg71
    v28.ThumbnailRanked3v3 = arg72
    assert(if CosmeticLibrary_m.Cosmetics["Season " .. v28.Version] == nil then false else true)
end

add_season_ranked_details(
    "Zero",
    "ranks_version1",
    t,
    0,
    14,
    30,
    0,
    800,
    1,
    1800,
    3000,
    100,
    7,
    5,
    0,
    { { 1000, { Name = "Phoenix Rifle", Weapon = "Assault Rifle" } } },
    nil,
    250,
    0.5,
    3600,
    0.5,
    2500,
    "Arch Katana",
    200,
    "rbxassetid://103123155567436",
    "rbxassetid://103123155567436",
    "rbxassetid://94210614848859",
    "rbxassetid://136241323883086"
)
add_season_ranked_details(
    "Warp",
    "ranks_version1",
    t,
    0,
    14,
    30,
    0,
    800,
    1,
    1800,
    3000,
    100,
    7,
    5,
    0,
    {
        { 50, { Name = "Mini Unstable Portal", Weapon = "IsUniversal" } },
        { 100, { Name = "Glory", Quantity = 100 } },
        { 200, { Name = "Spiral", Weapon = "IsUniversal" } },
        { 300, { Name = "Glory", Quantity = 150 } },
        { 500, { Name = "Warped Away", Weapon = "IsUniversal" } },
        { 750, { Name = "Glory", Quantity = 250 } },
        { 1000, { Name = "Warp Handgun", Weapon = "Handgun" } }
    },
    nil,
    250,
    0.5,
    3600,
    0.5,
    2500,
    "Arch Crossbow",
    200,
    "rbxassetid://108294156233914",
    "rbxassetid://108294156233914",
    "rbxassetid://74079396411050",
    "rbxassetid://131383109536840"
)
add_season_ranked_details(
    "Polar",
    "ranks_version1",
    t,
    1,
    14,
    50,
    30,
    800,
    1,
    1800,
    3000,
    100,
    7,
    5,
    0,
    {
        { 50, { Name = "Snowman", Weapon = "IsUniversal" } },
        { 100, { Name = "Glory", Quantity = 100 } },
        { 200, { Name = "Tusky", Weapon = "IsUniversal" } },
        { 300, { Name = "Glory", Quantity = 150 } },
        { 500, { Name = "Northern Light Show", Weapon = "IsUniversal" } },
        { 750, { Name = "Glory", Quantity = 250 } },
        { 1000, { Name = "Frozen Grenade", Weapon = "Grenade" } }
    },
    nil,
    250,
    0.5,
    3600,
    0.5,
    2500,
    "Arch Molotov",
    200,
    "rbxassetid://76786660109423",
    "rbxassetid://77500396480714",
    "rbxassetid://76786660109423",
    "rbxassetid://103544907023810"
)
add_season_ranked_details(
    "Fame",
    "ranks_version1",
    t,
    200,
    14,
    100,
    30,
    800,
    1,
    1800,
    3000,
    100,
    7,
    5,
    0,
    {
        { 50, { Name = "Horseshoe", Weapon = "IsUniversal" } },
        { 100, { Name = "Glory", Quantity = 50 } },
        { 200, { Name = "Mesa", Weapon = "IsUniversal" } },
        { 300, { Name = "Glory", Quantity = 100 } },
        { 400, { Name = "Paparazzi Flash", Weapon = "IsUniversal" } },
        { 500, { Name = "Glory", Quantity = 150 } },
        { 600, { Name = "Standoff" } },
        { 750, { Name = "Glory", Quantity = 200 } },
        { 1000, { Name = "Spy Gloves", Weapon = "Fists" } }
    },
    "Season 3 Stomp",
    250,
    0.65,
    3600,
    0.35,
    2500,
    "Arch Uzi",
    200,
    "rbxassetid://105428897961077",
    "rbxassetid://76704907616030",
    "rbxassetid://96045696868067",
    "rbxassetid://73857466226252"
)

local function add_season_battlepass_details(
    arg73,
    arg74,
    arg75,
    arg76,
    arg77,
    arg78,
    arg79,
    arg80,
    arg81
) -- line: 413
    -- upvalues:
    --  [1] t_32 (copy)
    --  [2] CosmeticLibrary_m (copy)

    local v33 = t_32.Seasons[arg73]
    local SeasonPasses_m = require(script:WaitForChild("SeasonPasses"):WaitForChild(arg73))
    local JunkRewards = SeasonPasses_m.JunkRewards
    local RawRewards = SeasonPasses_m.RawRewards

    for _, val_5 in pairs(JunkRewards) do
        table.sort(val_5, function(arg82, arg83) -- line: 423
            return arg82.Chance < arg83.Chance
        end)
    end

    local v36 = 0

    local function get_junk_reward(arg84) -- line: 430
        -- upvalues:
        --  [1] v36 (ref)
        --  [2] JunkRewards (copy)

        v36 += 1
        local v37 = Random.new(v36):NextNumber()
        local v38 = JunkRewards[arg84]
        local v39 = v38[#v38]

        for _, val_6 in pairs(v38) do
            if v37 <= val_6.Chance then
                v39 = val_6
                break
            end
        end

        return table.clone(v39.RewardData)
    end

    local v40 = 0
    local v41 = 0

    for key_8, val_7 in pairs(RawRewards) do
        v40 = math.max(v40, key_8)

        for key_9, _ in pairs(val_7) do
            v41 = math.max(v41, key_9)
        end
    end

    for index_3 = 1, v40 do
        local v42 = RawRewards[index_3] or {}
        RawRewards[index_3] = v42

        for index_4 = 1, v41 do
            if index_3 ~= 1 or index_4 ~= 1 then
                local v43 = RawRewards[index_3][index_4]
                local v44 = RawRewards[index_3]
                v43 = v43 or get_junk_reward(index_4)
                v44[index_4] = v43
            end
        end
    end

    for _, val_9 in pairs({ arg77, arg78, arg79, arg80, arg81 }) do
        CosmeticLibrary_m:ExternallySetCosmeticDescription(
            val_9,
            "Included in the Contraband Bundle from Season " .. v33.Version
        )
    end

    for index_5 = 1, v40 do
        for index_6 = 1, v41 do
            local v46 = RawRewards[index_5][index_6]
            local v47 = v46

            if v47 then
                v47 = CosmeticLibrary_m.Cosmetics[v46.Name]
            end

            if v47 and not v47.Description and not v47.DescriptionSpecific then
                CosmeticLibrary_m:ExternallySetCosmeticDescription(
                    v46.Name,
                    "Earned from the Season Pass during Season " .. v33.Version
                )
            end
        end
    end

    v33.BattlePassActive = true
    v33.BattlePassTasksPerWeek = arg74
    v33.BattlePassTaskRequirements = { RoundsWon = arg75, Playtime = arg76 }
    v33.BattlePassRewards = RawRewards
    v33.NumBattlePassTiers = v40
    v33.NumBattlePassTracks = v41
    v33.ContrabandBundleSkinName = arg77
    v33.ContrabandBundleFinisherName = arg78
    v33.ContrabandBundleWrapName = arg79
    v33.ContrabandBundleCharmName = arg80
    v33.ContrabandBundleEmoteName = arg81
end

add_season_battlepass_details(
    "Warp",
    7,
    25,
    1200,
    "Electropunk Warper",
    "Spaghettified",
    "Encroached",
    "Warp Disc",
    "Portal Glitch"
)
add_season_battlepass_details(
    "Polar",
    7,
    25,
    1200,
    nil,
    "Giant Snowball",
    "Ice Queen",
    "Cryo Capsule",
    "It's Time"
)
add_season_battlepass_details(
    "Fame",
    7,
    25,
    1200,
    "Giant Pencil",
    "BANG!",
    "Crime Scene",
    "Duely Award",
    "Police Car"
)

return t_32
