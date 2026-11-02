local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Signal_m = require(ReplicatedStorage.Modules.Signal)
local FighterController_m = require(Players.LocalPlayer.PlayerScripts.Controllers.FighterController)
local t = {}
t.__index = t

function t._new() -- line: 12
    -- upvalues:
    --  [1] t (copy)
    --  [2] Signal_m (copy)

    local t_1 = setmetatable({}, t)
    t_1.Refreshed = Signal_m.new()
    t_1.LeaderboardSerials = {}
    t_1._leaderboard_refreshed_signals = {}
    t_1._leaderboard_refresh_requests = {}
    t_1._local_fighter = nil
    t_1._next_request = 0
    t_1:_Init()

    return t_1
end

function t.GetLeaderboardRefreshedSignal(arg1, arg2) -- line: 33
    -- upvalues:
    --  [1] Signal_m (copy)

    if not arg1._leaderboard_refreshed_signals[arg2] then
        arg1._leaderboard_refreshed_signals[arg2] = Signal_m.new()
    end

    return arg1._leaderboard_refreshed_signals[arg2]
end

function t.GetRankingByUserID(arg3, arg4, arg5) -- line: 41
    local v1 = arg3.LeaderboardSerials[arg4]

    if not v1 then
        return
    end

    local str = tostring(arg5)

    for key, val in pairs(v1.Players) do
        if str == val.key then
            return key
        end
    end
end

function t.GetRankingByValue(arg6, arg7, arg8) -- line: 57
    local v2 = arg6.LeaderboardSerials[arg7]

    if not v2 then
        return
    end

    for key_1, val_1 in pairs(v2.Players) do
        if arg8 >= val_1.value then
            return key_1
        end
    end
end

function t._FetchLeaderboards(arg9) -- line: 75
    -- upvalues:
    --  [1] ReplicatedStorage (copy)

    if
        #arg9._leaderboard_refresh_requests == 0
        or arg9._local_fighter and (arg9._local_fighter:Get("IsInDuel") or arg9._local_fighter:Get(
            "IsInShootingRange"
        ))
    then
        return
    end

    if tick() < arg9._next_request then
        task.delay(arg9._next_request - tick(), arg9._FetchLeaderboards, arg9)

        return
    end

    arg9._next_request = tick() + 2
    ReplicatedStorage.Remotes.Misc.RequestLeaderboards:FireServer(
        arg9._leaderboard_refresh_requests
    )
    arg9._leaderboard_refresh_requests = {}
end

function t._HookFighter(arg10) -- line: 94
    -- upvalues:
    --  [1] FighterController_m (copy)

    arg10._local_fighter = FighterController_m:WaitForLocalFighter()
    arg10._local_fighter:GetDataChangedSignal("IsInDuel"):Connect(function() -- line: 97
        -- upvalues:
        --  [1] arg10 (copy)

        arg10:_FetchLeaderboards()
    end)
    arg10._local_fighter:GetDataChangedSignal("IsInShootingRange"):Connect(function() -- line: 101
        -- upvalues:
        --  [1] arg10 (copy)

        arg10:_FetchLeaderboards()
    end)
    arg10:_FetchLeaderboards()
end

function t._Setup(_) -- line: 108
    -- upvalues:
    --  [1] ReplicatedStorage (copy)

    ReplicatedStorage.Remotes.Misc.RequestLeaderboards:FireServer()
end

function t._Init(arg12) -- line: 112
    -- upvalues:
    --  [1] ReplicatedStorage (copy)

    arg12.Refreshed:Connect(function(arg13) -- line: 113
        -- upvalues:
        --  [1] arg12 (copy)

        if arg12._leaderboard_refreshed_signals[arg13] then
            arg12._leaderboard_refreshed_signals[arg13]:Fire()
        end
    end)
    ReplicatedStorage.Remotes.Misc.LeaderboardRefreshed.OnClientEvent:Connect(function(arguments) -- line: 119
        -- upvalues:
        --  [1] arg12 (copy)

        if not table.find(arg12._leaderboard_refresh_requests, arguments) then
            table.insert(arg12._leaderboard_refresh_requests, arguments)
        end

        arg12:_FetchLeaderboards()
    end)
    ReplicatedStorage.Remotes.Misc.UpdateLeaderboard.OnClientEvent:Connect(function(arguments_1) -- line: 127
        -- upvalues:
        --  [1] arg12 (copy)

        arg12.LeaderboardSerials[arguments_1.Name] = arguments_1
        arg12.Refreshed:Fire(arguments_1.Name)
    end)
    arg12:_Setup()
    task.defer(arg12._HookFighter, arg12)
end

return t._new()
