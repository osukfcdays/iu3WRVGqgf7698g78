local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local BetterDebris_m = require(ReplicatedStorage.Modules.BetterDebris)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local ClientViewModel_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("ClientReplicatedClasses"):WaitForChild(
        "ClientFighter"
    ):WaitForChild("ClientItem"):WaitForChild("ClientViewModel")
)
local SubspaceTripmineExplosion = Players.LocalPlayer.PlayerScripts.Assets.Misc:WaitForChild(
    "SubspaceTripmineExplosion"
)
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

function t.PlayHideMineSound(_, arg2) -- line: 25
    -- upvalues:
    --  [1] Utility_m (copy)

    Utility_m:CreateSound(
        "rbxassetid://11956590",
        1,
        1,
        arg2.Hitbox,
        true,
        5
    )
end

function t.ExplosionEffect(arg3, arg4) -- line: 29
    -- upvalues:
    --  [1] Utility_m (copy)
    --  [2] SubspaceTripmineExplosion (copy)
    --  [3] BetterDebris_m (copy)

    Utility_m:CreateSound(
        "rbxassetid://11984351",
        0.5,
        1,
        arg4,
        true,
        10
    )
    Utility_m:CreateSound(
        "rbxassetid://11984254",
        1,
        0.75,
        arg4,
        true,
        10
    )
    local v3 = SubspaceTripmineExplosion:Clone()
    v3.CFrame = CFrame.new(arg4)
    v3.PointLight.Range = arg3.ClientItem.Info.ExplosionRadius * 3
    v3.Parent = workspace
    BetterDebris_m:AddItem(v3, 5)
    wait(1)
    v3.Sparkles.Enabled = false
    local PointLight = v3.PointLight
    Utility_m:RenderstepForLoop(0, 100, 1, function(arg5) -- line: 45
        -- upvalues:
        --  [1] PointLight (copy)

        PointLight.Brightness = 40 * (1 - (arg5 / 100) ^ 4)
    end)
end

function t._Init(_) -- line: 56
end

return t
