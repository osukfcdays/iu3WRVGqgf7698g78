local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TestLibrary_m = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("TestLibrary"))
local t = {
    "PRIVATE_SERVER_ID",
    "PRIVATE_SERVER_OWNER_ID",
    "IS_PUBLIC_SERVER",
    "IS_RESERVED_SERVER",
    "IS_PRIVATE_SERVER",
    "IS_PRIVATE_HUB_SERVER"
}
local RequestConstants = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Misc"):WaitForChild(
    "RequestConstants"
)
local StudioIsPrivateServerOwner = TestLibrary_m:GetTestAttribute("StudioIsPrivateServerOwner")
local StudioIsPrivateServer = TestLibrary_m:GetTestAttribute("StudioIsPrivateServer")
local StudioPlaceID = TestLibrary_m:GetTestAttribute("StudioPlaceID")
local t_1 = {
    GAME_VERSION = 31,
    MAIN_HUB_PLACE_ID = 17625359962,
    MAIN_MOBILE_PLACE_ID = 18126510175,
    MAIN_MATCHMAKING_PLACE_ID = 117398147513099,
    MAIN_ARCADE_TEAMDEATHMATCH_PLACE_ID = 71874690745115,
    MAIN_ARCADE_FREEFORALL_PLACE_ID = 129604661913557,
    MAIN_ARCADE_GUNGAME_PLACE_ID = 133215910299950,
    TESTING_HUB_PLACE_ID = 12011504191,
    TESTING_MOBILE_PLACE_ID = 18126498684,
    TESTING_MATCHMAKING_PLACE_ID = 136907445582634,
    TESTING_ARCADE_TEAMDEATHMATCH_PLACE_ID = 139242311442282,
    TESTING_ARCADE_FREEFORALL_PLACE_ID = 83743252354420,
    TESTING_ARCADE_GUNGAME_PLACE_ID = 90728399170029,
    IS_RUNNING = RunService:IsRunning(),
    IS_STUDIO = RunService:IsStudio(),
    IS_SERVER = RunService:IsServer(),
    IS_CLIENT = RunService:IsClient(),
    DEVICE = "Server"
}
t_1.PLACE_ID = if t_1.IS_STUDIO and StudioPlaceID > 0 then StudioPlaceID else game.PlaceId
t_1.JOB_ID = game.JobId
local v2 = t_1.IS_SERVER

if v2 then
    v2 = game.PrivateServerId
end

t_1.PRIVATE_SERVER_ID = v2
v2 = t_1.IS_SERVER and game.PrivateServerOwnerId
t_1.PRIVATE_SERVER_OWNER_ID = v2
v2 = t_1.PLACE_ID == t_1.MAIN_HUB_PLACE_ID or t_1.PLACE_ID == t_1.MAIN_MOBILE_PLACE_ID or t_1.PLACE_ID == t_1.MAIN_MATCHMAKING_PLACE_ID or t_1.PLACE_ID == t_1.MAIN_ARCADE_TEAMDEATHMATCH_PLACE_ID or t_1.PLACE_ID == t_1.MAIN_ARCADE_FREEFORALL_PLACE_ID or t_1.PLACE_ID == t_1.MAIN_ARCADE_GUNGAME_PLACE_ID
t_1.IS_MAIN_SERVER = v2
v2 = t_1.PLACE_ID == t_1.TESTING_HUB_PLACE_ID or t_1.PLACE_ID == t_1.TESTING_MOBILE_PLACE_ID or t_1.PLACE_ID == t_1.TESTING_MATCHMAKING_PLACE_ID or t_1.PLACE_ID == t_1.TESTING_ARCADE_TEAMDEATHMATCH_PLACE_ID or t_1.PLACE_ID == t_1.TESTING_ARCADE_FREEFORALL_PLACE_ID or t_1.PLACE_ID == t_1.TESTING_ARCADE_GUNGAME_PLACE_ID
t_1.IS_TESTING_SERVER = v2
v2 = t_1.IS_MAIN_SERVER and t_1.MAIN_HUB_PLACE_ID or t_1.TESTING_HUB_PLACE_ID
t_1.HUB_PLACE_ID = v2
v2 = t_1.IS_MAIN_SERVER and t_1.MAIN_MOBILE_PLACE_ID or t_1.TESTING_MOBILE_PLACE_ID
t_1.MOBILE_PLACE_ID = v2
v2 = t_1.IS_MAIN_SERVER and t_1.MAIN_MATCHMAKING_PLACE_ID or t_1.TESTING_MATCHMAKING_PLACE_ID
t_1.MATCHMAKING_PLACE_ID = v2
v2 = t_1.IS_MAIN_SERVER and t_1.MAIN_ARCADE_TEAMDEATHMATCH_PLACE_ID or t_1.TESTING_ARCADE_TEAMDEATHMATCH_PLACE_ID
t_1.ARCADE_TEAMDEATHMATCH_PLACE_ID = v2
v2 = t_1.IS_MAIN_SERVER and t_1.MAIN_ARCADE_FREEFORALL_PLACE_ID or t_1.TESTING_ARCADE_FREEFORALL_PLACE_ID
t_1.ARCADE_FREEFORALL_PLACE_ID = v2
v2 = t_1.IS_MAIN_SERVER and t_1.MAIN_ARCADE_GUNGAME_PLACE_ID or t_1.TESTING_ARCADE_GUNGAME_PLACE_ID
t_1.ARCADE_GUNGAME_PLACE_ID = v2
v2 = if not t_1.IS_STUDIO then t_1.IS_SERVER and t_1.PRIVATE_SERVER_ID == "" else not StudioIsPrivateServer
t_1.IS_PUBLIC_SERVER = v2
v2 = if not t_1.IS_STUDIO then t_1.IS_SERVER and not t_1.IS_PUBLIC_SERVER and t_1.PRIVATE_SERVER_OWNER_ID == 0 else StudioIsPrivateServer
t_1.IS_RESERVED_SERVER = v2
v2 = if not t_1.IS_STUDIO then t_1.IS_SERVER and not t_1.IS_PUBLIC_SERVER and t_1.PRIVATE_SERVER_OWNER_ID ~= 0 else StudioIsPrivateServer
t_1.IS_PRIVATE_SERVER = v2
v2 = t_1.PLACE_ID == t_1.HUB_PLACE_ID or t_1.PLACE_ID == t_1.MOBILE_PLACE_ID
t_1.IS_HUB_SERVER = v2
v2 = t_1.PLACE_ID == t_1.MOBILE_PLACE_ID
t_1.IS_MOBILE_SERVER = v2
v2 = t_1.PLACE_ID == t_1.ARCADE_TEAMDEATHMATCH_PLACE_ID or t_1.PLACE_ID == t_1.ARCADE_FREEFORALL_PLACE_ID or t_1.PLACE_ID == t_1.ARCADE_GUNGAME_PLACE_ID
t_1.IS_ARCADE_SERVER = v2
t_1.IS_MATCHMAKING_SERVER = if t_1.PLACE_ID ~= t_1.MATCHMAKING_PLACE_ID then false else true
v2 = t_1.IS_HUB_SERVER

if v2 then
    v2 = t_1.IS_PRIVATE_SERVER
end

t_1.IS_PRIVATE_HUB_SERVER = v2
t_1.GROUP_ID = 3461453
t_1.TEAM_GROUP_ROLE_ID = 816494002

function t_1.IS_PRIVATE_SERVER_OWNER(arg1) -- line: 72
    -- upvalues:
    --  [1] StudioIsPrivateServerOwner (copy)
    --  [2] t_1 (copy)

    return StudioIsPrivateServerOwner or t_1.IS_TESTING_SERVER and not t_1.IS_STUDIO or t_1.IS_PRIVATE_HUB_SERVER and (t_1.IS_STUDIO or t_1.PRIVATE_SERVER_OWNER_ID == arg1)
end

function t_1.SHOULD_ALWAYS_REPLICATE(_) -- line: 73
    -- upvalues:
    --  [1] t_1 (copy)

    return t_1.IS_ARCADE_SERVER or t_1.IS_MATCHMAKING_SERVER
end

t_1.DEFAULT_WEAPONS = { "Assault Rifle", "Handgun", "Fists", "Grenade" }
t_1.DEFAULT_MAPS = { "Arena", "Backrooms", "Construction", "Docks" }
t_1.QUEUES_ACTIVE = t_1.IS_HUB_SERVER
local v5 = t_1.IS_HUB_SERVER or t_1.IS_MATCHMAKING_SERVER
t_1.SHOOTING_RANGE_ACTIVE = v5
t_1.BASE_HEALTH = 150
t_1.BASE_WALKSPEED = 16
t_1.BASE_JUMPPOWER = 20
t_1.BASE_GRAVITY = 0.25
t_1.BASE_MASS = 14.381
t_1.SELF_DAMAGE_MULTIPLIER = 0
t_1.MAX_RAYCAST_DISTANCE = 400
t_1.RENDER_DISTANCE = 500
t_1.MAX_PARTY_SIZE = 5
t_1.BEGINNER_QUEUE_NAME = "2v2_beginner"
t_1.BEGINNER_QUEUE_WINS = 10
t_1.WEAPON_REVEAL_TIME_OFFSET = 604800
t_1.WEAPON_EARLY_ACCESS_TIME_OFFSET = 86400
t_1.HEADSHOT_IMAGE = "https://www.roblox.com/headshot-thumbnail/image?userId=%s&width=420&height=420&format=png"
t_1.CONTROLS_IMAGES = {
    MouseKeyboard = "rbxassetid://17136633356",
    Touch = "rbxassetid://17136633510",
    Gamepad = "rbxassetid://17136633629",
    VR = "rbxassetid://17136765745"
}
t_1.CONTROLS_IMAGES_CENTERED = {
    MouseKeyboard = "rbxassetid://88012714630436",
    Touch = "rbxassetid://113510944677126",
    Gamepad = "rbxassetid://110291144710849",
    VR = "rbxassetid://99115398611290"
}
local t_4 = {}
t_4[Enum.HumanoidStateType.FallingDown] = true
t_4[Enum.HumanoidStateType.Jumping] = true
t_4[Enum.HumanoidStateType.Freefall] = true
t_4[Enum.HumanoidStateType.Flying] = true
t_4[Enum.HumanoidStateType.Jumping] = true
t_4[Enum.HumanoidStateType.PlatformStanding], t_1.AIRBORNE_HUMANOID_STATES = true, t_4
t_1.DUEL_HISTORY_MAX_SIZE = 20
t_1.MAX_BACKPACK_USE_QUANTITY = 100
t_1.MAX_EQUIPPABLE_WEAPONS = 4
t_1.MAX_EQUIPPABLE_EMOTES = 8
t_1.COSMETIC_IMAGES = {
    NONE_COSMETIC = "rbxassetid://17562770037",
    RANDOM_COSMETIC = "rbxassetid://94238795177693"
}
t_1.MAX_DUEL_PAD_WINS_PER_DAY_BEFORE_BEING_BLOCKED = 25
t_1.DEFAULT_HEAD_ASSET_ID = 2432102561
t_1.LEVEL_REQUIRED_FOR_REWARDS_FROM_ARCADE_SERVERS = 100
t_1.MAX_STREAK_GAIN_FROM_DUEL_PADS = 50

function t_1.INIT() -- line: 108
    -- upvalues:
    --  [1] t_1 (copy)
    --  [2] t (copy)
    --  [3] RequestConstants (copy)

    if t_1.IS_SERVER then
        local t_5 = {}

        for _, val in pairs(t) do
            t_5[val] = t_1[val]
        end

        function RequestConstants.OnServerInvoke() -- line: 116
            -- upvalues:
            --  [1] t_5 (copy)

            return t_5
        end

        return
    end

    if t_1.IS_CLIENT then
        while true do
            local g_pcall = pcall
            local v7
            g_pcall, v7 = g_pcall(RequestConstants.InvokeServer, RequestConstants)

            if not g_pcall then
                warn("Constants failed to fetch, error:", v7)
                wait(1)
                continue
            end

            for key_1, val_1 in pairs(v7) do
                t_1[key_1] = val_1
            end

            return
        end
    else
        return
    end
end

return t_1
