local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local CONSTANTS_m = require(ReplicatedStorage.Modules.CONSTANTS)
local ComplianceController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("ComplianceController")
)
local QueuePadController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("QueuePadController")
)
local FighterController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("FighterController")
)
local SocialController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("SocialController")
)
local PartyController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("PartyController")
)
local MatchmakingCountdown_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("UserInterface"):WaitForChild(
        "MatchmakingCountdown"
    )
)
local PartyInviteSlot_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("PartyInviteSlot")
)
local ButtonEffect_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("ButtonEffect")
)
local Page_m = require(Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("Page"))
local PartyMemberBigSlot = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild(
    "PartyMemberBigSlot"
)
local t = setmetatable({}, Page_m)
t.__index = t

function t._new() -- line: 21
    -- upvalues:
    --  [1] Page_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(Page_m.new(script.Name), t)
    t_1.CloseButton = t_1.PageFrame:WaitForChild("Close")
    t_1.MembersFrame = t_1.PageFrame:WaitForChild("Members")
    t_1.List = t_1.PageFrame:WaitForChild("List")
    t_1.Container = t_1.List:WaitForChild("Container")
    t_1.Layout = t_1.Container:WaitForChild("Layout")
    t_1.EmptyFrame = t_1.Container:WaitForChild("Empty")
    t_1.TopFrame = t_1.Container:WaitForChild("Top")
    t_1.SearchBox = t_1.TopFrame:WaitForChild("Search"):WaitForChild("Box")
    t_1.TabsFrame = t_1.TopFrame:WaitForChild("Tabs")
    t_1.AllButton = t_1.TabsFrame:WaitForChild("All")
    t_1.AllButtonText = t_1.AllButton:WaitForChild("Title")
    t_1.AllButtonBackground = t_1.AllButton:WaitForChild("Background")
    t_1.AllButtonBackgroundGradient = t_1.AllButtonBackground:WaitForChild("UIGradient")
    t_1.FriendsButton = t_1.TabsFrame:WaitForChild("Friends")
    t_1.FriendsButtonText = t_1.FriendsButton:WaitForChild("Title")
    t_1.FriendsButtonBackground = t_1.FriendsButton:WaitForChild("Background")
    t_1.FriendsButtonBackgroundGradient = t_1.FriendsButtonBackground:WaitForChild("UIGradient")
    t_1.LobbyButton = t_1.TabsFrame:WaitForChild("Lobby")
    t_1.LobbyButtonText = t_1.LobbyButton:WaitForChild("Title")
    t_1.LobbyButtonBackground = t_1.LobbyButton:WaitForChild("Background")
    t_1.LobbyButtonBackgroundGradient = t_1.LobbyButtonBackground:WaitForChild("UIGradient")
    t_1.PlayersFrame = t_1.Container:WaitForChild("Players")
    t_1.PlayersContainer = t_1.PlayersFrame:WaitForChild("Container")
    t_1.PlayersLayout = t_1.PlayersContainer:WaitForChild("Layout")
    t_1.HidePartyDisplay = true
    t_1._member_slots = {}
    t_1._invite_slots = {}
    t_1._offline_invite_slots = {}
    t_1._invite_generation_disabled = 0
    t_1._leave_buttons = {}
    t_1:_Init()

    return t_1
end

function t.Open(arg1, ...) -- line: 66
    -- upvalues:
    --  [1] Page_m (copy)
    --  [2] QueuePadController_m (copy)
    --  [3] PartyController_m (copy)

    Page_m.Open(arg1, ...)
    table.insert(arg1._open_connections, QueuePadController_m.ChallengeRequestCooldownChanged:Connect(
        function() -- line: 69
            -- upvalues:
            --  [1] arg1 (copy)

            arg1:_UpdateCooldowns()
        end
    ))
    table.insert(arg1._open_connections, PartyController_m.InviteRequestCooldownChanged:Connect(function() -- line: 73
        -- upvalues:
        --  [1] arg1 (copy)

        arg1:_UpdateCooldowns()
    end))
    arg1:_GenerateMembers()
    arg1:_GeneratePlayers(true)
    arg1:_UpdateCooldowns()
    arg1._invite_generation_disabled = tick() + 0.375
    task.delay(0.375, arg1._GeneratePlayers, arg1)
    arg1.SearchBox.Text = ""
end

function t._UpdateLayouts(arg2) -- line: 91
    arg2.List.CanvasSize = UDim2.new(0, 0, 0, arg2.Layout.AbsoluteContentSize.Y)
    arg2.PlayersFrame.Size = UDim2.new(1, 0, 0, arg2.PlayersLayout.AbsoluteContentSize.Y)
    local EmptyFrame = arg2.EmptyFrame
    EmptyFrame.Visible = arg2.PlayersLayout.AbsoluteContentSize.Y < 5
end

function t._UpdateLeaveButtons(arg3) -- line: 97
    -- upvalues:
    --  [1] MatchmakingCountdown_m (copy)

    local v12 = MatchmakingCountdown_m:IsVisible()

    for _, val in pairs(arg3._leave_buttons) do
        val.Visible = v12
    end
end

function t._UpdateCooldowns(arg4) -- line: 105
    for _, val_1 in pairs(arg4._invite_slots) do
        val_1:UpdateCooldowns()
    end
end

function t._SetTab(arg5, arg6) -- line: 111
    arg5._current_tab = arg6
    local AllButtonText = arg5.AllButtonText
    AllButtonText.TextColor3 = if arg5._current_tab ~= "All" then Color3.fromRGB(255, 255, 255) else Color3.fromRGB(
        0,
        0,
        0
    ) or Color3.fromRGB(255, 255, 255)
    local AllButtonBackground = arg5.AllButtonBackground
    AllButtonBackground.ImageColor3 = if arg5._current_tab ~= "All" then Color3.fromRGB(0, 0, 0) else Color3.fromRGB(
        255,
        255,
        255
    ) or Color3.fromRGB(0, 0, 0)
    local AllButtonBackground_1 = arg5.AllButtonBackground
    AllButtonBackground_1.ImageTransparency = if arg5._current_tab ~= "All" then 0.25 else 0
    local AllButtonBackgroundGradient = arg5.AllButtonBackgroundGradient
    AllButtonBackgroundGradient.Enabled = arg5._current_tab ~= "All"
    local FriendsButtonText = arg5.FriendsButtonText
    FriendsButtonText.TextColor3 = if arg5._current_tab ~= "Friends" then Color3.fromRGB(
        255,
        255,
        255
    ) else Color3.fromRGB(0, 0, 0) or Color3.fromRGB(255, 255, 255)
    local FriendsButtonBackground = arg5.FriendsButtonBackground
    FriendsButtonBackground.ImageColor3 = if arg5._current_tab ~= "Friends" then Color3.fromRGB(
        0,
        0,
        0
    ) else Color3.fromRGB(255, 255, 255) or Color3.fromRGB(0, 0, 0)
    local FriendsButtonBackground_1 = arg5.FriendsButtonBackground
    FriendsButtonBackground_1.ImageTransparency = if arg5._current_tab ~= "Friends" then 0.25 else 0
    local FriendsButtonBackgroundGradient = arg5.FriendsButtonBackgroundGradient
    FriendsButtonBackgroundGradient.Enabled = arg5._current_tab ~= "Friends"
    local LobbyButtonText = arg5.LobbyButtonText
    LobbyButtonText.TextColor3 = if arg5._current_tab ~= "Lobby" then Color3.fromRGB(255, 255, 255) else Color3.fromRGB(
        0,
        0,
        0
    ) or Color3.fromRGB(255, 255, 255)
    local LobbyButtonBackground = arg5.LobbyButtonBackground
    LobbyButtonBackground.ImageColor3 = if arg5._current_tab ~= "Lobby" then Color3.fromRGB(0, 0, 0) else Color3.fromRGB(
        255,
        255,
        255
    ) or Color3.fromRGB(0, 0, 0)
    local LobbyButtonBackground_1 = arg5.LobbyButtonBackground
    LobbyButtonBackground_1.ImageTransparency = if arg5._current_tab ~= "Lobby" then 0.25 else 0
    local LobbyButtonBackgroundGradient = arg5.LobbyButtonBackgroundGradient
    LobbyButtonBackgroundGradient.Enabled = arg5._current_tab ~= "Lobby"
    arg5:_UpdatePlayersVisibility()
end

function t._UpdatePlayerVisibility(arg7, arg8) -- line: 132
    local lowerText = string.lower(arg7.SearchBox.Text)
    local Frame = arg8.Frame
    Frame.Visible = if arg7._current_tab ~= "All" then if arg7._current_tab == arg8.Frame.Name then string.find(
        string.lower(arg8.Frame.DisplayName.Text),
        lowerText
    ) or string.find(string.lower(arg8.Frame.Username.Text), lowerText) else false else string.find(
        string.lower(arg8.Frame.DisplayName.Text),
        lowerText
    ) or string.find(string.lower(arg8.Frame.Username.Text), lowerText)
end

function t._UpdatePlayersVisibility(arg9) -- line: 139
    for _, val_2 in pairs(arg9._invite_slots) do
        arg9:_UpdatePlayerVisibility(val_2)
    end

    for _, val_3 in pairs(arg9._offline_invite_slots) do
        arg9:_UpdatePlayerVisibility(val_3)
    end
end

function t._GeneratePlayers(arg10, arg11) -- line: 149
    -- upvalues:
    --  [1] Players (copy)
    --  [2] CONSTANTS_m (copy)
    --  [3] PartyInviteSlot_m (copy)
    --  [4] FighterController_m (copy)
    --  [5] SocialController_m (copy)

    if not arg10:IsOpen() then
        return
    end

    for index = #arg10._invite_slots, 1, -1 do
        local v17 = arg10._invite_slots[index]

        if arg11 or not v17:StillHere() then
            v17:Destroy()
            table.remove(arg10._invite_slots, index)
        end
    end

    if arg11 then
        local v18 = pairs
        local OfflineInviteSlots = arg10._offline_invite_slots

        for _, val_4 in v18(OfflineInviteSlots) do
            val_4:Destroy()
        end

        arg10._offline_invite_slots = {}
    end

    if tick() < arg10._invite_generation_disabled then
        return
    end

    local t_3 = {}
    local v19 = pairs

    for _, val_5 in v19(arg10._invite_slots) do
        t_3[tostring(val_5:GetUserID())] = true
    end

    local v20 = 0

    local function generate_slot(
        arg12,
        arg13,
        arg14,
        arg15,
        arg16
    ) -- line: 185
        -- upvalues:
        --  [1] Players (ref)
        --  [2] CONSTANTS_m (ref)
        --  [3] t_3 (copy)
        --  [4] v20 (ref)
        --  [5] PartyInviteSlot_m (ref)
        --  [6] arg10 (copy)

        local v21 = arg14 or arg13 and arg13.UserId or nil
        local v22 = t_3

        if if v21 ~= Players.LocalPlayer.UserId then v22[tostring(v21)] else not CONSTANTS_m.IS_STUDIO or v22[tostring(
            v21
        )] then
            return
        end

        t_3[tostring(v21)] = true
        v20 += 1
        local v24 = PartyInviteSlot_m.new(arg13, v21, arg15, arg16)
        local Frame_1 = v24.Frame
        Frame_1.LayoutOrder += v20
        v24.Frame.Parent = arg10.PlayersContainer
        arg10:_UpdatePlayerVisibility(v24)

        if arg12 then
            table.insert(arg12, v24)
        end
    end

    for _, val_6 in pairs(FighterController_m.Objects) do
        generate_slot(arg10._invite_slots, val_6.Player)
    end

    if #arg10._offline_invite_slots == 0 then
        for _, val_7 in pairs(SocialController_m.Friends) do
            generate_slot(
                arg10._offline_invite_slots,
                nil,
                val_7.VisitorId,
                val_7.DisplayName,
                val_7.UserName
            )
        end
    end

    arg10:_UpdatePlayersVisibility()
end

function t._GenerateMembers(arg17) -- line: 218
    -- upvalues:
    --  [1] PartyController_m (copy)
    --  [2] Players (copy)
    --  [3] FighterController_m (copy)
    --  [4] PartyMemberBigSlot (copy)
    --  [5] CONSTANTS_m (copy)
    --  [6] ComplianceController_m (copy)
    --  [7] ButtonEffect_m (copy)
    --  [8] ReplicatedStorage (copy)

    if not arg17:IsOpen() then
        return
    end

    local v25 = pairs

    for _, val_8 in v25(arg17._member_slots) do
        val_8:Destroy()
    end

    arg17._member_slots = {}
    arg17._leave_buttons = {}
    local v26 = PartyController_m.CurrentParty or { Players.LocalPlayer }

    local function generate_slot_1(arg18, arg19) --[[ generate_slot ]] -- line: 232
        -- upvalues:
        --  [1] FighterController_m (ref)
        --  [2] PartyMemberBigSlot (ref)
        --  [3] CONSTANTS_m (ref)
        --  [4] PartyController_m (ref)
        --  [5] Players (ref)
        --  [6] v26 (copy)
        --  [7] ComplianceController_m (ref)
        --  [8] arg17 (copy)
        --  [9] ButtonEffect_m (ref)
        --  [10] ReplicatedStorage (ref)

        local v27 = arg19

        if v27 then
            v27 = FighterController_m:GetFighter(arg19)
        end

        local v28 = PartyMemberBigSlot:Clone()
        v28.Icon.Image = if not arg19 then "" else string.format(
            CONSTANTS_m.HEADSHOT_IMAGE,
            arg19.UserId
        )
        local Leader = v28.Leader
        local v29 = arg19 and PartyController_m.CurrentParty and arg18 == 1
        Leader.Visible = v29
        local Kick = v28.Kick
        v29 = arg19 and PartyController_m.CurrentParty and (if Players.LocalPlayer ~= v26[1] then false else arg19 ~= Players.LocalPlayer)
        Kick.Visible = v29
        local Promote = v28.Promote
        v29 = arg19 and PartyController_m.CurrentParty and (if Players.LocalPlayer ~= v26[1] then false else arg19 ~= Players.LocalPlayer)
        Promote.Visible = v29
        local Leave = v28.Leave
        v29 = arg19 and PartyController_m.CurrentParty and arg19 == Players.LocalPlayer
        Leave.Visible = v29
        local Controls = v28.DisplayName.Controls
        v29 = v27 and CONSTANTS_m.CONTROLS_IMAGES[v27:Get("Controls")] or ""
        Controls.Image = v29
        v28.DisplayName.Text = if not arg19 then "" else ComplianceController_m:GetName(arg19)
        v28.Username.Text = if not arg19 then "" else "@" .. arg19.Name
        local Background = v28.Background
        v29 = arg19 ~= nil
        Background.Visible = v29
        v28.TransparentBackground.Visible = not arg19
        v28.LayoutOrder = arg18
        v28.Parent = arg17.MembersFrame
        table.insert(arg17._member_slots, v28)
        table.insert(arg17._leave_buttons, v28.Leave)
        ButtonEffect_m:Add(v28.Kick)
        ButtonEffect_m:Add(v28.Leave)
        ButtonEffect_m:Add(v28.Promote)
        v28.Kick.MouseButton1Click:Connect(function() -- line: 254
            -- upvalues:
            --  [1] ReplicatedStorage (ref)
            --  [2] arg19 (copy)

            ReplicatedStorage.Remotes.Matchmaking.KickPlayerFromParty:FireServer(arg19)
        end)
        v28.Leave.MouseButton1Click:Connect(function() -- line: 258
            -- upvalues:
            --  [1] ReplicatedStorage (ref)

            ReplicatedStorage.Remotes.Matchmaking.TryLeaveParty:FireServer()
        end)
        v28.Promote.MouseButton1Click:Connect(function() -- line: 262
            -- upvalues:
            --  [1] ReplicatedStorage (ref)
            --  [2] arg19 (copy)

            ReplicatedStorage.Remotes.Matchmaking.TransferPartyLeader:FireServer(arg19)
        end)
        v28.DisplayName:GetPropertyChangedSignal("TextBounds"):Connect(function() --[[ update ]] -- line: 266
            -- upvalues:
            --  [1] v28 (copy)

            v28.DisplayName.Controls.Position = UDim2.new(0, v28.DisplayName.TextBounds.X, 0.5, 0)
        end)
        v28.DisplayName.Controls.Position = UDim2.new(0, v28.DisplayName.TextBounds.X, 0.5, 0)
    end

    for key_9, val_9 in pairs(v26) do
        generate_slot_1(key_9, val_9)
    end

    for index_1 = #v26 + 1, CONSTANTS_m.MAX_PARTY_SIZE do
        generate_slot_1(index_1, nil)
    end
end

function t._Init(arg20) -- line: 283
    -- upvalues:
    --  [1] PartyController_m (copy)
    --  [2] SocialController_m (copy)
    --  [3] FighterController_m (copy)
    --  [4] MatchmakingCountdown_m (copy)
    --  [5] ButtonEffect_m (copy)

    arg20.CloseButton.MouseButton1Click:Connect(function() -- line: 284
        -- upvalues:
        --  [1] arg20 (copy)

        arg20:CloseRequest()
    end)
    arg20.Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() -- line: 288
        -- upvalues:
        --  [1] arg20 (copy)

        arg20:_UpdateLayouts()
    end)
    arg20.PlayersLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() -- line: 292
        -- upvalues:
        --  [1] arg20 (copy)

        arg20:_UpdateLayouts()
    end)
    arg20.AllButton.MouseButton1Click:Connect(function() -- line: 296
        -- upvalues:
        --  [1] arg20 (copy)

        arg20:_SetTab("All")
    end)
    arg20.FriendsButton.MouseButton1Click:Connect(function() -- line: 300
        -- upvalues:
        --  [1] arg20 (copy)

        arg20:_SetTab("Friends")
    end)
    arg20.LobbyButton.MouseButton1Click:Connect(function() -- line: 304
        -- upvalues:
        --  [1] arg20 (copy)

        arg20:_SetTab("Lobby")
    end)
    arg20.SearchBox:GetPropertyChangedSignal("Text"):Connect(function() -- line: 308
        -- upvalues:
        --  [1] arg20 (copy)

        arg20:_UpdatePlayersVisibility()
    end)
    PartyController_m.PartyChanged:Connect(function() -- line: 312
        -- upvalues:
        --  [1] arg20 (copy)

        arg20:_GenerateMembers()
        arg20:_GeneratePlayers()
    end)
    SocialController_m.FriendsFetched:Connect(function() -- line: 317
        -- upvalues:
        --  [1] arg20 (copy)

        arg20:_GeneratePlayers()
    end)
    FighterController_m.ObjectAdded:Connect(function() -- line: 321
        -- upvalues:
        --  [1] arg20 (copy)

        arg20:_GeneratePlayers()
    end)
    FighterController_m.ObjectRemoved:Connect(function() -- line: 325
        -- upvalues:
        --  [1] arg20 (copy)

        arg20:_GeneratePlayers()
    end)
    MatchmakingCountdown_m.VisibilityChanged:Connect(function() -- line: 329
        -- upvalues:
        --  [1] arg20 (copy)

        arg20:_UpdateLeaveButtons()
    end)
    arg20:_UpdateLayouts()
    arg20:_UpdateLeaveButtons()
    task.defer(arg20._SetTab, arg20, "All")
    task.defer(arg20._GeneratePlayers, arg20)
    task.defer(arg20._GenerateMembers, arg20)
    ButtonEffect_m:Add(arg20.CloseButton)
    ButtonEffect_m:Add(arg20.AllButton)
    ButtonEffect_m:Add(arg20.FriendsButton)
    ButtonEffect_m:Add(arg20.LobbyButton)
end

return t._new()
