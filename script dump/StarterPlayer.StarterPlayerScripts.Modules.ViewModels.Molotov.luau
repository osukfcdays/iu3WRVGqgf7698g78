local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local BetterDebris_m = require(ReplicatedStorage.Modules.BetterDebris)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local WrapController_m = require(Players.LocalPlayer.PlayerScripts.Controllers.WrapController)
local ClientViewModel_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("ClientReplicatedClasses"):WaitForChild(
        "ClientFighter"
    ):WaitForChild("ClientItem"):WaitForChild("ClientViewModel")
)
local MolotovExplosionEffects = Players.LocalPlayer.PlayerScripts.Assets.Misc:WaitForChild(
    "MolotovExplosionEffects"
)
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

function t.ExplosionEffect(arg1, arg2, arg3) -- line: 26
    -- upvalues:
    --  [1] MolotovExplosionEffects (copy)
    --  [2] BetterDebris_m (copy)
    --  [3] Utility_m (copy)
    --  [4] WrapController_m (copy)

    local v3 = (MolotovExplosionEffects:FindFirstChild(arg1.Name) or MolotovExplosionEffects.Default):Clone()
    v3.CFrame = CFrame.new(arg2, arg2 + Vector3.new(0, 1, 0))
    v3.Parent = workspace
    BetterDebris_m:AddItem(v3, 5)
    Utility_m:CreateSound(
        "rbxassetid://17167035482",
        0.25,
        1.5 + 0.25 * math.random(),
        v3,
        true,
        10
    )

    for _, child in pairs(v3.Attachment:GetChildren()) do
        if child:IsA("ParticleEmitter") then
            Utility_m:ScaleParticleEmitter(child, arg3 / 16)
        end
    end

    Utility_m:PlayParticles(v3.Attachment)
    Utility_m:PlayParticles(v3.Attachment)
    WrapController_m:ApplyWrap(
        WrapController_m:RecordOriginalWrapProperties(v3),
        arg1.ClientItem:GetWrap(),
        true
    )

    return v3
end

function t._Init(_) -- line: 51
end

return t
