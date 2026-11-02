local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local BetterDebris_m = require(ReplicatedStorage.Modules.BetterDebris)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local ClientViewModel_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("ClientReplicatedClasses"):WaitForChild(
        "ClientFighter"
    ):WaitForChild("ClientItem"):WaitForChild("ClientViewModel")
)
local ExogunExplosionParticles = Players.LocalPlayer.PlayerScripts.Assets.Misc:WaitForChild(
    "ExogunExplosionParticles"
)
local gradient = ColorSequence.new(Color3.fromRGB(131, 255, 117))
local t = setmetatable({}, ClientViewModel_m)
t.__index = t

function t.new(...) -- line: 14
    -- upvalues:
    --  [1] ClientViewModel_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(ClientViewModel_m.new(...), t)
    t_1._reload_attachment = t_1.Model:FindFirstChild("_exogun_reload", true)
    t_1:_Init()

    return t_1
end

function t.GetFriendlyTracerColor(_) -- line: 28
    -- upvalues:
    --  [1] gradient (copy)

    return gradient
end

function t.ExplosionEffect(
    _,
    arg3,
    arg4,
    arg5,
    _
) -- line: 32
    -- upvalues:
    --  [1] ExogunExplosionParticles (copy)
    --  [2] BetterDebris_m (copy)
    --  [3] Utility_m (copy)

    local v4 = (arg5 or ExogunExplosionParticles):Clone()
    v4.CFrame = CFrame.new(arg3)
    v4.Parent = workspace
    BetterDebris_m:AddItem(v4, 5)
    Utility_m:CreateSound(
        "rbxassetid://17245106793",
        0.375,
        1 + 0.5 * math.random(),
        v4,
        true,
        10
    )

    for _, child in pairs(v4.Attachment:GetChildren()) do
        if child:IsA("ParticleEmitter") then
            Utility_m:ScaleParticleEmitter(child, arg4 / 8)
        end
    end

    Utility_m:PlayParticles(v4.Attachment)
end

function t.PlayReloadParticles(arg7) -- line: 49
    for _, child_1 in pairs(arg7._reload_attachment:GetChildren()) do
        child_1:Emit(20)
    end
end

function t._Init(_) -- line: 59
end

return t
