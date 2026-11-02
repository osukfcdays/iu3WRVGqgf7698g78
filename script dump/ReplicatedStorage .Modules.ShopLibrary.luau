local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CONSTANTS_m = require(ReplicatedStorage.Modules.CONSTANTS)
local EventLibrary_m = require(ReplicatedStorage.Modules.EventLibrary)
local ServerOsTime_m = require(ReplicatedStorage.Modules.ServerOsTime)
local ItemLibrary_m = require(ReplicatedStorage.Modules.ItemLibrary)
local TestLibrary_m = require(ReplicatedStorage.Modules.TestLibrary)
local ShopEntry_m = require(ReplicatedStorage.Modules.ShopEntry)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local v1 = if CONSTANTS_m.IS_STUDIO then TestLibrary_m:GetTestAttribute(
    "StudioTestUnreleasedWeapons"
) else CONSTANTS_m.IS_TESTING_SERVER
local StudioEnableFlashSales = TestLibrary_m:GetTestAttribute("StudioEnableFlashSales")
local t = {
    NUM_GLORIOUS_COSMETICS = {},
    Entries = {},
    Weapons = {},
    OwnableWeapons = {},
    OwnableWeaponsAlphabetized = {},
    OwnableWeaponsCanEliminate = {},
    OwnableWeaponReleaseSchedule = {},
    DailyShopCosmeticTypes = {},
    FlashSales = {},
    Lootboxes = {},
    GetWeaponKeyPriceInfo = function(arg1, arg2, arg3, arg4) --[[ GetWeaponKeyPriceInfo ]] -- line: 30
        -- upvalues:
        --  [1] ItemLibrary_m (copy)

        local v2 = arg4[arg2]
        local v3 = v2 or arg3 > 0 and ItemLibrary_m.Items[arg2] and ItemLibrary_m.Items[arg2].Status == "Standard"

        return if not v3 then arg1.Weapons[arg2] and arg1.Weapons[arg2].KeyPrice or math.huge else 0, v3, v2, arg3
    end,
    GetReleasedOwnableWeapons = function(arg5, arg6, arg7) --[[ GetReleasedOwnableWeapons ]] -- line: 38
        local t_1 = {}
        local v5 = pairs
        local v6 = arg7 or arg5.OwnableWeapons

        for _, val in v5(v6) do
            if arg5:IsWeaponReleased(val, arg6) then
                table.insert(t_1, val)
            end
        end

        return t_1
    end,
    GetTimeUntilWeaponRelease = function(arg8, arg9) --[[ GetTimeUntilWeaponRelease ]] -- line: 50
        -- upvalues:
        --  [1] ServerOsTime_m (copy)

        local v7 = arg8.Weapons[arg9]

        return (v7 and v7.ReleaseTime or 0) - ServerOsTime_m:GetRounded()
    end,
    IsWeaponReleased = function(arg10, arg11, arg12) --[[ IsWeaponReleased ]] -- line: 56
        local v9 = arg10.Weapons[arg11]

        if v9 then
            v9 = arg10:GetTimeUntilWeaponRelease(arg11) <= (arg12 or 0) and true
        end

        return v9
    end,
    GetUpcomingWeapon = function(arg13) --[[ GetUpcomingWeapon ]] -- line: 60
        for key_1, val_1 in pairs(arg13.OwnableWeaponReleaseSchedule) do
            if arg13:GetTimeUntilWeaponRelease(val_1) > 0 then
                return val_1, key_1
            end
        end
    end
}

local function add_weapon(arg14, arg15, arg16) -- line: 68
    -- upvalues:
    --  [1] ItemLibrary_m (copy)
    --  [2] v1 (copy)
    --  [3] t (copy)
    --  [4] Utility_m (copy)

    local v11 = ItemLibrary_m.Items[arg14]
    local v12 = if not v1 then arg16 or 0 else #t.OwnableWeapons
    t.Weapons[arg14] = { Weapon = arg14, KeyPrice = arg15, ReleaseTime = v12 }
    table.insert(t.OwnableWeapons, arg14)
    table.insert(t.OwnableWeaponsAlphabetized, arg14)

    if v11.CanEliminate then
        table.insert(t.OwnableWeaponsCanEliminate, arg14)
    end

    table.sort(t.OwnableWeaponsAlphabetized, function(arg17, arg18) -- line: 86
        -- upvalues:
        --  [1] Utility_m (ref)

        return Utility_m:StringLessThan(string.lower(arg17), string.lower(arg18))
    end)
end

add_weapon("Assault Rifle", 0)
add_weapon("Bow", 15)
add_weapon("Burst Rifle", 25)
add_weapon("Flamethrower", 400)
add_weapon("Grenade Launcher", 425)
add_weapon("Minigun", 450)
add_weapon("Paintball Gun", 475)
add_weapon("RPG", 25)
add_weapon("Shotgun", 20)
add_weapon("Sniper", 75)
add_weapon("Handgun", 0)
add_weapon("Flare Gun", 10)
add_weapon("Exogun", 350)
add_weapon("Revolver", 25)
add_weapon("Shorty", 20)
add_weapon("Slingshot", 300)
add_weapon("Uzi", 20)
add_weapon("Fists", 0)
add_weapon("Chainsaw", 15)
add_weapon("Katana", 45)
add_weapon("Knife", 20)
add_weapon("Scythe", 40)
add_weapon("Trowel", 200)
add_weapon("Grenade", 0)
add_weapon("Flashbang", 15)
add_weapon("Medkit", 300)
add_weapon("Molotov", 25)
add_weapon("Smoke Grenade", 10)
add_weapon("Subspace Tripmine", 250)
add_weapon("Freeze Ray", 45, 1720886400)
add_weapon("War Horn", 30, 1735275600)
add_weapon("Satchel", 35, 1734670800)
add_weapon("Battle Axe", 50, 1734066000)
add_weapon("Riot Shield", 45, 1735880400)
add_weapon("Daggers", 30, 1733461200)
add_weapon("Energy Pistols", 400)
add_weapon("Energy Rifle", 425)
add_weapon("Spray", 5, 1736485200)
add_weapon("Crossbow", 35, 1732770000)
add_weapon("Gunblade", 45, 1737090000)
add_weapon("Jump Pad", nil)
add_weapon("Distortion", 700)
add_weapon("Warper", 650)
add_weapon("Warpstone", 400)
add_weapon("Maul", 550)
add_weapon("Permafrost", 600)
add_weapon("Spear", nil)
add_weapon("Grappler", nil)
add_weapon("Wildcat", 35)

local function add_shop_entry(...) -- line: 142
    -- upvalues:
    --  [1] ShopEntry_m (copy)
    --  [2] t (copy)

    local v14 = ShopEntry_m.new(...)
    t.Entries[v14.EntryName] = v14

    return v14
end

add_shop_entry(
    "Loose",
    "loose_arena",
    { { Name = "Arena", Weapon = "IsRandom" } },
    { WeaponKeys = 25 }
)
add_shop_entry(
    "Loose",
    "loose_randomwrap",
    { { Name = "Nightmare", Weapon = "IsRandom" } },
    { WeaponKeys = 25 },
    nil,
    true
)
add_shop_entry(
    "Loose",
    "loose_universalwrap",
    { { Name = "Ravensoul", Weapon = "IsUniversal" } },
    { WeaponKeys = 250 },
    nil,
    true
)
add_shop_entry(
    "Loose",
    "loose_glorycharm",
    { { Name = "Emoji: Imp", Weapon = "IsUniversal" } },
    { Glory = 250 }
)
add_shop_entry(
    "Loose",
    "loose_gloryfinisher",
    { { Name = "Impaled", Weapon = "IsUniversal" } },
    { Glory = 500 }
)
add_shop_entry("Loose", "loose_gloryemote", { { Name = "Flex" } }, { Glory = 1000 })
add_shop_entry(
    "Loose",
    "loose_glorywrap",
    { { Name = "Black Glass", Weapon = "IsUniversal" } },
    { Glory = 2000 }
)
local v15

if EventLibrary_m.IS_ACTIVE then
    add_shop_entry(
        "Loose",
        "loose_" .. EventLibrary_m.UNIVERSAL_SHOP_CHARM,
        { { Name = EventLibrary_m.UNIVERSAL_SHOP_CHARM, Weapon = "IsUniversal" } },
        { EventCurrency = 1000 },
        nil,
        true
    )
    add_shop_entry(
        "Loose",
        "loose_" .. EventLibrary_m.UNIVERSAL_SHOP_WRAP,
        { { Name = EventLibrary_m.UNIVERSAL_SHOP_WRAP, Weapon = "IsUniversal" } },
        { EventCurrency = 2000 },
        nil,
        true
    )
    add_shop_entry(
        "Loose",
        "loose_" .. EventLibrary_m.UNIVERSAL_SHOP_FINISHER,
        { { Name = EventLibrary_m.UNIVERSAL_SHOP_FINISHER, Weapon = "IsUniversal" } },
        { EventCurrency = 3000 },
        nil,
        true
    )
    add_shop_entry(
        "Loose",
        "loose_" .. EventLibrary_m.UNIVERSAL_SHOP_EMOTE,
        { { Name = EventLibrary_m.UNIVERSAL_SHOP_EMOTE } },
        { EventCurrency = 5000 },
        nil,
        true
    )

    if EventLibrary_m.STANDALONE_SHOP_SKIN then
        v15 = { [3605561707] = 1 }
        add_shop_entry(
            "Loose",
            EventLibrary_m.STANDALONE_SHOP_SKIN_SHOP_ENTRY_NAME,
            { EventLibrary_m.STANDALONE_SHOP_SKIN },
            nil,
            v15,
            true
        )
    end
end

for _, val_2 in pairs(
    t:GetReleasedOwnableWeapons(
        CONSTANTS_m.WEAPON_EARLY_ACCESS_TIME_OFFSET,
        t.OwnableWeaponsAlphabetized
    )
) do
    v15 = 0

    for index = 1, 4 do
        if index ~= 3 or ItemLibrary_m.Items[val_2].CanEliminate then
            v15 += 1
            local v17 = "loose_gloriouscosmetic_" .. v15 .. "_" .. val_2
            local v18 = if index == 1 then "Glory Coin" else if index == 2 then "Glorious" else if index == 3 then "For Glory" else if index == 4 then "Glorious " .. val_2 else assert(
                false,
                "???"
            )
            local v19 = if index == 1 then 100 else if index == 2 then 200 else if index == 3 then 300 else if index == 4 then 400 else assert(
                false,
                "???"
            )
            add_shop_entry("Loose", v17, { { Name = v18, Weapon = val_2 } }, { Glory = v19 })
            t.NUM_GLORIOUS_COSMETICS[val_2] = (t.NUM_GLORIOUS_COSMETICS[val_2] or 0) + 1
        end
    end
end

local _ = function(arg19, arg20) --[[ add_daily_shop_cosmetic_type ]] -- line: 231
    -- upvalues:
    --  [1] t (copy)

    t.DailyShopCosmeticTypes[arg19] = { PricesByRarity = arg20, CosmeticNames = {} }
end

t.DailyShopCosmeticTypes.Emote = {
    PricesByRarity = {
        Common = { WeaponKeys = 50 },
        Rare = { WeaponKeys = 75 },
        Legendary = { WeaponKeys = 100 }
    },
    CosmeticNames = {}
}

local _ = function(arg21, arg22) --[[ add_daily_shop_cosmetic ]] -- line: 242
    -- upvalues:
    --  [1] t (copy)
    --  [2] ReplicatedStorage (copy)

    table.insert(t.DailyShopCosmeticTypes[arg21].CosmeticNames, arg22)
    task.defer(function() -- line: 245
        -- upvalues:
        --  [1] ReplicatedStorage (ref)
        --  [2] arg22 (copy)

        require(ReplicatedStorage.Modules.CosmeticLibrary):ExternallySetCosmeticDescription(
            arg22,
            "Can be purchased from the Daily Shop"
        )
    end)
end

table.insert(t.DailyShopCosmeticTypes.Emote.CosmeticNames, "Shoulder Brush")
local v21 = "Shoulder Brush"
task.defer(function() -- line: 245
    -- upvalues:
    --  [1] ReplicatedStorage (copy)
    --  [2] v21 (copy)

    require(ReplicatedStorage.Modules.CosmeticLibrary):ExternallySetCosmeticDescription(
        v21,
        "Can be purchased from the Daily Shop"
    )
end)
table.insert(t.DailyShopCosmeticTypes.Emote.CosmeticNames, "Vegetable")
local v22 = "Vegetable"
task.defer(function() -- line: 245
    -- upvalues:
    --  [1] ReplicatedStorage (copy)
    --  [2] v22 (copy)

    require(ReplicatedStorage.Modules.CosmeticLibrary):ExternallySetCosmeticDescription(
        v22,
        "Can be purchased from the Daily Shop"
    )
end)
table.insert(t.DailyShopCosmeticTypes.Emote.CosmeticNames, "Coo Coo")
local v23 = "Coo Coo"
task.defer(function() -- line: 245
    -- upvalues:
    --  [1] ReplicatedStorage (copy)
    --  [2] v23 (copy)

    require(ReplicatedStorage.Modules.CosmeticLibrary):ExternallySetCosmeticDescription(
        v23,
        "Can be purchased from the Daily Shop"
    )
end)
table.insert(t.DailyShopCosmeticTypes.Emote.CosmeticNames, "Denial")
local v24 = "Denial"
task.defer(function() -- line: 245
    -- upvalues:
    --  [1] ReplicatedStorage (copy)
    --  [2] v24 (copy)

    require(ReplicatedStorage.Modules.CosmeticLibrary):ExternallySetCosmeticDescription(
        v24,
        "Can be purchased from the Daily Shop"
    )
end)
table.insert(t.DailyShopCosmeticTypes.Emote.CosmeticNames, "Facepalm")
local v25 = "Facepalm"
task.defer(function() -- line: 245
    -- upvalues:
    --  [1] ReplicatedStorage (copy)
    --  [2] v25 (copy)

    require(ReplicatedStorage.Modules.CosmeticLibrary):ExternallySetCosmeticDescription(
        v25,
        "Can be purchased from the Daily Shop"
    )
end)
table.insert(t.DailyShopCosmeticTypes.Emote.CosmeticNames, "Kneel")
local v26 = "Kneel"
task.defer(function() -- line: 245
    -- upvalues:
    --  [1] ReplicatedStorage (copy)
    --  [2] v26 (copy)

    require(ReplicatedStorage.Modules.CosmeticLibrary):ExternallySetCosmeticDescription(
        v26,
        "Can be purchased from the Daily Shop"
    )
end)
table.insert(t.DailyShopCosmeticTypes.Emote.CosmeticNames, "Agree")
local v27 = "Agree"
task.defer(function() -- line: 245
    -- upvalues:
    --  [1] ReplicatedStorage (copy)
    --  [2] v27 (copy)

    require(ReplicatedStorage.Modules.CosmeticLibrary):ExternallySetCosmeticDescription(
        v27,
        "Can be purchased from the Daily Shop"
    )
end)
table.insert(t.DailyShopCosmeticTypes.Emote.CosmeticNames, "Think")
local v28 = "Think"
task.defer(function() -- line: 245
    -- upvalues:
    --  [1] ReplicatedStorage (copy)
    --  [2] v28 (copy)

    require(ReplicatedStorage.Modules.CosmeticLibrary):ExternallySetCosmeticDescription(
        v28,
        "Can be purchased from the Daily Shop"
    )
end)
table.insert(t.DailyShopCosmeticTypes.Emote.CosmeticNames, "Salty")
local v29 = "Salty"
task.defer(function() -- line: 245
    -- upvalues:
    --  [1] ReplicatedStorage (copy)
    --  [2] v29 (copy)

    require(ReplicatedStorage.Modules.CosmeticLibrary):ExternallySetCosmeticDescription(
        v29,
        "Can be purchased from the Daily Shop"
    )
end)
table.insert(t.DailyShopCosmeticTypes.Emote.CosmeticNames, "Superhero")
local v30 = "Superhero"
task.defer(function() -- line: 245
    -- upvalues:
    --  [1] ReplicatedStorage (copy)
    --  [2] v30 (copy)

    require(ReplicatedStorage.Modules.CosmeticLibrary):ExternallySetCosmeticDescription(
        v30,
        "Can be purchased from the Daily Shop"
    )
end)
table.insert(t.DailyShopCosmeticTypes.Emote.CosmeticNames, "Cream Cheese Honey")
local v31 = "Cream Cheese Honey"
task.defer(function() -- line: 245
    -- upvalues:
    --  [1] ReplicatedStorage (copy)
    --  [2] v31 (copy)

    require(ReplicatedStorage.Modules.CosmeticLibrary):ExternallySetCosmeticDescription(
        v31,
        "Can be purchased from the Daily Shop"
    )
end)
table.insert(t.DailyShopCosmeticTypes.Emote.CosmeticNames, "Criss Cross")
local v32 = "Criss Cross"
task.defer(function() -- line: 245
    -- upvalues:
    --  [1] ReplicatedStorage (copy)
    --  [2] v32 (copy)

    require(ReplicatedStorage.Modules.CosmeticLibrary):ExternallySetCosmeticDescription(
        v32,
        "Can be purchased from the Daily Shop"
    )
end)
table.insert(t.DailyShopCosmeticTypes.Emote.CosmeticNames, "Side To Side")
local v33 = "Side To Side"
task.defer(function() -- line: 245
    -- upvalues:
    --  [1] ReplicatedStorage (copy)
    --  [2] v33 (copy)

    require(ReplicatedStorage.Modules.CosmeticLibrary):ExternallySetCosmeticDescription(
        v33,
        "Can be purchased from the Daily Shop"
    )
end)
table.insert(t.DailyShopCosmeticTypes.Emote.CosmeticNames, "Off of You")
local v34 = "Off of You"
task.defer(function() -- line: 245
    -- upvalues:
    --  [1] ReplicatedStorage (copy)
    --  [2] v34 (copy)

    require(ReplicatedStorage.Modules.CosmeticLibrary):ExternallySetCosmeticDescription(
        v34,
        "Can be purchased from the Daily Shop"
    )
end)
table.insert(t.DailyShopCosmeticTypes.Emote.CosmeticNames, "Round & Round")
local v35 = "Round & Round"
task.defer(function() -- line: 245
    -- upvalues:
    --  [1] ReplicatedStorage (copy)
    --  [2] v35 (copy)

    require(ReplicatedStorage.Modules.CosmeticLibrary):ExternallySetCosmeticDescription(
        v35,
        "Can be purchased from the Daily Shop"
    )
end)
table.insert(t.DailyShopCosmeticTypes.Emote.CosmeticNames, "Smile")
local v36 = "Smile"
task.defer(function() -- line: 245
    -- upvalues:
    --  [1] ReplicatedStorage (copy)
    --  [2] v36 (copy)

    require(ReplicatedStorage.Modules.CosmeticLibrary):ExternallySetCosmeticDescription(
        v36,
        "Can be purchased from the Daily Shop"
    )
end)
table.insert(t.DailyShopCosmeticTypes.Emote.CosmeticNames, "Take The L")
local v37 = "Take The L"
task.defer(function() -- line: 245
    -- upvalues:
    --  [1] ReplicatedStorage (copy)
    --  [2] v37 (copy)

    require(ReplicatedStorage.Modules.CosmeticLibrary):ExternallySetCosmeticDescription(
        v37,
        "Can be purchased from the Daily Shop"
    )
end)
table.insert(t.DailyShopCosmeticTypes.Emote.CosmeticNames, "Selfie")
local v38 = "Selfie"
task.defer(function() -- line: 245
    -- upvalues:
    --  [1] ReplicatedStorage (copy)
    --  [2] v38 (copy)

    require(ReplicatedStorage.Modules.CosmeticLibrary):ExternallySetCosmeticDescription(
        v38,
        "Can be purchased from the Daily Shop"
    )
end)
table.insert(t.DailyShopCosmeticTypes.Emote.CosmeticNames, "Giant Camera")
local v39 = "Giant Camera"
task.defer(function() -- line: 245
    -- upvalues:
    --  [1] ReplicatedStorage (copy)
    --  [2] v39 (copy)

    require(ReplicatedStorage.Modules.CosmeticLibrary):ExternallySetCosmeticDescription(
        v39,
        "Can be purchased from the Daily Shop"
    )
end)
table.insert(t.DailyShopCosmeticTypes.Emote.CosmeticNames, "Horsey")
local v40 = "Horsey"
task.defer(function() -- line: 245
    -- upvalues:
    --  [1] ReplicatedStorage (copy)
    --  [2] v40 (copy)

    require(ReplicatedStorage.Modules.CosmeticLibrary):ExternallySetCosmeticDescription(
        v40,
        "Can be purchased from the Daily Shop"
    )
end)
table.insert(t.DailyShopCosmeticTypes.Emote.CosmeticNames, "Bad Feeling")
local v41 = "Bad Feeling"
task.defer(function() -- line: 245
    -- upvalues:
    --  [1] ReplicatedStorage (copy)
    --  [2] v41 (copy)

    require(ReplicatedStorage.Modules.CosmeticLibrary):ExternallySetCosmeticDescription(
        v41,
        "Can be purchased from the Daily Shop"
    )
end)
table.insert(t.DailyShopCosmeticTypes.Emote.CosmeticNames, "Hollywoodin'")
local v42 = "Hollywoodin'"
task.defer(function() -- line: 245
    -- upvalues:
    --  [1] ReplicatedStorage (copy)
    --  [2] v42 (copy)

    require(ReplicatedStorage.Modules.CosmeticLibrary):ExternallySetCosmeticDescription(
        v42,
        "Can be purchased from the Daily Shop"
    )
end)
table.insert(t.DailyShopCosmeticTypes.Emote.CosmeticNames, "Bad Boy")
local v43 = "Bad Boy"
task.defer(function() -- line: 245
    -- upvalues:
    --  [1] ReplicatedStorage (copy)
    --  [2] v43 (copy)

    require(ReplicatedStorage.Modules.CosmeticLibrary):ExternallySetCosmeticDescription(
        v43,
        "Can be purchased from the Daily Shop"
    )
end)
table.insert(t.DailyShopCosmeticTypes.Emote.CosmeticNames, "Old Timer")
local v44 = "Old Timer"
task.defer(function() -- line: 245
    -- upvalues:
    --  [1] ReplicatedStorage (copy)
    --  [2] v44 (copy)

    require(ReplicatedStorage.Modules.CosmeticLibrary):ExternallySetCosmeticDescription(
        v44,
        "Can be purchased from the Daily Shop"
    )
end)

local _ = function(arg23, ...) --[[ add_flash_sale ]] -- line: 276
    -- upvalues:
    --  [1] add_shop_entry (copy)
    --  [2] StudioEnableFlashSales (copy)
    --  [3] t (copy)

    local v45 = add_shop_entry("Flash Sale", ...)

    if StudioEnableFlashSales then
        v45.PurchaseAppearTime = os.time() + 5
        v45.PurchaseStartTime = os.time() + 10
        v45.PurchaseDuration = 60
    end

    table.insert(t.FlashSales, { ShopEntry = v45, DisplayName = arg23 })
end

local function add_lootbox(
    arg24,
    arg25,
    arg26,
    arg27,
    arg28,
    arg29
) -- line: 295
    -- upvalues:
    --  [1] add_shop_entry (copy)
    --  [2] t (copy)

    t.Lootboxes[arg25] = {
        ShopEntry = add_shop_entry(
            "Lootbox",
            "lootbox_" .. arg25,
            { { Name = arg25, Weapon = "IsRandom", Quantity = 1 } },
            arg26,
            arg27,
            arg28
        ),
        PricesByRarity = arg29,
        ConsiderContentsForDailyShop = not arg24
    }
end

add_lootbox(nil, "Skin Case", { SkinTickets = 10 }, { [1852079505] = 1, [1861165031] = 3 })
add_lootbox(nil, "Skin Case 2", { SkinTickets = 10 }, { [1892542763] = 1, [1892543013] = 3 })
add_lootbox(nil, "Skin Case 3", { SkinTickets = 10 }, { [3251887315] = 1, [3251887576] = 3 })
add_lootbox(
    nil,
    "Wrap Box",
    { WeaponKeys = 5 },
    nil,
    nil,
    { Common = { WeaponKeys = 5 }, Rare = { WeaponKeys = 10 }, Legendary = { WeaponKeys = 15 } }
)
add_lootbox(
    nil,
    "Wrap Box 2",
    { WeaponKeys = 5 },
    nil,
    nil,
    { Common = { WeaponKeys = 5 }, Rare = { WeaponKeys = 10 }, Legendary = { WeaponKeys = 15 } }
)
add_lootbox(
    nil,
    "Wrap Box 3",
    { WeaponKeys = 5 },
    nil,
    nil,
    { Common = { WeaponKeys = 5 }, Rare = { WeaponKeys = 10 }, Legendary = { WeaponKeys = 15 } }
)
add_lootbox(
    nil,
    "Charm Capsule",
    { WeaponKeys = 3 },
    nil,
    nil,
    { Common = { WeaponKeys = 3 }, Rare = { WeaponKeys = 4 }, Legendary = { WeaponKeys = 5 } }
)
add_lootbox(
    nil,
    "Finisher Pack",
    { WeaponKeys = 10 },
    nil,
    nil,
    { Common = { WeaponKeys = 10 }, Rare = { WeaponKeys = 15 }, Legendary = { WeaponKeys = 20 } }
)
add_lootbox(
    nil,
    "Finisher Pack 2",
    { WeaponKeys = 10 },
    nil,
    nil,
    { Common = { WeaponKeys = 10 }, Rare = { WeaponKeys = 15 }, Legendary = { WeaponKeys = 20 } }
)

if EventLibrary_m.IS_ACTIVE then
    if EventLibrary_m.PRIZE_WHEEL_NAME then
        add_lootbox(
            true,
            EventLibrary_m.PRIZE_WHEEL_NAME,
            nil,
            { [3717328063] = 1, [3717328285] = 10, [3717328318] = 25 },
            true
        )
    end

    add_lootbox(
        nil,
        EventLibrary_m.SPECIAL_LOOTBOX_SKINS,
        { SkinTickets = 10 },
        { [2154617424] = 1, [2154618109] = 3 },
        true
    )
    add_lootbox(
        nil,
        EventLibrary_m.SPECIAL_LOOTBOX_VARIETY,
        { EventCurrency = 30 },
        nil,
        true,
        {
            Common = { EventCurrency = 30 },
            Rare = { EventCurrency = 60 },
            Legendary = { EventCurrency = 90 }
        }
    )
end

local function setup_schedule() -- line: 328
    -- upvalues:
    --  [1] t (copy)
    --  [2] Utility_m (copy)

    for _, val_3 in pairs(t.OwnableWeapons) do
        table.insert(t.OwnableWeaponReleaseSchedule, val_3)
    end

    table.sort(t.OwnableWeaponReleaseSchedule, function(arg30, arg31) -- line: 333
        -- upvalues:
        --  [1] t (ref)
        --  [2] Utility_m (ref)

        local v46 = t.Weapons[arg30].ReleaseTime or -1
        local v47 = t.Weapons[arg31].ReleaseTime or -1

        if v46 ~= v47 then
            return v46 < v47
        end

        return Utility_m:StringLessThan(arg30, arg31)
    end)
end

setup_schedule()

return t
