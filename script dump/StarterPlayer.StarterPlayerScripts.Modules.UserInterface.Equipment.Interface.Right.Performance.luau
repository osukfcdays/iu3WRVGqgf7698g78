local Players = game:GetService("Players")
local PlayerDataController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.PlayerDataController
)
local EquipmentMetricCard_m = require(Players.LocalPlayer.PlayerScripts.Modules.EquipmentMetricCard)
local StatisticsList_m = require(Players.LocalPlayer.PlayerScripts.Modules.StatisticsList)
local t = {}
t.__index = t

function t.new(arg1) -- line: 10
    -- upvalues:
    --  [1] t (copy)
    --  [2] EquipmentMetricCard_m (copy)
    --  [3] StatisticsList_m (copy)

    local t_1 = setmetatable({}, t)
    t_1.Right = arg1
    t_1.MetricCard = EquipmentMetricCard_m.new("Statistics", "rbxassetid://17336063541")
    t_1.StatisticsList = StatisticsList_m.new(t_1.MetricCard.Container, 1, true)
    t_1:_Init()

    return t_1
end

function t.OnStateChanged(arg2) -- line: 26
    arg2:_UpdateInformation()
end

function t.OnOpen(arg3) -- line: 30
    arg3:_UpdateInformation()
end

function t._UpdateInformation(arg4) -- line: 38
    -- upvalues:
    --  [1] PlayerDataController_m (copy)

    if not arg4.Right.Interface.Equipment.IsOpen or arg4.Right.Interface.Equipment:IsCustomizing() then
        arg4.StatisticsList:Clear()

        return
    end

    local v1 = arg4.Right.Interface.Equipment:IsCareerPageOpen()
    local v2 = arg4.Right.Interface.Equipment:GetSelectedWeapon()
    local v3 = PlayerDataController_m:GetWeaponData(v2)

    if v1 then
        arg4.StatisticsList:Generate(true, nil, nil)

        return
    end

    if v3 then
        arg4.StatisticsList:Generate(false, "WeaponStatistics", v2)

        return
    end

    arg4.StatisticsList:Clear()
end

function t._Init(arg5) -- line: 57
    -- upvalues:
    --  [1] PlayerDataController_m (copy)

    arg5.MetricCard.Clicked:Connect(function() -- line: 58
        -- upvalues:
        --  [1] arg5 (copy)

        arg5.Right:SetMetricCardVisible("Performance", false)
    end)
    PlayerDataController_m:GetDataChangedSignal("WeaponInventory"):Connect(function() -- line: 62
        -- upvalues:
        --  [1] arg5 (copy)

        arg5:_UpdateInformation()
    end)
    arg5.MetricCard:SetParent(arg5.Right.Container)
end

return t
