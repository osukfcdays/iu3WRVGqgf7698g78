local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StatisticsLibrary_m = require(ReplicatedStorage.Modules.StatisticsLibrary)
local CosmeticLibrary_m = require(ReplicatedStorage.Modules.CosmeticLibrary)
local _ = require(ReplicatedStorage.Modules.DuelLibrary)
local _ = require(ReplicatedStorage.Modules.ItemLibrary)
local ShopLibrary_m = require(ReplicatedStorage.Modules.ShopLibrary)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local t_2 = {}
t_2["Assault Rifle"] = { "Blue", "Desert Camo", "Chibi Assault Rifle" }
t_2.Bow = { "Red", "Forest Camo", "Chibi Bow" }
t_2["Burst Rifle"] = { "Orange", "Arctic Camo", "Chibi Burst Rifle" }
t_2.Flamethrower = { "Maize", "Scorched", "Chibi Flamethrower" }
t_2["Grenade Launcher"] = { "Surge", "Glass", "Chibi Grenade Launcher" }
t_2.Minigun = { "Spartan", "Malevolent", "Chibi Minigun" }
t_2["Paintball Gun"] = { "Medium stone grey", "Omnisand", "Chibi Paintball Gun" }
t_2.RPG = { "Teal", "Swirls", "Chibi RPG" }
t_2.Shotgun = { "Purple", "Reptile", "Chibi Shotgun" }
t_2.Sniper = { "Blush", "Patriot", "Chibi Sniper" }
t_2["Flare Gun"] = { "Green", "PB & J", "Chibi Flare Gun" }
t_2.Handgun = { "Yellow", "Digital Camo", "Chibi Handgun" }
t_2.Exogun = { "Vile", "Quasar", "Chibi Exogun" }
t_2.Revolver = { "Mint", "Street Camo", "Chibi Revolver" }
t_2.Shorty = { "Sky", "Steel", "Chibi Shorty" }
t_2.Slingshot = { "Studs", "Hesper", "Chibi Slingshot" }
t_2.Uzi = { "Lemon", "Ocean Camo", "Chibi Uzi" }
t_2.Chainsaw = { "Olive", "Circuit", "Chibi Chainsaw" }
t_2.Fists = { "Salmon", "Rug", "Chibi Fists" }
t_2.Katana = { "Crimson", "Clouds", "Chibi Katana" }
t_2.Knife = { "Highlighter", "Urban Camo", "Chibi Knife" }
t_2.Scythe = { "Navy", "Frosted", "Chibi Scythe" }
t_2.Trowel = { "Inlets", "Slime", "Chibi Trowel" }
t_2.Flashbang = { "Maroon", "Carpet", "Chibi Flashbang" }
t_2.Grenade = { "Beige", "Brain", "Chibi Grenade" }
t_2.Medkit = { "OranGG", "Water", "Chibi Medkit" }
t_2.Molotov = { "Pink", "Mainframe", "Chibi Molotov" }
t_2["Smoke Grenade"] = { "Brown", "Honeycomb", "Chibi Smoke Grenade" }
t_2["Subspace Tripmine"] = { "Universal", "Black Opal", "Chibi Subspace Tripmine" }
t_2["Freeze Ray"] = { "Cool", "Crossed", "Chibi Freeze Ray" }
t_2["Energy Rifle"] = { "Termination", ".exe", "Chibi Energy Rifle" }
t_2["Energy Pistols"] = { "Eco", "Sunset", "Chibi Energy Pistols" }
t_2.Crossbow = { "Lumber", "Spellslinger", "Chibi Crossbow" }
t_2.Daggers = { "Venom", "Fiery", "Chibi Daggers" }
t_2["Battle Axe"] = { "MaGGenta", "Carmine", "Chibi Battle Axe" }
t_2["War Horn"] = { "Ornate", "Voltaic", "Chibi War Horn" }
t_2.Satchel = { "Cheese", "Money", "Chibi Satchel" }
t_2["Riot Shield"] = { "Bluesteel", "Portal", "Chibi Riot Shield" }
t_2.Spray = { "Stained", "Igneous", "Chibi Spray" }
t_2.Gunblade = { "Gunmetal", "Celtic", "Chibi Gunblade" }
t_2["Jump Pad"] = { "Olo", "Dawn", "Chibi Jump Pad" }
t_2.Distortion = { "Bee", "Aegis", "Chibi Distortion" }
t_2.Warper = { "Mint Choco Chip", "Fracture", "Chibi Warper" }
t_2.Warpstone = { "Bliss", "Devourer", "Chibi Warpstone" }
t_2.Maul = { "Cold Metal", "Plaid Pajama", "Chibi Maul" }
t_2.Permafrost = { "Luxe", "Blizzard", "Chibi Permafrost" }
t_2.Spear = { "Galvanized", "Mossy Stone", "Chibi Spear" }
t_2.Grappler = { "Quartz", "Orichalcum", "Chibi Grappler" }
t_2.Wildcat = { "Toxin", "Rafflesia", "Chibi Wildcat" }
local t_54 = {}
t_54.Arena = { "Diorama Arena" }
t_54["Big Graveyard"] = { "Diorama Big Graveyard" }
t_54.Docks = { "Diorama Docks" }
t_54.Splash = { "Diorama Splash" }
t_54.Bridge = { "Diorama Bridge" }
t_54.Crossroads = { "Diorama Crossroads" }
t_54["Big Crossroads"] = { "Diorama Big Crossroads" }
t_54["Shooting Range"] = { "Diorama Shooting Range" }
t_54["Big Backrooms"] = { "Diorama Big Backrooms" }
t_54.Battleground = { "Diorama Battleground" }
t_54["Big Arena"] = { "Diorama Big Arena" }
t_54.Construction = { "Diorama Construction" }
t_54.Playground = { "Diorama Playground" }
t_54.Onyx = { "Diorama Onyx" }
t_54.Graveyard = { "Diorama Graveyard" }
t_54["Big Splash"] = { "Diorama Big Splash" }
t_54["Big Onyx"] = { "Diorama Big Onyx" }
t_54.Backrooms = { "Diorama Backrooms" }
t_54.Station = { "Diorama Station" }
t_54.Dimension = { "Diorama Dimension" }
t_54.Iceberg = { "Diorama Iceberg" }
t_54.Village = { "Diorama Village" }
t_54.Chess = { "Diorama Chess" }
t_54["Big Station"] = { "Diorama Big Station" }
t_54.Westown = { "Diorama Westown" }
t_54.Studio = { "Diorama Studio" }
t_54.Museum = { "Diorama Museum" }
t_54.Sandbox = { "Diorama Sandbox" }
local t_83 = {
    Types = {},
    Contracts = {},
    WeaponContracts = {},
    MapContracts = {},
    GetWeaponContracts = function(arg1, arg2) --[[ GetWeaponContracts ]] -- line: 117
        return arg1.WeaponContracts[arg2] or {}
    end,
    GetMapContracts = function(arg3, arg4) --[[ GetMapContracts ]] -- line: 121
        return arg3.MapContracts[arg4] or {}
    end,
    GetContractNamesByStatistic = function(arg5, arg6, arg7, arg8) --[[ GetContractNamesByStatistic ]] -- line: 125
        local t_84 = {}

        for key, val in pairs(arg5.Contracts) do
            if
                val.Type == arg6
                and val.Identifier == arg7
                and (val.StatisticName == arg8 or table.find(val.ExtraStatisticNames, arg8))
            then
                table.insert(t_84, key)
            end
        end

        return t_84
    end,
    GetWeaponContractNamesByStatistic = function(arg9, arg10, arg11) --[[ GetWeaponContractNamesByStatistic ]] -- line: 137
        return arg9:GetContractNameByStatistic("Weapon", arg10, arg11)
    end,
    GetMapContractNamesByStatistic = function(arg12, arg13, arg14) --[[ GetMapContractNamesByStatistic ]] -- line: 141
        return arg12:GetContractNameByStatistic("Map", arg13, arg14)
    end
}

local _ = function(arg15) --[[ add_type ]] -- line: 145
    -- upvalues:
    --  [1] t_83 (copy)

    t_83.Types[arg15] = {}
end

t_83.Types.Weapon = {}
t_83.Types.Map = {}

local function add_contract(
    arg16,
    arg17,
    arg18,
    arg19,
    arg20,
    arg21,
    arg22
) -- line: 156
    -- upvalues:
    --  [1] t_83 (copy)
    --  [2] StatisticsLibrary_m (copy)

    assert(t_83.Types[arg16])
    assert(not t_83.Contracts[arg17])

    for _, val_1 in pairs(arg20) do
        val_1[1] = math.ceil(val_1[1])
    end

    local t_85 = {
        Type = arg16,
        Name = arg17,
        Identifier = arg18,
        StatisticName = arg19,
        Milestones = arg20,
        ExtraStatisticNames = nil,
        FullDisplayName = ""
    }
    local v3 = arg21 or {}
    t_85.ExtraStatisticNames = v3

    for _, val_2 in pairs({ { t_85.StatisticName }, t_85.ExtraStatisticNames }) do
        for _, val_3 in pairs(val_2) do
            local FullDisplayName = t_85.FullDisplayName
            local v5 = if t_85.FullDisplayName ~= "" then " + " else ""
            t_85.FullDisplayName = FullDisplayName .. v5 .. StatisticsLibrary_m.Info[val_3].FullDisplayName
        end
    end

    for key_4, val_4 in pairs(arg22) do
        t_85[key_4] = val_4
    end

    t_83.Contracts[arg17] = t_85

    return t_85
end

local function add_weapon_contract(
    arg23,
    arg24,
    arg25,
    arg26,
    arg27
) -- line: 192
    -- upvalues:
    --  [1] ShopLibrary_m (copy)
    --  [2] Utility_m (copy)
    --  [3] t_2 (copy)
    --  [4] CosmeticLibrary_m (copy)
    --  [5] add_contract (copy)
    --  [6] t_83 (copy)

    local v6

    if arg23 == "MISSING_WEAPON" then
        v6 = arg23

        if not v6 then
            v6 = ShopLibrary_m:IsWeaponReleased(arg23) and arg23 or "unreleased weapon"
        end
    else
        v6 = ShopLibrary_m:IsWeaponReleased(arg23) and arg23 or "unreleased weapon"
    end

    local formattedText = string.format(
        "Earned from %s %s weapon contract",
        Utility_m:GetProperArticle(v6),
        v6
    )

    for _, val_5 in pairs(t_2[arg23]) do
        CosmeticLibrary_m:ExternallySetCosmeticDescription(val_5, formattedText)
    end

    add_contract(
        "Weapon",
        arg24,
        arg23,
        arg25,
        arg26,
        arg27,
        {}
    )
    local v9 = t_83.WeaponContracts[arg23] or {}
    t_83.WeaponContracts[arg23] = v9
    table.insert(t_83.WeaponContracts[arg23], arg24)
end

local function get_weapon_contract_reward(arg28, arg29, arg30) -- line: 210
    -- upvalues:
    --  [1] t_2 (copy)

    if arg28 == "Performance" then
        return ({
            { Name = "Key", Quantity = 1 },
            { Name = "Charm Capsule", Weapon = arg30, Quantity = 1 },
            { Name = "Charm Capsule", Weapon = arg30, Quantity = 1 },
            { Name = "Wrap Box", Weapon = arg30, Quantity = 1 },
            { Name = "Gold", Weapon = arg30 },
            { Name = "Diamond", Weapon = arg30 },
            { Name = "Midas Touch", Weapon = arg30 },
            { Name = "Diamond Hands", Weapon = arg30 },
            { Name = "Dark Matter", Weapon = arg30 }
        })[arg29]
    end

    if arg28 == "Playtime" then
        return ({
            { Name = "Key", Quantity = 1 },
            { Name = "Charm Capsule", Weapon = arg30, Quantity = 1 },
            { Name = t_2[arg30][1], Weapon = "IsUniversal" },
            { Name = "Charm Capsule", Weapon = arg30, Quantity = 1 },
            { Name = "Wrap Box", Weapon = arg30, Quantity = 1 },
            { Name = t_2[arg30][2], Weapon = "IsUniversal" },
            { Name = "Wrap Box 2", Weapon = arg30, Quantity = 1 },
            { Name = t_2[arg30][3], Weapon = "IsUniversal" }
        })[arg29]
    end

    assert(false, "???")
end

local function add_weapon_playtime_contract(arg31) -- line: 239
    -- upvalues:
    --  [1] add_weapon_contract (copy)
    --  [2] get_weapon_contract_reward (copy)

    local v10 = arg31 .. " Playtime"
    local t_106 = { 300, get_weapon_contract_reward("Playtime", 1, arg31) }
    add_weapon_contract(
        arg31,
        v10,
        "StatisticPlaytime",
        {
            t_106,
            { 1200, get_weapon_contract_reward("Playtime", 2, arg31) },
            { 3600, get_weapon_contract_reward("Playtime", 3, arg31) },
            { 21600, get_weapon_contract_reward("Playtime", 4, arg31) },
            { 43200, get_weapon_contract_reward("Playtime", 5, arg31) },
            { 86400, get_weapon_contract_reward("Playtime", 6, arg31) },
            { 172800, get_weapon_contract_reward("Playtime", 7, arg31) },
            { 259200, get_weapon_contract_reward("Playtime", 8, arg31) }
        }
    )
end

local function add_weapon_elimination_contract(arg32, arg33) -- line: 252
    -- upvalues:
    --  [1] add_weapon_contract (copy)
    --  [2] get_weapon_contract_reward (copy)

    local v12 = arg32 .. " Eliminations"
    local _ = {}
    local _ = {}
    local v13 = 5 * arg33
    local v14 = add_weapon_contract
    local _ = {}
    local v15 = 20 * arg33
    local t_117 = { v13, get_weapon_contract_reward("Performance", 1, arg32) }
    local _ = {}
    local v16 = 100 * arg33
    local t_119 = { v15, get_weapon_contract_reward("Performance", 2, arg32) }
    local _ = {}
    local v17 = 500 * arg33
    local t_121 = { v16, get_weapon_contract_reward("Performance", 3, arg32) }
    local _ = {}
    local v18 = 2000 * arg33
    local t_123 = { v17, get_weapon_contract_reward("Performance", 4, arg32) }
    local _ = {}
    local v19 = 10000 * arg33
    local t_125 = { v18, get_weapon_contract_reward("Performance", 5, arg32) }
    local _ = {}
    local v20 = 20000 * arg33
    local t_127 = { v19, get_weapon_contract_reward("Performance", 6, arg32) }
    local _ = {}
    local v21 = 30000 * arg33
    local t_129 = { v20, get_weapon_contract_reward("Performance", 7, arg32) }
    local _ = {}
    local v22 = 40000 * arg33
    v14(
        arg32,
        v12,
        "StatisticEliminations",
        {
            t_117,
            t_119,
            t_121,
            t_123,
            t_125,
            t_127,
            t_129,
            { v21, get_weapon_contract_reward("Performance", 8, arg32) },
            { v22, get_weapon_contract_reward("Performance", 9, arg32) }
        }
    )
end

for _, val_6 in pairs(
    {
        "Assault Rifle",
        "Handgun",
        "Burst Rifle",
        "Sniper",
        "RPG",
        "Shorty",
        "Shotgun",
        "Bow",
        "Uzi",
        "Revolver",
        "Paintball Gun",
        "Slingshot",
        "Grenade Launcher",
        "Minigun",
        "Exogun",
        "Flamethrower",
        "Daggers",
        "Energy Pistols",
        "Energy Rifle",
        "Spray",
        "Crossbow",
        "Gunblade",
        "Distortion",
        "Permafrost",
        "Wildcat"
    }
) do
    add_weapon_elimination_contract(val_6, 1)
    add_weapon_playtime_contract(val_6)
end

for _, val_7 in pairs(
    { "Fists", "Knife", "Chainsaw", "Katana", "Scythe", "Trowel", "Battle Axe", "Maul", "Spear" }
) do
    add_weapon_elimination_contract(val_7, 0.5)
    add_weapon_playtime_contract(val_7)
end

add_weapon_contract(
    "Smoke Grenade",
    "Smoke Grenade Smokeds",
    "StatisticSmokedsEnemies",
    {
        { 1, get_weapon_contract_reward("Performance", 1, "Smoke Grenade") },
        { 5, get_weapon_contract_reward("Performance", 2, "Smoke Grenade") },
        { 20, get_weapon_contract_reward("Performance", 3, "Smoke Grenade") },
        { 75, get_weapon_contract_reward("Performance", 4, "Smoke Grenade") },
        { 200, get_weapon_contract_reward("Performance", 5, "Smoke Grenade") },
        { 1000, get_weapon_contract_reward("Performance", 6, "Smoke Grenade") },
        { 4000, get_weapon_contract_reward("Performance", 9, "Smoke Grenade") }
    }
)
add_weapon_playtime_contract("Smoke Grenade")
add_weapon_contract(
    "Flashbang",
    "Flashbang Blinds",
    "StatisticBlindsEnemies",
    {
        { 1, get_weapon_contract_reward("Performance", 1, "Flashbang") },
        { 10, get_weapon_contract_reward("Performance", 2, "Flashbang") },
        { 50, get_weapon_contract_reward("Performance", 3, "Flashbang") },
        { 200, get_weapon_contract_reward("Performance", 4, "Flashbang") },
        { 500, get_weapon_contract_reward("Performance", 5, "Flashbang") },
        { 2500, get_weapon_contract_reward("Performance", 6, "Flashbang") },
        { 10000, get_weapon_contract_reward("Performance", 9, "Flashbang") }
    }
)
add_weapon_playtime_contract("Flashbang")
add_weapon_contract(
    "Medkit",
    "Medkit Heals",
    "StatisticHealsGiven",
    {
        { 150, get_weapon_contract_reward("Performance", 1, "Medkit") },
        { 500, get_weapon_contract_reward("Performance", 2, "Medkit") },
        { 2500, get_weapon_contract_reward("Performance", 3, "Medkit") },
        { 12000, get_weapon_contract_reward("Performance", 4, "Medkit") },
        { 50000, get_weapon_contract_reward("Performance", 5, "Medkit") },
        { 140000, get_weapon_contract_reward("Performance", 6, "Medkit") },
        { 560000, get_weapon_contract_reward("Performance", 9, "Medkit") }
    }
)
add_weapon_playtime_contract("Medkit")
add_weapon_contract(
    "Freeze Ray",
    "Freeze Ray Freezes",
    "StatisticFreezesEnemies",
    {
        { 1, get_weapon_contract_reward("Performance", 1, "Freeze Ray") },
        { 10, get_weapon_contract_reward("Performance", 2, "Freeze Ray") },
        { 50, get_weapon_contract_reward("Performance", 3, "Freeze Ray") },
        { 200, get_weapon_contract_reward("Performance", 4, "Freeze Ray") },
        { 500, get_weapon_contract_reward("Performance", 5, "Freeze Ray") },
        { 2500, get_weapon_contract_reward("Performance", 6, "Freeze Ray") },
        { 10000, get_weapon_contract_reward("Performance", 9, "Freeze Ray") }
    }
)
add_weapon_playtime_contract("Freeze Ray")
add_weapon_contract(
    "Flare Gun",
    "Flare Gun Damage Dealt",
    "StatisticDamageDealt",
    {
        { 100, get_weapon_contract_reward("Performance", 1, "Flare Gun") },
        { 500, get_weapon_contract_reward("Performance", 2, "Flare Gun") },
        { 2500, get_weapon_contract_reward("Performance", 3, "Flare Gun") },
        { 12000, get_weapon_contract_reward("Performance", 4, "Flare Gun") },
        { 50000, get_weapon_contract_reward("Performance", 5, "Flare Gun") },
        { 140000, get_weapon_contract_reward("Performance", 6, "Flare Gun") },
        { 280000, get_weapon_contract_reward("Performance", 7, "Flare Gun") },
        { 420000, get_weapon_contract_reward("Performance", 8, "Flare Gun") },
        { 560000, get_weapon_contract_reward("Performance", 9, "Flare Gun") }
    }
)
add_weapon_playtime_contract("Flare Gun")
add_weapon_contract(
    "Grenade",
    "Grenade Damage Dealt",
    "StatisticDamageDealt",
    {
        { 100, get_weapon_contract_reward("Performance", 1, "Grenade") },
        { 500, get_weapon_contract_reward("Performance", 2, "Grenade") },
        { 2500, get_weapon_contract_reward("Performance", 3, "Grenade") },
        { 12000, get_weapon_contract_reward("Performance", 4, "Grenade") },
        { 50000, get_weapon_contract_reward("Performance", 5, "Grenade") },
        { 140000, get_weapon_contract_reward("Performance", 6, "Grenade") },
        { 280000, get_weapon_contract_reward("Performance", 7, "Grenade") },
        { 420000, get_weapon_contract_reward("Performance", 8, "Grenade") },
        { 560000, get_weapon_contract_reward("Performance", 9, "Grenade") }
    }
)
add_weapon_playtime_contract("Grenade")
add_weapon_contract(
    "Molotov",
    "Molotov Damage Dealt",
    "StatisticDamageDealt",
    {
        { 100, get_weapon_contract_reward("Performance", 1, "Molotov") },
        { 500, get_weapon_contract_reward("Performance", 2, "Molotov") },
        { 2500, get_weapon_contract_reward("Performance", 3, "Molotov") },
        { 12000, get_weapon_contract_reward("Performance", 4, "Molotov") },
        { 50000, get_weapon_contract_reward("Performance", 5, "Molotov") },
        { 140000, get_weapon_contract_reward("Performance", 6, "Molotov") },
        { 280000, get_weapon_contract_reward("Performance", 7, "Molotov") },
        { 420000, get_weapon_contract_reward("Performance", 8, "Molotov") },
        { 560000, get_weapon_contract_reward("Performance", 9, "Molotov") }
    }
)
add_weapon_playtime_contract("Molotov")
add_weapon_contract(
    "Subspace Tripmine",
    "Subspace Tripmine Damage Dealt",
    "StatisticDamageDealt",
    {
        { 100, get_weapon_contract_reward("Performance", 1, "Subspace Tripmine") },
        { 500, get_weapon_contract_reward("Performance", 2, "Subspace Tripmine") },
        { 2500, get_weapon_contract_reward("Performance", 3, "Subspace Tripmine") },
        { 12000, get_weapon_contract_reward("Performance", 4, "Subspace Tripmine") },
        { 50000, get_weapon_contract_reward("Performance", 5, "Subspace Tripmine") },
        { 140000, get_weapon_contract_reward("Performance", 6, "Subspace Tripmine") },
        { 280000, get_weapon_contract_reward("Performance", 7, "Subspace Tripmine") },
        { 420000, get_weapon_contract_reward("Performance", 8, "Subspace Tripmine") },
        { 560000, get_weapon_contract_reward("Performance", 9, "Subspace Tripmine") }
    }
)
add_weapon_playtime_contract("Subspace Tripmine")
add_weapon_contract(
    "War Horn",
    "War Horn Empowers",
    "StatisticEmpowers",
    {
        { 3, get_weapon_contract_reward("Performance", 1, "War Horn") },
        { 50, get_weapon_contract_reward("Performance", 2, "War Horn") },
        { 250, get_weapon_contract_reward("Performance", 3, "War Horn") },
        { 1250, get_weapon_contract_reward("Performance", 4, "War Horn") },
        { 5000, get_weapon_contract_reward("Performance", 5, "War Horn") },
        { 10000, get_weapon_contract_reward("Performance", 6, "War Horn") },
        { 40000, get_weapon_contract_reward("Performance", 9, "War Horn") }
    }
)
add_weapon_playtime_contract("War Horn")
add_weapon_contract(
    "Satchel",
    "Satchel Damage Dealt",
    "StatisticDamageDealt",
    {
        { 100, get_weapon_contract_reward("Performance", 1, "Satchel") },
        { 500, get_weapon_contract_reward("Performance", 2, "Satchel") },
        { 2500, get_weapon_contract_reward("Performance", 3, "Satchel") },
        { 12000, get_weapon_contract_reward("Performance", 4, "Satchel") },
        { 50000, get_weapon_contract_reward("Performance", 5, "Satchel") },
        { 140000, get_weapon_contract_reward("Performance", 6, "Satchel") },
        { 280000, get_weapon_contract_reward("Performance", 7, "Satchel") },
        { 420000, get_weapon_contract_reward("Performance", 8, "Satchel") },
        { 560000, get_weapon_contract_reward("Performance", 9, "Satchel") }
    }
)
add_weapon_playtime_contract("Satchel")
add_weapon_contract(
    "Riot Shield",
    "Riot Shield Heals",
    "StatisticAbsorbs",
    {
        { 300, get_weapon_contract_reward("Performance", 1, "Riot Shield") },
        { 1000, get_weapon_contract_reward("Performance", 2, "Riot Shield") },
        { 5000, get_weapon_contract_reward("Performance", 3, "Riot Shield") },
        { 24000, get_weapon_contract_reward("Performance", 4, "Riot Shield") },
        { 100000, get_weapon_contract_reward("Performance", 5, "Riot Shield") },
        { 280000, get_weapon_contract_reward("Performance", 6, "Riot Shield") },
        { 560000, get_weapon_contract_reward("Performance", 7, "Riot Shield") },
        { 840000, get_weapon_contract_reward("Performance", 8, "Riot Shield") },
        { 1120000, get_weapon_contract_reward("Performance", 9, "Riot Shield") }
    }
)
add_weapon_playtime_contract("Riot Shield")
add_weapon_contract(
    "Jump Pad",
    "Jump Pad Bounces",
    "StatisticBounces",
    {
        { 1, get_weapon_contract_reward("Performance", 1, "Jump Pad") },
        { 25, get_weapon_contract_reward("Performance", 2, "Jump Pad") },
        { 120, get_weapon_contract_reward("Performance", 3, "Jump Pad") },
        { 500, get_weapon_contract_reward("Performance", 4, "Jump Pad") },
        { 1500, get_weapon_contract_reward("Performance", 5, "Jump Pad") },
        { 4500, get_weapon_contract_reward("Performance", 6, "Jump Pad") },
        { 18000, get_weapon_contract_reward("Performance", 9, "Jump Pad") }
    }
)
add_weapon_playtime_contract("Jump Pad")
add_weapon_contract(
    "Warper",
    "Warper Portals Spawned",
    "StatisticPortalsSpawned",
    {
        { 1, get_weapon_contract_reward("Performance", 1, "Warper") },
        { 10, get_weapon_contract_reward("Performance", 2, "Warper") },
        { 50, get_weapon_contract_reward("Performance", 3, "Warper") },
        { 200, get_weapon_contract_reward("Performance", 4, "Warper") },
        { 500, get_weapon_contract_reward("Performance", 5, "Warper") },
        { 2500, get_weapon_contract_reward("Performance", 6, "Warper") },
        { 10000, get_weapon_contract_reward("Performance", 9, "Warper") }
    }
)
add_weapon_playtime_contract("Warper")
add_weapon_contract(
    "Warpstone",
    "Warpstone Warps",
    "StatisticWarps",
    {
        { 1, get_weapon_contract_reward("Performance", 1, "Warpstone") },
        { 10, get_weapon_contract_reward("Performance", 2, "Warpstone") },
        { 50, get_weapon_contract_reward("Performance", 3, "Warpstone") },
        { 200, get_weapon_contract_reward("Performance", 4, "Warpstone") },
        { 500, get_weapon_contract_reward("Performance", 5, "Warpstone") },
        { 2500, get_weapon_contract_reward("Performance", 6, "Warpstone") },
        { 10000, get_weapon_contract_reward("Performance", 9, "Warpstone") }
    }
)
add_weapon_playtime_contract("Warpstone")
add_weapon_contract(
    "Grappler",
    "Grappler Hooks",
    "StatisticHooksEnemies",
    {
        { 1, get_weapon_contract_reward("Performance", 1, "Grappler") },
        { 10, get_weapon_contract_reward("Performance", 2, "Grappler") },
        { 50, get_weapon_contract_reward("Performance", 3, "Grappler") },
        { 200, get_weapon_contract_reward("Performance", 4, "Grappler") },
        { 500, get_weapon_contract_reward("Performance", 5, "Grappler") },
        { 2500, get_weapon_contract_reward("Performance", 6, "Grappler") },
        { 10000, get_weapon_contract_reward("Performance", 9, "Grappler") }
    }
)
add_weapon_playtime_contract("Grappler")

local function add_map_contract(
    arg34,
    arg35,
    arg36,
    arg37,
    arg38
) -- line: 471
    -- upvalues:
    --  [1] add_contract (copy)
    --  [2] t_83 (copy)

    add_contract(
        "Map",
        arg35,
        arg34,
        arg36,
        arg37,
        arg38,
        {}
    )
    local v23 = t_83.MapContracts[arg34] or {}
    t_83.MapContracts[arg34] = v23
    table.insert(t_83.MapContracts[arg34], arg35)
end

local function get_map_contract_reward(arg39, arg40, arg41) -- line: 482
    -- upvalues:
    --  [1] t_54 (copy)

    if arg39 == "Performance" then
        return ({
            { Name = "Key", Quantity = 1 },
            { Name = "Charm Capsule", Weapon = "IsRandom", Quantity = 1 },
            { Name = "Wrap Box", Weapon = "IsRandom", Quantity = 1 },
            { Name = "Finisher Pack", Weapon = "IsRandom", Quantity = 1 },
            { Name = "Key", Quantity = 4 },
            { Name = t_54[arg41][1], Weapon = "IsUniversal" }
        })[arg40]
    end

    if arg39 == "Playtime" then
        assert(false, "Not implemented yet")

        return
    end

    assert(false, "???")
end

local _ = function(arg42) --[[ add_map_playtime_contract ]] -- line: 499
    -- upvalues:
    --  [1] add_map_contract (copy)
    --  [2] get_map_contract_reward (copy)

    local v24 = arg42 .. " Playtime"
    local t_268 = { 300, get_map_contract_reward("Playtime", 1, arg42) }
    add_map_contract(
        arg42,
        v24,
        "StatisticPlaytime",
        {
            t_268,
            { 1200, get_map_contract_reward("Playtime", 2, arg42) },
            { 3600, get_map_contract_reward("Playtime", 3, arg42) },
            { 21600, get_map_contract_reward("Playtime", 4, arg42) },
            { 43200, get_map_contract_reward("Playtime", 5, arg42) },
            { 86400, get_map_contract_reward("Playtime", 6, arg42) }
        }
    )
end

local function add_map_roundswon_contract(arg43, arg44) -- line: 510
    -- upvalues:
    --  [1] CosmeticLibrary_m (copy)
    --  [2] t_54 (copy)
    --  [3] Utility_m (copy)
    --  [4] add_map_contract (copy)
    --  [5] get_map_contract_reward (copy)

    CosmeticLibrary_m:ExternallySetCosmeticDescription(
        t_54[arg43][1],
        string.format("Earned from %s %s map contract", Utility_m:GetProperArticle(arg43), arg43)
    )
    local v28 = arg43 .. " Rounds Won"
    local _ = {}
    local _ = {}
    local v29 = 10 * arg44
    local v30 = add_map_contract
    local _ = {}
    local v31 = 40 * arg44
    local t_277 = { v29, get_map_contract_reward("Performance", 1, arg43) }
    local _ = {}
    local v32 = 100 * arg44
    local t_279 = { v31, get_map_contract_reward("Performance", 2, arg43) }
    local _ = {}
    local v33 = 300 * arg44
    local t_281 = { v32, get_map_contract_reward("Performance", 3, arg43) }
    local _ = {}
    local v34 = 600 * arg44
    local t_283 = { v33, get_map_contract_reward("Performance", 4, arg43) }
    local _ = {}
    local v35 = 1000 * arg44
    v30(
        arg43,
        v28,
        "StatisticRoundsWon",
        {
            t_277,
            t_279,
            t_281,
            t_283,
            { v34, get_map_contract_reward("Performance", 5, arg43) },
            { v35, get_map_contract_reward("Performance", 6, arg43) }
        },
        { "StatisticRankedRoundsWon" }
    )
end

for _, val_8 in pairs(
    {
        "Arena",
        "Big Graveyard",
        "Docks",
        "Splash",
        "Bridge",
        "Crossroads",
        "Big Crossroads",
        "Shooting Range",
        "Big Backrooms",
        "Battleground",
        "Big Arena",
        "Construction",
        "Playground",
        "Onyx",
        "Graveyard",
        "Big Splash",
        "Big Onyx",
        "Backrooms",
        "Station",
        "Dimension",
        "Iceberg",
        "Village",
        "Chess",
        "Big Station",
        "Westown",
        "Studio",
        "Museum",
        "Sandbox"
    }
) do
    add_map_roundswon_contract(val_8, 1)
end

for _, val_9 in pairs({}) do
    add_map_roundswon_contract(val_9, 0.5)
end

local function assert_weapon_contracts() -- line: 531
    -- upvalues:
    --  [1] ShopLibrary_m (copy)
    --  [2] t_83 (copy)

    for _, val_10 in pairs(ShopLibrary_m.OwnableWeapons) do
        local v36 = false

        for _, val_11 in pairs(t_83.Contracts) do
            if val_11.Identifier == val_10 then
                v36 = true
                break
            end
        end

        assert(v36, val_10)
    end
end

assert_weapon_contracts()

return t_83
