local Players = game:GetService("Players")
local FunctionsController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.FunctionsController
)
local BaseRPG_m = require(Players.LocalPlayer.PlayerScripts.Modules.ViewModels.BaseRPG)
local t = setmetatable({}, BaseRPG_m)
t.__index = t

function t.new(...) -- line: 9
    -- upvalues:
    --  [1] BaseRPG_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(BaseRPG_m.new(...), t)
    t_1:_Init()

    return t_1
end

function t.ExplosionEffect(arg1, arg2, arg3) -- line: 21
    -- upvalues:
    --  [1] FunctionsController_m (copy)

    FunctionsController_m:FireAsync(
        arg1:ToEnum("NukeEffect"),
        arg2,
        arg3,
        nil,
        true
    )
end

function t._Init(arg4) -- line: 29
    arg4:_RegisterAmmoVisual(arg4.ItemModel:WaitForChild("Rocket"):WaitForChild("Head"))
    arg4:_RegisterAmmoVisual(arg4.ItemModel:WaitForChild("Rocket"):WaitForChild("Neck"))
end

return t
