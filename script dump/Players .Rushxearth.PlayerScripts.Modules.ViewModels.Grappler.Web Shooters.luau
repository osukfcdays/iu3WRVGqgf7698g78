local Grappler_m = require(
    game:GetService("Players").LocalPlayer.PlayerScripts.Modules.ViewModels.Grappler
)
local t = setmetatable({}, Grappler_m)
t.__index = t

function t.new(...) -- line: 8
    -- upvalues:
    --  [1] Grappler_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(Grappler_m.new(...), t)
    t_1:_Init()

    return t_1
end

function t.PlayShootSounds(arg1) -- line: 20
    arg1:CreateSound(
        "rbxassetid://100300369951636",
        1.25,
        1 + 0.1 * math.random(),
        true,
        10
    )
    arg1:CreateSound(
        "rbxassetid://131248992892383",
        1.25,
        1 + 0.1 * math.random(),
        true,
        10
    )
end

function t.PlayPullSounds(arg2) -- line: 25
    arg2:CreateSound(
        "rbxassetid://97538682393106",
        1.25,
        1 + 0.1 * math.random(),
        true,
        10
    )
end

function t._Init(_) -- line: 33
end

return t
