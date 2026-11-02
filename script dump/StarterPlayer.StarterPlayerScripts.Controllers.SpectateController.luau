local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local _ = game:GetService("StarterGui")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CONSTANTS_m = require(ReplicatedStorage.Modules.CONSTANTS)
local InputLibrary_m = require(ReplicatedStorage.Modules.InputLibrary)
local Signal_m = require(ReplicatedStorage.Modules.Signal)
local FighterController_m = require(Players.LocalPlayer.PlayerScripts.Controllers.FighterController)
local CameraController_m = require(Players.LocalPlayer.PlayerScripts.Controllers.CameraController)
local DuelController_m = require(Players.LocalPlayer.PlayerScripts.Controllers.DuelController)
local Teleporting_m = require(Players.LocalPlayer.PlayerScripts.Modules.UserInterface.Teleporting)
local Queue_m = require(Players.LocalPlayer.PlayerScripts.Modules.UserInterface.Queue)
local t = {}
t.__index = t

function t._new() -- line: 22
    -- upvalues:
    --  [1] t (copy)
    --  [2] Signal_m (copy)

    local t_1 = setmetatable({}, t)
    t_1.SubjectChanged = Signal_m.new()
    t_1.SubjectEmoteStatusChanged = Signal_m.new()
    t_1.DuelSubjectChanged = Signal_m.new()
    t_1.DuelSubjectEnvironmentIDChanged = Signal_m.new()
    t_1.DuelSubjectStatusChanged = Signal_m.new()
    t_1.Subjects = {}
    t_1.CurrentSubject = nil
    t_1.CurrentDuelSubject = nil
    t_1._duel_connections = {}
    t_1._subject_connections = {}
    t_1._last_spectating_user_id = nil
    t_1._spectate_duel_request_queue = {}
    t_1._spectate_duel_request_queue_active = false
    t_1._duel_just_spectated = {}
    t_1._firing_subject_changed = nil
    t_1._process_mb2_on_input_ended_delta = nil
    t_1:_Init()

    return t_1
end

function t.IsRendered(arg1, arg2) -- line: 54
    -- upvalues:
    --  [1] CONSTANTS_m (copy)
    --  [2] Players (copy)

    local v1 = CONSTANTS_m.IS_ARCADE_SERVER

    if not v1 then
        v1 = true

        if Players.LocalPlayer:GetAttribute("EnvironmentID") ~= arg2 then
            v1 = arg1.CurrentDuelSubject

            if v1 then
                v1 = if arg1.CurrentDuelSubject:Get("EnvironmentID") ~= arg2 then false else true
            end
        end
    end

    return v1
end

function t.IsSubjectEmoting(arg3) -- line: 58
    local v2 = arg3.CurrentSubject

    if v2 then
        v2 = arg3.CurrentSubject.Entity

        if v2 then
            v2 = arg3.CurrentSubject.Entity:IsEmoting()
        end
    end

    return v2
end

function t.IsThereValidSubject(arg4, arg5) -- line: 62
    for _, val in pairs(arg4.Subjects) do
        if val ~= arg5 and arg4:_IsValidSubject(val) then
            return true
        end
    end

    return false
end

function t.Increment(arg6, arg7) -- line: 72
    if
        not arg6.CurrentDuelSubject
        or arg6.CurrentSubject and arg6.CurrentSubject.IsLocalPlayer
        or not arg6:IsThereValidSubject(arg6.CurrentSubject)
    then
        return
    end

    local v3 = arg6.CurrentSubject and table.find(arg6.Subjects, arg6.CurrentSubject) or 0
    local v4 = if v3 then if v3 then if arg7 ~= 1 then if arg7 ~= -1 then v3 + arg7 else if v3 ~= 1 then v3 + arg7 else #arg6.Subjects else if v3 ~= #arg6.Subjects then if arg7 ~= -1 then v3 + arg7 else if v3 ~= 1 then v3 + arg7 else #arg6.Subjects else 1 else if arg7 ~= -1 then if arg7 ~= 1 then if arg7 ~= -1 then v3 + arg7 else if v3 ~= 1 then v3 + arg7 else #arg6.Subjects else if v3 ~= #arg6.Subjects then if arg7 ~= -1 then v3 + arg7 else if v3 ~= 1 then v3 + arg7 else #arg6.Subjects else 1 else #arg6.Subjects else if arg7 ~= 1 then if v3 then if arg7 ~= 1 then if arg7 ~= -1 then v3 + arg7 else if v3 ~= 1 then v3 + arg7 else #arg6.Subjects else if v3 ~= #arg6.Subjects then if arg7 ~= -1 then v3 + arg7 else if v3 ~= 1 then v3 + arg7 else #arg6.Subjects else 1 else if arg7 ~= -1 then if arg7 ~= 1 then if arg7 ~= -1 then v3 + arg7 else if v3 ~= 1 then v3 + arg7 else #arg6.Subjects else if v3 ~= #arg6.Subjects then if arg7 ~= -1 then v3 + arg7 else if v3 ~= 1 then v3 + arg7 else #arg6.Subjects else 1 else #arg6.Subjects else 1
    arg6:_RawSetCurrentSubject(arg6.Subjects[v4])
    arg6:_VerifySubject(if arg7 ~= -1 then false else true)
end

function t.Next(arg8) -- line: 94
    arg8._duel_just_spectated = {}
    arg8:Increment(1)
end

function t.Last(arg9) -- line: 99
    arg9._duel_just_spectated = {}
    arg9:Increment(-1)
end

function t.Exit(arg10) -- line: 104
    if not arg10.CurrentDuelSubject or arg10.CurrentDuelSubject.LocalDueler then
        return
    end

    arg10:SpectateDuelRequest(nil)
end

function t.SpectateDuelRequest(arg11, arg12) -- line: 113
    -- upvalues:
    --  [1] Queue_m (copy)
    --  [2] DuelController_m (copy)
    --  [3] Players (copy)
    --  [4] ReplicatedStorage (copy)

    if
        arg12
        and not arg12.LocalDueler
        and (Queue_m:IsVisible() or arg12:Get("Status") == "GameOver")
    then
        return
    end

    local t_2 = { DuelController_m:GetDuel(Players.LocalPlayer) or arg12 }
    table.insert(arg11._spectate_duel_request_queue, t_2)
    task.spawn(function() -- line: 125
        -- upvalues:
        --  [1] arg11 (copy)
        --  [2] ReplicatedStorage (ref)

        if arg11._spectate_duel_request_queue_active then
            return
        end

        arg11._spectate_duel_request_queue_active = true

        while true do
            if not (#arg11._spectate_duel_request_queue > 0) then
                break
            end

            local removedValue = table.remove(arg11._spectate_duel_request_queue, 1)
            local v6 = arg11.CurrentDuelSubject and arg11.CurrentDuelSubject:Get("ObjectID") or nil
            local v7 = removedValue[1] and removedValue[1]:Get("ObjectID") or nil

            if v7 == v6 then
                continue
            end

            ReplicatedStorage.Remotes.Replication.Fighter.SpectateDuel:FireServer(v7)
            wait(1)
        end

        arg11._spectate_duel_request_queue = {}
        arg11._spectate_duel_request_queue_active = false
    end)
end

function t.Update(arg13, arg14) -- line: 149
    -- upvalues:
    --  [1] FighterController_m (copy)
    --  [2] CONSTANTS_m (copy)

    local v8 = arg13.CurrentDuelSubject and arg13.CurrentDuelSubject:GetFighters() or FighterController_m:GetFightersNotInDuel()

    if FighterController_m.LocalFighter and not table.find(v8, FighterController_m.LocalFighter) then
        table.insert(v8, FighterController_m.LocalFighter)
    end

    local t_3 = {}

    for _, val_1 in pairs(v8) do
        if not t_3[val_1.Player] then
            t_3[val_1.Player] = true

            if CONSTANTS_m.IS_TESTING_SERVER then
                val_1:Update(arg14)
            else
                local Success, Result = pcall(val_1.Update, val_1, arg14)

                if not Success then
                    warn("ClientFighter::Update errored:", Result)
                end
            end
        end
    end
end

function t._IsValidSubject(arg15, arg16) -- line: 181
    -- upvalues:
    --  [1] CameraController_m (copy)

    if
        CameraController_m:GetPublicState() == CameraController_m.CameraState.States.CustomFreecam
        or not arg16
        or not arg16:IsAlive()
    then
        return false
    end

    if arg15.CurrentDuelSubject and not table.find(arg15.CurrentDuelSubject:GetFighters(), arg16) then
        return false
    end

    if not arg15.CurrentDuelSubject or not arg15.CurrentDuelSubject.LocalDueler then
        return true
    end

    local v11

    if
        arg15.CurrentDuelSubject
        and arg15.CurrentDuelSubject.LocalDueler
        and arg15.CurrentDuelSubject.LocalDueler:IsAlive()
    then
        v11 = arg16 == arg15.CurrentDuelSubject.LocalDueler.ClientFighter

        return v11
    end

    v11 = arg15.CurrentDuelSubject.LocalDueler:Get("TeamID")

    if not v11 or arg15.CurrentDuelSubject:Get("IsCurrentArcadeDuel") then
        return true
    end

    local v12 = false

    for _, val_2 in pairs(arg15.CurrentDuelSubject.Duelers) do
        if val_2:Get("TeamID") == v11 and val_2:IsAlive() then
            v12 = true
            break
        end
    end

    if
        arg15.CurrentDuelSubject:Get("StaggeredSpawns")
        and arg15.CurrentDuelSubject:Get("Status") ~= "RoundFinished"
    then
        v12 = true
    end

    if not v12 then
        return true
    end

    return if arg16:Get("TeamID") ~= v11 then false else true
end

function t._RawSetCurrentSubject(arg17, arg18) -- line: 243
    if arg18 == arg17.CurrentSubject then
        return
    end

    for _, val_3 in pairs(arg17._subject_connections) do
        val_3:Disconnect()
    end

    arg17._subject_connections = {}

    if arg17.CurrentSubject then
        arg17.CurrentSubject:SetReplicate("IsSpectating", false)

        if arg17.CurrentDuelSubject and arg17.CurrentSubject.Player then
            arg17._duel_just_spectated[arg17.CurrentSubject.Player] = tick()
        end
    end

    arg17.CurrentSubject = arg18
    arg17.SubjectChanged:FireDeferred()

    if arg17.CurrentSubject then
        arg17.CurrentSubject:SetReplicate("IsSpectating", true)
    end
end

function t._VerifySubject(arg19, arg20) -- line: 270
    local v14 = if not arg20 then 1 else -1
    local v15 = arg19.CurrentSubject and table.find(arg19.Subjects, arg19.CurrentSubject) or 1
    local v16 = nil

    for index = 1, #arg19.Subjects do
        local v17 = arg19.Subjects[(v15 + (index - 1) * v14 - 1) % #arg19.Subjects + 1]

        if arg19:_IsValidSubject(v17) then
            v16 = v17
            break
        end
    end

    if v16 == arg19.CurrentSubject then
        return
    end

    arg19:_RawSetCurrentSubject(v16)

    if not arg19.CurrentSubject then
        return
    end

    function v16() --[[ verify_subject ]] -- line: 301
        -- upvalues:
        --  [1] arg19 (copy)

        arg19:_VerifySubject()
    end

    table.insert(arg19._subject_connections, arg19.CurrentSubject.EntityRemoved:Connect(v16))
    table.insert(arg19._subject_connections, arg19.CurrentSubject.EntityAdded:Connect(v16))
    table.insert(arg19._subject_connections, arg19.CurrentSubject.Died:Connect(v16))

    local function entity_added(arg21) -- line: 310
        -- upvalues:
        --  [1] arg19 (copy)

        table.insert(arg19._subject_connections, arg21.EmoteStatusChanged:Connect(function() -- line: 311
            -- upvalues:
            --  [1] arg19 (ref)

            arg19.SubjectEmoteStatusChanged:Fire()
        end))
    end

    table.insert(arg19._subject_connections, arg19.CurrentSubject.EntityAdded:Connect(entity_added))

    if arg19.CurrentSubject.Entity then
        table.insert(arg19._subject_connections, arg19.CurrentSubject.Entity.EmoteStatusChanged:Connect(
            function() -- line: 311
                -- upvalues:
                --  [1] arg19 (copy)

                arg19.SubjectEmoteStatusChanged:Fire()
            end
        ))
    end
end

function t._CleanupCurrentDuelSubject(arg22, arg23) -- line: 323
    for _, val_4 in pairs(arg22._duel_connections) do
        val_4:Disconnect()
    end

    arg22._duel_connections = {}
    arg22._duel_just_spectated = {}

    for index_1 = #arg22.Subjects, 1, -1 do
        arg22:_RemoveSubject(arg22.Subjects[index_1], true)
    end

    arg22:_VerifySubject()

    if arg22.CurrentDuelSubject and arg22.CurrentDuelSubject ~= arg23 then
        arg22.CurrentDuelSubject:SetReplicate("IsSpectating", false)

        for _, val_5 in pairs(arg22.CurrentDuelSubject.Duelers) do
            if val_5.ClientFighter then
                val_5.ClientFighter:ClearInterface()
                val_5.ClientFighter:ClearSounds(true)
            end
        end
    end
end

function t._SpectateDuel(arg24, arg25) -- line: 349
    -- upvalues:
    --  [1] DuelController_m (copy)
    --  [2] Players (copy)
    --  [3] CameraController_m (copy)

    local v18 = DuelController_m:GetDuel(Players.LocalPlayer)

    if v18 and arg25 ~= v18 then
        return
    end

    arg24:_CleanupCurrentDuelSubject(arg25)
    arg24.CurrentDuelSubject = arg25
    arg24.DuelSubjectChanged:Fire()

    if not arg24.CurrentDuelSubject then
        return
    end

    arg24.CurrentDuelSubject:SetReplicate("IsSpectating", true)
    table.insert(arg24._duel_connections, arg24.CurrentDuelSubject:GetDataChangedSignal(
        "EnvironmentID"
    ):Connect(function() -- line: 371
        -- upvalues:
        --  [1] arg24 (copy)

        arg24.DuelSubjectEnvironmentIDChanged:Fire()
    end))
    table.insert(arg24._duel_connections, arg24.CurrentDuelSubject:GetDataChangedSignal("Status"):Connect(
        function() -- line: 375
            -- upvalues:
            --  [1] arg24 (copy)

            arg24.DuelSubjectStatusChanged:Fire()
        end
    ))

    local function verify_subject() -- line: 380
        -- upvalues:
        --  [1] arg24 (copy)

        arg24:_VerifySubject()
    end

    table.insert(
        arg24._duel_connections,
        arg24.CurrentDuelSubject:GetDataChangedSignal("IsCurrentArcadeDuel"):Connect(verify_subject)
    )
    table.insert(
        arg24._duel_connections,
        arg24.CurrentDuelSubject:GetDataChangedSignal("Status"):Connect(verify_subject)
    )
    task.defer(verify_subject)

    local function dueler_removed(arg26) -- line: 388
        -- upvalues:
        --  [1] arg24 (copy)

        if arg26.IsLocalPlayer then
            arg24:SpectateDuelRequest(nil)

            return
        end

        arg24:_RemoveSubject(arg26.ClientFighter)
    end

    table.insert(
        arg24._duel_connections,
        arg24.CurrentDuelSubject.DuelerRemoved:Connect(dueler_removed)
    )

    local function dueler_added(arg27, arg28) -- line: 398
        -- upvalues:
        --  [1] CameraController_m (ref)
        --  [2] arg24 (copy)
        --  [3] verify_subject (copy)

        if arg27.IsLocalPlayer then
            CameraController_m.CameraState:SetCustomFreecamEnabled(false)
        end

        table.insert(
            arg24._duel_connections,
            arg27:GetDataChangedSignal("TeamID"):Connect(verify_subject)
        )
        table.insert(arg24._duel_connections, arg27.EntityAdded:Connect(verify_subject))
        table.insert(arg24._duel_connections, arg27.Eliminated:Connect(verify_subject))
        table.insert(arg24._duel_connections, arg27.Died:Connect(verify_subject))
        arg24:_AddSubject(arg27.ClientFighter, arg28)
    end

    table.insert(
        arg24._duel_connections,
        arg24.CurrentDuelSubject.DuelerAdded:Connect(dueler_added)
    )
    local _ = arg24.CurrentDuelSubject.DuelerAdded:Connect(dueler_added)

    for _, val_6 in pairs(arg24.CurrentDuelSubject.Duelers) do
        task.spawn(dueler_added, val_6, true)
    end

    table.insert(arg24._duel_connections, arg24.CurrentDuelSubject.SpectateThisPlayer:Connect(function(
        arg29,
        arg30
    ) -- line: 417
        -- upvalues:
        --  [1] arg24 (copy)

        if tick() > (arg24._duel_just_spectated[arg29] or 0) + 0.3 then
            return
        end

        local v19 = nil

        for _, val_7 in pairs(arg24.Subjects) do
            if val_7.Player == arg30 then
                v19 = val_7
                break
            end
        end

        arg24:_RawSetCurrentSubject(v19)
        arg24:_VerifySubject()
    end))
end

function t._AddSubject(arg31, arg32, arg33) -- line: 436
    if table.find(arg31.Subjects, arg32) then
        return
    end

    table.insert(arg31.Subjects, arg32)

    if not arg33 then
        arg31:_VerifySubject()
    end
end

function t._RemoveSubject(arg34, arg35, arg36) -- line: 449
    if arg35.IsLocalPlayer then
        return
    end

    local index_2 = table.find(arg34.Subjects, arg35)

    if not index_2 then
        return
    end

    if arg35 == arg34.CurrentSubject then
        arg34:Increment(-1)
    end

    table.remove(arg34.Subjects, index_2)

    if not arg36 then
        arg34:_VerifySubject()
    end
end

function t._SpectatingReplicationLoop(arg37) -- line: 473
    -- upvalues:
    --  [1] ReplicatedStorage (copy)

    while true do
        wait(1)
        local v20 = arg37.CurrentSubject

        if v20 then
            v20 = arg37.CurrentSubject.Player.UserId
        end

        if v20 == arg37._last_spectating_user_id then
            continue
        end

        arg37._last_spectating_user_id = v20
        ReplicatedStorage.Remotes.Replication.Fighter.Spectating:FireServer(
            arg37._last_spectating_user_id
        )
    end
end

function t._ProcessInput(arg38, arg39) -- line: 486
    -- upvalues:
    --  [1] CameraController_m (copy)
    --  [2] InputLibrary_m (copy)

    local v22 = if CameraController_m:GetPublicState() ~= CameraController_m.CameraState.States.CustomFreecam then false else true

    if InputLibrary_m:InputIs(arg39, "SpectateNext") and not v22 then
        arg38:Next()

        return
    end

    if InputLibrary_m:InputIs(arg39, "SpectateLast") and not v22 then
        arg38:Last()

        return
    end

    if InputLibrary_m:InputIs(arg39, "SpectateExit") then
        arg38:Exit()
    end
end

function t._HookLocalFighter(arg40) -- line: 498
    -- upvalues:
    --  [1] FighterController_m (copy)
    --  [2] DuelController_m (copy)

    local v23 = FighterController_m:WaitForLocalFighter()

    local function update_duel_subject() -- line: 501
        -- upvalues:
        --  [1] v23 (copy)
        --  [2] DuelController_m (ref)
        --  [3] arg40 (copy)

        local v24 = v23:Get("SpectatingDuelObjectID")
        local v25 = v24 and DuelController_m:GetDuelByID(v24) or nil
        arg40:_SpectateDuel(v25)
    end

    v23:GetDataChangedSignal("SpectatingDuelObjectID"):Connect(update_duel_subject)
    local v26 = v23:Get("SpectatingDuelObjectID")
    local v27 = v26 and DuelController_m:GetDuelByID(v26) or nil
    arg40:_SpectateDuel(v27)
end

function t._Init(arg41) -- line: 512
    -- upvalues:
    --  [1] CameraController_m (copy)
    --  [2] RunService (copy)
    --  [3] UserInputService (copy)
    --  [4] FighterController_m (copy)
    --  [5] DuelController_m (copy)
    --  [6] Teleporting_m (copy)
    --  [7] Queue_m (copy)

    arg41.SubjectChanged:Connect(function() -- line: 513
        -- upvalues:
        --  [1] arg41 (copy)
        --  [2] CameraController_m (ref)

        arg41.SubjectEmoteStatusChanged:Fire()
        CameraController_m:SetSubject(arg41.CurrentSubject)
    end)
    arg41.DuelSubjectChanged:Connect(function() -- line: 518
        -- upvalues:
        --  [1] arg41 (copy)
        --  [2] CameraController_m (ref)

        arg41:_VerifySubject()
        CameraController_m.CameraState:SetCustomFreecamEnabled(false)
        CameraController_m:SetDuelSubject(arg41.CurrentDuelSubject)
    end)
    RunService:BindToRenderStep("SpectateController", Enum.RenderPriority.Camera.Value + 1, function(
        arg42
    ) -- line: 524
        -- upvalues:
        --  [1] arg41 (copy)

        arg41:Update(arg42)
    end)
    UserInputService.InputBegan:Connect(function(input: InputObject, gameProcessedEvent: boolean) -- line: 528
        -- upvalues:
        --  [1] CameraController_m (ref)
        --  [2] arg41 (copy)

        if gameProcessedEvent then
            return
        end

        if
            CameraController_m:GetPublicState() == CameraController_m.CameraState.States.ThirdPersonUnlockedMouse
            and input.UserInputType == Enum.UserInputType.MouseButton2
        then
            arg41._process_mb2_on_input_ended_delta = 0

            return
        end

        arg41:_ProcessInput(input)
    end)
    UserInputService.InputChanged:Connect(function(arg45, _) -- line: 541
        -- upvalues:
        --  [1] arg41 (copy)

        if
            not arg41._process_mb2_on_input_ended_delta
            or arg45.UserInputType ~= Enum.UserInputType.MouseMovement
        then
            return
        end

        local v30 = arg41
        v30._process_mb2_on_input_ended_delta = v30._process_mb2_on_input_ended_delta + Vector2.new(
            arg45.Delta.X,
            arg45.Delta.Y
        ).Magnitude
    end)
    UserInputService.InputEnded:Connect(function(arg47, _) -- line: 549
        -- upvalues:
        --  [1] arg41 (copy)

        local ProcessMb2OnInputEndedDelta_1 = arg41._process_mb2_on_input_ended_delta

        if not ProcessMb2OnInputEndedDelta_1 or arg47.UserInputType ~= Enum.UserInputType.MouseButton2 then
            return
        end

        arg41._process_mb2_on_input_ended_delta = nil

        if ProcessMb2OnInputEndedDelta_1 > 5 then
            return
        end

        arg41:_ProcessInput(arg47)
    end)
    FighterController_m.ObjectAdded:Connect(function(arg49) -- line: 565
        -- upvalues:
        --  [1] arg41 (copy)

        if not arg49.IsLocalPlayer then
            return
        end

        arg49.EntityAdded:Connect(function() -- line: 570
            -- upvalues:
            --  [1] arg41 (ref)

            arg41:_VerifySubject()
        end)
        arg49.EntityRemoved:Connect(function() -- line: 574
            -- upvalues:
            --  [1] arg41 (ref)

            arg41:_VerifySubject()
        end)
        arg49.Died:Connect(function() -- line: 578
            -- upvalues:
            --  [1] arg41 (ref)

            arg41:_VerifySubject()
        end)
        arg41:_AddSubject(arg49)
    end)
    FighterController_m.ObjectRemoved:Connect(function(arg50) -- line: 585
        -- upvalues:
        --  [1] arg41 (copy)

        arg41:_RemoveSubject(arg50)
    end)
    DuelController_m.LocalPlayerJoinedDuel:Connect(function(arg51, _) -- line: 589
        -- upvalues:
        --  [1] arg41 (copy)

        arg41:SpectateDuelRequest(arg51)
    end)
    DuelController_m.LocalPlayerLeftDuel:Connect(function(_, _) -- line: 593
        -- upvalues:
        --  [1] arg41 (copy)

        arg41:SpectateDuelRequest(nil)
    end)
    DuelController_m.ObjectRemoved:Connect(function(arg55) -- line: 597
        -- upvalues:
        --  [1] arg41 (copy)

        if arg41.CurrentDuelSubject == arg55 then
            arg41:SpectateDuelRequest(nil)
        end
    end)
    CameraController_m.CustomFreecamStateChanged:Connect(function() -- line: 603
        -- upvalues:
        --  [1] arg41 (copy)

        arg41:_VerifySubject()
    end)
    Teleporting_m.EnabledChanged:Connect(function() -- line: 607
        -- upvalues:
        --  [1] Teleporting_m (ref)
        --  [2] arg41 (copy)

        if Teleporting_m.Enabled then
            arg41:SpectateDuelRequest(nil)
        end
    end)
    Queue_m.VisibilityChanged:Connect(function() -- line: 613
        -- upvalues:
        --  [1] Queue_m (ref)
        --  [2] arg41 (copy)

        if Queue_m:IsVisible() then
            arg41:SpectateDuelRequest(nil)
        end
    end)
    arg41:_VerifySubject()
    task.spawn(arg41._HookLocalFighter, arg41)
    task.spawn(arg41._SpectatingReplicationLoop, arg41)
end

return t._new()
