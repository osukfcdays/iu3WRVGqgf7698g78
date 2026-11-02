local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local BetterDebris_m = require(ReplicatedStorage.Modules.BetterDebris)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local ClientViewModel_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("ClientReplicatedClasses"):WaitForChild(
        "ClientFighter"
    ):WaitForChild("ClientItem"):WaitForChild("ClientViewModel")
)
local DistortionExplosionParticles = Players.LocalPlayer.PlayerScripts.Assets.Misc:WaitForChild(
    "DistortionExplosionParticles"
)
local gradient = ColorSequence.new(Color3.fromRGB(0, 255, 149))
local t = setmetatable({}, ClientViewModel_m)
t.__index = t

function t.new(...) -- line: 14
    -- upvalues:
    --  [1] ClientViewModel_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(ClientViewModel_m.new(...), t)
    t_1:_Init()

    return t_1
end

function t.GetFriendlyTracerColor(_) -- line: 26
    -- upvalues:
    --  [1] gradient (copy)

    return gradient
end

function t.ExplosionEffect(_, arg3, arg4, arg5) -- line: 30
    -- upvalues:
    --  [1] DistortionExplosionParticles (copy)
    --  [2] BetterDebris_m (copy)
    --  [3] Utility_m (copy)

    task.delay(math.random() * 0.2, function() -- line: 31
        -- upvalues:
        --  [1] arg5 (copy)
        --  [2] DistortionExplosionParticles (ref)
        --  [3] arg3 (copy)
        --  [4] BetterDebris_m (ref)
        --  [5] Utility_m (ref)
        --  [6] arg4 (copy)

        local v4 = (arg5 or DistortionExplosionParticles):Clone()
        v4.CFrame = CFrame.new(arg3)
        v4.Parent = workspace
        BetterDebris_m:AddItem(v4, 5)
        Utility_m:CreateSound(
            "rbxassetid://97822830667649",
            0.375,
            0.75 + 1.25 * math.random(),
            v4,
            true,
            10
        )

        for _, child in pairs(v4.Attachment:GetChildren()) do
            if child:IsA("ParticleEmitter") then
                Utility_m:ScaleParticleEmitter(child, arg4 / 4)
            end
        end

        Utility_m:PlayParticles(v4.Attachment)
    end)
end

function t._Init(_) -- line: 53
end

return t
