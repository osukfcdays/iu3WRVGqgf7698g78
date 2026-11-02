local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local BetterDebris_m = require(ReplicatedStorage.Modules.BetterDebris)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local WrapController_m = require(Players.LocalPlayer.PlayerScripts.Controllers.WrapController)
local BaseRPG_m = require(Players.LocalPlayer.PlayerScripts.Modules.ViewModels.BaseRPG)
local Attachment = Players.LocalPlayer.PlayerScripts.Assets.Misc:WaitForChild(
    "RPKEYExplosionEffect"
):WaitForChild("Attachment")
local t = setmetatable({}, BaseRPG_m)
t.__index = t

function t.new(...) -- line: 14
    -- upvalues:
    --  [1] BaseRPG_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(BaseRPG_m.new(...), t)
    t_1:_Init()

    return t_1
end

function t.PlayAimSound(arg1, arg2) -- line: 26
    arg1:CreateSound(
        "rbxassetid://96253147006478",
        0.375,
        2 + (if not arg2 then 0 else 0.1),
        true,
        5
    )
end

function t.ExplosionEffect(arg3, arg4, arg5) -- line: 30
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
    Part.CFrame = CFrame.new(arg4)
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
    local v8 = Attachment:Clone()

    for _, child in pairs(v8:GetChildren()) do
        if child:IsA("ParticleEmitter") then
            Utility_m:ScaleParticleEmitter(child, arg5 / 20)
        end
    end

    v8.PointLight.Range = arg5 * 2
    v8.Parent = Part
    WrapController_m:ApplyWrap(
        WrapController_m:RecordOriginalWrapProperties(v8),
        arg3.ClientItem:GetWrap(),
        true
    )
    Utility_m:PlayParticles(v8)
end

function t._Init(arg6) -- line: 62
    arg6:_RegisterAmmoVisual(arg6.ItemModel:WaitForChild("Rocket"):WaitForChild("Head"))
end

return t
