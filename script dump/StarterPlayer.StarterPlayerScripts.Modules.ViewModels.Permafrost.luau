local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local BetterDebris_m = require(ReplicatedStorage.Modules.BetterDebris)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local ClientViewModel_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("ClientReplicatedClasses"):WaitForChild(
        "ClientFighter"
    ):WaitForChild("ClientItem"):WaitForChild("ClientViewModel")
)
local FreezeRayExplosionEffect = Players.LocalPlayer.PlayerScripts.Assets.Misc:WaitForChild(
    "FreezeRayExplosionEffect"
)
local gradient = ColorSequence.new(Color3.fromRGB(30, 225, 255))
local t = setmetatable({}, ClientViewModel_m)
t.__index = t

function t.new(...) -- line: 14
    -- upvalues:
    --  [1] ClientViewModel_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(ClientViewModel_m.new(...), t)
    t_1._gauge_tickers = {}
    t_1:_Init()

    return t_1
end

function t.GetFriendlyTracerColor(_) -- line: 28
    -- upvalues:
    --  [1] gradient (copy)

    return gradient
end

function t.ExplosionEffect(_, arg3, arg4) -- line: 32
    -- upvalues:
    --  [1] FreezeRayExplosionEffect (copy)
    --  [2] BetterDebris_m (copy)
    --  [3] Utility_m (copy)

    local v4 = FreezeRayExplosionEffect:Clone()
    v4.CFrame = CFrame.new(arg3)
    v4.Parent = workspace
    BetterDebris_m:AddItem(v4, 5)
    Utility_m:CreateSound(
        "rbxassetid://18429092842",
        0.4,
        1 + 0.2 * math.random(),
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
end

function t._UpdateGaugeTickers(arg5) -- line: 53
    local v10 = -45 - 270 * (1 - arg5.ClientItem:Get("Ammo") / arg5.ClientItem.Info.MaxAmmo)

    for _, val in pairs(arg5._gauge_tickers) do
        val.Rotation = v10
    end
end

function t._Setup(arg6) -- line: 61
    for _, descendant in pairs(arg6.ItemModel:GetDescendants()) do
        if descendant:HasTag("PermafrostGaugeTicker") then
            table.insert(arg6._gauge_tickers, descendant)
        end
    end
end

function t._Init(arg7) -- line: 69
    arg7.ClientItem:GetDataChangedSignal("MaxAmmo"):Connect(function() -- line: 70
        -- upvalues:
        --  [1] arg7 (copy)

        arg7:_UpdateGaugeTickers()
    end)
    arg7.ClientItem:GetDataChangedSignal("Ammo"):Connect(function() -- line: 74
        -- upvalues:
        --  [1] arg7 (copy)

        arg7:_UpdateGaugeTickers()
    end)
    arg7:_Setup()
    arg7:_UpdateGaugeTickers()
end

return t
