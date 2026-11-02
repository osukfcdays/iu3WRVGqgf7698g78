local Minigun_m = require(
    game:GetService("Players").LocalPlayer.PlayerScripts.Modules.ViewModels.Minigun
)
local gradient = ColorSequence.new(Color3.fromRGB(255, 0, 0))
local t = setmetatable({}, Minigun_m)
t.__index = t

function t.new(...) -- line: 10
    -- upvalues:
    --  [1] Minigun_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(Minigun_m.new(...), t)
    t_1:_Init()

    return t_1
end

function t.GetFriendlyTracerColor(_) -- line: 22
    -- upvalues:
    --  [1] gradient (copy)

    return gradient
end

function t._CreateMinigunShootingSounds(arg2) -- line: 30
    local v3 = arg2:CreateSound("rbxassetid://17722581026", 0.75, 1, true)
    v3.TimePosition = 0.5 * math.random()
    v3.Looped = true
    local v4 = arg2:CreateSound("rbxassetid://17722580791", 0.75, 1, true)
    v4.TimePosition = 0.5 * math.random()
    v4.Looped = true
    local v5 = arg2:CreateSound("rbxassetid://17722580585", 0.75, 1, true)
    v5.TimePosition = 0.5 * math.random()
    v5.Looped = true

    return { v3, v4, v5 }
end

function t._CreateMinigunWindingSounds(arg3) -- line: 50
    local v6 = arg3:CreateSound("rbxassetid://17722633119", 0.25, 1, true)
    v6.Looped = true

    return { v6 }
end

function t._Init(_) -- line: 57
end

return t
