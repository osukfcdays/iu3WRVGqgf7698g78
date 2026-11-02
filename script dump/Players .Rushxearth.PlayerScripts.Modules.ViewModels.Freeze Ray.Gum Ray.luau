local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local BetterDebris_m = require(ReplicatedStorage.Modules.BetterDebris)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local FreezeRay_m = require(Players.LocalPlayer.PlayerScripts.Modules.ViewModels["Freeze Ray"])
local GumRayExplosionEffect = Players.LocalPlayer.PlayerScripts.Assets.Misc:WaitForChild(
    "GumRayExplosionEffect"
)
local t = setmetatable({}, FreezeRay_m)
t.__index = t

function t.new(...) -- line: 13
    -- upvalues:
    --  [1] FreezeRay_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(FreezeRay_m.new(...), t)
    t_1:_Init()

    return t_1
end

function t.ExplosionEffect(_, arg2, arg3) -- line: 25
    -- upvalues:
    --  [1] GumRayExplosionEffect (copy)
    --  [2] BetterDebris_m (copy)
    --  [3] Utility_m (copy)

    local v2 = GumRayExplosionEffect:Clone()
    v2.CFrame = CFrame.new(arg2)
    v2.Parent = workspace
    BetterDebris_m:AddItem(v2, 5)

    for _ = 1, 4 do
        task.delay(
            0.2 * math.random(),
            Utility_m.CreateSound,
            Utility_m,
            "rbxassetid://94915446476512",
            0.5 + 0.25 * math.random(),
            1 + 0.2 * math.random(),
            v2,
            true,
            10
        )
    end

    for _, child in pairs(v2.Attachment:GetChildren()) do
        if child:IsA("ParticleEmitter") then
            Utility_m:ScaleParticleEmitter(child, arg3 / 6)
        end
    end

    Utility_m:PlayParticles(v2.Attachment)
end

function t._Init(_) -- line: 48
end

return t
