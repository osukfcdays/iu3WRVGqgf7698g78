local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Signal_m = require(ReplicatedStorage.Modules.Signal)
local UserInterfaceController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.UserInterfaceController
)
local PlayerDataController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.PlayerDataController
)
local SpectateController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.SpectateController
)
local FighterController_m = require(Players.LocalPlayer.PlayerScripts.Controllers.FighterController)
local CameraController_m = require(Players.LocalPlayer.PlayerScripts.Controllers.CameraController)
local EmoteRenderLogic_m = require(script:WaitForChild("EmoteRenderLogic"))
local EmoteSoundLogic_m = require(script:WaitForChild("EmoteSoundLogic"))
local t = {}
t.__index = t

function t._new() -- line: 18
    -- upvalues:
    --  [1] t (copy)
    --  [2] Signal_m (copy)
    --  [3] EmoteRenderLogic_m (copy)
    --  [4] EmoteSoundLogic_m (copy)

    local t_1 = setmetatable({}, t)
    t_1.CanEmoteChanged = Signal_m.new()
    t_1.EmoteRenderLogic = EmoteRenderLogic_m.new(t_1)
    t_1.EmoteSoundLogic = EmoteSoundLogic_m.new(t_1)
    t_1._emoting_cooldown = 0
    t_1._equipping_items_cooldown = 0
    t_1:_Init()

    return t_1
end

function t.IsEquippingItemsDisabled(arg1) -- line: 38
    return tick() < arg1._equipping_items_cooldown
end

function t.CanEmote(arg2, arg3) -- line: 42
    -- upvalues:
    --  [1] UserInterfaceController_m (copy)
    --  [2] FighterController_m (copy)
    --  [3] Players (copy)
    --  [4] CameraController_m (copy)
    --  [5] SpectateController_m (copy)
    --  [6] PlayerDataController_m (copy)

    if
        UserInterfaceController_m:IsEquipmentOpen()
        or (if arg3 then tick() < arg2._emoting_cooldown else UserInterfaceController_m:IsPageOpen() or tick() < arg2._emoting_cooldown)
    then
        return false
    end

    local v4 = FighterController_m:GetFighter(Players.LocalPlayer)
    local v5 = v4

    if v5 then
        v5 = v4:Get("IsSpectating")
    end

    local v6 = if CameraController_m:GetPublicState() == CameraController_m.CameraState.States.CustomFreecam then not SpectateController_m.CurrentDuelSubject or SpectateController_m.CurrentDuelSubject.LocalDueler else false

    if not v5 and not v6 then
        return false
    end

    local v8 = v4.IsLocalPlayer

    if v8 then
        v8 = v4:IsAlive()

        if v8 then
            v8 = not v4.Entity:Get("IsFrozen")

            if v8 then
                v8 = if next(PlayerDataController_m:Get("EquippedEmotes")) == nil then false else true
            end
        end
    end

    return v8
end

function t.UseEmote(arg4, arg5) -- line: 58
    -- upvalues:
    --  [1] PlayerDataController_m (copy)

    local v9 = PlayerDataController_m:Get("EquippedEmotes")[arg5]

    if not v9 then
        return
    end

    arg4:UseEmoteByName(v9.Name)
end

function t.UseEmoteByName(arg6, arg7) -- line: 68
    -- upvalues:
    --  [1] ReplicatedStorage (copy)

    arg6._equipping_items_cooldown = tick() + 0.5
    ReplicatedStorage.Remotes.Replication.Fighter.UseEmoteByName:FireServer(arg7)
end

function t.EquipEmote(_, arg9, arg10) -- line: 73
    -- upvalues:
    --  [1] ReplicatedStorage (copy)

    ReplicatedStorage.Remotes.Data.EquipEmote:FireServer(arg9, arg10)
end

function t._FighterAdded(arg11, arg12) -- line: 81
    if not arg12.IsLocalPlayer then
        return
    end

    local function changed() -- line: 86
        -- upvalues:
        --  [1] arg11 (copy)

        arg11.CanEmoteChanged:Fire()
    end

    arg12:GetDataChangedSignal("IsSpectating"):Connect(changed)
    arg12.HealthChanged:Connect(changed)
    arg11.CanEmoteChanged:Fire()

    local function entity_added(arg13) -- line: 94
        -- upvalues:
        --  [1] changed (copy)
        --  [2] arg11 (copy)

        arg13:GetDataChangedSignal("IsFrozen"):Connect(changed)
        arg11.CanEmoteChanged:Fire()
    end

    arg12.EntityAdded:Connect(entity_added)

    if arg12.Entity then
        task.spawn(entity_added, arg12.Entity)
    end

    arg12.EquippedItemChanged:Connect(function() -- line: 105
        -- upvalues:
        --  [1] arg11 (copy)
        --  [2] changed (copy)

        arg11._emoting_cooldown = tick() + 0.5
        arg11.CanEmoteChanged:Fire()
        task.delay(0.5, changed)
    end)
end

function t._Init(arg14) -- line: 112
    -- upvalues:
    --  [1] PlayerDataController_m (copy)
    --  [2] CameraController_m (copy)
    --  [3] SpectateController_m (copy)
    --  [4] UserInterfaceController_m (copy)
    --  [5] FighterController_m (copy)

    PlayerDataController_m:GetDataChangedSignal("EquippedEmotes"):Connect(function() -- line: 113
        -- upvalues:
        --  [1] arg14 (copy)

        arg14.CanEmoteChanged:Fire()
    end)
    CameraController_m.StateChanged:Connect(function() -- line: 117
        -- upvalues:
        --  [1] arg14 (copy)

        arg14.CanEmoteChanged:Fire()
    end)
    SpectateController_m.DuelSubjectChanged:Connect(function() -- line: 121
        -- upvalues:
        --  [1] arg14 (copy)

        arg14.CanEmoteChanged:Fire()
    end)
    UserInterfaceController_m.PageSystemPagesActivity:Connect(function() -- line: 125
        -- upvalues:
        --  [1] arg14 (copy)

        arg14.CanEmoteChanged:Fire()
    end)
    UserInterfaceController_m.EquipmentOpened:Connect(function() -- line: 129
        -- upvalues:
        --  [1] arg14 (copy)

        arg14.CanEmoteChanged:Fire()
    end)
    FighterController_m.ObjectAdded:Connect(function(arg15) -- line: 133
        -- upvalues:
        --  [1] arg14 (copy)

        arg14:_FighterAdded(arg15)
    end)

    for _, val in pairs(FighterController_m.Objects) do
        task.spawn(arg14._FighterAdded, arg14, val)
    end
end

return t._new()
