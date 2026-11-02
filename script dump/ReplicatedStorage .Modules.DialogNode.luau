local t = {}
t.__index = t

function t.new() -- line: 4
    -- upvalues:
    --  [1] t (copy)

    local t_1 = setmetatable({}, t)
    t_1.Message = nil
    t_1.ButtonAppearDelay = nil
    t_1.Buttons = {}
    t_1.DelayedContinue = nil
    t_1:_Init()

    return t_1
end

function t.SetMessage(arg1, arg2, arg3, arg4) -- line: 21
    arg1.Message = { Picture = arg2, Text = arg3, SoundID = arg4 }
end

function t.SetButtonAppearDelay(arg5, arg6) -- line: 29
    arg5.ButtonAppearDelay = arg6
end

function t.ContinueAfterDelay(arg7, arg8, arg9) -- line: 33
    arg7.DelayedContinue = { Delay = arg8, NextDialog = arg9 }
end

function t.AddButton(arg10, arg11, arg12, arg13) -- line: 40
    local t_4 = { Text = arg11, NextDialog = arg12, IsCloseButton = nil, DialogActionKey = nil }
    local Buttons = arg10.Buttons
    t_4.IsCloseButton = if arg12 then nil else not arg13 or nil
    t_4.DialogActionKey = arg13
    table.insert(Buttons, t_4)
end

function t.AddCloseButton(arg14, arg15) -- line: 49
    arg14:AddButton(arg15 or "Goodbye", nil)
end

function t.IsDialogActionAvailable(arg16, arg17) -- line: 53
    if not arg17 then
        return false
    end

    local function search(arg18) -- line: 58
        -- upvalues:
        --  [1] arg17 (copy)
        --  [2] search (copy)

        local v2 = pairs
        local v3 = arg18.Buttons or {}

        for _, val in v2(v3) do
            if val.DialogActionKey == arg17 or val.NextDialog and search(val.NextDialog) then
                return true
            end
        end

        return arg18.DelayedContinue and arg18.DelayedContinue.NextDialog and search(
            arg18.DelayedContinue.NextDialog
        )
    end

    return (search(arg16))
end

function t._Init(_) -- line: 81
end

return t
