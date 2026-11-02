local Knife_m = require(
    game:GetService("Players").LocalPlayer.PlayerScripts.Modules:WaitForChild("ViewModels"):WaitForChild(
        "Knife"
    )
)
local t = setmetatable({}, Knife_m)
t.__index = t

function t.new(...) -- line: 8
    -- upvalues:
    --  [1] Knife_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(Knife_m.new(...), t)
    t_1:_Init()

    return t_1
end

function t._Init(arg1) -- line: 26
    arg1.Animator:OverridePreviousAnimationsOnPlay(true)
end

return t
