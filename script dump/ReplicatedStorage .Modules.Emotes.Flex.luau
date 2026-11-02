local v1 = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local CONSTANTS_m = require(v1.Modules.CONSTANTS)
local Utility_m = require(v1.Modules.Utility)
local Emote_m = require(v1.Modules.Emote)
v1 = CONSTANTS_m.IS_CLIENT

if v1 then
    v1 = require(Players.LocalPlayer.PlayerScripts.Modules.RankIcon)
end

local t = setmetatable({}, Emote_m)
t.__index = t

function t.new(...) -- line: 17
    -- upvalues:
    --  [1] Emote_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(Emote_m.new(nil, script.Name, ...), t)
    t_1:_Init()

    return t_1
end

function t.PlayClient(arg1, ...) -- line: 29
    -- upvalues:
    --  [1] Emote_m (copy)
    --  [2] Players (copy)
    --  [3] Utility_m (copy)
    --  [4] v1 (copy)

    Emote_m.PlayClient(arg1, ...)
    arg1:_PlayAnimation("rbxassetid://110098633210491", "rbxassetid://125433333048429", 4.85)
    local v3 = arg1._humanoid and arg1._humanoid.Parent and Players:GetPlayerFromCharacter(
        arg1._humanoid.Parent
    ) or Players.LocalPlayer
    local v4 = v3

    if v4 then
        v4 = v3:GetAttribute("StatisticDuelsWinStreak")
    end

    local v5 = v3

    if v5 then
        v5 = v3:GetAttribute("Level")
    end

    local v6 = v3

    if v6 then
        v6 = v3:GetAttribute("DisplayELO")
    end

    local v7 = v3 and v3.UserId
    v3 = arg1:_SetupMultipleProps(script.FlexProp)
    v3.Pillow1.Attachment.BillboardGui.Streak.Value.Text = Utility_m:PrettyNumber(v4 or 0)
    v3.Pillow2.Attachment.BillboardGui.Level.Title.Text = Utility_m:PrettyNumber(v5 or 1)
    v1.new(v6, v7):SetParent(v3.Pillow3.Attachment.BillboardGui.Rank)
    arg1:CreateSound(
        "rbxassetid://97330697628857",
        0.75,
        1,
        nil,
        true
    )
end

function t._Init(_) -- line: 54
end

return t
