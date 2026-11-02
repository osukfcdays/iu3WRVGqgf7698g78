local BaseCrossbow_m = require(
    game:GetService("Players").LocalPlayer.PlayerScripts.Modules.ViewModels.BaseCrossbow
)
local gradient = ColorSequence.new(Color3.fromRGB(255, 255, 255))
local t = setmetatable({}, BaseCrossbow_m)
t.__index = t

function t.new(...) -- line: 10
    -- upvalues:
    --  [1] BaseCrossbow_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(BaseCrossbow_m.new(...), t)
    t_1:_Init()

    return t_1
end

function t.GetFriendlyTracerColor(_) -- line: 22
    -- upvalues:
    --  [1] gradient (copy)

    return gradient
end

function t._Init(arg2) -- line: 30
    arg2:_RegisterAmmoVisual(arg2.ItemModel:WaitForChild("Arrow"):WaitForChild("MeshPart"))
end

return t
