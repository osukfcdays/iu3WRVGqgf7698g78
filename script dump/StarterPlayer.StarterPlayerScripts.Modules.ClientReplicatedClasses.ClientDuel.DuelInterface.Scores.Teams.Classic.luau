local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local DuelLibrary_m = require(ReplicatedStorage.Modules.DuelLibrary)
local TeammateSlot_m = require(Players.LocalPlayer.PlayerScripts.Modules.TeammateSlot)
local DuelScoresChatBubbleContainer = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild(
    "DuelScoresChatBubbleContainer"
)
local DuelScoresTeamSlot = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild(
    "DuelScoresTeamSlot"
)
local t = {}
t.__index = t

function t.new(arg1) -- line: 13
    -- upvalues:
    --  [1] t (copy)

    local t_1 = setmetatable({}, t)
    t_1.Teams = arg1
    t_1._connections = {}
    t_1._team_slots = {}
    t_1._dueler_slots = {}
    t_1:_Init()

    return t_1
end

function t.GetChatBubbleContainer(arg2, arg3) -- line: 31
    for key, val in pairs(arg2._dueler_slots) do
        if key.Player == arg3 then
            return val.ChatBubbleContainer
        end
    end
end

function t.Generate(arg4) -- line: 39
    -- upvalues:
    --  [1] DuelLibrary_m (copy)
    --  [2] DuelScoresTeamSlot (copy)

    arg4:_Clear()

    if
        arg4.Teams.Scores.DuelInterface.ClientDuel:Get("ScoresBehavior") ~= "Teams"
        or arg4.Teams.Scores.DuelInterface.ClientDuel:Get("ScoreNeededToWin")
    then
        return
    end

    for index = 1, arg4.Teams.Scores.DuelInterface.ClientDuel:Get("NumTeams") do
        local Layout_1 = DuelLibrary_m.Teams[index]
        local v2 = arg4.Teams.Scores.DuelInterface.ClientDuel.LocalDueler

        if v2 then
            v2 = if Layout_1.TeamID ~= arg4.Teams.Scores.DuelInterface.ClientDuel.LocalDueler:Get(
                "TeamID"
            ) then false else true
        end

        local Score_2 = if not arg4.Teams.Scores.DuelInterface.ClientDuel.LocalDueler then index % 2 == 0 else v2
        local v2 = DuelScoresTeamSlot:Clone()
        v2.Background.ImageColor3 = DuelLibrary_m:GetTeamColor(Layout_1.TeamID)
        local Container = v2.Container
        local v4 = Score_2 and UDim2.new(1, 0, 0.5, 0) or UDim2.new(0, 0, 0.5, 0)
        Container.Position = v4
        local Container_1 = v2.Container
        v4 = Score_2 and Vector2.new(1, 0.5) or Vector2.new(0, 0.5)
        Container_1.AnchorPoint = v4
        local Teammates = v2.Container.Teammates
        v4 = Score_2 and UDim2.new(0, 0, 0.5, 0) or UDim2.new(1, 0, 0.5, 0)
        Teammates.Position = v4
        local Teammates_1 = v2.Container.Teammates
        v4 = Score_2 and Vector2.new(0, 0.5) or Vector2.new(1, 0.5)
        Teammates_1.AnchorPoint = v4
        local Score = v2.Container.Score
        v4 = Score_2 and UDim2.new(1, 0, 0.5, 0) or UDim2.new(0, 0, 0.5, 0)
        Score.Position = v4
        local Score_1 = v2.Container.Score
        v4 = Score_2 and Vector2.new(1, 0.5) or Vector2.new(0, 0.5)
        Score_1.AnchorPoint = v4
        local Layout = v2.Container.Teammates.Layout
        v4 = Score_2 and Enum.HorizontalAlignment.Right or Enum.HorizontalAlignment.Left
        Layout.HorizontalAlignment = v4
        v2.LayoutOrder = index
        local v5 = Score_2 and arg4.Teams.LeftFrame or arg4.Teams.RightFrame
        v2.Parent = v5
        arg4._team_slots[index] = v2
        local Score_2 = v2.Container.Score
        local Layout_1 = v2.Container.Teammates.Layout

        local function update() -- line: 68
            -- upvalues:
            --  [1] v2 (copy)
            --  [2] Layout_1 (copy)
            --  [3] Score_2 (copy)

            v2.Size = UDim2.new(0, Layout_1.AbsoluteContentSize.X + Score_2.AbsoluteSize.X, 1, 0)
        end

        Layout_1:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(update)
        Score_2:GetPropertyChangedSignal("AbsoluteSize"):Connect(update)
        v2.Size = UDim2.new(0, Layout_1.AbsoluteContentSize.X + Score_2.AbsoluteSize.X, 1, 0)
    end

    local Connections = arg4._connections
    local Scores = arg4.Teams.Scores.DuelInterface.ClientDuel:GetDataChangedSignal("Scores")
    table.insert(Connections, Scores:Connect(function(_) -- line: 77
        -- upvalues:
        --  [1] arg4 (copy)

        arg4:_UpdateScores()
    end))
    table.insert(arg4._connections, arg4.Teams.Scores.DuelInterface.ClientDuel.DuelerAdded:Connect(
        function(arg6) -- line: 81
            -- upvalues:
            --  [1] arg4 (copy)

            arg4:_AddClientDueler(arg6)
        end
    ))

    if arg4.Teams.Scores.DuelInterface.ClientDuel:Get("ArcadeMode") then
        table.insert(arg4._connections, arg4.Teams.Scores.DuelInterface.ClientDuel.DuelerRemoved:Connect(
            function(arg7) -- line: 86
                -- upvalues:
                --  [1] arg4 (copy)

                arg4:_RemoveClientDueler(arg7)
            end
        ))
    end

    local v8 = pairs
    local _ = arg4.Teams.Scores.DuelInterface.ClientDuel.DuelerRemoved:Connect(function(arg7) -- line: 86
        -- upvalues:
        --  [1] arg4 (copy)

        arg4:_RemoveClientDueler(arg7)
    end)

    for key_1, _ in v8(arg4.Teams.Scores.DuelInterface:GetLoggedClientDuelers()) do
        arg4:_AddClientDueler(key_1, true)
    end

    arg4:_UpdateScores()
end

function t.Destroy(arg8) -- line: 98
    arg8:_Clear()
end

function t._UpdateScores(arg9) -- line: 106
    -- upvalues:
    --  [1] DuelLibrary_m (copy)

    local v9 = arg9.Teams.Scores.DuelInterface.ClientDuel:Get("Scores")

    for key_2, val_2 in pairs(arg9._team_slots) do
        val_2.Container.Score.Text = v9[DuelLibrary_m.Teams[key_2].TeamID]
    end
end

function t._RemoveClientDueler(arg10, arg11) -- line: 114
    local v10 = arg10._dueler_slots[arg11]

    if not v10 then
        return
    end

    for _, val_3 in pairs(v10.Connections) do
        val_3:Disconnect()
    end

    v10.TeammateSlot:Destroy()
    arg10._dueler_slots[arg11] = nil
end

function t._AddClientDueler(arg12, arg13) -- line: 129
    -- upvalues:
    --  [1] TeammateSlot_m (copy)
    --  [2] DuelLibrary_m (copy)
    --  [3] DuelScoresChatBubbleContainer (copy)

    arg12:_RemoveClientDueler(arg13)
    local t_2 = {}
    local v11 = TeammateSlot_m.new(arg13.Player.UserId)
    v11.SlotFrame.Container.Background.Visible = false

    local function update_details() -- line: 137
        -- upvalues:
        --  [1] arg12 (copy)
        --  [2] arg13 (copy)
        --  [3] v11 (copy)

        local v12 = arg12.Teams.Scores.DuelInterface.ClientDuel:Get("Status")
        local v13 = arg13:Get("TeamID")
        local v14 = arg12.Teams.Scores.DuelInterface.ClientDuel.LocalDueler

        if v14 then
            v14 = if v13 ~= arg12.Teams.Scores.DuelInterface.ClientDuel.LocalDueler:Get("TeamID") then false else true
        end

        local v15 = arg13.ClientFighter:Get("Controls")
        local v17 = arg13:GetHealth() / arg13:GetMaxHealth()
        local v18 = arg12.Teams.Scores.DuelInterface.ClientDuel.LocalDueler
        local v19 = not table.find(arg12.Teams.Scores.DuelInterface.ClientDuel.Duelers, arg13)

        if v18 then
            v18 = not v14 and (if v12 == "RoundFinished" then false else v12 ~= "GameOver")
        end

        v14 = if arg12.Teams.Scores.DuelInterface.ClientDuel.IsRanked then nil else arg13.Player:GetAttribute(
            "Level"
        )
        v11:SetDetails(
            v15,
            v17,
            v19,
            v18,
            nil,
            v14
        )
    end

    table.insert(
        t_2,
        arg12.Teams.Scores.DuelInterface.ClientDuel:GetDataChangedSignal("Status"):Connect(
            update_details
        )
    )
    table.insert(t_2, arg13.ClientFighter:GetDataChangedSignal("Controls"):Connect(update_details))
    table.insert(t_2, arg13.Player:GetAttributeChangedSignal("Level"):Connect(update_details))
    table.insert(
        t_2,
        arg12.Teams.Scores.DuelInterface.ClientDuel.DuelerRemoved:Connect(update_details)
    )
    table.insert(t_2, arg13:GetDataChangedSignal("TeamID"):Connect(update_details))
    table.insert(t_2, arg13.HealthChanged:Connect(update_details))
    update_details()

    local function update_parent() -- line: 159
        -- upvalues:
        --  [1] arg13 (copy)
        --  [2] v11 (copy)
        --  [3] arg12 (copy)
        --  [4] DuelLibrary_m (ref)

        local v22 = arg13:Get("TeamID")
        v11.SlotFrame.Parent = if not v22 then nil else arg12._team_slots[DuelLibrary_m.TeamsByID[v22].TeamIndex].Container.Teammates
    end

    table.insert(t_2, arg13:GetDataChangedSignal("TeamID"):Connect(update_parent))

    local function update_turn() -- line: 166
        -- upvalues:
        --  [1] v11 (copy)
        --  [2] arg13 (copy)

        v11:SetStaggeredSpawnsTurn(arg13:GetStaggeredSpawnsTurn(), arg13:Get("TeamID"))
    end

    table.insert(
        t_2,
        arg12.Teams.Scores.DuelInterface.ClientDuel:GetDataChangedSignal("StaggeredSpawnsOrder"):Connect(
            update_turn
        )
    )
    table.insert(t_2, arg13:GetDataChangedSignal("TeamID"):Connect(update_turn))
    local v26 = arg13:GetStaggeredSpawnsTurn()
    v11:SetStaggeredSpawnsTurn(v26, arg13:Get("TeamID"))

    if arg12.Teams.Scores.DuelInterface.ClientDuel.IsRanked and arg13:CanShowRankToLocalPlayer() then
        v11:SetDisplayELO(arg13.Player:GetAttribute("DisplayELO"))
    end

    local v27 = DuelScoresChatBubbleContainer:Clone()
    v27.Parent = v11.SlotFrame
    local v28 = arg13:Get("TeamID")
    v11.SlotFrame.Parent = if not v28 then nil else arg12._team_slots[DuelLibrary_m.TeamsByID[v28].TeamIndex].Container.Teammates
    arg12._dueler_slots[arg13] = {
        ClientDueler = arg13,
        TeammateSlot = v11,
        ChatBubbleContainer = v27,
        Connections = t_2
    }
end

function t._Clear(arg14) -- line: 191
    for _, val_4 in pairs(arg14._connections) do
        val_4:Disconnect()
    end

    for _, val_5 in pairs(arg14._team_slots) do
        val_5:Destroy()
    end

    for key_6, _ in pairs(arg14._dueler_slots) do
        arg14:_RemoveClientDueler(key_6)
    end

    arg14._connections = {}
    arg14._team_slots = {}
    arg14._dueler_slots = {}
end

function t._Init(_) -- line: 209
end

return t
