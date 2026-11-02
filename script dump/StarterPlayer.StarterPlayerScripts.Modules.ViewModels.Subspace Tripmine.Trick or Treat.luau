local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local _ = require(ReplicatedStorage.Modules.Utility)
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

function t.ExplosionEffect(arg1, arg2) -- line: 23
    -- upvalues:
    --  [1] FunctionsController_m (copy)

    for index = 1, 3 do
        local v2 = 10 * (math.random() - 0.5)
        local v4 = arg2 + Vector3.new(v2, index ^ 2, 10 * (math.random() - 0.5))
        local v5 = arg1.ClientItem.Info.ExplosionRadius * (1 + 1 * math.random())
        FunctionsController_m:FireAsync(
            arg1:ToEnum("ExplosionEffect"),
            v4,
            v5,
            (index - 1) * 0.25 + 1
        )
        wait(0.1)
    end
end

function t._Init(_) -- line: 38
end

return t
