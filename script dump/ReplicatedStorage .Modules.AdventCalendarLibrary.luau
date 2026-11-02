local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CONSTANTS_m = require(ReplicatedStorage.Modules.CONSTANTS)
local ServerOsTime_m = require(ReplicatedStorage.Modules.ServerOsTime)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local t = { IS_ACTIVE = false, VERSION = 4 }
t.START_TIME = if CONSTANTS_m.IS_STUDIO then os.time() else 1765515600
t.Rewards = {}
t.NumRewards = 0

function t.GetTimeUntilRefresh(_) -- line: 19
    -- upvalues:
    --  [1] ServerOsTime_m (copy)

    return math.ceil(ServerOsTime_m:GetRounded() / 86400) * 86400 - ServerOsTime_m:GetRounded()
end

function t.GetReward(_, arg3) -- line: 23
    -- upvalues:
    --  [1] ServerOsTime_m (copy)
    --  [2] t (copy)

    local v3 = ServerOsTime_m:Get()
    local v4 = math.floor((v3 - t.START_TIME) / 86400) + 1 + (arg3 or 0)

    for _, val in pairs(t.Rewards) do
        if val.Day == v4 then
            return val, v4
        end
    end
end

local _ = function(...) --[[ add_reward ]] -- line: 33
    -- upvalues:
    --  [1] t (copy)
    --  [2] Utility_m (copy)

    local v5 = t.NumRewards + 1
    local t_1 = { ... }

    for _, val_1 in pairs({}) do
        table.insert(t_1, Utility_m:CloneTable(val_1))
    end

    t.Rewards[v5] = { Day = v5, StartTime = t.START_TIME + (v5 - 1) * 86400, Rewards = t_1 }
    local v6 = t
    v6.NumRewards += 1
end

return t
