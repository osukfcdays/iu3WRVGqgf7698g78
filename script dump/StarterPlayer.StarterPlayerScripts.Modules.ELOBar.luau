local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local SeasonLibrary_m = require(ReplicatedStorage.Modules.SeasonLibrary)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local PlayerDataController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.PlayerDataController
)
local RankIcon_m = require(Players.LocalPlayer.PlayerScripts.Modules.RankIcon)
local ELOBar = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("ELOBar")
local t = {}
t.__index = t

function t.new() -- line: 14
    -- upvalues:
    --  [1] t (copy)
    --  [2] ELOBar (copy)

    local t_1 = setmetatable({}, t)
    t_1.Frame = ELOBar:Clone()
    t_1.ProgressBar = t_1.Frame:WaitForChild("Progress"):WaitForChild("Bar")
    t_1.ProgressBarTexture = t_1.ProgressBar:WaitForChild("Texture")
    t_1.LeftRankText = t_1.Frame:WaitForChild("LeftRank")
    t_1.LeftELOText = t_1.Frame:WaitForChild("LeftELO")
    t_1.CurrentELOTitle = t_1.Frame:WaitForChild("CurrentELOTitle")
    t_1.CurrentELOText = t_1.Frame:WaitForChild("CurrentELO")
    t_1.RightRankText = t_1.Frame:WaitForChild("RightRank")
    t_1.RightELOText = t_1.Frame:WaitForChild("RightELO")
    t_1.RankCurrentFrame = t_1.Frame:WaitForChild("RankCurrent")
    t_1.RankNextFrame = t_1.Frame:WaitForChild("RankNext")
    t_1._is_enabled = nil
    t_1._update_hash = 0
    t_1._current_rank_icon = nil
    t_1._next_rank_icon = nil
    t_1._preloaded_rank_icons = false
    t_1:_Init()

    return t_1
end

function t.SetParent(arg1, arg2) -- line: 44
    arg1.Frame.Parent = arg2
end

function t.Update(arg3, arg4) -- line: 48
    arg3._is_enabled = arg4
    arg3._update_hash += 1
    arg3:_Update()
end

function t.Destroy(arg5) -- line: 54
    arg5.Frame:Destroy()
end

function t._Update(arg6) -- line: 62
    -- upvalues:
    --  [1] SeasonLibrary_m (copy)
    --  [2] PlayerDataController_m (copy)
    --  [3] Players (copy)
    --  [4] Utility_m (copy)
    --  [5] RankIcon_m (copy)

    if arg6._current_rank_icon then
        arg6._current_rank_icon:Destroy()
        arg6._current_rank_icon = nil
    end

    if arg6._next_rank_icon then
        arg6._next_rank_icon:Destroy()
        arg6._next_rank_icon = nil
    end

    arg6.Frame.Visible = false

    if not arg6._is_enabled then
        return
    end

    local RankProfile = SeasonLibrary_m.CurrentSeason.RankProfile
    local v2 = PlayerDataController_m:Get("Seasons")[SeasonLibrary_m.CurrentSeason.Name]
    local v1 = v2

    if v1 then
        v1 = v2.RankedPerformances[SeasonLibrary_m.UNIVERSAL_ELO_NAME]
    end

    if not v1 then
        return
    end

    v2 = SeasonLibrary_m:GetRank(v1.CurrentELO, Players.LocalPlayer.UserId)
    local v3 = RankProfile.Ranks[v2]
    local v5 = RankProfile.RanksOrder[math.min(
        #RankProfile.RanksOrder,
        table.find(RankProfile.RanksOrder, v2) + 1
    )]
    local v6 = RankProfile.Ranks[v5]
    local v7 = v6.RequiredELO

    if v7 then
        v7 = v3.RequiredELO and v6.RequiredELO - v3.RequiredELO == 0
    end

    local v8 = if v1.CurrentELO then if v5 ~= v2 then if not v7 then (v1.CurrentELO - v3.RequiredELO) / (v6.RequiredELO - v3.RequiredELO) else 0.5 else 1 else v1.DuelsPlayed / SeasonLibrary_m.CurrentSeason.RankProfile.NumPlacementDuels
    local v9

    if v8 <= 0 then
        v9 = 0
    elseif v7 then
        v9 = v8
    else
        local _ = v1.CurrentELO
        v9 = math.clamp(v8, 0, 1) * 0.9 + 0.1
    end

    v8 = RankProfile.Groups[v3.RankGroupName]

    if v7 then
        v2 = RankProfile.RanksOrder[table.find(RankProfile.RanksOrder, v5) - 1]
        v3 = RankProfile.Ranks[v2]
        v8 = RankProfile.Groups[v6.RankGroupName]
    end

    arg6.ProgressBar.BackgroundColor3 = v8.Color
    arg6.ProgressBar.Size = UDim2.new(0, 0, 1, 0)
    arg6.ProgressBarTexture.ImageColor3 = v8.SecondaryColor
    arg6.ProgressBar:TweenSize(
        UDim2.new(v9, 0, 1, 0),
        "InOut",
        "Quint",
        0.5,
        true
    )
    arg6.LeftRankText.Text = v2
    arg6.LeftELOText.Text = if not v1.CurrentELO then "" else Utility_m:PrettyNumber(v3.RequiredELO)
    local CurrentELOTitle = arg6.CurrentELOTitle
    CurrentELOTitle.Text = if v1.CurrentELO then "Your ELO" else "Play Ranked"
    arg6.CurrentELOText.Text = if not v1.CurrentELO then v1.DuelsPlayed .. " / " .. SeasonLibrary_m.CurrentSeason.RankProfile.NumPlacementDuels else Utility_m:PrettyNumber(
        v1.CurrentELO
    )
    local RightRankText = arg6.RightRankText
    RightRankText.Text = if v1.CurrentELO then v5 else "Unlock your rank"
    arg6.RightELOText.Text = if not v1.CurrentELO then "" else if v6.RequiredELOLeaderboardRanking then "Top " .. Utility_m:PrettyNumber(
        v6.RequiredELOLeaderboardRanking
    ) else Utility_m:PrettyNumber(v6.RequiredELO)
    v9 = v1.CurrentELO or nil
    v8 = if v1.CurrentELO then v3.RequiredELOLeaderboardRanking else nil
    arg6._current_rank_icon = RankIcon_m.new(v9, nil, v8 or math.huge)
    arg6._current_rank_icon:SetParent(arg6.RankCurrentFrame)

    if v1.CurrentELO then
        v9 = if v1.CurrentELO then v6.RequiredELO else nil
        v8 = if v1.CurrentELO then v6.RequiredELOLeaderboardRanking else nil
        arg6._next_rank_icon = RankIcon_m.new(v9, nil, v8 or math.huge)
        arg6._next_rank_icon:SetParent(arg6.RankNextFrame)
    else
        if not arg6._preloaded_rank_icons then
            arg6._preloaded_rank_icons = true

            for _, val in pairs(RankProfile.GroupsOrder) do
                v7 = RankProfile.Groups[val]
                local v11 = RankProfile.Ranks[v7.Ranks[#v7.Ranks]]
                local v12 = RankIcon_m.new(
                    v11.RequiredELO,
                    nil,
                    v11.RequiredELOLeaderboardRanking or math.huge
                )
                v12.Frame.Size = UDim2.new(0, 0, 0, 0)
                v12:SetParent(arg6.RankNextFrame)
            end
        end

        task.spawn(function() -- line: 144
            -- upvalues:
            --  [1] arg6 (copy)
            --  [2] RankProfile (copy)
            --  [3] RankIcon_m (ref)

            local UpdateHash = arg6._update_hash

            for key_1, val_1 in pairs(RankProfile.GroupsOrder) do
                if key_1 ~= 1 then
                end

                if UpdateHash ~= arg6._update_hash then
                    return
                end

                if arg6._next_rank_icon then
                    arg6._next_rank_icon:Destroy()
                    arg6._next_rank_icon = nil
                end

                local v13 = RankProfile.Groups[val_1]
                local v14 = RankProfile.Ranks[v13.Ranks[#v13.Ranks]]
                arg6._next_rank_icon = RankIcon_m.new(
                    v14.RequiredELO,
                    nil,
                    v14.RequiredELOLeaderboardRanking or math.huge
                )
                arg6._next_rank_icon:SetParent(arg6.RankNextFrame)
                wait(1)
            end
        end)
    end

    arg6.Frame.Visible = true
end

function t._Init(arg7) -- line: 177
    arg7:Update(false)
end

return t
