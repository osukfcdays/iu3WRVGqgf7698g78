local t = {}
local t_1 = {
    CURRENCY_NAME = "Pearl",
    CURRENCY_NAME_PLURAL = "Pearls",
    CURRENCY_IMAGE = "rbxassetid://128587370010060",
    CURRENCY_IMAGE_FLAT = "rbxassetid://93406657709407",
    CURRENCY_IMAGE_FLAT_OUTLINE = "rbxassetid://95350863643200",
    CURRENCY_COLOR = Color3.fromRGB(239, 176, 255),
    CURRENCY_COLOR_GRADIENT = nil,
    BUNDLE_BACKGROUND_IMAGES = nil,
    OVERVIEW_BANNER_IMAGE = "rbxassetid://117618245635260",
    OVERVIEW_BUTTON_IMAGE = "rbxassetid://92989711430837",
    LOADING_SCREEN_LOGO = "rbxassetid://85313933907097",
    LOBBY_MUSIC = "Tropical",
    LOBBY_MUSIC_MUFFLED = "TropicalMuffled",
    LOBBY_LIGHTING_PROFILE = "LobbyTropical",
    EQUIPMENT_LIGHTING_PROFILE = "LobbyTropical",
    LTM_HEADER_ICON = "rbxassetid://78136793834272",
    GLOWY_BACKGROUND_COLOR_OVERRIDES = nil
}
local t_2 = { "rbxassetid://120786971461452", [4] = "rbxassetid://73561500503723" }
t_2[5] = "rbxassetid://79528672047345"
t_1.BUNDLE_BACKGROUND_IMAGES = t_2
t_1.GLOWY_BACKGROUND_COLOR_OVERRIDES = {
    Purple = Color3.fromRGB(42, 85, 111),
    Purple2 = Color3.fromRGB(31, 61, 144),
    Yellow = Color3.fromRGB(17, 0, 254)
}
t.Summer = t_1
local t_4 = {
    CURRENCY_NAME = "Candy",
    CURRENCY_NAME_PLURAL = "Candy",
    CURRENCY_IMAGE = "rbxassetid://139984992207621",
    CURRENCY_IMAGE_FLAT = "rbxassetid://105505748492292",
    CURRENCY_IMAGE_FLAT_OUTLINE = "rbxassetid://90825880394324",
    CURRENCY_COLOR = Color3.fromRGB(255, 127, 0),
    CURRENCY_COLOR_GRADIENT = nil,
    BUNDLE_BACKGROUND_IMAGES = nil,
    OVERVIEW_BANNER_IMAGE = "rbxassetid://121777952645484",
    OVERVIEW_BUTTON_IMAGE = "rbxassetid://80974689450076",
    LOADING_SCREEN_LOGO = "rbxassetid://96198404149077",
    LOBBY_MUSIC = "Spooky",
    LOBBY_MUSIC_MUFFLED = "SpookyMuffled",
    LOBBY_LIGHTING_PROFILE = "LobbySpooky",
    EQUIPMENT_LIGHTING_PROFILE = "LobbySpooky",
    LTM_HEADER_ICON = "rbxassetid://78136793834272",
    GLOWY_BACKGROUND_COLOR_OVERRIDES = nil
}
local t_5 = { "rbxassetid://140701532981455" }
t_5[5] = "rbxassetid://121767138688269"
t_4.BUNDLE_BACKGROUND_IMAGES = t_5
t_4.GLOWY_BACKGROUND_COLOR_OVERRIDES = {
    Purple = Color3.fromRGB(123, 255, 0),
    Purple2 = Color3.fromRGB(32, 12, 66),
    Yellow = Color3.fromRGB(0, 0, 0)
}
t.Spooky = t_4
local t_7 = {
    CURRENCY_NAME = "Crystal",
    CURRENCY_NAME_PLURAL = "Crystals",
    CURRENCY_IMAGE = "rbxassetid://134934134842764",
    CURRENCY_IMAGE_FLAT = "rbxassetid://116178247622565",
    CURRENCY_IMAGE_FLAT_OUTLINE = "rbxassetid://89625231758124",
    CURRENCY_COLOR = Color3.fromRGB(48, 221, 255),
    CURRENCY_COLOR_GRADIENT = nil,
    BUNDLE_BACKGROUND_IMAGES = nil,
    OVERVIEW_BANNER_IMAGE = "rbxassetid://109554184678249",
    OVERVIEW_BUTTON_IMAGE = "rbxassetid://134934134842764",
    LOADING_SCREEN_LOGO = "rbxassetid://101362140024495",
    LOBBY_MUSIC = "Festive",
    LOBBY_MUSIC_MUFFLED = "FestiveMuffled",
    LOBBY_LIGHTING_PROFILE = "LobbyFestive",
    EQUIPMENT_LIGHTING_PROFILE = "LobbyFestive",
    LTM_HEADER_ICON = "rbxassetid://78136793834272"
}
local t_8 = { "rbxassetid://135222754688862" }
t_8[5] = "rbxassetid://93388902108383"
t_7.BUNDLE_BACKGROUND_IMAGES = t_8
t.Festive = t_7
local t_9 = {
    IS_ACTIVE = true,
    NUM_GAMES_NEEDED_TO_PARTICIPATE = 15,
    RESET_CURRENCY_COUNTER = 9,
    RESET_CURRENCY_COMPENSATION_MILESTONE = 30
}
t_9.RESET_CURRENCY_COMPENSATION_REWARDS = {
    { Name = "Tropical Chest", Quantity = 1, Weapon = "IsRandom" }
}
t_9.RESET_CURRENCY_COMPENSATION_REWARDS_CAN_MULTIPLY_QUANTITY = true
t_9.LAST_EVENT_NAME = "Summer"
t_9.EVENT_NAME = "Spooky"
t_9.EVENT_TASK_NAMES = {
    "EventDuelRoundPlayed",
    "EventEliminations",
    "EventDuelWon",
    "EventDuelWon2",
    "EventDuelWon3",
    "EventDuelWon4"
}
t_9.CURRENCY_RUSH_DAILY_LIMIT = 200
t_9.CURRENCY_RUSH_MULTIPLIER = 5
t_9.LTM_QUEUENAMES = {
    "ltm_monstertower_gargoyletower",
    "ltm_monstertower_gargoyletower_solo",
    "ltm_monstertower_zombietower",
    "ltm_monstertower_zombietower_solo"
}
t_9.LTM_QUEUES_SMART_TILING_X_SIZE_MULTIPLIER = 0.3
t_9.LTM_QUEUES_SMART_TILING_DISABLED = false
t_9.LTM_QUEUES_REWARDS_DISPLAYED = {
    "Chombie Head",
    "Zombie",
    "Towerstone Fists",
    "Gargoyle Head",
    "Conduction",
    "Towerstone Wildcat"
}
t_9.UNIVERSAL_SHOP_CHARM = "Jerm"
t_9.UNIVERSAL_SHOP_WRAP = "Brewery"
t_9.UNIVERSAL_SHOP_FINISHER = "Acid Splash"
t_9.UNIVERSAL_SHOP_EMOTE = "Zombie Walk"
t_9.STANDALONE_SHOP_SKIN = { Name = "Cursed Daggers", Weapon = "Daggers" }
t_9.SPECIAL_LOOTBOX_SKINS = "Spooky Skin Case"
t_9.SPECIAL_LOOTBOX_VARIETY = "Haunted Chest"
t_9.CURRENCY_BUNDLE_CHARM = "Dumbkin"
t_9.CURRENCY_BUNDLE_WRAP = "Greenflame"
t_9.CURRENCY_BUNDLE_FINISHER = "DRIP"
t_9.CURRENCY_BUNDLE_SKIN = "Shadow Wildcat"
t_9.PRIZE_WHEEL_NAME = "Spooky Prize Wheel"
t_9.SKIN_BUNDLE_NAME = "bat_bundle"
t_9.EVENT_GIFT_REWARD = nil
t_9.EVENT_GIFT_COOLDOWN = 3600
t_9.SHOP_ENTRIES_OVERVIEW = {}
t_9.EVENT_DETAILS = t[t_9.EVENT_NAME]
t_9.LAST_EVENT_DETAILS = t[t_9.LAST_EVENT_NAME]
t_9.LOBBY_VISUALS_PROFILE = if t_9.IS_ACTIVE then t_9.EVENT_NAME else "Default"
t_9.STANDALONE_SHOP_SKIN_SHOP_ENTRY_NAME = "loose_standaloneeventskin"
t_9.STANDALONE_PRIZE_WHEEL_SHOP_ENTRY_NAME = if not t_9.PRIZE_WHEEL_NAME then nil else "lootbox_" .. t_9.PRIZE_WHEEL_NAME

local function populate_shop_entries() -- line: 130
    -- upvalues:
    --  [1] t_9 (copy)

    if t_9.PRIZE_WHEEL_NAME then
        table.insert(t_9.SHOP_ENTRIES_OVERVIEW, t_9.STANDALONE_PRIZE_WHEEL_SHOP_ENTRY_NAME)
    end

    if t_9.SPECIAL_LOOTBOX_SKINS then
        table.insert(t_9.SHOP_ENTRIES_OVERVIEW, "lootbox_" .. t_9.SPECIAL_LOOTBOX_SKINS)
    end

    if t_9.SPECIAL_LOOTBOX_VARIETY then
        table.insert(t_9.SHOP_ENTRIES_OVERVIEW, "lootbox_" .. t_9.SPECIAL_LOOTBOX_VARIETY)
    end

    if t_9.UNIVERSAL_SHOP_CHARM then
        table.insert(t_9.SHOP_ENTRIES_OVERVIEW, "loose_" .. t_9.UNIVERSAL_SHOP_CHARM)
    end

    if t_9.UNIVERSAL_SHOP_WRAP then
        table.insert(t_9.SHOP_ENTRIES_OVERVIEW, "loose_" .. t_9.UNIVERSAL_SHOP_WRAP)
    end

    if t_9.UNIVERSAL_SHOP_FINISHER then
        table.insert(t_9.SHOP_ENTRIES_OVERVIEW, "loose_" .. t_9.UNIVERSAL_SHOP_FINISHER)
    end

    if t_9.UNIVERSAL_SHOP_EMOTE then
        table.insert(t_9.SHOP_ENTRIES_OVERVIEW, "loose_" .. t_9.UNIVERSAL_SHOP_EMOTE)
    end

    if t_9.STANDALONE_SHOP_SKIN then
        table.insert(t_9.SHOP_ENTRIES_OVERVIEW, t_9.STANDALONE_SHOP_SKIN_SHOP_ENTRY_NAME)
    end
end

populate_shop_entries()

return t_9
