local ClientMap_m = require(
    game:GetService("Players").LocalPlayer.PlayerScripts.Modules.ClientReplicatedClasses.ClientDuel.ClientMap
)
local t = { "Museum - Day", "Museum - Dusk", "Museum - Night" }
local t_1 = setmetatable({}, ClientMap_m)
t_1.__index = t_1

function t_1.new(...) -- line: 10
    -- upvalues:
    --  [1] ClientMap_m (copy)
    --  [2] t_1 (copy)

    local t_2 = setmetatable(ClientMap_m.new(...), t_1)
    t_2:_Init()

    return t_2
end

function t_1._Init(arg1) -- line: 28
    -- upvalues:
    --  [1] t (copy)

    arg1:SetReplicate("LightingProfileOverride", t[Random.new(arg1._seed):NextInteger(1, #t)])
end

return t_1
