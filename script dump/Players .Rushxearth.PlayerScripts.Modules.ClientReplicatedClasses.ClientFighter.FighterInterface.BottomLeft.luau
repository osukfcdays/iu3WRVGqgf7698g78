local t = {}
t.__index = t

function t.new(arg1) -- line: 4
    -- upvalues:
    --  [1] t (copy)

    local t_1 = setmetatable({}, t)
    t_1.FighterInterface = arg1
    t_1.Frame = t_1.FighterInterface.Frame:WaitForChild("BottomLeft")
    t_1.Container = t_1.Frame:WaitForChild("Container")
    t_1:_Init()

    return t_1
end

function t.SetVisible(arg2, arg3) -- line: 20
    arg2.Frame.Visible = arg3
end

function t.Destroy(_) -- line: 24
end

function t._Init(_) -- line: 32
end

return t
