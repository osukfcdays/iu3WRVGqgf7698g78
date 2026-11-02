local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local CONSTANTS_m = require(ReplicatedStorage.Modules.CONSTANTS)
local ReplicatedClass_m = require(ReplicatedStorage.Modules.ReplicatedClass)
local SeasonLibrary_m = require(ReplicatedStorage.Modules.SeasonLibrary)
local Signal_m = require(ReplicatedStorage.Modules.Signal)
local SpectateController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.SpectateController
)
local FighterController_m = require(Players.LocalPlayer.PlayerScripts.Controllers.FighterController)
local Pages_m = require(Players.LocalPlayer.PlayerScripts.Modules.UserInterface.Pages)
local DuelInterface_m = require(script:WaitForChild("DuelInterface"))
local BeginnerDuel_m = require(script:WaitForChild("BeginnerDuel"))
local ChickenGame_m = require(script:WaitForChild("ChickenGame"))
local ClientMap_m = require(script:WaitForChild("ClientMap"))
local Maps = Players.LocalPlayer.PlayerScripts.Modules.Maps
local t = setmetatable({}, ReplicatedClass_m)
t.__index = t

function t.new(arg1) -- line: 22
    -- upvalues:
    --  [1] ReplicatedClass_m (copy)
    --  [2] t (copy)
    --  [3] Signal_m (copy)
    --  [4] DuelInterface_m (copy)
    --  [5] SeasonLibrary_m (copy)
    --  [6] ChickenGame_m (copy)
    --  [7] BeginnerDuel_m (copy)

    local t_1 = setmetatable(ReplicatedClass_m.new(arg1), t)
    t_1.DuelerAdded = Signal_m.new()
    t_1.DuelerRemoved = Signal_m.new()
    t_1.MapAdded = Signal_m.new()
    t_1.SpectateThisPlayer = Signal_m.new()
    t_1.Duelers = {}
    t_1.Map = nil
    t_1.DuelInterface = DuelInterface_m.new(t_1)
    t_1.LocalDueler = nil
    t_1.IsRanked = SeasonLibrary_m:IsRankedQueue(t_1:Get("QueueName"))
    t_1.ChickenGame = ChickenGame_m.new(t_1)
    t_1.BeginnerDuel = BeginnerDuel_m.new(t_1)
    t_1.Data.IsSpectating = false
    t_1.Data.LastRoundStartingStatus = nil
    t_1.Data.DuelMusic = nil
    t_1._temp_serial = arg1
    t_1._connections = {}
    t_1._client_fighters = {}
    t_1._duelers_by_player = {}
    t_1:_Init()

    return t_1
end

function t.IsRendered(arg2) -- line: 56
    -- upvalues:
    --  [1] CONSTANTS_m (copy)
    --  [2] SpectateController_m (copy)

    return CONSTANTS_m.SHOULD_ALWAYS_REPLICATE() or arg2.LocalDueler or arg2 == SpectateController_m.CurrentDuelSubject
end

function t.CanLeave(arg3) -- line: 60
    -- upvalues:
    --  [1] Pages_m (copy)

    if Pages_m.PageSystem.CurrentPage then
        return false
    end

    local v8 = arg3:Get("IsCurrentArcadeDuel")

    if not v8 then
        v8 = arg3:Get("RoundNum") > 1 and arg3:Get("Status") == "RoundFinished" and not arg3:Get(
            "CanTrackStatistics"
        ) or arg3:Get("WasSelfQueued")
    end

    return v8
end

function t.GetDueler(arg4, arg5) -- line: 72
    if arg4._duelers_by_player[arg5] then
        return arg4._duelers_by_player[arg5]
    end

    for key, val in pairs(arg4.Duelers) do
        if val.Player == arg5 or val:Get("ObjectID") == arg5 then
            return val, key
        end
    end
end

function t.GetFighters(arg6) -- line: 84
    return table.clone(arg6._client_fighters)
end

function t.CountTeam(arg7, arg8) -- line: 88
    local v9 = 0

    for _, val_1 in pairs(arg7.Duelers) do
        v9 += if val_1:Get("TeamID") == arg8 then 1 else 0
    end

    return v9
end

function t.LeaveDuelRequest(arg9) -- line: 98
    -- upvalues:
    --  [1] Pages_m (copy)

    if arg9:CanLeave() then
        Pages_m.PageSystem:OpenPage("LeaveDuel", true)
    end
end

function t.ReplicateFromServer(arg10, arg11, ...) -- line: 104
    -- upvalues:
    --  [1] ReplicatedClass_m (copy)

    if arg11 == "DuelerAdded" then
        arg10:_DuelerAdded(...)

        return
    end

    if arg11 == "DuelerRemoved" then
        arg10:_DuelerRemoved(...)

        return
    end

    if arg11 == "DuelerChanged" then
        arg10:_DuelerChanged(...)

        return
    end

    if arg11 == "MapAdded" then
        arg10:_MapAdded(...)

        return
    end

    local v11

    if arg11 == "MapChanged" then
        v11 = ...

        if arg10.Map then
            arg10.Map:ReplicateFromServer(arg10:FromEnum(v11) or v11, select(2, ...))

            return
        end
    else
        local v12

        if arg11 == "RoundStarting" then
            if not arg10:IsRendered() then
                return
            end

            v11, v12 = ...
            local v13 = arg10:FromEnum(v12)
            arg10:SetReplicate("LastRoundStartingStatus", v13)

            if v13 == "MatchPoint" then
                arg10.DuelInterface.MatchPoint:Play(false)
            elseif v13 == "SuddenDeath" then
                arg10.DuelInterface.MatchPoint:Play(true)
            end

            arg10.DuelInterface.Timer:Set(v11)

            return
        elseif arg11 == "RoundStart" then
            if not arg10:IsRendered() then
                return
            end

            arg10.DuelInterface.Timer:Set(...)

            return
        elseif arg11 == "RoundFinish" then
            if not arg10:IsRendered() then
                return
            end

            v11, v12 = ...
            arg10.DuelInterface.Timer:Pause(v12)
            arg10.DuelInterface.RoundResult:Play(v11)

            return
        elseif arg11 == "FinalResults" then
            if not arg10:IsRendered() then
                return
            end

            arg10.DuelInterface.FinalResults:Play(...)

            return
        elseif arg11 == "Countdown" then
            if not arg10:IsRendered() then
                return
            end

            arg10.DuelInterface.Timer:Set(...)

            return
        elseif arg11 == "ChosenMapEffect" then
            if not arg10:IsRendered() then
                return
            end

            arg10.DuelInterface.Voting:PlayMapChosenEffect(...)

            return
        elseif arg11 == "PauseTimer" then
            if not arg10:IsRendered() then
                return
            end

            arg10.DuelInterface.Timer:Pause(...)

            return
        elseif arg11 == "RespawnNowAnimation" then
            if not arg10:IsRendered() then
                return
            end

            v11, v12 = ...

            if not arg10.LocalDueler or v11 ~= arg10.LocalDueler.Player then
                return
            end

            arg10.DuelInterface.Buttons:RespawnNowAnimation(v12)

            return
        elseif arg11 == "ChickenGamesRedLight" then
            if not arg10:IsRendered() then
                return
            end

            arg10.ChickenGame:RedLight(...)

            return
        elseif arg11 == "ChickenGamesGreenLight" then
            if not arg10:IsRendered() then
                return
            end

            arg10.ChickenGame:GreenLight(...)

            return
        elseif arg11 == "ChickenGamesElimination" then
            if not arg10:IsRendered() then
                return
            end

            arg10.ChickenGame:Elimination(...)

            return
        elseif arg11 == "ChickenGamesStop" then
            if not arg10:IsRendered() then
                return
            end

            arg10.ChickenGame:Stop(...)

            return
        elseif arg11 == "TimerStopwatchStarted" then
            if not arg10:IsRendered() then
                return
            end

            arg10.DuelInterface.Timer:StopwatchStart(...)

            return
        elseif arg11 == "TimerStopwatchFinished" then
            if not arg10:IsRendered() then
                return
            end

            arg10.DuelInterface.Timer:StopwatchFinish(...)

            return
        elseif arg11 == "SpectateThisPlayer" then
            if not arg10:IsRendered() then
                return
            end

            v11, v12 = ...

            if not v11 or not v12 then
                return
            end

            arg10.SpectateThisPlayer:Fire(v11, v12)

            return
        else
            ReplicatedClass_m.ReplicateFromServer(arg10, arg11, ...)
        end
    end
end

function t.Destroy(arg12) -- line: 241
    -- upvalues:
    --  [1] ReplicatedClass_m (copy)

    for _, val_2 in pairs(arg12._connections) do
        val_2:Disconnect()
    end

    for _, val_3 in pairs(arg12.Duelers) do
        val_3:Destroy()
    end

    arg12._client_fighters = {}
    arg12._duelers_by_player = {}

    if arg12.Map then
        arg12.Map:Destroy()
    end

    arg12.DuelInterface:Destroy()
    arg12.ChickenGame:Destroy()
    arg12.BeginnerDuel:Destroy()
    arg12.DuelerAdded:Destroy()
    arg12.DuelerRemoved:Destroy()
    arg12.MapAdded:Destroy()
    arg12.SpectateThisPlayer:Destroy()
    ReplicatedClass_m.Destroy(arg12)
end

function t._UpdateAllies(arg13) -- line: 273
    -- upvalues:
    --  [1] Players (copy)

    local v14 = arg13:GetDueler(Players.LocalPlayer)
    local v15 = v14

    if v15 then
        v15 = v14:Get("TeamID")
    end

    for _, val_4 in pairs(arg13.Duelers) do
        local v16 = v15

        if v16 then
            v16 = if val_4 ~= v14 then if v15 ~= val_4:Get("TeamID") then false else true else false
        end

        val_4:SetAlly(v16)
    end
end

function t._DuelerChanged(arg14, arg15, arg16, ...) -- line: 282
    local v17 = arg14:GetDueler(arg15)

    if not v17 then
        return
    end

    v17:ReplicateFromServer(arg14:FromEnum(arg16) or arg16, ...)
end

function t._DuelerAdded(arg17, arg18) -- line: 294
    -- upvalues:
    --  [1] FighterController_m (copy)
    --  [2] ReplicatedClass_m (copy)

    if arg17:GetDueler(arg18[arg17:ToEnum("Data")][arg17:ToEnum("ObjectID")]) then
        return
    end

    local v19 = arg18[arg17:ToEnum("ClientReplicatedClassType")]
    local v21 = FighterController_m:WaitForFighter(arg18[arg17:ToEnum("Player")])
    local v23 = ReplicatedClass_m:GetReplicatedClass(arg17:FromEnum(v19) or v19).new(
        arg18,
        v21,
        arg17
    )
    table.insert(arg17.Duelers, v23)
    table.insert(arg17._client_fighters, v21)
    arg17._duelers_by_player[v23.Player] = v23
    arg17.LocalDueler = if v21.IsLocalPlayer then v23 else arg17.LocalDueler
    arg17.DuelerAdded:Fire(v23)
end

function t._DuelerRemoved(arg19, arg20) -- line: 311
    local v25, v26 = arg19:GetDueler(arg20)

    if not v26 then
        return
    end

    if v25 == arg19.LocalDueler then
        arg19.LocalDueler = nil
    end

    if v25.ClientFighter then
        local index = table.find(arg19._client_fighters, v25.ClientFighter)

        if index then
            table.remove(arg19._client_fighters, index)
        end
    end

    table.remove(arg19.Duelers, v26)
    arg19._duelers_by_player[v25.Player] = nil
    arg19.DuelerRemoved:Fire(v25)
    v25:Destroy()
end

function t._MapAdded(arg21, arg22) -- line: 336
    -- upvalues:
    --  [1] Maps (copy)
    --  [2] ClientMap_m (copy)

    local v27 = arg22[arg21:ToEnum("Name")]
    local v28 = Maps:FindFirstChild(v27) and require(Maps[v27]) or ClientMap_m
    arg21.Map = v28.new(arg22, arg21)
    arg21.MapAdded:Fire(arg21.Map)
end

function t._Setup(arg23) -- line: 343
    for _, val_5 in pairs(arg23._temp_serial.Duelers) do
        task.spawn(arg23._DuelerAdded, arg23, val_5)
    end

    if arg23._temp_serial.Map then
        task.spawn(arg23._MapAdded, arg23, arg23._temp_serial.Map)
    end

    arg23._temp_serial = nil
end

function t._Init(arg24) -- line: 355
    arg24.DuelerAdded:Connect(function() -- line: 356
        -- upvalues:
        --  [1] arg24 (copy)

        arg24:_UpdateAllies()
    end)
    arg24:_Setup()
    arg24:_UpdateAllies()
end

return t
