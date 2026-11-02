local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local BetterDebris_m = require(ReplicatedStorage.Modules.BetterDebris)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local BaseRPG_m = require(Players.LocalPlayer.PlayerScripts.Modules.ViewModels.BaseRPG)
local Attachment = Players.LocalPlayer.PlayerScripts.Assets.Misc:WaitForChild(
    "CupcakeExplosionEffect"
):WaitForChild("Attachment")
local t = setmetatable({}, BaseRPG_m)
t.__index = t

function t.new(...) -- line: 13
    -- upvalues:
    --  [1] BaseRPG_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(BaseRPG_m.new(...), t)
    t_1:_Init()

    return t_1
end

function t.ExplosionEffect(_, arg2, arg3) -- line: 25
    -- upvalues:
    --  [1] BetterDebris_m (copy)
    --  [2] Utility_m (copy)
    --  [3] Attachment (copy)

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
        "rbxassetid://121017531909847",
        1.25,
        0.9 + 0.2 * math.random(),
        Part,
        true,
        10
    )
    local v6 = Attachment:Clone()

    for _, child in pairs(v6:GetChildren()) do
        if child:IsA("ParticleEmitter") then
            Utility_m:ScaleParticleEmitter(child, arg3 / 16)
        end
    end

    v6.PointLight.Range = arg3 * 2
    v6.Parent = Part
    Utility_m:PlayParticles(v6)
end

function t._Init(arg4) -- line: 56
    arg4:_RegisterAmmoVisual(arg4.ItemModel:WaitForChild("Rocket"):WaitForChild("MeshPart1"))
    arg4:_RegisterAmmoVisual(arg4.ItemModel:WaitForChild("Rocket"):WaitForChild("MeshPart2"))
    arg4:_RegisterAmmoVisual(arg4.ItemModel:WaitForChild("Rocket"):WaitForChild("MeshPart3"))
    arg4:_RegisterAmmoVisual(arg4.ItemModel:WaitForChild("Rocket"):WaitForChild("MeshPart4"))
    arg4:_RegisterAmmoVisual(arg4.ItemModel:WaitForChild("Rocket"):WaitForChild("MeshPart5"))
    arg4:_RegisterAmmoVisual(arg4.ItemModel:WaitForChild("Rocket"):WaitForChild("MeshPart6"))
    arg4:_RegisterAmmoVisual(arg4.ItemModel:WaitForChild("Rocket"):WaitForChild("MeshPart7"))
end

return t
