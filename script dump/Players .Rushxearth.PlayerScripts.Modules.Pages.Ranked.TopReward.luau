local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local CosmeticLibrary_m = require(ReplicatedStorage.Modules.CosmeticLibrary)
local SeasonLibrary_m = require(ReplicatedStorage.Modules.SeasonLibrary)
local PlayerDataController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.PlayerDataController
)
local RewardSlot_m = require(Players.LocalPlayer.PlayerScripts.Modules.RewardSlot)
local RankIcon_m = require(Players.LocalPlayer.PlayerScripts.Modules.RankIcon)
local t = {}
t.__index = t

function t.new(arg1) -- line: 13
    -- upvalues:
    --  [1] t (copy)

    local t_1 = setmetatable({}, t)
    t_1.Page = arg1
    t_1.Frame = t_1.Page.Container:WaitForChild("TopReward")
    t_1.RankContainer = t_1.Frame:WaitForChild("RankContainer")
    t_1.Container = t_1.Frame:WaitForChild("Container")
    t_1.Title = t_1.Frame:WaitForChild("Title")
    t_1.Description = t_1.Frame:WaitForChild("Description")
    t_1.Description2 = t_1.Frame:WaitForChild("Description2")
    t_1:_Init()

    return t_1
end

function t.Open(arg2) -- line: 33
    arg2:_Update()
end

function t.Close(_) -- line: 37
end

function t._GetTopRankDetails(_) -- line: 45
    -- upvalues:
    --  [1] SeasonLibrary_m (copy)

    local v1 = SeasonLibrary_m:GetRank(
        math.huge,
        nil,
        SeasonLibrary_m.CurrentSeason.TopPlayerLeaderboardRank
    )

    return v1, SeasonLibrary_m.CurrentSeason.RankProfile.Ranks[v1].RequiredELO
end

function t._Update(arg5) -- line: 52
    -- upvalues:
    --  [1] SeasonLibrary_m (copy)
    --  [2] PlayerDataController_m (copy)

    if not SeasonLibrary_m.CurrentSeason.TopPlayerRewardSkinName then
        arg5.Frame.Visible = false

        return
    end

    local v3 = PlayerDataController_m:Get("Seasons")[SeasonLibrary_m.CurrentSeason.Name]
    local v2 = v3

    if v2 then
        v2 = v3.RankedPerformances[SeasonLibrary_m.UNIVERSAL_ELO_NAME]
    end

    v3 = v2 and v2.CurrentELO
    local _, v5 = arg5:_GetTopRankDetails()
    local v6 = v3
    local Frame = arg5.Frame

    if v6 then
        v6 = v3 >= v5
    end

    Frame.Visible = v6
end

function t._Setup(arg6) -- line: 66
    -- upvalues:
    --  [1] SeasonLibrary_m (copy)
    --  [2] CosmeticLibrary_m (copy)
    --  [3] RankIcon_m (copy)
    --  [4] RewardSlot_m (copy)

    local v7, _ = arg6:_GetTopRankDetails()
    local TopPlayerRewardSkinName = SeasonLibrary_m.CurrentSeason.TopPlayerRewardSkinName

    if not TopPlayerRewardSkinName then
        return
    end

    local v9 = CosmeticLibrary_m.Cosmetics[TopPlayerRewardSkinName]
    arg6.Title.Text = TopPlayerRewardSkinName
    arg6.Description.Text = string.format(
        "Become %s by reaching top %s on the Ranked Leaderboard!",
        v7,
        SeasonLibrary_m.CurrentSeason.TopPlayerLeaderboardRank
    )
    arg6.Description2.Text = string.format(
        "The %s %s skin will be rewarded to %s players at season end!",
        v9.Rarity,
        TopPlayerRewardSkinName,
        v7
    )
    RankIcon_m.new(math.huge, nil, SeasonLibrary_m.CurrentSeason.TopPlayerLeaderboardRank):SetParent(
        arg6.RankContainer
    )
    RewardSlot_m.new({ Name = TopPlayerRewardSkinName, Weapon = v9.ItemName }):SetParent(
        arg6.Container
    )
end

function t._Init(arg7) -- line: 83
    arg7:_Setup()
end

return t
