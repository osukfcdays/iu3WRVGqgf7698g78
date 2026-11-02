local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local BetterDebris_m = require(ReplicatedStorage.Modules.BetterDebris)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local WrapController_m = require(Players.LocalPlayer.PlayerScripts.Controllers.WrapController)
local Grenade_m = require(Players.LocalPlayer.PlayerScripts.Modules.ViewModels.Grenade)
local Attachment = Players.LocalPlayer.PlayerScripts.Assets.Misc:WaitForChild(
    "KeynadeExplosionEffect"
):WaitForChild("Attachment")
local t = setmetatable({}, Grenade_m)
t.__index = t

function t.new(...) -- line: 14
    -- upvalues:
    --  [1] Grenade_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(Grenade_m.new(...), t)
    t_1:_Init()

    return t_1
end

function t.ExplosionEffect(arg1, arg2, arg3) -- line: 26
    -- upvalues:
    --  [1] BetterDebris_m (copy)
    --  [2] Utility_m (copy)
    --  [3] Attachment (copy)
    --  [4] WrapController_m (copy)

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
        0.5,
        0.9 + 0.2 * math.random(),
        Part,
        true,
        10
    )
    Utility_m:CreateSound(
        "rbxassetid://18179281854",
        2,
        0.9 + 0.2 * math.random(),
        Part,
        true,
        10
    )
    local v6 = Attachment:Clone()

    for _, child in pairs(v6:GetChildren()) do
        if child:IsA("ParticleEmitter") then
            Utility_m:ScaleParticleEmitter(child, arg3 / 10)
        end
    end

    v6.PointLight.Range = arg3 * 2
    v6.Parent = Part
    WrapController_m:ApplyWrap(
        WrapController_m:RecordOriginalWrapProperties(v6),
        arg1.ClientItem:GetWrap(),
        true
    )
    Utility_m:PlayParticles(v6)
end

function t._Init(_) -- line: 58
end

return t
