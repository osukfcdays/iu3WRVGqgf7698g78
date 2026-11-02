local Players = game:GetService("Players")
local PlayerDataController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.PlayerDataController
)
local ButtonEffect_m = require(Players.LocalPlayer.PlayerScripts.Modules.ButtonEffect)
local t = {}
local EquipmentMetricActionSlot = Players.LocalPlayer.PlayerScripts.UserInterface.EquipmentMetricActionSlot
t.__index = t

function t.new(arg1) -- line: 11
    -- upvalues:
    --  [1] t (copy)

    local t_1 = setmetatable({}, t)
    t_1.Right = arg1
    t_1.Frame = t_1.Right.Container:WaitForChild("SecondaryActions")
    t_1.Container = t_1.Frame:WaitForChild("Container")
    t_1.Layout = t_1.Container:WaitForChild("Layout")
    t_1._last_state = nil
    t_1._metric_action_slots = {}
    t_1:_Init()

    return t_1
end

function t.SetMetricActionVisible(arg2, arg3, arg4) -- line: 31
    if not arg2._metric_action_slots[arg3] then
        return
    end

    local v1 = arg4
    local v2 = arg2._metric_action_slots[arg3]

    if v1 then
        v1 = arg2:_IsMetricActionVisible(arg3)
    end

    v2.Visible = v1
    arg2:_UpdateVisibility()
end

function t.CreateMetricAction(
    arg5,
    arg6,
    arg7,
    arg8,
    arg9
) -- line: 40
    -- upvalues:
    --  [1] EquipmentMetricActionSlot (copy)
    --  [2] ButtonEffect_m (copy)

    local v3 = EquipmentMetricActionSlot:Clone()
    v3.Icon.Image = arg7
    v3.Title.Text = arg8
    v3.Description.Text = arg9
    v3.Name = arg6
    v3.Visible = false
    v3.Parent = arg5.Container
    arg5._metric_action_slots[arg6] = v3
    v3.Button.MouseButton1Click:Connect(function() -- line: 50
        -- upvalues:
        --  [1] arg5 (copy)
        --  [2] arg6 (copy)

        arg5.Right:SetMetricCardVisible(arg6, true)
    end)
    local t_2 = { HoverRatio = UDim2.new(0, 10, 0, 10), ReleaseRatio = UDim2.new(0, 10, 0, 10) }
    ButtonEffect_m:Add(v3.Button, nil, t_2)
end

function t.OnStateChanged(arg10) -- line: 57
    task.defer(arg10._UpdateInformation, arg10)
end

function t.OnOpen(arg11) -- line: 61
    arg11:_UpdateInformation(true)
end

function t._IsMetricActionVisible(arg12, arg13) -- line: 69
    -- upvalues:
    --  [1] PlayerDataController_m (copy)

    local v5 = arg12.Right.Interface.Equipment:IsCareerPageOpen()
    local v6 = arg12.Right.Interface.Equipment:GetSelectedWeapon()
    local _ = PlayerDataController_m:GetWeaponData(v6)

    if #arg13 >= 7 and string.sub(arg13, 1, 7) == "season_" then
        return v5
    end

    return true
end

function t._UpdateInformation(arg14, arg15) -- line: 78
    -- upvalues:
    --  [1] PlayerDataController_m (copy)

    local _ = arg14.Right.Interface.Equipment:IsCareerPageOpen()
    local v10 = arg14.Right.Interface.Equipment:GetSelectedWeapon()
    local _ = PlayerDataController_m:GetWeaponData(v10)
    local v12 = arg14.Right.Interface.Equipment:GetStateID()

    if arg15 or v12 ~= arg14._last_state then
        arg14._last_state = v12
        arg14.Right:ResetMetricCards()
    end

    arg14:_UpdateVisibility()
end

function t._UpdateVisibility(arg16) -- line: 94
    local v13 = false

    for _, val in pairs(arg16._metric_action_slots) do
        v13 = v13 or val.Visible
    end

    arg16.Frame.Visible = v13
end

function t._UpdateSize(arg17) -- line: 105
    arg17.Frame.Size = UDim2.new(1, 0, 0, arg17.Layout.AbsoluteContentSize.Y)
end

function t._Init(arg18) -- line: 109
    -- upvalues:
    --  [1] PlayerDataController_m (copy)

    arg18.Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() -- line: 110
        -- upvalues:
        --  [1] arg18 (copy)

        arg18:_UpdateSize()
    end)
    PlayerDataController_m:GetDataChangedSignal("WeaponInventory"):Connect(function() -- line: 114
        -- upvalues:
        --  [1] arg18 (copy)

        arg18:_UpdateInformation()
    end)
    arg18:_UpdateSize()
    arg18:_UpdateVisibility()
end

return t
