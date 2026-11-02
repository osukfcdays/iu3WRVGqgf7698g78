local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local AdventCalendarLibrary_m = require(ReplicatedStorage.Modules.AdventCalendarLibrary)
local TaskLibrary_m = require(ReplicatedStorage.Modules.TaskLibrary)
local PlayerDataController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.PlayerDataController
)
local TimerController_m = require(Players.LocalPlayer.PlayerScripts.Controllers.TimerController)
local RewardSlot_m = require(Players.LocalPlayer.PlayerScripts.Modules.RewardSlot)
local AdventCalendarSlot = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild(
    "AdventCalendarSlot"
)
local t = {}
t.__index = t

function t.new(arg1) -- line: 15
    -- upvalues:
    --  [1] t (copy)
    --  [2] AdventCalendarSlot (copy)

    local t_1 = setmetatable({}, t)
    t_1.Container = arg1
    t_1.Frame = AdventCalendarSlot:Clone()
    t_1.TitleText = t_1.Frame:WaitForChild("Title")
    t_1.Icon = t_1.TitleText:WaitForChild("ImageLabel")
    t_1.TimerText = t_1.Frame:WaitForChild("Timer")
    t_1.RewardsFrame = t_1.Frame:WaitForChild("Rewards")
    t_1._connections = {}
    t_1._reward_slots = {}
    t_1:_Init()

    return t_1
end

function t.SetEnabled(arg2, arg3) -- line: 37
    -- upvalues:
    --  [1] PlayerDataController_m (copy)
    --  [2] TimerController_m (copy)

    for _, val in pairs(arg2._connections) do
        val:Disconnect()
    end

    arg2._connections = {}

    if not arg3 then
        return
    end

    table.insert(arg2._connections, PlayerDataController_m:GetDataChangedSignal("Tasks"):Connect(
        function() -- line: 48
            -- upvalues:
            --  [1] arg2 (copy)

            arg2:_Update()
        end
    ))
    table.insert(arg2._connections, PlayerDataController_m:GetDataChangedSignal("BonusTasks"):Connect(
        function() -- line: 52
            -- upvalues:
            --  [1] arg2 (copy)

            arg2:_Update()
        end
    ))
    table.insert(arg2._connections, PlayerDataController_m:GetDataChangedSignal(
        "StatisticDuelsPlayed"
    ):Connect(function() -- line: 56
        -- upvalues:
        --  [1] arg2 (copy)

        arg2:_Update()
    end))
    table.insert(arg2._connections, PlayerDataController_m:GetDataChangedSignal("SpecialChallenges"):Connect(
        function() -- line: 60
            -- upvalues:
            --  [1] arg2 (copy)

            arg2:_Update()
        end
    ))
    table.insert(arg2._connections, PlayerDataController_m:GetDataChangedSignal(
        "BeginnerTasksCompleted"
    ):Connect(function() -- line: 64
        -- upvalues:
        --  [1] arg2 (copy)

        arg2:_Update()
    end))
    table.insert(arg2._connections, TimerController_m.TimerUpdated:Connect(function() -- line: 68
        -- upvalues:
        --  [1] arg2 (copy)

        arg2:_Update()
    end))
    arg2:_Update()
end

function t._Update(arg4) -- line: 79
    -- upvalues:
    --  [1] AdventCalendarLibrary_m (copy)
    --  [2] PlayerDataController_m (copy)
    --  [3] TaskLibrary_m (copy)
    --  [4] TimerController_m (copy)
    --  [5] RewardSlot_m (copy)

    for _, val_1 in pairs(arg4._reward_slots) do
        val_1:Destroy()
    end

    arg4._reward_slots = {}
    local v2 = AdventCalendarLibrary_m:GetReward()
    local v4 = PlayerDataController_m:Get("BeginnerTasksCompleted") >= TaskLibrary_m.NUM_BEGINNER_TASKS and true
    local Container = arg4.Container
    local v5 = v4 and v2 ~= nil
    Container.Visible = v5

    if not arg4.Container.Visible then
        return
    end

    v4 = AdventCalendarLibrary_m:GetReward(1)
    local v3 = PlayerDataController_m:Get("AdventCalendarLastDayClaimed") >= v2.Day and true
    arg4.TitleText.Text = "Advent Calendar - Day " .. v2.Day
    arg4.Icon.Image = if v3 then "rbxassetid://17588806026" else "rbxassetid://71486631710031"
    local Icon_1 = arg4.Icon
    Icon_1.ImageColor3 = v3 and Color3.fromRGB(100, 255, 50) or Color3.fromRGB(255, 255, 255)
    arg4.TimerText.Text = if v3 then if v4 then "" else "Advent Calendar completed!" else "Complete your Daily Tasks to claim!"
    TimerController_m:OnStep("TaskPageAdventCalendar", "AdventCalendar", if not v3 or not v2 or not v4 then nil else function(
        _,
        arg6
    ) -- line: 104
        -- upvalues:
        --  [1] arg4 (copy)

        arg4.TimerText.Text = "next reward in " .. arg6
    end)

    for _, val_2 in pairs(v2.Rewards) do
        local v11 = RewardSlot_m.new(val_2)
        v11:SetParent(arg4.RewardsFrame)
        table.insert(arg4._reward_slots, v11)
    end
end

function t._Setup(arg7) -- line: 115
    arg7.Frame.Parent = arg7.Container
end

function t._Init(arg8) -- line: 119
    arg8:_Setup()
end

return t
