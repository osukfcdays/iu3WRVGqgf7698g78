local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CONSTANTS_m = require(ReplicatedStorage.Modules.CONSTANTS)
local CosmeticLibrary_m = require(ReplicatedStorage.Modules.CosmeticLibrary)
local CurrencyLibrary_m = require(ReplicatedStorage.Modules.CurrencyLibrary)
local v1 = require(ReplicatedStorage.Modules.SeasonLibrary)
local EventLibrary_m = require(ReplicatedStorage.Modules.EventLibrary)
local ShopLibrary_m = require(ReplicatedStorage.Modules.ShopLibrary)
local ItemLibrary_m = require(ReplicatedStorage.Modules.ItemLibrary)
local _ = require(ReplicatedStorage.Modules.Utility)
local t = {
    ["\\"] = true,
    ["|"] = true,
    [" "] = true,
    q = true,
    w = true,
    e = true,
    r = true,
    t = true,
    y = true,
    u = true,
    i = true,
    o = true,
    p = true,
    a = true,
    s = true,
    d = true,
    f = true,
    g = true,
    h = true,
    j = true,
    k = true,
    l = true,
    z = true,
    x = true,
    c = true,
    v = true,
    b = true,
    n = true,
    m = true,
    ["1"] = true,
    ["2"] = true,
    ["3"] = true,
    ["4"] = true,
    ["5"] = true,
    ["6"] = true,
    ["7"] = true,
    ["8"] = true,
    ["9"] = true,
    ["0"] = true,
    ["`"] = true,
    ["-"] = true,
    ["="] = true,
    ["["] = true,
    ["]"] = true,
    [";"] = true,
    ["'"] = true,
    [","] = true,
    ["."] = true,
    ["/"] = true,
    ["~"] = true,
    ["!"] = true,
    ["@"] = true,
    ["#"] = true,
    ["$"] = true,
    ["%"] = true,
    ["^"] = true,
    ["&"] = true,
    ["*"] = true,
    ["("] = true,
    [")"] = true,
    _ = true,
    ["+"] = true,
    ["{"] = true,
    ["}"] = true,
    [":"] = true,
    ["\""] = true,
    ["<"] = true,
    [">"] = true,
    ["?"] = true
}
local t_1 = { NUM_KEY_BUNDLES = 5, NUM_EVENT_CURRENCY_BUNDLES = 5, GIFT_REWARD_DATA = "Bubbles" }
t_1.BATTLE_PASS_LEVELS = {
    "BattlePassLevels1",
    "BattlePassLevels5",
    "BattlePassLevels10",
    "BattlePassLevels20",
    "BattlePassLevels30",
    "BattlePassLevels40",
    "BattlePassLevels50",
    "BattlePassLevels60",
    "BattlePassLevels70"
}
t_1.MAX_GIFTING_NOTE_CHARACTER_COUNT = 128
t_1.VIDEO_AD_REWARDS_ENABLED = true
t_1.VIDEO_AD_REWARDS_MAX_SCALE_FACTOR = 2
t_1.VIDEO_ADS_SHOP_OFFER_PLACEMENT_ID = if CONSTANTS_m.IS_TESTING_SERVER then 539056999862972 else 329421439571920
t_1.MAX_FREE_WEAPON_TRIALS_PER_DAY = 5
t_1.VIDEO_ADS_WEAPON_TRIAL_PLACEMENT_ID = if not CONSTANTS_m.IS_TESTING_SERVER then 755928445335559 else 711043139604582
t_1.MAX_BILLBOARD_VIDEO_ADS_PER_DAY = 2
t_1.BILLBOARD_KEYS_REWARD_DATA = { Name = "Key", Quantity = 1 }
t_1.BILLBOARD_WRAPS_REWARD_DATA = { Name = "Brimstone", Quantity = 1, Weapon = "IsRandom" }
t_1.BILLBOARD_KEYS_VIDEO_AD_PLACEMENT_ID = if not CONSTANTS_m.IS_TESTING_SERVER then 118857322168446 else 329647288529142
t_1.BILLBOARD_WRAPS_VIDEO_AD_PLACEMENT_ID = if not CONSTANTS_m.IS_TESTING_SERVER then 345653440933702 else 842581759201595
t_1.SUPER_STARTER_BUNDLE_OFFER_DURATION = 604800
t_1.Gamepasses = {}
t_1.Products = {}
t_1.Bundles = {}
t_1.CosmeticBundlesOrder = {}
t_1.Gifts = {}
t_1.GiftOrder = {}
t_1.VideoAdRewards = {}
t_1.UGCs = {}
t_1.UGCAssetIDToName = {}
t_1.UGCOrder = {}
t_1.UGCMilestones = {}
t_1.UGCMilestoneOrder = {}

function t_1.GetGiftRewardRobuxSpentRequirement(_, arg2) -- line: 46
    return (math.min(500, 25 + 25 * arg2))
end

function t_1.GetGamepassName(arg3, arg4) -- line: 50
    for key, val in pairs(arg3.Gamepasses) do
        if arg4 == val.GamepassID then
            return key
        end
    end
end

function t_1.GetProductName(arg5, arg6) -- line: 58
    for key_1, val_1 in pairs(arg5.Products) do
        if arg6 == val_1.ProductID then
            return key_1
        end
    end
end

function t_1.GetBundleByProductID(_, arg8) -- line: 66
    -- upvalues:
    --  [1] t_1 (copy)

    for key_2, val_2 in pairs(t_1.Bundles) do
        if val_2.ProductID == arg8 then
            return key_2
        end
    end
end

function t_1.GetBundleContainingReward(_, arg10) -- line: 74
    -- upvalues:
    --  [1] t_1 (copy)

    for key_3, val_3 in pairs(t_1.Bundles) do
        for _, val_4 in pairs(val_3.Rewards) do
            if val_4.Name == arg10 then
                return key_3
            end
        end
    end
end

function t_1.GetStandardWeaponBundleWeapons(_) -- line: 84
    -- upvalues:
    --  [1] ShopLibrary_m (copy)
    --  [2] CONSTANTS_m (copy)
    --  [3] ItemLibrary_m (copy)

    local t_3 = {}

    for _, val_5 in pairs(
        ShopLibrary_m:GetReleasedOwnableWeapons(
            CONSTANTS_m.WEAPON_EARLY_ACCESS_TIME_OFFSET,
            ShopLibrary_m.OwnableWeaponsAlphabetized
        )
    ) do
        if
            not table.find(CONSTANTS_m.DEFAULT_WEAPONS, val_5)
            and ItemLibrary_m.Items[val_5].Status == "Standard"
            and ShopLibrary_m.Weapons[val_5].KeyPrice
        then
            table.insert(t_3, val_5)
        end
    end

    return t_3
end

function t_1.SanitizeGiftNote(arg12, arg13) -- line: 98
    -- upvalues:
    --  [1] t (copy)

    if typeof(arg13) ~= "string" or #arg13 == 0 then
        return nil
    end

    local substring = string.sub(
        arg13,
        1,
        (math.min(#arg13, arg12.MAX_GIFTING_NOTE_CHARACTER_COUNT))
    )
    local v5 = ""

    for index = 1, #substring do
        local substring_1 = string.sub(substring, index, index)
        v5 = v5 .. (if t[string.lower(substring_1)] then substring_1 else "#")
    end

    return v5
end

function t_1.GetNextUGCMilestone(arg14, arg15) -- line: 114
    for key_6, val_6 in pairs(arg14.UGCMilestoneOrder) do
        local v9 = arg14.UGCMilestones[val_6]

        if not (arg15 >= v9.PurchaseRequirement) then
            local v10 = arg14.UGCMilestoneOrder[key_6 - 1]

            return v9, if v10 then arg14.UGCMilestones[v10] else nil
        end
    end
end

function t_1.GetNumVideoAdsForFreeWeaponTrial(_, arg17) -- line: 129
    -- upvalues:
    --  [1] ItemLibrary_m (copy)
    --  [2] ShopLibrary_m (copy)

    local v12 = ItemLibrary_m.Items[arg17]
    local v13 = ShopLibrary_m.Weapons[arg17] and ShopLibrary_m.Weapons[arg17].KeyPrice

    if not v12 or v12.Status ~= "Standard" or not v13 then
        return nil
    end

    local floorValue = math.floor(v13 / 7.5)

    return (math.max(2, floorValue))
end

function t_1.GetNumVideoAdsForBillboardReward(_, arg19) -- line: 140
    return 3 + 1 * arg19
end

local _ = function(arg20, arg21, arg22, arg23) --[[ add_gamepass ]] -- line: 144
    -- upvalues:
    --  [1] t_1 (copy)

    t_1.Gamepasses[arg20] = {
        GamepassID = arg21,
        DisplayName = arg22,
        StaticRobuxPrice = arg23,
        BundleName = nil
    }
end

t_1.Gamepasses.StandardWeaponsBundle = {
    GamepassID = 838203071,
    DisplayName = "Standard Weapons Bundle",
    StaticRobuxPrice = 999,
    BundleName = nil
}
t_1.Gamepasses.ClassicBundle = {
    GamepassID = 838160059,
    DisplayName = "Classic Bundle",
    StaticRobuxPrice = 1149,
    BundleName = nil
}
t_1.Gamepasses.HeavyDutyBundle = {
    GamepassID = 838198043,
    DisplayName = "Heavy Duty Bundle",
    StaticRobuxPrice = 1899,
    BundleName = nil
}
t_1.Gamepasses.ExogunBundle = {
    GamepassID = 838087219,
    DisplayName = "Exogun Bundle",
    StaticRobuxPrice = 649,
    BundleName = nil
}
t_1.Gamepasses.MedkitBundle = {
    GamepassID = 837904767,
    DisplayName = "Medkit Bundle",
    StaticRobuxPrice = 249,
    BundleName = nil
}
t_1.Gamepasses.StarterBundle = {
    GamepassID = 839491390,
    DisplayName = "Starter Bundle",
    StaticRobuxPrice = 49,
    BundleName = nil
}
t_1.Gamepasses.EnergyBundle = {
    GamepassID = 977061826,
    DisplayName = "Energy Bundle",
    StaticRobuxPrice = 1299,
    BundleName = nil
}
t_1.Gamepasses.RPGBundle = {
    GamepassID = 1162134376,
    DisplayName = "RPG Bundle",
    StaticRobuxPrice = 124,
    BundleName = nil
}

local function add_product(arg24, arg25, arg26, arg27) -- line: 166
    -- upvalues:
    --  [1] t_1 (copy)

    local t_5 = { Name = arg24, ProductID = arg25, DisplayName = arg26 }
    local v15 = arg27 or {}

    for key_7, val_7 in pairs(v15) do
        t_5[key_7] = val_7
    end

    t_1.Products[arg24] = t_5
end

add_product("RefreshTasks", 1852077788, "Refresh Daily Tasks")
add_product("DailySkin1Common", 1852078966, "Common Skin #1")
add_product("DailySkin1Rare", 1852080069, "Rare Skin #1")
add_product("DailySkin1Legendary", 1852068440, "Legendary Skin #1")
add_product("DailySkin2Common", 1857673571, "Common Skin #2")
add_product("DailySkin2Rare", 1857673748, "Rare Skin #2")
add_product("DailySkin2Legendary", 1857673858, "Legendary Skin #2")
add_product("DailySkin3Common", 2151911761, "Common Skin #3")
add_product("DailySkin3Rare", 2151911909, "Rare Skin #3")
add_product("DailySkin3Legendary", 2151912016, "Legendary Skin #3")
add_product("DailySkin4Common", 2151912274, "Common Skin #4")
add_product("DailySkin4Rare", 2151912453, "Rare Skin #4")
add_product("DailySkin4Legendary", 2151912592, "Legendary Skin #4")
add_product("DailySkin5Common", 2151912371, "Common Skin #5")
add_product("DailySkin5Rare", 2151912504, "Rare Skin #5")
add_product("DailySkin5Legendary", 2151912645, "Legendary Skin #5")
local v18 = if not CONSTANTS_m.IS_TESTING_SERVER then 3322045009 else 3328255161
add_product("VideoAdRewardShopOffer", v18, "Video Ad Reward - Shop Offer")
v18 = if not CONSTANTS_m.IS_TESTING_SERVER then 3592870962 else 3592874068
add_product("VideoAdRewardPlayWithReward", v18, "Video Ad Reward - Play With Reward")
v18 = if not CONSTANTS_m.IS_TESTING_SERVER then 3592919946 else 3592920078
add_product("VideoAdRewardWeaponTrial", v18, "Video Ad Reward - Free Weapon Trial")
v18 = if not CONSTANTS_m.IS_TESTING_SERVER then 3592980112 else 3592980242
add_product("VideoAdRewardBillboardKeys", v18, "Video Ad Reward - Billboard Keys")
v18 = if not CONSTANTS_m.IS_TESTING_SERVER then 3592980464 else 3592980378
add_product("VideoAdRewardBillboardWraps", v18, "Video Ad Reward - Billboard Wraps")
add_product(
    "BattlePassLevels1",
    3406958794,
    "+1 Season Pass Level",
    { BattlePassLevelIncrement = 1 }
)
add_product(
    "BattlePassLevels5",
    3406958927,
    "+5 Season Pass Levels",
    { BattlePassLevelIncrement = 5 }
)
add_product(
    "BattlePassLevels10",
    3406959039,
    "+10 Season Pass Levels",
    { BattlePassLevelIncrement = 10 }
)
add_product(
    "BattlePassLevels20",
    3406959143,
    "+20 Season Pass Levels",
    { BattlePassLevelIncrement = 20 }
)
add_product(
    "BattlePassLevels30",
    3406962774,
    "+30 Season Pass Levels",
    { BattlePassLevelIncrement = 30 }
)
add_product(
    "BattlePassLevels40",
    3406959259,
    "+40 Season Pass Levels",
    { BattlePassLevelIncrement = 40 }
)
add_product(
    "BattlePassLevels50",
    3406962880,
    "+50 Season Pass Levels",
    { BattlePassLevelIncrement = 50 }
)
add_product(
    "BattlePassLevels60",
    3406963062,
    "+60 Season Pass Levels",
    { BattlePassLevelIncrement = 60 }
)
add_product(
    "BattlePassLevels70",
    3406959434,
    "+70 Season Pass Levels",
    { BattlePassLevelIncrement = 70 }
)

local function add_bundle(
    arg28,
    arg29,
    arg30,
    arg31,
    arg32,
    arg33,
    arg34,
    arg35
) -- line: 211
    -- upvalues:
    --  [1] t_1 (copy)

    for _, val_8 in pairs(arg33) do
        assert(val_8.Name)
    end

    local t_6 = {
        Type = arg28,
        DisplayName = arg30,
        ProductID = arg31,
        GamepassName = arg32,
        Rewards = arg33,
        BubbleText = arg34
    }
    local v28 = arg35 or {}

    for key_9, val_9 in pairs(v28) do
        t_6[key_9] = val_9
    end

    t_1.Bundles[arg29] = t_6

    if arg32 then
        t_1.Gamepasses[arg32].BundleName = arg29
    end
end

add_bundle(
    "Currency",
    "keybundle_1",
    "Key Bundle",
    1851594490,
    nil,
    { { Name = "Key", Quantity = 10 } }
)
add_bundle(
    "Currency",
    "keybundle_2",
    "Mega Key Bundle",
    1851594599,
    nil,
    {
        { Name = "Key", Quantity = 40 },
        { Name = "Charm Capsule", Weapon = "IsRandom", Quantity = 1 }
    }
)
add_bundle(
    "Currency",
    "keybundle_3",
    "Super Key Bundle",
    1851594741,
    nil,
    {
        { Name = "Key", Quantity = 90 },
        { Name = "Charm Capsule", Weapon = "IsRandom", Quantity = 3 },
        { Name = "Wrap Box 3", Weapon = "IsRandom", Quantity = 1 },
        { Name = "Mini Key", Weapon = "IsRandom", Quantity = 1 }
    }
)
add_bundle(
    "Currency",
    "keybundle_4",
    "Ultra Key Bundle",
    1851594902,
    nil,
    {
        { Name = "Key", Quantity = 450 },
        { Name = "Charm Capsule", Weapon = "IsRandom", Quantity = 15 },
        { Name = "Wrap Box 3", Weapon = "IsRandom", Quantity = 5 },
        { Name = "Mini Key", Weapon = "IsRandom", Quantity = 5 },
        { Name = "Luxurious", Weapon = "IsRandom", Quantity = 2 },
        { Name = "Opulent", Weapon = "IsRandom", Quantity = 1 },
        { Name = "Enerkey Rifle", Weapon = "Energy Rifle" }
    }
)
add_bundle(
    "Currency",
    "keybundle_5",
    "Legendary Key Bundle",
    1851595031,
    nil,
    {
        { Name = "Key", Quantity = 1100 },
        { Name = "Charm Capsule", Weapon = "IsRandom", Quantity = 40 },
        { Name = "Wrap Box 3", Weapon = "IsRandom", Quantity = 15 },
        { Name = "Mini Key", Weapon = "IsRandom", Quantity = 15 },
        { Name = "Luxurious", Weapon = "IsRandom", Quantity = 5 },
        { Name = "Opulent", Weapon = "IsRandom", Quantity = 3 },
        { Name = "Enerkey Pistols", Weapon = "Energy Pistols" },
        { Name = "Skin Case 3", Weapon = "IsRandom", Quantity = 1 }
    }
)

if EventLibrary_m.IS_ACTIVE then
    local DisplayName = CurrencyLibrary_m.Info.EventCurrency.DisplayName
    add_bundle(
        "Currency",
        "eventcurrencybundle_1",
        DisplayName .. " Bundle",
        2155532324,
        nil,
        { { Name = "EventCurrency", Quantity = 100 } }
    )
    add_bundle(
        "Currency",
        "eventcurrencybundle_2",
        "Mega " .. DisplayName .. " Bundle",
        2155532405,
        nil,
        {
            { Name = "EventCurrency", Quantity = 400 },
            { Name = EventLibrary_m.SPECIAL_LOOTBOX_VARIETY, Weapon = "IsRandom", Quantity = 1 }
        }
    )
    add_bundle(
        "Currency",
        "eventcurrencybundle_3",
        "Super " .. DisplayName .. " Bundle",
        2155532505,
        nil,
        {
            { Name = "EventCurrency", Quantity = 900 },
            { Name = EventLibrary_m.SPECIAL_LOOTBOX_VARIETY, Weapon = "IsRandom", Quantity = 3 },
            { Name = EventLibrary_m.CURRENCY_BUNDLE_CHARM, Weapon = "IsRandom", Quantity = 1 }
        }
    )
    add_bundle(
        "Currency",
        "eventcurrencybundle_4",
        "Ultra " .. DisplayName .. " Bundle",
        2155532614,
        nil,
        {
            { Name = "EventCurrency", Quantity = 4500 },
            { Name = EventLibrary_m.SPECIAL_LOOTBOX_VARIETY, Weapon = "IsRandom", Quantity = 15 },
            { Name = EventLibrary_m.CURRENCY_BUNDLE_CHARM, Weapon = "IsRandom", Quantity = 5 },
            { Name = EventLibrary_m.CURRENCY_BUNDLE_WRAP, Weapon = "IsRandom", Quantity = 2 },
            { Name = EventLibrary_m.CURRENCY_BUNDLE_FINISHER, Weapon = "IsRandom", Quantity = 1 }
        }
    )
    add_bundle(
        "Currency",
        "eventcurrencybundle_5",
        "Legendary " .. DisplayName .. " Bundle",
        2155532697,
        nil,
        {
            { Name = "EventCurrency", Quantity = 11000 },
            { Name = EventLibrary_m.SPECIAL_LOOTBOX_VARIETY, Weapon = "IsRandom", Quantity = 30 },
            { Name = EventLibrary_m.CURRENCY_BUNDLE_CHARM, Weapon = "IsRandom", Quantity = 15 },
            { Name = EventLibrary_m.CURRENCY_BUNDLE_WRAP, Weapon = "IsRandom", Quantity = 6 },
            { Name = EventLibrary_m.CURRENCY_BUNDLE_FINISHER, Weapon = "IsRandom", Quantity = 3 },
            {
                Name = EventLibrary_m.CURRENCY_BUNDLE_SKIN,
                Weapon = CosmeticLibrary_m.Cosmetics[EventLibrary_m.CURRENCY_BUNDLE_SKIN].ItemName
            },
            { Name = EventLibrary_m.SPECIAL_LOOTBOX_SKINS, Weapon = "IsRandom", Quantity = 1 }
        }
    )
end

add_bundle(
    "Product",
    "superstarter_bundle",
    "Super Starter Bundle",
    3710468157,
    nil,
    {
        { Name = "Plasma Wildcat", Weapon = "Wildcat" },
        { Name = "Wildcat" },
        { Name = "Spray" },
        { Name = "Chainsaw" },
        { Name = "Flashbang" },
        { Name = "Key", Quantity = 25 }
    },
    "x15 VALUE"
)
add_bundle(
    "Gamepass",
    "starter_bundle",
    "Starter Bundle",
    nil,
    "StarterBundle",
    {
        { Name = "Standard Weapon Crate", Quantity = 1 },
        { Name = "Shorty" },
        { Name = "Too Shorty", Weapon = "Shorty" },
        { Name = "Paint", Weapon = "IsUniversal" },
        { Name = "Emoji: Nauseated", Weapon = "IsUniversal" },
        { Name = "Stiff", Weapon = "IsUniversal" },
        { Name = "Key", Quantity = 10 }
    },
    "x12 VALUE"
)
add_bundle(
    "Gamepass",
    "standardweapons_bundle",
    "Standard Weapons Bundle",
    nil,
    "StandardWeaponsBundle",
    {
        { Name = "Disco", Weapon = "IsUniversal" },
        { Name = "Mini Disco Ball", Weapon = "IsUniversal" },
        { Name = "Boogie", Weapon = "IsUniversal" },
        { Name = "Wrap Box", Weapon = "IsRandom", Quantity = 5 },
        { Name = "Charm Capsule", Weapon = "IsRandom", Quantity = 10 },
        { Name = "Key", Quantity = 15 }
    },
    "x3 VALUE"
)
add_bundle(
    "Gamepass",
    "classic_bundle",
    "Classic Bundle",
    nil,
    "ClassicBundle",
    {
        { Name = "Paintball Gun" },
        { Name = "Slingshot" },
        { Name = "Trowel" },
        { Name = "Subspace Tripmine" },
        { Name = "Classic", Weapon = "IsUniversal" },
        { Name = "Mini Ban Hammer", Weapon = "IsUniversal" },
        { Name = "OOF", Weapon = "IsUniversal" },
        { Name = "Wrap Box", Weapon = "IsRandom", Quantity = 10 },
        { Name = "Charm Capsule", Weapon = "IsRandom", Quantity = 20 },
        { Name = "Key", Quantity = 40 }
    },
    "x7 VALUE"
)
add_bundle(
    "Gamepass",
    "heavyduty_bundle",
    "Heavy Duty Bundle",
    nil,
    "HeavyDutyBundle",
    {
        { Name = "Grenade Launcher" },
        { Name = "Minigun" },
        { Name = "Flamethrower" },
        { Name = "Magma", Weapon = "IsUniversal" },
        { Name = "Explosion", Weapon = "IsUniversal" },
        { Name = "Ignite", Weapon = "IsUniversal" },
        { Name = "Wrap Box", Weapon = "IsRandom", Quantity = 10 },
        { Name = "Charm Capsule", Weapon = "IsRandom", Quantity = 20 },
        { Name = "Key", Quantity = 40 }
    },
    "x4 VALUE"
)
add_bundle(
    "Gamepass",
    "exogun_bundle",
    "Exogun Bundle",
    nil,
    "ExogunBundle",
    {
        { Name = "Exogun" },
        { Name = "Wondergun", Weapon = "Exogun" },
        { Name = "Nebula", Weapon = "IsUniversal" },
        { Name = "Alien Head", Weapon = "IsUniversal" },
        { Name = "Low Gravity", Weapon = "IsUniversal" },
        { Name = "Wrap Box", Weapon = "IsRandom", Quantity = 15 },
        { Name = "Key", Quantity = 20 }
    },
    "x4 VALUE"
)
add_bundle(
    "Gamepass",
    "medkit_bundle",
    "Medkit Bundle",
    nil,
    "MedkitBundle",
    {
        { Name = "Medkit" },
        { Name = "Briefcase", Weapon = "Medkit" },
        { Name = "Aurum", Weapon = "IsUniversal" },
        { Name = "First Aid", Weapon = "IsUniversal" },
        { Name = "Heartbeat", Weapon = "IsUniversal" },
        { Name = "Wrap Box", Weapon = "IsRandom", Quantity = 15 },
        { Name = "Key", Quantity = 20 }
    },
    "x10 VALUE"
)
add_bundle(
    "Gamepass",
    "energy_bundle",
    "Energy Bundle",
    nil,
    "EnergyBundle",
    {
        { Name = "Energy Rifle" },
        { Name = "Energy Pistols" },
        { Name = "Apex Rifle", Weapon = "Energy Rifle" },
        { Name = "Apex Pistols", Weapon = "Energy Pistols" },
        { Name = ".dll", Weapon = "IsUniversal" },
        { Name = "Energy Cell", Weapon = "IsUniversal" },
        { Name = "Beacon", Weapon = "IsUniversal" }
    },
    "x5 VALUE"
)
add_bundle(
    "Gamepass",
    "rpg_bundle",
    "RPG Bundle",
    nil,
    "RPGBundle",
    {
        { Name = "RPG" },
        { Name = "Pencil Launcher", Weapon = "RPG" },
        { Name = "Emoji: Nerd", Weapon = "IsUniversal" },
        { Name = "Cardboard", Weapon = "IsUniversal" },
        { Name = "Erased", Weapon = "IsUniversal" },
        { Name = "Key", Quantity = 5 }
    },
    "x3 VALUE"
)

if v1.CurrentSeason.BattlePassActive then
    add_bundle(
        "Product",
        "primeseason_bundle",
        "Prime Bundle",
        3406969974,
        nil,
        { { Name = "Prime Season Pass" }, { Name = "Prime Nametag" } },
        "<s>" .. utf8.char(57346) .. " 724</s>",
        {
            BattlePassMaxPassTrackNum = 2,
            UnlockNowDisplayName = "Prime Season Pass",
            UnlockNowWeaponStatusUIEffect = "Prime"
        }
    )
    add_bundle(
        "Product",
        "contrabandseason_bundle",
        "Contraband Bundle",
        3406992213,
        nil,
        {
            { Name = "Prime Season Pass" },
            { Name = "Contraband Nametag" },
            { Name = "Season Pass Level", Quantity = v1.SEASON_PASS_LEVELS_IN_SEASON_BUNDLE },
            { Name = "Prime Goodie Bag", Quantity = 10, Weapon = "IsRandom" },
            {
                Name = v1.CurrentSeason.ContrabandBundleSkinName,
                Quantity = 1,
                Weapon = CosmeticLibrary_m.Cosmetics[v1.CurrentSeason.ContrabandBundleSkinName].ItemName
            },
            {
                Name = v1.CurrentSeason.ContrabandBundleWrapName,
                Quantity = 1,
                Weapon = "IsUniversal"
            },
            {
                Name = v1.CurrentSeason.ContrabandBundleCharmName,
                Quantity = 1,
                Weapon = "IsUniversal"
            },
            {
                Name = v1.CurrentSeason.ContrabandBundleFinisherName,
                Quantity = 1,
                Weapon = "IsUniversal"
            },
            { Name = v1.CurrentSeason.ContrabandBundleEmoteName, Quantity = 1 }
        },
        "<s>" .. utf8.char(57346) .. " 2,499</s>",
        {
            BattlePassMaxPassTrackNum = 2,
            BattlePassLevelIncrement = v1.SEASON_PASS_LEVELS_IN_SEASON_BUNDLE
        }
    )
end

local function add_cosmetic_bundle(
    arg36,
    arg37,
    arg38,
    arg39,
    arg40,
    arg41
) -- line: 447
    -- upvalues:
    --  [1] CosmeticLibrary_m (copy)
    --  [2] add_bundle (copy)
    --  [3] t_1 (copy)

    for _, val_10 in pairs(arg41) do
        local v30 = if not arg36 then "Included in the %s" else "Used to be included in the %s"
        CosmeticLibrary_m:ExternallySetCosmeticDescription(
            val_10[3].Name,
            string.format(v30, arg38)
        )
    end

    if arg36 then
        return
    end

    local t_48 = {}
    local t_49 = {}

    for _, val_11 in pairs(arg41) do
        table.insert(t_48, val_11[3])

        if val_11[1] then
            table.insert(t_49, val_11[1])
            table.insert(t_49, Enum.InfoType.Product)
        end
    end

    add_bundle(
        "Product",
        arg37,
        arg38,
        arg39,
        nil,
        t_48,
        nil,
        {
            IsCosmeticBundle = true,
            RewardsWithIndividualProductIDs = arg41,
            SetRobuxTextArgs = t_49,
            GiftProductID = arg40
        }
    )
    table.insert(t_1.CosmeticBundlesOrder, arg37)
end

add_cosmetic_bundle(
    nil,
    "pixel_bundle",
    "Pixel Bundle",
    3535136080,
    2146952782,
    {
        { 3535139215, 3535796474, { Name = "Pixel Burst", Weapon = "Burst Rifle" } },
        { 3535139428, 3535796544, { Name = "Pixel Handgun", Weapon = "Handgun" } },
        { 3535139535, 3535796623, { Name = "Pixel Katana", Weapon = "Katana" } },
        { 3535139628, 3535796722, { Name = "Pixel Flashbang", Weapon = "Flashbang" } },
        { nil, nil, { Name = "Geometric", Weapon = "IsUniversal" } },
        { nil, nil, { Name = "EZ", Weapon = "IsUniversal" } },
        { nil, nil, { Name = "Pixel Coins", Weapon = "IsUniversal" } },
        { nil, nil, { Name = "Coin Block" } }
    }
)
add_cosmetic_bundle(
    nil,
    "balloon_bundle",
    "Balloon Bundle",
    3535217450,
    3535800297,
    {
        { 3535217737, 3535800345, { Name = "Balloon Launcher", Weapon = "Grenade Launcher" } },
        { 3535217775, 3535800399, { Name = "Paintballoon Gun", Weapon = "Paintball Gun" } },
        { 3535217832, 3535800453, { Name = "Balloon Bow", Weapon = "Bow" } },
        { 3535217904, 3535800531, { Name = "Balloon Axe", Weapon = "Battle Axe" } },
        { nil, nil, { Name = "Balloon Dog", Weapon = "IsUniversal" } },
        { nil, nil, { Name = "Red Rubber", Weapon = "IsUniversal" } },
        { nil, nil, { Name = "Inflate", Weapon = "IsUniversal" } },
        { nil, nil, { Name = "Whimsical" } }
    }
)
add_cosmetic_bundle(
    nil,
    "nostalgia_bundle",
    "Nostalgia Bundle",
    3535218231,
    3535800586,
    {
        { 3535218275, 3535800641, { Name = "Ban Hammer", Weapon = "Maul" } },
        { 3535218311, 3535800699, { Name = "Rocket Launcher", Weapon = "RPG" } },
        { 3535218352, 3535800924, { Name = "Hyperlaser Guns", Weapon = "Energy Pistols" } },
        { 3535218430, 3535800959, { Name = "Linked Sword", Weapon = "Katana" } },
        { nil, nil, { Name = "Happy Home", Weapon = "IsUniversal" } },
        { nil, nil, { Name = "The Heights", Weapon = "IsUniversal" } },
        { nil, nil, { Name = "Dematerialize", Weapon = "IsUniversal" } },
        { nil, nil, { Name = "Illumina Storm" } }
    }
)

for _, val_12 in pairs(
    {
        { 3535218018, 3535801045, { Name = "Beloved Bow", Weapon = "Bow" } },
        { 3535218067, 3535801071, { Name = "Broken Hearts", Weapon = "Daggers" } },
        { 3535218104, 3535801113, { Name = "Cuddle Bomb", Weapon = "Grenade" } },
        { 3535218148, 3535801142, { Name = "Box of Chocolates", Weapon = "Medkit" } },
        { nil, nil, { Name = "Pierced Heart", Weapon = "IsUniversal" } },
        { nil, nil, { Name = "Heartfelt", Weapon = "IsUniversal" } },
        { nil, nil, { Name = "Poof", Weapon = "IsUniversal" } },
        { nil, nil, { Name = "Tango" } }
    }
) do
    CosmeticLibrary_m:ExternallySetCosmeticDescription(
        val_12[3].Name,
        string.format("Used to be included in the %s", "Lovely Bundle")
    )
end

for _, val_13 in pairs(
    {
        { 3549289473, 3549289668, { Name = "Rainbowthrower", Weapon = "Flamethrower" } },
        { 3549289501, 3549289722, { Name = "Lucky Horseshoe", Weapon = "Slingshot" } },
        { 3549289534, 3549289757, { Name = "Caladbolg", Weapon = "Knife" } },
        { 3549289575, 3549289804, { Name = "Pot o' Keys", Weapon = "Subspace Tripmine" } },
        { nil, nil, { Name = "Four-Leaf Clover", Weapon = "IsUniversal" } },
        { nil, nil, { Name = "Clovers", Weapon = "IsUniversal" } },
        { nil, nil, { Name = "Leprechaunify", Weapon = "IsUniversal" } },
        { nil, nil, { Name = "Step Dancing" } }
    }
) do
    CosmeticLibrary_m:ExternallySetCosmeticDescription(
        val_13[3].Name,
        string.format("Used to be included in the %s", "Lucky Bundle")
    )
end

add_cosmetic_bundle(
    nil,
    "prop_bundle",
    "Prop Bundle",
    3580412457,
    3580412891,
    {
        { 3580412515, 3580412913, { Name = "Extinguisher", Weapon = "Flamethrower" } },
        { 3580412541, 3580412953, { Name = "Toaster", Weapon = "Daggers" } },
        { 3580412562, 3580412985, { Name = "Street Sign", Weapon = "Battle Axe" } },
        { 3580412593, 3580413018, { Name = "Pizza Box", Weapon = "Satchel" } },
        { nil, nil, { Name = "Pencil", Weapon = "Knife" } },
        { nil, nil, { Name = "Box TV", Weapon = "IsUniversal" } },
        { nil, nil, { Name = "TV Error", Weapon = "IsUniversal" } },
        { nil, nil, { Name = "Goofy Brawl", Weapon = "IsUniversal" } },
        { nil, nil, { Name = "Scoot" } }
    }
)
add_cosmetic_bundle(
    nil,
    "pirate_bundle",
    "Pirate Bundle",
    3605561386,
    3605561751,
    {
        { 3605561596, 3605561781, { Name = "Kraken Sniper", Weapon = "Sniper" } },
        { 3605561621, 3605561802, { Name = "Cannon Shorty", Weapon = "Shorty" } },
        { 3605561673, 3605561828, { Name = "Pirate Hook", Weapon = "Fists" } },
        { 3605561690, 3605561892, { Name = "Ship In A Bottle", Weapon = "Molotov" } },
        { nil, nil, { Name = "Cutlass", Weapon = "Katana" } },
        { nil, nil, { Name = "Long Lost Treasure", Weapon = "IsUniversal" } },
        { nil, nil, { Name = "Dutchman", Weapon = "IsUniversal" } },
        { nil, nil, { Name = "Spectralized", Weapon = "IsUniversal" } },
        { nil, nil, { Name = "X Marks The Spot" } }
    }
)
add_cosmetic_bundle(
    nil,
    "bat_bundle",
    "Bat Bundle",
    3716730402,
    3716731407,
    {
        { 3716730830, 3716731473, { Name = "Batblade", Weapon = "Gunblade" } },
        { 3716730904, 3716731518, { Name = "Slingshotula", Weapon = "Slingshot" } },
        { 3716730996, 3716731590, { Name = "Karambat", Weapon = "Knife" } },
        { 3716731074, 3716731685, { Name = "Batnade", Weapon = "Grenade" } },
        { nil, nil, { Name = "Bat Wing", Weapon = "IsUniversal" } },
        { nil, nil, { Name = "Bat Flock", Weapon = "IsUniversal" } },
        { nil, nil, { Name = "Become Bat", Weapon = "IsUniversal" } },
        { nil, nil, { Name = "Take Flight" } }
    }
)

local _ = function(
    arg42,
    arg43,
    arg44,
    arg45,
    arg46,
    arg47,
    arg48
) --[[ add_gift ]] -- line: 569
    -- upvalues:
    --  [1] t_1 (copy)
    --  [2] ShopLibrary_m (copy)

    local v31 = if arg43 ~= "Gamepass" then if arg43 ~= "Product" then if arg43 ~= "Bundle" then if arg43 ~= "ShopEntry" then error(
        "???"
    ) else ShopLibrary_m.Entries[arg44] or error("???") else t_1.Bundles[arg44] or (if arg43 ~= "ShopEntry" then error(
        "???"
    ) else ShopLibrary_m.Entries[arg44] or error("???")) else t_1.Products[arg44] or (if arg43 ~= "Bundle" then if arg43 ~= "ShopEntry" then error(
        "???"
    ) else ShopLibrary_m.Entries[arg44] or error("???") else t_1.Bundles[arg44] or (if arg43 ~= "ShopEntry" then error(
        "???"
    ) else ShopLibrary_m.Entries[arg44] or error("???"))) else t_1.Gamepasses[arg44] or (if arg43 ~= "Product" then if arg43 ~= "Bundle" then if arg43 ~= "ShopEntry" then error(
        "???"
    ) else ShopLibrary_m.Entries[arg44] or error("???") else t_1.Bundles[arg44] or (if arg43 ~= "ShopEntry" then error(
        "???"
    ) else ShopLibrary_m.Entries[arg44] or error("???")) else t_1.Products[arg44] or (if arg43 ~= "Bundle" then if arg43 ~= "ShopEntry" then error(
        "???"
    ) else ShopLibrary_m.Entries[arg44] or error("???") else t_1.Bundles[arg44] or (if arg43 ~= "ShopEntry" then error(
        "???"
    ) else ShopLibrary_m.Entries[arg44] or error("???"))))
    local t_125 = {
        ProductID = arg42,
        ProductType = if arg43 == "Gamepass" then "Gamepass" else "Product",
        GiftType = arg43,
        GiftName = arg44,
        TargetProductID = nil,
        DisplayName = nil,
        IsPaidRandomItem = nil,
        Quantity = nil,
        ImageID = nil
    }
    local v32 = arg48 or (if arg43 ~= "Gamepass" then if arg43 ~= "ShopEntry" then v31.ProductID else v31.ProductQuantityToID[arg46 or 1] or v31.ProductID else v31.GamepassID or (if arg43 ~= "ShopEntry" then v31.ProductID else v31.ProductQuantityToID[arg46 or 1] or v31.ProductID))
    t_125.TargetProductID = v32
    v32 = arg47

    if not v32 then
        v32 = arg43 == "ShopEntry" and v31.Rewards[1].Name .. (if not arg46 or arg46 == 1 then "" else " [\195\151" .. arg46 .. "]") or v31.DisplayName
    end

    t_125.DisplayName = v32
    t_125.IsPaidRandomItem = arg45
    t_125.Quantity = arg46
    t_1.Gifts[tostring(arg42)] = t_125
    local GiftOrder = t_1.GiftOrder
    local str = tostring(arg42)
    table.insert(GiftOrder, str)
end

local function add_bundle_gift(arg49) -- line: 593
    -- upvalues:
    --  [1] t_1 (copy)

    local v34 = t_1.Bundles[arg49]

    if v34.GiftProductID then
        local GiftProductID = v34.GiftProductID
        local v35 = t_1.Bundles[arg49] or error("???")
        t_1.Gifts[tostring(GiftProductID)] = {
            ProductID = GiftProductID,
            ProductType = "Product",
            GiftType = "Bundle",
            GiftName = arg49,
            TargetProductID = v35.ProductID,
            DisplayName = v35.DisplayName,
            IsPaidRandomItem = nil,
            Quantity = nil,
            ImageID = nil
        }
        table.insert(t_1.GiftOrder, (tostring(GiftProductID)))
    end

    for _, val_14 in pairs(v34.RewardsWithIndividualProductIDs) do
        if val_14[1] and val_14[2] then
            local v36 = val_14[2]
            local v37 = t_1.Bundles[arg49]
            local Name_4 = val_14[3].Name
            local v38 = val_14[1]
            v37 = v37 or error("???")
            local t_127 = {
                ProductID = v36,
                ProductType = "Product",
                GiftType = "Bundle",
                GiftName = arg49,
                TargetProductID = nil,
                DisplayName = nil,
                IsPaidRandomItem = nil,
                Quantity = nil,
                ImageID = nil
            }
            local v39 = v38 or v37.ProductID
            t_127.TargetProductID = v39
            v39 = Name_4 or v37.DisplayName
            t_127.DisplayName = v39
            t_1.Gifts[tostring(v36)] = t_127
            table.insert(t_1.GiftOrder, (tostring(v36)))
        end
    end
end

if EventLibrary_m.IS_ACTIVE then
    local v40

    if EventLibrary_m.PRIZE_WHEEL_NAME then
        local STANDALONEPRIZEWHEELSHOPENTRYNAME = EventLibrary_m.STANDALONE_PRIZE_WHEEL_SHOP_ENTRY_NAME
        v40 = ShopLibrary_m.Entries[STANDALONEPRIZEWHEELSHOPENTRYNAME] or error("???")
        local t_128 = {
            ProductID = 3717335257,
            ProductType = "Product",
            GiftType = "ShopEntry",
            GiftName = STANDALONEPRIZEWHEELSHOPENTRYNAME,
            TargetProductID = v40.ProductQuantityToID[10] or v40.ProductID,
            DisplayName = v40.Rewards[1].Name .. " [\195\151" .. 10 .. "]" or v40.DisplayName,
            IsPaidRandomItem = true,
            Quantity = 10,
            ImageID = nil
        }
        t_1.Gifts[tostring(3717335257)] = t_128
        table.insert(t_1.GiftOrder, (tostring(3717335257)))
    end

    if EventLibrary_m.STANDALONE_SHOP_SKIN then
        local STANDALONESHOPSKINSHOPENTRYNAME = EventLibrary_m.STANDALONE_SHOP_SKIN_SHOP_ENTRY_NAME
        v40 = ShopLibrary_m.Entries[STANDALONESHOPSKINSHOPENTRYNAME] or error("???")
        local t_129 = {
            ProductID = 3605561994,
            ProductType = "Product",
            GiftType = "ShopEntry",
            GiftName = STANDALONESHOPSKINSHOPENTRYNAME,
            TargetProductID = v40.ProductQuantityToID[1] or v40.ProductID,
            DisplayName = v40.Rewards[1].Name .. "" or v40.DisplayName,
            IsPaidRandomItem = nil,
            Quantity = nil,
            ImageID = nil
        }
        t_1.Gifts[tostring(3605561994)] = t_129
        table.insert(t_1.GiftOrder, (tostring(3605561994)))
    end

    local v43 = "lootbox_" .. EventLibrary_m.SPECIAL_LOOTBOX_SKINS
    v40 = ShopLibrary_m.Entries[v43] or error("???")
    local t_130 = {
        ProductID = 2154618268,
        ProductType = "Product",
        GiftType = "ShopEntry",
        GiftName = v43,
        TargetProductID = v40.ProductQuantityToID[1] or v40.ProductID,
        DisplayName = v40.Rewards[1].Name .. "" or v40.DisplayName,
        IsPaidRandomItem = true,
        Quantity = nil,
        ImageID = nil
    }
    t_1.Gifts[tostring(2154618268)] = t_130
    table.insert(t_1.GiftOrder, (tostring(2154618268)))
    local v45 = "lootbox_" .. EventLibrary_m.SPECIAL_LOOTBOX_SKINS
    v40 = ShopLibrary_m.Entries[v45] or error("???")
    local t_131 = {
        ProductID = 2319690506,
        ProductType = "Product",
        GiftType = "ShopEntry",
        GiftName = v45,
        TargetProductID = v40.ProductQuantityToID[3] or v40.ProductID,
        DisplayName = v40.Rewards[1].Name .. " [\195\151" .. 3 .. "]" or v40.DisplayName,
        IsPaidRandomItem = true,
        Quantity = 3,
        ImageID = nil
    }
    t_1.Gifts[tostring(2319690506)] = t_131
    table.insert(t_1.GiftOrder, (tostring(2319690506)))
    v45 = t_1.Bundles.eventcurrencybundle_1 or error("???")
    t_1.Gifts[tostring(2319763472)] = {
        ProductID = 2319763472,
        ProductType = "Product",
        GiftType = "Bundle",
        GiftName = "eventcurrencybundle_1",
        TargetProductID = v45.ProductID,
        DisplayName = v45.DisplayName,
        IsPaidRandomItem = nil,
        Quantity = nil,
        ImageID = nil
    }
    table.insert(t_1.GiftOrder, (tostring(2319763472)))
    v45 = t_1.Bundles.eventcurrencybundle_2 or error("???")
    t_1.Gifts[tostring(2319763545)] = {
        ProductID = 2319763545,
        ProductType = "Product",
        GiftType = "Bundle",
        GiftName = "eventcurrencybundle_2",
        TargetProductID = v45.ProductID,
        DisplayName = v45.DisplayName,
        IsPaidRandomItem = nil,
        Quantity = nil,
        ImageID = nil
    }
    table.insert(t_1.GiftOrder, (tostring(2319763545)))
    v45 = t_1.Bundles.eventcurrencybundle_3 or error("???")
    t_1.Gifts[tostring(2319763627)] = {
        ProductID = 2319763627,
        ProductType = "Product",
        GiftType = "Bundle",
        GiftName = "eventcurrencybundle_3",
        TargetProductID = v45.ProductID,
        DisplayName = v45.DisplayName,
        IsPaidRandomItem = nil,
        Quantity = nil,
        ImageID = nil
    }
    table.insert(t_1.GiftOrder, (tostring(2319763627)))
    v45 = t_1.Bundles.eventcurrencybundle_4 or error("???")
    t_1.Gifts[tostring(2319763722)] = {
        ProductID = 2319763722,
        ProductType = "Product",
        GiftType = "Bundle",
        GiftName = "eventcurrencybundle_4",
        TargetProductID = v45.ProductID,
        DisplayName = v45.DisplayName,
        IsPaidRandomItem = nil,
        Quantity = nil,
        ImageID = nil
    }
    table.insert(t_1.GiftOrder, (tostring(2319763722)))
    v45 = t_1.Bundles.eventcurrencybundle_5 or error("???")
    t_1.Gifts[tostring(2319763802)] = {
        ProductID = 2319763802,
        ProductType = "Product",
        GiftType = "Bundle",
        GiftName = "eventcurrencybundle_5",
        TargetProductID = v45.ProductID,
        DisplayName = v45.DisplayName,
        IsPaidRandomItem = nil,
        Quantity = nil,
        ImageID = nil
    }
    table.insert(t_1.GiftOrder, (tostring(2319763802)))

    if EventLibrary_m.SKIN_BUNDLE_NAME then
        add_bundle_gift(EventLibrary_m.SKIN_BUNDLE_NAME)
    end
end

if v1.CurrentSeason.BattlePassActive then
    local v47 = t_1.Products.BattlePassLevels10 or error("???")
    t_1.Gifts[tostring(3407624520)] = {
        ProductID = 3407624520,
        ProductType = "Product",
        GiftType = "Product",
        GiftName = "BattlePassLevels10",
        TargetProductID = v47.ProductID,
        DisplayName = v47.DisplayName,
        IsPaidRandomItem = nil,
        Quantity = nil,
        ImageID = nil
    }
    table.insert(t_1.GiftOrder, (tostring(3407624520)))
    v47 = t_1.Bundles.primeseason_bundle or error("???")
    t_1.Gifts[tostring(3407614262)] = {
        ProductID = 3407614262,
        ProductType = "Product",
        GiftType = "Bundle",
        GiftName = "primeseason_bundle",
        TargetProductID = v47.ProductID,
        DisplayName = v47.DisplayName,
        IsPaidRandomItem = nil,
        Quantity = nil,
        ImageID = nil
    }
    table.insert(t_1.GiftOrder, (tostring(3407614262)))
    v47 = t_1.Bundles.contrabandseason_bundle or error("???")
    t_1.Gifts[tostring(3407615047)] = {
        ProductID = 3407615047,
        ProductType = "Product",
        GiftType = "Bundle",
        GiftName = "contrabandseason_bundle",
        TargetProductID = v47.ProductID,
        DisplayName = v47.DisplayName,
        IsPaidRandomItem = nil,
        Quantity = nil,
        ImageID = nil
    }
    table.insert(t_1.GiftOrder, (tostring(3407615047)))
end

v1 = t_1.Gamepasses.StandardWeaponsBundle or error("???")
local v48 = {
    ProductID = 1890371681,
    ProductType = "Gamepass",
    GiftType = "Gamepass",
    GiftName = "StandardWeaponsBundle",
    TargetProductID = nil,
    DisplayName = nil,
    IsPaidRandomItem = nil,
    Quantity = nil,
    ImageID = nil
}
local v49 = v1.GamepassID or v1.ProductID
v48.TargetProductID = v49
v48.DisplayName = v1.DisplayName
t_1.Gifts[tostring(1890371681)] = v48
local GiftOrder_15 = t_1.GiftOrder
local str_15 = tostring(1890371681)
table.insert(GiftOrder_15, str_15)
v48 = t_1.Gamepasses.ClassicBundle or error("???")
local t_140 = {
    ProductID = 1890372364,
    ProductType = "Gamepass",
    GiftType = "Gamepass",
    GiftName = "ClassicBundle",
    TargetProductID = nil,
    DisplayName = nil,
    IsPaidRandomItem = nil,
    Quantity = nil,
    ImageID = nil
}
local v50 = v48.GamepassID or v48.ProductID
t_140.TargetProductID = v50
t_140.DisplayName = v48.DisplayName
t_1.Gifts[tostring(1890372364)] = t_140
local GiftOrder_16 = t_1.GiftOrder
local str_16 = tostring(1890372364)
table.insert(GiftOrder_16, str_16)
v48 = t_1.Gamepasses.HeavyDutyBundle or error("???")
local t_141 = {
    ProductID = 1890372130,
    ProductType = "Gamepass",
    GiftType = "Gamepass",
    GiftName = "HeavyDutyBundle",
    TargetProductID = nil,
    DisplayName = nil,
    IsPaidRandomItem = nil,
    Quantity = nil,
    ImageID = nil
}
local v51 = v48.GamepassID or v48.ProductID
t_141.TargetProductID = v51
t_141.DisplayName = v48.DisplayName
t_1.Gifts[tostring(1890372130)] = t_141
local GiftOrder_17 = t_1.GiftOrder
local str_17 = tostring(1890372130)
table.insert(GiftOrder_17, str_17)
v48 = t_1.Gamepasses.ExogunBundle or error("???")
local t_142 = {
    ProductID = 1890372574,
    ProductType = "Gamepass",
    GiftType = "Gamepass",
    GiftName = "ExogunBundle",
    TargetProductID = nil,
    DisplayName = nil,
    IsPaidRandomItem = nil,
    Quantity = nil,
    ImageID = nil
}
local v52 = v48.GamepassID or v48.ProductID
t_142.TargetProductID = v52
t_142.DisplayName = v48.DisplayName
t_1.Gifts[tostring(1890372574)] = t_142
local GiftOrder_18 = t_1.GiftOrder
local str_18 = tostring(1890372574)
table.insert(GiftOrder_18, str_18)
v48 = t_1.Gamepasses.MedkitBundle or error("???")
local t_143 = {
    ProductID = 1890372831,
    ProductType = "Gamepass",
    GiftType = "Gamepass",
    GiftName = "MedkitBundle",
    TargetProductID = nil,
    DisplayName = nil,
    IsPaidRandomItem = nil,
    Quantity = nil,
    ImageID = nil
}
local v53 = v48.GamepassID or v48.ProductID
t_143.TargetProductID = v53
t_143.DisplayName = v48.DisplayName
t_1.Gifts[tostring(1890372831)] = t_143
local GiftOrder_19 = t_1.GiftOrder
local str_19 = tostring(1890372831)
table.insert(GiftOrder_19, str_19)
v48 = t_1.Gamepasses.StarterBundle or error("???")
local t_144 = {
    ProductID = 1890371901,
    ProductType = "Gamepass",
    GiftType = "Gamepass",
    GiftName = "StarterBundle",
    TargetProductID = nil,
    DisplayName = nil,
    IsPaidRandomItem = nil,
    Quantity = nil,
    ImageID = nil
}
local v54 = v48.GamepassID or v48.ProductID
t_144.TargetProductID = v54
t_144.DisplayName = v48.DisplayName
t_1.Gifts[tostring(1890371901)] = t_144
local GiftOrder_20 = t_1.GiftOrder
local str_20 = tostring(1890371901)
table.insert(GiftOrder_20, str_20)
v48 = t_1.Gamepasses.EnergyBundle or error("???")
local t_145 = {
    ProductID = 2661338143,
    ProductType = "Gamepass",
    GiftType = "Gamepass",
    GiftName = "EnergyBundle",
    TargetProductID = nil,
    DisplayName = nil,
    IsPaidRandomItem = nil,
    Quantity = nil,
    ImageID = nil
}
local v55 = v48.GamepassID or v48.ProductID
t_145.TargetProductID = v55
t_145.DisplayName = v48.DisplayName
t_1.Gifts[tostring(2661338143)] = t_145
local GiftOrder_21 = t_1.GiftOrder
local str_21 = tostring(2661338143)
table.insert(GiftOrder_21, str_21)
v48 = t_1.Gamepasses.RPGBundle or error("???")
local t_146 = {
    ProductID = 3277561206,
    ProductType = "Gamepass",
    GiftType = "Gamepass",
    GiftName = "RPGBundle",
    TargetProductID = nil,
    DisplayName = nil,
    IsPaidRandomItem = nil,
    Quantity = nil,
    ImageID = nil
}
local v56 = v48.GamepassID or v48.ProductID
t_146.TargetProductID = v56
t_146.DisplayName = v48.DisplayName
t_1.Gifts[tostring(3277561206)] = t_146
local GiftOrder_22 = t_1.GiftOrder
local str_22 = tostring(3277561206)
table.insert(GiftOrder_22, str_22)
v48 = ShopLibrary_m.Entries["lootbox_Skin Case"] or error("???")
local t_147 = {
    ProductID = 1892544195,
    ProductType = "Product",
    GiftType = "ShopEntry",
    GiftName = "lootbox_Skin Case",
    TargetProductID = v48.ProductQuantityToID[1] or v48.ProductID,
    DisplayName = v48.Rewards[1].Name .. "" or v48.DisplayName,
    IsPaidRandomItem = true,
    Quantity = nil,
    ImageID = nil
}
t_1.Gifts[tostring(1892544195)] = t_147
local GiftOrder_23 = t_1.GiftOrder
local str_23 = tostring(1892544195)
table.insert(GiftOrder_23, str_23)
v48 = ShopLibrary_m.Entries["lootbox_Skin Case"] or error("???")
local t_148 = {
    ProductID = 2319692001,
    ProductType = "Product",
    GiftType = "ShopEntry",
    GiftName = "lootbox_Skin Case",
    TargetProductID = v48.ProductQuantityToID[3] or v48.ProductID,
    DisplayName = v48.Rewards[1].Name .. " [\195\151" .. 3 .. "]" or v48.DisplayName,
    IsPaidRandomItem = true,
    Quantity = 3,
    ImageID = nil
}
t_1.Gifts[tostring(2319692001)] = t_148
local GiftOrder_24 = t_1.GiftOrder
local str_24 = tostring(2319692001)
table.insert(GiftOrder_24, str_24)
v48 = ShopLibrary_m.Entries["lootbox_Skin Case 2"] or error("???")
local t_149 = {
    ProductID = 1892544449,
    ProductType = "Product",
    GiftType = "ShopEntry",
    GiftName = "lootbox_Skin Case 2",
    TargetProductID = v48.ProductQuantityToID[1] or v48.ProductID,
    DisplayName = v48.Rewards[1].Name .. "" or v48.DisplayName,
    IsPaidRandomItem = true,
    Quantity = nil,
    ImageID = nil
}
t_1.Gifts[tostring(1892544449)] = t_149
local GiftOrder_25 = t_1.GiftOrder
local str_25 = tostring(1892544449)
table.insert(GiftOrder_25, str_25)
v48 = ShopLibrary_m.Entries["lootbox_Skin Case 2"] or error("???")
local t_150 = {
    ProductID = 2319692175,
    ProductType = "Product",
    GiftType = "ShopEntry",
    GiftName = "lootbox_Skin Case 2",
    TargetProductID = v48.ProductQuantityToID[3] or v48.ProductID,
    DisplayName = v48.Rewards[1].Name .. " [\195\151" .. 3 .. "]" or v48.DisplayName,
    IsPaidRandomItem = true,
    Quantity = 3,
    ImageID = nil
}
t_1.Gifts[tostring(2319692175)] = t_150
local GiftOrder_26 = t_1.GiftOrder
local str_26 = tostring(2319692175)
table.insert(GiftOrder_26, str_26)
v48 = ShopLibrary_m.Entries["lootbox_Skin Case 3"] or error("???")
local t_151 = {
    ProductID = 3251887720,
    ProductType = "Product",
    GiftType = "ShopEntry",
    GiftName = "lootbox_Skin Case 3",
    TargetProductID = v48.ProductQuantityToID[1] or v48.ProductID,
    DisplayName = v48.Rewards[1].Name .. "" or v48.DisplayName,
    IsPaidRandomItem = true,
    Quantity = nil,
    ImageID = nil
}
t_1.Gifts[tostring(3251887720)] = t_151
local GiftOrder_27 = t_1.GiftOrder
local str_27 = tostring(3251887720)
table.insert(GiftOrder_27, str_27)
v48 = ShopLibrary_m.Entries["lootbox_Skin Case 3"] or error("???")
local t_152 = {
    ProductID = 3251887824,
    ProductType = "Product",
    GiftType = "ShopEntry",
    GiftName = "lootbox_Skin Case 3",
    TargetProductID = v48.ProductQuantityToID[3] or v48.ProductID,
    DisplayName = v48.Rewards[1].Name .. " [\195\151" .. 3 .. "]" or v48.DisplayName,
    IsPaidRandomItem = true,
    Quantity = 3,
    ImageID = nil
}
t_1.Gifts[tostring(3251887824)] = t_152
local GiftOrder_28 = t_1.GiftOrder
local str_28 = tostring(3251887824)
table.insert(GiftOrder_28, str_28)
v48 = t_1.Bundles.keybundle_1 or error("???")
t_1.Gifts[tostring(1890374722)] = {
    ProductID = 1890374722,
    ProductType = "Product",
    GiftType = "Bundle",
    GiftName = "keybundle_1",
    TargetProductID = v48.ProductID,
    DisplayName = v48.DisplayName,
    IsPaidRandomItem = nil,
    Quantity = nil,
    ImageID = nil
}
local GiftOrder_29 = t_1.GiftOrder
local str_29 = tostring(1890374722)
table.insert(GiftOrder_29, str_29)
v48 = t_1.Bundles.keybundle_2 or error("???")
t_1.Gifts[tostring(1890374959)] = {
    ProductID = 1890374959,
    ProductType = "Product",
    GiftType = "Bundle",
    GiftName = "keybundle_2",
    TargetProductID = v48.ProductID,
    DisplayName = v48.DisplayName,
    IsPaidRandomItem = nil,
    Quantity = nil,
    ImageID = nil
}
local GiftOrder_30 = t_1.GiftOrder
local str_30 = tostring(1890374959)
table.insert(GiftOrder_30, str_30)
v48 = t_1.Bundles.keybundle_3 or error("???")
t_1.Gifts[tostring(1890375172)] = {
    ProductID = 1890375172,
    ProductType = "Product",
    GiftType = "Bundle",
    GiftName = "keybundle_3",
    TargetProductID = v48.ProductID,
    DisplayName = v48.DisplayName,
    IsPaidRandomItem = nil,
    Quantity = nil,
    ImageID = nil
}
local GiftOrder_31 = t_1.GiftOrder
local str_31 = tostring(1890375172)
table.insert(GiftOrder_31, str_31)
v48 = t_1.Bundles.keybundle_4 or error("???")
t_1.Gifts[tostring(1890375405)] = {
    ProductID = 1890375405,
    ProductType = "Product",
    GiftType = "Bundle",
    GiftName = "keybundle_4",
    TargetProductID = v48.ProductID,
    DisplayName = v48.DisplayName,
    IsPaidRandomItem = nil,
    Quantity = nil,
    ImageID = nil
}
local GiftOrder_32 = t_1.GiftOrder
local str_32 = tostring(1890375405)
table.insert(GiftOrder_32, str_32)
v48 = t_1.Bundles.keybundle_5 or error("???")
t_1.Gifts[tostring(1890375611)] = {
    ProductID = 1890375611,
    ProductType = "Product",
    GiftType = "Bundle",
    GiftName = "keybundle_5",
    TargetProductID = v48.ProductID,
    DisplayName = v48.DisplayName,
    IsPaidRandomItem = nil,
    Quantity = nil,
    ImageID = nil
}
local GiftOrder_33 = t_1.GiftOrder
local str_33 = tostring(1890375611)
table.insert(GiftOrder_33, str_33)

for _, val_15 in pairs(t_1.CosmeticBundlesOrder) do
    if val_15 ~= EventLibrary_m.SKIN_BUNDLE_NAME then
        add_bundle_gift(val_15)
    end
end

local function add_video_ad_reward(arg50, arg51, arg52) -- line: 667
    -- upvalues:
    --  [1] t_1 (copy)

    local t_158 = {
        NumAdsRequired = arg50,
        RewardDatas = arg51 or {},
        PreRepetitionRewardDatas = arg52 or {}
    }
    table.insert(t_1.VideoAdRewards, t_158)
end

add_video_ad_reward(1, { { Name = "3D Glasses", Quantity = 1, Weapon = "IsRandom" } }, nil)
add_video_ad_reward(2, { { Name = "Glamour", Quantity = 1, Weapon = "IsRandom" } }, nil)
add_video_ad_reward(
    3,
    { { Name = "Director's Cut", Quantity = 1, Weapon = "IsRandom" } },
    { { Name = "Key", Quantity = 3 } }
)

local function add_ugc(arg53, arg54, arg55) -- line: 681
    -- upvalues:
    --  [1] t_1 (copy)

    assert(not t_1.UGCs[arg53])

    for _, val_16 in pairs(t_1.UGCs) do
        assert(val_16.AssetID ~= arg54)
    end

    t_1.UGCs[arg53] = { Name = arg53, AssetID = arg54, CanBeMisleading = arg55 }
    t_1.UGCAssetIDToName[tostring(arg54)] = arg53
    table.insert(t_1.UGCOrder, arg53)
end

add_ugc("clothing_iloverivals1", 137732463728326)
add_ugc("clothing_iloverivals2", 90796679262086)
add_ugc("clothing_arenashirt", 137296265324812)
add_ugc("clothing_arenapants", 129512336852435)
add_ugc("ugc_arenamanhead", 92733410260261)
add_ugc("ugc_removeautoshootsign", 96099566912338)
add_ugc("ugc_rivalskatana", 125867270722283, true)
add_ugc("ugc_rivalsrpkey", 111522988085700, true)
add_ugc("ugc_rivalskeyvolver", 113554056154134, true)
add_ugc("ugc_rivalskeytana", 109723477692566, true)
add_ugc("ugc_rivalskeythe", 124750945461549, true)
add_ugc("ugc_rivalsakey", 107643383612249, true)
add_ugc("ugc_rivalskeyper", 115241839813934, true)
add_ugc("ugc_rivalskeybow", 84129786923826, true)
add_ugc("ugc_rivalsshotkey", 85619994948307, true)
add_ugc("ugc_rivalskeyttleaxe", 112664145011287, true)
add_ugc("ugc_rivalskeyzi", 103972049379360, true)
add_ugc("ugc_rivalskeylisong", 138648784848614, true)
add_ugc("ugc_rivalskeyrambit", 84629336575689, true)
add_ugc("ugc_rivalskeynais", 105245077140577, true)
add_ugc("ugc_rivalskeyst", 117095370466098, true)
add_ugc("ugc_shouldermedkitty", 103869769768832, true)
add_ugc("ugc_rivalsnotebook", 133770605510980, true)
add_ugc("ugc_targetmask", 127292540343907)
add_ugc("ugc_eliminatedtrollface", 121118883943056)
add_ugc("ugc_disconnectedtrollface", 73916910731449)
add_ugc("ugc_unranked", 115861376533108)
add_ugc("ugc_bronzerank", 101681212276850)
add_ugc("ugc_silverrank", 140214523497602)
add_ugc("ugc_goldrank", 102276356750407)
add_ugc("ugc_platinumrank", 110101090201266)
add_ugc("ugc_diamondrank", 133745283061883)
add_ugc("ugc_onyxrank", 85555348152612)
add_ugc("ugc_nemesisrank", 110806369909684)
add_ugc("ugc_archnemesisrank", 102797305676607)

local function add_ugc_milestone(arg56, arg57, arg58) -- line: 735
    -- upvalues:
    --  [1] t_1 (copy)
    --  [2] CosmeticLibrary_m (copy)

    assert(not t_1.UGCMilestones[arg56])
    local t_163 = { Name = arg56, PurchaseRequirement = arg57, Reward = arg58 }
    t_1.UGCMilestones[arg56] = t_163
    table.insert(t_1.UGCMilestoneOrder, arg56)

    if CosmeticLibrary_m.Cosmetics[t_163.Reward.Name] then
        local v66 = CosmeticLibrary_m
        local Name_5 = t_163.Reward.Name
        v66:ExternallySetCosmeticDescription(
            Name_5,
            "Earned from purchasing " .. t_163.PurchaseRequirement .. " UGC item" .. (if t_163.PurchaseRequirement ~= 1 then "s" else "")
        )
    end
end

add_ugc_milestone("ugc_milestone0", 1, { Name = "Skin Ticket", Quantity = 1 })
add_ugc_milestone("ugc_milestone1", 5, { Name = "Sneaker", Weapon = "IsUniversal" })
add_ugc_milestone("ugc_milestone2", 10, { Name = "Heirloom", Weapon = "IsUniversal" })
add_ugc_milestone("ugc_milestone3", 15, { Name = "Plushify", Weapon = "IsUniversal" })
add_ugc_milestone("ugc_milestone4", 20, { Name = "Busting A Move" })
add_ugc_milestone("ugc_milestone5", 25, { Name = "Fist", Weapon = "Fists" })

return t_1
