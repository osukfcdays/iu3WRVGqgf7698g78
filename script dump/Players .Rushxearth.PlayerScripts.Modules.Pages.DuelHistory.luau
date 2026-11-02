local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local CONSTANTS_m = require(ReplicatedStorage.Modules.CONSTANTS)
local SeasonLibrary_m = require(ReplicatedStorage.Modules.SeasonLibrary)
local DuelLibrary_m = require(ReplicatedStorage.Modules.DuelLibrary)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local ComplianceController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("ComplianceController")
)
local PlayerDataController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("PlayerDataController")
)
local ButtonEffect_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("ButtonEffect")
)
local RankIcon_m = require(Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("RankIcon"))
local Page_m = require(Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("Page"))
local DuelHistoryRageQuitSlot = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild(
    "DuelHistoryRageQuitSlot"
)
local DuelHistoryHeadshotSlot = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild(
    "DuelHistoryHeadshotSlot"
)
local DuelHistoryDuelerSlot = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild(
    "DuelHistoryDuelerSlot"
)
local DuelHistoryEmptySlot = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild(
    "DuelHistoryEmptySlot"
)
local DuelHistorySlot = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild(
    "DuelHistorySlot"
)
local t = setmetatable({}, Page_m)
t.__index = t

function t._new() -- line: 23
    -- upvalues:
    --  [1] Page_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(Page_m.new(script.Name), t)
    t_1.CloseButton = t_1.PageFrame:WaitForChild("Close")
    t_1.List = t_1.PageFrame:WaitForChild("List")
    t_1.Container = t_1.List:WaitForChild("Container")
    t_1.Layout = t_1.Container:WaitForChild("Layout")
    t_1._duel_history_slots = {}
    t_1._generate_hash = 0
    t_1:_Init()

    return t_1
end

function t.Open(arg1, ...) -- line: 43
    -- upvalues:
    --  [1] Page_m (copy)

    Page_m.Open(arg1, ...)
    task.spawn(arg1._Generate, arg1)
end

function t._SetupELOEventLog(_, arg3, arg4) -- line: 52
    -- upvalues:
    --  [1] RankIcon_m (copy)

    arg3.Visible = arg4

    if not arg4 then
        return
    end

    local v7 = RankIcon_m.new(arg4.CurrentELO, nil, arg4.CurrentLeaderboardRanking or math.huge)
    v7:SetLabelFromELOEvent(arg4.ELOIncrement, arg4.CurrentELO, arg4.DuelsPlayed)
    v7:SetParent(arg3)
end

function t._Generate(arg5) -- line: 64
    -- upvalues:
    --  [1] PlayerDataController_m (copy)
    --  [2] DuelHistoryRageQuitSlot (copy)
    --  [3] Players (copy)
    --  [4] DuelHistorySlot (copy)
    --  [5] DuelLibrary_m (copy)
    --  [6] SeasonLibrary_m (copy)
    --  [7] DuelHistoryHeadshotSlot (copy)
    --  [8] CONSTANTS_m (copy)
    --  [9] DuelHistoryDuelerSlot (copy)
    --  [10] Utility_m (copy)
    --  [11] RankIcon_m (copy)
    --  [12] ButtonEffect_m (copy)
    --  [13] ComplianceController_m (copy)
    --  [14] DuelHistoryEmptySlot (copy)

    for _, val in pairs(arg5._duel_history_slots) do
        val:Destroy()
    end

    arg5._duel_history_slots = {}
    arg5._generate_hash += 1
    local GenerateHash = arg5._generate_hash
    local t_2 = {}

    for _, val_1 in pairs(PlayerDataController_m:Get("LoggedELOEvents")) do
        if val_1.LogID then
            t_2[val_1.LogID] = val_1
        end
    end

    local v11, v21

    for key_2, val_2 in pairs(PlayerDataController_m:Get("DuelHistory")) do
        if GenerateHash ~= arg5._generate_hash then
            return
        end

        local v10 = t_2[val_2.LogID]

        if val_2.IsRageQuit then
            v11 = DuelHistoryRageQuitSlot:Clone()
            v11.LayoutOrder = key_2
            v11.Parent = arg5.Container
            table.insert(arg5._duel_history_slots, v11)
            arg5:_SetupELOEventLog(v11.RankContainer, v10)
            wait(0.03)
        else
            v11 = false

            for _, val_3 in pairs(val_2.Duelers) do
                if val_3.UserID == Players.LocalPlayer.UserId then
                    v11 = true
                    break
                end
            end

            if v11 then
                local v11 = DuelHistorySlot:Clone()
                v11.LayoutOrder = key_2
                local v12 = v11.Map
                local v13 = val_2.Map and DuelLibrary_m.Maps[val_2.Map] and DuelLibrary_m.Maps[val_2.Map].Image or ""
                v12.Image = v13
                v12 = v11.Container.QueueName
                v13 = val_2.QueueName and DuelLibrary_m.MatchmakingQueues[val_2.QueueName] and DuelLibrary_m.MatchmakingQueues[val_2.QueueName].DisplayName or val_2.QueueName or ""
                v12.Text = v13
                v11.Container.Score.Text = ""
                v11.Container.EDATitle.Visible = false
                v11.Container.EDA.Visible = false
                arg5:_SetupELOEventLog(v11.Container.RankContainer, v10)

                for index = 1, val_2.NumTeams, 1 do
                    local Score = v11.Container.Score
                    local Text = Score.Text
                    local v17 = val_2.Scores[index]
                    local v18 = if index ~= val_2.NumTeams then " \226\128\162 " else ""
                    Score.Text = Text .. v17 .. v18
                end

                v10 = SeasonLibrary_m:IsRankedQueue(val_2.QueueName)
                local v12 = {}

                for key_4, val_4 in pairs(val_2.Duelers) do
                    local v20 = DuelLibrary_m:GetTeamColor(
                        val_4.TeamIndex and DuelLibrary_m.Teams[val_4.TeamIndex] and DuelLibrary_m.Teams[val_4.TeamIndex].TeamID
                    )

                    if val_4.UserID == Players.LocalPlayer.UserId then
                        v21 = val_2.WinningTeamIndex and val_2.WinningTeamIndex == val_4.TeamIndex
                        local Background = v11.Container.Background
                        local v22 = v21 and Color3.fromRGB(100, 255, 50) or Color3.fromRGB(
                            255,
                            50,
                            50
                        )
                        Background.ImageColor3 = v22
                        v22 = if not v21 then "DEFEAT" else "VICTORY"
                        v11.Container.Title.Text = v22
                        v11.Container.EDA.Text = (val_4.Eliminations or "?") .. " \226\128\162 " .. (val_4.Deaths or "?") .. " \226\128\162 " .. (val_4.Assists or "?")
                        v11.Container.EDA.Visible = not v11.Container.RankContainer.Visible
                        v11.Container.EDATitle.Visible = v11.Container.EDA.Visible
                    end

                    v21 = DuelHistoryHeadshotSlot:Clone()
                    v21.Picture.Image = if not val_4.UserID then "rbxassetid://18623501726" else string.format(
                        CONSTANTS_m.HEADSHOT_IMAGE,
                        val_4.UserID
                    )
                    local Picture_1 = v21.Picture
                    local v23 = if val_4.UserID then v21.Picture.ImageColor3 else Color3.fromRGB(
                        0,
                        0,
                        0
                    ) or v21.Picture.ImageColor3
                    Picture_1.ImageColor3 = v23
                    local Picture_2 = v21.Picture
                    v23 = if val_4.UserID then v21.Picture.ImageTransparency else 0.5
                    Picture_2.ImageTransparency = v23
                    local Picture_3 = v21.Picture
                    v23 = if val_4.UserID then v21.Picture.Size else UDim2.new(0.75, 0, 0.75, 0) or v21.Picture.Size
                    Picture_3.Size = v23
                    v21.Background.BackgroundColor3 = v20
                    v21.LayoutOrder = val_4.TeamIndex * 1000 + key_4
                    v21.Parent = v11.Container.Headshots
                    local v24 = DuelHistoryDuelerSlot:Clone()
                    v24.Player.Image = if not val_4.UserID then "rbxassetid://18623501726" else string.format(
                        CONSTANTS_m.HEADSHOT_IMAGE,
                        val_4.UserID
                    )
                    v24.DisplayName.Text = "\226\128\162 \226\128\162 \226\128\162"
                    v24.Username.Text = "@\226\128\162 \226\128\162 \226\128\162"
                    local Damage = v24.Damage
                    local v26 = val_4.Damage and Utility_m:PrettyNumber(
                        (math.floor(val_4.Damage + 0.5))
                    ) or ""
                    Damage.Text = v26
                    v24.Eliminations.Text = val_4.Eliminations or ""
                    v24.Deaths.Text = val_4.Deaths or ""
                    v24.Assists.Text = val_4.Assists or ""
                    v24.MVPText.Visible = val_4.IsMVP
                    v24.MVPIcon.Visible = val_4.IsMVP
                    v24.BackgroundColor3 = v20
                    v24.LayoutOrder = key_4
                    v24.Parent = v11.Container.Duelers

                    if val_4.UserID then
                        v12[tostring(val_4.UserID)] = v24
                    end

                    if v10 then
                        RankIcon_m.new(
                            val_4.DisplayELO,
                            nil,
                            val_4.DisplayELOLeaderboardRanking or math.huge
                        ):SetParent(v24.Rank)
                    end
                end

                v11.Parent = arg5.Container
                table.insert(arg5._duel_history_slots, v11)
                local v10 = ButtonEffect_m:Add(
                    v11,
                    nil,
                    { HoverRatio = 1.025, ReleaseRatio = 1.025 }
                )
                local v28 = false
                local v29 = false
                v11.MouseButton1Click:Connect(function() -- line: 183
                    -- upvalues:
                    --  [1] v29 (ref)
                    --  [2] v11 (copy)
                    --  [3] v10 (copy)
                    --  [4] v28 (ref)
                    --  [5] val_2 (copy)
                    --  [6] ComplianceController_m (ref)
                    --  [7] v12 (copy)

                    v29 = not v29
                    local v30 = v29 and UDim2.new(
                        1,
                        0,
                        (#v11.Container.Duelers:GetChildren() - 3) * 0.07500000000000001 + 0.2475,
                        0
                    ) or UDim2.new(1, 0, 0.2, 0)
                    v10.UpdateOriginalSize(v30)
                    v11.Size = v30
                    v11.Container.Duelers.Visible = v29

                    if v28 then
                        return
                    end

                    v28 = true
                    v30 = {}

                    for _, val_5 in pairs(val_2.Duelers) do
                        if val_5.UserID then
                            table.insert(v30, val_5.UserID)
                        end
                    end

                    local v31 = ComplianceController_m:GetUserInfos(v30)

                    for key_6, val_6 in pairs(v12) do
                        local v32 = v31[key_6]

                        if v32 then
                            val_6.Username.Text = if v32.Username == v32.DisplayName then "" else "@" .. v32.Username
                            val_6.DisplayName.Text = v32.DisplayName
                            local DisplayName = val_6.DisplayName
                            local v34 = if val_6.Username.Text ~= "" then UDim2.new(0.1, 0, 0.35, 0) else UDim2.new(
                                0.1,
                                0,
                                0.5,
                                0
                            ) or UDim2.new(0.1, 0, 0.35, 0)
                            DisplayName.Position = v34
                        end
                    end
                end)
                wait(0.03)
            end
        end
    end

    for _ = #arg5._duel_history_slots + 1, 6 do
        if GenerateHash ~= arg5._generate_hash then
            return
        end

        local v35 = DuelHistoryEmptySlot:Clone()
        v35.LayoutOrder = 99999
        v35.Parent = arg5.Container
        table.insert(arg5._duel_history_slots, v35)
        wait(0.03)
    end
end

function t._Init(arg6) -- line: 238
    -- upvalues:
    --  [1] ButtonEffect_m (copy)

    arg6.CloseButton.MouseButton1Click:Connect(function() -- line: 239
        -- upvalues:
        --  [1] arg6 (copy)

        arg6:CloseRequest()
    end)
    arg6.Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() -- line: 243
        -- upvalues:
        --  [1] arg6 (copy)

        arg6.List.CanvasSize = UDim2.new(0, 0, 0, arg6.Layout.AbsoluteContentSize.Y)
    end)
    ButtonEffect_m:Add(arg6.CloseButton)
end

return t._new()
