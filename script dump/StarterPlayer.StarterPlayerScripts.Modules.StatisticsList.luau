local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local StatisticsLibrary_m = require(ReplicatedStorage.Modules.StatisticsLibrary)
local ItemLibrary_m = require(ReplicatedStorage.Modules.ItemLibrary)
local PlayerDataController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.PlayerDataController
)
local WeaponStatusHandler_m = require(Players.LocalPlayer.PlayerScripts.Modules.WeaponStatusHandler)
local ButtonEffect_m = require(Players.LocalPlayer.PlayerScripts.Modules.ButtonEffect)
local UILibrary_m = require(Players.LocalPlayer.PlayerScripts.Modules.UILibrary)
local StatisticParentSlot = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild(
    "StatisticParentSlot"
)
local StatisticChildSlot = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild(
    "StatisticChildSlot"
)
local t = {}
t.__index = t

function t.new(arg1, arg2, arg3) -- line: 17
    -- upvalues:
    --  [1] t (copy)

    local t_1 = setmetatable({}, t)
    t_1._parent = arg1
    t_1._layout_order = arg2
    t_1._expand_all_statistics = arg3
    t_1._statistic_slots = {}
    t_1._dependent_statistic_slots = {}
    t_1:_Init()

    return t_1
end

function t.Clear(arg4) -- line: 35
    for _, val in pairs(arg4._statistic_slots) do
        val:Destroy()
    end

    arg4._statistic_slots = {}
    arg4._dependent_statistic_slots = {}
end

function t.Generate(arg5, arg6, arg7, arg8) -- line: 45
    -- upvalues:
    --  [1] StatisticsLibrary_m (copy)
    --  [2] PlayerDataController_m (copy)
    --  [3] StatisticChildSlot (copy)
    --  [4] StatisticParentSlot (copy)
    --  [5] ItemLibrary_m (copy)
    --  [6] WeaponStatusHandler_m (copy)
    --  [7] UILibrary_m (copy)
    --  [8] ButtonEffect_m (copy)

    arg5:Clear()
    local v1 = StatisticsLibrary_m:GetStatisticsDirectoryInfo(arg7)
    local v3 = arg6 and StatisticsLibrary_m:GetCareerStatistics(
        PlayerDataController_m:GetUnlockedWeapons()
    ) or v1[2][arg8] and v1[2][arg8].DataNames or nil

    if not v3 then
        return
    end

    local v4 = 0

    local function generate(arg9, arg10) -- line: 60
        -- upvalues:
        --  [1] arg5 (copy)
        --  [2] StatisticsLibrary_m (ref)
        --  [3] arg6 (copy)
        --  [4] PlayerDataController_m (ref)
        --  [5] arg7 (copy)
        --  [6] arg8 (copy)
        --  [7] StatisticChildSlot (ref)
        --  [8] StatisticParentSlot (ref)
        --  [9] v4 (ref)
        --  [10] ItemLibrary_m (ref)
        --  [11] WeaponStatusHandler_m (ref)
        --  [12] generate (copy)
        --  [13] UILibrary_m (ref)

        if arg5._statistic_slots[arg9] then
            return
        end

        local v5 = StatisticsLibrary_m.Info[arg9]
        local v6 = if arg6 then PlayerDataController_m:GetStatistic(arg9) else PlayerDataController_m:GetDirectoryStatistic(
            arg7,
            arg8,
            arg9
        )
        local v7 = arg9 == "StatisticFavoriteWeapon" or arg9 == "StatisticFavoriteWeaponPrimary" or arg9 == "StatisticFavoriteWeaponSecondary" or arg9 == "StatisticFavoriteWeaponMelee" or arg9 == "StatisticFavoriteWeaponUtility"
        local v8 = v7 or arg9 == "StatisticFavoriteMap"

        if v5.OnlyDisplayAboveZero and (not v6 or v6 <= 0) then
            return
        end

        local v9 = (v5.ParentDataName and StatisticChildSlot or StatisticParentSlot):Clone()
        v9.TitleContainer.Title.Text = v5.DisplayName
        local TitleContainer = v9.TitleContainer
        TitleContainer.Position = v5.ParentDataName and UDim2.new(0.125, 0, 0.5, 0) or UDim2.new(
            0.0625,
            0,
            0.5,
            0
        )
        local Value = v9.Value
        Value.Text = if not v5.IsStatisticFolder then v5.TostringFunction(v6) else ""
        local Value_1 = v9.Value
        Value_1.Size = v8 and UDim2.new(0.35, 0, 1, 0) or v9.Value.Size
        v9.LayoutOrder = arg5._layout_order + arg10
        local v11 = not v5.IsStatisticFolder and (arg5._expand_all_statistics or not v5.ParentDataName or arg6)
        v9.Visible = v11
        v9.Parent = arg5._parent
        arg5._statistic_slots[arg9] = v9
        v4 += 1

        if v7 and ItemLibrary_m.Items[v6] then
            WeaponStatusHandler_m:ApplyItemStatusToText(v9.Value, ItemLibrary_m.Items[v6].Status)
        end

        if v5.ParentDataName then
            local v12 = arg5._dependent_statistic_slots[v5.ParentDataName] or {}
            arg5._dependent_statistic_slots[v5.ParentDataName] = v12
            table.insert(arg5._dependent_statistic_slots[v5.ParentDataName], v9)
            generate(v5.ParentDataName, arg10 - 1)
        else
            v9.Arrow.Visible = false
        end

        UILibrary_m:ScrollingTextLabel(v9.TitleContainer, v9.TitleContainer.Title, v9.Value)
    end

    for key_1, val_1 in pairs(v3) do
        generate(val_1, key_1 * 2)
    end

    local v15

    for key_2, val_2 in pairs(arg5._dependent_statistic_slots) do
        arg5._statistic_slots[key_2].Visible = true
        local v3 = arg5._statistic_slots[key_2]
        v15 = false

        local _ = function(arg11) --[[ set_visible ]] -- line: 110
            -- upvalues:
            --  [1] v15 (ref)
            --  [2] v3 (copy)
            --  [3] val_2 (copy)

            v15 = arg11
            local Arrow = v3.Arrow
            Arrow.Image = if not v15 then "rbxassetid://17654548862" else "rbxassetid://17654601337"

            for _, val_3 in pairs(val_2) do
                val_3.Visible = v15
            end
        end

        v3.Button.MouseButton1Click:Connect(function() -- line: 119
            -- upvalues:
            --  [1] v15 (ref)
            --  [2] v3 (copy)
            --  [3] val_2 (copy)

            v15 = not v15
            local Arrow_1 = v3.Arrow
            Arrow_1.Image = if not v15 then "rbxassetid://17654548862" else "rbxassetid://17654601337"

            for _, val_4 in pairs(val_2) do
                val_4.Visible = v15
            end
        end)
        v15 = arg5._expand_all_statistics or arg6
        v3.Arrow.Image = if v15 then "rbxassetid://17654601337" else "rbxassetid://17654548862"

        for _, val_5 in pairs(val_2) do
            val_5.Visible = v15
        end

        v3.Arrow.Visible = true
        ButtonEffect_m:Add(v3.Button, true, { TargetElement = v3.Arrow })
    end

    return v4 > 0
end

function t._Init(_) -- line: 136
end

return t
