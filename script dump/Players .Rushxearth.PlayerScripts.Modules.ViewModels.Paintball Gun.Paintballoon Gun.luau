local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local PaintballGun_m = require(
    Players.LocalPlayer.PlayerScripts.Modules.ViewModels["Paintball Gun"]
)
local Attachment = Players.LocalPlayer.PlayerScripts.Assets.Misc:WaitForChild(
    "BalloonExplosionEffect"
):WaitForChild("Attachment")
local t = {
    ColorSequence.new(Color3.fromRGB(61, 90, 255)),
    ColorSequence.new(Color3.fromRGB(88, 255, 62)),
    ColorSequence.new(Color3.fromRGB(255, 232, 57))
}
local t_1 = setmetatable({}, PaintballGun_m)
t_1.__index = t_1

function t_1.new(...) -- line: 14
    -- upvalues:
    --  [1] PaintballGun_m (copy)
    --  [2] t_1 (copy)

    local t_2 = setmetatable(PaintballGun_m.new(...), t_1)
    t_2:_Init()

    return t_2
end

function t_1.CustomImpactMarker(_, arg2) -- line: 26
    -- upvalues:
    --  [1] t (copy)
    --  [2] Attachment (copy)
    --  [3] Utility_m (copy)

    local v5 = t[math.random(#t)]
    local v6 = Attachment:Clone()
    v6.flash.Color = v5
    v6.impact1.Color = v5
    v6.impact2.Color = v5
    v6.specs2Balloon.Color = v5
    v6.specs2Balloon2.Color = v5
    v6.Parent = arg2

    for _, child in pairs(v6:GetChildren()) do
        if child:IsA("ParticleEmitter") then
            Utility_m:ScaleParticleEmitter(child, 0.16666666666666666)
        end
    end

    Utility_m:PlayParticles(v6)
end

function t_1._Init(_) -- line: 49
end

return t_1
