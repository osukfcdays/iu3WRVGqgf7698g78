local t = {}
t.__index = t

function t.new(arg1, ...) -- line: 4
    -- upvalues:
    --  [1] t (copy)

    local t_1 = setmetatable({}, t)
    t_1._interval = arg1
    t_1._references = { ... }
    t_1._connections = {}
    t_1._colors = {}
    t_1._formatted = {}
    t_1._next_update = 0
    t_1._offset = 0
    t_1:_Init()

    return t_1
end

function t.Update(arg2, _) -- line: 24
    if tick() < arg2._next_update then
        return
    end

    arg2._next_update = tick() + arg2._interval
    arg2._offset += 1

    for key, val in pairs(arg2._formatted) do
        val.Reference.Transparency = 1
        val.Visual.Transparency = 0
        val.Visual.Color = arg2._colors[(key + arg2._offset) % #arg2._colors + 1]
    end
end

function t.Destroy(arg4) -- line: 39
    for _, val_1 in pairs(arg4._connections) do
        val_1:Disconnect()
    end

    arg4._connections = {}
    arg4._references = {}
    arg4._formatted = {}
end

function t._UpdateColors(arg5) -- line: 53
    arg5._colors = {}
    arg5._next_update = 0

    for _, val_2 in pairs(arg5._references) do
        table.insert(arg5._colors, val_2.Color)
    end

    arg5:Update(0)
end

function t._Setup(arg6) -- line: 64
    for _, val_3 in pairs(arg6._references) do
        table.insert(arg6._connections, val_3:GetPropertyChangedSignal("Color"):Connect(function() -- line: 66
            -- upvalues:
            --  [1] arg6 (copy)

            arg6:_UpdateColors()
        end))
        local t_3 = { Reference = val_3, Visual = val_3:WaitForChild("Visual") }
        table.insert(arg6._formatted, t_3)
    end
end

function t._Init(arg7) -- line: 74
    arg7:_Setup()
    arg7:_UpdateColors()
end

return t
