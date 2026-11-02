local BaseRevolver_m = require(
    game:GetService("Players").LocalPlayer.PlayerScripts.Modules.ViewModels.BaseRevolver
)
local t = setmetatable({}, BaseRevolver_m)
t.__index = t

function t.new(...) -- line: 8
    -- upvalues:
    --  [1] BaseRevolver_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(BaseRevolver_m.new(...), t)
    t_1:_Init()

    return t_1
end

function t._Init(arg1) -- line: 26
    arg1:_RegisterDefaultAmmoVisuals()
end

return t
