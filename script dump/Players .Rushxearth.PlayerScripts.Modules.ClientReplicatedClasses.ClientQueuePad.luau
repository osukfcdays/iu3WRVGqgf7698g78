local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local BaseQueuePad_m = require(ReplicatedStorage.Modules.ReplicatedClass.BaseQueuePad)
local Signal_m = require(ReplicatedStorage.Modules.Signal)
local FighterController_m = require(Players.LocalPlayer.PlayerScripts.Controllers.FighterController)
local QueuePadTerminal_m = require(script:WaitForChild("QueuePadTerminal"))
local QueuePadVisuals_m = require(script:WaitForChild("QueuePadVisuals"))
local t = {
    "Model",
    "CanSelfQueue",
    "NumTeams",
    "PlayersPerTeam",
    "InfinitePlayersPerTeam",
    "QueueName",
    "IsStarting",
    "IsLocked",
    "PlayersWaiting"
}
local t_1 = setmetatable({}, BaseQueuePad_m)
t_1.__index = t_1

function t_1.new(arg1) -- line: 16
    -- upvalues:
    --  [1] BaseQueuePad_m (copy)
    --  [2] t_1 (copy)
    --  [3] Signal_m (copy)
    --  [4] QueuePadVisuals_m (copy)
    --  [5] QueuePadTerminal_m (copy)

    local t_2 = setmetatable(BaseQueuePad_m.new(arg1), t_1)
    t_2.Activity = Signal_m.new()
    t_2.LocalPlayerActivity = Signal_m.new()
    t_2.Visuals = QueuePadVisuals_m.new(t_2)
    t_2.Terminal = QueuePadTerminal_m.new(t_2)
    t_2._was_local_player_here = nil
    t_2:_Init()

    return t_2
end

function t_1.GetClientFightersWaiting(arg2) -- line: 36
    -- upvalues:
    --  [1] FighterController_m (copy)

    local t_3 = {}

    for key, val in pairs(arg2:Get("PlayersWaiting")) do
        local t_4 = {}

        for key_1, _ in pairs(val) do
            local v6 = FighterController_m:GetFighter((tonumber(key_1)))

            if v6 then
                table.insert(t_4, v6)
            end
        end

        t_3[key] = t_4
    end

    return t_3
end

function t_1.GetTeleportPosition(arg3) -- line: 56
    local t_5 = {}

    for index = 1, arg3:Get("NumTeams") do
        local Important = arg3:Get("Model"):WaitForChild("Important")
        table.insert(
            t_5,
            { Important:WaitForChild("Team" .. index).Position, (arg3:CountTeam(index)) }
        )
    end

    table.sort(t_5, function(arg4, arg5) -- line: 66
        return arg4[2] < arg5[2]
    end)

    return t_5[1][1]
end

function t_1.Destroy(arg6) -- line: 73
    -- upvalues:
    --  [1] BaseQueuePad_m (copy)

    arg6.Activity:Destroy()
    arg6.LocalPlayerActivity:Destroy()
    arg6.Visuals:Destroy()
    arg6.Terminal:Destroy()
    BaseQueuePad_m.Destroy(arg6)
end

function t_1._DetectLocalPlayerActivity(arg7) -- line: 85
    -- upvalues:
    --  [1] Players (copy)
    --  [2] t (copy)

    local _ = function(arg8) --[[ update ]] -- line: 86
        -- upvalues:
        --  [1] arg7 (copy)
        --  [2] Players (ref)

        arg7.Activity:Fire(arg8)
        local v9 = if arg7:IsInQueue(Players.LocalPlayer) == nil then false else true

        if v9 or arg7._was_local_player_here then
            arg7.LocalPlayerActivity:Fire(arg8)
        end

        arg7._was_local_player_here = v9
    end

    for _, val_2 in pairs(t) do
        arg7:GetDataChangedSignal(val_2):Connect(function() -- line: 99
            -- upvalues:
            --  [1] val_2 (copy)
            --  [2] arg7 (copy)
            --  [3] Players (ref)

            local v11 = val_2
            arg7.Activity:Fire(v11)
            local v12 = if arg7:IsInQueue(Players.LocalPlayer) == nil then false else true

            if v12 or arg7._was_local_player_here then
                arg7.LocalPlayerActivity:Fire(v11)
            end

            arg7._was_local_player_here = v12
        end)
    end

    arg7.Activity:Fire(nil)
    local v13 = if arg7:IsInQueue(Players.LocalPlayer) == nil then false else true

    if v13 or arg7._was_local_player_here then
        arg7.LocalPlayerActivity:Fire(nil)
    end

    arg7._was_local_player_here = v13
end

function t_1._Init(arg9) -- line: 107
    arg9:_DetectLocalPlayerActivity()
end

return t_1
