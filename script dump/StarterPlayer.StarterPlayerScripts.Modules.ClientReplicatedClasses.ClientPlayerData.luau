local ReplicatedClass_m = require(
    game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("ReplicatedClass")
)
local t = setmetatable({}, ReplicatedClass_m)
t.__index = t

function t.new(arg1) -- line: 9
    -- upvalues:
    --  [1] ReplicatedClass_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(ReplicatedClass_m.new(arg1, true), t)
    t_1:_Init()

    return t_1
end

function t._Init(_) -- line: 27
end

return t
