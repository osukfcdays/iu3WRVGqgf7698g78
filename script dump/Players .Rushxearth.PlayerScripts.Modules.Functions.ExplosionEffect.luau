local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local BetterDebris_m = require(ReplicatedStorage.Modules.BetterDebris)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local Attachment = Players.LocalPlayer.PlayerScripts.Assets.Misc:WaitForChild("ExplosionEffect"):WaitForChild(
    "Attachment"
)

return function(arg1, arg2, arg3) -- line: 10
    -- upvalues:
    --  [1] BetterDebris_m (copy)
    --  [2] Utility_m (copy)
    --  [3] Attachment (copy)

    local Part = Instance.new("Part")
    Part.CanCollide = false
    Part.CanQuery = false
    Part.Anchored = true
    Part.Transparency = 1
    Part.CFrame = CFrame.new(arg1)
    Part.Parent = workspace
    BetterDebris_m:AddItem(Part, 5)
    Utility_m:CreateSound(
        "rbxassetid://13455969017",
        1,
        arg3 or 0.9 + 0.2 * math.random(),
        Part,
        true,
        10
    )
    local v5 = Attachment:Clone()

    for _, child in pairs(v5:GetChildren()) do
        if child:IsA("ParticleEmitter") then
            Utility_m:ScaleParticleEmitter(child, arg2 / 24)
        end
    end

    v5.PointLight.Range = arg2 * 2
    v5.Parent = Part
    Utility_m:PlayParticles(v5)
end
