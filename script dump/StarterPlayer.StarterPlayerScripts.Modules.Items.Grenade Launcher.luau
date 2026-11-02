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

function t.StartAiming(arg1, ...) -- line: 22
    local v2, _, v4, v5 = arg1:StartShooting(...)

    if not v2 then
        return false
    end

    return true, "StartAiming", v4, v5
end

function t.FinishAiming(_, _) -- line: 32
    return false
end

function t._Init(_) -- line: 40
end

return t
