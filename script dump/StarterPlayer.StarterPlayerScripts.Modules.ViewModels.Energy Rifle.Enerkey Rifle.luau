local Players = game:GetService("Players")
local EnergyRifle_m = require(Players.LocalPlayer.PlayerScripts.Modules.ViewModels["Energy Rifle"])
local KeyBeamTracerEffect = Players.LocalPlayer.PlayerScripts.Assets.Misc:WaitForChild(
    "KeyBeamTracerEffect"
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
    --  [1] KeyBeamTracerEffect (copy)

    return KeyBeamTracerEffect
end

function t.PlayAimSound(arg2, arg3) -- line: 26
    arg2:CreateSound(
        "rbxassetid://96253147006478",
        0.375,
        2 + (if not arg3 then 0 else 0.1),
        true,
        5
    )
end

function t._Init(_) -- line: 34
end

return t
