local Minigun_m = require(
    game:GetService("Players").LocalPlayer.PlayerScripts.Modules.ViewModels.Minigun
)
local t = setmetatable({}, Minigun_m)
t.__index = t

function t.new(...) -- line: 8
    -- upvalues:
    --  [1] Minigun_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(Minigun_m.new(...), t)
    t_1:_Init()

    return t_1
end

function t._CreateMinigunShootingSounds(arg1) -- line: 26
    local v2 = arg1:CreateSound("rbxassetid://112116120783481", 8.75, 1, true)
    v2.TimePosition = 0.25 + 0.25 * math.random()
    v2.Looped = true

    return { v2 }
end

function t._CreateMinigunWindingSounds(arg2) -- line: 34
    local v3 = arg2:CreateSound("rbxassetid://111731354794881", 0.5, 1, true)
    v3.TimePosition = 2
    v3.Looped = true

    return { v3 }
end

function t._Init(_) -- line: 42
end

return t
