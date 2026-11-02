local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local SeasonLibrary_m = require(ReplicatedStorage.Modules.SeasonLibrary)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local RankIconLabel = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("RankIconLabel")
local RankIcon = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("RankIcon")
local t = {}
t.__index = t

function t.new(arg1, arg2, arg3) -- line: 13
    -- upvalues:
    --  [1] t (copy)
    --  [2] SeasonLibrary_m (copy)
    --  [3] RankIcon (copy)

    local t_1 = setmetatable({}, t)
    t_1.ELO = arg1
    t_1.UserID = arg2
    t_1.ELOLeaderboardRanking = arg3 or SeasonLibrary_m:GetHighestELOLeaderboardRanking(
        t_1.ELO,
        t_1.UserID
    )
    t_1.RankName = SeasonLibrary_m:GetRank(t_1.ELO, t_1.UserID, t_1.ELOLeaderboardRanking)
    t_1.RankInfo = SeasonLibrary_m.CurrentSeason.RankProfile.Ranks[t_1.RankName]
    t_1.Frame = RankIcon:Clone()
    t_1.Icon = t_1.Frame:WaitForChild("Icon")
    t_1._destroyed = false
    t_1._label = nil
    t_1._label_text = nil
    t_1:_Init()

    return t_1
end

function t.GetLabelText(arg4) -- line: 37
    return arg4._label_text
end

function t.GetLabel(arg5) -- line: 41
    return arg5._label
end

function t.SetParent(arg6, arg7) -- line: 45
    pcall(function() -- line: 46
        -- upvalues:
        --  [1] arg6 (copy)
        --  [2] arg7 (copy)

        arg6.Frame.Parent = arg7
    end)
end

function t.SetLabel(arg8, arg9, arg10) -- line: 51
    -- upvalues:
    --  [1] RankIconLabel (copy)

    if not arg8._label then
        arg8._label = RankIconLabel:Clone()
        arg8._label.Parent = arg8.Frame
        arg8._label_text = arg8._label:WaitForChild("Title")
    end

    local v2 = arg9
    local LabelText = arg8._label_text

    if not v2 then
        v2 = arg8._label_text.Text
    end

    LabelText.Text = v2
    local LabelText_1 = arg8._label_text
    v2 = arg10 or arg8._label_text.TextColor3
    LabelText_1.TextColor3 = v2
end

function t.SetLabelFromELOEvent(arg11, arg12, arg13, arg14) -- line: 62
    -- upvalues:
    --  [1] Utility_m (copy)
    --  [2] SeasonLibrary_m (copy)

    if arg12 and math.abs(arg12) < 0.001 then
        arg12 = math.abs(arg12)
    end

    local v3

    if arg12 then
        v3 = string.format("%s%s ", if not (arg12 >= 0) then "" else "+", arg12)

        if not v3 then
            if arg13 then
                v3 = Utility_m:PrettyNumber(arg13)

                if not v3 then
                    v3 = arg14 and arg14 .. "/" .. SeasonLibrary_m.CurrentSeason.RankProfile.NumPlacementDuels or ""
                end
            else
                v3 = arg14 and arg14 .. "/" .. SeasonLibrary_m.CurrentSeason.RankProfile.NumPlacementDuels or ""
            end
        end
    elseif arg13 then
        v3 = Utility_m:PrettyNumber(arg13)

        if not v3 then
            v3 = arg14 and arg14 .. "/" .. SeasonLibrary_m.CurrentSeason.RankProfile.NumPlacementDuels or ""
        end
    else
        v3 = arg14 and arg14 .. "/" .. SeasonLibrary_m.CurrentSeason.RankProfile.NumPlacementDuels or ""
    end

    local v5 = if arg12 then arg12 > 0 and Color3.fromRGB(100, 255, 50) or arg12 < 0 and Color3.fromRGB(
        255,
        50,
        50
    ) or Color3.fromRGB(255, 215, 0) else Color3.fromRGB(255, 255, 255) or arg12 > 0 and Color3.fromRGB(
        100,
        255,
        50
    ) or arg12 < 0 and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(255, 215, 0)
    arg11:SetLabel(v3, v5)
end

function t.Destroy(arg15) -- line: 80
    if arg15._destroyed then
        return
    end

    arg15._destroyed = true
    pcall(function() -- line: 87
        -- upvalues:
        --  [1] arg15 (copy)

        arg15.Frame:Destroy()
    end)
end

function t._Setup(arg16) -- line: 96
    arg16.Icon.Image = arg16.RankInfo.Image
end

function t._Init(arg17) -- line: 100
    arg17.Frame.Destroying:Connect(function() -- line: 101
        -- upvalues:
        --  [1] arg17 (copy)

        arg17:Destroy()
    end)
    arg17:_Setup()
end

return t
