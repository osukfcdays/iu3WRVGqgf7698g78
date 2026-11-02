local _ = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local CONSTANTS_m = require(ReplicatedStorage.Modules.CONSTANTS)
local Signal_m = require(ReplicatedStorage.Modules.Signal)
local MatchmakingController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.MatchmakingController
)
local FighterController_m = require(Players.LocalPlayer.PlayerScripts.Controllers.FighterController)
local DuelController_m = require(Players.LocalPlayer.PlayerScripts.Controllers.DuelController)
local MatchmakingCountdown_m = require(
    Players.LocalPlayer.PlayerScripts.Modules.UserInterface.MatchmakingCountdown
)
local ReplicatedController_m = require(
    Players.LocalPlayer.PlayerScripts.Modules.ReplicatedController
)
local t = setmetatable({}, ReplicatedController_m)
t.__index = t

function t._new() -- line: 18
    -- upvalues:
    --  [1] ReplicatedController_m (copy)
    --  [2] t (copy)
    --  [3] Signal_m (copy)

    local t_1 = setmetatable(ReplicatedController_m.new("QueuePad"), t)
    t_1.LocalPlayerActivity = Signal_m.new()
    t_1.ChallengeRequestCooldownChanged = Signal_m.new()
    t_1._local_fighter = nil
    t_1._update_loop_active = false
    t_1._challenge_cooldowns = {}
    t_1._actively_on_queue_pad = false
    t_1:_Init()

    return t_1
end

function t.IsChallengeRequestOnCooldown(arg1, arg2) -- line: 38
    return tick() < (arg1._challenge_cooldowns[arg2] or 0)
end

function t.GetQueuePad(arg3, arg4) -- line: 42
    for _, val in pairs(arg3.Objects) do
        local v3 = val:IsInQueue(arg4)

        if v3 then
            return val, v3
        end
    end
end

function t.CanChallenge(_, arg6) -- line: 52
    -- upvalues:
    --  [1] Players (copy)
    --  [2] CONSTANTS_m (copy)
    --  [3] DuelController_m (copy)

    local v4 = arg6

    if v4 then
        if arg6 == Players.LocalPlayer then
            v4 = CONSTANTS_m.IS_STUDIO

            if v4 then
                v4 = CONSTANTS_m.QUEUES_ACTIVE

                if v4 then
                    v4 = not DuelController_m:GetDuel(arg6)
                end
            end
        else
            v4 = CONSTANTS_m.QUEUES_ACTIVE

            if v4 then
                v4 = not DuelController_m:GetDuel(arg6)
            end
        end
    end

    return v4
end

function t.SendChallengeRequest(arg7, arg8) -- line: 59
    -- upvalues:
    --  [1] ReplicatedStorage (copy)

    if not arg7:CanChallenge(arg8) or arg7:IsChallengeRequestOnCooldown(arg8) then
        return
    end

    arg7._challenge_cooldowns[arg8] = tick() + 15
    arg7.ChallengeRequestCooldownChanged:Fire()
    task.delay(15, arg7.ChallengeRequestCooldownChanged.Fire, arg7.ChallengeRequestCooldownChanged)
    ReplicatedStorage.Remotes.Misc.SendChallengeRequest:FireServer(arg8)
end

function t._QueueLeave(arg9) -- line: 75
    -- upvalues:
    --  [1] ReplicatedStorage (copy)

    ReplicatedStorage.Remotes.Misc.QueueLeave:InvokeServer()
    arg9._actively_on_queue_pad = false
end

function t._QueueJoin(arg10, arg11, arg12) -- line: 80
    -- upvalues:
    --  [1] ReplicatedStorage (copy)

    arg10._actively_on_queue_pad = true
    ReplicatedStorage.Remotes.Misc.QueueJoin:InvokeServer(arg11:Get("ObjectID"), arg12)
end

function t._CheckQueueStatus(arg13) -- line: 85
    -- upvalues:
    --  [1] Players (copy)
    --  [2] MatchmakingCountdown_m (copy)
    --  [3] MatchmakingController_m (copy)

    local v6 = arg13._local_fighter:IsAlive()

    if v6 then
        v6 = arg13._local_fighter.Player
    end

    local v7, v8 = arg13:GetQueuePad(Players.LocalPlayer)
    local v9 = MatchmakingCountdown_m:IsVisible()

    if v7 then
        if v6 then
            if not arg13._local_fighter:Get("IsInDuel") then
                if not arg13._local_fighter:Get("IsInShootingRange") then
                    if v7:IsWithin(v6, v8) then
                        if v9 then
                            arg13:_QueueLeave()

                            return
                        end
                    else
                        arg13:_QueueLeave()

                        return
                    end
                else
                    arg13:_QueueLeave()

                    return
                end
            else
                arg13:_QueueLeave()

                return
            end
        else
            arg13:_QueueLeave()

            return
        end
    elseif v6 then
        for _, val_1 in pairs(arg13.Objects) do
            local v11 = val_1:IsWithin(v6)

            if v11 then
                if v9 then
                    MatchmakingController_m:TryLeaveQueue()
                else
                    arg13:_QueueJoin(val_1, v11)
                end
            end
        end
    end
end

function t._UpdateLoop(arg14) -- line: 111
    -- upvalues:
    --  [1] CONSTANTS_m (copy)

    if arg14._update_loop_active then
        return
    end

    arg14._update_loop_active = true

    while true do
        wait(0.1)

        if CONSTANTS_m.IS_STUDIO then
            arg14:_CheckQueueStatus()
        else
            local Success, Result = pcall(arg14._CheckQueueStatus, arg14)

            if not Success then
                warn("Failed to check queue status, error:", Result)
            end
        end

        if
            not arg14._actively_on_queue_pad
            and (arg14._local_fighter:Get("IsInDuel") or arg14._local_fighter:Get(
                "IsInShootingRange"
            ))
        then
            arg14:_QueueLeave()
            break
        end
    end

    arg14._update_loop_active = false
end

function t._HookLocalFighter(arg15) -- line: 142
    -- upvalues:
    --  [1] FighterController_m (copy)

    arg15._local_fighter = FighterController_m:WaitForLocalFighter()
    arg15._local_fighter:GetDataChangedSignal("IsInDuel"):Connect(function() -- line: 145
        -- upvalues:
        --  [1] arg15 (copy)

        arg15:_UpdateLoop()
    end)
    arg15._local_fighter:GetDataChangedSignal("IsInShootingRange"):Connect(function() -- line: 149
        -- upvalues:
        --  [1] arg15 (copy)

        arg15:_UpdateLoop()
    end)
    arg15:_UpdateLoop()
end

function t._Init(arg16) -- line: 156
    arg16.ObjectAdded:Connect(function(arg17) -- line: 157
        -- upvalues:
        --  [1] arg16 (copy)

        arg17.LocalPlayerActivity:Connect(function() -- line: 158
            -- upvalues:
            --  [1] arg16 (ref)

            arg16.LocalPlayerActivity:Fire()
        end)
    end)
    task.defer(arg16._HookLocalFighter, arg16)
end

return t._new()
