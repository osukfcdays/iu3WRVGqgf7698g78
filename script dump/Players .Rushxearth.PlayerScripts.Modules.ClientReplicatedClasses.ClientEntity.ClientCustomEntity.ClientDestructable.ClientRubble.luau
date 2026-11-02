local ClientDestructable_m = require(
    game:GetService("Players").LocalPlayer.PlayerScripts.Modules.ClientReplicatedClasses.ClientEntity.ClientCustomEntity.ClientDestructable
)
local t = setmetatable({}, ClientDestructable_m)
t.__index = t

function t.new(...) -- line: 8
    -- upvalues:
    --  [1] ClientDestructable_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(ClientDestructable_m.new(...), t)
    t_1.PlayRubbleEffectOnDeath = true
    t_1:_Init()

    return t_1
end

function t._Init(_) -- line: 28
end

return t
