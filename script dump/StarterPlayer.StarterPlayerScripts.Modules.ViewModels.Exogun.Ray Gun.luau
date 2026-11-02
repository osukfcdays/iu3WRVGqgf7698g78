local Players = game:GetService("Players")
local Exogun_m = require(Players.LocalPlayer.PlayerScripts.Modules.ViewModels.Exogun)
local RayGunExplosionParticles = Players.LocalPlayer.PlayerScripts.Assets.Misc:WaitForChild(
    "RayGunExplosionParticles"
)
local gradient = ColorSequence.new(Color3.fromRGB(255, 204, 0))
local t = setmetatable({}, Exogun_m)
t.__index = t

function t.new(...) -- line: 11
    -- upvalues:
    --  [1] Exogun_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(Exogun_m.new(...), t)
    t_1:_Init()

    return t_1
end

function t.GetFriendlyTracerColor(_) -- line: 23
    -- upvalues:
    --  [1] gradient (copy)

    return gradient
end

function t.ExplosionEffect(arg2, arg3, arg4) -- line: 27
    -- upvalues:
    --  [1] Exogun_m (copy)
    --  [2] RayGunExplosionParticles (copy)

    Exogun_m.ExplosionEffect(arg2, arg3, arg4, RayGunExplosionParticles)
end

function t._Init(_) -- line: 35
end

return t
