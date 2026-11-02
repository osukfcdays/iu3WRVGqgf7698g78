local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local Exogun_m = require(Players.LocalPlayer.PlayerScripts.Modules.ViewModels.Exogun)
local PearlExogunExplosionParticles = Players.LocalPlayer.PlayerScripts.Assets.Misc:WaitForChild(
    "PearlExogunExplosionParticles"
)
local gradient = ColorSequence.new(Color3.fromRGB(255, 215, 246))
local t = setmetatable({}, Exogun_m)
t.__index = t

function t.new(...) -- line: 13
    -- upvalues:
    --  [1] Exogun_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(Exogun_m.new(...), t)
    t_1:_Init()

    return t_1
end

function t.GetFriendlyTracerColor(_) -- line: 25
    -- upvalues:
    --  [1] gradient (copy)

    return gradient
end

function t.ExplosionEffect(arg2, arg3, arg4) -- line: 29
    -- upvalues:
    --  [1] Exogun_m (copy)
    --  [2] PearlExogunExplosionParticles (copy)
    --  [3] Utility_m (copy)

    Exogun_m.ExplosionEffect(arg2, arg3, arg4, PearlExogunExplosionParticles)
    Utility_m:CreateSound(
        "rbxassetid://121938614359106",
        1,
        1 + 0.25 * math.random(),
        arg3,
        true,
        10
    )
end

function t._Init(_) -- line: 38
end

return t
