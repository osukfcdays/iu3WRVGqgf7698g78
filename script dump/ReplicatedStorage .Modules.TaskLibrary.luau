local ReplicatedStorage = game:GetService("ReplicatedStorage")
local EventLibrary_m = require(ReplicatedStorage.Modules.EventLibrary)
local ServerOsTime_m = require(ReplicatedStorage.Modules.ServerOsTime)
local StudioTestUnreleasedTasks = require(ReplicatedStorage.Modules.TestLibrary):GetTestAttribute(
    "StudioTestUnreleasedTasks"
)
local t = {}
t.TASKS_DATA_NAMES = { "Tasks", "BonusTasks", "EventTasks", "SpecialChallenges", "LimitedTasks" }
t.NUM_BEGINNER_TASKS = 3
t.DAILY_TASKS_RARE_REWARD = "Nova"
t.DAILY_TASKS_RARE_REWARD_CHANCE = 0.05
t.DAILY_TASKS_LEGENDARY_REWARD = "Supernova"
t.DAILY_TASKS_LEGENDARY_REWARD_CHANCE = 0.01
t.SPECIAL_CHALLENGES_VERSION = 3
t.SPECIAL_CHALLENGES = nil
t.SPECIAL_CHALLENGES_MUST_BE_COMPLETED_IN_ORDER = false
t.DAILY_TASK_STREAK_REWARD_MAX_MULTIPLIER = 1
t.NUM_DAILY_TASK_STREAK_REWARD_MILESTONES = 0
t.Info = {}
t.LimitedTimeTasksBatches = {}
t.DailyTaskStreakRewards = {}

function t.GetCurrentlyActiveLimitedTasks(arg1) -- line: 27
    -- upvalues:
    --  [1] ServerOsTime_m (copy)

    local v1 = ServerOsTime_m:Get()

    for _, val in pairs(arg1.LimitedTimeTasksBatches) do
        if v1 >= val.StartTimestamp and v1 < val.FinishTimestamp then
            return val
        end
    end
end

local function add_task(
    arg2,
    arg3,
    arg4,
    arg5,
    arg6,
    arg7,
    arg8,
    arg9
) -- line: 37
    -- upvalues:
    --  [1] t (copy)

    local t_2 = {
        Goal = arg3,
        Title = arg5,
        Icon = arg6 or "rbxassetid://17619445009",
        Rewards = typeof(arg4) == "number" and { { Name = "Key", Quantity = arg4 } } or arg4,
        BadgeName = arg7,
        CanBeMultipliedByEventBoost = arg8,
        MaxCompletionsPerDay = arg9
    }
    t.Info[arg2] = t_2
end

add_task(
    "Beginner1",
    1,
    1,
    "Go to Shooting Range",
    "rbxassetid://17539215512"
)
add_task(
    "Beginner2",
    5,
    1,
    "Break targets",
    "rbxassetid://17738770088"
)
add_task(
    "Beginner3",
    3,
    1,
    "Run + crouch to Slide",
    "rbxassetid://17735857643"
)
add_task(
    "Beginner4",
    1,
    2,
    "Equip Scythe",
    "rbxassetid://17735878660"
)
add_task(
    "Beginner5",
    3,
    2,
    "Scythe Dash (MB2 / Aim)",
    "rbxassetid://16828140099"
)
add_task(
    "Beginner6",
    1,
    2,
    "Throw a Grenade",
    "rbxassetid://17513805716"
)
add_task(
    "Beginner7",
    1,
    3,
    "Play a duel",
    "rbxassetid://17738769051"
)
add_task(
    "Beginner8",
    5,
    3,
    "Eliminations",
    "rbxassetid://17735857264"
)
add_task(
    "Beginner9",
    1,
    3,
    "Win a duel",
    "rbxassetid://17735868621"
)
add_task(
    "Core1",
    5,
    1,
    "Play duels",
    "rbxassetid://17738769051"
)
add_task(
    "Core2",
    15,
    2,
    "Eliminations",
    "rbxassetid://17735857264"
)
add_task(
    "Core3",
    2,
    3,
    "Win duels",
    "rbxassetid://17735868621"
)
add_task(
    "RepeatableCore1",
    10,
    1,
    "Play duels",
    "rbxassetid://17738769051",
    nil,
    nil,
    3
)
add_task(
    "RepeatableCore2",
    35,
    2,
    "Eliminations",
    "rbxassetid://17735857264",
    nil,
    nil,
    3
)
add_task(
    "RepeatableCore3",
    10,
    3,
    "Win duels",
    "rbxassetid://17735868621",
    nil,
    nil,
    3
)
add_task(
    "RepeatableWins",
    25,
    { { Name = "Trophy", Weapon = "IsRandom", Quantity = 1 } },
    "Win duels",
    "rbxassetid://17735868621"
)
add_task(
    "RepeatableStreak",
    10,
    { { Name = "Fire", Weapon = "IsRandom", Quantity = 1 } },
    "Win duels in a row",
    "rbxassetid://18151049137"
)
add_task(
    "RepeatableStreak2",
    100,
    { { Name = "Blaze", Weapon = "IsRandom", Quantity = 1 } },
    "Win duels in a row",
    "rbxassetid://18151049137"
)
add_task(
    "EventDuelRoundPlayed",
    5,
    { { Name = "EventCurrency", Quantity = 3 } },
    "Play rounds in a duel",
    "rbxassetid://17738769051",
    nil,
    true
)
add_task(
    "EventEliminations",
    15,
    { { Name = "EventCurrency", Quantity = 4 } },
    "Eliminations",
    "rbxassetid://17735857264",
    nil,
    true
)
add_task(
    "EventDuelWon",
    1,
    { { Name = "EventCurrency", Quantity = 5 } },
    "Win a duel",
    "rbxassetid://17735868621",
    nil,
    true
)
add_task(
    "EventDuelWon2",
    5,
    { { Name = EventLibrary_m.PRIZE_WHEEL_NAME, Quantity = 1, Weapon = "IsRandom" } },
    "Win duels",
    "rbxassetid://17735868621",
    nil,
    nil,
    1
)
add_task(
    "EventDuelWon3",
    10,
    { { Name = EventLibrary_m.SPECIAL_LOOTBOX_VARIETY, Quantity = 1, Weapon = "IsRandom" } },
    "Win duels",
    "rbxassetid://17735868621",
    nil,
    nil,
    1
)
add_task(
    "EventDuelWon4",
    20,
    { { Name = EventLibrary_m.PRIZE_WHEEL_NAME, Quantity = 1, Weapon = "IsRandom" } },
    "Win duels",
    "rbxassetid://17735868621",
    nil,
    nil,
    1
)
add_task(
    "SpecialChallenge1",
    15,
    { { Name = "Key", Quantity = 5 }, { Name = "Jolly Chest", Quantity = 1, Weapon = "IsRandom" } },
    "Eliminate players in duels",
    "rbxassetid://101221631717761",
    "2024WinterSpotlight1"
)
add_task(
    "SpecialChallenge2",
    100,
    {
        { Name = "Key", Quantity = 15 },
        { Name = "Jolly Chest", Quantity = 3, Weapon = "IsRandom" },
        { Name = "Danger", Quantity = 1, Weapon = "IsUniversal" }
    },
    "Eliminate players in ???",
    "rbxassetid://112147813284051",
    "2024WinterSpotlight2"
)
add_task(
    "SpecialChallengeBridge1",
    5,
    { { Name = "Key", Quantity = 3 } },
    "Play duels on the Bridge map",
    "rbxassetid://17738769051"
)
add_task(
    "SpecialChallengeBridge2",
    25,
    { { Name = "Bungeoppang", Quantity = 1, Weapon = "IsUniversal" } },
    "Eliminate players on the Bridge map",
    "rbxassetid://17735857264"
)
add_task(
    "Limited_Birthday2_Keys",
    1,
    3,
    "Win a duel",
    "rbxassetid://17735868621"
)
add_task(
    "Limited_Birthday2_Charm",
    5,
    { { Name = "2nd Birthday Cake", Weapon = "IsUniversal" } },
    "Win duels",
    "rbxassetid://17735868621"
)
add_task(
    "Limited_Birthday2_Wrap",
    10,
    { { Name = "Confetti Cake", Weapon = "IsUniversal" } },
    "Win duels",
    "rbxassetid://17735868621"
)
add_task(
    "Limited_Birthday2_Finisher",
    25,
    { { Name = "Caked", Weapon = "IsUniversal" } },
    "Win duels",
    "rbxassetid://17735868621"
)
add_task(
    "Limited_Birthday2_Emote",
    50,
    { { Name = "Yummy Cake" } },
    "Win duels",
    "rbxassetid://17735868621"
)
add_task(
    "Limited_Birthday2_Skin",
    100,
    { { Name = "Birthday Candle", Weapon = "Knife" } },
    "Backstab eliminations",
    "rbxassetid://17225650859"
)
add_task(
    "Limited_2026Summer_Task1",
    1,
    { { Name = "EventCurrency", Quantity = 50 } },
    "Win a duel",
    "rbxassetid://17735868621"
)
add_task(
    "Limited_2026Summer_Task2",
    3,
    { { Name = "EventCurrency", Quantity = 100 } },
    "Win duels",
    "rbxassetid://17735868621"
)
add_task(
    "Limited_2026Summer_Task3",
    5,
    { { Name = "EventCurrency", Quantity = 200 } },
    "Win duels",
    "rbxassetid://17735868621"
)
add_task(
    "Limited_2026Summer_Task4",
    10,
    { { Name = "Tropical Chest", Quantity = 9, Weapon = "IsRandom" } },
    "Win duels",
    "rbxassetid://17735868621"
)
add_task(
    "Limited_2026Summer_Task5",
    15,
    { { Name = "EventCurrency", Quantity = 300 } },
    "Win duels",
    "rbxassetid://17735868621"
)
add_task(
    "Limited_2026Summer_Task6",
    20,
    { { Name = "Spooky Skin Case", Quantity = 1, Weapon = "IsRandom" } },
    "Win duels",
    "rbxassetid://17735868621"
)
add_task(
    "Limited_2026Spooky_Task1",
    1,
    { { Name = "EventCurrency", Quantity = 100 } },
    "Win a duel",
    "rbxassetid://17735868621"
)
add_task(
    "Limited_2026Spooky_Task2",
    5,
    { { Name = "EventCurrency", Quantity = 200 } },
    "Win duels",
    "rbxassetid://17735868621"
)
add_task(
    "Limited_2026Spooky_Task3",
    10,
    { { Name = "Haunted Chest", Quantity = 3, Weapon = "IsRandom" } },
    "Win duels",
    "rbxassetid://17735868621"
)
add_task(
    "Limited_2026Spooky_Task4",
    15,
    { { Name = "Spooky Prize Wheel", Quantity = 1, Weapon = "IsRandom" } },
    "Win duels",
    "rbxassetid://17735868621"
)
add_task(
    "Limited_2026Spooky_Task5",
    25,
    { { Name = "Spooky Prize Wheel", Quantity = 1, Weapon = "IsRandom" } },
    "Win duels",
    "rbxassetid://17735868621"
)
add_task(
    "Limited_2026Spooky_Task6",
    50,
    { { Name = "Spooky Skin Case", Quantity = 1, Weapon = "IsRandom" } },
    "Win duels",
    "rbxassetid://17735868621"
)

local _ = function(
    arg10,
    arg11,
    arg12,
    arg13,
    arg14,
    arg15,
    arg16,
    arg17
) --[[ add_limited_time_tasks_batch ]] -- line: 106
    -- upvalues:
    --  [1] t (copy)

    t.LimitedTimeTasksBatches[arg10] = {
        Name = arg10,
        RequiresPreviousTaskCompleted = arg11,
        DisplayName = arg12,
        Image = arg13,
        ImageSize = arg14,
        StartTimestamp = arg15,
        Duration = arg16,
        FinishTimestamp = arg15 + arg16,
        TaskNames = arg17
    }
end

t.LimitedTimeTasksBatches.ltt_bday2 = {
    Name = "ltt_bday2",
    RequiresPreviousTaskCompleted = true,
    DisplayName = "Birthday Celebration",
    Image = "rbxassetid://17653923757",
    ImageSize = UDim2.new(2, 0, 1.5, 0),
    StartTimestamp = 1782619200,
    Duration = 1209600,
    FinishTimestamp = 1783828800,
    TaskNames = {
        "Limited_Birthday2_Keys",
        "Limited_Birthday2_Charm",
        "Limited_Birthday2_Wrap",
        "Limited_Birthday2_Finisher",
        "Limited_Birthday2_Emote",
        "Limited_Birthday2_Skin"
    }
}
t.LimitedTimeTasksBatches.ltt_summer2026 = {
    Name = "ltt_summer2026",
    RequiresPreviousTaskCompleted = true,
    DisplayName = "Summer Fun",
    Image = "rbxassetid://17653923757",
    ImageSize = UDim2.new(2, 0, 1.5, 0),
    StartTimestamp = 1784260800,
    Duration = 1209600,
    FinishTimestamp = 1785470400,
    TaskNames = {
        "Limited_2026Summer_Task1",
        "Limited_2026Summer_Task2",
        "Limited_2026Summer_Task3",
        "Limited_2026Summer_Task4",
        "Limited_2026Summer_Task5",
        "Limited_2026Summer_Task6"
    }
}
t.LimitedTimeTasksBatches.ltt_spooky2026 = {
    Name = "ltt_spooky2026",
    RequiresPreviousTaskCompleted = true,
    DisplayName = "No Tricks, Just Treats",
    Image = "rbxassetid://17653923757",
    ImageSize = UDim2.new(2, 0, 1.5, 0),
    StartTimestamp = 1793246400,
    Duration = 950400,
    FinishTimestamp = 1794196800,
    TaskNames = {
        "Limited_2026Spooky_Task1",
        "Limited_2026Spooky_Task2",
        "Limited_2026Spooky_Task3",
        "Limited_2026Spooky_Task4",
        "Limited_2026Spooky_Task5",
        "Limited_2026Spooky_Task6"
    }
}

local function add_daily_task_streak_reward(arg18, arg19, arg20) -- line: 126
    -- upvalues:
    --  [1] t (copy)

    local t_44 = {
        Milestone = arg18,
        CanMultiplyRewards = arg19,
        Rewards = typeof(arg20) == "number" and { { Name = "Key", Quantity = arg20 } } or arg20
    }
    t.DailyTaskStreakRewards[arg18] = t_44
    t.NUM_DAILY_TASK_STREAK_REWARD_MILESTONES = math.max(
        t.NUM_DAILY_TASK_STREAK_REWARD_MILESTONES,
        arg18
    )
end

add_daily_task_streak_reward(1, true, {})
add_daily_task_streak_reward(
    2,
    true,
    { { Name = "Prize Wheel", Quantity = 1, Weapon = "IsRandom" } }
)
add_daily_task_streak_reward(3, true, {})
add_daily_task_streak_reward(
    4,
    true,
    { { Name = "Prize Wheel", Quantity = 1, Weapon = "IsRandom" } }
)
add_daily_task_streak_reward(5, true, {})
add_daily_task_streak_reward(
    6,
    true,
    { { Name = "Prize Wheel", Quantity = 1, Weapon = "IsRandom" } }
)
add_daily_task_streak_reward(
    7,
    false,
    { { Name = "Prize Wheel", Quantity = 1, Weapon = "IsRandom" } }
)

if StudioTestUnreleasedTasks then
    add_daily_task_streak_reward = nil

    for _, val_1 in pairs(t.LimitedTimeTasksBatches) do
        if val_1.StartTimestamp > os.time() then
            add_daily_task_streak_reward = val_1
            break
        end
    end

    add_daily_task_streak_reward.StartTimestamp = os.time()
    add_daily_task_streak_reward.FinishTimestamp = add_daily_task_streak_reward.StartTimestamp + add_daily_task_streak_reward.Duration
end

return t
