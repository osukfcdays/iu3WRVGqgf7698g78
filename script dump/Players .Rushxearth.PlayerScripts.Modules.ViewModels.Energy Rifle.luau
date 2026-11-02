local Players = game:GetService("Players")
local ClientViewModel_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("ClientReplicatedClasses"):WaitForChild(
        "ClientFighter"
    ):WaitForChild("ClientItem"):WaitForChild("ClientViewModel")
)
local EnergyBeamTracerEffect = Players.LocalPlayer.PlayerScripts.Assets.Misc:WaitForChild(
    "EnergyBeamTracerEffect"
)
local t = setmetatable({}, ClientViewModel_m)
t.__index = t

function t.new(...) -- line: 10
    -- upvalues:
    --  [1] ClientViewModel_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(ClientViewModel_m.new(...), t)
    t_1:_Init()

    return t_1
end

function t.GetTracerTemplate(_) -- line: 22
    -- upvalues:
    --  [1] EnergyBeamTracerEffect (copy)

    return EnergyBeamTracerEffect
end

function t._Init(_) -- line: 30
end

return t
