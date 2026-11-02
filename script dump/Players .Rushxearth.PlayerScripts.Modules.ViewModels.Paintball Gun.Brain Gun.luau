local PaintballGun_m = require(
    game:GetService("Players").LocalPlayer.PlayerScripts.Modules.ViewModels["Paintball Gun"]
)
local color = Color3.fromRGB(255, 116, 165)
local t = setmetatable({}, PaintballGun_m)
t.__index = t

function t.new(...) -- line: 10
    -- upvalues:
    --  [1] PaintballGun_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(PaintballGun_m.new(...), t)
    t_1:_Init()

    return t_1
end

function t.GetPaintballColor(_) -- line: 22
    -- upvalues:
    --  [1] color (copy)

    return color
end

function t._Init(_) -- line: 30
end

return t
