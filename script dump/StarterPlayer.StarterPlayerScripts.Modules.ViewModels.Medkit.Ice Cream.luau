local Medkit_m = require(
    game:GetService("Players").LocalPlayer.PlayerScripts.Modules.ViewModels.Medkit
)
local t = setmetatable({}, Medkit_m)
t.__index = t

function t.new(...) -- line: 8
    -- upvalues:
    --  [1] Medkit_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(Medkit_m.new(...), t)
    t_1.PlayEquipAnimationOnHeal = false
    t_1:_Init()

    return t_1
end

function t._Init(_) -- line: 28
end

return t
