local ReplicatedStorage = game:GetService("ReplicatedStorage")
local _ = game:GetService("GuiService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local _ = require(ReplicatedStorage.Modules.ItemLibrary)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local ComplianceController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.ComplianceController
)
local TeammateSlot_m = require(Players.LocalPlayer.PlayerScripts.Modules.TeammateSlot)
local RankIcon_m = require(Players.LocalPlayer.PlayerScripts.Modules.RankIcon)
local ScoreboardPlayerSlot = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild(
    "ScoreboardPlayerSlot"
)
local t = {}
t.__index = t

function t.new(arg1, arg2) -- line: 18
    -- upvalues:
    --  [1] t (copy)
    --  [2] ScoreboardPlayerSlot (copy)

    local t_1 = setmetatable({}, t)
    t_1.Scoreboard = arg1
    t_1.ClientDueler = arg2
    t_1.Frame = ScoreboardPlayerSlot:Clone()
    t_1.UIGradient = t_1.Frame:WaitForChild("UIGradient")
    t_1.TeammateSlotContainer = t_1.Frame:WaitForChild("TeammateSlotContainer")
    t_1.RankContainer = t_1.Frame:WaitForChild("RankContainer")
    t_1.ConnectionLevel = t_1.Frame:WaitForChild("ConnectionLevel")
    t_1.ConnectionLevelIcon = t_1.ConnectionLevel:WaitForChild("Icon")
    t_1.DisplayNameText = t_1.Frame:WaitForChild("DisplayName")
    t_1.UsernameText = t_1.Frame:WaitForChild("Username")
    t_1.EliminationsText = t_1.Frame:WaitForChild("Eliminations")
    t_1.DeathsText = t_1.Frame:WaitForChild("Deaths")
    t_1.AssistsText = t_1.Frame:WaitForChild("Assists")
    t_1.PingText = t_1.Frame:WaitForChild("Ping")
    t_1.ScoreText = t_1.Frame:WaitForChild("Score")
    t_1.WeaponIcon = t_1.Frame:WaitForChild("Weapon")
    t_1._destroyed = false
    t_1._update_ping_connection = nil
    t_1._teammate_slot = nil
    t_1._rank_icon = nil
    t_1:_Init()

    return t_1
end

function t.UpdatePreferredTransparency(arg3, arg4) -- line: 52
    local v1 = arg4
    local UIGradient = arg3.UIGradient
    local New = NumberSequence.new

    if not v1 then
        v1 = arg3.Scoreboard:GetBackgroundTransparency()
    end

    UIGradient.Transparency = New(0, v1)
end

function t.Update(arg5) -- line: 56
    -- upvalues:
    --  [1] Utility_m (copy)
    --  [2] ComplianceController_m (copy)
    --  [3] TeammateSlot_m (copy)
    --  [4] RankIcon_m (copy)

    arg5:_Clear()

    if arg5._destroyed then
        return
    end

    local v2 = arg5.ClientDueler:Get("TeamID")
    local v3 = arg5.ClientDueler.ClientFighter:Get("Controls")
    local index = table.find(arg5.Scoreboard.DuelInterface.ClientDuel.Duelers, arg5.ClientDueler)
    local v5 = arg5.ClientDueler:GetHealth() / arg5.ClientDueler:GetMaxHealth()
    local floorValue = math.floor(arg5.ClientDueler:Get("Damage") + 0.5)
    local v6 = if arg5.Scoreboard.DuelInterface.ClientDuel.IsRanked or arg5.Scoreboard.DuelInterface.ClientDuel:Get(
        "ScoresBehavior"
    ) ~= "Teams" or arg5.Scoreboard.DuelInterface.ClientDuel:Get("ScoreNeededToWin") then nil else arg5.ClientDueler.Player:GetAttribute(
        "StatisticDuelsWinStreak"
    )
    local Level = arg5.ClientDueler.Player:GetAttribute("Level")
    local v7 = if arg5.Scoreboard.DuelInterface.ClientDuel:Get("ScoresBehavior") == "Duelers" then arg5.Scoreboard.DuelInterface.ClientDuel:Get(
        "Scores"
    )[arg5.ClientDueler:Get("DuelerID")] else false
    local v9 = Utility_m:SanitizeName(arg5.ClientDueler.Player.Name)
    arg5.Frame.BackgroundColor3 = arg5.Scoreboard:GetTeamColor(v2)
    arg5.UsernameText.Text = if arg5.ClientDueler.Player.DisplayName == v9 then "" else "@" .. v9
    arg5.DisplayNameText.Text = ComplianceController_m:GetName(arg5.ClientDueler.Player)
    local DisplayNameText_1 = arg5.DisplayNameText
    DisplayNameText_1.Position = arg5.UsernameText.Text == "" and UDim2.new(0.1, 0, 0.5, 0) or UDim2.new(
        0.1,
        0,
        0.375,
        0
    )
    arg5.EliminationsText.Text = Utility_m:PrettyNumber(arg5.ClientDueler:Get("Eliminations"))
    arg5.DeathsText.Text = Utility_m:PrettyNumber(arg5.ClientDueler:Get("Deaths"))
    arg5.AssistsText.Text = Utility_m:PrettyNumber(arg5.ClientDueler:Get("Assists"))
    arg5.ConnectionLevelIcon.Image = Utility_m:GetConnectionLevelIcon(
        arg5.ClientDueler.ClientFighter:Get("ConnectionLevel")
    ) or ""
    local ConnectionLevel = arg5.ConnectionLevel
    ConnectionLevel.Position = arg5.ClientDueler.IsLocalPlayer and UDim2.new(0.925, 0, 0.55, 0) or UDim2.new(
        0.925,
        0,
        0.5,
        0
    )
    local ConnectionLevel_1 = arg5.ConnectionLevel
    ConnectionLevel_1.AnchorPoint = arg5.ClientDueler.IsLocalPlayer and Vector2.new(0.5, 1) or Vector2.new(
        0.5,
        0.5
    )
    arg5.PingText.Visible = arg5.ClientDueler.IsLocalPlayer
    local ScoreText = arg5.ScoreText
    ScoreText.Text = v7 and Utility_m:PrettyNumber(v7) or Utility_m:PrettyNumber(floorValue)
    arg5.WeaponIcon.Image = ""
    local v22 = TeammateSlot_m.new(
        arg5.ClientDueler.Player.UserId,
        v3,
        v5,
        not index,
        true,
        v6,
        Level
    )
    v22.SlotFrame.Parent = arg5.TeammateSlotContainer

    if arg5.ClientDueler:GetStaggeredSpawnsTurn() then
        v22:SetStaggeredSpawnsTurn(arg5.ClientDueler:GetStaggeredSpawnsTurn(), v2)
    end

    if
        arg5.Scoreboard.DuelInterface.ClientDuel.IsRanked
        and arg5.ClientDueler:CanShowRankToLocalPlayer()
    then
        arg5._rank_icon = RankIcon_m.new(
            arg5.ClientDueler.Player:GetAttribute("DisplayELO"),
            arg5.ClientDueler.Player.UserId
        )
        arg5._rank_icon:SetParent(arg5.RankContainer)
    end

    arg5:UpdatePreferredTransparency()
end

function t.Destroy(arg6) -- line: 111
    arg6._destroyed = true

    if arg6._update_ping_connection then
        arg6._update_ping_connection:Disconnect()
        arg6._update_ping_connection = nil
    end

    arg6:_Clear()
    arg6.Frame:Destroy()
end

function t._UpdatePing(arg7) -- line: 128
    -- upvalues:
    --  [1] Utility_m (copy)

    local v24 = Utility_m:GetLocalConnectionPing()
    local v25 = Utility_m:GetConnectionLevel(v24)
    local v26 = Utility_m:GetConnectionLevelIcon(v25)
    arg7.PingText.Text = v24
    arg7.ConnectionLevelIcon.Image = v26 or ""
end

function t._Clear(arg8) -- line: 137
    if arg8._teammate_slot then
        arg8._teammate_slot:Destroy()
        arg8._teammate_slot = nil
    end

    if arg8._rank_icon then
        arg8._rank_icon:Destroy()
        arg8._rank_icon = nil
    end
end

function t._Setup(arg9) -- line: 149
    -- upvalues:
    --  [1] RunService (copy)

    if arg9.ClientDueler.IsLocalPlayer then
        arg9._update_ping_connection = RunService.RenderStepped:Connect(function() -- line: 151
            -- upvalues:
            --  [1] arg9 (copy)

            arg9:_UpdatePing()
        end)
        arg9:_UpdatePing()
    end
end

function t._Init(arg10) -- line: 159
    arg10:_Setup()
    arg10:Update()
end

return t
