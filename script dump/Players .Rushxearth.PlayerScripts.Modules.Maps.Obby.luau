local ClientMap_m = require(
    game:GetService("Players").LocalPlayer.PlayerScripts.Modules.ClientReplicatedClasses.ClientDuel.ClientMap
)
local t = setmetatable({}, ClientMap_m)
t.__index = t

function t.new(...) -- line: 8
    -- upvalues:
    --  [1] ClientMap_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(ClientMap_m.new(...), t)
    t_1:_Init()

    return t_1
end

function t._Init(arg1) -- line: 26
    arg1.ClientDuel:SetReplicate("DuelMusic", "Obby")
end

return t
