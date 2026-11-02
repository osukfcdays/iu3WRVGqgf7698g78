local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local BetterDebris_m = require(ReplicatedStorage.Modules.BetterDebris)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local BaseRPG_m = require(Players.LocalPlayer.PlayerScripts.Modules.ViewModels.BaseRPG)
local t = setmetatable({}, BaseRPG_m)
t.__index = t

function t.new(...) -- line: 11
    -- upvalues:
    --  [1] BaseRPG_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(BaseRPG_m.new(...), t)
    t_1:_Init()

    return t_1
end

function t.ExplosionEffect(_, arg2, arg3) -- line: 23
    -- upvalues:
    --  [1] BetterDebris_m (copy)
    --  [2] Utility_m (copy)

    local Explosion = Instance.new("Explosion")
    Explosion.BlastRadius = arg3
    Explosion.BlastPressure = 0
    Explosion.ExplosionType = Enum.ExplosionType.NoCraters
    Explosion.Position = arg2
    Explosion.Parent = workspace
    BetterDebris_m:AddItem(Explosion, 5)
    Utility_m:CreateSound(
        "rbxasset://sounds/collide.wav",
        0.5,
        0.9 + 0.2 * math.random(),
        arg2,
        true,
        10
    )
end

function t._Init(arg4) -- line: 39
    -- upvalues:
    --  [1] Utility_m (copy)

    task.defer(function() -- line: 40
        -- upvalues:
        --  [1] arg4 (copy)
        --  [2] Utility_m (ref)

        arg4.ClientItem.ProjectileShot:Connect(function(_, arg6) -- line: 41
            -- upvalues:
            --  [1] Utility_m (ref)

            local v4 = Utility_m:CreateSound(
                "rbxasset://sounds/Rocket whoosh 01.wav",
                0.5,
                1,
                arg6.Part,
                true
            )
            arg6:GetAttributeChangedSignal("Destroying"):Wait()
            v4:Destroy()
        end)
    end)
    arg4:_RegisterAmmoVisual(arg4.ItemModel:WaitForChild("Rocket"):WaitForChild("Part"))
end

return t
