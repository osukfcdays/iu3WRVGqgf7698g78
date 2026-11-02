local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local DuelLibrary_m = require(ReplicatedStorage.Modules.DuelLibrary)
local Signal_m = require(ReplicatedStorage.Modules.Signal)
local SpectateController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.SpectateController
)
local TeammateSlot_m = require(Players.LocalPlayer.PlayerScripts.Modules.TeammateSlot)
local ButtonEffect_m = require(Players.LocalPlayer.PlayerScripts.Modules.ButtonEffect)
local DuelsBoardTeamSlot = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild(
    "DuelsBoardTeamSlot"
)
local DuelsBoardSlot = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild(
    "DuelsBoardSlot"
)
local t = {}
t.__index = t

function t.new(arg1) -- line: 16
    -- upvalues:
    --  [1] t (copy)
    --  [2] Signal_m (copy)
    --  [3] DuelsBoardSlot (copy)

    local t_1 = setmetatable({}, t)
    t_1.GameOver = Signal_m.new()
    t_1.ClientDuel = arg1
    t_1.Frame = DuelsBoardSlot:Clone()
    t_1._destroyed = false
    t_1._connections = {}
    t_1._num_teams = t_1.ClientDuel:Get("NumTeams")
    t_1._team_slots = {}
    t_1._team_ids = {}
    t_1._dueler_slots = {}
    t_1:_Init()

    return t_1
end

function t.Destroy(arg2) -- line: 40
    arg2._destroyed = true

    for _, val in pairs(arg2._connections) do
        val:Disconnect()
    end

    arg2.GameOver:Destroy()
    arg2.Frame:Destroy()
end

function t._DuelerAdded(arg3, arg4) -- line: 55
    -- upvalues:
    --  [1] TeammateSlot_m (copy)

    if arg3._destroyed then
        return
    end

    arg3:_UpdateScores()
    local index = table.find(arg3._team_ids, arg4:Get("TeamID"))
    local v3 = TeammateSlot_m.new(
        arg4.Player.UserId,
        arg4.ClientFighter:Get("Controls"),
        1,
        false,
        false,
        arg4.Player:GetAttribute("StatisticDuelsWinStreak"),
        arg4.Player:GetAttribute("Level")
    )
    v3.SlotFrame.Container.Background.Visible = false
    local SlotFrame = v3.SlotFrame
    SlotFrame.Parent = index and arg3.Frame.Teams[index].Container or arg3.Frame.Teams
    arg3._dueler_slots[arg4] = v3

    local function update_health() -- line: 68
        -- upvalues:
        --  [1] v3 (copy)
        --  [2] arg4 (copy)

        v3:SetHealthPercent(arg4:GetHealth() / arg4:GetMaxHealth())
    end

    table.insert(arg3._connections, arg4.HealthChanged:Connect(update_health))
    v3:SetHealthPercent(arg4:GetHealth() / arg4:GetMaxHealth())
end

function t._DuelerRemoved(arg5, arg6) -- line: 76
    if not arg5.ClientDuel:Get("ArcadeMode") then
        return
    end

    local v10 = arg5._dueler_slots[arg6]

    if not v10 then
        return
    end

    v10:Destroy()
    arg5._dueler_slots[arg6] = nil
end

function t._UpdateScores(arg7) -- line: 91
    local v11 = arg7.ClientDuel:Get("ScoresBehavior")
    local v12 = arg7.ClientDuel:Get("Scores")

    for key_1, val_1 in pairs(arg7._team_ids) do
        local Score = arg7.Frame.Teams[key_1].Container.Score
        local v13 = v11 == "Teams"
        Score.Visible = v13
        arg7.Frame.Teams[key_1].Container.Score.Text = v12[val_1] or "0"
    end
end

function t._UpdateMap(arg8) -- line: 101
    -- upvalues:
    --  [1] DuelLibrary_m (copy)

    local v14 = arg8.ClientDuel.Map and arg8.ClientDuel.Map.Model and arg8.ClientDuel.Map.Model.Name
    local Picture = arg8.Frame.Picture
    Picture.Image = if v14 then DuelLibrary_m.Maps[v14].Image else ""
    local NoPicture = arg8.Frame.NoPicture
    NoPicture.Visible = v14 == nil
end

function t._Setup(arg9) -- line: 108
    -- upvalues:
    --  [1] DuelsBoardTeamSlot (copy)

    for index_1 = 1, arg9._num_teams do
        local v16 = DuelsBoardTeamSlot:Clone()
        v16.Container.Layout.HorizontalAlignment = if arg9._num_teams == 2 then if index_1 ~= 1 then Enum.HorizontalAlignment.Left else Enum.HorizontalAlignment.Right or Enum.HorizontalAlignment.Left else Enum.HorizontalAlignment.Left
        local Score_1 = v16.Container.Score
        local v17 = if v16.Container.Layout.HorizontalAlignment ~= Enum.HorizontalAlignment.Right then -99999 else 99999
        Score_1.LayoutOrder = v17
        v16.Size = UDim2.new(0.9 / arg9._num_teams, 0, 1, 0)
        v16.LayoutOrder = index_1 * 2
        v16.Name = index_1
        v16.Parent = arg9.Frame.Teams
        arg9._team_slots[index_1] = v16
        table.insert(arg9._team_ids, utf8.char(index_1))
    end

    local Spectate = arg9.Frame.Teams.Spectate
    Spectate.LayoutOrder = if arg9._num_teams ~= 2 then -1 else 3

    for _, val_2 in pairs(arg9.ClientDuel.Duelers) do
        task.defer(arg9._DuelerAdded, arg9, val_2)
    end
end

function t._Init(arg10) -- line: 128
    -- upvalues:
    --  [1] SpectateController_m (copy)
    --  [2] ButtonEffect_m (copy)

    arg10.Frame.SpectateButton.MouseButton1Click:Connect(function() -- line: 129
        -- upvalues:
        --  [1] SpectateController_m (ref)
        --  [2] arg10 (copy)

        SpectateController_m:SpectateDuelRequest(arg10.ClientDuel)
    end)
    table.insert(arg10._connections, arg10.ClientDuel.MapAdded:Connect(function() -- line: 133
        -- upvalues:
        --  [1] arg10 (copy)

        arg10:_UpdateMap()
    end))
    local Connections_2 = arg10._connections
    local Scores = arg10.ClientDuel:GetDataChangedSignal("Scores")
    table.insert(Connections_2, Scores:Connect(function() -- line: 137
        -- upvalues:
        --  [1] arg10 (copy)

        arg10:_UpdateScores()
    end))
    table.insert(arg10._connections, arg10.ClientDuel.DuelerAdded:Connect(function(arg11) -- line: 141
        -- upvalues:
        --  [1] arg10 (copy)

        arg10:_DuelerAdded(arg11)
    end))
    table.insert(arg10._connections, arg10.ClientDuel.DuelerRemoved:Connect(function(arg12) -- line: 145
        -- upvalues:
        --  [1] arg10 (copy)

        arg10:_DuelerRemoved(arg12)
    end))
    table.insert(arg10._connections, arg10.ClientDuel.DuelerRemoved:Connect(function(arg13) -- line: 149
        -- upvalues:
        --  [1] arg10 (copy)

        if arg10._dueler_slots[arg13] then
            arg10._dueler_slots[arg13]:SetDisconnected(true)
        end
    end))
    local Connections_6 = arg10._connections
    local Status = arg10.ClientDuel:GetDataChangedSignal("Status")
    table.insert(Connections_6, Status:Connect(function() -- line: 155
        -- upvalues:
        --  [1] arg10 (copy)

        if arg10.ClientDuel:Get("Status") == "GameOver" then
            arg10.GameOver:Fire()
        end
    end))
    arg10:_Setup()
    arg10:_UpdateMap()
    arg10:_UpdateScores()
    ButtonEffect_m:Add(
        arg10.Frame.SpectateButton,
        nil,
        { TargetElement = arg10.Frame.Teams.Spectate.Icon }
    )
end

return t
