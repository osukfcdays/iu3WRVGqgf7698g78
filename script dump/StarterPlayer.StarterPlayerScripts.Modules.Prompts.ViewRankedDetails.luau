local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local SeasonLibrary_m = require(ReplicatedStorage.Modules.SeasonLibrary)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local ButtonEffect_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("ButtonEffect")
)
local RankIcon_m = require(Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("RankIcon"))
local Prompt_m = require(Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("Prompt"))
local RankGraphSlot = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("RankGraphSlot")
local t = setmetatable({}, Prompt_m)
t.__index = t

function t.new(_, _) -- line: 18
    -- upvalues:
    --  [1] Prompt_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(Prompt_m.new(script.Name), t)
    t_1.CloseButton = t_1.PromptFrame:WaitForChild("Close")
    t_1.List = t_1.PromptFrame:WaitForChild("List")
    t_1.Container = t_1.List:WaitForChild("Container")
    t_1.Layout = t_1.Container:WaitForChild("Layout")
    t_1.ELOShieldMaxELOAllowedText = t_1.Container:WaitForChild("ELOShieldMaxELOAllowed")
    t_1.ELODecayPeriodText = t_1.Container:WaitForChild("ELODecayPeriod")
    t_1.ELODecayAmountText = t_1.Container:WaitForChild("ELODecayAmount")
    t_1.RanksFrame = t_1.Container:WaitForChild("Ranks")
    t_1.RanksContainer = t_1.RanksFrame:WaitForChild("Container")
    t_1._rank_icons = {}
    t_1:_Init()

    return t_1
end

function t.Destroy(arg3) -- line: 42
    -- upvalues:
    --  [1] Prompt_m (copy)

    for _, val in pairs(arg3._rank_icons) do
        val:Destroy()
    end

    Prompt_m.Destroy(arg3)
end

function t._UpdateList(arg4) -- line: 54
    arg4.List.CanvasSize = UDim2.new(0, 0, 0, arg4.Layout.AbsoluteContentSize.Y)
    arg4.List.ClipsDescendants = true
end

function t._GetELORange(_, arg6) -- line: 59
    -- upvalues:
    --  [1] SeasonLibrary_m (copy)
    --  [2] Utility_m (copy)

    local v5 = SeasonLibrary_m.CurrentSeason.RankProfile.Ranks[SeasonLibrary_m.CurrentSeason.RankProfile.Groups[arg6].Ranks[1]].RequiredELOLeaderboardRanking

    if v5 then
        return "Top " .. Utility_m:PrettyNumber(v5)
    end

    v5 = nil
    local v6 = nil

    for _, val_1 in pairs(SeasonLibrary_m.CurrentSeason.RankProfile.RanksOrder) do
        local v7 = SeasonLibrary_m.CurrentSeason.RankProfile.Ranks[val_1]

        if not v5 then
            if v7.RankGroupName == arg6 then
                v5 = v7.RequiredELO
            elseif v5 and v7.RankGroupName ~= arg6 then
                v6 = v7.RequiredELO - 1
                break
            end
        elseif v5 and v7.RankGroupName ~= arg6 then
            v6 = v7.RequiredELO - 1
            break
        end
    end

    if not v5 then
        return ""
    end

    if not v6 then
        return Utility_m:PrettyNumber(v5) .. "+"
    end

    return Utility_m:PrettyNumber(v5) .. "+"
end

function t._Setup(arg7) -- line: 89
    -- upvalues:
    --  [1] SeasonLibrary_m (copy)
    --  [2] RankGraphSlot (copy)
    --  [3] RankIcon_m (copy)
    --  [4] Utility_m (copy)

    local v8 = #SeasonLibrary_m.CurrentSeason.RankProfile.GroupsOrder - 1

    for key_2, val_2 in pairs(SeasonLibrary_m.CurrentSeason.RankProfile.GroupsOrder) do
        if key_2 ~= 1 then
            local v9 = SeasonLibrary_m.CurrentSeason.RankProfile.Groups[val_2]
            local Color = v9.Color
            local SecondaryColor = v9.SecondaryColor
            local v10 = if v9.SecondaryColor == Color3.fromRGB(0, 0, 0) then false else true
            local v11 = RankGraphSlot:Clone()
            v11.Bar.Title.Text = val_2
            v11.Bar.Background.ImageColor3 = if v10 then SecondaryColor else Color
            v11.Bar.BackgroundStriped.ImageColor3 = Color
            v11.Bar.BackgroundStriped.Visible = v10
            v11.Bar.Rank.ELO.UIStroke.Color = Color3.new(
                v9.Color.R * 0.25,
                v9.Color.G * 0.25,
                v9.Color.B * 0.25
            )
            v11.Bar.Rank.ELO.Text = arg7:_GetELORange(val_2)
            v11.Bar.Size = UDim2.new(0.9, 0, 0.3 + 0.5 * (key_2 - 2) / (v8 - 1), 0)
            v11.Size = UDim2.new(1 / v8, 0, 1, 0)
            v11.LayoutOrder = key_2
            v11.ZIndex = key_2
            v11.Parent = arg7.RanksContainer
            v10 = SeasonLibrary_m.CurrentSeason.RankProfile.Ranks[v9.Ranks[#v9.Ranks]]
            local v13 = RankIcon_m.new(
                v10.RequiredELO,
                nil,
                v10.RequiredELOLeaderboardRanking or math.huge
            )
            v13:SetParent(v11.Bar.Rank)
            table.insert(arg7._rank_icons, v13)
        end
    end

    arg7.ELOShieldMaxELOAllowedText.Visible = SeasonLibrary_m.CurrentSeason.ELOShieldMaxELOAllowed or false
    local ELOShieldMaxELOAllowedText = arg7.ELOShieldMaxELOAllowedText
    ELOShieldMaxELOAllowedText.Text = if not arg7.ELOShieldMaxELOAllowedText.Visible then "" else string.format(
        " \226\128\162 Players with %s+ ELO do not receive ELO Shields",
        Utility_m:PrettyNumber(SeasonLibrary_m.CurrentSeason.ELOShieldMaxELOAllowed)
    )
    arg7.ELODecayPeriodText.Visible = SeasonLibrary_m.CurrentSeason.ELODecayThreshold or false
    local ELODecayPeriodText = arg7.ELODecayPeriodText
    ELODecayPeriodText.Text = if not arg7.ELODecayPeriodText.Visible then "" else string.format(
        " \226\128\162 Players with %s+ ELO must play Ranked atleast once every %s to avoid ELO Decay",
        Utility_m:PrettyNumber(SeasonLibrary_m.CurrentSeason.ELODecayThreshold),
        Utility_m:TimeFormat2(
            SeasonLibrary_m.CurrentSeason.ELODecayInactivePeriodDays * 24 * 60 * 60,
            true
        )
    )
    arg7.ELODecayAmountText.Visible = SeasonLibrary_m.CurrentSeason.ELODecayThreshold or false
    local ELODecayAmountText = arg7.ELODecayAmountText
    ELODecayAmountText.Text = if not arg7.ELODecayAmountText.Visible then "" else string.format(
        " \226\128\162 ELO Decay makes you lose %s ELO for every day you remain inactive",
        Utility_m:PrettyNumber((math.abs(SeasonLibrary_m.CurrentSeason.ELODecayPerInactiveDay)))
    )
end

function t._Init(arg8) -- line: 129
    -- upvalues:
    --  [1] ButtonEffect_m (copy)

    arg8.CloseButton.MouseButton1Click:Connect(function() -- line: 130
        -- upvalues:
        --  [1] arg8 (copy)

        arg8:CloseRequest()
    end)
    arg8.Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() -- line: 134
        -- upvalues:
        --  [1] arg8 (copy)

        arg8:_UpdateList()
    end)
    arg8.List:GetPropertyChangedSignal("CanvasPosition"):Connect(function() -- line: 138
        -- upvalues:
        --  [1] arg8 (copy)

        arg8:_UpdateList()
    end)
    arg8:_Setup()
    arg8:_UpdateList()
    ButtonEffect_m:Add(arg8.CloseButton)
end

return t
