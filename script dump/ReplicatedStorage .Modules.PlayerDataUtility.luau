local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CONSTANTS_m = require(ReplicatedStorage.Modules.CONSTANTS)
local Signal_m = require(ReplicatedStorage.Modules.Signal)
local MonetizationLibrary_m = require(ReplicatedStorage.Modules.MonetizationLibrary)
local StatisticsLibrary_m = require(ReplicatedStorage.Modules.StatisticsLibrary)
local SettingsLibrary_m = require(ReplicatedStorage.Modules.SettingsLibrary)
local SeasonLibrary_m = require(ReplicatedStorage.Modules.SeasonLibrary)
local t = {}
t.__index = t

function t._new() -- line: 13
    -- upvalues:
    --  [1] t (copy)

    local t_1 = setmetatable({}, t)
    t_1:_Init()

    return t_1
end

function t.GetRobuxSpent(_, arg2, arg3, arg4) -- line: 25
    -- upvalues:
    --  [1] MonetizationLibrary_m (copy)

    local v1 = 0
    local v3 = arg2 or {}

    for _, val in pairs(v3) do
        v1 += val.CurrencySpent or 0
    end

    local v3 = arg3 or {}

    for key_1, val_1 in pairs(v3) do
        local v5 = val_1 and MonetizationLibrary_m.Gamepasses[key_1] and MonetizationLibrary_m.Gamepasses[key_1].StaticRobuxPrice or 0
        v1 += v5
    end

    local v3 = arg4 or {}

    for _, val_2 in pairs(v3) do
        v1 += val_2.CurrencySpentTotal or 0
    end

    return v1
end

function t.GetSetting(_, arg6, arg7, arg8) -- line: 43
    -- upvalues:
    --  [1] SettingsLibrary_m (copy)

    assert(SettingsLibrary_m:DoesExist(arg7), arg7)

    return arg6:Get("Settings")[arg8 or arg6:Get("SettingsProfile")][arg7]
end

function t.GetSettingChangedSignal(arg9, arg10, arg11) -- line: 49
    -- upvalues:
    --  [1] SettingsLibrary_m (copy)
    --  [2] Signal_m (copy)

    assert(SettingsLibrary_m:DoesExist(arg11), arg11)

    if not next(arg10._setting_changed_events) then
        local v11 = arg10:Get("SettingsProfile")

        local function update_bulk(arg12) -- line: 55
            -- upvalues:
            --  [1] arg10 (copy)
            --  [2] arg9 (copy)
            --  [3] v11 (ref)

            local v12 = arg10:Get("SettingsProfile")

            for key_3, val_3 in pairs(arg10._setting_changed_events) do
                local v13 = if not arg12 then nil else arg9:GetSetting(arg10, key_3, v11)
                local v14 = if not arg12 then nil else arg9:GetSetting(arg10, key_3, v12)

                if arg12 then
                    if not (if typeof(v13) == "number" and typeof(v14) == "number" then math.abs(
                        v13 - v14
                    ) < 0.001 and true else if v13 ~= v14 then false else true) then
                        val_3:FireDeferred()
                    end
                else
                    val_3:FireDeferred()
                end
            end

            v11 = v12
        end

        arg10:GetDataChangedSignal("SettingsProfile"):Connect(function() -- line: 76
            -- upvalues:
            --  [1] update_bulk (copy)

            update_bulk(true)
        end)
        arg10:GetDataChangedSignal("Settings"):Connect(function() -- line: 80
            -- upvalues:
            --  [1] update_bulk (copy)

            update_bulk()
        end)
    end

    if not arg10._setting_changed_events[arg11] then
        arg10._setting_changed_events[arg11] = Signal_m.new()
    end

    return arg10._setting_changed_events[arg11]
end

function t.SetSetting(
    _,
    arg14,
    arg15,
    arg16,
    arg17
) -- line: 92
    -- upvalues:
    --  [1] SettingsLibrary_m (copy)

    assert(SettingsLibrary_m:DoesExist(arg15), arg15)
    local v19 = arg14:Get("Settings")
    local v20 = arg17 or arg14:Get("SettingsProfile")
    v19[v20][arg15] = arg16

    if arg14.ReplicateToClient then
        arg14.ReplicateToClient:Fire("SettingChanged", arg15, arg16, arg17)
    end

    if arg14._setting_changed_events[arg15] then
        arg14._setting_changed_events[arg15]:Fire(arg16, arg15)
    end
end

function t.IsNosniyGamesTeamMemberRaw(_, arg19) -- line: 106
    -- upvalues:
    --  [1] CONSTANTS_m (copy)

    return arg19 and table.find(arg19, CONSTANTS_m.TEAM_GROUP_ROLE_ID)
end

function t.IsNosniyGamesTeamMember(arg20, arg21) -- line: 110
    return arg20:IsNosniyGamesTeamMemberRaw(arg21:Get("GroupRoleIDs"))
end

function t.GetWeaponData(_, arg23, arg24) -- line: 114
    for key_4, val_4 in pairs(arg23:Get("WeaponInventory")) do
        if val_4.Name == arg24 then
            return val_4, key_4
        end
    end
end

function t.HasGamepass(_, arg26, arg27) -- line: 122
    return arg26:Get("Gamepasses")[arg27]
end

function t.AreTasksCompleted(_, arg29, arg30) -- line: 126
    for _, val_5 in pairs(arg29:Get(arg30 or "Tasks")) do
        if not val_5.Completed then
            return false
        end
    end

    return true
end

function t.GetUnlockedWeapons(_, arg32, arg33) -- line: 136
    local t_2 = {}

    for _, val_6 in pairs(arg32:Get("WeaponInventory")) do
        t_2[val_6.Name] = true
    end

    if not arg33 then
        for key_7, _ in pairs(arg32:Get("FreeWeaponUnlockCheck")) do
            t_2[key_7] = true
        end
    end

    return t_2
end

function t.GetStatistic(_, arg35, arg36) -- line: 152
    -- upvalues:
    --  [1] StatisticsLibrary_m (copy)

    local v26 = StatisticsLibrary_m.Info[arg36]

    if not v26 then
        assert(
            false,
            "Invalid statistic_name: " .. tostring(arg36) .. ". Did you forget to put \"Statistic\" before the string?"
        )
    end

    return arg35:Get(arg36) or v26.DefaultValue
end

function t.GetDirectoryStatistic(
    _,
    arg38,
    arg39,
    arg40,
    arg41,
    arg42
) -- line: 162
    -- upvalues:
    --  [1] StatisticsLibrary_m (copy)

    local v28 = StatisticsLibrary_m.Info[arg41]

    if not v28 then
        assert(
            false,
            "Invalid statistic_name: " .. tostring(arg41) .. ". Did you forget to put \"Statistic\" before the string?"
        )
    end

    local v29 = 0

    local _ = function(arg43) --[[ add ]] -- line: 171
        -- upvalues:
        --  [1] arg38 (copy)
        --  [2] arg39 (copy)
        --  [3] arg40 (copy)
        --  [4] v28 (copy)
        --  [5] v29 (ref)

        local v30 = arg38:Get(arg39)
        local v31 = v30[arg40] and v30[arg40][arg43] or v28.DefaultValue
        v29 = if v28.ValueType ~= "number" then v31 else v29 + v31
    end

    local v33 = arg38:Get(arg39)
    local v34 = v33[arg40] and v33[arg40][arg41] or v28.DefaultValue
    v29 = if v28.ValueType ~= "number" then v34 else v29 + v34
    v34 = arg42 or {}

    for _, val_8 in pairs(v34) do
        local v36 = arg38:Get(arg39)
        local v37 = v36[arg40] and v36[arg40][val_8] or v28.DefaultValue
        v29 = if v28.ValueType ~= "number" then v37 else v29 + v37
    end

    return v29
end

function t.GetSeasonInfo(_, arg45, arg46) -- line: 186
    -- upvalues:
    --  [1] SeasonLibrary_m (copy)

    local v38 = arg45:Get("Seasons")[arg46]
    local v39 = v38

    if v39 then
        v39 = v38.RankedPerformances[SeasonLibrary_m.UNIVERSAL_ELO_NAME]
    end

    v38 = v39 and v39.CurrentELO

    return v38, v39 and v39.Metadata and v39.Metadata.FinalLeaderboardRank
end

function t.GetWeaponStatistic(arg47, arg48, ...) -- line: 195
    return arg47:GetDirectoryStatistic(arg48, "WeaponStatistics", ...)
end

function t.GetMapStatistic(arg49, arg50, ...) -- line: 199
    return arg49:GetDirectoryStatistic(arg50, "MapStatistics", ...)
end

function t._Init(_) -- line: 207
end

return t._new()
