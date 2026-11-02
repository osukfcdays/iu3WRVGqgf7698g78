local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local CONSTANTS_m = require(ReplicatedStorage.Modules.CONSTANTS)
local Signal_m = require(ReplicatedStorage.Modules.Signal)
local DuelController_m = require(Players.LocalPlayer.PlayerScripts.Controllers.DuelController)
local t = {}
t.__index = t

function t._new() -- line: 13
    -- upvalues:
    --  [1] t (copy)
    --  [2] Signal_m (copy)

    local t_1 = setmetatable({}, t)
    t_1.PartyChanged = Signal_m.new()
    t_1.InviteRequestCooldownChanged = Signal_m.new()
    t_1.CurrentParty = nil
    t_1._invite_cooldowns = {}
    t_1:_Init()

    return t_1
end

function t.IsPartyLeader(arg1) -- line: 32
    -- upvalues:
    --  [1] Players (copy)

    return not arg1.CurrentParty or arg1.CurrentParty[1] == Players.LocalPlayer
end

function t.IsInParty(arg2, arg3) -- line: 36
    return arg2.CurrentParty and table.find(arg2.CurrentParty, arg3)
end

function t.IsInviteRequestOnCooldown(arg4, arg5) -- line: 40
    return tick() < (arg4._invite_cooldowns[arg5] or 0)
end

function t.CanInvitePlayerToParty(arg6, arg7) -- line: 44
    -- upvalues:
    --  [1] Players (copy)
    --  [2] CONSTANTS_m (copy)
    --  [3] DuelController_m (copy)

    local v4 = arg7

    if v4 then
        if arg7 == Players.LocalPlayer then
            v4 = CONSTANTS_m.IS_STUDIO

            if v4 then
                v4 = arg6:IsPartyLeader()

                if v4 then
                    v4 = not arg6:IsInParty(arg7)

                    if v4 then
                        v4 = not DuelController_m:GetDuel(arg7)
                    end
                end
            end
        else
            v4 = arg6:IsPartyLeader()

            if v4 then
                v4 = not arg6:IsInParty(arg7)

                if v4 then
                    v4 = not DuelController_m:GetDuel(arg7)
                end
            end
        end
    end

    return v4
end

function t.SendPartyInvite(arg8, arg9) -- line: 52
    -- upvalues:
    --  [1] ReplicatedStorage (copy)

    if not arg8:CanInvitePlayerToParty(arg9) or arg8:IsInviteRequestOnCooldown(arg9) then
        return
    end

    arg8._invite_cooldowns[arg9] = tick() + 15
    arg8.InviteRequestCooldownChanged:Fire()
    task.delay(15, arg8.InviteRequestCooldownChanged.Fire, arg8.InviteRequestCooldownChanged)
    ReplicatedStorage.Remotes.Matchmaking.SendPartyInvite:FireServer(arg9)
end

function t._FetchParty(_) -- line: 68
    -- upvalues:
    --  [1] ReplicatedStorage (copy)

    ReplicatedStorage.Remotes.Matchmaking.RequestOneTimePartyReplication:FireServer()
end

function t._Init(arg11) -- line: 72
    -- upvalues:
    --  [1] ReplicatedStorage (copy)

    ReplicatedStorage.Remotes.Matchmaking.UpdateParty.OnClientEvent:Connect(function(arguments) -- line: 73
        -- upvalues:
        --  [1] arg11 (copy)

        arg11.CurrentParty = arguments
        arg11.PartyChanged:Fire()
    end)
    task.defer(arg11._FetchParty, arg11)
end

return t._new()
