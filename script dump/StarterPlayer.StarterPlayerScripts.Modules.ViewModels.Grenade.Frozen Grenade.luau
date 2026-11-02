local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local FunctionsController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.FunctionsController
)
local Grenade_m = require(Players.LocalPlayer.PlayerScripts.Modules.ViewModels.Grenade)
local t = setmetatable({}, Grenade_m)
t.__index = t

function t.new(...) -- line: 11
    -- upvalues:
    --  [1] Grenade_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(Grenade_m.new(...), t)
    t_1:_Init()

    return t_1
end

function t.ExplosionEffect(arg1, arg2, arg3) -- line: 23
    -- upvalues:
    --  [1] Utility_m (copy)
    --  [2] FunctionsController_m (copy)

    Utility_m:CreateSound(
        "rbxassetid://99261833097954",
        0.5,
        0.9 + 0.2 * math.random(),
        arg2,
        true,
        10
    )
    FunctionsController_m:FireAsync(arg1:ToEnum("ExplosionEffect"), arg2, arg3)
end

function t._Init(_) -- line: 32
end

return t
