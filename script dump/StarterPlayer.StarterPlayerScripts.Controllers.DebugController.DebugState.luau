local ReplicatedClass_m = require(game:GetService("ReplicatedStorage").Modules.ReplicatedClass)
local t = setmetatable({}, ReplicatedClass_m)
t.__index = t

function t._new() -- line: 8
    -- upvalues:
    --  [1] ReplicatedClass_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(ReplicatedClass_m.new(), t)
    t_1.Data.AreHandicapsEnabled = false
    t_1.Data.DisableTransparentHats = false
    t_1:_Init()

    return t_1
end

function t._Init(_) -- line: 29
end

return t._new()
