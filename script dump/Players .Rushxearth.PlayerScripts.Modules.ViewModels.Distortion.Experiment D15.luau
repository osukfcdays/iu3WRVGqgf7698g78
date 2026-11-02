local Players = game:GetService("Players")
local Distortion_m = require(Players.LocalPlayer.PlayerScripts.Modules.ViewModels.Distortion)
local ExperimentD15ExplosionParticles = Players.LocalPlayer.PlayerScripts.Assets.Misc:WaitForChild(
    "ExperimentD15ExplosionParticles"
)
local gradient = ColorSequence.new(Color3.fromRGB(208, 255, 0))
local t = setmetatable({}, Distortion_m)
t.__index = t

function t.new(...) -- line: 11
    -- upvalues:
    --  [1] Distortion_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(Distortion_m.new(...), t)
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
    --  [1] Distortion_m (copy)
    --  [2] ExperimentD15ExplosionParticles (copy)

    Distortion_m.ExplosionEffect(arg2, arg3, arg4, ExperimentD15ExplosionParticles)
end

function t._Init(_) -- line: 35
end

return t
