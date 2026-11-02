local BaseCrossbow_m = require(
    game:GetService("Players").LocalPlayer.PlayerScripts.Modules.ViewModels.BaseCrossbow
)
local t = setmetatable({}, BaseCrossbow_m)
t.__index = t

function t.new(...) -- line: 8
    -- upvalues:
    --  [1] BaseCrossbow_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(BaseCrossbow_m.new(...), t)
    t_1:_Init()

    return t_1
end

function t._Init(arg1) -- line: 26
    arg1:_RegisterAmmoVisual(arg1.ItemModel:WaitForChild("Arrow"):WaitForChild("Feather"))
    arg1:_RegisterAmmoVisual(arg1.ItemModel:WaitForChild("Arrow"):WaitForChild("Stick"))
    arg1:_RegisterAmmoVisual(arg1.ItemModel:WaitForChild("Arrow"):WaitForChild("Tip"))
end

return t
