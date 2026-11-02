local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local BetterDebris_m = require(ReplicatedStorage.Modules.BetterDebris)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local ClientViewModel_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("ClientReplicatedClasses"):WaitForChild(
        "ClientFighter"
    ):WaitForChild("ClientItem"):WaitForChild("ClientViewModel")
)
local FlamethrowerAirblasts = Players.LocalPlayer.PlayerScripts.Assets.Misc:WaitForChild(
    "FlamethrowerAirblasts"
)
local FlamethrowerFlames = Players.LocalPlayer.PlayerScripts.Assets.Misc:WaitForChild(
    "FlamethrowerFlames"
)
local t = setmetatable({}, ClientViewModel_m)
t.__index = t

function t.new(...) -- line: 14
    -- upvalues:
    --  [1] ClientViewModel_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(ClientViewModel_m.new(...), t)
    t_1._flame_particles = {}
    t_1._flame_particles_hash = 0
    t_1._flame_sounds = nil
    t_1._flame_particles_enabled_count = 0
    t_1._flame_particles_enabled = false
    t_1:_Init()

    return t_1
end

function t.SetFlameParticlesEnabled(arg1, arg2) -- line: 32
    -- upvalues:
    --  [1] Utility_m (copy)

    local v3 = arg1._flame_particles_enabled_count
    arg1._flame_particles_enabled_count = v3 + (if arg2 then 1 else -1)
    v3 = arg1._flame_particles_enabled_count > 0 and true

    if v3 == arg1._flame_particles_enabled then
        return
    end

    arg1._flame_particles_enabled = v3
    arg1._flame_particles_hash += 1
    v3 = arg1._flame_particles_hash

    for _, val in pairs(arg1._flame_particles) do
        if val:IsA("ParticleEmitter") then
            val.Enabled = arg1._flame_particles_enabled
        elseif val:IsA("Light") then
            if arg1._flame_particles_enabled then
                val.Brightness = 10
            else
                task.spawn(
                    Utility_m.RenderstepForLoop,
                    Utility_m,
                    0,
                    100,
                    10,
                    function(arg3) -- line: 52
                        -- upvalues:
                        --  [1] v3 (copy)
                        --  [2] arg1 (copy)
                        --  [3] val (copy)

                        if v3 ~= arg1._flame_particles_hash then
                            return true
                        end

                        val.Brightness = 20 * (1 - arg3 / 100)
                    end
                )
            end
        end
    end

    if arg1._flame_particles_enabled then
        arg1:PlayFlameSoundEffect()

        return
    end

    arg1:StopFlameSoundEffect()
end

function t.PlayFlameSoundEffect(arg4, _) -- line: 70
    arg4:StopFlameSoundEffect(false)
    arg4._flame_sounds = arg4._flame_sounds or arg4:_CreateFlameSoundEffects()

    for _, val_1 in pairs(arg4._flame_sounds) do
        val_1.Looped = true
    end
end

function t.StopFlameSoundEffect(arg6, _) -- line: 80
    -- upvalues:
    --  [1] Utility_m (copy)

    local v6 = arg6._flame_sounds

    if v6 then
        v6 = Utility_m:CloneTable(arg6._flame_sounds)
    end

    arg6._flame_sounds = nil

    if not v6 or #v6 == 0 then
        return
    end

    local t_2 = {}

    for _, val_2 in pairs(v6) do
        t_2[val_2] = val_2.Volume
    end

    task.spawn(
        Utility_m.RenderstepForLoop,
        Utility_m,
        0,
        100,
        4,
        function(arg8) -- line: 95
            -- upvalues:
            --  [1] v6 (copy)
            --  [2] t_2 (copy)

            for _, val_3 in pairs(v6) do
                val_3.Volume = t_2[val_3] * (1 - arg8 / 100)
            end
        end
    )
end

function t.PlayAirblastSoundEffect(arg9) -- line: 102
    arg9:CreateSound(
        "rbxassetid://17209245422",
        1,
        1,
        true,
        5
    )
end

function t.AirblastEffect(arg10) -- line: 106
    -- upvalues:
    --  [1] FlamethrowerAirblasts (copy)
    --  [2] BetterDebris_m (copy)
    --  [3] Utility_m (copy)

    local t_3 = {}
    local v7 = pairs
    local v8 = FlamethrowerAirblasts:FindFirstChild(arg10.Name) or FlamethrowerAirblasts.Default

    for _, child in v7(v8.Attachment:GetChildren()) do
        local v9 = child:Clone()
        v9.Parent = arg10._muzzle_attachments[1]
        BetterDebris_m:AddItem(v9, 5)
        table.insert(t_3, v9)
    end

    Utility_m:PlayParticles(t_3)
    arg10:PlayAirblastSoundEffect()
end

function t._CreateFlameSoundEffects(arg11) -- line: 124
    return { arg11:CreateSound("rbxassetid://17209245734", 1.5, 1, true) }
end

function t._Setup(arg12) -- line: 128
    -- upvalues:
    --  [1] FlamethrowerFlames (copy)

    local v10 = pairs
    local v11 = FlamethrowerFlames:FindFirstChild(arg12.Name) or FlamethrowerFlames.Default

    for _, child_1 in v10(v11.Attachment:GetChildren()) do
        local v12 = child_1:Clone()
        v12.Parent = arg12._muzzle_attachments[1]
        table.insert(arg12._flame_particles, v12)
    end
end

function t._Init(arg13) -- line: 136
    arg13:_Setup()
end

return t
