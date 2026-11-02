local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local DuelLibrary_m = require(ReplicatedStorage.Modules.DuelLibrary)
local ItemLibrary_m = require(ReplicatedStorage.Modules.ItemLibrary)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local TeammateSlot_m = require(Players.LocalPlayer.PlayerScripts.Modules.TeammateSlot)
local DuelScoresDuelerTeamBackground = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild(
    "DuelScoresDuelerTeamBackground"
)
local DuelScoresChatBubbleContainer = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild(
    "DuelScoresChatBubbleContainer"
)
local DuelScoresDuelerSlot = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild(
    "DuelScoresDuelerSlot"
)
local t = {}
t.__index = t

function t.new(arg1) -- line: 18
    -- upvalues:
    --  [1] t (copy)

    local t_1 = setmetatable({}, t)
    t_1.Scores = arg1
    t_1.Frame = t_1.Scores.Frame:WaitForChild("Duelers")
    t_1.Container = t_1.Frame:WaitForChild("Container")
    t_1._connections = {}
    t_1._dueler_slots = {}
    t_1:_Init()

    return t_1
end

function t.GetChatBubbleContainer(arg2, arg3) -- line: 37
    local v1 = nil

    for key, val in pairs(arg2._dueler_slots) do
        local v2 = key.Player == arg3
        v1 = v1 or v2 and val.ChatBubbleContainer
        local v4 = if not v2 then 1 else 2
        val.TeammateSlot.SlotFrame.ZIndex = v4
    end

    return v1
end

function t.Generate(arg4) -- line: 49
    arg4:_Clear()

    if
        arg4.Scores.DuelInterface.ClientDuel:Get("ScoresBehavior") ~= "Duelers"
        or arg4.Scores.DuelInterface.ClientDuel:Get("VoteOptions")
    then
        return
    end

    local Connections = arg4._connections
    local Scores = arg4.Scores.DuelInterface.ClientDuel:GetDataChangedSignal("Scores")
    table.insert(Connections, Scores:Connect(function(_) -- line: 56
        -- upvalues:
        --  [1] arg4 (copy)

        arg4:_UpdateRanks()
    end))
    table.insert(arg4._connections, arg4.Scores.DuelInterface.ClientDuel.DuelerAdded:Connect(function(
        arg6
    ) -- line: 60
        -- upvalues:
        --  [1] arg4 (copy)

        arg4:_AddClientDueler(arg6)
    end))

    if arg4.Scores.DuelInterface.ClientDuel:Get("ArcadeMode") then
        table.insert(arg4._connections, arg4.Scores.DuelInterface.ClientDuel.DuelerRemoved:Connect(
            function(arg7) -- line: 65
                -- upvalues:
                --  [1] arg4 (copy)

                arg4:_RemoveClientDueler(arg7)
            end
        ))
    end

    local v5 = pairs
    local _ = arg4.Scores.DuelInterface.ClientDuel.DuelerRemoved:Connect(function(arg7) -- line: 65
        -- upvalues:
        --  [1] arg4 (copy)

        arg4:_RemoveClientDueler(arg7)
    end)

    for key_1, _ in v5(arg4.Scores.DuelInterface:GetLoggedClientDuelers()) do
        arg4:_AddClientDueler(key_1, true)
    end

    arg4:_UpdateRanks()
end

function t.Destroy(arg8) -- line: 77
    arg8:_Clear()
end

function t._UpdateRanks(arg9) -- line: 85
    task.defer(function() -- line: 87
        -- upvalues:
        --  [1] arg9 (copy)

        for key_2, val_2 in pairs((arg9.Scores.DuelInterface:GetLoggedClientDuelers(true))) do
            local v7 = arg9._dueler_slots[val_2]

            if v7 then
                v7.TeammateSlot.SlotFrame.LayoutOrder = key_2
                local SlotFrame = v7.TeammateSlot.SlotFrame
                local v8 = key_2 <= 9 or val_2.IsLocalPlayer
                SlotFrame.Visible = v8
                v7.ScoreSlot.Rank.Text = "#" .. key_2
            end
        end
    end)
end

function t._RemoveClientDueler(arg10, arg11, arg12) -- line: 104
    local v9 = arg10._dueler_slots[arg11]

    if not v9 then
        return
    end

    for _, val_3 in pairs(v9.Connections) do
        val_3:Disconnect()
    end

    v9.TeammateSlot:Destroy()
    arg10._dueler_slots[arg11] = nil

    if not arg12 then
        arg10:_UpdateRanks()
    end
end

function t._AddClientDueler(arg13, arg14, arg15) -- line: 123
    -- upvalues:
    --  [1] TeammateSlot_m (copy)
    --  [2] DuelScoresDuelerTeamBackground (copy)
    --  [3] DuelLibrary_m (copy)
    --  [4] DuelScoresDuelerSlot (copy)
    --  [5] Utility_m (copy)
    --  [6] ItemLibrary_m (copy)
    --  [7] DuelScoresChatBubbleContainer (copy)

    arg13:_RemoveClientDueler(arg14, arg15)
    local t_2 = {}
    local v10 = TeammateSlot_m.new(
        arg14.Player.UserId,
        nil,
        nil,
        nil,
        true
    )
    local v11 = DuelScoresDuelerTeamBackground:Clone()
    v11.Parent = v10.SlotFrame.Container.Background
    local ImageTransparency = v10.SlotFrame.Container.Background.ImageTransparency

    local function update_team() -- line: 135
        -- upvalues:
        --  [1] arg14 (copy)
        --  [2] v10 (copy)
        --  [3] ImageTransparency (copy)
        --  [4] v11 (copy)
        --  [5] DuelLibrary_m (ref)

        local v12 = arg14:Get("TeamID")
        v10.SlotFrame.Container.Background.ImageTransparency = if v12 then 1 else ImageTransparency
        v11.ImageColor3 = DuelLibrary_m:GetTeamColor(v12)
        v11.Visible = if v12 == nil then false else true
    end

    table.insert(t_2, arg14:GetDataChangedSignal("TeamID"):Connect(update_team))
    local v16 = arg14:Get("TeamID")
    v10.SlotFrame.Container.Background.ImageTransparency = if v16 then 1 else ImageTransparency
    v11.ImageColor3 = DuelLibrary_m:GetTeamColor(v16)
    v11.Visible = if v16 == nil then false else true
    local v19 = DuelScoresDuelerSlot:Clone()
    v19.Parent = v10.SlotFrame

    local function update_score() -- line: 149
        -- upvalues:
        --  [1] Utility_m (ref)
        --  [2] arg13 (copy)
        --  [3] arg14 (copy)
        --  [4] ItemLibrary_m (ref)
        --  [5] v19 (copy)

        local v22 = Utility_m:PrettyNumber(
            arg13.Scores.DuelInterface.ClientDuel:Get("Scores")[arg14:Get("DuelerID")]
        )

        if
            not arg14
            or not arg14.ClientFighter
            or not arg14.ClientFighter.Items[1]
            or not ItemLibrary_m.ViewModels[arg14.ClientFighter.Items[1].Name].EliminationFeedImage
        then
        end

        v19.Score.Text = v22
        v19.Weapon.Image = ""
    end

    table.insert(
        t_2,
        arg13.Scores.DuelInterface.ClientDuel:GetDataChangedSignal("IsGunGame"):Connect(
            update_score
        )
    )
    table.insert(
        t_2,
        arg13.Scores.DuelInterface.ClientDuel:GetDataChangedSignal("Scores"):Connect(update_score)
    )
    update_score()
    local v23 = DuelScoresChatBubbleContainer:Clone()
    v23.Position = UDim2.new(0.5, 0, 1.375, 0)
    v23.Parent = v10.SlotFrame
    v10.SlotFrame.Parent = arg13.Container
    arg13._dueler_slots[arg14] = {
        ClientDueler = arg14,
        TeammateSlot = v10,
        ScoreSlot = v19,
        ChatBubbleContainer = v23,
        Connections = t_2
    }

    if not arg15 then
        arg13:_UpdateRanks()
    end
end

function t._Clear(arg16) -- line: 181
    for _, val_4 in pairs(arg16._connections) do
        val_4:Disconnect()
    end

    for key_5, _ in pairs(arg16._dueler_slots) do
        arg16:_RemoveClientDueler(key_5)
    end

    arg16._connections = {}
    arg16._dueler_slots = {}
end

function t._Init(_) -- line: 194
end

return t
