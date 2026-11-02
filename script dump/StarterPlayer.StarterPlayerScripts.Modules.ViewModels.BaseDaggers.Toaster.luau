local BaseDaggers_m = require(
    game:GetService("Players").LocalPlayer.PlayerScripts.Modules.ViewModels.BaseDaggers
)
local t = setmetatable({}, BaseDaggers_m)
t.__index = t

function t.new(...) -- line: 8
    -- upvalues:
    --  [1] BaseDaggers_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(BaseDaggers_m.new(...), t)
    t_1.DontUseAmmoReserveToChangeCoreAnimations = true
    t_1:_Init()

    return t_1
end

function t._Init(arg1) -- line: 28
    arg1:_RegisterAmmoVisual(arg1.ItemModel:WaitForChild("Toast 1"):WaitForChild("MeshPart1"), 1)
    arg1:_RegisterAmmoVisual(arg1.ItemModel:WaitForChild("Toast 1"):WaitForChild("MeshPart2"), 1)
    arg1:_RegisterAmmoVisual(arg1.ItemModel:WaitForChild("Toast 2"):WaitForChild("MeshPart1"), 2)
    arg1:_RegisterAmmoVisual(arg1.ItemModel:WaitForChild("Toast 2"):WaitForChild("MeshPart2"), 2)
end

return t
