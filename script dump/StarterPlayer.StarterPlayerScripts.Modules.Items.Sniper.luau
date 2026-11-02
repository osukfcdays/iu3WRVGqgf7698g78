local Gun_m = require(game:GetService("Players").LocalPlayer.PlayerScripts.Modules.ItemTypes.Gun)
local t = setmetatable({}, Gun_m)
t.__index = t

function t.new(...) -- line: 8
    -- upvalues:
    --  [1] Gun_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(Gun_m.new(...), t)
    t_1:_Init()

    return t_1
end

function t.GetAutoShootReactionTime(arg1) -- line: 20
    -- upvalues:
    --  [1] Gun_m (copy)

    if arg1:IsFullyAiming() then
        return (Gun_m.GetAutoShootReactionTime(arg1))
    end

    return nil
end

function t._Init(_) -- line: 28
end

return t
