local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local EventLibrary_m = require(ReplicatedStorage.Modules.EventLibrary)
local TaskLibrary_m = require(ReplicatedStorage.Modules.TaskLibrary)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local PlayerDataController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.PlayerDataController
)
local RewardSlot_m = require(Players.LocalPlayer.PlayerScripts.Modules.RewardSlot)
local TaskSlot = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("TaskSlot")
local t = {}
t.__index = t

function t.new(arg1) -- line: 16
    -- upvalues:
    --  [1] t (copy)
    --  [2] TaskLibrary_m (copy)
    --  [3] TaskSlot (copy)

    local t_1 = setmetatable({}, t)
    t_1.TaskData = arg1
    t_1.Info = TaskLibrary_m.Info[t_1.TaskData.Name]
    t_1.Frame = TaskSlot:Clone()
    t_1._connections = {}
    t_1._reward_slots = {}
    t_1._notification_visible = false
    t_1:_Init()

    return t_1
end

function t.SetParent(arg2, arg3) -- line: 36
    arg2.Frame.Parent = arg3
end

function t.SetLocked(arg4, arg5, _) -- line: 40
    arg4.Frame.Unlocked.Visible = not arg5
    arg4.Frame.Locked.Visible = arg5
    arg4.Frame.Locked.Icon.Position = UDim2.new(0.5, 0, 0.375, 0)
    arg4.Frame.Locked.Title.Visible = false
end

function t.ShowNotification(arg7, arg8) -- line: 47
    local Notification = arg7.Frame.Unlocked.Title.Notification
    local v1 = arg8 and not arg7.TaskData.Completed
    Notification.Visible = v1
end

function t.Destroy(arg9) -- line: 51
    for _, val in pairs(arg9._connections) do
        val:Disconnect()
    end

    arg9:_ClearRewards()
    arg9.Frame:Destroy()
end

function t._UpdateNotification(arg10) -- line: 64
    arg10.Frame.Unlocked.Title.Notification.Position = UDim2.new(
        0.5,
        arg10.Frame.Unlocked.Title.TextBounds.X / 2 + arg10.Frame.Unlocked.Title.Notification.AbsoluteSize.X / 2,
        0.5,
        0
    )
end

function t._ClearRewards(arg11) -- line: 68
    for _, val_1 in pairs(arg11._reward_slots) do
        val_1:Destroy()
    end

    arg11._reward_slots = {}
end

function t._UpdateRewards(arg12) -- line: 76
    -- upvalues:
    --  [1] Utility_m (copy)
    --  [2] PlayerDataController_m (copy)
    --  [3] EventLibrary_m (copy)
    --  [4] RewardSlot_m (copy)

    arg12:_ClearRewards()
    local Rewards = arg12.Info.Rewards
    local v2 = arg12.TaskData.BonusRewards or {}

    for _, val_2 in pairs({ Rewards, v2 }) do
        for _, val_3 in pairs(val_2) do
            local v3 = Utility_m:CloneTable(val_3)

            if
                v3.Name == "EventCurrency"
                and PlayerDataController_m:Get("EventCurrencyRushProgress") < EventLibrary_m.CURRENCY_RUSH_DAILY_LIMIT
                and arg12.Info.CanBeMultipliedByEventBoost
            then
                v3.Quantity *= EventLibrary_m.CURRENCY_RUSH_MULTIPLIER
            end

            local v4 = RewardSlot_m.new(v3)
            v4:SetParent(arg12.Frame.Reward)
            table.insert(arg12._reward_slots, v4)
        end
    end
end

function t._UpdateName(arg13) -- line: 96
    -- upvalues:
    --  [1] PlayerDataController_m (copy)

    local v6 = PlayerDataController_m:Get("TasksCompletedToday")[arg13.TaskData.Name] or 0
    arg13.Frame.Unlocked.Title.Text = arg13.Info.Title .. (if arg13.Info.MaxCompletionsPerDay and v6 < arg13.Info.MaxCompletionsPerDay then " [" .. v6 + 1 .. "/" .. arg13.Info.MaxCompletionsPerDay .. "]" else "")
end

function t._Setup(arg14) -- line: 103
    local v8 = arg14.TaskData.Goal or arg14.Info.Goal
    local Completed = arg14.TaskData.Completed
    local v9 = if not (#arg14.Info.Title > 20) then 1 else 1.5
    arg14.Frame.Unlocked.Progress.Bar.Size = UDim2.new(
        math.clamp(arg14.TaskData.Progress / v8, 0, 1),
        0,
        1,
        2
    )
    local Bar_1 = arg14.Frame.Unlocked.Progress.Bar
    Bar_1.BackgroundColor3 = Completed and Color3.fromRGB(100, 255, 50) or Color3.fromRGB(
        0,
        190,
        255
    )
    arg14.Frame.Unlocked.Progress.Title.Text = arg14.TaskData.Progress .. " / " .. v8
    arg14.Frame.Unlocked.Progress.Title.Visible = not Completed
    arg14.Frame.Unlocked.Progress.Completed.Visible = Completed
    arg14.Frame.Unlocked.Title.Size = UDim2.new(0.8, 0, v9 * 0.1, 0)
    arg14.Frame.Unlocked.Title.Notification.Size = UDim2.new(1 / v9, 0, 1 / v9, 0)
    local Title_1 = arg14.Frame.Unlocked.Title
    Title_1.TextColor3 = Completed and Color3.fromRGB(100, 255, 50) or Color3.fromRGB(255, 255, 255)
    arg14.Frame.Unlocked.Icon.Image = arg14.Info.Icon
    local Icon_1 = arg14.Frame.Unlocked.Icon
    Icon_1.ImageColor3 = Completed and Color3.fromRGB(100, 255, 50) or Color3.fromRGB(255, 255, 255)
    local Background = arg14.Frame.Background
    Background.BackgroundColor3 = Completed and Color3.fromRGB(100, 255, 50) or Color3.fromRGB(
        255,
        255,
        255
    )
    local UIStroke = arg14.Frame.Background.UIStroke
    UIStroke.Color = Completed and Color3.fromRGB(100, 255, 50) or Color3.fromRGB(255, 255, 255)
end

function t._Init(arg15) -- line: 122
    -- upvalues:
    --  [1] PlayerDataController_m (copy)

    arg15.Frame.Unlocked.Title:GetPropertyChangedSignal("TextBounds"):Connect(function() -- line: 123
        -- upvalues:
        --  [1] arg15 (copy)

        arg15:_UpdateNotification()
    end)
    arg15.Frame.Unlocked.Title:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- line: 127
        -- upvalues:
        --  [1] arg15 (copy)

        arg15:_UpdateNotification()
    end)
    arg15.Frame.Unlocked.Title.Notification:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- line: 131
        -- upvalues:
        --  [1] arg15 (copy)

        arg15:_UpdateNotification()
    end)
    local Connections = arg15._connections
    local EventCurrencyRushProgress = PlayerDataController_m:GetDataChangedSignal(
        "EventCurrencyRushProgress"
    )
    table.insert(Connections, EventCurrencyRushProgress:Connect(function() -- line: 135
        -- upvalues:
        --  [1] arg15 (copy)

        arg15:_UpdateRewards()
    end))
    local Connections_1 = arg15._connections
    local TasksCompletedToday = PlayerDataController_m:GetDataChangedSignal("TasksCompletedToday")
    table.insert(Connections_1, TasksCompletedToday:Connect(function() -- line: 139
        -- upvalues:
        --  [1] arg15 (copy)

        arg15:_UpdateName()
    end))
    arg15:_Setup()
    arg15:_UpdateName()
    arg15:_UpdateRewards()
    arg15:_UpdateNotification()
    arg15:ShowNotification(false)
    arg15:SetLocked(false)
end

return t
