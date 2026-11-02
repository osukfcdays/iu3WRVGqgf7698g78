local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local BetterDebris_m = require(ReplicatedStorage.Modules.BetterDebris)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local FreezeRay_m = require(Players.LocalPlayer.PlayerScripts.Modules.ViewModels["Freeze Ray"])
local BubbleRayExplosionEffect = Players.LocalPlayer.PlayerScripts.Assets.Misc:WaitForChild(
    "BubbleRayExplosionEffect"
)
local t = {
    "rbxassetid://6928709440",
    "rbxassetid://6928709814",
    "rbxassetid://6928710129",
    "rbxassetid://6928710411",
    "rbxassetid://6928710904",
    "rbxassetid://6928711244"
}
local t_1 = setmetatable({}, FreezeRay_m)
t_1.__index = t_1

function t_1.new(...) -- line: 14
    -- upvalues:
    --  [1] FreezeRay_m (copy)
    --  [2] t_1 (copy)

    local t_2 = setmetatable(FreezeRay_m.new(...), t_1)
    t_2:_Init()

    return t_2
end

function t_1.ExplosionEffect(_, arg2, arg3) -- line: 26
    -- upvalues:
    --  [1] BubbleRayExplosionEffect (copy)
    --  [2] BetterDebris_m (copy)
    --  [3] Utility_m (copy)
    --  [4] t (copy)

    local v2 = BubbleRayExplosionEffect:Clone()
    v2.CFrame = CFrame.new(arg2)
    v2.Parent = workspace
    BetterDebris_m:AddItem(v2, 5)

    for _ = 1, 8 do
        Utility_m:CreateSound(
            t[math.random(#t)],
            0.75,
            1 + 0.2 * math.random(),
            v2,
            true,
            10
        )
    end

    for _, child in pairs(v2.Attachment:GetChildren()) do
        if child:IsA("ParticleEmitter") then
            Utility_m:ScaleParticleEmitter(child, arg3 / 8)
        end
    end

    Utility_m:PlayParticles(v2.Attachment)
end

function t_1._Init(_) -- line: 49
end

return t_1
