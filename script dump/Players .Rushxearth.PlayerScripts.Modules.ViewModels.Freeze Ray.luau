local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local BetterDebris_m = require(ReplicatedStorage.Modules.BetterDebris)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local ClientViewModel_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("ClientReplicatedClasses"):WaitForChild(
        "ClientFighter"
    ):WaitForChild("ClientItem"):WaitForChild("ClientViewModel")
)
local FreezeRayExplosionEffect = Players.LocalPlayer.PlayerScripts.Assets.Misc:WaitForChild(
    "FreezeRayExplosionEffect"
)
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

function t.ExplosionEffect(_, arg2, arg3) -- line: 25
    -- upvalues:
    --  [1] FreezeRayExplosionEffect (copy)
    --  [2] BetterDebris_m (copy)
    --  [3] Utility_m (copy)

    local v3 = FreezeRayExplosionEffect:Clone()
    v3.CFrame = CFrame.new(arg2)
    v3.Parent = workspace
    BetterDebris_m:AddItem(v3, 5)
    Utility_m:CreateSound(
        "rbxassetid://18429092842",
        0.4,
        1 + 0.2 * math.random(),
        v3,
        true,
        10
    )

    for _, child in pairs(v3.Attachment:GetChildren()) do
        if child:IsA("ParticleEmitter") then
            Utility_m:ScaleParticleEmitter(child, arg3 / 4)
        end
    end

    Utility_m:PlayParticles(v3.Attachment)
end

function t._Init(_) -- line: 46
end

return t
