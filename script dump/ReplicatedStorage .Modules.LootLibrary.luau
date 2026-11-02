local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CONSTANTS_m = require(ReplicatedStorage.Modules.CONSTANTS)
local CosmeticLibrary_m = require(ReplicatedStorage.Modules.CosmeticLibrary)
local ItemLibrary_m = require(ReplicatedStorage.Modules.ItemLibrary)
local ShopLibrary_m = require(ReplicatedStorage.Modules.ShopLibrary)
local t = {}
t.__index = t

function t._new() -- line: 13
    -- upvalues:
    --  [1] t (copy)

    local t_1 = setmetatable({}, t)
    t_1:_Init()

    return t_1
end

function t.GetCareerLevelsRewardMilestone(_) -- line: 25
    return 10
end

function t.GetCareerLevelsRewardData(_) -- line: 29
    return { Name = "Experience", Weapon = "IsRandom", Quantity = 1 }
end

function t.GetCostToLevelUp(arg3, arg4, arg5) -- line: 33
    local v1 = if not arg5 then 0 else arg5 / arg3:GetXPRequiredToLevelUp(arg4)
    local floorValue = math.floor(10 * (1 - v1))

    return (math.clamp(floorValue, 1, 10))
end

function t.GetCostToRefreshDailyShop(_, arg7) -- line: 38
    return (math.min(24, 3 * 2 ^ arg7))
end

function t.GetNextWeaponLevelReward(arg8, arg9, arg10) -- line: 42
    for index = arg9 + 1, 99 do
        local v2 = arg8:GetWeaponLevelReward(index, arg10)

        if v2 then
            return v2, index
        end
    end
end

function t.GetWeaponLevelReward(_, arg12, arg13) -- line: 52
    if arg12 == 5 then
        return { Name = "Key", Quantity = 1 }
    end

    if arg12 == 50 then
        return { Name = "White", Weapon = arg13 }
    end

    if arg12 == 99 then
        return { Name = "Black", Weapon = arg13 }
    end

    if arg12 % 10 == 0 then
        return
    end

    if arg12 % 5 == 0 then
    end
end

function t.GetXPRequiredToLevelUp(_, arg15) -- line: 66
    local floorValue_1 = math.floor(5 + 4 * (arg15 - 1) + (math.min(arg15, 99) / 40) ^ 2 * 100)

    return (math.max(50, floorValue_1))
end

function t.GetRecoverStreakCost(_, arg17) -- line: 70
    return (math.clamp(5 * 2 ^ arg17, 1, 100))
end

function t.CanCosmeticBeEarnedRandomly(_, arg19, arg20, arg21) -- line: 74
    -- upvalues:
    --  [1] CosmeticLibrary_m (copy)
    --  [2] ShopLibrary_m (copy)
    --  [3] ItemLibrary_m (copy)
    --  [4] CONSTANTS_m (copy)

    local v4 = CosmeticLibrary_m.Cosmetics[arg19]
    local v5 = if v4.Type ~= "Skin" then ShopLibrary_m.OwnableWeapons else { v4.ItemName } or ShopLibrary_m.OwnableWeapons

    for _, val in pairs(v5) do
        if
            (v4.Type ~= "Finisher" or ItemLibrary_m.Items[val].CanEliminate)
            and (if arg21[val] then not CosmeticLibrary_m:OwnsCosmetic(arg20, arg19, val) else ShopLibrary_m:IsWeaponReleased(
                val,
                CONSTANTS_m.WEAPON_EARLY_ACCESS_TIME_OFFSET
            ) and not CosmeticLibrary_m:OwnsCosmetic(arg20, arg19, val))
        then
            return true
        end
    end
end

function t.GetWeightedLootboxOutcome(_, arg23) -- line: 93
    local t_4 = {}
    local v6 = 0

    for _, val_1 in pairs(arg23) do
        v6 += val_1.Weight
        table.insert(t_4, { val_1.Weight, val_1.Reward })
    end

    table.sort(t_4, function(arg24, arg25) -- line: 102
        return arg24[1] < arg25[1]
    end)
    local v8 = math.random() * v6
    v6 = 0

    for key_2, val_2 in pairs(t_4) do
        v6 += val_2[1]

        if v6 > v8 or key_2 == #t_4 then
            return val_2[2]
        end
    end

    return t_4[#t_4] or nil
end

function t.GetLootboxPossibilities(
    arg26,
    arg27,
    arg28,
    arg29,
    arg30,
    arg31
) -- line: 120
    -- upvalues:
    --  [1] CosmeticLibrary_m (copy)
    --  [2] ShopLibrary_m (copy)
    --  [3] CONSTANTS_m (copy)

    local t_7

    if not arg27 then
        t_7 = {}

        return arg28, {}, t_7
    end

    local v10 = arg31 or "IsRandom"
    local t_6 = {}
    t_7 = {}
    local t_8 = {}

    local function attempt_cosmetic(arg32, arg33) -- line: 132
        -- upvalues:
        --  [1] CosmeticLibrary_m (ref)
        --  [2] arg30 (copy)
        --  [3] ShopLibrary_m (ref)
        --  [4] CONSTANTS_m (ref)
        --  [5] t_7 (ref)
        --  [6] v10 (copy)
        --  [7] arg26 (copy)
        --  [8] arg29 (copy)
        --  [9] t_8 (ref)
        --  [10] t_6 (copy)

        local Name = arg32.Reward.Name
        local v12 = CosmeticLibrary_m.Cosmetics[Name]

        if
            v12.Type == "Skin"
            and not arg30[v12.ItemName]
            and not ShopLibrary_m:IsWeaponReleased(
                v12.ItemName,
                CONSTANTS_m.WEAPON_EARLY_ACCESS_TIME_OFFSET
            )
        then
            return
        end

        if v12.ItemName and not arg33 and not arg30[v12.ItemName] then
            table.insert(t_7, arg32)

            return
        end

        if if v10 == "IsRandom" then not arg26:CanCosmeticBeEarnedRandomly(Name, arg29, arg30) else if v10 == "IsUniversal" then CosmeticLibrary_m:OwnsCosmeticUniversally(
            arg29,
            Name
        ) else CosmeticLibrary_m:OwnsCosmetic(arg29, Name, v10) then
            table.insert(t_8, arg32)

            return
        end

        table.insert(t_6, arg32)
    end

    local _ = function(arg34) --[[ attempt_reward ]] -- line: 161
        -- upvalues:
        --  [1] CosmeticLibrary_m (ref)
        --  [2] arg30 (copy)
        --  [3] t_8 (ref)
        --  [4] t_6 (copy)

        local Name_1 = arg34.Reward.Name

        if CosmeticLibrary_m.Rewards[Name_1].Type == "Weapon" then
            if arg30[Name_1] then
                table.insert(t_8, arg34)

                return
            end

            table.insert(t_6, arg34)

            return
        else
            table.insert(t_6, arg34)

            return
        end
    end

    local function populate(arg35) -- line: 179
        -- upvalues:
        --  [1] arg28 (copy)
        --  [2] CosmeticLibrary_m (ref)
        --  [3] attempt_cosmetic (copy)
        --  [4] arg30 (copy)
        --  [5] t_8 (ref)
        --  [6] t_6 (copy)

        for _, val_3 in pairs(arg28) do
            if CosmeticLibrary_m.Cosmetics[val_3.Reward.Name] then
                attempt_cosmetic(val_3, arg35)
            elseif CosmeticLibrary_m.Rewards[val_3.Reward.Name] then
                local Name_2 = val_3.Reward.Name

                if CosmeticLibrary_m.Rewards[Name_2].Type == "Weapon" then
                    if arg30[Name_2] then
                        table.insert(t_8, val_3)
                    else
                        table.insert(t_6, val_3)
                    end
                else
                    table.insert(t_6, val_3)
                end
            else
                assert(false, val_3.Reward.Name)
            end
        end
    end

    populate()

    if #t_6 == 0 then
        t_7 = {}
        t_8 = {}
        populate(true)
    end

    return t_6, t_7, t_8
end

function t.GetUnlockedWeaponsForSelection(
    _,
    arg37,
    arg38,
    arg39,
    arg40
) -- line: 202
    -- upvalues:
    --  [1] CosmeticLibrary_m (copy)
    --  [2] ItemLibrary_m (copy)
    --  [3] ShopLibrary_m (copy)
    --  [4] CONSTANTS_m (copy)

    local _ = function(arg41) --[[ is_valid_option ]] -- line: 203
        -- upvalues:
        --  [1] arg39 (copy)
        --  [2] CosmeticLibrary_m (ref)
        --  [3] arg40 (copy)
        --  [4] ItemLibrary_m (ref)

        if not arg39 then
            return true
        end

        local v14 = CosmeticLibrary_m.Cosmetics[arg39]
        local v15 = not CosmeticLibrary_m:OwnsCosmetic(arg40, arg39, arg41)

        return v15 and not (v14.Type == "Skin" and arg41 ~= v14.ItemName or (if v14.Type ~= "Finisher" then false else not ItemLibrary_m.Items[arg41].CanEliminate))
    end

    local t_9 = {}
    local v18

    for _, val_4 in pairs(arg37) do
        local Name_3 = val_4.Name

        if not arg39 then
            v18 = true
        else
            local v19 = CosmeticLibrary_m.Cosmetics[arg39]
            local v20 = not CosmeticLibrary_m:OwnsCosmetic(arg40, arg39, Name_3)
            local v21 = v19.Type == "Skin" and Name_3 ~= v19.ItemName or (if v19.Type ~= "Finisher" then false else not ItemLibrary_m.Items[Name_3].CanEliminate)
            v18 = v20

            if v18 then
                v18 = not v21
            end
        end

        if v18 then
            table.insert(t_9, val_4.Name)
        end
    end

    if #t_9 > 0 then
        return t_9
    end

    if not arg38 then
        return {}
    end

    local t_10 = {}

    for _, val_5 in pairs(
        ShopLibrary_m:GetReleasedOwnableWeapons(CONSTANTS_m.WEAPON_EARLY_ACCESS_TIME_OFFSET)
    ) do
        if not arg39 then
            v18 = true
        else
            local v23 = CosmeticLibrary_m.Cosmetics[arg39]
            local _ = table.insert
            local v24 = not CosmeticLibrary_m:OwnsCosmetic(arg40, arg39, val_5)
            local v25 = v23.Type == "Skin" and val_5 ~= v23.ItemName or (if v23.Type ~= "Finisher" then false else not ItemLibrary_m.Items[val_5].CanEliminate)
            v18 = v24

            if v18 then
                v18 = not v25
            end
        end

        if v18 then
            table.insert(t_10, val_5)
        end
    end

    return t_10
end

function t.GetRandomUnlockedWeapon(arg42, ...) -- line: 242
    local v26 = arg42:GetUnlockedWeaponsForSelection(...)

    if not v26 or #v26 == 0 then
        return nil
    end

    return v26[math.random(#v26)]
end

function t._Init(_) -- line: 256
end

return t._new()
