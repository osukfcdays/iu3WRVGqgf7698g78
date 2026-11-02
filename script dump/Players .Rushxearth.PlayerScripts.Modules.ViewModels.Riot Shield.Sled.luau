local RiotShield_m = require(
    game:GetService("Players").LocalPlayer.PlayerScripts.Modules:WaitForChild("ViewModels"):WaitForChild(
        "Riot Shield"
    )
)
local t = setmetatable({}, RiotShield_m)
t.__index = t

function t.new(...) -- line: 8
    -- upvalues:
    --  [1] RiotShield_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(RiotShield_m.new(...), t)
    t_1:_Init()

    return t_1
end

function t._Init(_) -- line: 26
end

return t
