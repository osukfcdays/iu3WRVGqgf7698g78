local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local CONSTANTS_m = require(ReplicatedStorage.Modules.CONSTANTS)
local ItemLibrary_m = require(ReplicatedStorage.Modules.ItemLibrary)
local PlayerDataController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.PlayerDataController
)
local WeaponStatusHandler_m = require(Players.LocalPlayer.PlayerScripts.Modules.WeaponStatusHandler)
local ButtonEffect_m = require(Players.LocalPlayer.PlayerScripts.Modules.ButtonEffect)
local Pages_m = require(Players.LocalPlayer.PlayerScripts.Modules.UserInterface.Pages)
local t = {}
local EquipmentMetricActionSlot = Players.LocalPlayer.PlayerScripts.UserInterface.EquipmentMetricActionSlot
t.__index = t

function t.new(arg1) -- line: 17
    -- upvalues:
    --  [1] t (copy)

    local t_1 = setmetatable({}, t)
    t_1.Right = arg1
    t_1.Frame = t_1.Right.Container:WaitForChild("PrimaryActions")
    t_1.Container = t_1.Frame:WaitForChild("Container")
    t_1.Layout = t_1.Container:WaitForChild("Layout")
    t_1.ContractsFrame = t_1.Container:WaitForChild("Contracts")
    t_1.ContractsButton = t_1.ContractsFrame:WaitForChild("Button")
    t_1.DuelHistoryFrame = t_1.Container:WaitForChild("DuelHistory")
    t_1.DuelHistoryButton = t_1.DuelHistoryFrame:WaitForChild("Button")
    t_1.MapsFrame = t_1.Container:WaitForChild("Maps")
    t_1.MapsButton = t_1.MapsFrame:WaitForChild("Button")
    t_1.CollectionFrame = t_1.Container:WaitForChild("Collection")
    t_1.CollectionButton = t_1.CollectionFrame:WaitForChild("Button")
    t_1.CareerFrame = t_1.Container:WaitForChild("Career")
    t_1.CareerButton = t_1.CareerFrame:WaitForChild("Button")
    t_1.CareerIcon = t_1.CareerFrame:WaitForChild("Icon")
    t_1.WeaponFrame = t_1.Container:WaitForChild("Weapon")
    t_1.WeaponButton = t_1.WeaponFrame:WaitForChild("Button")
    t_1.WeaponTitle = t_1.WeaponFrame:WaitForChild("Title")
    t_1.WeaponIcon = t_1.WeaponFrame:WaitForChild("Icon")
    t_1._last_state = nil
    t_1._back_to_weapon = nil
    t_1._metric_action_slots = {}
    t_1:_Init()

    return t_1
end

function t.SetMetricActionVisible(arg2, arg3, arg4) -- line: 53
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
) -- line: 62
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
    v3.Button.MouseButton1Click:Connect(function() -- line: 72
        -- upvalues:
        --  [1] arg5 (copy)
        --  [2] arg6 (copy)

        arg5.Right:SetMetricCardVisible(arg6, true)
    end)
    local t_2 = { HoverRatio = UDim2.new(0, 10, 0, 10), ReleaseRatio = UDim2.new(0, 10, 0, 10) }
    ButtonEffect_m:Add(v3.Button, nil, t_2)
end

function t.OnStateChanged(arg10) -- line: 79
    task.defer(arg10._UpdateInformation, arg10)
end

function t.OnOpen(arg11) -- line: 83
    arg11:_UpdateInformation(true)
end

function t._IsMetricActionVisible(arg12, arg13) -- line: 91
    -- upvalues:
    --  [1] PlayerDataController_m (copy)

    local v5 = arg12.Right.Interface.Equipment:IsCareerPageOpen()
    local v6 = arg12.Right.Interface.Equipment:GetSelectedWeapon()
    local v7 = PlayerDataController_m:GetWeaponData(v6)
    local v8

    if arg13 == "Performance" then
        v8 = true

        if v7 == nil then
            return v5
        end
    else
        if arg13 == "Overview" then
            v8 = v7 ~= nil

            return v8
        end

        if #arg13 >= 7 and string.sub(arg13, 1, 7) == "season_" then
            return v5
        end

        v8 = true
    end

    return v8
end

function t._UpdateInformation(arg14, arg15) -- line: 102
    -- upvalues:
    --  [1] PlayerDataController_m (copy)
    --  [2] ItemLibrary_m (copy)
    --  [3] WeaponStatusHandler_m (copy)

    local v9 = arg14.Right.Interface.Equipment:IsCareerPageOpen()
    local v10 = arg14.Right.Interface.Equipment:GetSelectedWeapon()
    local v11 = PlayerDataController_m:GetWeaponData(v10)
    local v12 = arg14.Right.Interface.Equipment:GetStateID()

    if arg15 or v12 ~= arg14._last_state then
        arg14._last_state = v12
        arg14._back_to_weapon = if not v9 then nil else arg14._back_to_weapon
        arg14.Right:ResetMetricCards()
    end

    local v14 = ItemLibrary_m.Items[arg14._back_to_weapon]
    local WeaponIcon = arg14.WeaponIcon
    WeaponIcon.Image = v14 and v14.Image or ""
    arg14.WeaponTitle.Text = arg14._back_to_weapon or ""
    WeaponStatusHandler_m:ClearStatusElements(arg14.WeaponTitle)
    local v16 = v14
    local v17 = WeaponStatusHandler_m
    local WeaponTitle = arg14.WeaponTitle

    if v16 then
        v16 = v14.Status
    end

    v17:ApplyItemStatusToText(WeaponTitle, v16)
    local v18 = v9
    local WeaponFrame = arg14.WeaponFrame

    if v18 then
        v18 = arg14._back_to_weapon
    end

    WeaponFrame.Visible = v18
    arg14.CareerFrame.Visible = false
    arg14.ContractsFrame.Visible = v11
    arg14.DuelHistoryFrame.Visible = v9
    arg14.MapsFrame.Visible = v9
    arg14.CollectionFrame.Visible = v9
    arg14:_UpdateVisibility()
end

function t._UpdateVisibility(arg16) -- line: 131
    local v19 = arg16.ContractsFrame.Visible or arg16.DuelHistoryFrame.Visible or arg16.MapsFrame.Visible or arg16.CollectionFrame.Visible or arg16.CareerFrame.Visible
    local v20 = false

    for _, val in pairs(arg16._metric_action_slots) do
        v20 = v20 or val.Visible
    end

    arg16.Frame.Visible = v19 or v20
end

function t._UpdateSize(arg17) -- line: 142
    arg17.Frame.Size = UDim2.new(1, 0, 0, arg17.Layout.AbsoluteContentSize.Y)
end

function t._Setup(arg18) -- line: 146
    -- upvalues:
    --  [1] CONSTANTS_m (copy)
    --  [2] Players (copy)

    arg18.CareerIcon.Image = string.format(CONSTANTS_m.HEADSHOT_IMAGE, Players.LocalPlayer.UserId)
end

function t._Init(arg19) -- line: 150
    -- upvalues:
    --  [1] Pages_m (copy)
    --  [2] PlayerDataController_m (copy)
    --  [3] ButtonEffect_m (copy)

    arg19.Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() -- line: 151
        -- upvalues:
        --  [1] arg19 (copy)

        arg19:_UpdateSize()
    end)
    arg19.ContractsButton.MouseButton1Click:Connect(function() -- line: 155
        -- upvalues:
        --  [1] Pages_m (ref)
        --  [2] arg19 (copy)

        Pages_m.PageSystem:OpenPage("Contracts")
        Pages_m.PageSystem:WaitForPage("Contracts"):SetWeapon(
            arg19.Right.Interface.Equipment:GetSelectedWeapon()
        )
    end)
    arg19.DuelHistoryButton.MouseButton1Click:Connect(function() -- line: 160
        -- upvalues:
        --  [1] Pages_m (ref)

        Pages_m.PageSystem:OpenPage("DuelHistory")
    end)
    arg19.MapsButton.MouseButton1Click:Connect(function() -- line: 164
        -- upvalues:
        --  [1] Pages_m (ref)

        Pages_m.PageSystem:OpenPage("Maps")
    end)
    arg19.CollectionButton.MouseButton1Click:Connect(function() -- line: 168
        -- upvalues:
        --  [1] Pages_m (ref)

        Pages_m.PageSystem:OpenPage("Collection")
    end)
    arg19.CareerButton.MouseButton1Click:Connect(function() -- line: 172
        -- upvalues:
        --  [1] arg19 (copy)

        arg19._back_to_weapon = arg19.Right.Interface.Equipment:GetSelectedWeapon()
        arg19.Right.Interface.Equipment:OpenCareerPage(true)
    end)
    arg19.WeaponButton.MouseButton1Click:Connect(function() -- line: 177
        -- upvalues:
        --  [1] arg19 (copy)

        arg19.Right.Interface.Equipment:SelectWeapon(arg19._back_to_weapon)
    end)
    PlayerDataController_m:GetDataChangedSignal("WeaponInventory"):Connect(function() -- line: 181
        -- upvalues:
        --  [1] arg19 (copy)

        arg19:_UpdateInformation()
    end)
    arg19:_Setup()
    arg19:_UpdateSize()
    arg19:_UpdateVisibility()
    arg19:CreateMetricAction(
        "Overview",
        "rbxassetid://18404346057",
        "Overview",
        "View weapon metrics"
    )
    arg19:CreateMetricAction(
        "Performance",
        "rbxassetid://17336063541",
        "Statistics",
        "See lifetime data"
    )
    local t_3 = { HoverRatio = UDim2.new(0, 10, 0, 10), ReleaseRatio = UDim2.new(0, 10, 0, 10) }
    ButtonEffect_m:Add(arg19.ContractsButton, nil, t_3)
    local t_4 = { HoverRatio = UDim2.new(0, 10, 0, 10), ReleaseRatio = UDim2.new(0, 10, 0, 10) }
    ButtonEffect_m:Add(arg19.DuelHistoryButton, nil, t_4)
    local t_5 = { HoverRatio = UDim2.new(0, 10, 0, 10), ReleaseRatio = UDim2.new(0, 10, 0, 10) }
    ButtonEffect_m:Add(arg19.MapsButton, nil, t_5)
    local t_6 = { HoverRatio = UDim2.new(0, 10, 0, 10), ReleaseRatio = UDim2.new(0, 10, 0, 10) }
    ButtonEffect_m:Add(arg19.CollectionButton, nil, t_6)
    local t_7 = { HoverRatio = UDim2.new(0, 10, 0, 10), ReleaseRatio = UDim2.new(0, 10, 0, 10) }
    ButtonEffect_m:Add(arg19.CareerButton, nil, t_7)
    local t_8 = { HoverRatio = UDim2.new(0, 10, 0, 10), ReleaseRatio = UDim2.new(0, 10, 0, 10) }
    ButtonEffect_m:Add(arg19.WeaponButton, nil, t_8)
end

return t
