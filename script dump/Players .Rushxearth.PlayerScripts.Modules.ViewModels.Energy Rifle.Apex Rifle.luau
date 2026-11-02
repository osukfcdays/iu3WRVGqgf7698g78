local Players = game:GetService("Players")
local EnergyRifle_m = require(Players.LocalPlayer.PlayerScripts.Modules.ViewModels["Energy Rifle"])
local ApexBeamTracerEffect = Players.LocalPlayer.PlayerScripts.Assets.Misc:WaitForChild(
    "ApexBeamTracerEffect"
)
local t = setmetatable({}, EnergyRifle_m)
t.__index = t

function t.new(...) -- line: 10
    -- upvalues:
    --  [1] EnergyRifle_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(EnergyRifle_m.new(...), t)
    t_1:_Init()

    return t_1
end

function t.GetTracerTemplate(_) -- line: 22
    -- upvalues:
    --  [1] ApexBeamTracerEffect (copy)

    return ApexBeamTracerEffect
end

function t._Init(_) -- line: 30
end

return t
