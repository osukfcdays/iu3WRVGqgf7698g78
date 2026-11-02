local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local _ = game:GetService("RunService")
local Players = game:GetService("Players")
local _ = require(ReplicatedStorage.Modules.CONSTANTS)
local EnumLibrary_m = require(ReplicatedStorage.Modules.EnumLibrary)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local _ = require(Players.LocalPlayer.PlayerScripts.Controllers.PlayerDataController)
local ControlsController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.ControlsController
)
local CameraController_m = require(Players.LocalPlayer.PlayerScripts.Controllers.CameraController)
local ReplicatedController_m = require(
    Players.LocalPlayer.PlayerScripts.Modules.ReplicatedController
)
local DefaultCharacter = Players.LocalPlayer.PlayerScripts.Assets:WaitForChild("Misc"):WaitForChild(
    "DefaultCharacter"
)
local t = setmetatable({}, ReplicatedController_m)
t.__index = t

function t._new() -- line: 20
    -- upvalues:
    --  [1] ReplicatedController_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(ReplicatedController_m.new("Fighter"), t)
    t_1.LocalFighter = nil
    t_1._network_id_map = {}
    t_1._last_connection_level = nil
    t_1._player_to_fighter = {}
    t_1._model_to_fighter = {}
    t_1._last_controls_replicated_time = 0
    t_1._character_model_cache = {}
    t_1:_Init()

    return t_1
end

function t.GetFighter(arg1, arg2) -- line: 42
    -- upvalues:
    --  [1] Players (copy)

    local v2 = arg1._player_to_fighter[arg2] or arg1._model_to_fighter[arg2]

    if v2 then
        return v2
    end

    if not arg2 then
        return
    end

    if typeof(arg2) == "Instance" then
        if arg2:IsA("Player") then
            for key, val in pairs(arg1.Objects) do
                if val.Player == arg2 then
                    return val, key
                end
            end

            return nil
        end

        return arg1:GetFighter(Players:GetPlayerFromCharacter(arg2))
    else
        if typeof(arg2) == "number" then
            return arg1:GetFighter(Players:GetPlayerByUserId(arg2))
        end

        local str = tostring(arg2)
        local v3 = typeof(arg2) == "Instance" and arg2.ClassName or typeof(arg2)
        assert(
            false,
            "Argument 1 invalid, expected a Player or a Model or nil, got " .. str .. " (type: " .. v3 .. ")"
        )

        return
    end
end

function t.GetFighterFromNetworkID(arg3, arg4) -- line: 72
    return arg3._network_id_map[arg4]
end

function t.GetFightersNotInDuel(arg5) -- line: 76
    local t_2 = {}

    for _, val_1 in pairs(arg5.Objects) do
        if not val_1:Get("IsInDuel") then
            table.insert(t_2, val_1)
        end
    end

    return t_2
end

function t.GetEntities(arg6) -- line: 88
    local t_3 = {}

    for _, val_2 in pairs(arg6.Objects) do
        if val_2.Entity then
            table.insert(t_3, val_2.Entity)
        end
    end

    return t_3
end

function t.GetFighterModels(arg7, arg8) -- line: 102
    local t_4 = {}

    for _, val_3 in pairs(arg7.Objects) do
        if val_3.Entity and (not arg8 or not val_3.IsLocalPlayer) then
            table.insert(t_4, val_3.Entity.Model)
        end
    end

    return t_4
end

function t.GetWrap(arg9, arg10) -- line: 116
    for _, val_4 in pairs(arg9.Objects) do
        local v4 = val_4:GetItem(arg10)

        if v4 then
            return v4:GetWrap()
        end
    end
end

function t.WaitForFighter(arg11, ...) -- line: 127
    while true do
        local v5 = arg11:GetFighter(...)

        if v5 then
            return v5
        end

        arg11.ObjectAdded:Wait()
    end
end

function t.WaitForLocalFighter(arg12) -- line: 139
    -- upvalues:
    --  [1] Players (copy)

    return arg12:WaitForFighter(Players.LocalPlayer)
end

function t.GenerateCharacterModel(arg13, arg14, arg15) -- line: 143
    -- upvalues:
    --  [1] Players (copy)
    --  [2] DefaultCharacter (copy)

    if arg13._character_model_cache[tostring(arg14)] then
        return arg13._character_model_cache[tostring(arg14)]
    end

    local function generate() -- line: 148
        -- upvalues:
        --  [1] Players (ref)
        --  [2] arg14 (copy)
        --  [3] arg13 (copy)

        local Success, Result = pcall(Players.GetHumanoidDescriptionFromUserIdAsync, Players, arg14)

        if not Success then
            warn("Failed to fetch humanoid description:", Result)

            return
        end

        Result.Torso = 15365012259
        Result.LeftArm = 15365010034
        Result.RightArm = 15365012263
        Result.LeftLeg = 15365010038
        Result.RightLeg = 15365010030
        local Success_1, Result_1 = pcall(
            Players.CreateHumanoidModelFromDescriptionAsync,
            Players,
            Result,
            Enum.HumanoidRigType.R15
        )

        if not Success_1 then
            warn("Failed to create humanoid model:", Result_1)

            return
        end

        arg13._preloaded_character_model = Result_1
        local t_5 = { Template = Result_1 }
        arg13._character_model_cache[tostring(arg14)] = t_5

        return t_5
    end

    if arg15 then
        return generate()
    end

    task.spawn(generate)

    return arg13._character_model_cache[tostring(arg14)] or { Template = DefaultCharacter }
end

function t._VerifyEntityLoop(arg16) -- line: 197
    -- upvalues:
    --  [1] Players (copy)
    --  [2] ReplicatedStorage (copy)

    local function is_inaccurate() -- line: 198
        -- upvalues:
        --  [1] arg16 (copy)
        --  [2] Players (ref)

        local v7 = not arg16.LocalFighter:Get("IsInDuel")

        if v7 then
            v7 = not arg16.LocalFighter:Get("IsInShootingRange")

            if v7 then
                v7 = Players.LocalPlayer.Character and (not arg16.LocalFighter.Entity or arg16.LocalFighter.Entity.Model ~= Players.LocalPlayer.Character)
            end
        end

        return v7
    end

    while true do
        if not wait(1) then
            break
        end

        if not is_inaccurate() then
            continue
        end

        wait(2)

        if not is_inaccurate() then
            continue
        end

        ReplicatedStorage.Remotes.Replication.Fighter.VerifyClientEntity:FireServer()
        wait(10)
    end
end

function t._ConnectionLevelReplicationLoop(arg17) -- line: 214
    -- upvalues:
    --  [1] Utility_m (copy)
    --  [2] ReplicatedStorage (copy)

    while true do
        wait(1)

        if arg17.LocalFighter and arg17.LocalFighter:Get("IsInDuel") then
            local v9 = Utility_m:GetConnectionLevel((Utility_m:GetLocalConnectionPing()))

            if v9 == arg17._last_connection_level then
                continue
            end

            arg17._last_connection_level = v9
            ReplicatedStorage.Remotes.Replication.Fighter.UpdateConnectionLevel:FireServer(v9)
        end
    end
end

function t._UpdateNetworkIDMap(arg18) -- line: 234
    arg18._network_id_map = {}

    for _, val_5 in pairs(arg18.Objects) do
        local v10 = val_5:Get("DecodedNetworkID")

        if v10 then
            arg18._network_id_map[v10] = val_5
        end
    end
end

function t._FighterAdded(arg19, arg20) -- line: 246
    arg20:GetDataChangedSignal("DecodedNetworkID"):Connect(function() -- line: 247
        -- upvalues:
        --  [1] arg19 (copy)

        arg19:_UpdateNetworkIDMap()
    end)
    arg20.EntityAdded:Connect(function(arg21) -- line: 251
        -- upvalues:
        --  [1] arg19 (copy)
        --  [2] arg20 (copy)

        arg19._model_to_fighter[arg21.Model] = arg20
    end)
    arg20.EntityRemoved:Connect(function(_) -- line: 255
        -- upvalues:
        --  [1] arg19 (copy)
        --  [2] arg20 (copy)

        for key_6, val_6 in pairs(arg19._model_to_fighter) do
            if val_6 == arg20 then
                arg19._model_to_fighter[key_6] = nil
            end
        end
    end)

    if arg20.Entity and arg20.Entity.Model then
        arg19._model_to_fighter[arg20.Entity.Model] = arg20
    end

    arg19._player_to_fighter[arg20.Player] = arg20
    arg19:_UpdateNetworkIDMap()
end

function t._ReplicateControls(arg23) -- line: 271
    -- upvalues:
    --  [1] ControlsController_m (copy)
    --  [2] ReplicatedStorage (copy)

    if not arg23.LocalFighter then
        return
    end

    task.delay(math.max(0.2 - (tick() - arg23._last_controls_replicated_time), 0.2), function() -- line: 279
        -- upvalues:
        --  [1] ControlsController_m (ref)
        --  [2] ReplicatedStorage (ref)

        if typeof(ControlsController_m.CurrentControls) == "string" then
            ReplicatedStorage.Remotes.Replication.Fighter.SetControls:FireServer(
                ControlsController_m.CurrentControls
            )
        end
    end)
end

function t._CameraReplicationLoop(arg24) -- line: 286
    -- upvalues:
    --  [1] ReplicatedStorage (copy)
    --  [2] CameraController_m (copy)
    --  [3] Utility_m (copy)

    local function send(arg25) -- line: 287
        -- upvalues:
        --  [1] ReplicatedStorage (ref)

        if arg25 and not utf8.len(arg25) then
            return
        end

        ReplicatedStorage.Remotes.Replication.Fighter.UpdateCameraRotation:FireServer(arg25, nil)
    end

    local v12 = false
    local v13 = nil

    while true do
        wait(0.1)

        if
            arg24.LocalFighter
            and arg24.LocalFighter:Get("IsSpectating")
            and CameraController_m:GetPublicState()
        then
            local v14 = Utility_m:EncodeCameraRotation(CameraController_m.Rotation)

            if v12 or v14 ~= v13 then
                task.defer(send, v14)
            end

            v13 = v14
            v12 = false
            continue
        end

        if v12 then
            continue
        end

        task.defer(send, Utility_m:EncodeCameraRotation(Vector2.zero))
        v12 = true
    end
end

function t._HookLocalFighter(arg26) -- line: 317
    -- upvalues:
    --  [1] CameraController_m (copy)
    --  [2] ReplicatedStorage (copy)
    --  [3] StarterGui (copy)

    arg26.LocalFighter = arg26:WaitForLocalFighter()

    local function update_third_person_overide() -- line: 320
        -- upvalues:
        --  [1] CameraController_m (ref)
        --  [2] arg26 (copy)

        CameraController_m:SetThirdPersonOverride(arg26.LocalFighter:Get("ThirdPersonOverride"))
    end

    arg26.LocalFighter:GetDataChangedSignal("ThirdPersonOverride"):Connect(
        update_third_person_overide
    )
    task.defer(update_third_person_overide)
    local v16 = 0
    local BindableEvent = Instance.new("BindableEvent")
    BindableEvent.Event:Connect(function() -- line: 330
        -- upvalues:
        --  [1] ReplicatedStorage (ref)

        ReplicatedStorage.Remotes.Replication.Fighter.ResetCharacter:FireServer()
    end)

    local function update_reset_button() -- line: 334
        -- upvalues:
        --  [1] v16 (ref)
        --  [2] StarterGui (ref)
        --  [3] arg26 (copy)
        --  [4] BindableEvent (copy)

        v16 += 1
        local v17 = v16

        while true do
            if v16 ~= v17 then
                break
            end

            local SetCore = StarterGui.SetCore
            local v18 = StarterGui
            local v19 = not arg26.LocalFighter:Get("IsInDuel")

            if v19 then
                v19 = BindableEvent
            end

            local Success_2, Result_2 = pcall(SetCore, v18, "ResetButtonCallback", v19)

            if Success_2 then
                break
            end

            warn("Failed to set reset button callback", Result_2)
            wait(0.1)
        end
    end

    arg26.LocalFighter:GetDataChangedSignal("IsInDuel"):Connect(update_reset_button)
    task.defer(update_reset_button)
    arg26:_ReplicateControls()
    task.defer(arg26._CameraReplicationLoop, arg26)
    task.defer(arg26._ConnectionLevelReplicationLoop, arg26)
    task.defer(arg26._VerifyEntityLoop, arg26)
end

function t._Setup(arg27) -- line: 360
    -- upvalues:
    --  [1] EnumLibrary_m (copy)
    --  [2] Players (copy)

    function arg27._reject_object_added_serial_callback(arg28) -- line: 361
        -- upvalues:
        --  [1] EnumLibrary_m (ref)
        --  [2] Players (ref)

        local v20 = not arg28[EnumLibrary_m:ToEnum("Player")]

        if v20 then
            v20 = not Players:GetPlayerByUserId(arg28[EnumLibrary_m:ToEnum("UserID")])
        end

        return v20
    end
end

function t._Init(arg29) -- line: 366
    -- upvalues:
    --  [1] ControlsController_m (copy)
    --  [2] ReplicatedStorage (copy)
    --  [3] Utility_m (copy)

    arg29.ObjectAdded:Connect(function(arg30) -- line: 367
        -- upvalues:
        --  [1] arg29 (copy)

        arg29:_FighterAdded(arg30)
    end)
    arg29.ObjectRemoved:Connect(function(arg31) -- line: 371
        -- upvalues:
        --  [1] arg29 (copy)

        for key_7, val_7 in pairs(arg29._player_to_fighter) do
            if val_7 == arg31 then
                arg29._model_to_fighter[key_7] = nil
            end
        end

        for key_8, val_8 in pairs(arg29._model_to_fighter) do
            if val_8 == arg31 then
                arg29._model_to_fighter[key_8] = nil
            end
        end
    end)
    ControlsController_m.ControlsChanged:Connect(function() -- line: 385
        -- upvalues:
        --  [1] arg29 (copy)

        arg29:_ReplicateControls()
    end)
    ReplicatedStorage.Remotes.Replication.Fighter.UpdateCameraRotations.OnClientEvent:Connect(function(
        arguments
    ) -- line: 389
        -- upvalues:
        --  [1] Utility_m (ref)
        --  [2] arg29 (copy)

        for _, val_9 in pairs((Utility_m:DecodeCameraRotationBulk(arguments))) do
            local v23, v24, v25 = table.unpack(val_9)
            local v27 = arg29:GetFighterFromNetworkID(v23)

            if v27 then
                v27:SetReplicate("CameraRotation", Utility_m:FromXYToCameraRotation(v24, v25))
            end
        end
    end)

    for _, val_10 in pairs(arg29.Objects) do
        task.spawn(arg29._FighterAdded, arg29, val_10)
    end

    arg29:_Setup()
    task.defer(arg29._HookLocalFighter, arg29)
end

return t._new()
