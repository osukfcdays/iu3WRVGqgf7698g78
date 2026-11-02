local Players = game:GetService("Players")
local FestiveLightsCircuit_m = require(
    Players.LocalPlayer.PlayerScripts.Modules.FestiveLightsCircuit
)
local Exogun_m = require(Players.LocalPlayer.PlayerScripts.Modules.ViewModels.Exogun)
local MidnightFestiveExogunExplosionParticles = Players.LocalPlayer.PlayerScripts.Assets.Misc:WaitForChild(
    "MidnightFestiveExogunExplosionParticles"
)
local gradient = ColorSequence.new(Color3.fromRGB(22, 5, 255))
local t = setmetatable({}, Exogun_m)
t.__index = t

function t.new(...) -- line: 12
    -- upvalues:
    --  [1] Exogun_m (copy)
    --  [2] t (copy)
    --  [3] FestiveLightsCircuit_m (copy)

    local t_1 = setmetatable(Exogun_m.new(...), t)
    t_1._festive_lights_circuit = FestiveLightsCircuit_m.new(
        0.5,
        t_1.ItemModel:WaitForChild("Body"):WaitForChild("Light1"),
        t_1.ItemModel:WaitForChild("Body"):WaitForChild("Light2"),
        t_1.ItemModel:WaitForChild("Body"):WaitForChild("Light3")
    )
    t_1:_Init()

    return t_1
end

function t.GetFriendlyTracerColor(_) -- line: 26
    -- upvalues:
    --  [1] gradient (copy)

    return gradient
end

function t.ExplosionEffect(arg2, arg3, arg4) -- line: 30
    -- upvalues:
    --  [1] Exogun_m (copy)
    --  [2] MidnightFestiveExogunExplosionParticles (copy)

    Exogun_m.ExplosionEffect(arg2, arg3, arg4, MidnightFestiveExogunExplosionParticles)
end

function t.Update(arg5, arg6, arg7, arg8) -- line: 34
    -- upvalues:
    --  [1] Exogun_m (copy)

    Exogun_m.Update(arg5, arg6, arg7, arg8)

    if not arg8.IsActive then
        return
    end

    arg5._festive_lights_circuit:Update(arg6)
end

function t.Destroy(arg9) -- line: 44
    -- upvalues:
    --  [1] Exogun_m (copy)

    arg9._festive_lights_circuit:Destroy()
    Exogun_m.Destroy(arg9)
end

function t._Init(_) -- line: 53
end

return t
