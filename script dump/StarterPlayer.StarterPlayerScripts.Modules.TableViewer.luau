local Utility_m = require(game:GetService("ReplicatedStorage").Modules.Utility)
local Entry = script:WaitForChild("Entry")
local Gui = script:WaitForChild("Gui")
local t = {}
t.__index = t

function t.new(arg1) -- line: 12
    -- upvalues:
    --  [1] t (copy)
    --  [2] Gui (copy)

    local t_1 = setmetatable({}, t)
    t_1.Root = arg1
    t_1.ScreenGui = Gui:Clone()
    t_1._entry_to_children = {}
    t_1._entry_to_parent = {}
    t_1:_Init()

    return t_1
end

function t.Destroy(arg2) -- line: 30
    arg2.ScreenGui:Destroy()
    arg2._entry_to_children = nil
    arg2._entry_to_parent = nil
    arg2.Root = nil
end

function t._GetTabString(_, arg4) -- line: 41
    return string.rep(" <font transparency=\"0.75\">|</font>  ", arg4)
end

function t._ColorBasedOnType(_, arg6, arg7) -- line: 45
    if typeof(arg7) == "string" then
        return "<font color=\"rgb(0,255,0)\">" .. arg6 .. "</font>"
    end

    if typeof(arg7) == "number" then
        return "<font color=\"rgb(255,198,0)\">" .. arg6 .. "</font>"
    end

    if typeof(arg7) == "boolean" then
        return "<font color=\"rgb(8,123,255)\">" .. arg6 .. "</font>"
    end

    if typeof(arg7) == "Instance" then
        return arg7.ClassName .. ": <font color=\"rgb(0,255,0)\">\"" .. arg6 .. "\"</font>"
    end

    return arg6
end

function t._DeleteDescendants(arg8, arg9) -- line: 59
    local v1 = pairs
    local v2 = arg8._entry_to_children[arg9] or {}

    for _, val in v1(v2) do
        arg8:_DeleteDescendants(val)
        arg8._entry_to_children[val] = nil
        arg8._entry_to_parent[val] = nil
        val:Destroy()
    end
end

function t._CreateEntry(arg10, arg11) -- line: 68
    -- upvalues:
    --  [1] Entry (copy)

    local v3 = Entry:Clone()
    arg10._entry_to_children[v3] = {}
    arg10._entry_to_parent[v3] = arg11

    if arg11 then
        table.insert(arg10._entry_to_children[arg11], v3)
    end

    local function update_size() -- line: 77
        -- upvalues:
        --  [1] v3 (copy)
        --  [2] arg10 (copy)

        v3.Size = UDim2.new(
            0,
            math.max(v3.Title.TextBounds.X, arg10.ScreenGui.MainFrame.List.AbsoluteCanvasSize.X),
            v3.Size.Y.Scale,
            v3.Size.Y.Offset
        )
    end

    v3.Title:GetPropertyChangedSignal("TextBounds"):Connect(update_size)
    local New_1 = UDim2.new
    local maximum_1 = math.max(
        v3.Title.TextBounds.X,
        arg10.ScreenGui.MainFrame.List.AbsoluteCanvasSize.X
    )
    v3.Size = New_1(0, maximum_1, v3.Size.Y.Scale, v3.Size.Y.Offset)

    return v3
end

function t._Generate(arg12, arg13, arg14, arg15) -- line: 87
    -- upvalues:
    --  [1] Utility_m (copy)

    local t_2 = {}

    for key_1, _ in pairs(arg13) do
        table.insert(t_2, key_1)
    end

    table.sort(t_2, function(arg16, arg17) -- line: 94
        -- upvalues:
        --  [1] Utility_m (ref)

        return Utility_m:StringLessThan(tostring(arg16), (tostring(arg17)))
    end)
    local v6 = arg15 and arg15.LayoutOrder or 0
    local v7, v8

    for key_2, _ in pairs(arg12._entry_to_children) do
        if v6 < key_2.LayoutOrder then
            v7 = key_2.LayoutOrder
            v8 = if not arg15 then 0 else 1
            key_2.LayoutOrder = v7 + (#t_2 + v8)
        end
    end

    local v11, v13

    for key_3, val_3 in pairs(t_2) do
        local v7 = arg13[val_3]
        local v9 = if typeof(v7) ~= "table" then false else true
        local v10 = v9 and next(v7) ~= nil
        local v8 = arg12:_GetTabString(arg14)
        local v12 = arg12:_ColorBasedOnType(
            if typeof(val_3) == "string" then "\"" .. val_3 .. "\"" else tostring(val_3),
            val_3
        )

        if typeof(v7) == "string" then
            v13 = "\"" .. v7 .. "\""
        else
            v13 = tostring(v7)
        end

        local v14 = arg12:_ColorBasedOnType(v13, v7)
        local v11 = arg12:_CreateEntry(arg15)
        v11.Title.Text = string.format("%s[%s] = %s;", v8, v12, if v9 then "{}" else v14)
        v11.LayoutOrder = v6 + key_3
        local ScreenGui = arg12.ScreenGui.MainFrame.List.Container
        v11.Parent = ScreenGui

        if v10 then
            local v17 = false

            local _ = function() --[[ update_text ]] -- line: 125
                -- upvalues:
                --  [1] v11 (copy)
                --  [2] v8 (copy)
                --  [3] v12 (copy)
                --  [4] v17 (ref)

                local Title_1 = v11.Title
                local string_format_1 = string.format
                local v18 = v8
                local v19 = v12
                local v20 = if not v17 then "{...};" else "{"
                Title_1.Text = string_format_1("%s[%s] = %s", v18, v19, v20)
            end

            local Title_2 = v11.Title
            local string_format_2 = string.format
            local v21 = if not v17 then "{...};" else "{"
            Title_2.Text = string_format_2("%s[%s] = %s", v8, v12, v21)
            v11.Button.MouseButton1Click:Connect(function() -- line: 131
                -- upvalues:
                --  [1] v17 (ref)
                --  [2] v11 (copy)
                --  [3] v8 (copy)
                --  [4] v12 (copy)
                --  [5] arg12 (copy)
                --  [6] v7 (copy)
                --  [7] arg14 (copy)

                v17 = not v17
                local Title_3 = v11.Title
                local string_format_3 = string.format
                local v22 = v8
                local v23 = v12
                local v24 = if not v17 then "{...};" else "{"
                Title_3.Text = string_format_3("%s[%s] = %s", v22, v23, v24)

                if v17 then
                    arg12:_Generate(v7, arg14 + 1, v11)

                    return
                end

                arg12:_DeleteDescendants(v11)
            end)
        end
    end

    if arg15 then
        local v26 = arg12:_CreateEntry(arg15)
        v26.Title.Text = arg12:_GetTabString(arg14 - 1) .. "};"
        v26.LayoutOrder = v6 + #t_2 + 1
        v26.Parent = arg12.ScreenGui.MainFrame.List.Container
    end
end

function t._UpdateList(arg18) -- line: 152
    arg18.ScreenGui.MainFrame.List.CanvasSize = UDim2.new(
        0,
        arg18.ScreenGui.MainFrame.List.Container.Layout.AbsoluteContentSize.X,
        0,
        arg18.ScreenGui.MainFrame.List.Container.Layout.AbsoluteContentSize.Y
    )
end

function t._UpdateSize(arg19) -- line: 156
    arg19.ScreenGui.MainFrame.List.Container.Size = UDim2.new(
        0,
        arg19.ScreenGui.MainFrame.AbsoluteSize.X,
        0,
        arg19.ScreenGui.MainFrame.AbsoluteSize.Y
    )
end

function t._Init(arg20) -- line: 160
    arg20.ScreenGui.MainFrame.Top.Button.MouseButton1Click:Connect(function() -- line: 161
        -- upvalues:
        --  [1] arg20 (copy)

        arg20:Destroy()
    end)
    arg20.ScreenGui.MainFrame:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- line: 165
        -- upvalues:
        --  [1] arg20 (copy)

        arg20:_UpdateSize()
    end)
    arg20.ScreenGui.MainFrame.List.Container.Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(
        function() -- line: 169
            -- upvalues:
            --  [1] arg20 (copy)

            arg20:_UpdateList()
        end
    )
    arg20:_Generate(arg20.Root, 0, nil)
    arg20:_UpdateSize()
    arg20:_UpdateList()
end

return t
