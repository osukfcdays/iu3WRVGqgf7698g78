local t = {}
t.__index = t

function t.new(arg1, arg2) -- line: 4
    -- upvalues:
    --  [1] t (copy)

    local t_1 = setmetatable({}, t)
    t_1.DisplayName = arg1
    t_1.Image = arg2
    t_1:_Init()

    return t_1
end

function t._Init(_) -- line: 25
end

return t
