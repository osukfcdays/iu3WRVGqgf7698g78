local v1 = game:GetService("ReplicatedStorage")
local CONSTANTS_m = require(v1.Modules.CONSTANTS)
local ServerOsTime_m = require(v1.Modules.ServerOsTime)
local DuelLibrary_m = require(v1.Modules.DuelLibrary)
v1 = if not CONSTANTS_m.IS_TESTING_SERVER then nil else nil
local v2 = v1 or 86400
local floorValue = math.floor(1755837328 / v2)
local t = {
    Info = {},
    Order = {},
    IsNewRelease = function(arg1) --[[ IsNewRelease ]] -- line: 17
        return arg1:GetCycle() <= 20539 and true
    end,
    GetOsTime = function(_) --[[ GetOsTime ]] -- line: 21
        -- upvalues:
        --  [1] ServerOsTime_m (copy)

        return ServerOsTime_m:Get() - -590400
    end,
    GetCycle = function(arg3) --[[ GetCycle ]] -- line: 25
        -- upvalues:
        --  [1] v2 (copy)

        return (math.floor(arg3:GetOsTime() / v2))
    end,
    GetTimeUntilNext = function(arg4) --[[ GetTimeUntilNext ]] -- line: 29
        -- upvalues:
        --  [1] ServerOsTime_m (copy)
        --  [2] v2 (copy)

        if arg4:IsNewRelease() then
            return 1774065600 - ServerOsTime_m:Get()
        end

        return (arg4:GetCycle() + 1) * v2 - arg4:GetOsTime()
    end
}

function t.GetCurrent(arg5) -- line: 38
    -- upvalues:
    --  [1] t (copy)
    --  [2] CONSTANTS_m (copy)
    --  [3] v1 (copy)
    --  [4] floorValue (copy)

    if arg5:IsNewRelease() then
        return t.Info.spleef
    end

    local v5 = if not CONSTANTS_m.IS_STUDIO then -math.huge else if v1 then -math.huge else 0

    return t.Info[t.Order[math.max(v5, arg5:GetCycle() - floorValue) % #t.Order + 1]]
end

function t.IsValidQueueName(arg6, arg7) -- line: 51
    return table.find(arg6:GetCurrent().QueueNames, arg7)
end

local function add_rotating_queues(arg8, ...) -- line: 55
    -- upvalues:
    --  [1] t (copy)
    --  [2] DuelLibrary_m (copy)

    local t_2 = { Name = arg8, QueueNames = { ... } }
    t.Info[arg8] = t_2
    table.insert(t.Order, arg8)

    for _, val in pairs(t_2.QueueNames) do
        assert(DuelLibrary_m.MatchmakingQueues[val] ~= nil, val)
    end
end

add_rotating_queues("juggernaut", "ltm_juggernaut_1v7")
add_rotating_queues(
    "swiftstandoff",
    "ltm_swiftstandoff_1v1",
    "ltm_swiftstandoff_2v2",
    "ltm_swiftstandoff_3v3"
)
add_rotating_queues(
    "defaultduel_bunnysniping",
    "ltm_defaultduel_1v1",
    "ltm_defaultduel_2v2",
    "ltm_bunnysniping_2v2",
    "ltm_bunnysniping_3v3"
)
add_rotating_queues("tagteam", "ltm_tagteam_3v3", "ltm_tagteam_5v5")
add_rotating_queues(
    "chickengame",
    "ltm_chickengames_1v1",
    "ltm_chickengames_2v2",
    "ltm_chickengames_3v3",
    "ltm_chickengames_4v4"
)
add_rotating_queues("rivalsrng", "ltm_rivalsrng_1v1", "ltm_rivalsrng_2v2", "ltm_rivalsrng_3v3")
add_rotating_queues("headhoncho", "ltm_headhoncho_3v3", "ltm_headhoncho_4v4", "ltm_headhoncho_5v5")
add_rotating_queues(
    "hardcoreparkour",
    "ltm_hardcoreparkour_1v1",
    "ltm_hardcoreparkour_2v2",
    "ltm_hardcoreparkour_5v5"
)
add_rotating_queues(
    "doubletrouble",
    "ltm_doubletrouble_1v1",
    "ltm_doubletrouble",
    "ltm_doubletrouble_3v3"
)
add_rotating_queues(
    "mirrormatchup",
    "ltm_mirrormatchup_1v1",
    "ltm_mirrormatchup_2v2",
    "ltm_mirrormatchup_3v3"
)
add_rotating_queues(
    "limitlessloadout",
    "ltm_limitlessloadout_1v1",
    "ltm_limitlessloadout_2v2",
    "ltm_limitlessloadout_3v3"
)
add_rotating_queues("threeteams", "1v1v1", "2v2v2", "3v3v3")
add_rotating_queues("spleef", "ltm_spleef_8v8")

return t
