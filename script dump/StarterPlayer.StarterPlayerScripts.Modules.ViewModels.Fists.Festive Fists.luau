local Players = game:GetService("Players")
local FestiveLightsCircuit_m = require(
    Players.LocalPlayer.PlayerScripts.Modules.FestiveLightsCircuit
)
local Fists_m = require(Players.LocalPlayer.PlayerScripts.Modules.ViewModels.Fists)
local t = setmetatable({}, Fists_m)
t.__index = t

function t.new(...) -- line: 9
    -- upvalues:
    --  [1] Fists_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(Fists_m.new(...), t)
    t_1._festive_lights_circuits = {}
    t_1:_Init()

    return t_1
end

function t.Update(arg1, arg2, arg3, arg4) -- line: 23
    -- upvalues:
    --  [1] Fists_m (copy)

    Fists_m.Update(arg1, arg2, arg3, arg4)

    if not arg4.IsActive then
        return
    end

    for _, val in pairs(arg1._festive_lights_circuits) do
        val:Update(arg2)
    end
end

function t.Destroy(arg5) -- line: 35
    -- upvalues:
    --  [1] Fists_m (copy)

    for _, val_1 in pairs(arg5._festive_lights_circuits) do
        val_1:Destroy()
    end

    Fists_m.Destroy(arg5)
end

function t._Setup(arg6) -- line: 47
    -- upvalues:
    --  [1] FestiveLightsCircuit_m (copy)

    for key_2, _ in pairs(arg6._arm_submodels) do
        local FestiveLightsCircuits = arg6._festive_lights_circuits
        local New = FestiveLightsCircuit_m.new
        local Light1 = key_2:WaitForChild("Light1")
        table.insert(
            FestiveLightsCircuits,
            New(0.5, Light1, key_2:WaitForChild("Light2"), key_2:WaitForChild("Light3"))
        )
    end
end

function t._Init(arg7) -- line: 53
    arg7:_Setup()
end

return t
