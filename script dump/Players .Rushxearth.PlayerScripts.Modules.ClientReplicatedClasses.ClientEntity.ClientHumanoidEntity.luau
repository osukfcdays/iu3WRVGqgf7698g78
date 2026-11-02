local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local CONSTANTS_m = require(ReplicatedStorage.Modules.CONSTANTS)
local Signal_m = require(ReplicatedStorage.Modules.Signal)
local PreloadController_m = require(Players.LocalPlayer.PlayerScripts.Controllers.PreloadController)
local ClientEntity_m = require(
    Players.LocalPlayer.PlayerScripts.Modules.ClientReplicatedClasses.ClientEntity
)
local Emotes = ReplicatedStorage.Modules.Emotes
local Attachment = Players.LocalPlayer.PlayerScripts.Assets.Misc.HeadshotParticles.Attachment
local t = setmetatable({}, ClientEntity_m)
t.__index = t

function t.new(arg1) -- line: 16
    -- upvalues:
    --  [1] ClientEntity_m (copy)
    --  [2] t (copy)
    --  [3] Signal_m (copy)
    --  [4] Attachment (copy)

    local t_1 = setmetatable(ClientEntity_m.new(arg1), t)
    t_1.EmoteStatusChanged = Signal_m.new()
    t_1.Humanoid = arg1.Humanoid
    t_1._headshot_particles = Attachment:Clone()
    t_1._animation_cleanup = {}
    t_1._current_emote = nil
    t_1:_Init()

    return t_1
end

function t.IsEmoting(arg2) -- line: 36
    return arg2._current_emote ~= nil
end

function t.IsHumanoidStateAirborne(arg3, arg4) -- line: 40
    -- upvalues:
    --  [1] CONSTANTS_m (copy)

    local v3 = arg4
    local AIRBORNEHUMANOIDSTATES = CONSTANTS_m.AIRBORNE_HUMANOID_STATES

    if not v3 then
        v3 = arg3.Humanoid:GetState()
    end

    return AIRBORNEHUMANOIDSTATES[v3]
end

function t.GetCurrentEmote(arg5) -- line: 44
    return arg5._current_emote
end

function t.GetHealth(arg6) -- line: 48
    return arg6.Humanoid and arg6.Humanoid.Health or 0
end

function t.GetMaxHealth(arg7) -- line: 52
    return arg7.Humanoid and arg7.Humanoid.MaxHealth or 100
end

function t.CancelEmote(arg8, arg9) -- line: 56
    local CurrentEmote = arg8._current_emote

    if not CurrentEmote or arg9 and arg8._current_emote.ObjectID ~= arg9 then
        return
    end

    CurrentEmote:Destroy()
    arg8._current_emote = nil
    arg8.EmoteStatusChanged:Fire()
end

function t.PlayEmote(arg10, arg11) -- line: 72
    -- upvalues:
    --  [1] Emotes (copy)

    arg10:CancelEmote()

    if not arg10:IsAlive() then
        return
    end

    local v6 = require(Emotes[arg11.Name]).new(arg10.Humanoid)
    v6:SetSerial(arg11)
    arg10._current_emote = v6
    arg10.EmoteStatusChanged:Fire()
    v6:PlayClient()
end

function t.ReplicateFromServer(arg12, arg13, ...) -- line: 89
    -- upvalues:
    --  [1] ClientEntity_m (copy)

    if arg13 == "PlayAnimation" then
        if not arg12:IsRendered() then
            return
        end

        arg12:_PlayAnimation(...)

        return
    elseif arg13 == "EmotePlayed" then
        if not arg12:IsRendered() then
            return
        end

        arg12:PlayEmote(...)

        return
    else
        if arg13 == "EmoteStopped" then
            arg12:CancelEmote(...)

            return
        end

        ClientEntity_m.ReplicateFromServer(arg12, arg13, ...)

        return
    end
end

function t.Destroy(arg14) -- line: 109
    -- upvalues:
    --  [1] ClientEntity_m (copy)

    for _, val in pairs(arg14._animation_cleanup) do
        val:Destroy()
    end

    arg14._animation_cleanup = {}
    arg14.EmoteStatusChanged:Destroy()
    arg14:CancelEmote()
    ClientEntity_m.Destroy(arg14)
end

function t._PlayAnimation(arg15, arg16, ...) -- line: 125
    -- upvalues:
    --  [1] PreloadController_m (copy)

    local v7 = PreloadController_m:GetPreloadedAnimation(arg16) or arg15:_CreateAnimation(
        PreloadController_m:GetPreloadedAnimationID(arg16) or arg16
    )
    local animationTrack = arg15.Humanoid:LoadAnimation(v7)
    table.insert(arg15._animation_cleanup, animationTrack)
    animationTrack:Play(...)

    return animationTrack
end

function t._CreateAnimation(arg17, arg18) -- line: 135
    assert(
        if typeof(arg18) ~= "string" then false else true,
        "Argument 1 invalid, expected a string"
    )
    local Animation = Instance.new("Animation")
    Animation.AnimationId = arg18
    table.insert(arg17._animation_cleanup, Animation)

    return Animation
end

function t._Setup(arg19) -- line: 145
    local v9 = arg19.Model
    local HeadshotParticles = arg19._headshot_particles

    if v9 then
        v9 = arg19.Model:FindFirstChild("Head")
    end

    HeadshotParticles.Parent = v9

    if arg19.Humanoid then
        arg19.Humanoid:GetPropertyChangedSignal("MaxHealth"):Connect(function() -- line: 149
            -- upvalues:
            --  [1] arg19 (copy)

            arg19.HealthChanged:Fire()
        end)
        arg19.Humanoid:GetPropertyChangedSignal("Health"):Connect(function() -- line: 153
            -- upvalues:
            --  [1] arg19 (copy)

            arg19.HealthChanged:Fire()
        end)
    end
end

function t._Init(arg20) -- line: 159
    arg20:_Setup()
end

return t
