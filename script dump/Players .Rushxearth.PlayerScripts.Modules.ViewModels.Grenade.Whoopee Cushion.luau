local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local BetterDebris_m = require(ReplicatedStorage.Modules.BetterDebris)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local Grenade_m = require(Players.LocalPlayer.PlayerScripts.Modules.ViewModels.Grenade)
local Attachment = Players.LocalPlayer.PlayerScripts.Assets.Misc.FartEffect.Attachment
local t = setmetatable({}, Grenade_m)
t.__index = t

function t.new(...) -- line: 13
    -- upvalues:
    --  [1] Grenade_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(Grenade_m.new(...), t)
    t_1:_Init()

    return t_1
end

function t.ExplosionEffect(_, arg2, arg3) -- line: 25
    -- upvalues:
    --  [1] BetterDebris_m (copy)
    --  [2] Utility_m (copy)
    --  [3] Attachment (copy)

    local Part = Instance.new("Part")
    Part.CanCollide = false
    Part.CanQuery = false
    Part.Anchored = true
    Part.Transparency = 1
    Part.CFrame = CFrame.new(arg2)
    Part.Parent = workspace
    BetterDebris_m:AddItem(Part, 5)
    Utility_m:CreateSound(
        "rbxassetid://16924073325",
        1,
        1 + 0.2 * math.random(),
        Part,
        true,
        10
    )
    local v4 = Attachment:Clone()

    for _, child in pairs(v4:GetChildren()) do
        if child:IsA("ParticleEmitter") then
            Utility_m:ScaleParticleEmitter(child, arg3 / 24)
        end
    end

    v4.PointLight.Range = arg3 * 2
    v4.Parent = Part
    Utility_m:PlayParticles(v4)
end

function t._Init(_) -- line: 55
end

return t
