local AssaultRifle_m = require(
    game:GetService("Players").LocalPlayer.PlayerScripts.Modules.ViewModels["Assault Rifle"]
)
local gradient = ColorSequence.new(Color3.fromRGB(255, 215, 246))
local t = setmetatable({}, AssaultRifle_m)
t.__index = t

function t.new(...) -- line: 10
    -- upvalues:
    --  [1] AssaultRifle_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(AssaultRifle_m.new(...), t)
    t_1:_Init()

    return t_1
end

function t.GetFriendlyTracerColor(_) -- line: 22
    -- upvalues:
    --  [1] gradient (copy)

    return gradient
end

function t._Init(_) -- line: 30
end

return t
