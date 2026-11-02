local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local CosmeticLibrary_m = require(ReplicatedStorage.Modules.CosmeticLibrary)
local BetterDebris_m = require(ReplicatedStorage.Modules.BetterDebris)
local ItemLibrary_m = require(ReplicatedStorage.Modules.ItemLibrary)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local PlayerDataController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.PlayerDataController
)
local CosmeticSlot_m = require(Players.LocalPlayer.PlayerScripts.Modules.CosmeticSlot)
local CosmeticSlotNotification = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild(
    "CosmeticSlotNotification"
)
local CosmeticSlotEmpty = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild(
    "CosmeticSlotEmpty"
)
local t = {}
t.__index = t

function t.new(arg1) -- line: 23
    -- upvalues:
    --  [1] t (copy)

    local t_1 = setmetatable({}, t)
    t_1.Customize = arg1
    t_1.List = t_1.Customize.BottomContainer:WaitForChild("List")
    t_1.Container = t_1.List:WaitForChild("Container")
    t_1.Layout = t_1.Container:WaitForChild("Layout")
    t_1._cosmetic_slots = {}
    t_1._empty_cosmetic_slots = {}
    t_1._generate_hash = 0
    t_1:_Init()

    return t_1
end

function t.OnCustomizingStateChanged(arg2) -- line: 44
    arg2:_BulkUpdateEquipped()
    arg2:_BulkUpdateSearch()
end

function t.OnStateChanged(arg3) -- line: 49
    arg3:_BulkUpdateEquipped()
    task.defer(arg3._Generate, arg3)
end

function t._UpdateFavorited(arg4, arg5) -- line: 58
    -- upvalues:
    --  [1] PlayerDataController_m (copy)
    --  [2] CosmeticLibrary_m (copy)

    local v1 = PlayerDataController_m:Get("FavoritedCosmetics")
    local v2 = arg4.Customize.Interface.Equipment:GetSelectedWeapon()
    local v3 = arg4.Customize.Interface.Equipment:GetCustomizingType()
    local v4 = v1[v2]

    if v4 then
        v4 = v1[v2][CosmeticLibrary_m:GetNoneSpecificCosmeticName(arg5, v3)]
    end

    arg4._cosmetic_slots[arg5].Frame.Button.Favorited.Visible = v4
    local v7 = if not v4 then 0 else -9999999
    arg4._cosmetic_slots[arg5].Frame.LayoutOrder = arg4._cosmetic_slots[arg5].OriginalLayoutOrder + v7
    arg4._cosmetic_slots[arg5].Frame.ZIndex = arg4._cosmetic_slots[arg5].Frame.LayoutOrder
end

function t._BulkUpdateFavorited(arg6) -- line: 69
    for key, _ in pairs(arg6._cosmetic_slots) do
        arg6:_UpdateFavorited(key)
    end
end

function t._UpdateSearch(arg7, arg8) -- line: 75
    -- upvalues:
    --  [1] CosmeticLibrary_m (copy)
    --  [2] Utility_m (copy)

    local v8 = CosmeticLibrary_m.Cosmetics[arg8]
    local v9 = v8 and v8.GetDescription(false)
    local v10 = true
    local Frame_1 = arg7._cosmetic_slots[arg8].Frame

    if arg8 ~= "NONE_COSMETIC" then
        v10 = Utility_m:IsVisibleFromSearch(
            arg7.Customize.Interface.Equipment:GetCosmeticSearchQuery(),
            arg7._cosmetic_slots[arg8].Frame.Button.Title.ContentText,
            arg7._cosmetic_slots[arg8].Frame.Button.Title,
            v9,
            nil
        )
    end

    Frame_1.Visible = v10
end

function t._BulkUpdateSearch(arg9) -- line: 86
    for key_1, _ in pairs(arg9._cosmetic_slots) do
        arg9:_UpdateSearch(key_1)
    end
end

function t._IsEquipped(arg10, arg11) -- line: 92
    -- upvalues:
    --  [1] PlayerDataController_m (copy)

    local v13 = arg10.Customize.Interface.Equipment:GetSelectedWeapon()
    local v14 = arg10.Customize.Interface.Equipment:GetCustomizingType()

    if v14 == "Emote" then
        if arg11 == "NONE_COSMETIC" then
            return false
        end

        return (PlayerDataController_m:IsEmoteEquipped(arg11))
    else
        local v16 = PlayerDataController_m:GetWeaponData(v13)
        local v17 = v16

        if v17 then
            v17 = v16[v14]
        end

        if arg11 == "NONE_COSMETIC" then
            return not v17
        end

        return v17 and arg11 == v17.Name
    end
end

function t._UpdateEquipped(arg12, arg13) -- line: 109
    arg12._cosmetic_slots[arg13].Frame.Button.Equipped.Visible = arg12:_IsEquipped(arg13)
end

function t._BulkUpdateEquipped(arg14) -- line: 113
    if not arg14.Customize.Interface.Equipment.IsOpen then
        return
    end

    for key_2, _ in pairs(arg14._cosmetic_slots) do
        arg14:_UpdateEquipped(key_2)
    end
end

function t._Cleanup(arg15) -- line: 124
    -- upvalues:
    --  [1] BetterDebris_m (copy)

    local v18 = 0

    for _, val_3 in pairs(arg15._cosmetic_slots) do
        val_3.Frame.Parent = nil
        BetterDebris_m:AddItem(val_3, v18 * 0.1)
        v18 += 1
    end

    for _, val_4 in pairs(arg15._empty_cosmetic_slots) do
        val_4:Destroy()
    end

    arg15._cosmetic_slots = {}
    arg15._empty_cosmetic_slots = {}
    arg15._generate_hash += 1
end

function t._Generate(arg16) -- line: 148
    -- upvalues:
    --  [1] CosmeticLibrary_m (copy)
    --  [2] PlayerDataController_m (copy)
    --  [3] CosmeticSlot_m (copy)
    --  [4] CosmeticSlotNotification (copy)
    --  [5] ItemLibrary_m (copy)
    --  [6] ReplicatedStorage (copy)
    --  [7] CosmeticSlotEmpty (copy)

    arg16:_Cleanup()
    arg16._generate_hash += 1
    local GenerateHash = arg16._generate_hash
    local v20 = arg16.Customize.Interface.Equipment:GetSelectedWeapon()
    local v21 = arg16.Customize.Interface.Equipment:GetSelectedCosmetic()
    local v22 = arg16.Customize.Interface.Equipment:GetCustomizingType()
    local v23 = v22

    if v23 then
        v23 = CosmeticLibrary_m.Types[v22] and CosmeticLibrary_m.Types[v22].IsWeaponCosmetic
    end

    local v24 = PlayerDataController_m:Get("CosmeticNotifications")
    local v25 = PlayerDataController_m:Get("CosmeticInventory")

    if not v22 or v23 and not v20 then
        return
    end

    local v26 = 0
    local t_2 = {}

    for key_5, val_5 in pairs(CosmeticLibrary_m.CosmeticsAlphabetized) do
        local v27 = CosmeticLibrary_m.Cosmetics[val_5]
        local v28 = v27.Type == v22
        local v29 = v22 ~= "Skin" or v27.ItemName == v20

        if v28 and v29 then
            v29 = CosmeticLibrary_m:HasNotification(v24, val_5, v20)
            v28 = not CosmeticLibrary_m:OwnsCosmetic(v25, val_5, v20)
            local v32 = arg16:_IsEquipped(val_5)
            v26 += if v28 then 0 else 1
            table.insert(
                t_2,
                {
                    Name = val_5,
                    HasNotification = v29 or false,
                    IsLocked = v28,
                    IsEquipped = v32,
                    AlphabeticalValue = key_5
                }
            )
        end
    end

    table.sort(t_2, function(arg17, arg18) -- line: 192
        -- upvalues:
        --  [1] CosmeticLibrary_m (ref)

        local IsEquipped = arg17.IsEquipped

        if IsEquipped ~= arg18.IsEquipped then
            return IsEquipped
        end

        local IsLocked = arg17.IsLocked

        if IsLocked ~= arg18.IsLocked then
            return not IsLocked
        end

        local HasNotification = arg17.HasNotification

        if HasNotification ~= arg18.HasNotification then
            return HasNotification
        end

        local Value = CosmeticLibrary_m.Rarities[CosmeticLibrary_m.Cosmetics[arg17.Name].Rarity].Value
        local Value_1 = CosmeticLibrary_m.Rarities[CosmeticLibrary_m.Cosmetics[arg18.Name].Rarity].Value

        return if Value == Value_1 then arg17.AlphabeticalValue < arg18.AlphabeticalValue else Value_1 < Value
    end)
    local g_next = next

    if not v21 and v22 == "Emote" and not g_next(PlayerDataController_m:Get("EquippedEmotes")) then
        arg16.Customize.Interface.Equipment:SelectCosmetic("Take The L")
    end

    v25 = if v22 ~= "Emote" then 5 else 1
    local v34 = 0

    local function generate_slot(arg19, arg20, arg21) -- line: 233
        -- upvalues:
        --  [1] CosmeticLibrary_m (ref)
        --  [2] CosmeticSlot_m (ref)
        --  [3] v34 (ref)
        --  [4] arg16 (copy)
        --  [5] CosmeticSlotNotification (ref)
        --  [6] PlayerDataController_m (ref)
        --  [7] ItemLibrary_m (ref)
        --  [8] v20 (copy)
        --  [9] v23 (copy)
        --  [10] ReplicatedStorage (ref)
        --  [11] v22 (copy)
        --  [12] v25 (copy)

        local v35 = CosmeticLibrary_m.Cosmetics[arg19]

        if v35 and v35.Hidden and arg20 then
            return
        end

        local v36 = CosmeticSlot_m.new(arg19, arg20)
        local v38 = if v35 then 0 else -999999999
        v36.OriginalLayoutOrder = v34 + v38 + (if v35 and arg16:_IsEquipped(arg19) then -99999999 else 0)
        v36.Frame.LayoutOrder = v36.OriginalLayoutOrder
        v36.Frame.Parent = arg16.Container
        arg16._cosmetic_slots[arg19] = v36
        v34 += 1
        arg16:_UpdateSearch(arg19)
        arg16:_UpdateEquipped(arg19)
        arg16:_UpdateFavorited(arg19)
        local v40 = nil

        if arg21 then
            v40 = CosmeticSlotNotification:Clone()
            v40.Parent = v36.Frame.Button
        end

        v36.Frame.Button.MouseButton1Click:Connect(function() -- line: 264
            -- upvalues:
            --  [1] v40 (ref)
            --  [2] PlayerDataController_m (ref)
            --  [3] arg19 (copy)
            --  [4] ItemLibrary_m (ref)
            --  [5] v20 (ref)
            --  [6] arg16 (ref)
            --  [7] arg20 (copy)
            --  [8] v23 (ref)
            --  [9] ReplicatedStorage (ref)
            --  [10] v22 (ref)

            if v40 then
                v40:Destroy()
                v40 = nil
                local v41 = PlayerDataController_m
                v41:SilenceCosmeticNotification(arg19, ItemLibrary_m.Items[v20] and v20 or nil)
            end

            arg16.Customize.Interface.Equipment:SelectCosmetic(arg19)

            if v20 and not arg20 and v23 then
                local v44 = PlayerDataController_m:GetWeaponData(v20)
                local v45 = if arg19 == "NONE_COSMETIC" then nil else arg19
                local v46 = v44 and v44.Wrap and v44.Wrap.Inverted or nil
                ReplicatedStorage.Remotes.Data.EquipCosmetic:FireServer(
                    v20,
                    v22,
                    v45,
                    { IsInverted = v46 }
                )
            end
        end)

        if not arg16.Customize.Interface.Equipment:GetSelectedCosmetic() and arg16:_IsEquipped(
            arg19
        ) then
            arg16.Customize.Interface.Equipment:SelectCosmetic(arg19)
        end

        if v34 % v25 == 0 then
            wait(0.06)
        end
    end

    if v23 then
        generate_slot("NONE_COSMETIC", false)

        if GenerateHash ~= arg16._generate_hash then
            return
        end
    end

    if v23 and v26 > 0 then
        generate_slot("RANDOM_COSMETIC", false)

        if GenerateHash ~= arg16._generate_hash then
            return
        end
    end

    for _, val_6 in pairs(t_2) do
        generate_slot(val_6.Name, val_6.IsLocked, val_6.HasNotification)

        if GenerateHash ~= arg16._generate_hash then
            return
        end
    end

    for _ = 1, 11 do
        local v47 = CosmeticSlotEmpty:Clone()
        v47.LayoutOrder = 999999999
        v47.Parent = arg16.Container
        table.insert(arg16._empty_cosmetic_slots, v47)
    end
end

function t._Init(arg22) -- line: 332
    -- upvalues:
    --  [1] PlayerDataController_m (copy)

    arg22.Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() -- line: 333
        -- upvalues:
        --  [1] arg22 (copy)

        arg22.List.CanvasSize = UDim2.new(0, arg22.Layout.AbsoluteContentSize.X, 0, 0)
    end)
    arg22.Customize.Interface.Equipment.CosmeticSearchChanged:Connect(function() -- line: 337
        -- upvalues:
        --  [1] arg22 (copy)

        arg22:_BulkUpdateSearch()
    end)
    PlayerDataController_m:GetDataChangedSignal("WeaponInventory"):Connect(function() -- line: 341
        -- upvalues:
        --  [1] arg22 (copy)

        arg22:_BulkUpdateEquipped()
    end)
    PlayerDataController_m:GetDataChangedSignal("EquippedEmotes"):Connect(function() -- line: 345
        -- upvalues:
        --  [1] arg22 (copy)

        arg22:_BulkUpdateEquipped()
    end)
    PlayerDataController_m:GetDataChangedSignal("CosmeticInventory"):Connect(function() -- line: 349
        -- upvalues:
        --  [1] arg22 (copy)

        arg22:_BulkUpdateEquipped()
    end)
    PlayerDataController_m:GetDataChangedSignal("FavoritedCosmetics"):Connect(function() -- line: 353
        -- upvalues:
        --  [1] arg22 (copy)

        arg22:_BulkUpdateFavorited()
    end)
end

return t
