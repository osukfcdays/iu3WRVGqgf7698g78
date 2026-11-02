local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local BetterDebris_m = require(ReplicatedStorage.Modules.BetterDebris)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local BaseSatchel_m = require(Players.LocalPlayer.PlayerScripts.Modules.ViewModels.BaseSatchel)
local Attachment = Players.LocalPlayer.PlayerScripts.Assets.Misc:WaitForChild(
    "PaperExplosionEffect"
):WaitForChild("Attachment")
local t = setmetatable({}, BaseSatchel_m)
t.__index = t

function t.new(...) -- line: 13
    -- upvalues:
    --  [1] BaseSatchel_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(BaseSatchel_m.new(...), t)
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
        "rbxassetid://135595627084798",
        1,
        1 + 0.2 * math.random(),
        Part,
        true,
        10
    )
    Utility_m:CreateSound(
        "rbxassetid://13455969017",
        0.75,
        0.9 + 0.2 * math.random(),
        Part,
        true,
        10
    )
    local v6 = Attachment:Clone()

    for _, child in pairs(v6:GetChildren()) do
        if child:IsA("ParticleEmitter") then
            Utility_m:ScaleParticleEmitter(child, arg3 / 5)
        end
    end

    v6.PointLight.Range = arg3 * 2
    v6.Parent = Part
    Utility_m:PlayParticles(v6)
end

function t._Init(_) -- line: 56
end

return t
