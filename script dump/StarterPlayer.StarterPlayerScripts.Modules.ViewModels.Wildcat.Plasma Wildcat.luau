local Wildcat_m = require(
    game:GetService("Players").LocalPlayer.PlayerScripts.Modules.ViewModels.Wildcat
)
local gradient = ColorSequence.new(Color3.fromRGB(149, 43, 255))
local t = setmetatable({}, Wildcat_m)
t.__index = t

function t.new(...) -- line: 10
    -- upvalues:
    --  [1] Wildcat_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(Wildcat_m.new(...), t)
    t_1:_Init()

    return t_1
end

function t.GetFriendlyTracerColor(_) -- line: 22
    -- upvalues:
    --  [1] gradient (copy)

    return gradient
end

function t._Init(_) -- line: 30
end

return t
