local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GuiService = game:GetService("GuiService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local DuelLibrary_m = require(ReplicatedStorage.Modules.DuelLibrary)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local Signal_m = require(ReplicatedStorage.Modules.Signal)
local MatchmakingController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("MatchmakingController")
)
local _ = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("PlayerDataController")
)
local MobileInputs_m = require(
    Players.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("MobileInputs")
)
local Teleporting_m = require(
    Players.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("Teleporting")
)
local Equipment_m = require(
    Players.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("Equipment")
)
local Queue_m = require(
    Players.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("Queue")
)
local Pages_m = require(
    Players.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("Pages")
)
local ButtonEffect_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("ButtonEffect")
)
local UILibrary_m = require(Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("UILibrary"))
local t = {}
t.__index = t

function t._new() -- line: 25
    -- upvalues:
    --  [1] t (copy)
    --  [2] Signal_m (copy)
    --  [3] UILibrary_m (copy)

    local t_1 = setmetatable({}, t)
    t_1.VisibilityChanged = Signal_m.new()
    t_1.OpenedChanged = Signal_m.new()
    t_1.Frame = UILibrary_m:GetTo("MainFrame", "Lobby", "Matchmaking")
    t_1.Container = t_1.Frame:WaitForChild("Container")
    t_1.LeavingFrame = t_1.Container:WaitForChild("Leaving")
    t_1.LeavingDotsFrame = t_1.LeavingFrame:WaitForChild("Dots")
    t_1.LeaveButton = t_1.Container:WaitForChild("Leave")
    t_1.Icon = t_1.Container:WaitForChild("Icon")
    t_1.TitleText = t_1.Container:WaitForChild("Title")
    t_1.TimerText = t_1.Container:WaitForChild("Timer")
    t_1.QueueText = t_1.Container:WaitForChild("Queue")
    t_1._current_queue_name = nil
    t_1._queue_hash = 0
    t_1._renderstep_connection = nil
    t_1._is_open = false
    t_1:_Init()

    return t_1
end

function t.IsVisible(arg1) -- line: 55
    return arg1.Container.Visible
end

function t.IsOpened(arg2) -- line: 59
    local v10 = arg2:IsVisible()

    if v10 then
        v10 = arg2._is_open
    end

    return v10
end

function t._SetIsLeaving(arg3, arg4) -- line: 67
    arg3.LeavingFrame.Visible = arg4
    arg3.LeaveButton.Visible = not arg4

    if arg4 then
        arg3.LeavingDotsFrame:AddTag("UILoadingDots")

        return
    end

    arg3.LeavingDotsFrame:RemoveTag("UILoadingDots")
end

function t._SetQueueName(arg5, arg6) -- line: 78
    -- upvalues:
    --  [1] DuelLibrary_m (copy)
    --  [2] Utility_m (copy)

    arg5._queue_hash += 1
    arg5._current_queue_name = arg6
    local v11 = DuelLibrary_m.MatchmakingQueues[arg5._current_queue_name]
    local QueueHash = arg5._queue_hash
    local Container = arg5.Container
    Container.Visible = arg5._current_queue_name ~= nil
    local QueueText = arg5.QueueText
    QueueText.Text = v11 and v11.DisplayName or ""
    local Icon = arg5.Icon
    Icon.Image = v11 and v11.Image or ""
    arg5:_SetIsLeaving(false)
    arg5.VisibilityChanged:Fire()
    arg5.OpenedChanged:Fire()

    if not arg5._current_queue_name then
        return
    end

    Utility_m:CreateSound(
        "rbxassetid://18525513345",
        1,
        1,
        script,
        true,
        5
    )
    task.spawn(function() -- line: 100
        -- upvalues:
        --  [1] arg5 (copy)
        --  [2] QueueHash (copy)
        --  [3] Utility_m (ref)

        for index = 0, math.huge do
            if arg5._queue_hash ~= QueueHash then
                return
            end

            arg5.TimerText.Text = Utility_m:TimeFormat(index)
            wait(1)
        end
    end)
end

function t._UpdateVisibility(arg7) -- line: 113
    -- upvalues:
    --  [1] Pages_m (copy)
    --  [2] Equipment_m (copy)
    --  [3] Queue_m (copy)
    --  [4] Teleporting_m (copy)
    --  [5] MobileInputs_m (copy)
    --  [6] GuiService (copy)
    --  [7] RunService (copy)
    --  [8] DuelLibrary_m (copy)

    local v13 = not Pages_m.PageSystem.CurrentPage

    if v13 then
        v13 = not Equipment_m.IsOpen

        if v13 then
            v13 = not Queue_m:IsVisible()

            if v13 then
                v13 = not Teleporting_m.Enabled and not MobileInputs_m.EditorEnabled and not GuiService.MenuIsOpen
            end
        end
    end

    arg7._is_open = v13
    arg7.OpenedChanged:Fire()
    local Container_1 = arg7.Container
    local v14 = arg7._is_open and UDim2.new(0.5, 0, 0.075, 40) or UDim2.new(0.5, 0, -0.2, -40)
    Container_1:TweenPosition(
        v14,
        "Out",
        "Quint",
        0.25,
        true
    )

    if arg7._renderstep_connection then
        arg7._renderstep_connection:Disconnect()
        arg7._renderstep_connection = nil
    end

    local v16 = 0
    v14 = arg7._is_open
    local v17 = tick() + 0.5

    if v14 then
        v14 = RunService.RenderStepped:Connect(function(_) -- line: 127
            -- upvalues:
            --  [1] arg7 (copy)
            --  [2] v17 (ref)
            --  [3] v16 (ref)
            --  [4] DuelLibrary_m (ref)

            local Icon_1 = arg7.Icon
            local now = tick()
            Icon_1.Rotation = math.sin(now) * 5

            if tick() < v17 then
                return
            end

            v16 = (v16 + 1) % 4
            v17 = tick() + 0.5
            local v18 = arg7._current_queue_name

            if v18 then
                v18 = DuelLibrary_m.PlaySources[arg7._current_queue_name]
            end

            local v19 = if v18 then if v18.DuelLogic ~= "Zombie Tower" then if not (v18.DatabaseInfo.NumTeams * v18.DatabaseInfo.PlayersPerTeam <= 1) then "Searching for players" else "Waiting for server" else "Searching for zombies" else "Searching for players"
            arg7.TitleText.Text = v19 .. string.rep(".", v16)
        end)
    end

    arg7._renderstep_connection = v14
end

function t._Init(arg9) -- line: 147
    -- upvalues:
    --  [1] MatchmakingController_m (copy)
    --  [2] Equipment_m (copy)
    --  [3] Pages_m (copy)
    --  [4] Queue_m (copy)
    --  [5] Teleporting_m (copy)
    --  [6] MobileInputs_m (copy)
    --  [7] GuiService (copy)
    --  [8] ReplicatedStorage (copy)
    --  [9] ButtonEffect_m (copy)

    arg9.LeaveButton.MouseButton1Click:Connect(function() -- line: 148
        -- upvalues:
        --  [1] arg9 (copy)
        --  [2] MatchmakingController_m (ref)

        arg9:_SetIsLeaving(true)
        MatchmakingController_m:TryLeaveQueue()
    end)
    Equipment_m.Opened:Connect(function() -- line: 153
        -- upvalues:
        --  [1] arg9 (copy)

        arg9:_UpdateVisibility()
    end)
    Pages_m.PageSystem.PageOpened:Connect(function() -- line: 157
        -- upvalues:
        --  [1] arg9 (copy)

        arg9:_UpdateVisibility()
    end)
    Pages_m.PageSystem.PageClosed:Connect(function() -- line: 161
        -- upvalues:
        --  [1] arg9 (copy)

        arg9:_UpdateVisibility()
    end)
    Queue_m.VisibilityChanged:Connect(function() -- line: 165
        -- upvalues:
        --  [1] arg9 (copy)

        arg9:_UpdateVisibility()
    end)
    Teleporting_m.EnabledChanged:Connect(function() -- line: 169
        -- upvalues:
        --  [1] arg9 (copy)

        arg9:_UpdateVisibility()
    end)
    MobileInputs_m.EditorEnabledChanged:Connect(function() -- line: 173
        -- upvalues:
        --  [1] arg9 (copy)

        arg9:_UpdateVisibility()
    end)
    GuiService:GetPropertyChangedSignal("MenuIsOpen"):Connect(function() -- line: 177
        -- upvalues:
        --  [1] arg9 (copy)

        arg9:_UpdateVisibility()
    end)
    ReplicatedStorage.Remotes.Matchmaking.UpdateQueueStatus.OnClientEvent:Connect(function(...) -- line: 181
        -- upvalues:
        --  [1] arg9 (copy)

        arg9:_SetQueueName(...)
    end)
    arg9:_SetQueueName(nil)
    arg9:_SetIsLeaving(false)
    arg9:_UpdateVisibility()
    ButtonEffect_m:Add(arg9.LeaveButton)
end

return t._new()
