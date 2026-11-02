local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local BetterDebris_m = require(ReplicatedStorage.Modules.BetterDebris)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local ClientViewModel_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("ClientReplicatedClasses"):WaitForChild(
        "ClientFighter"
    ):WaitForChild("ClientItem"):WaitForChild("ClientViewModel")
)
local Attachment = Players.LocalPlayer.PlayerScripts.Assets.Misc.BattleAxeSpinParticles.Attachment
local t = setmetatable({}, ClientViewModel_m)
t.__index = t

function t.new(...) -- line: 13
    -- upvalues:
    --  [1] ClientViewModel_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(ClientViewModel_m.new(...), t)
    t_1:_Init()

    return t_1
end

function t.PlaySpinParticles(arg1) -- line: 25
    -- upvalues:
    --  [1] Attachment (copy)
    --  [2] BetterDebris_m (copy)
    --  [3] Utility_m (copy)

    local v3 = Attachment:Clone()
    v3.Parent = arg1.ClientItem.ClientFighter.Entity.RootPart
    BetterDebris_m:AddItem(v3, 3)
    Utility_m:PlayParticles(v3)

    for _, child in pairs(v3:GetChildren()) do
        if child:IsA("ParticleEmitter") then
            child:SetAttribute("IgnoreVisibilityCheck", true)
            Utility_m:ScaleParticleEmitter(child, arg1.ClientItem.Info.SpinRadius / 3)
        end
    end
end

function t._Init(_) -- line: 43
end

return t
