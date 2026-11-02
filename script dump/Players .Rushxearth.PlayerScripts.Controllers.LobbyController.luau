local ExperienceNotificationService = game:GetService("ExperienceNotificationService")
local AvatarEditorService = game:GetService("AvatarEditorService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local CONSTANTS_m = require(ReplicatedStorage.Modules.CONSTANTS)
local MonetizationLibrary_m = require(ReplicatedStorage.Modules.MonetizationLibrary)
local ServerOsTime_m = require(ReplicatedStorage.Modules.ServerOsTime)
local TestLibrary_m = require(ReplicatedStorage.Modules.TestLibrary)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local ShootingRangeController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.ShootingRangeController
)
local PlayerDataController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.PlayerDataController
)
local FighterController_m = require(Players.LocalPlayer.PlayerScripts.Controllers.FighterController)
local DuelController_m = require(Players.LocalPlayer.PlayerScripts.Controllers.DuelController)
local StudioSkipOnboarding = TestLibrary_m:GetTestAttribute("StudioSkipOnboarding")
local t = {
    "StarterBundleBoards",
    "LeaderboardDisplays",
    "EliminationsDisplays",
    "DuelsDisplays",
    "DuelsGarageDoor",
    "LikeBoards",
    "LooseWeaponDisplays",
    "Miscellaneous",
    "DuelsSign",
    "RotatingBundleDisplay",
    "WeaponReleaseSchedule",
    "ToyTrainPaths",
    "Teleporters",
    "DailyShopSkinHolograms",
    "LobbyPortals",
    "LobbyAnimations",
    "UpdateCountdowns",
    "TopPlayerRewards",
    "ProximityPageOpeners",
    "BillboardVideoAdBoards",
    "OnlyAppearWhens"
}
local t_1 = {}
local LobbyElements = Players.LocalPlayer.PlayerScripts.Modules.LobbyElements
t_1.__index = t_1

function t_1._new() -- line: 33
    -- upvalues:
    --  [1] t_1 (copy)

    local t_2 = setmetatable({}, t_1)
    t_2.LocalFighter = nil
    t_2.Elements = {}
    t_2._renderstep_connection = nil
    t_2._textures_deleted = false
    t_2._attempted_to_favorite = false
    t_2:_Init()

    return t_2
end

function t_1.ToDuels(_) -- line: 52
    -- upvalues:
    --  [1] FighterController_m (copy)
    --  [2] ShootingRangeController_m (copy)
    --  [3] CollectionService (copy)

    if
        FighterController_m.LocalFighter
        and FighterController_m.LocalFighter:Get("IsInShootingRange")
    then
        ShootingRangeController_m:Leave(true)

        return
    end

    if
        FighterController_m.LocalFighter
        and not FighterController_m.LocalFighter:Get("IsInDuel")
        and FighterController_m.LocalFighter:IsAlive()
    then
        FighterController_m.LocalFighter.Entity.Model:PivotTo(
            CollectionService:GetTagged("LobbyDuels")[1].CFrame
        )
    end
end

function t_1._RemoveSuperStarterBundleHolograms(_) -- line: 64
    -- upvalues:
    --  [1] ServerOsTime_m (copy)
    --  [2] PlayerDataController_m (copy)
    --  [3] MonetizationLibrary_m (copy)
    --  [4] CollectionService (copy)

    if if ServerOsTime_m:Get() < PlayerDataController_m:Get("SuperStarterBundleStartTime") + MonetizationLibrary_m.SUPER_STARTER_BUNDLE_OFFER_DURATION then not PlayerDataController_m:Get(
        "SuperStarterBundlePurchased"
    ) else false then
        return
    end

    for _, val in pairs(CollectionService:GetTagged("LobbySuperStarterBundleHologram")) do
        task.defer(val.Destroy, val)
    end
end

function t_1._RemoveGiftHolograms(_) -- line: 77
    -- upvalues:
    --  [1] PlayerDataController_m (copy)
    --  [2] CollectionService (copy)

    if not PlayerDataController_m:Get("ClaimedGroupReward") then
        return
    end

    for _, val_1 in pairs(CollectionService:GetTagged("LobbyFreeRewardsHologram")) do
        task.defer(val_1.Destroy, val_1)
    end
end

function t_1._PromptStuff(arg4) -- line: 87
    -- upvalues:
    --  [1] StudioSkipOnboarding (copy)
    --  [2] DuelController_m (copy)
    --  [3] Players (copy)
    --  [4] PlayerDataController_m (copy)
    --  [5] AvatarEditorService (copy)
    --  [6] CONSTANTS_m (copy)
    --  [7] ExperienceNotificationService (copy)
    --  [8] ReplicatedStorage (copy)

    if StudioSkipOnboarding then
        return
    end

    wait(1)

    if DuelController_m:GetDuel(Players.LocalPlayer) then
        return
    end

    local StatisticDuelsPlayed = PlayerDataController_m:GetStatistic("StatisticDuelsPlayed")
    local StatisticDuelsWon = PlayerDataController_m:GetStatistic("StatisticDuelsWon")

    if not arg4._attempted_to_favorite and (StatisticDuelsPlayed == 5 or StatisticDuelsWon == 1) then
        arg4._attempted_to_favorite = true
        AvatarEditorService:PromptSetFavorite(
            CONSTANTS_m.HUB_PLACE_ID,
            Enum.AvatarItemType.Asset,
            true
        )

        return
    end

    if
        not PlayerDataController_m:Get("PromptedNotificationPrompt")
        and (StatisticDuelsPlayed >= 8 or StatisticDuelsWon == 2)
    then
        local Success, Result = pcall(
            ExperienceNotificationService.CanPromptOptInAsync,
            ExperienceNotificationService
        )

        if not Success then
            warn("Failed to check if user can prompt notifications:", Result)

            return
        end

        if Result then
            ReplicatedStorage.Remotes.Data.PromptedNotificationPrompt:FireServer()
            ExperienceNotificationService:PromptOptIn()
        end
    end
end

function t_1._UpdateEnabled(arg5) -- line: 116
    -- upvalues:
    --  [1] RunService (copy)

    if arg5._renderstep_connection then
        arg5._renderstep_connection:Disconnect()
        arg5._renderstep_connection = nil
    end

    local v6 = arg5.LocalFighter

    if v6 then
        v6 = not arg5.LocalFighter:Get("IsInDuel")

        if v6 then
            v6 = not arg5.LocalFighter:Get("IsInShootingRange")
        end
    end

    for _, val_2 in pairs(arg5.Elements) do
        val_2:SetEnabled(v6)
    end

    if v6 then
        arg5._renderstep_connection = RunService.RenderStepped:Connect(function(deltaTime: number) -- line: 129
            -- upvalues:
            --  [1] arg5 (copy)

            for _, val_3 in pairs(arg5.Elements) do
                val_3:Update(deltaTime)
            end
        end)
    end

    if v6 then
        task.defer(arg5._PromptStuff, arg5)
    end
end

function t_1._UpdateShadows(arg7) -- line: 141
    -- upvalues:
    --  [1] Lighting (copy)
    --  [2] PlayerDataController_m (copy)
    --  [3] CollectionService (copy)
    --  [4] Utility_m (copy)

    Lighting.GlobalShadows = not PlayerDataController_m:GetSetting("Shadows Disabled")

    if arg7._shadows_deleted or not PlayerDataController_m:GetSetting("Shadows Disabled") then
        return
    end

    arg7._shadows_deleted = true

    for _, val_4 in pairs(CollectionService:GetTagged("LobbyFolder")) do
        Utility_m:DisableShadows(val_4)
    end
end

function t_1._UpdateTextures(arg8) -- line: 155
    -- upvalues:
    --  [1] PlayerDataController_m (copy)
    --  [2] CollectionService (copy)
    --  [3] Utility_m (copy)

    if arg8._textures_deleted or not PlayerDataController_m:GetSetting("Textures Disabled") then
        return
    end

    arg8._textures_deleted = true

    for _, val_5 in pairs(CollectionService:GetTagged("LobbyFolder")) do
        Utility_m:DisableTextures(val_5)
    end
end

function t_1._Setup(arg9) -- line: 167
    -- upvalues:
    --  [1] FighterController_m (copy)
    --  [2] t (copy)
    --  [3] LobbyElements (copy)

    arg9.LocalFighter = FighterController_m:WaitForLocalFighter()
    arg9.LocalFighter:GetDataChangedSignal("IsInDuel"):Connect(function() -- line: 170
        -- upvalues:
        --  [1] arg9 (copy)

        arg9:_UpdateEnabled()
    end)
    arg9.LocalFighter:GetDataChangedSignal("IsInShootingRange"):Connect(function() -- line: 174
        -- upvalues:
        --  [1] arg9 (copy)

        arg9:_UpdateEnabled()
    end)

    for _, val_6 in pairs(t) do
        task.defer(function() -- line: 179
            -- upvalues:
            --  [1] arg9 (copy)
            --  [2] LobbyElements (ref)
            --  [3] val_6 (copy)

            table.insert(arg9.Elements, require(LobbyElements[val_6]))
        end)
    end

    task.defer(arg9._UpdateEnabled, arg9)
end

function t_1._Init(arg10) -- line: 187
    -- upvalues:
    --  [1] PlayerDataController_m (copy)
    --  [2] CollectionService (copy)
    --  [3] DuelController_m (copy)

    PlayerDataController_m:GetDataChangedSignal("StatisticDuelsPlayed"):Connect(function() -- line: 188
        -- upvalues:
        --  [1] arg10 (copy)

        arg10:_PromptStuff()
    end)
    PlayerDataController_m:GetSettingChangedSignal("Textures Disabled"):Connect(function() -- line: 192
        -- upvalues:
        --  [1] arg10 (copy)

        arg10:_UpdateTextures()
    end)
    PlayerDataController_m:GetSettingChangedSignal("Shadows Disabled"):Connect(function() -- line: 196
        -- upvalues:
        --  [1] arg10 (copy)

        arg10:_UpdateShadows()
    end)
    PlayerDataController_m:GetDataChangedSignal("SuperStarterBundlePurchased"):Connect(function() -- line: 200
        -- upvalues:
        --  [1] arg10 (copy)

        arg10:_RemoveSuperStarterBundleHolograms()
    end)
    PlayerDataController_m:GetDataChangedSignal("ClaimedGroupReward"):Connect(function() -- line: 204
        -- upvalues:
        --  [1] arg10 (copy)

        arg10:_RemoveGiftHolograms()
    end)
    CollectionService:GetInstanceAddedSignal("LobbyFreeRewardsHologram"):Connect(function() -- line: 208
        -- upvalues:
        --  [1] arg10 (copy)

        arg10:_RemoveGiftHolograms()
    end)
    DuelController_m.LocalPlayerLeftDuel:Connect(function() -- line: 212
        -- upvalues:
        --  [1] arg10 (copy)

        arg10:_PromptStuff()
    end)
    arg10:_UpdateTextures()
    task.spawn(arg10._Setup, arg10)
    task.defer(arg10._UpdateShadows, arg10)
    task.defer(arg10._RemoveGiftHolograms, arg10)
    task.defer(arg10._RemoveSuperStarterBundleHolograms, arg10)
end

return t_1._new()
