local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local CONSTANTS_m = require(ReplicatedStorage.Modules.CONSTANTS)
local ReplicatedClass_m = require(ReplicatedStorage.Modules.ReplicatedClass)
local Signal_m = require(ReplicatedStorage.Modules.Signal)
local PlayerDataController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.PlayerDataController
)
local t = {
    "ServerRegion",
    "MatchmadeStatus",
    "MatchmadeExpectedPlayers",
    "MatchmadeConnectedPlayers",
    "MatchmadeGameOver",
    "MatchmadeCountdown",
    "MatchmadeRematchAvailable",
    "MatchmadeRematchCount",
    "MatchmadeRematchGoal",
    "MatchmadeRematchSuccess"
}
local t_1 = setmetatable({}, ReplicatedClass_m)
t_1.__index = t_1

function t_1._new() -- line: 18
    -- upvalues:
    --  [1] ReplicatedClass_m (copy)
    --  [2] t_1 (copy)
    --  [3] Signal_m (copy)

    local t_2 = setmetatable(ReplicatedClass_m.new(), t_1)
    t_2.MatchmadeDuelEnded = Signal_m.new()
    t_2.RematchDetailsChanged = Signal_m.new()
    t_2:_Init()

    return t_2
end

function t_1.IsMatchmadeDuelOver(arg1) -- line: 33
    -- upvalues:
    --  [1] CONSTANTS_m (copy)

    local v2 = CONSTANTS_m.IS_MATCHMAKING_SERVER

    if v2 then
        v2 = arg1:Get("MatchmadeGameOver")
    end

    return v2
end

function t_1.IsRematchAvailable(arg2) -- line: 37
    return arg2:Get("MatchmadeRematchSuccess") or arg2:Get("MatchmadeRematchCount") and arg2:Get(
        "MatchmadeRematchGoal"
    ) and arg2:Get("MatchmadeRematchAvailable")
end

function t_1.QueueInto(_, arg4) -- line: 41
    -- upvalues:
    --  [1] ReplicatedStorage (copy)

    return ReplicatedStorage.Remotes.Matchmaking.JoinQueue:InvokeServer(arg4)
end

function t_1.TryLeaveQueue(_) -- line: 45
    -- upvalues:
    --  [1] ReplicatedStorage (copy)

    ReplicatedStorage.Remotes.Matchmaking.TryLeaveQueue:FireServer()
end

function t_1._OnboardingQueue(arg6) -- line: 53
    -- upvalues:
    --  [1] CONSTANTS_m (copy)
    --  [2] PlayerDataController_m (copy)

    if
        CONSTANTS_m.IS_STUDIO
        or CONSTANTS_m.IS_PRIVATE_HUB_SERVER
        or PlayerDataController_m:GetStatistic("StatisticDuelsPlayed") > 0
    then
        return
    end

    arg6:QueueInto(CONSTANTS_m.BEGINNER_QUEUE_NAME)
end

function t_1._Setup(arg7) -- line: 61
    -- upvalues:
    --  [1] t (copy)

    for _, val in pairs(t) do
        local startIndex = string.find(val, "Rematch")

        local _ = function() --[[ update ]] -- line: 65
            -- upvalues:
            --  [1] arg7 (copy)
            --  [2] val (copy)

            arg7:SetReplicate(val, workspace:GetAttribute(val))
        end

        workspace:GetAttributeChangedSignal(val):Connect(function() -- line: 69
            -- upvalues:
            --  [1] arg7 (copy)
            --  [2] val (copy)
            --  [3] startIndex (copy)

            arg7:SetReplicate(val, workspace:GetAttribute(val))

            if startIndex then
                arg7.RematchDetailsChanged:Fire()
            end
        end)
        arg7:SetReplicate(val, workspace:GetAttribute(val))
    end
end

function t_1._Init(arg8) -- line: 81
    arg8:GetDataChangedSignal("MatchmadeGameOver"):Connect(function() -- line: 82
        -- upvalues:
        --  [1] arg8 (copy)

        arg8.MatchmadeDuelEnded:Fire()
    end)
    arg8:_Setup()
    task.defer(arg8._OnboardingQueue, arg8)
end

return t_1._new()
