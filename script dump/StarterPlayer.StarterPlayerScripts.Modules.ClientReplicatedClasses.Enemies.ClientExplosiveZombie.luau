local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local BetterDebris_m = require(ReplicatedStorage.Modules.BetterDebris)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local ClientEnemy_m = require(
    Players.LocalPlayer.PlayerScripts.Modules.ClientReplicatedClasses.ClientEntity.ClientHumanoidEntity.ClientEnemy
)
local ExplosiveZombieExplosionEffect = Players.LocalPlayer.PlayerScripts.Assets.Misc:WaitForChild(
    "ExplosiveZombieExplosionEffect"
)
local t = setmetatable({}, ClientEnemy_m)
t.__index = t

function t.new(...) -- line: 13
    -- upvalues:
    --  [1] ClientEnemy_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(ClientEnemy_m.new(...), t)
    t_1:_Init()

    return t_1
end

function t.ReplicateFromServer(arg1, arg2, ...) -- line: 25
    -- upvalues:
    --  [1] ExplosiveZombieExplosionEffect (copy)
    --  [2] BetterDebris_m (copy)
    --  [3] Utility_m (copy)
    --  [4] ClientEnemy_m (copy)

    if arg2 == "ZombieExplosionEffect" then
        if not arg1:IsRendered() then
            return
        end

        local v2, v3 = ...
        local v4 = ExplosiveZombieExplosionEffect:Clone()
        v4.CFrame = CFrame.new(v2)
        v4.Parent = arg1.Model
        BetterDebris_m:AddItem(v4, 10)
        Utility_m:CreateSound(
            "rbxassetid://13455969017",
            0.5,
            0.75,
            v4,
            true,
            10
        )
        Utility_m:CreateSound(
            "rbxassetid://103343386215625",
            1,
            0.95 + 0.1 * math.random(),
            v4,
            true,
            10
        )

        for _, val in pairs(v4:GetDescendants()) do
            if val:IsA("ParticleEmitter") then
                Utility_m:ScaleParticleEmitter(val, v3 / 3)
            end
        end

        Utility_m:PlayParticles(v4)

        return
    else
        ClientEnemy_m.ReplicateFromServer(arg1, arg2, ...)

        return
    end
end

function t._Init(_) -- line: 57
end

return t
