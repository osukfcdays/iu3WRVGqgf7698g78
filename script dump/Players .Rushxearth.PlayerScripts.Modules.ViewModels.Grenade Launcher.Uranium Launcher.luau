local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local BetterDebris_m = require(ReplicatedStorage.Modules.BetterDebris)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local GrenadeLauncher_m = require(
    Players.LocalPlayer.PlayerScripts.Modules.ViewModels["Grenade Launcher"]
)
local UraniumExplosionEffect = Players.LocalPlayer.PlayerScripts.Assets.Misc:WaitForChild(
    "UraniumExplosionEffect"
)
local t = setmetatable({}, GrenadeLauncher_m)
t.__index = t

function t.new(...) -- line: 13
    -- upvalues:
    --  [1] GrenadeLauncher_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(GrenadeLauncher_m.new(...), t)
    t_1:_Init()

    return t_1
end

function t.ExplosionEffect(_, arg2, arg3) -- line: 25
    -- upvalues:
    --  [1] BetterDebris_m (copy)
    --  [2] Utility_m (copy)
    --  [3] UraniumExplosionEffect (copy)

    local Part = Instance.new("Part")
    Part.CanCollide = false
    Part.CanQuery = false
    Part.Anchored = true
    Part.Transparency = 1
    Part.CFrame = CFrame.new(arg2)
    Part.Parent = workspace
    BetterDebris_m:AddItem(Part, 5)
    Utility_m:CreateSound(
        "rbxassetid://13455969017",
        0.375,
        0.75 + 0.15 * math.random(),
        Part,
        true,
        10
    )
    Utility_m:CreateSound(
        "rbxassetid://18763746452",
        1.5,
        0.9 + 0.2 * math.random(),
        Part,
        true,
        10
    )

    for _, child in pairs(UraniumExplosionEffect:GetChildren()) do
        child:Clone().Parent = Part
    end

    for _, descendant in pairs(Part:GetDescendants()) do
        if descendant:IsA("ParticleEmitter") then
            Utility_m:ScaleParticleEmitter(descendant, arg3 / 10)
        end
    end

    Utility_m:PlayParticles(Part)
end

function t._Init(_) -- line: 55
end

return t
