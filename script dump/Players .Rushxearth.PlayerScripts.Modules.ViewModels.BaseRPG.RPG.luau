local BaseRPG_m = require(
    game:GetService("Players").LocalPlayer.PlayerScripts.Modules.ViewModels.BaseRPG
)
local t = setmetatable({}, BaseRPG_m)
t.__index = t

function t.new(...) -- line: 8
    -- upvalues:
    --  [1] BaseRPG_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(BaseRPG_m.new(...), t)
    t_1:_Init()

    return t_1
end

function t._Init(arg1) -- line: 26
    arg1:_RegisterAmmoVisual(arg1.ItemModel:WaitForChild("Rocket"):WaitForChild("Head"))
    arg1:_RegisterAmmoVisual(arg1.ItemModel:WaitForChild("Rocket"):WaitForChild("Neck"))
end

return t
