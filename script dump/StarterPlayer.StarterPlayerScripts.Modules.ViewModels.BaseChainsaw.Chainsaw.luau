local BaseChainsaw_m = require(
    game:GetService("Players").LocalPlayer.PlayerScripts.Modules:WaitForChild("ViewModels"):WaitForChild(
        "BaseChainsaw"
    )
)
local t = setmetatable({}, BaseChainsaw_m)
t.__index = t

function t.new(...) -- line: 8
    -- upvalues:
    --  [1] BaseChainsaw_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(BaseChainsaw_m.new(...), t)
    t_1:_Init()

    return t_1
end

function t._Init(arg1) -- line: 26
    arg1:_RegisterBlade(arg1.ItemModel:WaitForChild("Body"):WaitForChild("Blade"))
    arg1:_RegisterSpikesPart(arg1.ItemModel:WaitForChild("Body"):WaitForChild("Spikes1"), true)
    arg1:_RegisterSpikesPart(arg1.ItemModel:WaitForChild("Body"):WaitForChild("Spikes2"), false)
end

return t
