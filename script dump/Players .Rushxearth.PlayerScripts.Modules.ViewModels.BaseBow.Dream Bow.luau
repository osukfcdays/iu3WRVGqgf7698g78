local BaseBow_m = require(
    game:GetService("Players").LocalPlayer.PlayerScripts.Modules.ViewModels.BaseBow
)
local t = setmetatable({}, BaseBow_m)
t.__index = t

function t.new(...) -- line: 8
    -- upvalues:
    --  [1] BaseBow_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(BaseBow_m.new(...), t)
    t_1:_Init()

    return t_1
end

function t._Init(arg1) -- line: 26
    arg1:_RegisterAmmoVisual(arg1.ItemModel:WaitForChild("Arrow"):WaitForChild("Cloud"))
    arg1:_RegisterAmmoVisual(arg1.ItemModel:WaitForChild("Arrow"):WaitForChild("Stick"))
    arg1:_RegisterAmmoVisual(arg1.ItemModel:WaitForChild("Arrow"):WaitForChild("Tip"))
end

return t
