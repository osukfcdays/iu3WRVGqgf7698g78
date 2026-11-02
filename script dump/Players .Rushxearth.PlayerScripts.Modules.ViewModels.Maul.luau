local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local BetterDebris_m = require(ReplicatedStorage.Modules.BetterDebris)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local ClientViewModel_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("ClientReplicatedClasses"):WaitForChild(
        "ClientFighter"
    ):WaitForChild("ClientItem"):WaitForChild("ClientViewModel")
)
local MaulSlamParticles = Players.LocalPlayer.PlayerScripts.Assets.Misc.MaulSlamParticles
local t = setmetatable({}, ClientViewModel_m)
t.__index = t

function t.new(...) -- line: 13
    -- upvalues:
    --  [1] ClientViewModel_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(ClientViewModel_m.new(...), t)
    t_1:_Init()

    return t_1
end

function t.SlamSoundEffect(_, arg2, _) -- line: 25
    -- upvalues:
    --  [1] Utility_m (copy)

    Utility_m:CreateSound(
        "rbxassetid://72483809453170",
        1 + 0.25 * math.random(),
        0.9 + 0.2 * math.random(),
        arg2,
        true,
        10
    )
    Utility_m:CreateSound(
        "rbxassetid://129922197154277",
        1 + 0.25 * math.random(),
        0.9 + 0.2 * math.random(),
        arg2,
        true,
        10
    )
end

function t.SlamEffect(_, arg5, arg6) -- line: 30
    -- upvalues:
    --  [1] MaulSlamParticles (copy)
    --  [2] BetterDebris_m (copy)
    --  [3] Utility_m (copy)

    local v9 = MaulSlamParticles:Clone()
    v9.CFrame = CFrame.new(arg5) + Vector3.new(0, 0.1, 0)
    v9.Parent = workspace
    BetterDebris_m:AddItem(v9, 10)
    Utility_m:ScaleParticleEmitter(v9, arg6 / 32)
    Utility_m:PlayParticles(v9)
end

function t._Init(_) -- line: 43
end

return t
