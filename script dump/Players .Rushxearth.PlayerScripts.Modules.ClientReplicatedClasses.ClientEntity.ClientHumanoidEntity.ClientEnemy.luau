local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local BetterDebris_m = require(ReplicatedStorage.Modules.BetterDebris)
local _ = require(ReplicatedStorage.Modules.SoundLibrary)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local ClientHumanoidEntity_m = require(
    Players.LocalPlayer.PlayerScripts.Modules.ClientReplicatedClasses.ClientEntity.ClientHumanoidEntity
)
local Particles = Players.LocalPlayer.PlayerScripts.Assets.Misc:WaitForChild("ZombieSpawnEffect"):WaitForChild(
    "Particles"
)
local t = setmetatable({}, ClientHumanoidEntity_m)
t.__index = t

function t.new(...) -- line: 16
    -- upvalues:
    --  [1] ClientHumanoidEntity_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(ClientHumanoidEntity_m.new(...), t)
    t_1._run_track = nil
    t_1._idle_track = nil
    t_1._death_animation_override = false
    t_1._death_sound_override = false
    t_1:_Init()

    return t_1
end

function t.ReplicateFromServer(arg1, arg2, ...) -- line: 33
    -- upvalues:
    --  [1] Particles (copy)
    --  [2] BetterDebris_m (copy)
    --  [3] Utility_m (copy)
    --  [4] ClientHumanoidEntity_m (copy)

    if arg2 == "ZombieSpawn" then
        arg1:_PlayAnimation("ZombieSpawn")
        arg1:_CreateSound(
            "rbxassetid://109012456164853",
            0.5 + 1 * math.random(),
            0.875 + 0.25 * math.random()
        )
        local v4 = Particles:Clone()
        v4.Parent = arg1.Model:FindFirstChild("Head") or arg1.Model:FindFirstChild("UpperTorso") or arg1.RootPart
        BetterDebris_m:AddItem(v4, 10)
        Utility_m:PlayParticles(v4)
        wait(0.5)
        v4.LockedToPart = false

        return
    end

    ClientHumanoidEntity_m.ReplicateFromServer(arg1, arg2, ...)
end

function t._DelayedVisibility(arg3) -- line: 55
    local t_2 = {}

    for _, descendant in pairs(arg3.Model:GetDescendants()) do
        if descendant:IsA("BasePart") or descendant:IsA("Decal") or descendant:IsA("Texture") then
            table.insert(t_2, descendant)
        end
    end

    for _, val in pairs(t_2) do
        val.LocalTransparencyModifier = 1
    end

    wait(0.2)

    for _, val_1 in pairs(t_2) do
        val_1.LocalTransparencyModifier = 0
    end
end

function t._LoadAnimation(arg4, arg5) -- line: 75
    if arg5 then
        return (arg4.Humanoid:LoadAnimation(arg4:_CreateAnimation(arg5)))
    end

    return nil
end

function t._VerifyIdleTrack(arg6) -- line: 79
    if arg6._idle_track then
        arg6._idle_track:Stop(0)
        arg6._idle_track:Destroy()
        arg6._idle_track = nil
    end

    if not arg6:IsAlive() then
        return
    end

    arg6._idle_track = arg6:_LoadAnimation(arg6:Get("IdleAnimation"))

    if not arg6._idle_track then
        return
    end

    arg6._idle_track:Play()
end

function t._VerifyRunTrack(arg7) -- line: 99
    if arg7._run_track then
        arg7._run_track:Stop(0)
        arg7._run_track:Destroy()
        arg7._run_track = nil
    end

    if not arg7:IsAlive() then
        return
    end

    arg7._run_track = arg7:_LoadAnimation(arg7:Get("RunAnimation"))

    if not arg7._run_track then
        return
    end

    arg7._run_track:AdjustWeight(0, 0)
end

function t._VerifyTracks(arg8) -- line: 119
    task.spawn(arg8._VerifyRunTrack, arg8)
    task.spawn(arg8._VerifyIdleTrack, arg8)
end

function t._Init(arg9) -- line: 124
    arg9:GetDataChangedSignal("RunAnimation"):Connect(function() -- line: 125
        -- upvalues:
        --  [1] arg9 (copy)

        arg9:_VerifyRunTrack()
    end)
    arg9:GetDataChangedSignal("IdleAnimation"):Connect(function() -- line: 129
        -- upvalues:
        --  [1] arg9 (copy)

        arg9:_VerifyIdleTrack()
    end)
    arg9.Died:Connect(function() -- line: 133
        -- upvalues:
        --  [1] arg9 (copy)

        arg9:_VerifyTracks()

        if not arg9._death_sound_override then
        end

        if not arg9._death_animation_override then
        end
    end)

    if arg9.Humanoid then
        arg9.Humanoid.Running:Connect(function(speed: number) -- line: 157
            -- upvalues:
            --  [1] arg9 (copy)

            if not arg9._run_track or not arg9:IsAlive() then
                return
            end

            if not arg9._run_track.IsPlaying then
                arg9._run_track:Play()
            end

            arg9._run_track:AdjustWeight(if not (speed >= 0.5) then 0 else 1)
            arg9._run_track:AdjustSpeed(speed * 1.25 / 16 / (arg9.RootPart.Size.Y / 2))
        end)
    end

    arg9:_VerifyTracks()
    task.defer(arg9._DelayedVisibility, arg9)
end

return t
