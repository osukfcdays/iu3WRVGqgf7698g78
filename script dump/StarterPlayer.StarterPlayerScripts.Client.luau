local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local _ = require(ReplicatedStorage.Modules.EnumBuilder)
local _ = require(ReplicatedStorage.Modules.Utility)
local t = {
    "PlayerDataController",
    "ComplianceController",
    "FunctionsController",
    "UserInterfaceController",
    "MonetizationController",
    "EnemyController",
    "CameraController",
    "MechanicsController",
    "FighterController",
    "SpectateController",
    "TightropeController",
    "EntityController",
    "DuelController",
    "GameComponentsController",
    "ControlsController",
    "LeaderboardController",
    "LobbyController",
    "QueuePadController",
    "LightingController",
    "ShootingRangeController",
    "CoreGuiController",
    "MusicController",
    "MobileController",
    "ShopController",
    "ProximityPromptController",
    "PlayerInteractionController",
    "DebugController",
    "MatchmakingController",
    "ChattingController",
    "EventController",
    "PrivateServerController",
    "TestingController",
    "ShadyChickenController",
    "WrapController",
    "ScavengerHuntController",
    "SocialController",
    "FFlagController",
    "AudioController",
    "BirthdayController",
    "ArcadeController",
    "EmoteController",
    "SeasonController",
    "PartyController",
    "MiscellaneousController"
}
local t_1 = {}
t_1.__index = t_1

function t_1._new() -- line: 29
    -- upvalues:
    --  [1] t_1 (copy)

    local t_2 = setmetatable({}, t_1)
    t_2:_Init()

    return t_2
end

function t_1.LoadModule(arg1, arg2) -- line: 42
    -- upvalues:
    --  [1] Players (copy)

    local _ = tick()
    arg1[arg2] = require(Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild(arg2))
end

function t_1._LoadModules(arg3) -- line: 54
    -- upvalues:
    --  [1] t (copy)

    for _, val in pairs(t) do
        arg3:LoadModule(val)
    end
end

function t_1._Init(arg4) -- line: 60
    arg4:_LoadModules()
end

return t_1._new()
