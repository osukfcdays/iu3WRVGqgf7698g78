local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local DuelLibrary_m = require(ReplicatedStorage.Modules.DuelLibrary)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local TeammateSlot_m = require(Players.LocalPlayer.PlayerScripts.Modules.TeammateSlot)
local DuelScoresTeammateScoreNeededSlot = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild(
    "DuelScoresTeammateScoreNeededSlot"
)
local DuelScoresTeamScoreNeededSlot = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild(
    "DuelScoresTeamScoreNeededSlot"
)
local DuelScoresChatBubbleContainer = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild(
    "DuelScoresChatBubbleContainer"
)
local t = {}
t.__index = t

function t.new(arg1) -- line: 17
    -- upvalues:
    --  [1] t (copy)

    local t_1 = setmetatable({}, t)
    t_1.Teams = arg1
    t_1._connections = {}
    t_1._team_slots = {}
    t_1._dueler_slots = {}
    t_1._bubbles_end_time = nil
    t_1:_Init()

    return t_1
end

function t.GetChatBubbleContainer(arg2, arg3) -- line: 36
    for key, val in pairs(arg2._dueler_slots) do
        if key.Player == arg3 then
            return val.ChatBubbleContainer
        end
    end
end

function t.Generate(arg4) -- line: 44
    -- upvalues:
    --  [1] DuelLibrary_m (copy)
    --  [2] DuelScoresTeamScoreNeededSlot (copy)
    --  [3] Players (copy)

    arg4:_Clear()

    if
        arg4.Teams.Scores.DuelInterface.ClientDuel:Get("ScoresBehavior") ~= "Teams"
        or not arg4.Teams.Scores.DuelInterface.ClientDuel:Get("ScoreNeededToWin")
    then
        return
    end

    if arg4.Teams.Scores.DuelInterface.ClientDuel:Get("VoteOptions") then
        arg4._bubbles_end_time = nil

        return
    end

    local v1 = arg4._bubbles_end_time or tick() + 12
    arg4._bubbles_end_time = v1
    v1 = tick() < arg4._bubbles_end_time
    local t_2 = {}

    for index = 1, arg4.Teams.Scores.DuelInterface.ClientDuel:Get("NumTeams") do
        local v2 = DuelLibrary_m.Teams[index]
        local v3 = arg4.Teams.Scores.DuelInterface.ClientDuel.LocalDueler

        if v3 then
            v3 = if v2.TeamID ~= arg4.Teams.Scores.DuelInterface.ClientDuel.LocalDueler:Get(
                "TeamID"
            ) then false else true
        end

        local v4 = if not arg4.Teams.Scores.DuelInterface.ClientDuel.LocalDueler then index % 2 == 0 else v3
        v3 = DuelLibrary_m:GetTeamColor(v2.TeamID)
        local color = Color3.new(v3.R * 0.5, v3.G * 0.5, v3.B * 0.5)
        local v5 = DuelScoresTeamScoreNeededSlot:Clone()
        v5.Container.Bubble.Visible = v4 and v1
        v5.Container.Progress.Bar.BackgroundColor3 = color
        v5.Container.Progress.Bar.UIStroke.Color = color
        v5.Container.Progress.Bar.Bar.BackgroundColor3 = v3
        v5.Container.Progress.Bar.Bar.UIStroke.Color = v3
        local v6 = v4 and Vector2.new(1, 0) or Vector2.new(0, 0)
        v5.AnchorPoint = v6
        v6 = v5.Container
        local v7 = v4 and Vector2.new(1, 0.5) or Vector2.new(0, 0.5)
        v6.AnchorPoint = v7
        local Container = v5.Container
        v7 = v4 and UDim2.new(1, 0, 0.5, 0) or UDim2.new(0, 0, 0.5, 0)
        Container.Position = v7
        local Progress = v5.Container.Progress
        v7 = v4 and UDim2.new(1, 0, 0.5, 0) or UDim2.new(0, 0, 0.5, 0)
        Progress.Position = v7
        local Progress_1 = v5.Container.Progress
        v7 = v4 and Vector2.new(1, 0.5) or Vector2.new(0, 0.5)
        Progress_1.AnchorPoint = v7
        local Bar = v5.Container.Progress.Bar.Bar
        v7 = v4 and UDim2.new(0, -1, 0.5, 0) or UDim2.new(1, 1, 0.5, 0)
        Bar.Position = v7
        local Bar_1 = v5.Container.Progress.Bar.Bar
        v7 = v4 and Vector2.new(0, 0.5) or Vector2.new(1, 0.5)
        Bar_1.AnchorPoint = v7
        local Value = v5.Container.Progress.Bar.Bar.Value
        v7 = v4 and Vector2.new(1, 0.5) or Vector2.new(0, 0.5)
        Value.AnchorPoint = v7
        local Value_1 = v5.Container.Progress.Bar.Bar.Value
        v7 = v4 and UDim2.new(1, 0, 0.5, 0) or UDim2.new(0, 0, 0.5, 0)
        Value_1.Position = v7
        local Title = v5.Container.Progress.Bar.Bar.Value.Title
        v7 = v4 and Vector2.new(1, 0.5) or Vector2.new(0, 0.5)
        Title.AnchorPoint = v7
        local Title_1 = v5.Container.Progress.Bar.Bar.Value.Title
        v7 = v4 and UDim2.new(0.875, 0, 0.5, 0) or UDim2.new(0.125, 0, 0.5, 0)
        Title_1.Position = v7
        local Title_2 = v5.Container.Progress.Bar.Bar.Value.Title
        v7 = v4 and Enum.TextXAlignment.Right or Enum.TextXAlignment.Left
        Title_2.TextXAlignment = v7
        local Teammates = v5.Container.Teammates
        v7 = v4 and UDim2.new(-7.5, 0, 1.75, 0) or UDim2.new(8.5, 0, 1.75, 0)
        Teammates.Position = v7
        local Layout = v5.Container.Teammates.Layout
        v7 = v4 and Enum.HorizontalAlignment.Left or Enum.HorizontalAlignment.Right
        Layout.HorizontalAlignment = v7
        v5.LayoutOrder = index
        local v8 = v4 and arg4.Teams.LeftFrame or arg4.Teams.RightFrame
        v5.Parent = v8
        arg4._team_slots[index] = v5
        table.insert(t_2, v5.Container.Bubble)
        local Background = v5.Container.Bubble.Container.Background
        local Title_3 = v5.Container.Bubble.Container.Title
        Title_3:GetPropertyChangedSignal("TextBounds"):Connect(function() --[[ update ]] -- line: 96
            -- upvalues:
            --  [1] Background (copy)
            --  [2] Title_3 (copy)

            Background.Size = UDim2.new(1.625, Title_3.TextBounds.X, 1, 0)
        end)
        Background.Size = UDim2.new(1.625, Title_3.TextBounds.X, 1, 0)
    end

    if v1 then
        local thread = task.spawn(function() -- line: 106
            -- upvalues:
            --  [1] t_2 (copy)
            --  [2] Players (ref)

            for _, val_1 in pairs(t_2) do
                if val_1:IsDescendantOf(Players) then
                    val_1:TweenPosition(
                        UDim2.new(1, 0, 1.5, 0),
                        "Out",
                        "Sine",
                        0.5,
                        true
                    )
                end
            end

            wait(0.5)

            for _, val_2 in pairs(t_2) do
                if val_2:IsDescendantOf(Players) then
                    val_2:TweenPosition(
                        UDim2.new(1, 0, 1.25, 0),
                        "In",
                        "Sine",
                        0.5,
                        true
                    )
                end
            end

            wait(0.5)
        end)
        task.delay(arg4._bubbles_end_time - tick(), function() -- line: 126
            -- upvalues:
            --  [1] thread (copy)
            --  [2] t_2 (copy)

            task.cancel(thread)

            for _, val_3 in pairs(t_2) do
                val_3.Visible = false
            end
        end)
    end

    table.insert(arg4._connections, arg4.Teams.Scores.DuelInterface.ClientDuel:GetDataChangedSignal(
        "Scores"
    ):Connect(function(_) -- line: 135
        -- upvalues:
        --  [1] arg4 (copy)

        arg4:_UpdateScores()
    end))
    table.insert(arg4._connections, arg4.Teams.Scores.DuelInterface.ClientDuel.DuelerAdded:Connect(
        function(arg6) -- line: 139
            -- upvalues:
            --  [1] arg4 (copy)

            arg4:_AddClientDueler(arg6)
        end
    ))

    if arg4.Teams.Scores.DuelInterface.ClientDuel:Get("ArcadeMode") then
        table.insert(arg4._connections, arg4.Teams.Scores.DuelInterface.ClientDuel.DuelerRemoved:Connect(
            function(arg7) -- line: 144
                -- upvalues:
                --  [1] arg4 (copy)

                arg4:_RemoveClientDueler(arg7)
            end
        ))
    end

    local v12 = pairs
    local _ = arg4.Teams.Scores.DuelInterface.ClientDuel.DuelerRemoved:Connect(function(arg7) -- line: 144
        -- upvalues:
        --  [1] arg4 (copy)

        arg4:_RemoveClientDueler(arg7)
    end)

    for key_4, _ in v12(arg4.Teams.Scores.DuelInterface:GetLoggedClientDuelers()) do
        arg4:_AddClientDueler(key_4, true)
    end

    arg4:_UpdateScores()
end

function t.Destroy(arg8) -- line: 157
    arg8:_Clear()
end

function t._UpdateScores(arg9) -- line: 165
    -- upvalues:
    --  [1] DuelLibrary_m (copy)
    --  [2] Utility_m (copy)

    local v13 = arg9.Teams.Scores.DuelInterface.ClientDuel:Get("ScoreNeededToWin")
    local v14 = arg9.Teams.Scores.DuelInterface.ClientDuel:Get("Scores")

    for key_5, val_5 in pairs(arg9._team_slots) do
        local v15 = v14[DuelLibrary_m.Teams[key_5].TeamID]
        val_5.Container.Bubble.Container.Title.Text = Utility_m:PrettyNumber(v13) .. " points to win"
        val_5.Container.Progress.Bar.Bar.Value.Title.Text = " " .. Utility_m:PrettyNumber(v15) .. " "
        val_5.Container.Progress.Bar.Bar.Size = UDim2.new(math.clamp(v15 / v13, 0.125, 1), 2, 1, 2)
    end
end

function t._RemoveClientDueler(arg10, arg11) -- line: 178
    local v16 = arg10._dueler_slots[arg11]

    if not v16 then
        return
    end

    for _, val_6 in pairs(v16.Connections) do
        val_6:Disconnect()
    end

    v16.PlayerSlot:Destroy()
    v16.TeammateSlot:Destroy()
    arg10._dueler_slots[arg11] = nil
end

function t._AddClientDueler(arg12, arg13) -- line: 194
    -- upvalues:
    --  [1] DuelScoresTeammateScoreNeededSlot (copy)
    --  [2] DuelLibrary_m (copy)
    --  [3] TeammateSlot_m (copy)
    --  [4] DuelScoresChatBubbleContainer (copy)

    arg12:_RemoveClientDueler(arg13)
    local t_3 = {}
    local v17 = DuelScoresTeammateScoreNeededSlot:Clone()

    local function update_parent() -- line: 201
        -- upvalues:
        --  [1] arg13 (copy)
        --  [2] v17 (copy)
        --  [3] arg12 (copy)
        --  [4] DuelLibrary_m (ref)

        local v18 = arg13:Get("TeamID")
        v17.Parent = if not v18 then nil else arg12._team_slots[DuelLibrary_m.TeamsByID[v18].TeamIndex].Container.Teammates
    end

    table.insert(t_3, arg13:GetDataChangedSignal("TeamID"):Connect(update_parent))
    local v21 = TeammateSlot_m.new(
        arg13.Player.UserId,
        nil,
        nil,
        nil,
        true
    )
    v21.SlotFrame.Container.Size = UDim2.new(0.825, 0, 0.825, 0)
    v21.SlotFrame.Container.Headshot.UICorner.CornerRadius = UDim.new(1, 0)
    v21.SlotFrame.Container.Background.Visible = false
    v21.SlotFrame.Parent = v17
    local v22 = DuelScoresChatBubbleContainer:Clone()
    v22.Size = UDim2.new(1.5, 0, 1.5, 0)
    v22.Position = UDim2.new(0.5, 0, 1.25, 0)
    v22.Parent = v21.SlotFrame
    local v23 = arg13:Get("TeamID")
    v17.Parent = if not v23 then nil else arg12._team_slots[DuelLibrary_m.TeamsByID[v23].TeamIndex].Container.Teammates
    arg12._dueler_slots[arg13] = {
        ClientDueler = arg13,
        PlayerSlot = v17,
        TeammateSlot = v21,
        ChatBubbleContainer = v22,
        Connections = t_3
    }
end

function t._Clear(arg14) -- line: 230
    for _, val_7 in pairs(arg14._connections) do
        val_7:Disconnect()
    end

    for _, val_8 in pairs(arg14._team_slots) do
        val_8:Destroy()
    end

    for key_9, _ in pairs(arg14._dueler_slots) do
        arg14:_RemoveClientDueler(key_9)
    end

    arg14._connections = {}
    arg14._team_slots = {}
    arg14._dueler_slots = {}
end

function t._Init(_) -- line: 248
end

return t
