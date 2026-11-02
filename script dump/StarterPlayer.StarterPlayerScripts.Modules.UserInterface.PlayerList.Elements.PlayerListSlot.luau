local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local StarterGui = game:GetService("StarterGui")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CONSTANTS_m = require(ReplicatedStorage.Modules.CONSTANTS)
local PlayerDataUtility_m = require(ReplicatedStorage.Modules.PlayerDataUtility)
local _ = require(ReplicatedStorage.Modules.DebugLibrary)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local Signal_m = require(ReplicatedStorage.Modules.Signal)
local MatchmakingController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.MatchmakingController
)
local LeaderboardController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.LeaderboardController
)
local _ = require(Players.LocalPlayer.PlayerScripts.Controllers.PlayerDataController)
local SocialController_m = require(Players.LocalPlayer.PlayerScripts.Controllers.SocialController)
local WeaponStatusHandler_m = require(Players.LocalPlayer.PlayerScripts.Modules.WeaponStatusHandler)
local ButtonEffect_m = require(Players.LocalPlayer.PlayerScripts.Modules.ButtonEffect)
local RankIcon_m = require(Players.LocalPlayer.PlayerScripts.Modules.RankIcon)
local t = { 0.45, "rbxassetid://89686341813708" }
local t_1 = { 0.625, "rbxassetid://140099562989635" }
local t_2 = { 0.45, "rbxassetid://114408044569826" }
local t_3 = { 0.6, "rbxassetid://134084662516990" }
local t_4 = { 0.5, "rbxassetid://108431611670429" }
local t_5 = { 0.5, "rbxassetid://104322490200835" }
local t_6 = { 0.4, "rbxassetid://97625610157994" }
local t_7 = { 0.5, "rbxassetid://118031781381166" }
local t_8 = { 0.4, "rbxassetid://105897927" }
local t_9 = { 0.6, "rbxassetid://113059239" }
local t_10 = { 0.6, "rbxassetid://134032333" }
local t_11 = {}
local PlayerListSlot = Players.LocalPlayer.PlayerScripts.UserInterface.PlayerListSlot
t_11.__index = t_11

function t_11.new(arg1, arg2) -- line: 38
    -- upvalues:
    --  [1] t_11 (copy)
    --  [2] Signal_m (copy)
    --  [3] PlayerListSlot (copy)

    local t_12 = setmetatable({}, t_11)
    t_12.Clicked = Signal_m.new()
    t_12.Elements = arg1
    t_12.ClientFighter = arg2
    t_12.Frame = PlayerListSlot:Clone()
    t_12.Button = t_12.Frame:WaitForChild("Button")
    t_12.RequestsFrame = t_12.Frame:WaitForChild("Requests")
    t_12.HighlightFrame = t_12.Frame:WaitForChild("Highlight")
    t_12.LeaderstatFrame = t_12.Frame:WaitForChild("Leaderstat")
    t_12.LeaderstatTitle = t_12.LeaderstatFrame:WaitForChild("Title")
    t_12.LeaderstatRankContainer = t_12.LeaderstatFrame:WaitForChild("RankContainer")
    t_12.PlayerContainer = t_12.Frame:WaitForChild("Player"):WaitForChild("Container")
    t_12.PlayerIcon = t_12.PlayerContainer:WaitForChild("Icon")
    t_12.PlayerTitle = t_12.PlayerContainer:WaitForChild("Title")
    t_12.PlayerTitleIcon = t_12.PlayerTitle:WaitForChild("Icon")
    t_12._connections = {}
    t_12._is_highlighted = false
    t_12._is_hovered = false
    t_12._leaderstat_name = nil
    t_12._leaderstat_rank_icon = nil
    t_12._is_friend = nil
    t_12._is_blocked = nil
    t_12._request_effect_threads = {}
    t_12:_Init()

    return t_12
end

function t_11.IsFriend(arg3) -- line: 75
    return arg3._is_friend
end

function t_11.IsBlocked(arg4) -- line: 79
    return arg4._is_blocked
end

function t_11.SetParent(arg5, arg6) -- line: 83
    arg5.Frame.Parent = arg6
end

function t_11.SetLeaderstat(arg7, arg8) -- line: 87
    arg7._leaderstat_name = arg8
    arg7:_UpdateLeaderstat()
end

function t_11.SetHighlighted(arg9, arg10) -- line: 92
    arg9._is_highlighted = arg10
    arg9:_UpdateHighlight()
end

function t_11.SetIsFriend(arg11, arg12) -- line: 97
    if arg11._is_friend == arg12 then
        return
    end

    arg11._is_friend = arg12
    arg11:_UpdateIcon()
end

function t_11.SetIsBlocked(arg13, arg14) -- line: 106
    if arg13._is_blocked == arg14 then
        return
    end

    arg13._is_blocked = arg14
    arg13:_UpdateIcon()
end

function t_11.SetRequestDuration(arg15, arg16, arg17) -- line: 115
    -- upvalues:
    --  [1] RunService (copy)

    if arg15._request_effect_threads[arg16] then
        task.cancel(arg15._request_effect_threads[arg16])
        arg15._request_effect_threads[arg16] = nil
    end

    arg15._request_effect_threads[arg16] = task.spawn(function() -- line: 121
        -- upvalues:
        --  [1] arg17 (copy)
        --  [2] arg15 (copy)
        --  [3] arg16 (copy)
        --  [4] RunService (ref)

        local v1 = tick() + arg17
        local v2 = arg15.RequestsFrame[arg16]
        local UIGradient = v2.UIStroke.UIGradient
        v2.Visible = true

        while true do
            if not (v1 > tick()) then
                break
            end

            UIGradient.Rotation = tick() * 90 % 360
            RunService.RenderStepped:Wait()
        end

        v2.Visible = false
    end)
end

function t_11.OnOpened(arg18) -- line: 137
    arg18:_UpdateLeaderstat()
    arg18:_UpdateIcon()
    arg18:_UpdateVisuals()
    arg18:_UpdateStatus()
end

function t_11.Destroy(arg19) -- line: 144
    for _, val in pairs(arg19._connections) do
        val:Disconnect()
    end

    for _, val_1 in pairs(arg19._request_effect_threads) do
        pcall(task.cancel, val_1)
    end

    if arg19._leaderstat_rank_icon then
        arg19._leaderstat_rank_icon:Destroy()
        arg19._leaderstat_rank_icon = nil
    end

    arg19.Clicked:Destroy()
    arg19.Frame:Destroy()
end

function t_11._UpdateVisuals(arg20) -- line: 166
    if not arg20.Elements.PlayerList.IsOpen then
        return
    end

    task.delay(0, function() -- line: 172
        -- upvalues:
        --  [1] arg20 (copy)

        arg20.PlayerTitleIcon.Position = UDim2.new(0, arg20.PlayerTitle.TextBounds.X, 0.5, 0)
    end)
end

function t_11._UpdateIcon(arg21) -- line: 177
    -- upvalues:
    --  [1] t_6 (copy)
    --  [2] t_7 (copy)
    --  [3] t_8 (copy)
    --  [4] t_9 (copy)
    --  [5] t_10 (copy)
    --  [6] t (copy)
    --  [7] PlayerDataUtility_m (copy)
    --  [8] HttpService (copy)
    --  [9] t_1 (copy)
    --  [10] t_2 (copy)
    --  [11] t_3 (copy)
    --  [12] t_5 (copy)
    --  [13] t_4 (copy)
    --  [14] CONSTANTS_m (copy)

    if not arg21.Elements.PlayerList.IsOpen then
        return
    end

    local v3

    if arg21._is_blocked then
        v3 = t_6
    elseif arg21._is_friend then
        v3 = t_7
    elseif arg21.ClientFighter.Player.UserId == 261 then
        v3 = t_8
    elseif arg21.ClientFighter.Player.UserId == 13268404 then
        v3 = t_9
    elseif arg21.ClientFighter.Player.UserId == 7210880 then
        v3 = t_10
    elseif
        not arg21.ClientFighter.Player:GetAttribute("DisableTeamVisuals")
        and arg21.ClientFighter.Player:GetAttribute("IsAdministrator")
    then
        v3 = t
    elseif not arg21.ClientFighter.Player:GetAttribute("DisableTeamVisuals") then
        local v4 = PlayerDataUtility_m
        local v5 = HttpService
        local v6 = arg21.ClientFighter.Player:GetAttribute("GroupRoleIDs") or {}
        v3 = if v4:IsNosniyGamesTeamMemberRaw(v5:JSONDecode(v6)) then t_1 else if arg21.ClientFighter.Player:GetAttribute(
            "IsRobloxEmployee"
        ) then t_2 else if arg21.ClientFighter.Player:GetAttribute("IsInfluencer") then t_3 else if not arg21.ClientFighter.Player.HasRobloxSubscription then if arg21.ClientFighter.Player.MembershipType ~= Enum.MembershipType.Premium then nil else t_4 else t_5
    else
        v3 = if arg21.ClientFighter.Player:GetAttribute("IsRobloxEmployee") then t_2 else if arg21.ClientFighter.Player:GetAttribute(
            "IsInfluencer"
        ) then t_3 else if not arg21.ClientFighter.Player.HasRobloxSubscription then if arg21.ClientFighter.Player.MembershipType ~= Enum.MembershipType.Premium then nil else t_4 else t_5
    end

    local PlayerIcon = arg21.PlayerIcon
    PlayerIcon.Image = v3 and v3[2] or ""
    local PlayerIcon_1 = arg21.PlayerIcon
    PlayerIcon_1.Size = v3 and UDim2.new(v3[1], 0, v3[1], 0) or UDim2.new(0, 0, 0, 0)
    arg21.PlayerTitleIcon.Image = CONSTANTS_m.CONTROLS_IMAGES_CENTERED[arg21.ClientFighter:Get(
        "Controls"
    )] or ""
end

function t_11._UpdateStatus(arg22) -- line: 200
    -- upvalues:
    --  [1] WeaponStatusHandler_m (copy)

    if not arg22.Elements.PlayerList.IsOpen then
        return
    end

    WeaponStatusHandler_m:ClearStatusElements(arg22.PlayerTitle)
    WeaponStatusHandler_m:ApplyItemStatusToText(
        arg22.PlayerTitle,
        arg22.ClientFighter.Player:GetAttribute("PlayerStatus")
    )
end

function t_11._UpdateLeaderstat(arg23) -- line: 209
    -- upvalues:
    --  [1] CONSTANTS_m (copy)
    --  [2] MatchmakingController_m (copy)
    --  [3] RankIcon_m (copy)
    --  [4] Utility_m (copy)

    if not arg23.Elements.PlayerList.IsOpen then
        return
    end

    if arg23._leaderstat_rank_icon then
        arg23._leaderstat_rank_icon:Destroy()
        arg23._leaderstat_rank_icon = nil
    end

    local v9 = arg23._leaderstat_name

    if v9 then
        v9 = arg23.ClientFighter.Player:FindFirstChild("CustomLeaderstats")

        if v9 then
            v9 = arg23.ClientFighter.Player.CustomLeaderstats:FindFirstChild(arg23._leaderstat_name)
        end
    end

    local Frame = arg23.Frame
    Frame.LayoutOrder = v9 and -v9.Value or 1

    if not v9 or v9:GetAttribute("StillLoading") then
        arg23.LeaderstatTitle.Text = "\226\128\162 \226\128\162 \226\128\162"

        return
    end

    if arg23._leaderstat_name == "Current ELO" then
        arg23.LeaderstatTitle.Text = ""
        local v11 = CONSTANTS_m.IS_MATCHMAKING_SERVER

        if v11 then
            v11 = not MatchmakingController_m:Get("MatchmadeGameOver")
        end

        if not v11 then
            arg23._leaderstat_rank_icon = RankIcon_m.new(
                v9.Value,
                arg23.ClientFighter.Player.UserId
            )
            arg23._leaderstat_rank_icon:SetParent(arg23.LeaderstatRankContainer)
        end

        return
    end

    arg23.LeaderstatTitle.Text = if not v9.Value then "\226\128\162 \226\128\162 \226\128\162" else Utility_m:PrettyNumber(
        v9.Value
    )
end

function t_11._UpdateHighlight(arg24) -- line: 244
    local HighlightFrame = arg24.HighlightFrame
    HighlightFrame.BackgroundTransparency = if not arg24._is_highlighted then if not arg24._is_hovered then 1 else 0.95 else 0.875
end

function t_11._SetHovered(arg25, arg26) -- line: 248
    arg25._is_hovered = arg26
    arg25:_UpdateHighlight()
end

function t_11._FetchIsBlocked(arg27) -- line: 253
    -- upvalues:
    --  [1] StarterGui (copy)

    local Success, Result = pcall(StarterGui.GetCore, StarterGui, "GetBlockedUserIds")
    local v14 = Success

    if v14 then
        v14 = table.find(Result, arg27.ClientFighter.Player.UserId) ~= nil
    end

    arg27:SetIsBlocked(v14)
end

function t_11._FetchIsFriend(arg28) -- line: 259
    -- upvalues:
    --  [1] SocialController_m (copy)

    if arg28.ClientFighter.IsLocalPlayer then
        arg28:SetIsFriend(false)

        return
    end

    arg28:SetIsFriend(SocialController_m:IsFriendsWith(arg28.ClientFighter.Player.UserId))
end

function t_11._SetupLeaderstats(arg29) -- line: 268
    local CustomLeaderstats = arg29.ClientFighter.Player:WaitForChild("CustomLeaderstats")
    table.insert(arg29._connections, CustomLeaderstats.ChildRemoved:Connect(function() -- line: 271
        -- upvalues:
        --  [1] arg29 (copy)

        arg29:_UpdateLeaderstat()
    end))

    local function object_added(arg30, arg31) -- line: 275
        -- upvalues:
        --  [1] arg29 (copy)

        arg30:GetPropertyChangedSignal("Value"):Connect(function() -- line: 276
            -- upvalues:
            --  [1] arg29 (ref)

            arg29:_UpdateLeaderstat()
        end)
        arg30:GetAttributeChangedSignal("StillLoading"):Connect(function() -- line: 280
            -- upvalues:
            --  [1] arg29 (ref)

            arg29:_UpdateLeaderstat()
        end)

        if not arg31 then
            arg29:_UpdateLeaderstat()
        end
    end

    table.insert(arg29._connections, CustomLeaderstats.ChildAdded:Connect(object_added))
    local v15 = pairs
    local _ = CustomLeaderstats.ChildAdded:Connect(object_added)

    for _, child in v15(CustomLeaderstats:GetChildren()) do
        task.spawn(object_added, child, true)
    end

    arg29:_UpdateLeaderstat()
end

function t_11._Setup(arg32) -- line: 298
    -- upvalues:
    --  [1] Utility_m (copy)

    arg32.PlayerTitle.Text = Utility_m:GetName(
        arg32.ClientFighter.Player,
        arg32.ClientFighter.Player.DisplayName,
        true
    )
end

function t_11._Init(arg33) -- line: 302
    -- upvalues:
    --  [1] LeaderboardController_m (copy)
    --  [2] UserInputService (copy)
    --  [3] MatchmakingController_m (copy)
    --  [4] ButtonEffect_m (copy)

    arg33.Button.MouseButton1Click:Connect(function() -- line: 303
        -- upvalues:
        --  [1] arg33 (copy)

        arg33.Clicked:Fire()
    end)
    arg33.Button.MouseEnter:Connect(function() -- line: 307
        -- upvalues:
        --  [1] arg33 (copy)

        arg33:_SetHovered(true)
    end)
    arg33.Button.MouseLeave:Connect(function() -- line: 311
        -- upvalues:
        --  [1] arg33 (copy)

        arg33:_SetHovered(false)
    end)
    arg33.PlayerTitle:GetPropertyChangedSignal("TextBounds"):Connect(function() -- line: 315
        -- upvalues:
        --  [1] arg33 (copy)

        arg33:_UpdateVisuals()
    end)
    arg33.PlayerTitle:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- line: 319
        -- upvalues:
        --  [1] arg33 (copy)

        arg33:_UpdateVisuals()
    end)
    arg33.PlayerTitle:GetPropertyChangedSignal("AbsolutePosition"):Connect(function() -- line: 323
        -- upvalues:
        --  [1] arg33 (copy)

        arg33:_UpdateVisuals()
    end)
    local Connections_2 = arg33._connections
    local Controls = arg33.ClientFighter:GetDataChangedSignal("Controls")
    table.insert(Connections_2, Controls:Connect(function() -- line: 327
        -- upvalues:
        --  [1] arg33 (copy)

        arg33:_UpdateIcon()
    end))
    local Connections_3 = arg33._connections
    local GroupRoleIDs = arg33.ClientFighter.Player:GetAttributeChangedSignal("GroupRoleIDs")
    table.insert(Connections_3, GroupRoleIDs:Connect(function() -- line: 331
        -- upvalues:
        --  [1] arg33 (copy)

        arg33:_UpdateIcon()
    end))
    local Connections_4 = arg33._connections
    local IsAdministrator = arg33.ClientFighter.Player:GetAttributeChangedSignal("IsAdministrator")
    table.insert(Connections_4, IsAdministrator:Connect(function() -- line: 335
        -- upvalues:
        --  [1] arg33 (copy)

        arg33:_UpdateIcon()
    end))
    local Connections_5 = arg33._connections
    local IsRobloxEmployee = arg33.ClientFighter.Player:GetAttributeChangedSignal(
        "IsRobloxEmployee"
    )
    table.insert(Connections_5, IsRobloxEmployee:Connect(function() -- line: 339
        -- upvalues:
        --  [1] arg33 (copy)

        arg33:_UpdateIcon()
    end))
    local Connections_6 = arg33._connections
    local IsInfluencer = arg33.ClientFighter.Player:GetAttributeChangedSignal("IsInfluencer")
    table.insert(Connections_6, IsInfluencer:Connect(function() -- line: 343
        -- upvalues:
        --  [1] arg33 (copy)

        arg33:_UpdateIcon()
    end))
    local Connections_7 = arg33._connections
    local MembershipType = arg33.ClientFighter.Player:GetPropertyChangedSignal("MembershipType")
    table.insert(Connections_7, MembershipType:Connect(function() -- line: 347
        -- upvalues:
        --  [1] arg33 (copy)

        arg33:_UpdateIcon()
    end))
    local Connections_8 = arg33._connections
    local DisableTeamVisuals = arg33.ClientFighter.Player:GetAttributeChangedSignal(
        "DisableTeamVisuals"
    )
    table.insert(Connections_8, DisableTeamVisuals:Connect(function() -- line: 351
        -- upvalues:
        --  [1] arg33 (copy)

        arg33:_UpdateIcon()
    end))
    local Connections_9 = arg33._connections
    local PlayerStatus = arg33.ClientFighter.Player:GetAttributeChangedSignal("PlayerStatus")
    table.insert(Connections_9, PlayerStatus:Connect(function() -- line: 355
        -- upvalues:
        --  [1] arg33 (copy)

        arg33:_UpdateStatus()
    end))
    local Connections_10 = arg33._connections
    local v16 = LeaderboardController_m:GetLeaderboardRefreshedSignal("Highest ELO")
    table.insert(Connections_10, v16:Connect(function() -- line: 359
        -- upvalues:
        --  [1] arg33 (copy)

        arg33:_UpdateLeaderstat()
    end))
    table.insert(arg33._connections, UserInputService.WindowFocused:Connect(function() -- line: 363
        -- upvalues:
        --  [1] arg33 (copy)

        arg33:_UpdateVisuals()
    end))
    table.insert(arg33._connections, UserInputService.WindowFocusReleased:Connect(function() -- line: 367
        -- upvalues:
        --  [1] arg33 (copy)

        arg33:_UpdateVisuals()
    end))
    local Connections_13 = arg33._connections
    local MatchmadeGameOver = MatchmakingController_m:GetDataChangedSignal("MatchmadeGameOver")
    table.insert(Connections_13, MatchmadeGameOver:Connect(function() -- line: 371
        -- upvalues:
        --  [1] arg33 (copy)

        arg33:_UpdateLeaderstat()
    end))
    arg33:_Setup()
    arg33:_UpdateIcon()
    arg33:_UpdateStatus()
    arg33:_UpdateVisuals()
    arg33:_UpdateHighlight()
    arg33:_UpdateLeaderstat()
    task.spawn(arg33._FetchIsFriend, arg33)
    task.spawn(arg33._FetchIsBlocked, arg33)
    task.spawn(arg33._SetupLeaderstats, arg33)
    ButtonEffect_m:Add(arg33.Button, true)
end

return t_11
