local BattleAxe_m = require(
    game:GetService("Players").LocalPlayer.PlayerScripts.Modules.ViewModels["Battle Axe"]
)
local t = setmetatable({}, BattleAxe_m)
t.__index = t

function t.new(...) -- line: 8
    -- upvalues:
    --  [1] BattleAxe_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(BattleAxe_m.new(...), t)
    t_1:_Init()

    return t_1
end

function t._Init(_) -- line: 26
end

return t
