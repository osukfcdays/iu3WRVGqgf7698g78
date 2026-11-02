local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local BetterDebris_m = require(ReplicatedStorage.Modules.BetterDebris)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local SubspaceTripmine_m = require(
    Players.LocalPlayer.PlayerScripts.Modules.ViewModels["Subspace Tripmine"]
)
local HazardSignExplosionEffect = Players.LocalPlayer.PlayerScripts.Assets.Misc:WaitForChild(
    "HazardSignExplosionEffect"
)
local HazardSignChark = Players.LocalPlayer.PlayerScripts.Assets.Misc:WaitForChild(
    "HazardSignChark"
)
local t = setmetatable({}, SubspaceTripmine_m)
t.__index = t

function t.new(...) -- line: 14
    -- upvalues:
    --  [1] SubspaceTripmine_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(SubspaceTripmine_m.new(...), t)
    t_1:_Init()

    return t_1
end

function t.ExplosionEffect(arg1, arg2) -- line: 26
    -- upvalues:
    --  [1] BetterDebris_m (copy)
    --  [2] Utility_m (copy)
    --  [3] HazardSignExplosionEffect (copy)
    --  [4] HazardSignChark (copy)

    local Part = Instance.new("Part")
    Part.CanCollide = false
    Part.CanQuery = false
    Part.Anchored = true
    Part.Transparency = 1
    Part.CFrame = CFrame.new(arg2) * CFrame.fromOrientation(
        1.5707963267948966,
        1.5707963267948966,
        0
    )
    Part.Parent = workspace
    BetterDebris_m:AddItem(Part, 5)
    Utility_m:CreateSound(
        "rbxassetid://17812496122",
        1,
        0.9 + 0.2 * math.random(),
        Part,
        true,
        10
    )

    for _, child in pairs(HazardSignExplosionEffect:GetChildren()) do
        child:Clone().Parent = Part
    end

    for _, child_1 in pairs(Part:GetChildren()) do
        if child_1:IsA("ParticleEmitter") then
            Utility_m:ScaleParticleEmitter(child_1, arg1.ClientItem.Info.ExplosionRadius / 6)
        end
    end

    Part.PointLight.Range = arg1.ClientItem.Info.ExplosionRadius * 2
    Utility_m:PlayParticles(Part)
    task.spawn(function() -- line: 51
        -- upvalues:
        --  [1] HazardSignChark (ref)
        --  [2] BetterDebris_m (ref)
        --  [3] arg2 (copy)
        --  [4] Utility_m (ref)

        local v7 = HazardSignChark:Clone()
        v7.Parent = workspace
        BetterDebris_m:AddItem(v7, 5)
        local v8 = CFrame.new(arg2) * CFrame.Angles(0, math.random() * 3.141592653589793 * 2, 0) + Vector3.new(0, 5, 0)
        local v9 = v8 - Vector3.new(0, 25, 0)
        Utility_m:RenderstepForLoop(0, 100, 3, function(arg3) -- line: 59
            -- upvalues:
            --  [1] v7 (copy)
            --  [2] v8 (copy)
            --  [3] v9 (copy)

            v7:PivotTo(v8:Lerp(v9, (arg3 / 100) ^ 4))
        end)
        v7:Destroy()
    end)
end

function t._Init(_) -- line: 73
end

return t
