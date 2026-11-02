local Gun_m = require(game:GetService("Players").LocalPlayer.PlayerScripts.Modules.ItemTypes.Gun)
local t = setmetatable({}, Gun_m)
t.__index = t

function t.new(...) -- line: 8
    -- upvalues:
    --  [1] Gun_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(Gun_m.new(...), t)
    t_1.ToggleAimEnabled = nil
    t_1:_Init()

    return t_1
end

function t.StartAiming(arg1, arg2) -- line: 22
    return arg1:StartShooting(arg2, true)
end

function t.FinishAiming(_, _) -- line: 26
    return false
end

function t.StartSprinting(_, _) -- line: 30
    return false
end

function t._Init(_) -- line: 38
end

return t
