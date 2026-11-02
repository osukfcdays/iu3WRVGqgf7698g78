local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local BetterDebris_m = require(ReplicatedStorage.Modules.BetterDebris)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local Attachment = Players.LocalPlayer.PlayerScripts.Assets.Misc:WaitForChild("CollectEffect"):WaitForChild(
    "Attachment"
)

return function(arg1, arg2, arg3, arg4) -- line: 9
    -- upvalues:
    --  [1] BetterDebris_m (copy)
    --  [2] Attachment (copy)
    --  [3] Utility_m (copy)

    local v1 = arg4 or 1
    local Part = Instance.new("Part")
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.Anchored = true
    Part.Transparency = 1
    Part.CFrame = CFrame.new(arg1)
    Part.Parent = workspace
    BetterDebris_m:AddItem(Part, 5)
    local v2 = Attachment:Clone()
    v2.Parent = Part
    BetterDebris_m:AddItem(v2, 5)

    for _, descendant in pairs(v2:GetDescendants()) do
        if descendant:IsA("ParticleEmitter") then
            Utility_m:ScaleParticleEmitter(descendant, 3 * v1)
            local v5 = arg2 and ColorSequence.new(arg2) or descendant.Color
            descendant.Color = v5
        end
    end

    Utility_m:PlayParticles(v2)

    if arg3 then
        Utility_m:CreateSound(
            arg3,
            1.5,
            1,
            Part,
            true,
            10
        )
    end
end
