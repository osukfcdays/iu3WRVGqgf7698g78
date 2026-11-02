local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local BetterDebris_m = require(ReplicatedStorage.Modules.BetterDebris)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local GrenadeLauncher_m = require(
    Players.LocalPlayer.PlayerScripts.Modules.ViewModels["Grenade Launcher"]
)
local Attachment = Players.LocalPlayer.PlayerScripts.Assets.Misc:WaitForChild(
    "BalloonExplosionEffect"
):WaitForChild("Attachment")
local t = {
    ColorSequence.new(Color3.fromRGB(61, 90, 255)),
    ColorSequence.new(Color3.fromRGB(88, 255, 62)),
    ColorSequence.new(Color3.fromRGB(255, 232, 57))
}
local t_1 = setmetatable({}, GrenadeLauncher_m)
t_1.__index = t_1

function t_1.new(...) -- line: 14
    -- upvalues:
    --  [1] GrenadeLauncher_m (copy)
    --  [2] t_1 (copy)

    local t_2 = setmetatable(GrenadeLauncher_m.new(...), t_1)
    t_2:_Init()

    return t_2
end

function t_1.ExplosionEffect(_, arg2, arg3) -- line: 26
    -- upvalues:
    --  [1] BetterDebris_m (copy)
    --  [2] Utility_m (copy)
    --  [3] t (copy)
    --  [4] Attachment (copy)

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
        "rbxassetid://101824947434055",
        1.25,
        0.9 + 0.2 * math.random(),
        Part,
        true,
        10
    )
    local v9 = t[math.random(#t)]
    local v10 = Attachment:Clone()
    v10.flash.Color = v9
    v10.impact1.Color = v9
    v10.impact2.Color = v9
    v10.specs2Balloon.Color = v9
    v10.specs2Balloon2.Color = v9
    v10.Parent = Part

    for _, child in pairs(v10:GetChildren()) do
        if child:IsA("ParticleEmitter") then
            Utility_m:ScaleParticleEmitter(child, arg3 / 12)
        end
    end

    Utility_m:PlayParticles(v10)
end

function t_1._Init(_) -- line: 61
end

return t_1
