local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local BetterDebris_m = require(ReplicatedStorage.Modules.BetterDebris)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local ExtinguishParticles = Players.LocalPlayer.PlayerScripts.Assets.Misc:WaitForChild(
    "ExtinguishParticles"
)

return function(arg1) -- line: 9
    -- upvalues:
    --  [1] ExtinguishParticles (copy)
    --  [2] BetterDebris_m (copy)
    --  [3] Utility_m (copy)

    local v1 = ExtinguishParticles:Clone()
    v1.CFrame = arg1
    v1.Parent = workspace
    BetterDebris_m:AddItem(v1, 10)
    Utility_m:CreateSound(
        "rbxassetid://16812185839",
        0.75,
        1.3 + 0.2 * math.random(),
        v1,
        true
    )
    Utility_m:CreateSound(
        "rbxassetid://16812389263",
        0.75,
        1.3 + 0.2 * math.random(),
        v1,
        true
    )
    Utility_m:PlayParticles(v1.Attachment)
end
