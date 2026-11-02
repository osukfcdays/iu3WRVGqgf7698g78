local t = {}
t.__index = t

function t.new(arg1) -- line: 4
    -- upvalues:
    --  [1] t (copy)

    local t_1 = setmetatable({}, t)
    t_1.Model = arg1
    t_1._destroyed = false
    t_1._original_scale = t_1.Model:GetScale()
    t_1:_Init()

    return t_1
end

function t.GetPivot(arg2) -- line: 21
    return arg2.Model:GetPivot()
end

function t.SetParent(arg3, arg4) -- line: 25
    arg3.Model.Parent = arg4
end

function t.SetArchivable(arg5, arg6) -- line: 29
    for _, descendant in pairs(arg5.Model:GetDescendants()) do
        if descendant:IsA("BasePart") then
            descendant.Archivable = arg6
        end
    end
end

function t.ScaleTo(arg7, arg8) -- line: 37
    arg7.Model:ScaleTo(arg7._original_scale * arg8)
end

function t.PivotTo(arg9, arg10, arg11) -- line: 41
    local Model = arg9.Model
    local v3 = arg11 or arg9.Model.WorldPivot
    Model.WorldPivot = v3
    arg9.Model:PivotTo(arg10)
    arg9:Update(0)
end

function t.Update(_, _) -- line: 47
end

function t.Destroy(arg14) -- line: 51
    arg14._destroyed = true
    arg14.Model:Destroy()
end

function t._Init(_) -- line: 60
end

return t
