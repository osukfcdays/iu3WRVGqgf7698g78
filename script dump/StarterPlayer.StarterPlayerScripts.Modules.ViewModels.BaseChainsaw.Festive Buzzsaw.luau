local Players = game:GetService("Players")
local FestiveLightsCircuit_m = require(
    Players.LocalPlayer.PlayerScripts.Modules.FestiveLightsCircuit
)
local BaseChainsaw_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("ViewModels"):WaitForChild(
        "BaseChainsaw"
    )
)
local t = setmetatable({}, BaseChainsaw_m)
t.__index = t

function t.new(...) -- line: 9
    -- upvalues:
    --  [1] BaseChainsaw_m (copy)
    --  [2] t (copy)
    --  [3] FestiveLightsCircuit_m (copy)

    local t_1 = setmetatable(BaseChainsaw_m.new(...), t)
    t_1._festive_lights_circuit_body = FestiveLightsCircuit_m.new(
        0.5,
        t_1.ItemModel:WaitForChild("Body"):WaitForChild("Light1"),
        t_1.ItemModel:WaitForChild("Body"):WaitForChild("Light2"),
        t_1.ItemModel:WaitForChild("Body"):WaitForChild("Light3")
    )
    t_1._festive_lights_circuit_spin = FestiveLightsCircuit_m.new(
        0.1,
        t_1.ItemModel:WaitForChild("Spin"):WaitForChild("Light1"),
        t_1.ItemModel:WaitForChild("Spin"):WaitForChild("Light2"),
        t_1.ItemModel:WaitForChild("Spin"):WaitForChild("Light3")
    )
    t_1:_Init()

    return t_1
end

function t.Update(arg1, arg2, arg3, arg4) -- line: 24
    -- upvalues:
    --  [1] BaseChainsaw_m (copy)

    BaseChainsaw_m.Update(arg1, arg2, arg3, arg4)

    if not arg4.IsActive then
        return
    end

    arg1._festive_lights_circuit_body:Update(arg2)
    arg1._festive_lights_circuit_spin:Update(arg2)
end

function t.Destroy(arg5) -- line: 35
    -- upvalues:
    --  [1] BaseChainsaw_m (copy)

    arg5._festive_lights_circuit_body:Destroy()
    arg5._festive_lights_circuit_spin:Destroy()
    BaseChainsaw_m.Destroy(arg5)
end

function t._Init(_) -- line: 45
end

return t
