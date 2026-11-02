local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StatisticsLibrary_m = require(ReplicatedStorage.Modules.StatisticsLibrary)
local CosmeticLibrary_m = require(ReplicatedStorage.Modules.CosmeticLibrary)
local DuelLibrary_m = require(ReplicatedStorage.Modules.DuelLibrary)
local ItemLibrary_m = require(ReplicatedStorage.Modules.ItemLibrary)
local EnumLibrary_m = require(ReplicatedStorage.Modules.EnumLibrary)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local t = {
    "ReplicationAdded",
    "ReplicationChanged",
    "ReplicationRemoved",
    "ReplicationRequest",
    "Ammo",
    "BulkDataValueChanged",
    "DataValueChanged",
    "ItemChanged",
    "EntityChanged",
    "ItemRemoved",
    "ItemAdded",
    "EntityAdded",
    "SafeUpdateLocalEquippedItemID",
    "UserID",
    "ShootEffect",
    "ProjectileEffect",
    "ServerInputWorkDone",
    "Died",
    "BurnEffect",
    "ExplosionEffect",
    "MolotovExplode",
    "HealEffect",
    "HurtEffect",
    "Skin",
    "DeflectHit",
    "PlayAnimation",
    "StartShooting",
    "StartReloading",
    "StartAiming",
    "StartInspecting",
    "EliminationFeed",
    "StartSprinting",
    "FinishShooting",
    "FinishReloading",
    "FinishAiming",
    "FinishInspecting",
    "FinishSprinting",
    "HitEffect",
    "SwitchItemsCount",
    "SwitchItemsMax",
    "EliminationEffect",
    "ViewModelChanged",
    "DuelerAdded",
    "DuelerChanged",
    "DuelerRemoved",
    "CameraMimicRotation",
    "RoundStart",
    "RoundFinish",
    "BatchUpdateWeaponXP",
    "CameraLean",
    "IsCrouching",
    "IsSprinting",
    "IsSliding",
    "ExtinguishEffect",
    "SplatEffect",
    "IsAirborne",
    "PlayMechanicsSound",
    "Slide",
    "DoubleJump",
    "BlindedEffect",
    "BackstabEffect",
    "EliminatedEffect",
    "RoundStarting",
    "MouseKeyboard",
    "Gamepad",
    "Touch",
    "VR",
    "HardenEffect",
    "NumReloadsSoFar",
    "ThrowEffect",
    "MineExplosion",
    "MapAdded",
    "KnockbackEffect",
    "CanTrackStatistics",
    "PlaySourceName",
    "ClientFighterCharacter",
    "ClientBaseGame",
    "ClientDuel",
    "ClientDueler",
    "ClientDestructable",
    "LogID",
    "ClientEnemy",
    "ClientEntity",
    "ClientFighter",
    "ClientPlayerData",
    "CameraRotation",
    "DecodedNetworkID",
    "IsSpectating",
    "LocalEquippedItemID",
    "IsInDuel",
    "FOVOffset",
    "ItemIndex",
    "Controls",
    "NetworkID",
    "EnvironmentID",
    "TeamID",
    "TeamkillEnabled",
    "ItemsLocked",
    "CanPickWeapons",
    "LastPickedWeapons",
    "EquippedItemID",
    "OctoCount",
    "InfiniteAmmo",
    "Name",
    "Scale",
    "ShowWhileAiming",
    "ClearQuickAttackState",
    "Level",
    "QuickAttackQueued",
    "SkipEquipAnimation",
    "Charm",
    "AmmoReserve",
    "IdleAnimation",
    "ThawFreezeEffect",
    "RunAnimation",
    "Damage",
    "DamageTaken",
    "Status",
    "ClientCustomEntity",
    "StatisticsBatchUpdate",
    "ShowWhileInspecting",
    "Timer",
    "Wave",
    "EnemyCount",
    "EnemiesByID",
    "MapName",
    "MapFolder",
    "VoteOptions",
    "Scores",
    "NumTeams",
    "LastVote",
    "AssistEffect",
    "PingEffect",
    "Eliminations",
    "Deaths",
    "Assists",
    "MatchPoint",
    "SuddenDeath",
    "ClientHumanoidEntity",
    "NumSpectators",
    "CanSwitchItems",
    "RoundNum",
    "IsInShootingRange",
    "RegisterDPS",
    "IsDisabled",
    "IsStatic",
    "BarsDisabled",
    "BarsSpacing",
    "BarsLength",
    "BarsThickness",
    "BarsTransparency",
    "DotDisabled",
    "DotThickness",
    "DotTransparency",
    "OutlineDisabled",
    "OutlineThickness",
    "OutlineTransparency",
    "DotColor",
    "BarsColor",
    "OutlineColor",
    "Rotation",
    "Override",
    "CompressedCrosshairAppearance",
    "OutlineType",
    "CircleDisabled",
    "CircleColor",
    "CircleSize",
    "CircleThickness",
    "CircleTransparency",
    "CircleShape",
    "WarpTo",
    "OnyxLavaSplash",
    "MapChanged",
    "CreateSound",
    "SendChat",
    "Shutdown",
    "BarsTopDisabled",
    "BarsBottomDisabled",
    "BarsRightDisabled",
    "BarsLeftDisabled",
    "WeaponDataChanged",
    "ConnectionLevel",
    "NukeEffect",
    "SpectatingDuelObjectID",
    "ClientReplicatedClassType",
    "Data",
    "ViewModel",
    "Player",
    "Model",
    "RootPart",
    "Humanoid",
    "Duelers",
    "Map",
    "ObjectID",
    "Items",
    "Entity",
    "Wrap",
    "EntityRemoved",
    "FinalResults",
    "LootboxEffect",
    "DEBUG_OCTO_MODE",
    "ChallengeRequest",
    "ClientDPSDummy",
    "DotShape",
    "BarsShape",
    "DamageNumberEffect",
    "FreezeEffect",
    "ScoresBehavior",
    "DuelerID",
    "IsFrozen",
    "IsMatchmaking",
    "PartyRequest",
    "MatchmadeCountdown",
    "FinisherEffect",
    "IsInvincible",
    "ArcadeMode",
    "CancelUse",
    "RematchAvailable",
    "RematchCount",
    "RematchGoal",
    "ConsecutiveRematches",
    "QueueName",
    "SetBoost",
    "NumSatchels",
    "SatchelAttached",
    "AbsorbedHit",
    "TransformProjectile",
    "MiniExplosionEffect",
    "ExtinguishEffect",
    "Countdown",
    "Mode",
    "BlindEffect",
    "WeaponPool",
    "WeaponPoolFilterType",
    "CanUseLockedWeapons",
    "IsCurrentArcadeDuel",
    "RematchSuccess",
    "IsGrabbingSnowball",
    "ThrowSnowball",
    "StopHolding",
    "StopUsing",
    "WasSelfQueued",
    "PauseTimer",
    "DuelResultsRunnerUpsEnabled",
    "MaxMapBansPerTeam",
    "VoteBansRemaining",
    "NoRandomMap",
    "MaxMapOptions",
    "MaxWeaponBansPerTeam",
    "VoteOptionsType",
    "AutoShootRestriction",
    "AimAssistRestriction",
    "ThirdPersonOverride",
    "ChosenMapEffect",
    "SetCooldown",
    "SummaryDetails",
    "ExternalDuelTimer",
    "ExternalDuelWinningScore",
    "ExternalKeepDuelGoing",
    "ExternalDrawsAreLosses",
    "PlayPreloadedAnimation",
    "TracerEffect",
    "FlashbangEffect",
    "Interrupted",
    "CheaterMode",
    "IsAprilFools",
    "AprilFoolsCharkAttack",
    "BladeCriticalHit",
    "WeaponClassRestrictionDisabled",
    "KeepDuelAliveTimeout",
    "DontDisableRematchingOnLeave",
    "VoteSelectionMode",
    "ScoreNeededToWin",
    "ClientQueuePad",
    "PlayersWaiting",
    "IsLocked",
    "IsStarting",
    "InfinitePlayersPerTeam",
    "PlayersPerTeam",
    "NumTeams",
    "CanSelfQueue",
    "RefillAmmoEffect",
    "CollectEffect",
    "RespawnDelay",
    "JustSwitchedTeam",
    "SetupDrop",
    "OverrideQuickAttacks",
    "RespawnNowAnimation",
    "UnlimitedTime",
    "ExternalCanPlayAllMaps",
    "BaseHealth",
    "Gravity",
    "DisableSprinting",
    "DisableSliding",
    "DashOnAim",
    "StaggeredSpawns",
    "StaggeredSpawnsOrder",
    "ExternalEndDuelNow",
    "ChickenGamesRedLight",
    "ChickenGamesGreenLight",
    "ChickenGamesElimination",
    "ChickenGamesStop",
    "EventEndTime",
    "SpecialChallengesEnabled",
    "RollResult",
    "IsHeadHoncho",
    "InvincibilityDurationOnSpawn",
    "ExternalDisableTimerAliveCheck",
    "IsTranslucent",
    "ClaimCheckpoint",
    "ObbyStartPosition",
    "ObbyFinishPosition",
    "TimerStopwatchStarted",
    "TimerStopwatchFinished",
    "FreeToUseStandardWeapons",
    "FreeToUsePrimeWeapons",
    "EmotePlayed",
    "EmoteStopped",
    "ExternalRematchProperties",
    "IsGunGame",
    "DisableAnticheatPositionVerificationLoop",
    "BlipEffect",
    "Warp",
    "MatchPointVisualDisabled",
    "InfiniteAmmoReserve",
    "ClientHelmetZombie",
    "DinkEffect",
    "DropFlagEffect",
    "ClientFlagZombie",
    "ZombieExplosionEffect",
    "ClientExplosiveZombie",
    "HideMostDuelInterfaceElements",
    "DisableDoubleJumping",
    "SprintingSpeedBoost",
    "SlidingSpeedMax",
    "EmpowerOtherEntityEffect",
    "ExternalMaxEquippableWeapons",
    "DuelSeed",
    "ChickenTrojanEffect",
    "GiantChombieCutscene",
    "StopCutsceneNow",
    "ExternalIsHidden",
    "BackToNormal",
    "ClientGiantChombie",
    "SlamEffect",
    "HunterLeapEffect",
    "ClientHunterZombie",
    "CameraFlashlightEnabled",
    "ZombieSpawn",
    "JoinCooldown",
    "SeasonEndTime",
    "SettingChanged",
    "HitmarkerDisabled",
    "HitmarkerColor",
    "HitmarkerColorCrit",
    "ResetReloadState",
    "ReplicatedExternalGameplayData",
    "SlamAttack",
    "FreeToUseContrabandWeapons",
    "CancelSlam",
    "ScopedRedDotDisabled",
    "HitmarkerTransparencyCrit",
    "HitmarkerScale",
    "HitmarkerRotation",
    "HitmarkerTransparency",
    "SpectateThisPlayer",
    "MapPool",
    "OriginalQueueName",
    "ExternalMapPoolPlaySourceName",
    "ClientSpleefTile",
    "SpleefTileShake",
    "ImmuneDamageEffect",
    "ClientRubble",
    "DisableOOB",
    "ExternalDisableOOB",
    "AddReceipt",
    "GrapplerPull",
    "ClientSatchelEntity",
    "ScopedDisabled",
    "ScopedBarsDisabled",
    "ScopedRedDotColor",
    "Throw",
    "ThrowFinal",
    "GrapplerMiss",
    "GrapplerTrackPart",
    "GrapplerCooldown",
    "CancelKnockbackEffect",
    "PaintballSplatter",
    "FreeWeaponTrials",
    "QuickAttackSystemOnReEquip",
    "SlowEffect",
    "Seed",
    "MapPoolGamemode",
    "MapPoolSpecific",
    "ExternalMapPoolSpecificMap",
    "ClientChargerZombie",
    "ChargerZombieChargeStart",
    "ChargerZombieChargeImpact",
    "ClientShockerZombie",
    "ShockerZombieZap",
    "ZombieReanimation",
    "ClientReanimatingZombie",
    "ChombieEggPhase",
    "ClientChombie",
    "StoredMonsterDieOnPresence",
    "ClientStoredMonster",
    "GargoyleTowerPlayCutsceneFloor17Intro",
    "GargoyleTowerPlayCutsceneFloor17BossReveal",
    "GargoyleTowerPlayCutsceneFloor17Falling",
    "AcidExplosion",
    "ClientGiantAcidicGargoyle",
    "AcidSlam",
    "FutileIntro",
    "ClientGiantGargoyle",
    "GargoyleTowerPlayCutsceneFloor10MinibossReveal",
    "FlightIntro",
    "ClawAttack",
    "GargoyleTowerPlayCutsceneFloor10MinibossDeath"
}
local t_1 = {
    "DuelerAdded",
    "EntityAdded",
    "MapAdded",
    "ItemRemoved",
    "DuelerRemoved",
    "DataValueChanged",
    "SafeUpdateLocalEquippedItemID",
    "Died"
}

local _ = function() --[[ add_dump ]] -- line: 87
    -- upvalues:
    --  [1] t (copy)
    --  [2] EnumLibrary_m (copy)

    for _, val in pairs(t) do
        EnumLibrary_m:AddEnum(val)
    end
end

local function add_viewmodels() -- line: 93
    -- upvalues:
    --  [1] ItemLibrary_m (copy)
    --  [2] EnumLibrary_m (copy)
    --  [3] Utility_m (copy)

    for _, val_1 in pairs(ItemLibrary_m.ViewModelOrder) do
        EnumLibrary_m:AddEnum(val_1)
    end

    for _, val_2 in pairs(ItemLibrary_m.ViewModels) do
        local t_2 = {}

        for key_3, _ in pairs(val_2.Animations) do
            table.insert(t_2, key_3)
        end

        table.sort(t_2, function(arg1, arg2) -- line: 108
            -- upvalues:
            --  [1] Utility_m (ref)

            return Utility_m:StringLessThan(arg1, arg2)
        end)

        for _, val_4 in pairs(t_2) do
            EnumLibrary_m:AddEnum(val_4)
            EnumLibrary_m:AddEnum(val_2.Animations[val_4])
        end
    end
end

local _ = function() --[[ add_statistics ]] -- line: 120
    -- upvalues:
    --  [1] StatisticsLibrary_m (copy)
    --  [2] EnumLibrary_m (copy)

    for _, val_5 in pairs(StatisticsLibrary_m.Order) do
        EnumLibrary_m:AddEnum(val_5)
    end
end

local function add_cosmetics() -- line: 127
    -- upvalues:
    --  [1] CosmeticLibrary_m (copy)
    --  [2] Utility_m (copy)
    --  [3] EnumLibrary_m (copy)

    local t_3 = {}

    for key_6, val_6 in pairs(CosmeticLibrary_m.Cosmetics) do
        if val_6.Type == "Finisher" then
            table.insert(t_3, key_6)
        end
    end

    table.sort(t_3, function(arg3, arg4) -- line: 136
        -- upvalues:
        --  [1] Utility_m (ref)

        return Utility_m:StringLessThan(arg3, arg4)
    end)

    for _, val_7 in pairs(t_3) do
        EnumLibrary_m:AddEnum(val_7)
    end
end

local _ = function() --[[ add_maps ]] -- line: 146
    -- upvalues:
    --  [1] DuelLibrary_m (copy)
    --  [2] EnumLibrary_m (copy)

    for _, val_8 in pairs(DuelLibrary_m.HiddenMapOrder) do
        EnumLibrary_m:AddEnum(val_8)
    end
end

local function finish() -- line: 152
    -- upvalues:
    --  [1] t_1 (copy)
    --  [2] EnumLibrary_m (copy)

    for _, val_9 in pairs(t_1) do
        EnumLibrary_m.AlwaysReplicateToEveryone[val_9] = true
        EnumLibrary_m.AlwaysReplicateToEveryone[EnumLibrary_m:ToEnum(val_9)] = true
    end

    EnumLibrary_m:EnumBuilderCompleted()
end

for _, val_10 in pairs(t) do
    EnumLibrary_m:AddEnum(val_10)
end

add_viewmodels()

for _, val_11 in pairs(StatisticsLibrary_m.Order) do
    EnumLibrary_m:AddEnum(val_11)
end

add_cosmetics()

for _, val_12 in pairs(DuelLibrary_m.HiddenMapOrder) do
    EnumLibrary_m:AddEnum(val_12)
end

finish()

return {}
