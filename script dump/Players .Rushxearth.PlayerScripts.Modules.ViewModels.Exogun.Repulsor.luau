local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local BetterDebris_m = require(ReplicatedStorage.Modules.BetterDebris)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local Exogun_m = require(Players.LocalPlayer.PlayerScripts.Modules.ViewModels.Exogun)
local RepulsorExplosionParticles = Players.LocalPlayer.PlayerScripts.Assets.Misc:WaitForChild(
    "RepulsorExplosionParticles"
)
local gradient = ColorSequence.new(Color3.fromRGB(55, 218, 255))
local t = setmetatable({}, Exogun_m)
t.__index = t

function t.new(...) -- line: 14
    -- upvalues:
    --  [1] Exogun_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(Exogun_m.new(...), t)
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
    --  [1] RepulsorExplosionParticles (copy)
    --  [2] BetterDebris_m (copy)
    --  [3] Utility_m (copy)

    local v3 = RepulsorExplosionParticles:Clone()
    v3.CFrame = CFrame.new(arg3)
    v3.Parent = workspace
    BetterDebris_m:AddItem(v3, 5)
    Utility_m:CreateSound(
        "rbxassetid://17245106793",
        0.125,
        1 + 0.5 * math.random(),
        v3,
        true,
        10
    )
    Utility_m:CreateSound(
        "rbxassetid://103974521039631",
        0.375,
        1 + 0.25 * math.random(),
        v3,
        true,
        10
    )

    for _, child in pairs(v3.Attachment:GetChildren()) do
        if child:IsA("ParticleEmitter") then
            Utility_m:ScaleParticleEmitter(child, arg4 / 6)
        end
    end

    Utility_m:PlayParticles(v3.Attachment)
end

function t.PlayReloadParticles(_) -- line: 48
end

function t._Init(arg6) -- line: 56
    -- upvalues:
    --  [1] Utility_m (copy)

    arg6.AnimationPlayed:Connect(function(animationTrack: AnimationTrack) -- line: 57
        -- upvalues:
        --  [1] Utility_m (ref)
        --  [2] arg6 (copy)

        if animationTrack == "Reload" then
            Utility_m:PlayParticles(arg6._reload_attachment.Parent)
        end
    end)
end

return t
