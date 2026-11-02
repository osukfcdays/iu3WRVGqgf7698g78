local EnergyPistols_m = require(
    game:GetService("Players").LocalPlayer.PlayerScripts.Modules.ViewModels["Energy Pistols"]
)
local t = setmetatable({}, EnergyPistols_m)
t.__index = t

function t.new(...) -- line: 8
    -- upvalues:
    --  [1] EnergyPistols_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(EnergyPistols_m.new(...), t)
    t_1:_Init()

    return t_1
end

function t.PlayAimSound(arg1, arg2) -- line: 20
    arg1:CreateSound(
        "rbxassetid://96253147006478",
        0.375,
        2 + (if not arg2 then 0 else 0.1),
        true,
        5
    )
end

function t._Init(_) -- line: 28
end

return t
