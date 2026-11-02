local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CONSTANTS_m = require(ReplicatedStorage.Modules.CONSTANTS)
local ReplicatedClass_m = require(ReplicatedStorage.Modules.ReplicatedClass)
local ServerOsTime_m = require(ReplicatedStorage.Modules.ServerOsTime)
local DuelLibrary_m = require(ReplicatedStorage.Modules.DuelLibrary)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local t = setmetatable({}, ReplicatedClass_m)
t.__index = t

function t.new(...) -- line: 14
    -- upvalues:
    --  [1] ReplicatedClass_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(ReplicatedClass_m.new(...), t)
    t_1:_Init()

    return t_1
end

function t.GetActualQueueName(arg1) -- line: 26
    -- upvalues:
    --  [1] DuelLibrary_m (copy)

    return DuelLibrary_m:GetFirstQueueNameByDuelLogic(arg1:Get("QueueName")) or arg1:Get(
        "QueueName"
    )
end

function t.GetDuelLogics(arg2, arg3, arg4) -- line: 30
    -- upvalues:
    --  [1] DuelLibrary_m (copy)
    --  [2] ServerOsTime_m (copy)
    --  [3] CONSTANTS_m (copy)

    local t_2 = {}

    for _, val in pairs(DuelLibrary_m.PlaySourceOrder) do
        local v4 = DuelLibrary_m.PlaySources[val]

        if v4.Type == "MatchmakingQueue" then
            local v5 = DuelLibrary_m.MatchmakingQueues[val]
            local v6 = if not arg4 then v4.DuelLogic or v5.TitleName or v5.DisplayName else v5.DisplayName

            if not table.find(t_2, v6) and not (ServerOsTime_m:Get() < v5.TerminalsReleaseTime) then
                local v7 = if v5.NumTeams ~= arg2:Get("NumTeams") then if v5.NumTeams == 1 then if arg2:Get(
                    "NumTeams"
                ) ~= 2 then false else true else false else true

                if v7 then
                    v7 = arg3

                    if v7 then
                        v7 = arg3.HasVerifiedBadge or (if #arg3.DisplayName >= 2 then if string.sub(
                            arg3.DisplayName,
                            1,
                            2
                        ) ~= "00" then false else true else false)
                    end

                    if v4.DuelLogic ~= "Easy Exploits" or not arg3 or v7 or CONSTANTS_m.IS_STUDIO then
                        table.insert(t_2, v6)
                    end
                end
            end
        end
    end

    return t_2
end

function t.GetMapPools(arg5, arg6) -- line: 70
    return arg5:GetDuelLogics(arg6, true)
end

function t.GetSortedMapNames(arg7) -- line: 74
    -- upvalues:
    --  [1] DuelLibrary_m (copy)
    --  [2] Utility_m (copy)

    local v13 = DuelLibrary_m:GetMaps(
        arg7:Get("PlayersPerTeam") * arg7:Get("NumTeams"),
        arg7:Get("NumTeams"),
        arg7:Get("QueueName"),
        true
    )
    table.sort(v13, function(arg8, arg9) -- line: 77
        -- upvalues:
        --  [1] Utility_m (ref)

        return Utility_m:StringLessThan(arg8, arg9)
    end)

    return v13
end

function t.GetMatchmakingQueueInfoFromQueueName(_, arg11) -- line: 84
    -- upvalues:
    --  [1] DuelLibrary_m (copy)

    return DuelLibrary_m.MatchmakingQueueDuelLogicToQueueName[arg11] or DuelLibrary_m.MatchmakingQueues[arg11]
end

function t.GetMaxPlayersPerTeam(_) -- line: 88
    return 16
end

function t.CountTeam(arg13, arg14) -- line: 92
    local v15 = 0

    for _, _ in pairs(arg13:Get("PlayersWaiting")[arg14]) do
        v15 += 1
    end

    return v15
end

function t.IsReady(arg15, arg16) -- line: 102
    local v17 = arg15:IsInQueue(arg16)
    local v18 = v17

    if v18 then
        v18 = arg15:Get("PlayersWaiting")[v17][tostring(arg16.UserId)]
    end

    return v18
end

function t.IsInQueue(arg17, arg18) -- line: 108
    for key_2, val_2 in pairs(arg17:Get("PlayersWaiting")) do
        if val_2[tostring(arg18.UserId)] ~= nil then
            return key_2
        end
    end
end

function t.IsWithin(arg19, arg20, arg21) -- line: 116
    -- upvalues:
    --  [1] Utility_m (copy)

    if not arg21 then
        for index = 1, arg19:Get("NumTeams") do
            if arg19:IsWithin(arg20, index) then
                return index
            end
        end

        return false
    end

    local Important = arg19:Get("Model"):WaitForChild("Important"):WaitForChild("Team" .. arg21)
    local v22 = arg20

    if v22 then
        v22 = arg20.Character

        if v22 then
            v22 = arg20.Character:FindFirstChild("HumanoidRootPart")

            if v22 then
                v22 = arg20.Character.HumanoidRootPart.Position
            end
        end
    end

    local v23 = Important

    if v23 then
        v23 = v22

        if v23 then
            v23 = Utility_m:IsWithinRotatedShape(
                v22,
                Important.CFrame,
                Important.Size,
                Important.Shape
            )
        end
    end

    return v23
end

function t._Init(_) -- line: 137
end

return t
