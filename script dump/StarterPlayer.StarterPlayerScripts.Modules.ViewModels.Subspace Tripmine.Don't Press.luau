local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local FunctionsController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.FunctionsController
)
local SubspaceTripmine_m = require(
    Players.LocalPlayer.PlayerScripts.Modules.ViewModels["Subspace Tripmine"]
)
local t = setmetatable({}, SubspaceTripmine_m)
t.__index = t

function t.new(...) -- line: 11
    -- upvalues:
    --  [1] SubspaceTripmine_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(SubspaceTripmine_m.new(...), t)
    t_1:_Init()

    return t_1
end

function t.PlayHideMineSound(_, arg2) -- line: 23
    -- upvalues:
    --  [1] Utility_m (copy)

    Utility_m:CreateSound(
        "rbxassetid://17675605394",
        1,
        1.25,
        arg2.Hitbox,
        true,
        5
    )
end

function t.ExplosionEffect(arg3, arg4) -- line: 27
    -- upvalues:
    --  [1] FunctionsController_m (copy)

    FunctionsController_m:FireAsync(
        arg3:ToEnum("NukeEffect"),
        arg4,
        arg3.ClientItem.Info.ExplosionRadius * 3,
        0.25
    )
end

function t._Init(_) -- line: 35
end

return t
