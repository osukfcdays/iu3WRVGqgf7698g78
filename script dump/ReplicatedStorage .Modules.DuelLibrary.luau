local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CONSTANTS_m = require(ReplicatedStorage.Modules.CONSTANTS)
local SeasonLibrary_m = require(ReplicatedStorage.Modules.SeasonLibrary)
local _ = require(ReplicatedStorage.Modules.EventLibrary)
local ServerOsTime_m = require(ReplicatedStorage.Modules.ServerOsTime)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local t = {
    Color3.fromRGB(255, 50, 50),
    Color3.fromRGB(255, 150, 0),
    Color3.fromRGB(255, 215, 0),
    Color3.fromRGB(100, 255, 50),
    Color3.fromRGB(0, 150, 255),
    Color3.fromRGB(161, 53, 255),
    Color3.fromRGB(255, 140, 244)
}
local t_1 = { MAX_TEAMS = 0, EMPTY_TEAM_COLOR = Color3.fromRGB(127, 127, 127) }
t_1.APRIL_FOOLS_QUEUES = { "ltm_easyexploits_2v2", "ltm_easyexploits_3v3" }
t_1.NEW_MAP_RELEASE_DURATION = 1209600
t_1.Teams = {}
t_1.TeamsByID = {}
t_1.MapDifficulties = {}
t_1.Maps = {}
t_1.MapTags = {}
t_1.MapOrder = {}
t_1.HiddenMapOrder = {}
t_1.PlaySourceTypes = {}
t_1.PlaySources = {}
t_1.PlaySourceOrder = {}
t_1.MatchmakingQueues = {}
t_1.MatchmakingQueueOrder = {}
t_1.MatchmakingQueueDuelLogicToQueueName = {}
t_1.MatchmakingQueueDisplayNameToQueueName = {}
t_1.ArcadeModes = {}
t_1.ArcadeModeOrder = {}
t_1.ArcadeModeByPlaceID = {}
t_1._assigned_color_count = 0
t_1._arcade_mode_display_names = nil
t_1._arcade_mode_display_name_to_arcade_name = nil

function t_1.GetArcadeModeDisplayNames(arg1) -- line: 48
    if not arg1._arcade_mode_display_names then
        arg1._arcade_mode_display_names = {}
        arg1._arcade_mode_display_name_to_arcade_name = {}

        for _, val in pairs(arg1.ArcadeModeOrder) do
            local DisplayName = arg1.ArcadeModes[val].DisplayName
            table.insert(arg1._arcade_mode_display_names, arg1.ArcadeModes[val].DisplayName)
            arg1._arcade_mode_display_name_to_arcade_name[DisplayName] = val
        end
    end

    return arg1._arcade_mode_display_names, arg1._arcade_mode_display_name_to_arcade_name
end

function t_1.GetTeamColor(arg2, arg3, arg4, arg5) -- line: 63
    return arg3 and arg2.TeamsByID[arg3] and arg2.TeamsByID[arg3][arg5 or "Color"] or arg4 or arg2.EMPTY_TEAM_COLOR
end

function t_1.GetMaps(
    arg6,
    arg7,
    arg8,
    arg9,
    arg10
) -- line: 67
    -- upvalues:
    --  [1] Utility_m (copy)

    local v2 = arg6.PlaySources[arg9]
    local v3 = v2 and v2.MapPool
    local v4 = v2
    local v5

    if v4 then
        v4 = v2.IsRigidMapPool

        if v4 then
            v5 = arg10 and v2 and v2.Type == "ArcadeMode"
            v4 = not v5
        end
    end

    v5 = arg10

    if v5 then
        v5 = not v4
    end

    if not v5 and v3 then
        return Utility_m:CloneTable(v3)
    end

    v4 = v2 and v2.Type == "ArcadeMode"
    local t_3 = {}

    for key_1, val_1 in pairs(arg6.Maps) do
        if not val_1.IsHidden then
            local v6 = v5 or arg7 >= val_1.MinimumPlayersRequired and not val_1.DontAutomaticallyAddToMapPools

            if v6 and arg8 <= val_1.MaximumTeamsSupported and (not v4 or val_1.SupportsArcadeMode) then
                table.insert(t_3, key_1)
            elseif v6 and v4 and v5 then
                table.insert(t_3, key_1)
            end
        end
    end

    local v10 = v3 or {}

    for _, val_2 in pairs(v10) do
        if not table.find(t_3, val_2) then
            table.insert(t_3, val_2)
        end
    end

    return t_3
end

function t_1.GetFirstQueueNameByDuelLogic(arg11, arg12) -- line: 105
    for _, val_3 in pairs(arg11.PlaySourceOrder) do
        if arg11.PlaySources[val_3].DuelLogic == arg12 then
            return val_3
        end
    end
end

function t_1.SortMaps(arg13, arg14, arg15) -- line: 113
    -- upvalues:
    --  [1] ServerOsTime_m (copy)
    --  [2] Utility_m (copy)

    local v12 = ServerOsTime_m:Get() < arg13.Maps[arg14].ReleaseTime + arg13.NEW_MAP_RELEASE_DURATION and true
    local v11 = ServerOsTime_m:Get() < arg13.Maps[arg15].ReleaseTime + arg13.NEW_MAP_RELEASE_DURATION and true
    local v13 = if v12 then arg13.Maps[arg14].ReleaseTime else -1
    v12 = if not v11 then -1 else arg13.Maps[arg15].ReleaseTime

    if v13 ~= v12 then
        return v12 < v13
    end

    v13 = arg13.MapDifficulties[arg13.Maps[arg14].Difficulty].Value
    v11 = arg13.MapDifficulties[arg13.Maps[arg15].Difficulty].Value

    if v13 ~= v11 then
        return v11 > v13
    end

    return Utility_m:StringLessThan(arg14, arg15)
end

local function add_team(
    arg16,
    arg17,
    arg18,
    arg19,
    arg20,
    arg21
) -- line: 134
    -- upvalues:
    --  [1] t_1 (copy)

    local t_4 = {
        TeamIndex = arg16,
        TeamID = utf8.char(arg16),
        TeamName = arg17,
        Logo = arg18 or "",
        Color = arg19,
        PadColor = arg20,
        PadColor2 = arg21
    }
    t_1.Teams[t_4.TeamIndex] = t_4
    t_1.TeamsByID[t_4.TeamID] = t_4
    local v16 = t_1
    v16.MAX_TEAMS += 1
end

add_team(
    1,
    "Sensei Global",
    "rbxassetid://97418037278150",
    Color3.fromRGB(255, 215, 0),
    Color3.fromRGB(163, 135, 51),
    Color3.fromRGB(194, 161, 61)
)
add_team(
    2,
    "Nosniy Inc.",
    "rbxassetid://114213660098262",
    Color3.fromRGB(116, 61, 255),
    Color3.fromRGB(125, 74, 162),
    Color3.fromRGB(180, 115, 255)
)
add_team(
    3,
    "Neko Labs",
    "rbxassetid://126657764282293",
    Color3.fromRGB(0, 150, 255),
    Color3.fromRGB(74, 112, 161),
    Color3.fromRGB(0, 115, 191)
)

local _ = function(arg22, arg23, arg24) --[[ add_map_difficulty ]] -- line: 154
    -- upvalues:
    --  [1] t_1 (copy)

    t_1.MapDifficulties[arg23] = { Value = arg22, Color = arg24 }
end

t_1.MapDifficulties.None = { Value = 0, Color = Color3.fromRGB(60, 60, 60) }
t_1.MapDifficulties.Easy = { Value = 1, Color = Color3.fromRGB(100, 255, 50) }
t_1.MapDifficulties.Medium = { Value = 2, Color = Color3.fromRGB(255, 215, 0) }
t_1.MapDifficulties.Hard = { Value = 3, Color = Color3.fromRGB(255, 50, 50) }
t_1.MapDifficulties.Secret = { Value = 4, Color = Color3.fromRGB(255, 255, 255) }

local _ = function(arg25, arg26, arg27, arg28) --[[ add_map_tag ]] -- line: 169
    -- upvalues:
    --  [1] t_1 (copy)

    local t_11 = { Name = arg25, DisplayName = arg26, Color = arg27, SecondaryColor = nil }
    local v17 = arg28 or Color3.fromRGB(255, 255, 255)
    t_11.SecondaryColor = v17
    t_1.MapTags[arg25] = t_11
end

local color_12, color_ret2 = Color3.fromRGB(255, 50, 50)
local t_12 = {
    Name = "tag_newrelease",
    DisplayName = "NEW RELEASE",
    Color = color_12,
    SecondaryColor = color_ret2 or Color3.fromRGB(255, 255, 255)
}
t_1.MapTags.tag_newrelease = t_12
local color_13 = Color3.fromRGB(44, 255, 248)
local t_13 = {
    Name = "tag_experimental",
    DisplayName = "Experimental",
    Color = color_13,
    SecondaryColor = nil
}
local v19 = Color3.fromRGB(0, 0, 0) or Color3.fromRGB(255, 255, 255)
t_13.SecondaryColor = v19
t_1.MapTags.tag_experimental = t_13

local function add_map(
    arg29,
    arg30,
    arg31,
    arg32,
    arg33,
    _,
    arg35,
    arg36,
    arg37,
    arg38,
    arg39,
    arg40,
    arg41,
    arg42
) -- line: 183
    -- upvalues:
    --  [1] t_1 (copy)
    --  [2] CONSTANTS_m (copy)

    local t_14 = {
        IsHidden = arg29,
        ReleaseTime = arg30 or 0,
        Image = arg32,
        Description = arg42,
        Difficulty = arg33,
        MinimumPlayersRequired = 1,
        MaximumTeamsSupported = arg35,
        ShuffleSpawnsUniversally = arg36,
        DontAutomaticallyAddToMapPools = arg37,
        SupportsArcadeMode = arg38,
        Creators = arg39 or {},
        Contributors = arg40 or {},
        MapTag = arg41,
        PlaySources = {}
    }
    t_1.Maps[arg31] = t_14
    table.insert(t_1.HiddenMapOrder, arg31)

    if not t_14.IsHidden or CONSTANTS_m.IS_TESTING_SERVER then
        table.insert(t_1.MapOrder, arg31)
    end
end

add_map(
    nil,
    1766548800,
    "Village",
    "rbxassetid://78458667507109",
    "Easy",
    1,
    2,
    nil,
    nil,
    nil,
    { "GreatGuyBoom" },
    nil
)
add_map(
    nil,
    1766548800,
    "Iceberg",
    "rbxassetid://110713820813038",
    "Medium",
    1,
    2,
    nil,
    nil,
    nil,
    { "Nosniy" },
    nil
)
add_map(
    nil,
    nil,
    "Backrooms",
    "rbxassetid://78425568447137",
    "Easy",
    1,
    2,
    nil,
    nil,
    nil,
    { "Nosniy" },
    nil
)
add_map(
    nil,
    nil,
    "Arena",
    "rbxassetid://108088064658436",
    "Easy",
    1,
    2,
    nil,
    nil,
    nil,
    { "Nosniy" },
    nil
)
add_map(
    nil,
    nil,
    "Dimension",
    "rbxassetid://78851598956506",
    "Hard",
    1,
    2,
    nil,
    nil,
    nil,
    { "GreatGuyBoom" },
    nil
)
add_map(
    nil,
    nil,
    "Bridge",
    "rbxassetid://110835255645526",
    "Easy",
    1,
    2,
    nil,
    nil,
    nil,
    { "GreatGuyBoom" },
    nil
)
add_map(
    nil,
    1777003200,
    "Museum",
    "rbxassetid://80495049076353",
    "Medium",
    5,
    3,
    nil,
    nil,
    true,
    { "GreatGuyBoom" },
    nil
)
add_map(
    nil,
    nil,
    "Graveyard",
    "rbxassetid://129215409539945",
    "Medium",
    1,
    2,
    nil,
    nil,
    nil,
    { "GreatGuyBoom" },
    nil
)
add_map(
    nil,
    1777003200,
    "Studio",
    "rbxassetid://113589926222762",
    "Easy",
    1,
    2,
    nil,
    nil,
    nil,
    { "GreatGuyBoom" },
    nil
)
add_map(
    nil,
    nil,
    "Playground",
    "rbxassetid://133164748672681",
    "Easy",
    1,
    2,
    nil,
    nil,
    nil,
    { "Nosniy" },
    nil
)
add_map(
    nil,
    nil,
    "Splash",
    "rbxassetid://73768743857232",
    "Medium",
    1,
    2,
    nil,
    nil,
    nil,
    { "Nosniy" },
    nil
)
add_map(
    nil,
    1770958800,
    "Chess",
    "rbxassetid://88015580366583",
    "Easy",
    1,
    2,
    nil,
    nil,
    nil,
    { "Nosniy" },
    nil
)
add_map(
    nil,
    nil,
    "Construction",
    "rbxassetid://92127692376940",
    "Hard",
    1,
    2,
    nil,
    nil,
    nil,
    { "Nosniy" },
    nil
)
add_map(
    nil,
    nil,
    "Station",
    "rbxassetid://118067445717885",
    "Medium",
    1,
    2,
    nil,
    nil,
    true,
    { "Nosniy" },
    { "GreatGuyBoom" }
)
add_map(
    nil,
    nil,
    "Onyx",
    "rbxassetid://103965007372841",
    "Hard",
    1,
    3,
    nil,
    nil,
    nil,
    { "ShadowTrojan" },
    nil
)
add_map(
    nil,
    nil,
    "Crossroads",
    "rbxassetid://137051465958454",
    "Medium",
    1,
    3,
    true,
    nil,
    nil,
    { "ShadowTrojan" },
    nil
)
add_map(
    nil,
    nil,
    "Docks",
    "rbxassetid://118450909242865",
    "Medium",
    1,
    2,
    nil,
    nil,
    true,
    { "Nosniy" },
    nil
)
add_map(
    nil,
    1777003200,
    "Westown",
    "rbxassetid://77717157639300",
    "Medium",
    1,
    2,
    nil,
    nil,
    true,
    { "Nosniy" },
    nil
)
add_map(
    nil,
    nil,
    "Big Arena",
    "rbxassetid://86783307295205",
    "Easy",
    5,
    3,
    nil,
    nil,
    true,
    { "Nosniy" },
    nil
)
add_map(
    nil,
    nil,
    "Big Onyx",
    "rbxassetid://102960591046810",
    "Hard",
    5,
    3,
    nil,
    nil,
    nil,
    { "ShadowTrojan" },
    nil
)
add_map(
    nil,
    nil,
    "Big Splash",
    "rbxassetid://129106276364955",
    "Medium",
    5,
    3,
    nil,
    nil,
    true,
    { "Nosniy" },
    nil
)
add_map(
    nil,
    nil,
    "Big Backrooms",
    "rbxassetid://70941797176675",
    "Easy",
    5,
    3,
    nil,
    nil,
    true,
    { "Nosniy" },
    nil
)
add_map(
    nil,
    nil,
    "Big Crossroads",
    "rbxassetid://73141606762048",
    "Medium",
    5,
    3,
    true,
    nil,
    true,
    { "ShadowTrojan" },
    nil
)
add_map(
    nil,
    nil,
    "Big Graveyard",
    "rbxassetid://93673011647821",
    "Medium",
    5,
    3,
    true,
    nil,
    true,
    { "GreatGuyBoom" },
    nil
)
add_map(
    nil,
    1770958800,
    "Big Station",
    "rbxassetid://115320285934414",
    "Medium",
    5,
    3,
    true,
    nil,
    true,
    { "GreatGuyBoom" },
    nil
)
add_map(
    nil,
    nil,
    "Shooting Range",
    "rbxassetid://80094199312443",
    "Easy",
    9,
    2,
    nil,
    nil,
    true,
    { "Nosniy" },
    nil
)
add_map(
    nil,
    nil,
    "Battleground",
    "rbxassetid://102473488579867",
    "Easy",
    1,
    2,
    nil,
    nil,
    nil,
    { "GreatGuyBoom" },
    { "ShadowTrojan" }
)
add_map(
    nil,
    1782446400,
    "Sandbox",
    "rbxassetid://129581948881572",
    "Easy",
    1,
    2,
    nil,
    nil,
    nil,
    { "GreatGuyBoom" },
    { "ShadowTrojan" }
)
add_map(
    nil,
    nil,
    "Legacy Backrooms",
    "rbxassetid://16780257607",
    "Secret",
    1,
    2,
    nil,
    true,
    nil,
    { "Nosniy" },
    nil
)
add_map(
    nil,
    nil,
    "Legacy Big Splash",
    "rbxassetid://112550674762781",
    "Secret",
    1,
    2,
    nil,
    true,
    true,
    { "Nosniy" },
    nil
)
add_map(
    nil,
    nil,
    "Legacy Splash",
    "rbxassetid://77611360382000",
    "Secret",
    1,
    2,
    nil,
    true,
    nil,
    { "Nosniy" },
    nil
)
add_map(
    nil,
    nil,
    "Legacy Docks",
    "rbxassetid://17619338260",
    "Secret",
    1,
    2,
    nil,
    true,
    true,
    { "Nosniy" },
    nil
)
add_map(
    nil,
    nil,
    "Legacy Onyx",
    "rbxassetid://73585862572119",
    "Secret",
    1,
    2,
    nil,
    true,
    nil,
    { "ShadowTrojan" },
    nil
)
add_map(
    nil,
    nil,
    "Legacy Crossroads",
    "rbxassetid://75089226416040",
    "Secret",
    1,
    2,
    nil,
    true,
    nil,
    { "ShadowTrojan" },
    nil
)
add_map(
    nil,
    nil,
    "Legacy Battleground",
    "rbxassetid://92092855485574",
    "Secret",
    1,
    2,
    nil,
    true,
    nil,
    { "ShadowTrojan" },
    nil
)
add_map(
    nil,
    nil,
    "Legacy Sandbox",
    "rbxassetid://84468237347412",
    "Secret",
    1,
    2,
    nil,
    nil,
    nil,
    { "ShadowTrojan" },
    nil
)
add_map(
    nil,
    nil,
    "Baseplate",
    "rbxassetid://70533987337950",
    "Secret",
    1,
    3,
    nil,
    true,
    nil,
    nil,
    nil
)
add_map(
    true,
    nil,
    "Boss Arena",
    "rbxassetid://75072389675461",
    "Secret",
    1,
    3,
    nil,
    true,
    nil,
    { "Nosniy" },
    nil
)
add_map(
    true,
    nil,
    "Obby",
    "rbxassetid://84725536967912",
    "Secret",
    1,
    3,
    nil,
    true,
    nil,
    { "Nosniy" },
    nil
)
add_map(
    true,
    nil,
    "Zombie Tower",
    "rbxassetid://129926572026365",
    "Secret",
    1,
    1,
    nil,
    true,
    nil,
    { "Nosniy", "GreatGuyBoom" },
    nil
)
add_map(
    true,
    nil,
    "Gargoyle Tower",
    "rbxassetid://127402825315980",
    "Secret",
    1,
    1,
    nil,
    true,
    nil,
    { "Nosniy", "GreatGuyBoom" },
    nil
)
add_map(
    true,
    nil,
    "Spleef",
    "rbxassetid://92639076087223",
    "Secret",
    1,
    1,
    nil,
    true,
    nil,
    { "Nosniy" },
    nil
)
add_map(
    nil,
    nil,
    "Factory",
    "rbxassetid://134218858341023",
    "Easy",
    1,
    2,
    nil,
    nil,
    nil,
    { "GreatGuyBoom" },
    nil,
    "tag_experimental"
)
add_map(
    nil,
    nil,
    "Gate",
    "rbxassetid://93979105537133",
    "Easy",
    1,
    2,
    nil,
    nil,
    nil,
    { "ShadowTrojan" },
    nil,
    "tag_experimental"
)

if CONSTANTS_m.IS_TESTING_SERVER then
    add_map(
        nil,
        nil,
        "Front",
        "rbxassetid://110072622389604",
        "None",
        1,
        3,
        nil,
        nil,
        nil,
        nil,
        nil,
        "tag_experimental"
    )
end

local _ = function(arg43) --[[ add_play_source_type ]] -- line: 259
    -- upvalues:
    --  [1] t_1 (copy)

    t_1.PlaySourceTypes[arg43] = {}
end

t_1.PlaySourceTypes.MatchmakingQueue = {}
t_1.PlaySourceTypes.ArcadeMode = {}

local function verify_map_pool(arg44) -- line: 270
    -- upvalues:
    --  [1] t_1 (copy)

    if not arg44 then
        return
    end

    for index = #arg44, 1, -1 do
        if not t_1.Maps[arg44[index]] then
            table.remove(arg44, index)
        end
    end

    return arg44
end

local function iaf() -- line: 284
    -- upvalues:
    --  [1] Utility_m (copy)

    return Utility_m:IsAprilFoolsGamemodesEnabled()
end

local function add_play_source(
    arg45,
    arg46,
    arg47,
    arg48,
    arg49,
    arg50,
    arg51
) -- line: 288
    -- upvalues:
    --  [1] t_1 (copy)
    --  [2] t (copy)
    --  [3] verify_map_pool (copy)

    assert(t_1.PlaySourceTypes[arg45])
    assert(not t_1.PlaySourceTypes[arg46])
    t_1._assigned_color_count = t_1._assigned_color_count % #t + 1
    local t_61 = {
        Type = arg45,
        DisplayName = arg48,
        DuelLogic = arg47,
        DatabaseInfo = arg49,
        IsRigidMapPool = arg50,
        MapPool = verify_map_pool(arg51),
        AssignedColor = t[t_1._assigned_color_count]
    }
    t_1.PlaySources[arg46] = t_61
    table.insert(t_1.PlaySourceOrder, arg46)

    if t_61.Type ~= "MatchmakingQueue" or t_61.DatabaseInfo.CanBeStartedFromClient then
        local v24 = (if t_61.Type == "MatchmakingQueue" then t_1:GetMaps(
            t_61.DatabaseInfo.NumTeams * t_61.DatabaseInfo.PlayersPerTeam,
            t_61.DatabaseInfo.NumTeams,
            arg46
        ) else if t_61.Type == "ArcadeMode" then t_1:GetMaps(nil, nil, arg46) else assert(
            false,
            "???"
        )) or {}

        for _, val_4 in pairs(v24) do
            table.insert(t_1.Maps[val_4].PlaySources, arg46)
        end
    end
end

local function add_queue(
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
    arg68
) -- line: 319
    -- upvalues:
    --  [1] CONSTANTS_m (copy)
    --  [2] Utility_m (copy)
    --  [3] t_1 (copy)
    --  [4] add_play_source (copy)

    local v25 = arg52 and (if not (arg52 < 0) then arg52 else math.huge)
    local t_62 = {
        TerminalsReleaseTime = if not CONSTANTS_m.IS_TESTING_SERVER then v25 or 0 else v25 and not (v25 < math.huge) and v25 or 0,
        Name = arg53,
        NumTeams = arg55,
        PlayersPerTeam = arg56,
        CanBeStartedFromClient = arg57,
        AreStreaksDisabled = nil,
        StatisticsDisabled = nil,
        IsSafeFromAprilFools = nil,
        DisplayName = nil,
        TitleName = nil,
        Image = nil,
        Thumbnail = nil,
        Description = nil,
        Tooltip = nil
    }

    function t_62.AreStreaksDisabled() -- line: 328
        -- upvalues:
        --  [1] arg58 (copy)
        --  [2] Utility_m (ref)
        --  [3] arg60 (copy)

        return arg58 or Utility_m:IsAprilFools() and not arg60
    end

    t_62.StatisticsDisabled = arg59
    t_62.IsSafeFromAprilFools = arg60
    t_62.DisplayName = arg61 or "???"
    t_62.TitleName = arg62
    t_62.Image = arg63 or "rbxassetid://18523763487"
    t_62.Thumbnail = arg64 or "rbxassetid://117875704523935"
    t_62.Description = arg65 or ""
    t_62.Tooltip = arg66
    t_1.MatchmakingQueues[arg53] = t_62
    t_1.MatchmakingQueueDisplayNameToQueueName[arg61] = arg53
    table.insert(t_1.MatchmakingQueueOrder, arg53)

    if arg54 then
        t_1.MatchmakingQueueDuelLogicToQueueName[arg54] = t_1.MatchmakingQueueDuelLogicToQueueName[arg54] or t_62
    end

    add_play_source(
        "MatchmakingQueue",
        arg53,
        arg54,
        arg61,
        t_62,
        arg67,
        arg68
    )
end

add_queue(
    -1,
    "2v2_beginner",
    nil,
    2,
    1,
    true,
    nil,
    nil,
    nil,
    "Beginner 2v2",
    "Beginner",
    nil,
    "rbxassetid://86693110079054",
    nil,
    nil,
    nil,
    { "Arena" }
)
add_queue(
    nil,
    "1v1",
    nil,
    2,
    1,
    true,
    nil,
    nil,
    nil,
    "1v1",
    nil,
    "rbxassetid://18525954682",
    "rbxassetid://110648887575668",
    nil,
    nil,
    nil,
    {
        "Arena",
        "Backrooms",
        "Crossroads",
        "Docks",
        "Splash",
        "Station",
        "Construction",
        "Onyx",
        "Bridge",
        "Playground",
        "Graveyard",
        "Dimension",
        "Village",
        "Chess",
        "Sandbox",
        "Westown",
        "Museum",
        "Studio",
        "Gate"
    }
)
add_queue(
    nil,
    "2v2",
    nil,
    2,
    2,
    true,
    nil,
    nil,
    nil,
    "2v2",
    nil,
    "rbxassetid://18525954682",
    "rbxassetid://75765063500610",
    nil,
    nil,
    nil,
    {
        "Arena",
        "Backrooms",
        "Crossroads",
        "Docks",
        "Splash",
        "Station",
        "Construction",
        "Onyx",
        "Bridge",
        "Playground",
        "Graveyard",
        "Battleground",
        "Dimension",
        "Village",
        "Chess",
        "Sandbox",
        "Westown",
        "Museum",
        "Studio",
        "Gate"
    }
)
add_queue(
    nil,
    "3v3",
    nil,
    2,
    3,
    true,
    nil,
    nil,
    nil,
    "3v3",
    nil,
    "rbxassetid://18525954682",
    "rbxassetid://115188828715635",
    nil,
    nil,
    nil,
    {
        "Big Arena",
        "Backrooms",
        "Crossroads",
        "Big Crossroads",
        "Docks",
        "Splash",
        "Station",
        "Construction",
        "Onyx",
        "Bridge",
        "Playground",
        "Graveyard",
        "Battleground",
        "Village",
        "Iceberg",
        "Big Station",
        "Chess",
        "Factory",
        "Westown",
        "Museum"
    }
)
add_queue(
    nil,
    "4v4",
    nil,
    2,
    4,
    true,
    nil,
    nil,
    nil,
    "4v4",
    nil,
    "rbxassetid://18525954682",
    "rbxassetid://78144981625266",
    nil,
    nil,
    nil,
    {
        "Big Arena",
        "Big Backrooms",
        "Big Crossroads",
        "Docks",
        "Station",
        "Big Onyx",
        "Big Splash",
        "Big Graveyard",
        "Battleground",
        "Iceberg",
        "Big Station",
        "Chess",
        "Factory",
        "Westown",
        "Museum"
    }
)
add_queue(
    nil,
    "5v5",
    nil,
    2,
    5,
    true,
    nil,
    nil,
    nil,
    "5v5",
    nil,
    "rbxassetid://18525954682",
    "rbxassetid://100769223566900",
    nil,
    nil,
    nil,
    {
        "Big Arena",
        "Big Backrooms",
        "Big Crossroads",
        "Docks",
        "Big Onyx",
        "Big Splash",
        "Big Graveyard",
        "Shooting Range",
        "Iceberg",
        "Big Station",
        "Chess",
        "Westown",
        "Museum"
    }
)
add_queue(
    nil,
    "ranked_1v1",
    "Ranked",
    2,
    1,
    true,
    true,
    nil,
    true,
    "Ranked 1v1",
    "Ranked",
    "rbxassetid://117835427046796",
    SeasonLibrary_m.CurrentSeason.ThumbnailRanked1v1,
    nil,
    nil,
    nil,
    {
        "Arena",
        "Docks",
        "Splash",
        "Station",
        "Construction",
        "Onyx",
        "Bridge",
        "Playground",
        "Westown",
        "Studio",
        "Museum",
        "Battleground",
        "Village"
    }
)
add_queue(
    nil,
    "ranked_2v2",
    "Ranked",
    2,
    2,
    true,
    true,
    nil,
    true,
    "Ranked 2v2",
    "Ranked",
    "rbxassetid://117835427046796",
    SeasonLibrary_m.CurrentSeason.ThumbnailRanked2v2,
    nil,
    nil,
    nil,
    {
        "Arena",
        "Docks",
        "Splash",
        "Station",
        "Construction",
        "Onyx",
        "Bridge",
        "Playground",
        "Battleground",
        "Westown",
        "Studio",
        "Museum",
        "Crossroads",
        "Village"
    }
)
add_queue(
    nil,
    "ranked_3v3",
    "Ranked",
    2,
    3,
    true,
    true,
    nil,
    true,
    "Ranked 3v3",
    "Ranked",
    "rbxassetid://117835427046796",
    SeasonLibrary_m.CurrentSeason.ThumbnailRanked3v3,
    nil,
    nil,
    nil,
    {
        "Crossroads",
        "Docks",
        "Splash",
        "Station",
        "Construction",
        "Onyx",
        "Bridge",
        "Battleground",
        "Big Arena",
        "Westown",
        "Museum"
    }
)
add_queue(
    nil,
    "ltm_doubletrouble_1v1",
    "Double Trouble",
    2,
    1,
    nil,
    true,
    nil,
    nil,
    "Double Trouble 1v1",
    "Double Trouble",
    "rbxassetid://132073690319347",
    "rbxassetid://137424181577897",
    "Dual wield your favorite weapons!",
    nil,
    nil,
    {
        "Arena",
        "Backrooms",
        "Crossroads",
        "Docks",
        "Splash",
        "Station",
        "Construction",
        "Onyx",
        "Bridge",
        "Playground",
        "Graveyard",
        "Dimension",
        "Village",
        "Iceberg",
        "Chess",
        "Westown",
        "Museum",
        "Studio"
    }
)
add_queue(
    nil,
    "ltm_doubletrouble",
    "Double Trouble",
    2,
    2,
    nil,
    true,
    nil,
    nil,
    "Double Trouble 2v2",
    "Double Trouble",
    "rbxassetid://132073690319347",
    "rbxassetid://137424181577897",
    "Dual wield your favorite weapons!",
    nil,
    nil,
    {
        "Arena",
        "Backrooms",
        "Crossroads",
        "Docks",
        "Splash",
        "Station",
        "Construction",
        "Onyx",
        "Bridge",
        "Playground",
        "Graveyard",
        "Battleground",
        "Dimension",
        "Village",
        "Chess",
        "Westown",
        "Museum",
        "Studio"
    }
)
add_queue(
    nil,
    "ltm_doubletrouble_3v3",
    "Double Trouble",
    2,
    3,
    nil,
    true,
    nil,
    nil,
    "Double Trouble 3v3",
    "Double Trouble",
    "rbxassetid://132073690319347",
    "rbxassetid://137424181577897",
    "Dual wield your favorite weapons!",
    nil,
    nil,
    {
        "Big Arena",
        "Backrooms",
        "Crossroads",
        "Big Crossroads",
        "Docks",
        "Splash",
        "Station",
        "Construction",
        "Onyx",
        "Bridge",
        "Playground",
        "Graveyard",
        "Battleground",
        "Village",
        "Iceberg",
        "Big Station",
        "Chess",
        "Westown",
        "Museum"
    }
)
add_queue(
    nil,
    "ltm_mirrormatchup_1v1",
    "Mirror Matchup",
    2,
    1,
    nil,
    true,
    nil,
    nil,
    "Mirror Matchup 1v1",
    "Mirror Matchup",
    "rbxassetid://132073690319347",
    "rbxassetid://105092869907244",
    "Everyone has to use the same random weapons!",
    nil,
    nil,
    {
        "Arena",
        "Backrooms",
        "Crossroads",
        "Docks",
        "Splash",
        "Station",
        "Construction",
        "Onyx",
        "Bridge",
        "Playground",
        "Graveyard",
        "Dimension",
        "Village",
        "Chess",
        "Westown",
        "Museum",
        "Studio"
    }
)
add_queue(
    nil,
    "ltm_mirrormatchup_2v2",
    "Mirror Matchup",
    2,
    2,
    nil,
    true,
    nil,
    nil,
    "Mirror Matchup 2v2",
    "Mirror Matchup",
    "rbxassetid://132073690319347",
    "rbxassetid://105092869907244",
    "Everyone has to use the same random weapons!",
    nil,
    nil,
    {
        "Arena",
        "Backrooms",
        "Crossroads",
        "Docks",
        "Splash",
        "Station",
        "Construction",
        "Onyx",
        "Bridge",
        "Playground",
        "Graveyard",
        "Battleground",
        "Dimension",
        "Village",
        "Chess",
        "Westown",
        "Museum",
        "Studio"
    }
)
add_queue(
    nil,
    "ltm_mirrormatchup_3v3",
    "Mirror Matchup",
    2,
    3,
    nil,
    true,
    nil,
    nil,
    "Mirror Matchup 3v3",
    "Mirror Matchup",
    "rbxassetid://132073690319347",
    "rbxassetid://105092869907244",
    "Everyone has to use the same random weapons!",
    nil,
    nil,
    {
        "Big Arena",
        "Backrooms",
        "Crossroads",
        "Big Crossroads",
        "Docks",
        "Splash",
        "Station",
        "Construction",
        "Onyx",
        "Bridge",
        "Playground",
        "Graveyard",
        "Battleground",
        "Village",
        "Iceberg",
        "Big Station",
        "Chess",
        "Westown",
        "Museum"
    }
)
add_queue(
    nil,
    "ltm_easyexploits_2v2",
    "Easy Exploits",
    2,
    2,
    iaf,
    true,
    nil,
    nil,
    "Easy Exploits 2v2",
    "Easy Exploits",
    "rbxassetid://132073690319347",
    "rbxassetid://131530572287607",
    "Fake cheating \226\128\148 actual cheaters get banned!",
    nil,
    nil,
    {
        "Arena",
        "Backrooms",
        "Crossroads",
        "Docks",
        "Splash",
        "Station",
        "Construction",
        "Onyx",
        "Bridge",
        "Playground",
        "Graveyard",
        "Battleground",
        "Dimension",
        "Village",
        "Chess",
        "Westown",
        "Museum",
        "Studio"
    }
)
add_queue(
    nil,
    "ltm_easyexploits_3v3",
    "Easy Exploits",
    2,
    3,
    iaf,
    true,
    nil,
    nil,
    "Easy Exploits 3v3",
    "Easy Exploits",
    "rbxassetid://132073690319347",
    "rbxassetid://131530572287607",
    "Fake cheating \226\128\148 actual cheaters get banned!",
    nil,
    nil,
    {
        "Big Arena",
        "Backrooms",
        "Crossroads",
        "Big Crossroads",
        "Docks",
        "Splash",
        "Station",
        "Construction",
        "Onyx",
        "Bridge",
        "Playground",
        "Graveyard",
        "Battleground",
        "Village",
        "Iceberg",
        "Big Station",
        "Chess",
        "Westown",
        "Museum"
    }
)
add_queue(
    nil,
    "ltm_limitlessloadout_1v1",
    "Limitless Loadout",
    2,
    1,
    nil,
    true,
    nil,
    nil,
    "Limitless Loadout 1v1",
    "Limitless Loadout",
    "rbxassetid://132073690319347",
    "rbxassetid://132019868240159",
    "Equip any weapon in any slot!",
    nil,
    nil,
    {
        "Arena",
        "Backrooms",
        "Crossroads",
        "Docks",
        "Splash",
        "Station",
        "Construction",
        "Onyx",
        "Bridge",
        "Playground",
        "Graveyard",
        "Dimension",
        "Village",
        "Chess",
        "Westown",
        "Museum",
        "Studio"
    }
)
add_queue(
    nil,
    "ltm_limitlessloadout_2v2",
    "Limitless Loadout",
    2,
    2,
    nil,
    true,
    nil,
    nil,
    "Limitless Loadout 2v2",
    "Limitless Loadout",
    "rbxassetid://132073690319347",
    "rbxassetid://132019868240159",
    "Equip any weapon in any slot!",
    nil,
    nil,
    {
        "Arena",
        "Backrooms",
        "Crossroads",
        "Docks",
        "Splash",
        "Station",
        "Construction",
        "Onyx",
        "Bridge",
        "Playground",
        "Graveyard",
        "Battleground",
        "Dimension",
        "Village",
        "Chess",
        "Westown",
        "Museum",
        "Studio"
    }
)
add_queue(
    nil,
    "ltm_limitlessloadout_3v3",
    "Limitless Loadout",
    2,
    3,
    nil,
    true,
    nil,
    nil,
    "Limitless Loadout 3v3",
    "Limitless Loadout",
    "rbxassetid://132073690319347",
    "rbxassetid://132019868240159",
    "Equip any weapon in any slot!",
    nil,
    nil,
    {
        "Big Arena",
        "Backrooms",
        "Crossroads",
        "Big Crossroads",
        "Docks",
        "Splash",
        "Station",
        "Construction",
        "Onyx",
        "Bridge",
        "Playground",
        "Graveyard",
        "Battleground",
        "Village",
        "Iceberg",
        "Big Station",
        "Chess",
        "Westown",
        "Museum"
    }
)
add_queue(
    1749182400,
    "ltm_juggernaut_1v7",
    "Juggernaut",
    2,
    4,
    nil,
    true,
    nil,
    nil,
    "Juggernaut 1v7",
    "Juggernaut",
    "rbxassetid://132073690319347",
    "rbxassetid://111131964001261",
    "Will you be the raid boss?",
    nil,
    nil,
    {
        "Big Arena",
        "Backrooms",
        "Bridge",
        "Graveyard",
        "Playground",
        "Construction",
        "Onyx",
        "Dimension",
        "Iceberg",
        "Chess",
        "Westown",
        "Museum",
        "Studio"
    }
)
add_queue(
    1749787200,
    "ltm_swiftstandoff_1v1",
    "Swift Standoff",
    2,
    1,
    nil,
    true,
    nil,
    nil,
    "Swift Standoff 1v1",
    "Swift Standoff",
    "rbxassetid://132073690319347",
    "rbxassetid://97275583028575",
    "Slash & dash with just 1 bullet in the chamber!",
    nil,
    nil,
    {
        "Arena",
        "Backrooms",
        "Crossroads",
        "Docks",
        "Splash",
        "Station",
        "Construction",
        "Onyx",
        "Bridge",
        "Playground",
        "Graveyard",
        "Dimension",
        "Village",
        "Chess",
        "Westown",
        "Museum",
        "Studio"
    }
)
add_queue(
    1749787200,
    "ltm_swiftstandoff_2v2",
    "Swift Standoff",
    2,
    2,
    nil,
    true,
    nil,
    nil,
    "Swift Standoff 2v2",
    "Swift Standoff",
    "rbxassetid://132073690319347",
    "rbxassetid://97275583028575",
    "Slash & dash with just 1 bullet in the chamber!",
    nil,
    nil,
    {
        "Arena",
        "Backrooms",
        "Crossroads",
        "Docks",
        "Splash",
        "Station",
        "Construction",
        "Onyx",
        "Bridge",
        "Playground",
        "Graveyard",
        "Battleground",
        "Dimension",
        "Village",
        "Chess",
        "Westown",
        "Museum",
        "Studio"
    }
)
add_queue(
    1749787200,
    "ltm_swiftstandoff_3v3",
    "Swift Standoff",
    2,
    3,
    nil,
    true,
    nil,
    nil,
    "Swift Standoff 3v3",
    "Swift Standoff",
    "rbxassetid://132073690319347",
    "rbxassetid://97275583028575",
    "Slash & dash with just 1 bullet in the chamber!",
    nil,
    nil,
    {
        "Big Arena",
        "Backrooms",
        "Crossroads",
        "Big Crossroads",
        "Docks",
        "Splash",
        "Station",
        "Construction",
        "Onyx",
        "Bridge",
        "Playground",
        "Graveyard",
        "Battleground",
        "Village",
        "Iceberg",
        "Big Station",
        "Chess",
        "Westown",
        "Museum"
    }
)
add_queue(
    1750392000,
    "ltm_defaultduel_1v1",
    "Default Duel",
    2,
    1,
    nil,
    nil,
    nil,
    nil,
    "Default Duel 1v1",
    "Default Duel",
    "rbxassetid://132073690319347",
    "rbxassetid://97514791083427",
    "A true test of skill \226\128\148 default weapons only!",
    nil,
    nil,
    { "Arena", "Station", "Legacy Backrooms", "Legacy Docks", "Legacy Onyx", "Legacy Crossroads" }
)
add_queue(
    1750392000,
    "ltm_defaultduel_2v2",
    "Default Duel",
    2,
    2,
    nil,
    nil,
    nil,
    nil,
    "Default Duel 2v2",
    "Default Duel",
    "rbxassetid://132073690319347",
    "rbxassetid://97514791083427",
    "A true test of skill \226\128\148 default weapons only!",
    nil,
    nil,
    { "Arena", "Station", "Legacy Backrooms", "Legacy Docks", "Legacy Onyx", "Legacy Crossroads" }
)
add_queue(
    1750392000,
    "ltm_bunnysniping_2v2",
    "Bunny Sniping",
    2,
    2,
    nil,
    true,
    nil,
    nil,
    "Bunny Sniping 2v2",
    "Bunny Sniping",
    "rbxassetid://132073690319347",
    "rbxassetid://111836104944441",
    "Snipe enemies in low gravity!",
    nil,
    nil,
    {
        "Arena",
        "Crossroads",
        "Docks",
        "Splash",
        "Station",
        "Construction",
        "Onyx",
        "Bridge",
        "Playground",
        "Graveyard",
        "Dimension",
        "Village",
        "Iceberg",
        "Chess",
        "Westown",
        "Studio"
    }
)
add_queue(
    1750392000,
    "ltm_bunnysniping_3v3",
    "Bunny Sniping",
    2,
    3,
    nil,
    true,
    nil,
    nil,
    "Bunny Sniping 3v3",
    "Bunny Sniping",
    "rbxassetid://132073690319347",
    "rbxassetid://81786315504458",
    "Snipe enemies in low gravity!",
    nil,
    nil,
    {
        "Arena",
        "Big Crossroads",
        "Docks",
        "Splash",
        "Station",
        "Construction",
        "Onyx",
        "Bridge",
        "Playground",
        "Graveyard",
        "Battleground",
        "Dimension",
        "Village",
        "Iceberg",
        "Big Station",
        "Chess",
        "Westown"
    }
)
add_queue(
    1750996800,
    "ltm_tagteam_3v3",
    "Tag Team",
    2,
    3,
    nil,
    true,
    nil,
    nil,
    "Tag Team 3v3",
    "Tag Team",
    "rbxassetid://132073690319347",
    "rbxassetid://98049823970129",
    "Sweep the enemy team as your teammates watch you!",
    nil,
    nil,
    {
        "Arena",
        "Backrooms",
        "Crossroads",
        "Docks",
        "Splash",
        "Station",
        "Construction",
        "Onyx",
        "Bridge",
        "Playground",
        "Graveyard",
        "Dimension",
        "Village",
        "Iceberg",
        "Chess",
        "Westown",
        "Museum"
    }
)
add_queue(
    1750996800,
    "ltm_tagteam_5v5",
    "Tag Team",
    2,
    5,
    nil,
    true,
    nil,
    nil,
    "Tag Team 5v5",
    "Tag Team",
    "rbxassetid://132073690319347",
    "rbxassetid://98049823970129",
    "Sweep the enemy team as your teammates watch you!",
    nil,
    nil,
    {
        "Arena",
        "Backrooms",
        "Crossroads",
        "Docks",
        "Splash",
        "Station",
        "Construction",
        "Onyx",
        "Bridge",
        "Playground",
        "Graveyard",
        "Dimension",
        "Village",
        "Iceberg",
        "Chess",
        "Westown",
        "Museum"
    }
)
add_queue(
    1751601600,
    "ltm_chickengames_1v1",
    "Chicken Game",
    2,
    1,
    nil,
    true,
    nil,
    nil,
    "Chicken Game 1v1",
    "Chicken Game",
    "rbxassetid://132073690319347",
    "rbxassetid://130631351253585",
    "Red Light \240\159\154\166 Green Light",
    nil,
    nil,
    {
        "Arena",
        "Backrooms",
        "Crossroads",
        "Docks",
        "Splash",
        "Station",
        "Construction",
        "Onyx",
        "Bridge",
        "Playground",
        "Graveyard",
        "Dimension",
        "Village",
        "Chess",
        "Westown",
        "Museum",
        "Studio"
    }
)
add_queue(
    1751601600,
    "ltm_chickengames_2v2",
    "Chicken Game",
    2,
    2,
    nil,
    true,
    nil,
    nil,
    "Chicken Game 2v2",
    "Chicken Game",
    "rbxassetid://132073690319347",
    "rbxassetid://130631351253585",
    "Red Light \240\159\154\166 Green Light",
    nil,
    nil,
    {
        "Arena",
        "Backrooms",
        "Crossroads",
        "Docks",
        "Splash",
        "Station",
        "Construction",
        "Onyx",
        "Bridge",
        "Playground",
        "Graveyard",
        "Battleground",
        "Dimension",
        "Village",
        "Chess",
        "Westown",
        "Museum",
        "Studio"
    }
)
add_queue(
    1751601600,
    "ltm_chickengames_3v3",
    "Chicken Game",
    2,
    3,
    nil,
    true,
    nil,
    nil,
    "Chicken Game 3v3",
    "Chicken Game",
    "rbxassetid://132073690319347",
    "rbxassetid://130631351253585",
    "Red Light \240\159\154\166 Green Light",
    nil,
    nil,
    {
        "Big Arena",
        "Backrooms",
        "Crossroads",
        "Big Crossroads",
        "Docks",
        "Splash",
        "Station",
        "Construction",
        "Onyx",
        "Bridge",
        "Playground",
        "Graveyard",
        "Battleground",
        "Village",
        "Iceberg",
        "Big Station",
        "Chess",
        "Westown",
        "Museum"
    }
)
add_queue(
    1751601600,
    "ltm_chickengames_4v4",
    "Chicken Game",
    2,
    4,
    nil,
    true,
    nil,
    nil,
    "Chicken Game 4v4",
    "Chicken Game",
    "rbxassetid://132073690319347",
    "rbxassetid://130631351253585",
    "Red Light \240\159\154\166 Green Light",
    nil,
    nil,
    {
        "Big Arena",
        "Big Backrooms",
        "Big Crossroads",
        "Docks",
        "Big Onyx",
        "Big Splash",
        "Station",
        "Big Graveyard",
        "Battleground",
        "Iceberg",
        "Big Station",
        "Chess",
        "Westown",
        "Museum"
    }
)
add_queue(
    1752206400,
    "ltm_rivalsrng_1v1",
    "RIVALS RNG",
    2,
    1,
    nil,
    true,
    nil,
    nil,
    "RIVALS RNG 1v1",
    "RIVALS RNG",
    "rbxassetid://132073690319347",
    "rbxassetid://77265684173552",
    "Roll for a random weapon!",
    nil,
    nil,
    {
        "Arena",
        "Backrooms",
        "Crossroads",
        "Docks",
        "Splash",
        "Station",
        "Construction",
        "Onyx",
        "Bridge",
        "Playground",
        "Graveyard",
        "Dimension",
        "Village",
        "Chess",
        "Westown",
        "Museum",
        "Studio"
    }
)
add_queue(
    1752206400,
    "ltm_rivalsrng_2v2",
    "RIVALS RNG",
    2,
    2,
    nil,
    true,
    nil,
    nil,
    "RIVALS RNG 2v2",
    "RIVALS RNG",
    "rbxassetid://132073690319347",
    "rbxassetid://77265684173552",
    "Roll for a random weapon!",
    nil,
    nil,
    {
        "Arena",
        "Backrooms",
        "Crossroads",
        "Docks",
        "Splash",
        "Station",
        "Construction",
        "Onyx",
        "Bridge",
        "Playground",
        "Graveyard",
        "Battleground",
        "Dimension",
        "Village",
        "Chess",
        "Westown",
        "Museum",
        "Studio"
    }
)
add_queue(
    1752206400,
    "ltm_rivalsrng_3v3",
    "RIVALS RNG",
    2,
    3,
    nil,
    true,
    nil,
    nil,
    "RIVALS RNG 3v3",
    "RIVALS RNG",
    "rbxassetid://132073690319347",
    "rbxassetid://77265684173552",
    "Roll for a random weapon!",
    nil,
    nil,
    {
        "Big Arena",
        "Big Backrooms",
        "Crossroads",
        "Big Crossroads",
        "Docks",
        "Splash",
        "Station",
        "Construction",
        "Onyx",
        "Bridge",
        "Playground",
        "Graveyard",
        "Battleground",
        "Village",
        "Iceberg",
        "Big Station",
        "Chess",
        "Westown",
        "Museum"
    }
)
add_queue(
    1752811200,
    "ltm_headhoncho_3v3",
    "Head Honcho",
    2,
    3,
    nil,
    true,
    nil,
    nil,
    "Head Honcho 3v3",
    "Head Honcho",
    "rbxassetid://132073690319347",
    "rbxassetid://129701707427431",
    "Eliminate the rival company's leader!",
    nil,
    nil,
    {
        "Big Arena",
        "Big Backrooms",
        "Big Crossroads",
        "Docks",
        "Big Onyx",
        "Big Splash",
        "Big Graveyard",
        "Shooting Range",
        "Iceberg",
        "Big Station",
        "Westown",
        "Museum"
    }
)
add_queue(
    1752811200,
    "ltm_headhoncho_4v4",
    "Head Honcho",
    2,
    4,
    nil,
    true,
    nil,
    nil,
    "Head Honcho 4v4",
    "Head Honcho",
    "rbxassetid://132073690319347",
    "rbxassetid://129701707427431",
    "Eliminate the rival company's leader!",
    nil,
    nil,
    {
        "Big Arena",
        "Big Backrooms",
        "Big Crossroads",
        "Docks",
        "Big Onyx",
        "Big Splash",
        "Big Graveyard",
        "Shooting Range",
        "Iceberg",
        "Big Station",
        "Westown",
        "Museum"
    }
)
add_queue(
    1752811200,
    "ltm_headhoncho_5v5",
    "Head Honcho",
    2,
    5,
    nil,
    true,
    nil,
    nil,
    "Head Honcho 5v5",
    "Head Honcho",
    "rbxassetid://132073690319347",
    "rbxassetid://111031080770975",
    "Eliminate the rival company's leader!",
    nil,
    nil,
    {
        "Big Arena",
        "Big Backrooms",
        "Big Crossroads",
        "Docks",
        "Big Onyx",
        "Big Splash",
        "Big Graveyard",
        "Shooting Range",
        "Iceberg",
        "Big Station",
        "Westown",
        "Museum"
    }
)
add_queue(
    1753416000,
    "ltm_hardcoreparkour_1v1",
    "Hardcore Parkour",
    2,
    1,
    nil,
    true,
    nil,
    nil,
    "Hardcore Parkour 1v1",
    "Hardcore Parkour",
    "rbxassetid://132073690319347",
    "rbxassetid://104911032041491",
    "Obby but you're in RIVALS!",
    nil,
    true,
    { "Obby" }
)
add_queue(
    1753416000,
    "ltm_hardcoreparkour_2v2",
    "Hardcore Parkour",
    2,
    2,
    nil,
    true,
    nil,
    nil,
    "Hardcore Parkour 2v2",
    "Hardcore Parkour",
    "rbxassetid://132073690319347",
    "rbxassetid://104911032041491",
    "Obby but you're in RIVALS!",
    nil,
    true,
    { "Obby" }
)
add_queue(
    1753416000,
    "ltm_hardcoreparkour_5v5",
    "Hardcore Parkour",
    2,
    5,
    nil,
    true,
    nil,
    nil,
    "Hardcore Parkour 5v5",
    "Hardcore Parkour",
    "rbxassetid://132073690319347",
    "rbxassetid://104911032041491",
    "Obby but you're in RIVALS!",
    nil,
    true,
    { "Obby" }
)
add_queue(
    nil,
    "1v1v1",
    nil,
    3,
    1,
    nil,
    true,
    nil,
    nil,
    "1v1v1",
    nil,
    "rbxassetid://132073690319347",
    "rbxassetid://105588944981527",
    "Classic duels but with 3 teams!",
    nil,
    nil,
    {
        "Big Arena",
        "Big Backrooms",
        "Big Crossroads",
        "Shooting Range",
        "Onyx",
        "Big Graveyard",
        "Station",
        "Docks",
        "Crossroads",
        "Big Onyx",
        "Iceberg",
        "Big Station",
        "Museum",
        "Westown"
    }
)
add_queue(
    nil,
    "2v2v2",
    nil,
    3,
    2,
    nil,
    true,
    nil,
    nil,
    "2v2v2",
    nil,
    "rbxassetid://132073690319347",
    "rbxassetid://105588944981527",
    "Classic duels but with 3 teams!",
    nil,
    nil,
    {
        "Big Arena",
        "Big Backrooms",
        "Big Crossroads",
        "Shooting Range",
        "Oynx",
        "Big Graveyard",
        "Station",
        "Docks",
        "Crossroads",
        "Big Onyx",
        "Iceberg",
        "Big Station",
        "Museum",
        "Westown"
    }
)
add_queue(
    nil,
    "3v3v3",
    nil,
    3,
    3,
    nil,
    true,
    nil,
    nil,
    "3v3v3",
    nil,
    "rbxassetid://132073690319347",
    "rbxassetid://105588944981527",
    "Classic duels but with 3 teams!",
    nil,
    nil,
    {
        "Big Arena",
        "Big Backrooms",
        "Big Crossroads",
        "Shooting Range",
        "Oynx",
        "Big Graveyard",
        "Station",
        "Docks",
        "Crossroads",
        "Big Onyx",
        "Iceberg",
        "Big Station",
        "Museum",
        "Westown"
    }
)
add_queue(
    nil,
    "ltm_spleef_8v8",
    "Spleef",
    2,
    8,
    nil,
    true,
    nil,
    nil,
    "Spleef 8v8",
    "Spleef",
    "rbxassetid://132073690319347",
    "rbxassetid://136079282184880",
    "Don't fall into the chark-infested waters!",
    nil,
    true,
    { "Spleef" }
)
add_queue(
    nil,
    "ltm_monstertower_zombietower",
    "Zombie Tower",
    1,
    5,
    true,
    true,
    true,
    nil,
    "Zombie Tower",
    "Zombie Tower",
    "rbxassetid://132073690319347",
    "rbxassetid://79328971751595",
    "Can you reach the top?",
    nil,
    true,
    { "Zombie Tower" }
)
add_queue(
    -1,
    "ltm_monstertower_zombietower_solo",
    "Zombie Tower",
    1,
    1,
    true,
    true,
    true,
    nil,
    "SOLO",
    "Zombie Tower",
    "rbxassetid://132073690319347",
    "rbxassetid://79328971751595",
    "",
    nil,
    true,
    { "Zombie Tower" }
)
add_queue(
    nil,
    "ltm_monstertower_gargoyletower",
    "Gargoyle Tower",
    1,
    5,
    true,
    true,
    true,
    nil,
    "Gargoyle Tower",
    "Gargoyle Tower",
    "rbxassetid://132073690319347",
    "rbxassetid://102542384323553",
    "There's.. more?",
    nil,
    true,
    { "Gargoyle Tower" }
)
add_queue(
    -1,
    "ltm_monstertower_gargoyletower_solo",
    "Gargoyle Tower",
    1,
    1,
    true,
    true,
    true,
    nil,
    "SOLO",
    "Gargoyle Tower",
    "rbxassetid://132073690319347",
    "rbxassetid://102542384323553",
    "",
    nil,
    true,
    { "Gargoyle Tower" }
)
add_queue(
    -1,
    "evt_senseibot",
    "Boss Battle",
    1,
    1,
    nil,
    true,
    true,
    true,
    "Sensei Bot",
    "Sensei Bot",
    "rbxassetid://132073690319347",
    "rbxassetid://110648887575668",
    nil,
    nil,
    true,
    { "Boss Arena" }
)
add_queue(
    -1,
    "evt_nosniybot",
    "Boss Battle",
    1,
    1,
    nil,
    true,
    true,
    true,
    "Nosniy Bot",
    "Nosniy Bot",
    "rbxassetid://132073690319347",
    "rbxassetid://110648887575668",
    nil,
    nil,
    true,
    { "Boss Arena" }
)

local function add_arcade_mode(
    arg69,
    arg70,
    arg71,
    arg72,
    arg73,
    arg74,
    arg75
) -- line: 408
    -- upvalues:
    --  [1] t_1 (copy)
    --  [2] add_play_source (copy)

    local t_116 = {
        Name = arg69,
        DisplayName = arg71,
        Thumbnail = arg72,
        Description = arg73,
        PlaceID = arg74
    }
    t_1.ArcadeModes[arg69] = t_116
    t_1.ArcadeModeByPlaceID[tostring(t_116.PlaceID)] = t_116
    table.insert(t_1.ArcadeModeOrder, arg69)
    add_play_source(
        "ArcadeMode",
        arg69,
        arg70,
        arg71,
        t_116,
        true,
        arg75
    )
end

add_arcade_mode(
    "arc_gungame",
    "Gun Game",
    "Gun Game",
    "rbxassetid://126712308378143",
    "Race to the final weapon to win!",
    CONSTANTS_m.ARCADE_GUNGAME_PLACE_ID,
    {
        "Big Crossroads",
        "Shooting Range",
        "Station",
        "Big Arena",
        "Big Backrooms",
        "Big Graveyard",
        "Big Splash",
        "Docks",
        "Iceberg",
        "Big Station",
        "Westown",
        "Museum"
    }
)
add_arcade_mode(
    "arc_teamdeathmatch",
    "Deathmatch",
    "Team Deathmatch",
    "rbxassetid://117499628913182",
    "The team with the most points wins!",
    CONSTANTS_m.ARCADE_TEAMDEATHMATCH_PLACE_ID,
    {
        "Big Crossroads",
        "Shooting Range",
        "Station",
        "Big Arena",
        "Big Backrooms",
        "Big Graveyard",
        "Big Splash",
        "Docks",
        "Iceberg",
        "Chess",
        "Big Station",
        "Westown",
        "Museum"
    }
)
add_arcade_mode(
    "arc_freeforall",
    "Deathmatch",
    "Free For All",
    "rbxassetid://86903206151694",
    "The player with the most points wins!",
    CONSTANTS_m.ARCADE_FREEFORALL_PLACE_ID,
    {
        "Big Crossroads",
        "Shooting Range",
        "Station",
        "Big Arena",
        "Big Backrooms",
        "Big Graveyard",
        "Big Splash",
        "Docks",
        "Iceberg",
        "Big Station",
        "Westown"
    }
)

return t_1
