local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Signal_m = require(ReplicatedStorage.Modules.Signal)
local PlayerDataController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.PlayerDataController
)
local HotbarSlot_m = require(script:WaitForChild("HotbarSlot"))
local t = {}
t.__index = t

function t.new(arg1) -- line: 11
    -- upvalues:
    --  [1] t (copy)
    --  [2] Signal_m (copy)

    local t_1 = setmetatable({}, t)
    t_1.Clicked = Signal_m.new()
    t_1.FighterInterface = arg1
    t_1.Frame = t_1.FighterInterface.BottomRight.Container:WaitForChild("Hotbar")
    t_1.Container = t_1.Frame:WaitForChild("Container")
    t_1.Layout = t_1.Container:WaitForChild("Layout")
    t_1.EquippedDisplayFrame = t_1.Container:WaitForChild("EquippedDisplay")
    t_1._hotbar_slots = {}
    t_1:_Init()

    return t_1
end

function t.UpdateParent(arg2) -- line: 33
    -- upvalues:
    --  [1] PlayerDataController_m (copy)

    task.defer(pcall, function() -- line: 34
        -- upvalues:
        --  [1] PlayerDataController_m (ref)
        --  [2] arg2 (copy)

        local v2 = if PlayerDataController_m:GetSetting("Hotbar Display") ~= "Bottom Center" then false else true
        local v3 = if PlayerDataController_m:GetSetting("Hotbar Display") ~= "Bottom Left" then false else true
        arg2.EquippedDisplayFrame.LayoutOrder = if not v3 then -1 else 100000000
        local Layout = arg2.Layout
        Layout.HorizontalAlignment = v2 and Enum.HorizontalAlignment.Center or v3 and Enum.HorizontalAlignment.Left or Enum.HorizontalAlignment.Right
        local Frame = arg2.Frame
        Frame.Parent = v2 and arg2.FighterInterface.BottomCenter.Container or v3 and arg2.FighterInterface.BottomLeft.Container or arg2.FighterInterface.BottomRight.Container
    end)
end

function t.EquipEffect(arg3, arg4, ...) -- line: 48
    local v5 = arg3._hotbar_slots[arg4]

    if not v5 then
        return
    end

    return v5:EquipEffect(...)
end

function t.RollEffect(arg5, arg6, ...) -- line: 58
    local v6 = arg5._hotbar_slots[arg6]

    if not v6 then
        return
    end

    return v6:RollEffect(...)
end

function t.CooldownEffect(arg7, arg8, ...) -- line: 68
    local v7 = arg7._hotbar_slots[arg8]

    if not v7 then
        return
    end

    return v7:CooldownEffect(...)
end

function t.UpdateAmmo(arg9, ...) -- line: 78
    for _, val in pairs(arg9._hotbar_slots) do
        val:UpdateAmmo(...)
    end
end

function t.UpdateVisuals(arg10, ...) -- line: 84
    for _, val_1 in pairs(arg10._hotbar_slots) do
        val_1:UpdateVisuals(...)
    end
end

function t.UpdateVisibility(arg11, ...) -- line: 90
    -- upvalues:
    --  [1] PlayerDataController_m (copy)

    arg11.EquippedDisplayFrame.Visible = if PlayerDataController_m:GetSetting(
        "Equipped Weapon Display"
    ) ~= "Legacy" then false else true
    local v9 = arg11.EquippedDisplayFrame.Visible

    for _, val_2 in pairs(arg11._hotbar_slots) do
        val_2:UpdateVisibility(...)
        v9 = v9 or val_2.Frame.Visible
    end

    local v11 = v9
    local Frame_1 = arg11.Frame

    if v11 then
        v11 = if PlayerDataController_m:GetSetting("Hotbar Display") == "Disabled" then false else true
    end

    Frame_1.Visible = v11
end

function t.ItemRemoved(arg12, arg13, arg14) -- line: 103
    local v12 = arg12._hotbar_slots[arg13]

    if not v12 then
        return
    end

    v12:Destroy()
    arg12._hotbar_slots[arg13] = nil
    arg12:_UpdateSize()
    arg12:UpdateVisibility()

    if not arg14 then
        arg12:UpdateLayouts()
    end
end

function t.ItemAdded(arg15, arg16, arg17) -- line: 120
    -- upvalues:
    --  [1] HotbarSlot_m (copy)

    arg15:ItemRemoved(arg16, arg17)
    local v13 = HotbarSlot_m.new(arg15, arg16)
    v13.Frame.Parent = arg15.Container
    arg15._hotbar_slots[arg16] = v13
    v13.Clicked:Connect(function(...) -- line: 127
        -- upvalues:
        --  [1] arg15 (copy)
        --  [2] v13 (copy)

        arg15.Clicked:Fire(v13, ...)
    end)
    v13.CooldownsChanged:Connect(function() -- line: 131
        -- upvalues:
        --  [1] arg15 (copy)

        arg15:_UpdateSize()
    end)
    arg15:_UpdateSize()
    arg15:UpdateVisibility()

    if not arg17 then
        arg15:UpdateLayouts()
    end
end

function t.UpdateLayouts(arg18) -- line: 143
    for key_3, val_3 in pairs(arg18.FighterInterface.ClientFighter.Items) do
        local v14 = arg18._hotbar_slots[val_3]

        if v14 then
            v14.Frame.LayoutOrder = key_3
        end
    end
end

function t.Update(arg19, arg20, arg21) -- line: 155
    for _, val_4 in pairs(arg19._hotbar_slots) do
        val_4:Update(arg20, arg21)
    end
end

function t.Destroy(arg22) -- line: 161
    arg22.Clicked:Destroy()

    for _, val_5 in pairs(arg22._hotbar_slots) do
        val_5:Destroy()
    end
end

function t._UpdateSize(arg23) -- line: 173
    local v15 = 0

    for _, val_6 in pairs(arg23._hotbar_slots) do
        v15 = math.max(v15, val_6:GetNumCooldownsActive())
    end

    arg23.Frame.Size = UDim2.new(0.275, 0, v15 * 0.05 + 0.275, 0)
end

function t._Init(arg24) -- line: 183
    for _, val_7 in pairs(arg24.FighterInterface.ClientFighter.Items) do
        arg24:ItemAdded(val_7, true)
    end

    arg24:_UpdateSize()
    arg24:UpdateLayouts()
    arg24:UpdateParent()
    arg24:UpdateVisibility()
end

return t
