local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local BetterDebris_m = require(ReplicatedStorage.Modules.BetterDebris)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local SubspaceTripmine_m = require(
    Players.LocalPlayer.PlayerScripts.Modules.ViewModels["Subspace Tripmine"]
)
local SpringExplosionEffect = Players.LocalPlayer.PlayerScripts.Assets.Misc:WaitForChild(
    "SpringExplosionEffect"
)
local t = setmetatable({}, SubspaceTripmine_m)
t.__index = t

function t.new(...) -- line: 13
    -- upvalues:
    --  [1] SubspaceTripmine_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(SubspaceTripmine_m.new(...), t)
    t_1:_Init()

    return t_1
end

function t.ExplosionEffect(_, arg2) -- line: 25
    -- upvalues:
    --  [1] Utility_m (copy)
    --  [2] SpringExplosionEffect (copy)
    --  [3] BetterDebris_m (copy)

    Utility_m:CreateSound(
        "rbxassetid://18763806953",
        1.75,
        0.9 + 0.2 * math.random(),
        arg2,
        true,
        10
    )
    Utility_m:CreateSound(
        "rbxassetid://105724753475729",
        1.5,
        0.9 + 0.2 * math.random(),
        arg2,
        true,
        10
    )
    local v6 = SpringExplosionEffect:Clone()
    v6.CFrame = CFrame.new(arg2)
    v6.Parent = workspace
    BetterDebris_m:AddItem(v6, 5)
    Utility_m:PlayParticles(v6)
end

function t._Init(_) -- line: 40
end

return t
