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

function t.PlayServer(arg1) -- line: 20
    arg1:_Ragdoll()
    arg1:_AnchorModel()
end

function t.PlayClient(_) -- line: 25
end

function t._Init(_) -- line: 33
end

return t
