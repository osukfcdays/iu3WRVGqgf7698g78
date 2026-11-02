local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ContentProvider = game:GetService("ContentProvider")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CONSTANTS_m = require(ReplicatedStorage.Modules.CONSTANTS)
local CosmeticLibrary_m = require(ReplicatedStorage.Modules.CosmeticLibrary)
local TestLibrary_m = require(ReplicatedStorage.Modules.TestLibrary)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local Signal_m = require(ReplicatedStorage.Modules.Signal)
local v1

if CONSTANTS_m.IS_CLIENT then
    v1 = require(Players.LocalPlayer.PlayerScripts.Controllers.PlayerDataController)
end

v1 = CONSTANTS_m.IS_CLIENT and require(
    Players.LocalPlayer.PlayerScripts.Controllers.SpectateController
)
local StudioPing = TestLibrary_m:GetTestAttribute("StudioPing")
local ISSTUDIO = CONSTANTS_m.IS_STUDIO
local t = {}
t.__index = t
t._id_counter = 0

function t.new(arg1, arg2, arg3) -- line: 23
    -- upvalues:
    --  [1] CosmeticLibrary_m (copy)
    --  [2] t (copy)
    --  [3] Signal_m (copy)

    assert(
        CosmeticLibrary_m.Cosmetics[arg2] and CosmeticLibrary_m.Cosmetics[arg2].Type == "Emote",
        arg2
    )
    assert(
        if typeof(arg3) == "Instance" then arg3:IsA("Humanoid") else false,
        "Argument 1 invalid, expected a Humanoid"
    )
    local t_1 = setmetatable({}, t)
    t_1.Destroying = Signal_m.new()
    t_1.ObjectID = t_1:_NewObjectID()
    t_1.Name = arg2
    t_1.Info = CosmeticLibrary_m.Cosmetics[arg2]
    t_1.Lifetime = arg1
    t_1._humanoid = arg3
    t_1._destroyed = false
    t_1._destroy_these = {}
    t_1._connections = {}
    t_1._threads = {}
    t_1._animation_tracks = {}
    t_1._serial = nil
    t_1._seed = math.random(1, 1000000)
    t_1._sounds = {}
    t_1._are_sounds_hidden = false
    t_1:_Init()

    return t_1
end

function t.IsDestroyed(arg4) -- line: 56
    return arg4._destroyed
end

function t.CreateSound(
    arg5,
    arg6,
    arg7,
    arg8,
    arg9,
    arg10,
    arg11,
    arg12,
    arg13,
    _,
    arg15
) -- line: 60
    -- upvalues:
    --  [1] Utility_m (copy)

    local v6 = Utility_m:CreateSound(
        arg6,
        arg7,
        arg8,
        if arg5._destroyed or not arg5._humanoid:IsDescendantOf(workspace) or arg5._are_sounds_hidden then nil else arg9 or arg5._humanoid.RootPart,
        arg10,
        arg11,
        arg12,
        arg13,
        arg5:_GetSoundGroup(),
        arg15
    )
    table.insert(arg5._destroy_these, v6)
    arg5._sounds[v6] = v6.Parent

    return v6
end

function t.HideSounds(arg16, arg17) -- line: 70
    if arg17 == arg16._are_sounds_hidden then
        return
    end

    arg16._are_sounds_hidden = arg17

    for key, val in pairs(arg16._sounds) do
        pcall(function() -- line: 79
            -- upvalues:
            --  [1] key (copy)
            --  [2] arg16 (copy)
            --  [3] val (copy)

            local v7 = key
            v7.Parent = if not arg16._are_sounds_hidden then val else nil
        end)
    end
end

function t.Simulate(arg18, arg19) -- line: 85
    -- upvalues:
    --  [1] ISSTUDIO (copy)
    --  [2] StudioPing (copy)

    local BindableEvent = Instance.new("BindableEvent")
    table.insert(arg18._destroy_these, BindableEvent)
    local v9 = 0
    task.spawn(function() -- line: 91
        -- upvalues:
        --  [1] arg18 (copy)
        --  [2] arg19 (copy)
        --  [3] ISSTUDIO (ref)
        --  [4] v9 (ref)
        --  [5] BindableEvent (copy)

        local Success, Result = pcall(arg18.PlayServer, arg18, true)

        if not Success and arg19 then
            arg19(Result)
        end

        if not Success and ISSTUDIO then
            error(Result)
        end

        v9 += 1
        BindableEvent:Fire()
    end)
    task.spawn(function() -- line: 106
        -- upvalues:
        --  [1] StudioPing (ref)
        --  [2] arg18 (copy)
        --  [3] arg19 (copy)
        --  [4] ISSTUDIO (ref)
        --  [5] v9 (ref)
        --  [6] BindableEvent (copy)

        if StudioPing and StudioPing > 0 then
            wait(StudioPing / 1000)
        end

        local Success_1, Result_1 = pcall(arg18.PlayClient, arg18, true)

        if not Success_1 and arg19 then
            arg19(Result_1)
        end

        if not Success_1 and ISSTUDIO then
            error(Result_1)
        end

        v9 += 1
        BindableEvent:Fire()
    end)

    while true do
        if not (v9 < 2) then
            break
        end

        BindableEvent.Event:Wait()
    end
end

function t.PlayServer(arg20, _) -- line: 130
    if arg20.Lifetime then
        task.delay(arg20.Lifetime, arg20.Destroy, arg20)
    end
end

function t.PlayClient(_, _) -- line: 136
end

function t.SetSerial(arg24, arg25) -- line: 140
    arg24._serial = arg25
    arg24._seed = arg25.Seed
    arg24.ObjectID = arg25.ObjectID
end

function t.Serialize(arg26) -- line: 146
    return { ObjectID = arg26.ObjectID, Name = arg26.Name, Seed = arg26._seed }
end

function t.Destroy(arg27) -- line: 156
    if arg27._destroyed then
        return
    end

    arg27._destroyed = true
    arg27.Destroying:Fire()
    task.defer(arg27.Destroying.Destroy, arg27.Destroying)

    for _, val_1 in pairs(arg27._connections) do
        val_1:Disconnect()
    end

    for _, val_2 in pairs(arg27._destroy_these) do
        val_2:Destroy()
    end

    for _, val_3 in pairs(arg27._threads) do
        pcall(task.cancel, val_3)
    end

    for _, val_4 in pairs(arg27._animation_tracks) do
        val_4:Stop()
        val_4:Destroy()
    end
end

function t._GetSoundGroup(arg28) -- line: 188
    -- upvalues:
    --  [1] Players (copy)
    --  [2] v1 (copy)

    local v10 = arg28:_IsWorkspaceEmote()

    if v10 then
        v10 = arg28._humanoid.Parent

        if v10 then
            v10 = Players:GetPlayerFromCharacter(arg28._humanoid.Parent)
        end
    end

    local v11 = v1 and v1.CurrentSubject and v1.CurrentSubject.Player

    return if not v10 then "Emote" else if v10 == v11 then "Emote" else "EmoteFromOthers"
end

function t._IsWorkspaceEmote(arg29) -- line: 195
    local v12 = arg29._humanoid

    while v12 do
        if v12:IsA("WorldModel") then
            return false
        end

        if v12 == workspace then
            return true
        end

        v12 = v12.Parent
    end

    return false
end

function t._CanPlayAnimation(arg30) -- line: 211
    -- upvalues:
    --  [1] Players (copy)

    local v13 = arg30._humanoid.Parent

    if v13 then
        v13 = Players:GetPlayerFromCharacter(arg30._humanoid.Parent)
    end

    return not v13 or v13 == Players.LocalPlayer
end

function t._NewObjectID(_) -- line: 217
    -- upvalues:
    --  [1] t (copy)

    local v15 = t
    v15._id_counter += 1

    return utf8.char(t._id_counter - 1)
end

function t._GetGroundPosition(_, arg33, arg34) -- line: 222
    -- upvalues:
    --  [1] Utility_m (copy)

    return Utility_m:Raycast(
        arg33,
        arg33 + Vector3.new(0, -100, 0),
        100,
        arg34,
        Enum.RaycastFilterType.Exclude
    ).Position
end

function t._SetupProp(arg35, arg36) -- line: 226
    local function get_motor6d(arg37) -- line: 227
        -- upvalues:
        --  [1] arg36 (copy)

        for _, child in pairs(arg36:GetChildren()) do
            if child.Name == arg37 and child:IsA("Motor6D") then
                return child
            end
        end
    end

    local t_3 = {}

    for _, child_1 in pairs(arg36:GetChildren()) do
        if child_1:IsA("BasePart") then
            local v19 = child_1:Clone()
            table.insert(arg35._destroy_these, v19)
            local v20 = get_motor6d(v19.Name):Clone()
            table.insert(arg35._destroy_these, v20)
            v20.Part1 = v19
            v20.Part0 = arg35._humanoid.RootPart
            v20.Parent = arg35._humanoid.RootPart

            local _ = function(arg38) --[[ format ]] -- line: 252
                if not arg38:IsA("BasePart") then
                    return
                end

                arg38.CanCollide = false
                arg38.CanTouch = false
                arg38.CanQuery = false
                arg38.Massless = true
            end

            for _, val_5 in pairs(v19:GetDescendants()) do
                if val_5:IsA("BasePart") then
                    val_5.CanCollide = false
                    val_5.CanTouch = false
                    val_5.CanQuery = false
                    val_5.Massless = true
                end
            end

            if v19:IsA("BasePart") then
                v19.CanCollide = false
                v19.CanTouch = false
                v19.CanQuery = false
                v19.Massless = true
            end

            v19:PivotTo(arg35._humanoid.RootPart.CFrame)
            v19.Parent = arg35._humanoid.Parent

            for _, val_6 in pairs(v19:GetDescendants()) do
                if val_6:IsA("ParticleEmitter") then
                    val_6:SetAttribute("IgnoreVisibilityCheck", true)
                end
            end

            table.insert(t_3, v19)
        end
    end

    return table.unpack(t_3)
end

function t._SetupMultipleProps(arg39, ...) -- line: 284
    local t_5 = {}

    for _, val_7 in pairs({ arg39:_SetupProp(...) }) do
        assert(not t_5[val_7.Name], val_7.Name)
        t_5[val_7.Name] = val_7
    end

    return t_5
end

function t._PlayAnimation(
    arg40,
    arg41,
    arg42,
    arg43,
    arg44,
    arg45
) -- line: 296
    -- upvalues:
    --  [1] ContentProvider (copy)
    --  [2] RunService (copy)

    if not arg40:_CanPlayAnimation() then
        return
    end

    local v23 = arg44 or 1
    arg40:_InternalThread(task.spawn, function() -- line: 303
        -- upvalues:
        --  [1] arg41 (copy)
        --  [2] arg40 (copy)
        --  [3] arg42 (copy)
        --  [4] ContentProvider (ref)
        --  [5] v23 (copy)
        --  [6] arg43 (copy)
        --  [7] arg45 (copy)
        --  [8] RunService (ref)

        local Animation_1 = Instance.new("Animation")
        Animation_1.AnimationId = arg41
        table.insert(arg40._destroy_these, Animation_1)

        if arg42 then
            task.spawn(pcall, ContentProvider.PreloadAsync, ContentProvider, { Animation_1 })
            local Animation = Instance.new("Animation")
            Animation.AnimationId = arg42
            table.insert(arg40._destroy_these, Animation)
            local Success_2, Result_2 = pcall(
                arg40._humanoid.LoadAnimation,
                arg40._humanoid,
                Animation
            )

            if Success_2 then
                table.insert(arg40._animation_tracks, Result_2)
                Result_2:Play()
                Result_2:AdjustSpeed(v23)
            end

            wait(arg43 - 0.04)

            if arg40._destroyed then
                return
            end
        end

        local Success_3, Result_3 = pcall(
            arg40._humanoid.LoadAnimation,
            arg40._humanoid,
            Animation_1
        )

        if Success_3 then
            table.insert(arg40._animation_tracks, Result_3)
            Result_3:Play(if arg42 then 0 else 0.1)
            Result_3:AdjustSpeed(v23)

            if arg45 then
                while true do
                    Result_3:AdjustSpeed(
                        v23 * (if not arg40:_IsWorkspaceEmote() or arg40._humanoid:GetAttribute(
                            "SimulateMoving"
                        ) then 1 else (arg40._humanoid.RootPart.Velocity * Vector3.new(1, 0, 1)).Magnitude / arg45)
                    )
                    RunService.Heartbeat:Wait()
                end
            end
        end
    end)
end

function t._InternalThread(arg46, arg47, ...) -- line: 351
    -- upvalues:
    --  [1] ISSTUDIO (copy)

    local v27 = nil

    if ISSTUDIO then
        v27 = arg47(...)
    else
        pcall(function(...) -- line: 357
            -- upvalues:
            --  [1] v27 (ref)
            --  [2] arg47 (copy)

            v27 = arg47(...)
        end, ...)
    end

    table.insert(arg46._threads, v27)

    return v27
end

function t._Init(arg48) -- line: 367
    table.insert(arg48._connections, arg48._humanoid.Destroying:Connect(function() -- line: 368
        -- upvalues:
        --  [1] arg48 (copy)

        arg48:Destroy()
    end))
end

return t
