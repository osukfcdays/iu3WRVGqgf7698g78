local SubspaceTripmine_m = require(
    game:GetService("Players").LocalPlayer.PlayerScripts.Modules.ViewModels["Subspace Tripmine"]
)
local t = setmetatable({}, SubspaceTripmine_m)
t.__index = t

function t.new(...) -- line: 8
    -- upvalues:
    --  [1] SubspaceTripmine_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(SubspaceTripmine_m.new(...), t)
    t_1:_Init()

    return t_1
end

function t._Init(_) -- line: 26
end

return t
