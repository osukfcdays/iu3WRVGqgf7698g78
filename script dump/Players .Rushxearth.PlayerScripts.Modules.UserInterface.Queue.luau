local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CONSTANTS_m = require(ReplicatedStorage.Modules.CONSTANTS)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local Signal_m = require(ReplicatedStorage.Modules.Signal)
local FighterController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("FighterController")
)
local SocialController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("SocialController")
)
local QueuePadController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("QueuePadController")
)
local ButtonEffect_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("ButtonEffect")
)
local TeammateSlot_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("TeammateSlot")
)
local UILibrary_m = require(Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("UILibrary"))
local LocalQueuePlayerSlot = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild(
    "LocalQueuePlayerSlot"
)
local TitleVS = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("TitleVS")
local t = {}
t.__index = t

function t._new() -- line: 23
    -- upvalues:
    --  [1] t (copy)
    --  [2] Signal_m (copy)
    --  [3] UILibrary_m (copy)

    local t_1 = setmetatable({}, t)
    t_1.VisibilityChanged = Signal_m.new()
    t_1.Frame = UILibrary_m:GetTo("MainFrame", "Queue")
    t_1.Container = t_1.Frame:WaitForChild("Container")
    t_1._cleanup = {}
    t_1._countdown_hash = 0
    t_1._last_countdown_sound = nil
    t_1:_Init()

    return t_1
end

function t.IsVisible(arg1) -- line: 44
    return arg1.Frame.Visible
end

function t._UpdateInviteFrame(arg2) -- line: 52
    -- upvalues:
    --  [1] SocialController_m (copy)

    local v7 = SocialController_m.CanSendGameInvite
    local Invite = arg2.Container.Invite
    v7 = v7 and not arg2.Container.Countdown.Visible
    Invite.Visible = v7
end

function t._UpdateWaitingBackground(arg3) -- line: 56
    arg3.Container.Waiting.Background.Size = UDim2.new(
        0,
        arg3.Container.Background.AbsoluteSize.X,
        0,
        arg3.Container.Background.AbsoluteSize.Y
    )
end

function t._StartCountdown(arg4) -- line: 60
    -- upvalues:
    --  [1] Utility_m (copy)
    --  [2] TweenService (copy)
    --  [3] RunService (copy)

    arg4._countdown_hash += 1
    local CountdownHash = arg4._countdown_hash
    arg4.Container.Countdown.Visible = true
    arg4.Container.Waiting.Visible = false
    arg4.Container.Start.Visible = false

    for index = 3, 1, -1 do
        if CountdownHash ~= arg4._countdown_hash then
            return
        end

        arg4.Container.Countdown.Value.Text = index
        arg4._last_countdown_sound = Utility_m:CreateSound(
            "rbxassetid://17259538274",
            0.5,
            1,
            script,
            true,
            5
        )
        local now = tick()

        while true do
            if not (tick() < now + 0.375) then
                break
            end

            if CountdownHash ~= arg4._countdown_hash then
                return
            end

            local v8 = (tick() - now) / 0.375
            local v9 = TweenService:GetValue(v8, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
            local v10 = TweenService:GetValue(v8, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
            arg4.Container.Countdown.Value.Size = UDim2.new(1, 0, 1.25 - 0.625 * v9)
            arg4.Container.Countdown.Glow.ImageTransparency = 0.875 - 0.25 * v10
            arg4.Container.Countdown.Glow.Size = UDim2.new(v10, 0, v10, 0)
            RunService.RenderStepped:Wait()
        end

        local now_2 = tick()

        while true do
            if not (tick() < now_2 + 0.625) then
                break
            end

            if CountdownHash ~= arg4._countdown_hash then
                return
            end

            local v11 = (tick() - now_2) / 0.625
            local v12 = TweenService:GetValue(v11, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
            local v13 = TweenService:GetValue(
                v11,
                Enum.EasingStyle.Linear,
                Enum.EasingDirection.Out
            )
            arg4.Container.Countdown.Value.Size = UDim2.new(1, 0, 0.625 - 0.625 * v12)
            arg4.Container.Countdown.Glow.ImageTransparency = 0.625 + 0.25 * v13
            RunService.RenderStepped:Wait()
        end
    end
end

function t._StopCountdown(arg5) -- line: 113
    arg5._countdown_hash += 1
    arg5.Container.Countdown.Visible = false

    if arg5._last_countdown_sound then
        arg5._last_countdown_sound:Destroy()
        arg5._last_countdown_sound = nil
    end
end

function t._Update(arg6) -- line: 123
    -- upvalues:
    --  [1] QueuePadController_m (copy)
    --  [2] Players (copy)
    --  [3] FighterController_m (copy)
    --  [4] LocalQueuePlayerSlot (copy)
    --  [5] TeammateSlot_m (copy)
    --  [6] TitleVS (copy)
    --  [7] CONSTANTS_m (copy)

    for _, val in pairs(arg6._cleanup) do
        val:Destroy()
    end

    arg6._cleanup = {}
    local v14 = QueuePadController_m:GetQueuePad(Players.LocalPlayer)
    arg6.Frame.Visible = not (not v14)
    arg6.VisibilityChanged:Fire()

    if not arg6.Frame.Visible then
        arg6.Frame.UIScale.Scale = 1
        arg6:_StopCountdown()

        return
    end

    local v15 = v14:GetClientFightersWaiting()
    local v16 = 0
    local v17 = 0
    local v18 = 0
    local v19 = 0
    local v20 = 0
    local v21 = 0
    local v22 = 0

    for index_1 = 1, v14:Get("NumTeams") do
        local v23 = v15[index_1]
        local v24 = false
        local v25 = false
        v21 = math.max(v21, #v23)
        local v26 = table.find(v23, FighterController_m.LocalFighter) and #v23 or v22
        v22 = v26

        for index_2 = 1, if v14:Get("InfinitePlayersPerTeam") then math.huge else v14:Get(
            "PlayersPerTeam"
        ) do
            local v28 = v23[index_2]

            if not v28 and v14:Get("InfinitePlayersPerTeam") then
                if v24 then
                    break
                end

                v24 = true
            end

            local v29 = LocalQueuePlayerSlot:Clone()
            v29.LayoutOrder = if v14:Get("NumTeams") == 2 then if index_1 ~= 1 then v20 else -v20 or v20 else v20
            local v31 = v28
            local Ready = v29.Container.Ready

            if v31 then
                v31 = v14:IsReady(v28.Player)
            end

            Ready.Visible = v31
            v29.Parent = arg6.Container.Details
            table.insert(arg6._cleanup, v29)
            v16 += 1
            v20 += 1

            if v28 then
                v29.Container.Dots:Destroy()
                local v33 = TeammateSlot_m.new(
                    v28.Player.UserId,
                    v28:Get("Controls"),
                    1,
                    false,
                    true,
                    v28.Player:GetAttribute("StatisticDuelsWinStreak"),
                    v28.Player:GetAttribute("Level")
                )
                v33.SlotFrame.Container.Background.Visible = false
                v33.SlotFrame.Parent = v29.Container
                table.insert(arg6._cleanup, v33)
                v19 += 1
                v25 = true
            else
                v29.Container.Dots:AddTag("UILoadingDots")
            end
        end

        if index_1 ~= v14:Get("NumTeams") then
            v24 = TitleVS:Clone()
            v24.LayoutOrder = v20
            v24.Parent = arg6.Container.Details
            table.insert(arg6._cleanup, v24)
            v17 += 1
            v20 += 1
        end

        if v25 then
            v18 += 1
        end
    end

    arg6.Frame.UIScale.Scale = math.clamp(1.3 - v16 * 0.05, 0.5, 1)
    arg6.Container.Background.Size = UDim2.new(v17 * 0.7 + 0.125 + v16 * 0.875, 0, 1, 0)
    local Ready_1 = arg6.Container.Ready
    local v34 = not v14:Get("InfinitePlayersPerTeam")

    if v34 then
        v34 = if v18 == v14:Get("NumTeams") then if v21 > v22 then not v14:IsReady(
            FighterController_m.LocalFighter.Player
        ) else false else false
    end

    Ready_1.Visible = v34
    local Start = arg6.Container.Start
    v34 = v14:Get("InfinitePlayersPerTeam")

    if v34 then
        v34 = if v18 > 1 then CONSTANTS_m.IS_PRIVATE_SERVER_OWNER(Players.LocalPlayer.UserId) else false
    end

    Start.Visible = v34
    local Waiting = arg6.Container.Waiting
    v34 = v14:Get("InfinitePlayersPerTeam")

    if v34 then
        v34 = v18 > 1 and not CONSTANTS_m.IS_PRIVATE_SERVER_OWNER(Players.LocalPlayer.UserId)
    end

    Waiting.Visible = v34

    if v14:Get("IsStarting") then
        arg6:_StartCountdown()

        return
    end

    arg6:_StopCountdown()
end

function t._WaitForLocalFighter(arg7) -- line: 219
    -- upvalues:
    --  [1] FighterController_m (copy)

    FighterController_m:WaitForLocalFighter()
    arg7:_Update()
end

function t._Init(arg8) -- line: 224
    -- upvalues:
    --  [1] ReplicatedStorage (copy)
    --  [2] SocialController_m (copy)
    --  [3] QueuePadController_m (copy)
    --  [4] ButtonEffect_m (copy)

    arg8.Container.Background:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- line: 225
        -- upvalues:
        --  [1] arg8 (copy)

        arg8:_UpdateWaitingBackground()
    end)
    arg8.Container.Countdown:GetPropertyChangedSignal("Visible"):Connect(function() -- line: 229
        -- upvalues:
        --  [1] arg8 (copy)

        arg8:_UpdateInviteFrame()
    end)
    arg8.Container.Start.MouseButton1Click:Connect(function() -- line: 233
        -- upvalues:
        --  [1] ReplicatedStorage (ref)

        ReplicatedStorage.Remotes.PrivateServer.StartQueuePad:FireServer()
    end)
    arg8.Container.Ready.MouseButton1Click:Connect(function() -- line: 237
        -- upvalues:
        --  [1] ReplicatedStorage (ref)

        ReplicatedStorage.Remotes.Misc.QueueReady:FireServer()
    end)
    arg8.Container.Invite.Button.MouseButton1Click:Connect(function() -- line: 241
        -- upvalues:
        --  [1] SocialController_m (ref)

        SocialController_m:PromptFriendInvite()
    end)
    QueuePadController_m.LocalPlayerActivity:Connect(function() -- line: 245
        -- upvalues:
        --  [1] arg8 (copy)

        arg8:_Update()
    end)
    SocialController_m.CanSendGameInviteChanged:Connect(function() -- line: 249
        -- upvalues:
        --  [1] arg8 (copy)

        arg8:_UpdateInviteFrame()
    end)
    arg8:_Update()
    arg8:_UpdateInviteFrame()
    arg8:_UpdateWaitingBackground()
    task.spawn(arg8._WaitForLocalFighter, arg8)
    ButtonEffect_m:Add(arg8.Container.Start)
    ButtonEffect_m:Add(arg8.Container.Ready)
    local t_2 = { HoverRatio = UDim2.new(0, 10, 0, 10), ReleaseRatio = UDim2.new(0, 10, 0, 10) }
    ButtonEffect_m:Add(arg8.Container.Invite.Button, nil, t_2)
end

return t._new()
