local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local CONSTANTS_m = require(ReplicatedStorage.Modules.CONSTANTS)
local DuelLibrary_m = require(ReplicatedStorage.Modules.DuelLibrary)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local LeaderboardController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.LeaderboardController
)
local _ = require(Players.LocalPlayer.PlayerScripts.Controllers.ControlsController)
local RankIcon_m = require(Players.LocalPlayer.PlayerScripts.Modules.RankIcon)
local TeammateSlot = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("TeammateSlot")
local udim2 = UDim2.new(0.5, 0, 0.5, 0)
local t = {}
t.__index = t

function t.new(
    arg1,
    arg2,
    arg3,
    arg4,
    arg5,
    arg6,
    arg7
) -- line: 17
    -- upvalues:
    --  [1] t (copy)
    --  [2] TeammateSlot (copy)

    local t_1 = setmetatable({}, t)
    t_1.SlotFrame = TeammateSlot:Clone()
    t_1._destroyed = false
    t_1._connections = {}
    t_1._user_id = arg1
    t_1._controls = arg2
    t_1._health_percent = arg3 or 1
    t_1._disconnected = arg4
    t_1._hide_health = arg5
    t_1._win_streak = arg6 and arg6 > 0 and arg6 or nil
    t_1._level = arg7 or nil
    t_1._display_elo_set = false
    t_1._display_elo = nil
    t_1._rank_icon = nil
    t_1._override_icon = nil
    t_1._override_icon_size = nil
    t_1._override_icon_color = nil
    t_1._override_icon_text = nil
    t_1._override_icon_text_color = nil
    t_1:_Init()

    return t_1
end

function t.SetDetails(
    arg8,
    arg9,
    arg10,
    arg11,
    arg12,
    arg13,
    arg14
) -- line: 49
    arg8._controls = arg9
    arg8:SetHealthPercent(arg10, true)
    arg8:SetDisconnected(arg11, true)
    arg8._hide_health = arg12
    arg8._win_streak = arg13 and arg13 > 0 and arg13 or nil
    arg8._level = arg14 or nil
    arg8:_UpdateDetails()
end

function t.SetDisplayELO(arg15, arg16) -- line: 59
    arg15._display_elo_set = true
    arg15._display_elo = arg16
    arg15:_UpdateRankIcon()
end

function t.SetDisconnected(arg17, arg18, arg19) -- line: 65
    if arg18 then
        arg17:OverrideIcon(
            nil,
            nil,
            nil,
            nil,
            nil,
            arg19
        )
    end

    arg17._disconnected = arg18

    if not arg19 then
        arg17:_UpdateDetails()
    end
end

function t.SetHealthPercent(arg20, arg21, arg22) -- line: 77
    arg20._health_percent = arg21 or 1

    if not arg22 then
        arg20:_UpdateDetails()
    end
end

function t.OverrideIcon(
    arg23,
    arg24,
    arg25,
    arg26,
    arg27,
    arg28,
    arg29
) -- line: 85
    if arg23._disconnected then
        return
    end

    arg23._override_icon = arg24
    arg23._override_icon_size = arg25
    arg23._override_icon_color = arg26
    arg23._override_icon_text = arg27
    arg23._override_icon_text_color = arg28

    if not arg29 then
        arg23:_UpdateDetails()
    end
end

function t.SetStaggeredSpawnsTurn(arg30, arg31, arg32) -- line: 101
    -- upvalues:
    --  [1] DuelLibrary_m (copy)

    if not arg31 then
        arg30:OverrideIcon()

        return
    end

    arg30:OverrideIcon(
        "rbxassetid://15319354627",
        UDim2.new(0.75, 0, 0.75, 0),
        Color3.fromRGB(0, 0, 0),
        arg31,
        DuelLibrary_m:GetTeamColor(arg32, Color3.fromRGB(255, 255, 255))
    )
end

function t.Destroy(arg33) -- line: 109
    arg33._destroyed = true

    for _, val in pairs(arg33._connections) do
        val:Disconnect()
    end

    arg33._connections = {}
    arg33:SetDisplayELO(nil)
    pcall(function() -- line: 120
        -- upvalues:
        --  [1] arg33 (copy)

        arg33.SlotFrame:Destroy()
    end)
end

function t._UpdateRankIcon(arg34) -- line: 129
    -- upvalues:
    --  [1] RankIcon_m (copy)

    if arg34._rank_icon then
        arg34._rank_icon:Destroy()
        arg34._rank_icon = nil
    end

    if arg34._destroyed or not arg34._display_elo_set then
        return
    end

    local v4 = arg34.SlotFrame:FindFirstChild("Container")

    if v4 then
        v4 = arg34.SlotFrame.Container:FindFirstChild("Rank")
    end

    if not v4 then
        return
    end

    arg34._rank_icon = RankIcon_m.new(arg34._display_elo, arg34._user_id)
    arg34._rank_icon:SetParent(v4)
end

function t._UpdateDetails(arg35) -- line: 149
    -- upvalues:
    --  [1] udim2 (copy)
    --  [2] CONSTANTS_m (copy)
    --  [3] Utility_m (copy)

    if arg35._destroyed then
        return
    end

    local color_1 = Color3.fromRGB(255, 50, 50):Lerp(
        Color3.fromRGB(255, 215, 0):Lerp(Color3.fromRGB(100, 255, 50), arg35._health_percent),
        arg35._health_percent
    )
    local color_4 = Color3.new(color_1.R / 2, color_1.G / 2, color_1.B / 2)
    local v5 = not arg35._disconnected

    if v5 then
        v5 = arg35._health_percent > 0
    end

    local Health = arg35.SlotFrame.Container.Health
    local v6 = v5 and not arg35._hide_health
    Health.Visible = v6
    arg35.SlotFrame.Container.Health.Bar.Size = UDim2.new(arg35._health_percent, 0, 1, 0)
    arg35.SlotFrame.Container.Health.BackgroundColor3 = color_4
    arg35.SlotFrame.Container.Health.UIStroke.Color = Color3.new(
        color_1.R * 0.25,
        color_1.G * 0.25,
        color_1.B * 0.25
    )
    arg35.SlotFrame.Container.Health.Bar.BackgroundColor3 = color_1
    arg35.SlotFrame.Container.Health.Bar.UIStroke.Color = color_1
    arg35.SlotFrame.Container.Headshot.ImageTransparency = if v5 then 0 else 0.75
    arg35.SlotFrame.Container.Icon.Visible = not v5
    local v7 = arg35._override_icon
    local Icon = arg35.SlotFrame.Container.Icon
    v7 = v7 or (if not arg35._disconnected then if v5 then "" else "rbxassetid://16802957270" else "rbxassetid://16782728353")
    Icon.Image = v7
    v7 = arg35._override_icon_size
    local Icon_1 = arg35.SlotFrame.Container.Icon

    if not v7 then
        v7 = udim2
    end

    Icon_1.Size = v7
    v7 = arg35._override_icon_color
    local Icon_2 = arg35.SlotFrame.Container.Icon

    if not v7 then
        v7 = Color3.fromRGB(255, 255, 255)
    end

    Icon_2.ImageColor3 = v7
    arg35.SlotFrame.Container.Icon.TextLabel.Text = arg35._override_icon_text or ""
    v7 = arg35._override_icon_text_color
    local TextLabel = arg35.SlotFrame.Container.Icon.TextLabel
    v7 = v7 or Color3.fromRGB(0, 0, 0)
    TextLabel.TextColor3 = v7
    local Controls = arg35.SlotFrame.Container.Controls
    v7 = if not v5 then "" else if arg35._win_streak then "" else arg35._controls and CONSTANTS_m.CONTROLS_IMAGES[arg35._controls] or ""
    Controls.Image = v7
    local Streak = arg35.SlotFrame.Container.Streak
    v7 = v5 and arg35._win_streak and arg35._win_streak > 0
    Streak.Visible = v7
    arg35.SlotFrame.Container.Streak.Value.Text = Utility_m:PrettyNumber(arg35._win_streak or 0)
    v7 = v5
    local Level = arg35.SlotFrame.Container.Level

    if v7 then
        v7 = arg35._level
    end

    Level.Visible = v7
    arg35.SlotFrame.Container.Level.Title.Text = Utility_m:PrettyNumber(arg35._level or 0)
    arg35.SlotFrame.Container.Rank.Visible = v5
end

function t._Setup(arg36) -- line: 179
    -- upvalues:
    --  [1] CONSTANTS_m (copy)

    arg36.SlotFrame.Container.Headshot.Image = string.format(
        CONSTANTS_m.HEADSHOT_IMAGE,
        arg36._user_id
    )
end

function t._Init(arg37) -- line: 183
    -- upvalues:
    --  [1] LeaderboardController_m (copy)

    local Connections = arg37._connections
    local v8 = LeaderboardController_m:GetLeaderboardRefreshedSignal("Highest ELO")
    table.insert(Connections, v8:Connect(function() -- line: 184
        -- upvalues:
        --  [1] arg37 (copy)

        arg37:_UpdateRankIcon()
    end))
    arg37.SlotFrame.Destroying:Connect(function() -- line: 188
        -- upvalues:
        --  [1] arg37 (copy)

        arg37:Destroy()
    end)
    arg37:_Setup()
    arg37:_UpdateDetails()
end

return t
