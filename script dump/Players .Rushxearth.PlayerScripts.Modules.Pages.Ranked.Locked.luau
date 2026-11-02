local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local CONSTANTS_m = require(ReplicatedStorage.Modules.CONSTANTS)
local PlayerDataUtility_m = require(ReplicatedStorage.Modules.PlayerDataUtility)
local SeasonLibrary_m = require(ReplicatedStorage.Modules.SeasonLibrary)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local PlayerDataController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("PlayerDataController")
)
local SeasonController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("SeasonController")
)
local ButtonEffect_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("ButtonEffect")
)
local t = {}
t.__index = t

function t.new(arg1) -- line: 15
    -- upvalues:
    --  [1] t (copy)

    local t_1 = setmetatable({}, t)
    t_1.Page = arg1
    t_1.UnlockedFrame = t_1.Page.PageFrame:WaitForChild("Unlocked")
    t_1.LockedFrame = t_1.Page.PageFrame:WaitForChild("Locked")
    t_1.LockedCloseButton = t_1.LockedFrame:WaitForChild("Close")
    t_1.LockedLevelFrame = t_1.LockedFrame:WaitForChild("Level")
    t_1.LockedLevelBar = t_1.LockedLevelFrame:WaitForChild("Progress"):WaitForChild("Bar")
    t_1.LockedLevelGoalText = t_1.LockedLevelFrame:WaitForChild("Goal")
    t_1.LockedLevelCompleted = t_1.LockedLevelFrame:WaitForChild("Completed")
    t_1.LockedLevelText = t_1.LockedLevelFrame:WaitForChild("Title")
    t_1.LockedWinsFrame = t_1.LockedFrame:WaitForChild("Wins")
    t_1.LockedWinsBar = t_1.LockedWinsFrame:WaitForChild("Progress"):WaitForChild("Bar")
    t_1.LockedWinsGoalText = t_1.LockedWinsFrame:WaitForChild("Goal")
    t_1.LockedWinsCompleted = t_1.LockedWinsFrame:WaitForChild("Completed")
    t_1.LockedWinsText = t_1.LockedWinsFrame:WaitForChild("Title")
    t_1.LockedAgeFrame = t_1.LockedFrame:WaitForChild("Age")
    t_1.LockedAgeBar = t_1.LockedAgeFrame:WaitForChild("Progress"):WaitForChild("Bar")
    t_1.LockedAgeGoalText = t_1.LockedAgeFrame:WaitForChild("Goal")
    t_1.LockedAgeCompleted = t_1.LockedAgeFrame:WaitForChild("Completed")
    t_1.LockedAgeText = t_1.LockedAgeFrame:WaitForChild("Title")
    t_1.LockedTasksFrame = t_1.LockedFrame:WaitForChild("Tasks")
    t_1.LockedTasksBar = t_1.LockedTasksFrame:WaitForChild("Progress"):WaitForChild("Bar")
    t_1.LockedTasksGoalText = t_1.LockedTasksFrame:WaitForChild("Goal")
    t_1.LockedTasksCompleted = t_1.LockedTasksFrame:WaitForChild("Completed")
    t_1.LockedTasksText = t_1.LockedTasksFrame:WaitForChild("Title")
    t_1.LockedTrustedFrame = t_1.LockedFrame:WaitForChild("Trusted")
    t_1.LockedTrustedBar = t_1.LockedTrustedFrame:WaitForChild("Progress"):WaitForChild("Bar")
    t_1.LockedTrustedGoalText = t_1.LockedTrustedFrame:WaitForChild("Goal")
    t_1.LockedTrustedCompleted = t_1.LockedTrustedFrame:WaitForChild("Completed")
    t_1.LockedTrustedText = t_1.LockedTrustedFrame:WaitForChild("Title")
    t_1._thread = nil
    t_1:_Init()

    return t_1
end

function t.Open(arg2) -- line: 59
    arg2:_Update()
end

function t.Close(_) -- line: 63
end

function t._Update(arg4) -- line: 71
    -- upvalues:
    --  [1] CONSTANTS_m (copy)
    --  [2] PlayerDataController_m (copy)
    --  [3] SeasonLibrary_m (copy)
    --  [4] Players (copy)
    --  [5] PlayerDataUtility_m (copy)
    --  [6] Utility_m (copy)
    --  [7] SeasonController_m (copy)

    local BEGINNERQUEUEWINS = CONSTANTS_m.BEGINNER_QUEUE_WINS
    local StatisticDuelsWon = PlayerDataController_m:GetStatistic("StatisticDuelsWon")
    local LevelRequirement = SeasonLibrary_m.CurrentSeason.LevelRequirement
    local v4 = PlayerDataController_m:Get("Level")
    local AccountAgeRequirement = SeasonLibrary_m.CurrentSeason.AccountAgeRequirement
    local AccountAge = Players.LocalPlayer.AccountAge
    local TasksCompletedRequirement = SeasonLibrary_m.CurrentSeason.TasksCompletedRequirement
    local StatisticTasksCompleted = PlayerDataController_m:GetStatistic("StatisticTasksCompleted")
    local BypassTrustworthySpendRequirement = SeasonLibrary_m.CurrentSeason.BypassTrustworthySpendRequirement
    local v5 = if Players.LocalPlayer:GetAttribute("IsTrustworthy") then BypassTrustworthySpendRequirement else PlayerDataUtility_m:GetRobuxSpent(
        PlayerDataController_m:Get("Receipts"),
        PlayerDataController_m:Get("Gamepasses"),
        PlayerDataController_m:Get("CompressedReceipts")
    )
    local _ = {}
    local _ = {}
    local _ = {}
    local _ = {}

    for _, val in pairs(
        {
            {
                arg4.LockedWinsBar,
                arg4.LockedWinsGoalText,
                arg4.LockedWinsCompleted,
                StatisticDuelsWon,
                BEGINNERQUEUEWINS
            },
            {
                arg4.LockedLevelBar,
                arg4.LockedLevelGoalText,
                arg4.LockedLevelCompleted,
                v4,
                LevelRequirement
            },
            {
                arg4.LockedAgeBar,
                arg4.LockedAgeGoalText,
                arg4.LockedAgeCompleted,
                AccountAge,
                AccountAgeRequirement
            },
            {
                arg4.LockedTasksBar,
                arg4.LockedTasksGoalText,
                arg4.LockedTasksCompleted,
                StatisticTasksCompleted,
                TasksCompletedRequirement
            },
            {
                arg4.LockedTrustedBar,
                arg4.LockedTrustedGoalText,
                arg4.LockedTrustedCompleted,
                v5,
                BypassTrustworthySpendRequirement
            }
        }
    ) do
        local v12, v13, v14, v15, v16 = table.unpack(val)
        v5 = math.clamp(v15 / v16, 0, 1)
        v12.Size = UDim2.new(v5, 0, 1, 2)
        local v17 = v5 >= 1 and Color3.fromRGB(100, 255, 50) or Color3.fromRGB(255, 255, 255)
        v12.BackgroundColor3 = v17
        v13.Text = Utility_m:PrettyNumber(v15) .. " / " .. Utility_m:PrettyNumber(v16)
        v13.Visible = v5 < 1 and true
        v17 = v5 >= 1
        v14.Visible = v17
    end

    arg4.UnlockedFrame.Visible = SeasonController_m:IsRankedUnlocked()
    arg4.LockedFrame.Visible = not arg4.UnlockedFrame.Visible
end

function t._Setup(arg5) -- line: 106
    -- upvalues:
    --  [1] CONSTANTS_m (copy)
    --  [2] SeasonLibrary_m (copy)
    --  [3] Utility_m (copy)

    arg5.LockedWinsText.Text = "Win " .. CONSTANTS_m.BEGINNER_QUEUE_WINS .. " duels"
    arg5.LockedLevelText.Text = "Reach Level " .. SeasonLibrary_m.CurrentSeason.LevelRequirement
    arg5.LockedAgeText.Text = "Have a " .. SeasonLibrary_m.CurrentSeason.AccountAgeRequirement .. " day old Roblox account"
    arg5.LockedTasksText.Text = "Complete " .. SeasonLibrary_m.CurrentSeason.TasksCompletedRequirement .. " tasks"
    arg5.LockedTrustedText.Text = "Spend " .. utf8.char(57346) .. Utility_m:PrettyNumber(
        SeasonLibrary_m.CurrentSeason.BypassTrustworthySpendRequirement
    ) .. " or verify your Roblox account's email, phone, ID, etc"
end

function t._Init(arg6) -- line: 114
    -- upvalues:
    --  [1] ButtonEffect_m (copy)

    arg6.LockedCloseButton.MouseButton1Click:Connect(function() -- line: 115
        -- upvalues:
        --  [1] arg6 (copy)

        arg6.Page:CloseRequest()
    end)
    arg6:_Setup()
    arg6:_Update()
    ButtonEffect_m:Add(arg6.LockedCloseButton)
end

return t
