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
    arg1:CreateSound(
        "rbxassetid://17209245422",
        1,
        1,
        true,
        5
    )
    arg1:CreateSound(
        "rbxassetid://113753648748200",
        1.125,
        1 + 0.1 * math.random(),
        true,
        10
    )
end

function t._CreateFlameSoundEffects(arg2) -- line: 29
    return { arg2:CreateSound("rbxassetid://100941596743597", 1.5, 1, true) }
end

function t._Init(_) -- line: 33
end

return t
