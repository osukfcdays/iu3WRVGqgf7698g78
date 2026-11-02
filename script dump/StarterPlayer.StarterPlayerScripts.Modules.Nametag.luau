local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CONSTANTS_m = require(ReplicatedStorage.Modules.CONSTANTS)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local ComplianceController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.ComplianceController
)
local PlayerDataController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.PlayerDataController
)
local WeaponStatusHandler_m = require(Players.LocalPlayer.PlayerScripts.Modules.WeaponStatusHandler)
local RankIcon_m = require(Players.LocalPlayer.PlayerScripts.Modules.RankIcon)
local NametagGui = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("NametagGui")
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
    --  [2] NametagGui (copy)

    local t_1 = setmetatable({}, t)
    t_1.BillboardGui = NametagGui:Clone()
    t_1._player_object = arg1
    t_1._controls = arg2
    t_1._win_streak = arg3 or 0
    t_1._level = arg4 or 0
    t_1._elo = arg5
    t_1._status = arg6
    t_1._rank_icon = nil
    t_1._is_matchmaking = arg7
    t_1:_Init()

    return t_1
end

function t.GetWinStreak(arg8) -- line: 40
    return arg8._win_streak
end

function t.SetParent(arg9, arg10) -- line: 44
    arg9.BillboardGui.Parent = arg10
    arg9:_UpdateLayout()
end

function t.Destroy(arg11) -- line: 49
    -- upvalues:
    --  [1] WeaponStatusHandler_m (copy)

    WeaponStatusHandler_m:ClearStatusElements(arg11.BillboardGui.Elements.NameDisplay.DisplayName)
    WeaponStatusHandler_m:ClearStatusElements(arg11.BillboardGui.Elements.NameDisplay.Username)
    arg11.BillboardGui:Destroy()

    if arg11._rank_icon then
        arg11._rank_icon:Destroy()
    end

    if arg11._matchmaking_connection then
        arg11._matchmaking_connection:Disconnect()
        arg11._matchmaking_connection = nil
    end
end

function t._UpdateLayout(arg12) -- line: 69
    arg12.BillboardGui.Elements.NameDisplay.Size = UDim2.new(
        0,
        math.max(
            arg12.BillboardGui.Elements.NameDisplay.DisplayName.TextBounds.X,
            arg12.BillboardGui.Elements.NameDisplay.Username.TextBounds.X
        ),
        1,
        0
    )
    local Streak = arg12.BillboardGui.Elements.Data.Streak
    local New_1 = UDim2.new
    local maximum = math.max(
        0,
        (arg12.BillboardGui.Elements.Data.Streak.Value.TextBounds.X - arg12.BillboardGui.Elements.Data.Streak.AbsoluteSize.X) / 2
    )
    Streak.Position = New_1(0.5, -maximum, 0.5, 0)
    local Level = arg12.BillboardGui.Elements.Data.Level
    local New_2 = UDim2.new
    local maximum_1 = math.max(
        0,
        (arg12.BillboardGui.Elements.Data.Level.Title.TextBounds.X - arg12.BillboardGui.Elements.Data.Level.AbsoluteSize.X) / 2
    )
    Level.Position = New_2(0.5, -maximum_1, 0.5, 0)
end

function t._SetupMatchmaking(arg13) -- line: 75
    -- upvalues:
    --  [1] RunService (copy)

    arg13.BillboardGui.Matchmaking.Visible = arg13._is_matchmaking

    if not arg13.BillboardGui.Matchmaking.Visible then
        return
    end

    local Container = arg13.BillboardGui.Matchmaking.Container
    local Scroller = Container.Scroller
    local Icon1 = Scroller.Icon1
    local Icon2 = Scroller.Icon2
    arg13._matchmaking_connection = RunService.RenderStepped:Connect(function() -- line: 87
        -- upvalues:
        --  [1] Icon1 (copy)
        --  [2] Container (copy)
        --  [3] Scroller (copy)
        --  [4] Icon2 (copy)

        local sine = math.sin(tick() * 0.75)
        local sine_1 = math.sin(tick() * 1.5)
        local v1 = sine * 10
        local v2 = -sine * 0.625 % Icon1.Size.X.Scale
        local v3 = -sine_1 * 0.125
        Container.Position = UDim2.new(sine * 0.025 + 0.5, 0, sine_1 * 0.025 + 0.25, 0)
        Container.Rotation = v1
        Scroller.Rotation = -v1
        Icon1.Position = UDim2.new(v2, 0, v3, 0)
        Icon2.Position = UDim2.new(v2 - 1.5, 0, v3, 0)
    end)
end

function t._Setup(arg14) -- line: 105
    -- upvalues:
    --  [1] CONSTANTS_m (copy)
    --  [2] Utility_m (copy)
    --  [3] ComplianceController_m (copy)
    --  [4] WeaponStatusHandler_m (copy)
    --  [5] PlayerDataController_m (copy)
    --  [6] RankIcon_m (copy)

    arg14.BillboardGui.Elements.Controls.Icon.Image = CONSTANTS_m.CONTROLS_IMAGES_CENTERED[arg14._controls] or ""
    local v7 = Utility_m:SanitizeName(arg14._player_object.Name)
    arg14.BillboardGui.Elements.NameDisplay.Username.Text = if arg14._player_object.DisplayName == v7 then "" else "@" .. v7
    arg14.BillboardGui.Elements.NameDisplay.DisplayName.Text = ComplianceController_m:GetName(
        arg14._player_object
    )
    WeaponStatusHandler_m:ApplyItemStatusToText(
        arg14.BillboardGui.Elements.NameDisplay.DisplayName,
        arg14._status
    )
    local v9 = PlayerDataController_m:GetSetting("PlayerList Leaderstat")
    local v10 = false
    local Rank = arg14.BillboardGui.Elements.Data.Rank

    if v9 == "Current ELO" then
        v10 = arg14._elo
    end

    Rank.Visible = v10

    if arg14._elo then
        arg14._rank_icon = RankIcon_m.new(arg14._elo, arg14._player_object.UserId)
        arg14._rank_icon:SetParent(arg14.BillboardGui.Elements.Data.Rank)
    end

    local Streak_1 = arg14.BillboardGui.Elements.Data.Streak
    local v11 = if v9 ~= "Win Streak" then false else arg14._win_streak > 0
    Streak_1.Visible = v11
    arg14.BillboardGui.Elements.Data.Streak.Value.Text = Utility_m:PrettyNumber(arg14._win_streak)
    v11 = true
    local Level_1 = arg14.BillboardGui.Elements.Data.Level

    if v9 ~= "Level" then
        v11 = not arg14.BillboardGui.Elements.Data.Streak.Visible and not arg14.BillboardGui.Elements.Data.Rank.Visible
    end

    Level_1.Visible = v11
    arg14.BillboardGui.Elements.Data.Level.Title.Text = Utility_m:PrettyNumber(arg14._level)
    arg14:_SetupMatchmaking()
    arg14:_UpdateLayout()
end

function t._Init(arg15) -- line: 133
    arg15.BillboardGui.Elements:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- line: 134
        -- upvalues:
        --  [1] arg15 (copy)

        arg15:_UpdateLayout()
    end)
    arg15.BillboardGui.Elements.NameDisplay.DisplayName:GetPropertyChangedSignal("TextBounds"):Connect(
        function() -- line: 138
            -- upvalues:
            --  [1] arg15 (copy)

            arg15:_UpdateLayout()
        end
    )
    arg15.BillboardGui.Elements.NameDisplay.Username:GetPropertyChangedSignal("TextBounds"):Connect(
        function() -- line: 142
            -- upvalues:
            --  [1] arg15 (copy)

            arg15:_UpdateLayout()
        end
    )
    arg15.BillboardGui.Elements.Data.Streak:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- line: 146
        -- upvalues:
        --  [1] arg15 (copy)

        arg15:_UpdateLayout()
    end)
    arg15.BillboardGui.Elements.Data.Streak.Value:GetPropertyChangedSignal("TextBounds"):Connect(
        function() -- line: 150
            -- upvalues:
            --  [1] arg15 (copy)

            arg15:_UpdateLayout()
        end
    )
    arg15.BillboardGui.Elements.Data.Level:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- line: 154
        -- upvalues:
        --  [1] arg15 (copy)

        arg15:_UpdateLayout()
    end)
    arg15.BillboardGui.Elements.Data.Level.Title:GetPropertyChangedSignal("TextBounds"):Connect(function() -- line: 158
        -- upvalues:
        --  [1] arg15 (copy)

        arg15:_UpdateLayout()
    end)
    task.spawn(arg15._Setup, arg15)
end

return t
