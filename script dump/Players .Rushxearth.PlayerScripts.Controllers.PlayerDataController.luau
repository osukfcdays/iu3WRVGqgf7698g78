local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local EnumLibrary_m = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("EnumLibrary"))
local Signal_m = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Signal"))
local ClientPlayerData_m = require(
    Players.LocalPlayer:WaitForChild("PlayerScripts"):WaitForChild("Modules"):WaitForChild(
        "ClientReplicatedClasses"
    ):WaitForChild("ClientPlayerData")
)
local Data = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Data")
local RequestPlayerData = Data:WaitForChild("RequestPlayerData")
local PlayerDataChanged = Data:WaitForChild("PlayerDataChanged")
local PlayerDataAdded = Data:WaitForChild("PlayerDataAdded")
local t = {}
t.__index = t

function t._new() -- line: 16
    -- upvalues:
    --  [1] t (copy)
    --  [2] Signal_m (copy)

    local t_1 = setmetatable({}, t)
    t_1.PlayerDataAdded = Signal_m.new()
    t_1.StatisticsUpdated = Signal_m.new()
    t_1.SettingsSliderChanged = Signal_m.new()
    t_1.CurrentData = nil
    t_1._setting_changed_events = {}
    t_1:_Init()

    return t_1
end

function t.Get(arg1, ...) -- line: 36
    return arg1.CurrentData:Get(...)
end

function t.Set(arg2, ...) -- line: 40
    return arg2.CurrentData:Set(...)
end

function t.GetDataChangedSignal(arg3, ...) -- line: 44
    return arg3.CurrentData:GetDataChangedSignal(...)
end

function t.GetSetting(arg4, ...) -- line: 48
    -- upvalues:
    --  [1] ReplicatedStorage (copy)

    return require(ReplicatedStorage.Modules.PlayerDataUtility):GetSetting(arg4, ...)
end

function t.GetSettingChangedSignal(arg5, ...) -- line: 53
    -- upvalues:
    --  [1] ReplicatedStorage (copy)

    return require(ReplicatedStorage.Modules.PlayerDataUtility):GetSettingChangedSignal(arg5, ...)
end

function t.SetSetting(arg6, ...) -- line: 58
    -- upvalues:
    --  [1] ReplicatedStorage (copy)

    return require(ReplicatedStorage.Modules.PlayerDataUtility):SetSetting(arg6, ...)
end

function t.IsNosniyGamesTeamMember(arg7, ...) -- line: 63
    -- upvalues:
    --  [1] ReplicatedStorage (copy)

    return require(ReplicatedStorage.Modules.PlayerDataUtility):IsNosniyGamesTeamMember(arg7, ...)
end

function t.GetWeaponData(arg8, ...) -- line: 68
    -- upvalues:
    --  [1] ReplicatedStorage (copy)

    return require(ReplicatedStorage.Modules.PlayerDataUtility):GetWeaponData(arg8, ...)
end

function t.HasGamepass(arg9, ...) -- line: 73
    -- upvalues:
    --  [1] ReplicatedStorage (copy)

    return require(ReplicatedStorage.Modules.PlayerDataUtility):HasGamepass(arg9, ...)
end

function t.GetStatistic(arg10, ...) -- line: 78
    -- upvalues:
    --  [1] ReplicatedStorage (copy)

    return require(ReplicatedStorage.Modules.PlayerDataUtility):GetStatistic(arg10, ...)
end

function t.GetDirectoryStatistic(arg11, ...) -- line: 83
    -- upvalues:
    --  [1] ReplicatedStorage (copy)

    return require(ReplicatedStorage.Modules.PlayerDataUtility):GetDirectoryStatistic(arg11, ...)
end

function t.GetWeaponStatistic(arg12, ...) -- line: 88
    -- upvalues:
    --  [1] ReplicatedStorage (copy)

    return require(ReplicatedStorage.Modules.PlayerDataUtility):GetWeaponStatistic(arg12, ...)
end

function t.GetMapStatistic(arg13, ...) -- line: 93
    -- upvalues:
    --  [1] ReplicatedStorage (copy)

    return require(ReplicatedStorage.Modules.PlayerDataUtility):GetMapStatistic(arg13, ...)
end

function t.GetUnlockedWeapons(arg14, ...) -- line: 98
    -- upvalues:
    --  [1] ReplicatedStorage (copy)

    return require(ReplicatedStorage.Modules.PlayerDataUtility):GetUnlockedWeapons(arg14, ...)
end

function t.AreTasksCompleted(arg15, ...) -- line: 103
    -- upvalues:
    --  [1] ReplicatedStorage (copy)

    return require(ReplicatedStorage.Modules.PlayerDataUtility):AreTasksCompleted(arg15, ...)
end

function t.GetFavoritedWeapons(arg16) -- line: 108
    local t_2 = {}

    for _, val in pairs(arg16:Get("WeaponInventory")) do
        if val.IsFavorited then
            t_2[val.Name] = true
        end
    end

    return t_2
end

function t.OwnsAllWeapons(arg17, arg18, arg19, arg20) -- line: 120
    -- upvalues:
    --  [1] ReplicatedStorage (copy)

    local ItemLibrary_m = require(ReplicatedStorage.Modules.ItemLibrary)
    local ShopLibrary_m = require(ReplicatedStorage.Modules.ShopLibrary)
    local v5 = 0
    local v6 = 0
    local v8

    for _, val_1 in pairs(ShopLibrary_m:GetReleasedOwnableWeapons()) do
        if not arg18 or ItemLibrary_m.Items[val_1].Status == arg18 then
            v8 = not arg20 or ShopLibrary_m:IsWeaponReleased(val_1)
            local v9 = not arg19 or ShopLibrary_m.Weapons[val_1].KeyPrice
            v5 = if not v8 then v5 else if not v9 then v5 else v5 + 1
        end
    end

    for _, val_2 in pairs(arg17:Get("WeaponInventory")) do
        if not arg18 or ItemLibrary_m.Items[val_2.Name].Status == arg18 then
            v8 = not arg20 or ShopLibrary_m:IsWeaponReleased(val_2.Name)
            local v11 = not arg19 or ShopLibrary_m.Weapons[val_2.Name] and ShopLibrary_m.Weapons[val_2.Name].KeyPrice
            v6 = if not v8 then v6 else if not v11 then v6 else v6 + 1
        end
    end

    return v5 <= v6
end

function t.GetNumTasksCompleted(arg21, arg22) -- line: 156
    local v13 = 0

    for _, val_3 in pairs(arg21:Get(arg22 or "Tasks")) do
        if val_3.Completed then
            v13 += 1
        end
    end

    return v13
end

function t.IsEmoteEquipped(arg23, arg24) -- line: 168
    for _, val_4 in pairs(arg23:Get("EquippedEmotes")) do
        if val_4.Name == arg24 then
            return true
        end
    end
end

function t.SilenceCosmeticNotification(arg25, arg26, arg27) -- line: 176
    -- upvalues:
    --  [1] ReplicatedStorage (copy)

    if not arg26 then
        arg25.CurrentData:SetReplicate("CosmeticNotifications", {})
        ReplicatedStorage.Remotes.Data.SilenceCosmeticNotification:FireServer(nil, nil)

        return
    end

    local v16 = arg25:Get("CosmeticNotifications")

    if not arg27 then
        v16[arg26] = nil
        arg25.CurrentData:Replicate("CosmeticNotifications")
        ReplicatedStorage.Remotes.Data.SilenceCosmeticNotification:FireServer(arg26, nil)

        return
    end

    if typeof(v16[arg26]) == "table" then
        v16[arg26][arg27] = nil
        arg25.CurrentData:Replicate("CosmeticNotifications")
        ReplicatedStorage.Remotes.Data.SilenceCosmeticNotification:FireServer(arg26, arg27)
    end
end

function t.WaitUntilLoaded(arg28) -- line: 196
    if not arg28.CurrentData then
        arg28.PlayerDataAdded:Wait()
    end
end

function t._PlayerDataChanged(arg29, arg30, ...) -- line: 207
    -- upvalues:
    --  [1] EnumLibrary_m (copy)
    --  [2] ReplicatedStorage (copy)

    local CurrentData = arg29.CurrentData

    if not CurrentData then
        return
    end

    EnumLibrary_m:WaitForEnumBuilder()
    local v17 = EnumLibrary_m:FromEnum(arg30) or arg30

    if v17 == "DataValueChanged" then
        CurrentData:SetReplicate(...)

        return
    end

    if v17 == "BulkDataValueChanged" then
        for _, val_5 in pairs((...)) do
            CurrentData:SetReplicate(val_5[1], val_5[2])
        end

        return
    end

    if v17 == "StatisticsBatchUpdate" then
        local StatisticsLibrary_m = require(ReplicatedStorage.Modules.StatisticsLibrary)
        local v18 = ...
        local v19 = pairs
        local v20 = v18[utf8.char(0)] or {}

        for key_6, val_6 in v19(v20) do
            CurrentData:Set(CurrentData:FromEnum(key_6), val_6)
        end

        for key_7, val_7 in pairs(StatisticsLibrary_m.STATISTICS_DIRECTORY_INFO) do
            local v22, _ = table.unpack(val_7)
            local v25 = arg29:Get(v22)
            local v26 = pairs
            local v24 = v18[utf8.char(0 + key_7)] or {}

            for key_8, val_8 in v26(v24) do
                local v27 = CurrentData:FromEnum(key_8)
                local v28 = v25[v27] or {}
                v25[v27] = v28

                for key_9, val_9 in pairs(val_8) do
                    v25[v27][CurrentData:FromEnum(key_9)] = val_9
                end
            end
        end

        arg29.StatisticsUpdated:Fire()

        return
    end

    local v31

    if v17 == "WeaponDataChanged" then
        local v30 = ...
        v31 = CurrentData:Get("WeaponInventory")

        for key_10, val_10 in pairs(v31) do
            if val_10.Name == v30.Name then
                v31[key_10] = v30
                break
            end
        end

        CurrentData:Replicate("WeaponInventory")

        return
    end

    if v17 == "BatchUpdateWeaponXP" then
        v31 = false

        for _, val_11 in pairs((...)) do
            local v32 = arg29:GetWeaponData(CurrentData:FromEnum(val_11[utf8.char(0)]))

            if v32 then
                v32.Level = val_11[utf8.char(1)]
                v32.XP = val_11[utf8.char(2)]
                v31 = true
            end
        end

        if v31 then
            CurrentData:Replicate("WeaponInventory")

            return
        end
    else
        if v17 == "SettingChanged" then
            arg29:SetSetting(...)

            return
        end

        if v17 == "AddReceipt" then
            table.insert(CurrentData:Get("Receipts"), (...))
            CurrentData:Replicate("Receipts")

            return
        end

        CurrentData:ReplicateFromServer(v17, ...)
    end
end

function t._CreatePlayerData(arg31, arg32) -- line: 296
    -- upvalues:
    --  [1] ClientPlayerData_m (copy)

    assert(
        if typeof(arg32) ~= "table" then false else true,
        "Argument 1 invalid, expected a table, got " .. tostring(arg32)
    )
    local v35 = ClientPlayerData_m.new(arg32)
    arg31.CurrentData = v35
    arg31.PlayerDataAdded:Fire(v35)
end

function t._RequestPlayerData(arg33) -- line: 304
    -- upvalues:
    --  [1] RequestPlayerData (copy)

    local v36 = RequestPlayerData:InvokeServer()

    if not v36 then
        return
    end

    arg33:_CreatePlayerData(v36)
end

function t._Init(arg34) -- line: 314
    -- upvalues:
    --  [1] PlayerDataChanged (copy)
    --  [2] PlayerDataAdded (copy)

    PlayerDataChanged.OnClientEvent:Connect(function(...) -- line: 315
        -- upvalues:
        --  [1] arg34 (copy)

        arg34:_PlayerDataChanged(...)
    end)
    PlayerDataAdded.OnClientEvent:Connect(function(...) -- line: 319
        -- upvalues:
        --  [1] arg34 (copy)

        arg34:_CreatePlayerData(...)
    end)
    task.spawn(arg34._RequestPlayerData, arg34)
end

return t._new()
