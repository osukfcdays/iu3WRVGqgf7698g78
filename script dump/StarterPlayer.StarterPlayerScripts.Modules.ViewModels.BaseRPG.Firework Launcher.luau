local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local BetterDebris_m = require(ReplicatedStorage.Modules.BetterDebris)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local BaseRPG_m = require(Players.LocalPlayer.PlayerScripts.Modules.ViewModels.BaseRPG)
local Attachment = Players.LocalPlayer.PlayerScripts.Assets.Misc:WaitForChild("2025ExplosionEffect"):WaitForChild(
    "Attachment"
)
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
        0.375,
        0.9 + 0.2 * math.random(),
        Part,
        true,
        10
    )
    Utility_m:CreateSound(
        "rbxassetid://121650992045064",
        1,
        0.9 + 0.2 * math.random(),
        Part,
        true,
        10
    )
    Utility_m:CreateSound(
        "rbxassetid://101905653148428",
        1,
        0.9 + 0.2 * math.random(),
        Part,
        true,
        10
    )
    local v8 = Attachment:Clone()

    for _, child in pairs(v8:GetChildren()) do
        if child:IsA("ParticleEmitter") then
            Utility_m:ScaleParticleEmitter(child, arg3 / 8)
        end
    end

    v8.PointLight.Range = arg3 * 2
    v8.Parent = Part
    Utility_m:PlayParticles(v8)
end

function t._Init(arg4) -- line: 57
    -- upvalues:
    --  [1] Utility_m (copy)

    task.defer(function() -- line: 58
        -- upvalues:
        --  [1] arg4 (copy)
        --  [2] Utility_m (ref)

        arg4.ClientItem.ProjectileShot:Connect(function(_, arg6) -- line: 59
            -- upvalues:
            --  [1] Utility_m (ref)

            local v11 = Utility_m:CreateSound(
                "rbxassetid://139064076353020",
                0.25,
                1,
                arg6.Fuse,
                true
            )
            arg6:GetAttributeChangedSignal("Destroying"):Wait()
            v11:Destroy()
        end)
    end)
    arg4:_RegisterAmmoVisual(arg4.ItemModel:WaitForChild("Rocket"):WaitForChild("Gold"))
    arg4:_RegisterAmmoVisual(arg4.ItemModel:WaitForChild("Rocket"):WaitForChild("Black"))
    arg4:_RegisterAmmoVisual(arg4.ItemModel:WaitForChild("Rocket"):WaitForChild("Fuse"))
end

return t
