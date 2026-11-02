local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local ItemLibrary_m = require(ReplicatedStorage.Modules.ItemLibrary)
local PlayerDataController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.PlayerDataController
)
local EquipmentMetricCard_m = require(Players.LocalPlayer.PlayerScripts.Modules.EquipmentMetricCard)
local MetricsGuide_m = require(script:WaitForChild("MetricsGuide"))
local _ = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("EquipmentMetricSlot")
local t = {}
t.__index = t

function t.new(arg1) -- line: 14
    -- upvalues:
    --  [1] t (copy)
    --  [2] EquipmentMetricCard_m (copy)

    local t_1 = setmetatable({}, t)
    t_1.Right = arg1
    t_1.MetricCard = EquipmentMetricCard_m.new("Overview", "rbxassetid://18404346057")
    t_1._set_opened_hash = 0
    t_1._cleanup = {}
    t_1._last_weapon_data = nil
    t_1:_Init()

    return t_1
end

function t.OnStateChanged(arg2) -- line: 33
    arg2:_UpdateInformation()
end

function t.OnOpen(arg3) -- line: 37
    arg3:_UpdateInformation()
end

function t._UpdateInformation(arg4) -- line: 45
    -- upvalues:
    --  [1] PlayerDataController_m (copy)
    --  [2] ItemLibrary_m (copy)
    --  [3] MetricsGuide_m (copy)

    if not arg4.Right.Interface.Equipment.IsOpen or arg4.Right.Interface.Equipment:IsCustomizing() then
        return
    end

    local v2 = arg4.Right.Interface.Equipment:GetSelectedWeapon()
    local v3 = PlayerDataController_m:GetWeaponData(v2)

    if v3 == arg4._last_weapon_data then
        return
    end

    arg4.MetricCard:Clear()
    arg4._last_weapon_data = v3

    if not v3 then
        return
    end

    local v4 = ItemLibrary_m.Items[v2]

    for _, val in pairs(MetricsGuide_m) do
        local v5, v6, v7, v8 = table.unpack(val)
        local v9 = nil

        for _, val_1 in pairs(v6) do
            if v4[val_1] then
                v9 = v4[val_1]
                break
            end
        end

        if v9 or not (#v6 > 0) then
            v6 = if v7 == "Custom" then v8(v2, v9) else if v7 == "Time" then string.format(
                "%.2f",
                v9
            ) .. "s" else if v7 == nil then string.format("%.0f", v9) else assert(false, v5)

            if v6 then
                arg4.MetricCard:Add(v5, v6)
            end
        end
    end
end

function t._Init(arg5) -- line: 94
    -- upvalues:
    --  [1] PlayerDataController_m (copy)

    arg5.MetricCard.Clicked:Connect(function() -- line: 95
        -- upvalues:
        --  [1] arg5 (copy)

        arg5.Right:SetMetricCardVisible("Overview", false)
    end)
    PlayerDataController_m:GetDataChangedSignal("WeaponInventory"):Connect(function() -- line: 99
        -- upvalues:
        --  [1] arg5 (copy)

        arg5:_UpdateInformation()
    end)
    arg5.MetricCard:SetParent(arg5.Right.Container)
end

return t
