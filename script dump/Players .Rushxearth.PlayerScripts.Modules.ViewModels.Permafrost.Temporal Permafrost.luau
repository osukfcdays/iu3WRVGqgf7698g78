local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local BetterDebris_m = require(ReplicatedStorage.Modules.BetterDebris)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local Permafrost_m = require(Players.LocalPlayer.PlayerScripts.Modules.ViewModels.Permafrost)
local TemporalRayExplosionEffect = Players.LocalPlayer.PlayerScripts.Assets.Misc:WaitForChild(
    "TemporalRayExplosionEffect"
)
local gradient = ColorSequence.new(Color3.fromRGB(255, 119, 0))
local t = setmetatable({}, Permafrost_m)
t.__index = t

function t.new(...) -- line: 14
    -- upvalues:
    --  [1] Permafrost_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(Permafrost_m.new(...), t)
    t_1:_Init()

    return t_1
end

function t.GetFriendlyTracerColor(_) -- line: 26
    -- upvalues:
    --  [1] gradient (copy)

    return gradient
end

function t.ExplosionEffect(_, arg3, arg4) -- line: 30
    -- upvalues:
    --  [1] TemporalRayExplosionEffect (copy)
    --  [2] BetterDebris_m (copy)
    --  [3] Utility_m (copy)

    local v3 = TemporalRayExplosionEffect:Clone()
    v3.CFrame = CFrame.new(arg3)
    v3.Parent = workspace
    BetterDebris_m:AddItem(v3, 5)
    Utility_m:CreateSound(
        "rbxassetid://18431054727",
        0.75,
        1 + 0.2 * math.random(),
        v3,
        true,
        10
    )

    for _, child in pairs(v3.Attachment:GetChildren()) do
        if child:IsA("ParticleEmitter") then
            Utility_m:ScaleParticleEmitter(child, arg4 / 4)
        end
    end

    Utility_m:PlayParticles(v3.Attachment)
end

function t._Init(_) -- line: 51
end

return t
