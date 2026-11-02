local Fists_m = require(
    game:GetService("Players").LocalPlayer.PlayerScripts.Modules.ViewModels.Fists
)
local t = setmetatable({}, Fists_m)
t.__index = t

function t.new(...) -- line: 8
    -- upvalues:
    --  [1] Fists_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(Fists_m.new(...), t)
    t_1.LeftArmIKControlDisabled = true
    t_1:_Init()

    return t_1
end

function t._Init(_) -- line: 28
end

return t
