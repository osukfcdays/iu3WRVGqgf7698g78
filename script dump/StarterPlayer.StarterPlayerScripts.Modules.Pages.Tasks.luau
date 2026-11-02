local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local CONSTANTS_m = require(ReplicatedStorage.Modules.CONSTANTS)
local MonetizationLibrary_m = require(ReplicatedStorage.Modules.MonetizationLibrary)
local StatisticsLibrary_m = require(ReplicatedStorage.Modules.StatisticsLibrary)
local ContractsLibrary_m = require(ReplicatedStorage.Modules.ContractsLibrary)
local EventLibrary_m = require(ReplicatedStorage.Modules.EventLibrary)
local ServerOsTime_m = require(ReplicatedStorage.Modules.ServerOsTime)
local ItemLibrary_m = require(ReplicatedStorage.Modules.ItemLibrary)
local TaskLibrary_m = require(ReplicatedStorage.Modules.TaskLibrary)
local DuelLibrary_m = require(ReplicatedStorage.Modules.DuelLibrary)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local ShootingRangeController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.ShootingRangeController
)
local MonetizationController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.MonetizationController
)
local PlayerDataController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.PlayerDataController
)
local LobbyController_m = require(Players.LocalPlayer.PlayerScripts.Controllers.LobbyController)
local TimerController_m = require(Players.LocalPlayer.PlayerScripts.Controllers.TimerController)
local AdventCalendarSlot_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("AdventCalendarSlot")
)
local DropdownSlot_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("DropdownSlot")
)
local ButtonEffect_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("ButtonEffect")
)
local RewardSlot_m = require(Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("RewardSlot"))
local TaskSlot_m = require(Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("TaskSlot"))
local Page_m = require(Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("Page"))
local DailyTaskStreakMilestoneSlot = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild(
    "DailyTaskStreakMilestoneSlot"
)
local TaskContractMilestoneDivider = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild(
    "TaskContractMilestoneDivider"
)
local DailyTaskStreakSlot = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild(
    "DailyTaskStreakSlot"
)
local TaskContractMilestoneSlot = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild(
    "TaskContractMilestoneSlot"
)
local TaskContainer = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("TaskContainer")
local t_1 = { "Tasks", "Daily Tasks", "rbxassetid://17653923757", UDim2.new(2, 0, 1.5, 0) }
local v8 = if #(TaskLibrary_m.SPECIAL_CHALLENGES or {}) ~= 1 then "s" else ""
local t = {
    t_1,
    { "LimitedTasks", nil, nil, nil },
    {
        "SpecialChallenges",
        "Special Challenge" .. v8 .. "!",
        "rbxassetid://17860673529",
        UDim2.new(2, 0, 2, 0),
        "Limited time only!"
    },
    {
        "EventTasks",
        "Earn " .. EventLibrary_m.EVENT_DETAILS.CURRENCY_NAME_PLURAL .. "!",
        EventLibrary_m.EVENT_DETAILS.CURRENCY_IMAGE,
        UDim2.new(2.25, 0, 2.25, 0),
        "Limited time only!"
    },
    { "BonusTasks", "Bonus Tasks", "rbxassetid://17653923757", UDim2.new(2, 0, 1.5, 0) }
}
local t_6 = setmetatable({}, Page_m)
t_6.__index = t_6

function t_6._new() -- line: 43
    -- upvalues:
    --  [1] Page_m (copy)
    --  [2] t_6 (copy)
    --  [3] AdventCalendarSlot_m (copy)

    local t_7 = setmetatable(Page_m.new(script.Name), t_6)
    t_7.CloseButton = t_7.PageFrame:WaitForChild("Close")
    t_7.List = t_7.PageFrame:WaitForChild("List")
    t_7.Container = t_7.List:WaitForChild("Container")
    t_7.Layout = t_7.Container:WaitForChild("Layout")
    t_7.TasksCompletedFrame = t_7.Container:WaitForChild("TasksCompleted")
    t_7.TasksCompletedContainer = t_7.TasksCompletedFrame:WaitForChild("Container")
    t_7.TasksCompletedTimerText = t_7.TasksCompletedContainer:WaitForChild("Timer")
    t_7.TasksCompletedContentsFrame = t_7.TasksCompletedContainer:WaitForChild("Contents")
    t_7.TasksCompletedContentsLayout = t_7.TasksCompletedContentsFrame:WaitForChild("Layout")
    t_7.TasksCompletedRefreshFrame = t_7.TasksCompletedContentsFrame:WaitForChild("Refresh")
    t_7.TasksCompletedRefreshRewardsFrame = t_7.TasksCompletedRefreshFrame:WaitForChild("Rewards")
    t_7.TasksCompletedRefreshButton = t_7.TasksCompletedRefreshFrame:WaitForChild("Button")
    t_7.TasksCompletedRefreshButtonText = t_7.TasksCompletedRefreshButton:WaitForChild("Price")
    t_7.ContractsFrame = t_7.Container:WaitForChild("Contracts")
    t_7.ContractsContainer = t_7.ContractsFrame:WaitForChild("Container")
    t_7.ContractsFilterButton = t_7.ContractsContainer:WaitForChild("Filter")
    t_7.ContractsDropdownFrame = t_7.ContractsContainer:WaitForChild("Dropdown")
    t_7.ContractsDropdownButton = t_7.ContractsDropdownFrame:WaitForChild("Button")
    t_7.ContractsDropdownTitle = t_7.ContractsDropdownButton:WaitForChild("Title")
    t_7.ContractsMilestones = t_7.ContractsContainer:WaitForChild("Milestones")
    t_7.ContractsLayout = t_7.ContractsMilestones:WaitForChild("Layout")
    t_7.AdventCalendarFrame = t_7.Container:WaitForChild("AdventCalendar")
    t_7.AdventCalendarSlot = AdventCalendarSlot_m.new(t_7.AdventCalendarFrame)
    t_7._to_shooting_range_button = nil
    t_7._to_duels_button = nil
    t_7._task_containers = {}
    t_7._task_slots = {}
    t_7._contract_slots = {}
    t_7._contract_dividers = {}
    t_7._daily_task_streak_cleanup = {}
    t_7._daily_task_streak_reward_slots = {}
    t_7._daily_task_streak_update_callbacks = {}
    t_7._percent_contract_goal_enabled = false
    t_7._while_open_callbacks = {}
    t_7:_Init()

    return t_7
end

function t_6.ScrollTo(arg1, arg2, arg3) -- line: 92
    -- upvalues:
    --  [1] TweenService (copy)

    local v12 = arg1._task_containers[arg2]

    if not v12 then
        return
    end

    task.delay(arg3 or 0, function() -- line: 99
        -- upvalues:
        --  [1] TweenService (ref)
        --  [2] arg1 (copy)
        --  [3] v12 (copy)

        TweenService:Create(
            arg1.List,
            TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
            {
                CanvasPosition = Vector2.new(
                    0,
                    v12.AbsolutePosition.Y - arg1.Container.AbsolutePosition.Y
                )
            }
        ):Play()
    end)
end

function t_6.Open(arg4, ...) -- line: 104
    -- upvalues:
    --  [1] Page_m (copy)
    --  [2] PlayerDataController_m (copy)
    --  [3] TimerController_m (copy)
    --  [4] TaskLibrary_m (copy)

    Page_m.Open(arg4, ...)
    arg4.AdventCalendarSlot:SetEnabled(true)
    arg4.ContractsDropdownFrame.Visible = PlayerDataController_m:Get("Level") >= 15 and true
    table.insert(arg4._open_threads, task.spawn(function() -- line: 110
        -- upvalues:
        --  [1] arg4 (copy)

        for _, val in pairs(arg4._while_open_callbacks) do
            val()
        end

        wait(1)
    end))
    table.insert(arg4._open_threads, task.spawn(function() -- line: 120
        -- upvalues:
        --  [1] arg4 (copy)

        wait(3)

        for _, val_1 in pairs(arg4._daily_task_streak_reward_slots) do
            val_1.Frame:TweenPosition(
                UDim2.new(0.5, 0, -0.125, 0),
                "Out",
                "Quint",
                1,
                true
            )
        end

        wait(0.75)

        for _, val_2 in pairs(arg4._daily_task_streak_reward_slots) do
            val_2.Frame:TweenPosition(
                UDim2.new(0.5, 0, 0.5, 0),
                "Out",
                "Bounce",
                1,
                true
            )
        end
    end))
    local OpenConnections = arg4._open_connections
    local StatisticDuelsPlayed = PlayerDataController_m:GetDataChangedSignal("StatisticDuelsPlayed")
    table.insert(OpenConnections, StatisticDuelsPlayed:Connect(function() -- line: 136
        -- upvalues:
        --  [1] arg4 (copy)

        arg4:_Generate()
    end))
    local OpenConnections_1 = arg4._open_connections
    local BeginnerTasksCompleted = PlayerDataController_m:GetDataChangedSignal(
        "BeginnerTasksCompleted"
    )
    table.insert(OpenConnections_1, BeginnerTasksCompleted:Connect(function() -- line: 140
        -- upvalues:
        --  [1] arg4 (copy)

        arg4:_Generate()
    end))
    local OpenConnections_2 = arg4._open_connections
    local DailyTaskStreak = PlayerDataController_m:GetDataChangedSignal("DailyTaskStreak")
    table.insert(OpenConnections_2, DailyTaskStreak:Connect(function() -- line: 144
        -- upvalues:
        --  [1] arg4 (copy)

        arg4:_Generate()
    end))
    table.insert(arg4._open_connections, TimerController_m.TimerUpdated:Connect(function() -- line: 148
        -- upvalues:
        --  [1] arg4 (copy)

        arg4:_Generate()
    end))
    local _ = TimerController_m.TimerUpdated:Connect(function() -- line: 148
        -- upvalues:
        --  [1] arg4 (copy)

        arg4:_Generate()
    end)

    for _, val_3 in pairs(TaskLibrary_m.TASKS_DATA_NAMES) do
        table.insert(arg4._open_connections, PlayerDataController_m:GetDataChangedSignal(val_3):Connect(
            function() -- line: 153
                -- upvalues:
                --  [1] arg4 (copy)

                arg4:_Generate()
            end
        ))
    end

    arg4:_Generate()
end

function t_6.Close(arg5, ...) -- line: 161
    -- upvalues:
    --  [1] TimerController_m (copy)
    --  [2] Page_m (copy)

    TimerController_m:OnStep("TaskPage", nil, nil)
    arg5.AdventCalendarSlot:SetEnabled(false)
    arg5:_StopDropdown()
    Page_m.Close(arg5, ...)
end

function t_6._StopDropdown(arg6) -- line: 172
    if arg6._dropdown_slot then
        arg6._dropdown_slot:Cancel()
        arg6._dropdown_slot = nil
    end

    arg6.ContractsDropdownButton.Visible = true
end

function t_6._StartDropdown(arg7) -- line: 181
    -- upvalues:
    --  [1] DropdownSlot_m (copy)

    arg7:_StopDropdown()
    arg7.ContractsDropdownButton.Visible = false
    arg7._dropdown_slot = DropdownSlot_m.new(
        arg7.ContractsDropdownFrame,
        { "Near Completion", "Most Played" }
    )
    arg7._dropdown_slot.Selected:Connect(function(mouse: Instance) -- line: 188
        -- upvalues:
        --  [1] arg7 (copy)

        if mouse then
            arg7.ContractsDropdownTitle.Text = mouse
            arg7:_Generate()
        end

        arg7:_StopDropdown()
    end)
end

function t_6._SetPercentContractGoalEnabled(arg9, arg10) -- line: 198
    arg9._percent_contract_goal_enabled = arg10

    for _, val_4 in pairs(arg9._contract_slots) do
        val_4.GoalPercent.Visible = arg9._percent_contract_goal_enabled
        val_4.Goal.Visible = not arg9._percent_contract_goal_enabled
    end
end

function t_6._CreateDailyTaskStreakSlot(arg11, arg12) -- line: 207
    -- upvalues:
    --  [1] DailyTaskStreakSlot (copy)
    --  [2] PlayerDataController_m (copy)
    --  [3] TaskLibrary_m (copy)
    --  [4] DailyTaskStreakMilestoneSlot (copy)
    --  [5] Utility_m (copy)
    --  [6] RewardSlot_m (copy)

    local v16 = DailyTaskStreakSlot:Clone()
    local v17 = arg12 or false

    local function update(arg13, arg14) -- line: 212
        -- upvalues:
        --  [1] v16 (copy)
        --  [2] v17 (copy)
        --  [3] PlayerDataController_m (ref)
        --  [4] TaskLibrary_m (ref)
        --  [5] DailyTaskStreakMilestoneSlot (ref)
        --  [6] arg11 (copy)
        --  [7] Utility_m (ref)
        --  [8] RewardSlot_m (ref)

        local v18 = v16
        local v19 = arg13 and v17 == arg14
        v18.Visible = v19

        if not v16.Visible then
            return
        end

        local v20 = PlayerDataController_m:Get("DailyTaskStreak")
        local v21 = math.floor(v20 / TaskLibrary_m.NUM_DAILY_TASK_STREAK_REWARD_MILESTONES) * TaskLibrary_m.NUM_DAILY_TASK_STREAK_REWARD_MILESTONES + 1

        for index = v21, v21 + TaskLibrary_m.NUM_DAILY_TASK_STREAK_REWARD_MILESTONES - 1 do
            local v22 = TaskLibrary_m.DailyTaskStreakRewards[(index - 1) % TaskLibrary_m.NUM_DAILY_TASK_STREAK_REWARD_MILESTONES + 1]
            local v23 = if not v22.CanMultiplyRewards then 1 else math.min(
                TaskLibrary_m.DAILY_TASK_STREAK_REWARD_MAX_MULTIPLIER,
                (math.ceil(index / TaskLibrary_m.NUM_DAILY_TASK_STREAK_REWARD_MILESTONES))
            )
            local v25 = v20 >= index
            local v24 = index == v20 + 1

            if not (index > v20 + 1) then
            end

            local v26 = if not v24 then if not v25 then 0.9 else 0 else if not arg14 then 0 else if not v25 then 0.9 else 0
            local v27 = DailyTaskStreakMilestoneSlot:Clone()
            v27.LayoutOrder = index
            v27.Completed.Visible = v25
            v27.Date.Visible = not v25
            v27.Date.Value.Text = index
            v27.Date.Value.TextTransparency = v26
            v27.Date.Title.TextTransparency = v26
            v27.Background.Circle.BackgroundTransparency = if v25 then 0 else 1
            v27.Background.Circle.UIStroke.Transparency = v26
            local v28 = if not v25 then if not v24 then 1 else 2 else 2
            v27.Background.Circle.UIStroke.Thickness = v28
            v27.Background.Dash.BackgroundTransparency = v26
            v27.Background.Dash.Visible = if index == v21 then false else true
            v27.Reward.Visible = not v25
            v27.Parent = v16.Container.Milestones
            table.insert(arg11._daily_task_streak_cleanup, v27)
            local v29 = pairs
            local v30 = v22.Rewards or {}

            for _, val_5 in v29(v30) do
                v26 = Utility_m:CloneTable(val_5)
                v26.Quantity = (v26.Quantity or 1) * v23
                v24 = RewardSlot_m.new(v26)
                v24:SetParent(v27.Reward)
                table.insert(arg11._daily_task_streak_cleanup, v24)
                table.insert(arg11._daily_task_streak_reward_slots, v24)
            end
        end
    end

    table.insert(arg11._daily_task_streak_update_callbacks, update)
    update()

    return v16
end

function t_6._UpdateDailyTaskStreak(arg15, ...) -- line: 264
    for _, val_6 in pairs(arg15._daily_task_streak_cleanup) do
        val_6:Destroy()
    end

    arg15._daily_task_streak_cleanup = {}
    arg15._daily_task_streak_reward_slots = {}

    for _, val_7 in pairs(arg15._daily_task_streak_update_callbacks) do
        val_7(...)
    end
end

function t_6._Generate(arg16) -- line: 277
    -- upvalues:
    --  [1] PlayerDataController_m (copy)
    --  [2] TaskLibrary_m (copy)
    --  [3] EventLibrary_m (copy)
    --  [4] CONSTANTS_m (copy)
    --  [5] TimerController_m (copy)

    for _, val_8 in pairs(arg16._task_slots) do
        val_8:Destroy()
    end

    for _, val_9 in pairs(arg16._contract_slots) do
        val_9:Destroy()
    end

    for _, val_10 in pairs(arg16._contract_dividers) do
        val_10:Destroy()
    end

    arg16._task_slots = {}
    arg16._contract_slots = {}
    arg16._contract_dividers = {}
    local v31 = PlayerDataController_m:Get("BeginnerTasksCompleted")
    local v32 = v31 >= TaskLibrary_m.NUM_BEGINNER_TASKS and true
    local v33 = PlayerDataController_m:AreTasksCompleted()
    local v34 = EventLibrary_m.IS_ACTIVE

    if v34 then
        v34 = PlayerDataController_m:GetStatistic("StatisticDuelsPlayed") >= EventLibrary_m.NUM_GAMES_NEEDED_TO_PARTICIPATE and true
    end

    local v35 = #(PlayerDataController_m:Get("LimitedTasks") or {}) > 0
    arg16.TasksCompletedFrame.Visible = v33
    arg16.ContractsFrame.Visible = v32
    local v37

    if arg16._to_shooting_range_button then
        v37 = CONSTANTS_m.SHOOTING_RANGE_ACTIVE
        local ToShootingRangeButton = arg16._to_shooting_range_button
        v37 = v37 and v31 <= TaskLibrary_m.NUM_BEGINNER_TASKS - 2
        ToShootingRangeButton.Visible = v37
    end

    if arg16._to_duels_button then
        v37 = CONSTANTS_m.QUEUES_ACTIVE
        local ToDuelsButton = arg16._to_duels_button
        v37 = v37 and v31 >= TaskLibrary_m.NUM_BEGINNER_TASKS - 1
        ToDuelsButton.Visible = v37
    end

    v37 = false
    local SpecialChallenges = arg16._task_containers.SpecialChallenges

    if PlayerDataController_m:Get("SpecialChallenges") ~= nil then
        v37 = not PlayerDataController_m:AreTasksCompleted("SpecialChallenges")
    end

    SpecialChallenges.Visible = v37
    arg16._task_containers.EventTasks.Visible = v33 and v34
    arg16._task_containers.LimitedTasks.Visible = v35
    arg16._task_containers.BonusTasks.Visible = v33
    arg16._task_containers.Tasks.Visible = not v33
    arg16._task_containers.Tasks.Container.Title.Text = if v32 then "Daily Tasks" else "Beginner Tasks   [" .. v31 + 1 .. " / " .. TaskLibrary_m.NUM_BEGINNER_TASKS .. "]"
    TimerController_m:OnStep("TaskPageTaskRefresh", "TaskRefresh", if not v33 then nil else function(
        _,
        arg18
    ) -- line: 318
        -- upvalues:
        --  [1] arg16 (copy)

        arg16.TasksCompletedTimerText.Text = "new tasks in " .. arg18
    end)
    arg16:_GenerateTasks(v33, v32, v34, v35)

    if v32 then
        arg16:_GenerateContracts()
    end
end

function t_6._GenerateTasks(
    arg19,
    arg20,
    arg21,
    arg22,
    _
) -- line: 329
    -- upvalues:
    --  [1] TaskLibrary_m (copy)
    --  [2] PlayerDataController_m (copy)
    --  [3] TaskSlot_m (copy)

    local v41 = if not arg20 then { "Tasks" } else { "BonusTasks" } or { "Tasks" }

    if arg20 and arg22 then
        table.insert(v41, "EventTasks")
    end

    if TaskLibrary_m.SPECIAL_CHALLENGES then
        table.insert(v41, "SpecialChallenges")
    end

    table.insert(v41, "LimitedTasks")
    local v42 = TaskLibrary_m:GetCurrentlyActiveLimitedTasks()

    for _, val_11 in pairs(v41) do
        local v43 = arg19._task_containers[val_11]
        local v44 = PlayerDataController_m:Get(val_11)

        if v44 then
            local v45 = if val_11 ~= "SpecialChallenges" then if val_11 ~= "LimitedTasks" then false else v42 and v42.RequiresPreviousTaskCompleted else TaskLibrary_m.SPECIAL_CHALLENGES_MUST_BE_COMPLETED_IN_ORDER or (if val_11 ~= "LimitedTasks" then false else v42 and v42.RequiresPreviousTaskCompleted)
            local v46 = false

            for key_12, val_12 in pairs(v44) do
                local v47 = v45 and key_12 > 1 and not v44[key_12 - 1].Completed
                local v48 = TaskSlot_m.new(val_12)
                v48:SetLocked(v47, v46)
                v48:SetParent(v43.Container.Contents.Slots.Container)
                table.insert(arg19._task_slots, v48)
                v46 = v47
            end
        end
    end

    arg19:_UpdateDailyTaskStreak(arg21, arg20)
end

function t_6._GenerateContracts(arg24) -- line: 372
    -- upvalues:
    --  [1] ContractsLibrary_m (copy)
    --  [2] StatisticsLibrary_m (copy)
    --  [3] TaskContractMilestoneSlot (copy)
    --  [4] ItemLibrary_m (copy)
    --  [5] DuelLibrary_m (copy)
    --  [6] RewardSlot_m (copy)
    --  [7] PlayerDataController_m (copy)
    --  [8] Utility_m (copy)
    --  [9] TaskContractMilestoneDivider (copy)

    local v49 = if arg24.ContractsDropdownTitle.Text ~= "Near Completion" then "FilterPlaytime" else "FilterProgress"
    local v50 = 0

    local _ = function(arg25) --[[ get_layout_order_from_group ]] -- line: 376
        return arg25 * 99999
    end

    local function generate(arg26, arg27, arg28, arg29) -- line: 380
        -- upvalues:
        --  [1] ContractsLibrary_m (ref)
        --  [2] StatisticsLibrary_m (ref)
        --  [3] v50 (ref)
        --  [4] TaskContractMilestoneSlot (ref)
        --  [5] ItemLibrary_m (ref)
        --  [6] DuelLibrary_m (ref)
        --  [7] arg24 (copy)
        --  [8] RewardSlot_m (ref)

        local v51 = arg26 or arg27 or "???"
        local v52 = ContractsLibrary_m.Contracts[arg28]
        local v53 = StatisticsLibrary_m.Info[v52.StatisticName]
        local v54 = if not string.find(arg28, " Rounds Won") then if not string.find(
            arg28,
            " Playtime"
        ) then 2 else 4 else 6

        for key_13, val_13 in pairs(v52.Milestones) do
            local v55, v56 = table.unpack(val_13)
            local v57 = arg29 >= v55 and true

            if not v57 or not (key_13 < #v52.Milestones) then
                v50 += 1
                local v58 = TaskContractMilestoneSlot:Clone()
                v58.Progress.Bar.Size = UDim2.new(math.clamp(arg29 / v55, 0, 1), 0, 1, 2)
                local Bar_1 = v58.Progress.Bar
                local v59 = v57 and Color3.fromRGB(100, 255, 50) or Color3.fromRGB(0, 190, 255)
                Bar_1.BackgroundColor3 = v59
                v58.Completed.Visible = v57
                local Goal = v58.Goal
                v59 = if v57 then "" else string.format(
                    "%s <font size=\"8\">/ %s</font>",
                    v53.TostringFunction(arg29),
                    v53.TostringFunction(v55)
                )
                Goal.Text = v59
                v58.GoalPercent.Text = if v57 then "" else string.format("%.1f", arg29 / v55 * 100) .. "%"
                v58.Title.Text = v51 .. "  \226\128\162  " .. v53.FullDisplayName
                local Weapon = v58.Weapon
                local v61 = arg26 and ItemLibrary_m.Items[arg26].Image or ""
                Weapon.Image = v61
                local Map = v58.Map
                v61 = arg27 and DuelLibrary_m.Maps[arg27].Image or ""
                Map.Image = v61
                v58.LayoutOrder = v54 * 99999
                v58.Parent = arg24.ContractsMilestones
                table.insert(arg24._contract_slots, v58)

                if not v56 or v57 then
                    break
                end

                RewardSlot_m.new(v56):SetParent(v58.Reward)

                return
            end
        end
    end

    local _ = function(arg30, arg31) --[[ get_current_milestone_info ]] -- line: 420
        for _, val_14 in pairs(arg30.Milestones) do
            local v63, _ = table.unpack(val_14)

            if not (if not (arg31 >= v63) then false else true) then
                return val_14
            end
        end

        return arg30.Milestones[#arg30.Milestones]
    end

    local function get_sorted_contracts(arg32, arg33, arg34) -- line: 433
        -- upvalues:
        --  [1] ContractsLibrary_m (ref)
        --  [2] PlayerDataController_m (ref)
        --  [3] v49 (copy)
        --  [4] Utility_m (ref)

        local t_10 = {}
        local v70

        for _, val_15 in pairs(arg32) do
            local v65 = if arg34 then ContractsLibrary_m:GetWeaponContracts(val_15) else ContractsLibrary_m:GetMapContracts(
                val_15
            )
            local v66 = v65

            if v66 then
                v66 = v65[arg33]
            end

            if v66 then
                v65 = ContractsLibrary_m.Contracts[v66]
                local v67 = if arg34 then PlayerDataController_m:GetWeaponStatistic(
                    v65.Identifier,
                    v65.StatisticName,
                    v65.ExtraStatisticNames
                ) else PlayerDataController_m:GetMapStatistic(
                    v65.Identifier,
                    v65.StatisticName,
                    v65.ExtraStatisticNames
                )
                local loop_exited = false

                for _, val_16 in pairs(v65.Milestones) do
                    local v68, _ = table.unpack(val_16)

                    if not (if not (v67 >= v68) then false else true) then
                        v70 = val_16
                        loop_exited = true
                        break
                    end
                end

                if not loop_exited then
                    v70 = v65.Milestones[#v65.Milestones]
                end

                local v71 = v70[1]
                local t_11 = {
                    Name = val_15,
                    ContractName = v66,
                    Progress = v67,
                    Goal = v71,
                    FilterPlaytime = if arg34 then PlayerDataController_m:GetWeaponStatistic(
                        val_15,
                        "StatisticPlaytime"
                    ) else PlayerDataController_m:GetMapStatistic(val_15, "StatisticPlaytime"),
                    FilterProgress = -(v71 - v67)
                }
                table.insert(t_10, t_11)
            end
        end

        table.sort(t_10, function(arg35, arg36) -- line: 460
            -- upvalues:
            --  [1] v49 (ref)
            --  [2] Utility_m (ref)

            local v73 = arg35.Progress >= arg35.Goal
            local v74 = arg36.Progress >= arg36.Goal and true

            if v73 ~= v74 then
                return v74
            end

            if math.abs(arg35[v49] - arg36[v49]) > 0.001 then
                return arg35[v49] > arg36[v49]
            end

            return Utility_m:StringLessThan(arg35.Name, arg36.Name)
        end)

        return t_10
    end

    for _, val_17 in pairs({ 3, 5 }) do
        local v76 = TaskContractMilestoneDivider:Clone()
        v76.LayoutOrder = val_17 * 99999
        v76.Parent = arg24.ContractsMilestones
        table.insert(arg24._contract_dividers, v76)
    end

    local function get_sorted_weapons(arg37, arg38) -- line: 487
        -- upvalues:
        --  [1] PlayerDataController_m (ref)
        --  [2] ItemLibrary_m (ref)
        --  [3] get_sorted_contracts (copy)

        local t_13 = {}

        for _, val_18 in pairs(PlayerDataController_m:Get("WeaponInventory")) do
            local Name = val_18.Name

            if ItemLibrary_m.Classes[ItemLibrary_m.Items[Name].Class].Slot == arg37 then
                table.insert(t_13, Name)
            end
        end

        return (get_sorted_contracts(t_13, arg38, true))
    end

    for index_1 = 1, 2 do
        for index_2 = 1, 4 do
            for _, val_19 in pairs((get_sorted_weapons(index_2, index_1))) do
                generate(val_19.Name, nil, val_19.ContractName, val_19.Progress)
                break
            end
        end
    end

    local function get_sorted_maps(arg39) -- line: 516
        -- upvalues:
        --  [1] DuelLibrary_m (ref)
        --  [2] get_sorted_contracts (copy)

        local t_14 = {}

        for _, val_20 in pairs(DuelLibrary_m.MapOrder) do
            table.insert(t_14, val_20)
        end

        return (get_sorted_contracts(t_14, arg39, false))
    end

    local v79 = get_sorted_maps(1)

    for index_3 = 1, 4 do
        local v80 = v79[index_3]
        generate(nil, v80.Name, v80.ContractName, v80.Progress)
    end

    arg24:_SetPercentContractGoalEnabled(arg24._percent_contract_goal_enabled)
end

function t_6._Setup(arg40) -- line: 539
    -- upvalues:
    --  [1] t (copy)
    --  [2] TaskLibrary_m (copy)
    --  [3] TaskContainer (copy)
    --  [4] ShootingRangeController_m (copy)
    --  [5] LobbyController_m (copy)
    --  [6] ButtonEffect_m (copy)
    --  [7] ServerOsTime_m (copy)
    --  [8] Utility_m (copy)
    --  [9] RewardSlot_m (copy)
    --  [10] MonetizationController_m (copy)
    --  [11] MonetizationLibrary_m (copy)

    arg40.ContractsDropdownTitle.Text = "Near Completion"
    local v86

    for key_21, val_21 in pairs(t) do
        local v81, v82, v83, v84, v85 = table.unpack(val_21)

        if v81 == "LimitedTasks" then
            v86 = TaskLibrary_m:GetCurrentlyActiveLimitedTasks()

            if v86 then
                v82 = v86.DisplayName
                v83 = v86.Image
                v84 = v86.ImageSize
                v85 = v86.Description
            end
        end

        local v86 = TaskContainer:Clone()
        v86.Container.Buttons.Visible = if v81 ~= "Tasks" then false else true
        v86.Container.Title.Text = v82 or ""
        v86.Container.Title.ImageLabel.Image = v83 or ""
        local ImageLabel = v86.Container.Title.ImageLabel
        local v88 = v84 or UDim2.new(1.5, 0, 1, 0)
        ImageLabel.Size = v88
        v86.Container.Description.Text = v85 or ""
        v86.LayoutOrder = -999 + key_21
        v86.Parent = arg40.Container
        arg40._task_containers[v81] = v86
        v86.Container.Contents.Slots.Container.Layout:GetPropertyChangedSignal(
            "AbsoluteContentSize"
        ):Connect(function() --[[ update_slots ]] -- line: 566
            -- upvalues:
            --  [1] v86 (copy)

            v86.Container.Contents.Slots.Size = UDim2.new(
                1,
                0,
                0,
                v86.Container.Contents.Slots.Container.Layout.AbsoluteContentSize.Y
            )
        end)
        v86.Container.Contents.Slots.Size = UDim2.new(
            1,
            0,
            0,
            v86.Container.Contents.Slots.Container.Layout.AbsoluteContentSize.Y
        )

        local function update_frame() -- line: 573
            -- upvalues:
            --  [1] v86 (copy)

            pcall(function() -- line: 574
                -- upvalues:
                --  [1] v86 (ref)

                v86.Size = UDim2.new(
                    1,
                    0,
                    0,
                    v86.Container.AbsoluteSize.Y * 0.2 + v86.Container.Contents.Layout.AbsoluteContentSize.Y
                )
                local v90 = false
                local v91 = v86

                if v86.Container.Contents.Layout.AbsoluteContentSize.Y > 1 then
                    v90 = #v86.Container.Contents.Slots.Container:GetChildren() > 1 and true
                end

                v91.Visible = v90
            end)
        end

        v86.Container.Contents.Slots.Container.ChildAdded:Connect(update_frame)
        v86.Container.Contents.Slots.Container.ChildRemoved:Connect(update_frame)
        v86.Container.Contents.Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(
            update_frame
        )
        v86.Container:GetPropertyChangedSignal("AbsoluteSize"):Connect(update_frame)
        pcall(function() -- line: 574
            -- upvalues:
            --  [1] v86 (copy)

            v86.Size = UDim2.new(
                1,
                0,
                0,
                v86.Container.AbsoluteSize.Y * 0.2 + v86.Container.Contents.Layout.AbsoluteContentSize.Y
            )
            local v93 = false
            local v94 = v86

            if v86.Container.Contents.Layout.AbsoluteContentSize.Y > 1 then
                v93 = #v86.Container.Contents.Slots.Container:GetChildren() > 1 and true
            end

            v94.Visible = v93
        end)

        if v81 == "Tasks" then
            arg40:_CreateDailyTaskStreakSlot(false).Parent = v86.Container.Contents
            arg40._to_shooting_range_button = v86.Container.Buttons.ToShootingRange
            arg40._to_duels_button = v86.Container.Buttons.ToDuels
            arg40._to_shooting_range_button.Button.MouseButton1Click:Connect(function() -- line: 593
                -- upvalues:
                --  [1] arg40 (copy)
                --  [2] ShootingRangeController_m (ref)

                arg40:CloseRequest()
                ShootingRangeController_m:Enter(true)
            end)
            arg40._to_duels_button.Button.MouseButton1Click:Connect(function() -- line: 598
                -- upvalues:
                --  [1] arg40 (copy)
                --  [2] LobbyController_m (ref)

                arg40:CloseRequest()
                LobbyController_m:ToDuels()
            end)
            local t_15 = {
                HoverRatio = UDim2.new(0, 10, 0, 10),
                ReleaseRatio = UDim2.new(0, 10, 0, 10)
            }
            ButtonEffect_m:Add(arg40._to_duels_button.Button, nil, t_15)
            local t_16 = {
                HoverRatio = UDim2.new(0, 10, 0, 10),
                ReleaseRatio = UDim2.new(0, 10, 0, 10)
            }
            ButtonEffect_m:Add(arg40._to_shooting_range_button.Button, nil, t_16)
        elseif v81 == "LimitedTasks" then
            table.insert(arg40._while_open_callbacks, function() -- line: 606
                -- upvalues:
                --  [1] TaskLibrary_m (ref)
                --  [2] ServerOsTime_m (ref)
                --  [3] v86 (copy)
                --  [4] Utility_m (ref)

                local v98 = TaskLibrary_m:GetCurrentlyActiveLimitedTasks()
                local v99 = v98

                if v99 then
                    v99 = math.floor(v98.FinishTimestamp - ServerOsTime_m:Get())
                end

                local Description = v86.Container.Description
                Description.Text = v99 and v99 > 0 and Utility_m:TimeFormat2(v99) or "\226\128\162 \226\128\162 \226\128\162"
            end)
        end
    end

    arg40:_CreateDailyTaskStreakSlot(true).Parent = arg40.TasksCompletedContentsFrame
    RewardSlot_m.new(
        {
            Name = "Key",
            Quantity = TaskLibrary_m.Info.Core1.Rewards[1].Quantity + TaskLibrary_m.Info.Core2.Rewards[1].Quantity + TaskLibrary_m.Info.Core3.Rewards[1].Quantity
        }
    ):SetParent(arg40.TasksCompletedRefreshRewardsFrame)
    local v103 = RewardSlot_m.new(
        { Name = TaskLibrary_m.DAILY_TASKS_RARE_REWARD, Weapon = "IsRandom" }
    )
    v103.CosmeticSlot.Frame.Button.Title.Size = UDim2.new(0.9, 0, 0.4, 0)
    v103.CosmeticSlot.Frame.Button.Title.Text = math.floor(
        TaskLibrary_m.DAILY_TASKS_RARE_REWARD_CHANCE * 1000
    ) / 10 .. "%"
    v103:SetParent(arg40.TasksCompletedRefreshRewardsFrame)
    local v104 = RewardSlot_m.new(
        { Name = TaskLibrary_m.DAILY_TASKS_LEGENDARY_REWARD, Weapon = "IsRandom" }
    )
    v104.CosmeticSlot.Frame.Button.Title.Size = UDim2.new(0.9, 0, 0.4, 0)
    v104.CosmeticSlot.Frame.Button.Title.Text = math.floor(
        TaskLibrary_m.DAILY_TASKS_LEGENDARY_REWARD_CHANCE * 1000
    ) / 10 .. "%"
    v104:SetParent(arg40.TasksCompletedRefreshRewardsFrame)
    MonetizationController_m:SetRobuxText(
        arg40.TasksCompletedRefreshButtonText,
        MonetizationLibrary_m.Products.RefreshTasks.ProductID
    )
end

function t_6._Init(arg41) -- line: 635
    -- upvalues:
    --  [1] MonetizationController_m (copy)
    --  [2] MonetizationLibrary_m (copy)
    --  [3] ButtonEffect_m (copy)

    arg41.CloseButton.MouseButton1Click:Connect(function() -- line: 636
        -- upvalues:
        --  [1] arg41 (copy)

        arg41:CloseRequest()
    end)
    arg41.TasksCompletedRefreshButton.MouseButton1Click:Connect(function() -- line: 640
        -- upvalues:
        --  [1] MonetizationController_m (ref)
        --  [2] MonetizationLibrary_m (ref)

        MonetizationController_m:PromptProductPurchase(
            MonetizationLibrary_m.Products.RefreshTasks.ProductID
        )
    end)
    arg41.Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() -- line: 644
        -- upvalues:
        --  [1] arg41 (copy)

        arg41.List.CanvasSize = UDim2.new(0, 0, 0, arg41.Layout.AbsoluteContentSize.Y)
        local List_2 = arg41.List
        List_2.Active = arg41.List.CanvasSize.Y.Offset > arg41.List.AbsoluteSize.Y
        local List_3 = arg41.List
        List_3.Position = arg41.List.Active and UDim2.new(0.5, 0, 0, 0) or UDim2.new(0.5, 0, 0.2, 0)
        local CloseButton = arg41.CloseButton
        CloseButton.Position = arg41.List.Active and UDim2.new(1.075, 16, 0.0375, 0) or UDim2.new(
            1.075,
            16,
            0.2375,
            0
        )
    end)
    arg41.TasksCompletedContentsLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() -- line: 651
        -- upvalues:
        --  [1] arg41 (copy)

        arg41.TasksCompletedFrame.Size = UDim2.new(
            1,
            0,
            0,
            arg41.TasksCompletedContentsLayout.AbsoluteContentSize.Y
        )
    end)
    arg41.ContractsLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() -- line: 655
        -- upvalues:
        --  [1] arg41 (copy)

        arg41.ContractsFrame.Size = UDim2.new(
            1,
            0,
            0,
            arg41.ContractsContainer.AbsoluteSize.Y * 0.15 + arg41.ContractsLayout.AbsoluteContentSize.Y
        )
    end)
    arg41.ContractsFilterButton.MouseButton1Click:Connect(function() -- line: 659
        -- upvalues:
        --  [1] arg41 (copy)

        arg41:_SetPercentContractGoalEnabled(not arg41._percent_contract_goal_enabled)
    end)
    arg41.ContractsDropdownButton.MouseButton1Click:Connect(function() -- line: 663
        -- upvalues:
        --  [1] arg41 (copy)

        arg41:_StartDropdown()
    end)
    arg41:_Setup()
    ButtonEffect_m:Add(arg41.CloseButton)
    ButtonEffect_m:Add(arg41.ContractsFilterButton)
    local t_20 = { HoverRatio = UDim2.new(0, 8, 0, 8), ReleaseRatio = UDim2.new(0, 8, 0, 8) }
    ButtonEffect_m:Add(arg41.TasksCompletedRefreshButton, nil, t_20)
    ButtonEffect_m:Add(
        arg41.ContractsDropdownButton,
        nil,
        { ReleaseRatio = 1.025, HoverRatio = 1.025 }
    )
end

return t_6._new()
