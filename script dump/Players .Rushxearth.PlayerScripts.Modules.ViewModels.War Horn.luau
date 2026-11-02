local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local AnimationLibrary_m = require(ReplicatedStorage.Modules.AnimationLibrary)
local ClientViewModel_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("ClientReplicatedClasses"):WaitForChild(
        "ClientFighter"
    ):WaitForChild("ClientItem"):WaitForChild("ClientViewModel")
)
local WarHornEffects = Players.LocalPlayer.PlayerScripts.Assets.Misc.WarHornEffects
local t = setmetatable({}, ClientViewModel_m)
t.__index = t

function t.new(...) -- line: 12
    -- upvalues:
    --  [1] ClientViewModel_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(ClientViewModel_m.new(...), t)
    t_1._horn_particles = {}
    t_1._horn_particles_active = 0
    t_1._use_effect_attachment = t_1.Model:FindFirstChild("_warhorn_use", true)
    t_1:_Init()

    return t_1
end

function t.PlayHornEffect(arg1) -- line: 28
    -- upvalues:
    --  [1] AnimationLibrary_m (copy)

    arg1:_IncrementParticlesActive(1)
    task.delay(
        AnimationLibrary_m.Info[arg1.Info.Animations.Use].ActionTimestamp,
        arg1._IncrementParticlesActive,
        arg1,
        -1
    )
end

function t._IncrementParticlesActive(arg2, arg3) -- line: 37
    arg2._horn_particles_active += arg3

    for _, val in pairs(arg2._horn_particles) do
        local v3 = arg2._horn_particles_active > 0
        val.Enabled = v3
    end
end

function t._Setup(arg4) -- line: 45
    -- upvalues:
    --  [1] WarHornEffects (copy)

    local v4 = pairs
    local v5 = WarHornEffects:FindFirstChild(arg4.Name) or WarHornEffects.Default

    for _, child in v4(v5.Attachment:GetChildren()) do
        local v6 = child:Clone()
        v6.Parent = arg4._use_effect_attachment
        table.insert(arg4._horn_particles, v6)
    end
end

function t._Init(arg5) -- line: 53
    arg5:_Setup()
end

return t
