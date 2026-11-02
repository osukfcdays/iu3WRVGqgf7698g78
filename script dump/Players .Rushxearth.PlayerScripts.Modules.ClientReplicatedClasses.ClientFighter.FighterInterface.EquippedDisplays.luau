local EquippedDisplay_m = require(script:WaitForChild("EquippedDisplay"))
local t = {}
t.__index = t

function t.new(arg1) -- line: 6
    -- upvalues:
    --  [1] t (copy)

    local t_1 = setmetatable({}, t)
    t_1.FighterInterface = arg1
    t_1._equipped_displays = {}
    t_1:_Init()

    return t_1
end

function t.UpdateVisibility(arg2, ...) -- line: 22
    for _, val in pairs(arg2._equipped_displays) do
        val:UpdateVisibility(...)
    end
end

function t.UpdateAmmo(arg3, ...) -- line: 28
    for _, val_1 in pairs(arg3._equipped_displays) do
        val_1:UpdateAmmo(...)
    end
end

function t.UpdateVisuals(arg4, ...) -- line: 34
    for _, val_2 in pairs(arg4._equipped_displays) do
        val_2:UpdateVisuals(...)
    end
end

function t.UpdateParents(arg5, ...) -- line: 40
    for _, val_3 in pairs(arg5._equipped_displays) do
        val_3:UpdateParent(...)
    end
end

function t.ItemRemoved(arg6, arg7, _) -- line: 46
    local v2 = arg6._equipped_displays[arg7]

    if not v2 then
        return
    end

    v2:Destroy()
    arg6._equipped_displays[arg7] = nil
end

function t.ItemAdded(arg9, arg10, arg11) -- line: 57
    -- upvalues:
    --  [1] EquippedDisplay_m (copy)

    arg9:ItemRemoved(arg10, arg11)
    arg9._equipped_displays[arg10] = EquippedDisplay_m.new(arg9, arg10)
end

function t.Update(arg12, arg13, arg14) -- line: 64
    for _, val_4 in pairs(arg12._equipped_displays) do
        val_4:Update(arg13, arg14)
    end
end

function t.Destroy(arg15) -- line: 70
    for _, val_5 in pairs(arg15._equipped_displays) do
        val_5:Destroy()
    end

    arg15._equipped_displays = {}
end

function t._Init(arg16) -- line: 82
    for _, val_6 in pairs(arg16.FighterInterface.ClientFighter.Items) do
        arg16:ItemAdded(val_6, true)
    end

    arg16:UpdateParents()
end

return t
