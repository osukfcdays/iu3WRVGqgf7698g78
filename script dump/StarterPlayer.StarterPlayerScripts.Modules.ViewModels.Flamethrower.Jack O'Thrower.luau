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

function t._Init(_) -- line: 26
end

return t
