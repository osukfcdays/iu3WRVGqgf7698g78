local Flamethrower_m = require(
    game:GetService("Players").LocalPlayer.PlayerScripts.Modules.ViewModels.Flamethrower
)
local t = setmetatable({}, Flamethrower_m)
t.__index = t

function t.new(...) -- line: 8
    -- upvalues:
    --  [1] Flamethrower_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(Flamethrower_m.new(...), t)
    t_1:_Init()

    return t_1
end

function t.PlayAirblastSoundEffect(arg1) -- line: 20
    arg1:CreateSound("rbxassetid://17772394926", 1, 1, true)
end

function t._CreateFlameSoundEffects(arg2) -- line: 28
    return { arg2:CreateSound("rbxassetid://17772394725", 2, 1.25, true) }
end

function t._Init(_) -- line: 32
end

return t
