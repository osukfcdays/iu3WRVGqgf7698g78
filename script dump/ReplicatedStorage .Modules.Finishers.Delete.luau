local Finisher_m = require(game:GetService("ReplicatedStorage").Modules.Finisher)
local t = setmetatable({}, Finisher_m)
t.__index = t

function t.new(...) -- line: 8
    -- upvalues:
    --  [1] Finisher_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(Finisher_m.new(...), t)
    t_1:_Init()

    return t_1
end

function t.PlayClient(arg1, ...) -- line: 20
    arg1:_HideBody()
end

function t._Init(_) -- line: 28
end

return t
