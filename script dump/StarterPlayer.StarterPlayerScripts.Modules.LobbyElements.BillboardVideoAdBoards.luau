local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local AdService = game:GetService("AdService")
local Players = game:GetService("Players")
local MonetizationLibrary_m = require(ReplicatedStorage.Modules.MonetizationLibrary)
local CosmeticLibrary_m = require(ReplicatedStorage.Modules.CosmeticLibrary)
local EventLibrary_m = require(ReplicatedStorage.Modules.EventLibrary)
local MonetizationController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.MonetizationController
)
local ComplianceController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.ComplianceController
)
local PlayerDataController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.PlayerDataController
)
local FighterController_m = require(Players.LocalPlayer.PlayerScripts.Controllers.FighterController)
local MatchmakingCountdown_m = require(
    Players.LocalPlayer.PlayerScripts.Modules.UserInterface.MatchmakingCountdown
)
local Pages_m = require(Players.LocalPlayer.PlayerScripts.Modules.UserInterface.Pages)
local ButtonEffect_m = require(Players.LocalPlayer.PlayerScripts.Modules.ButtonEffect)
local LobbyElement_m = require(Players.LocalPlayer.PlayerScripts.Modules.LobbyElement)
local RewardSlot_m = require(Players.LocalPlayer.PlayerScripts.Modules.RewardSlot)
local LobbyVisuals = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("LobbyVisuals")
local t = setmetatable({}, LobbyElement_m)
t.__index = t

function t._new(...) -- line: 24
    -- upvalues:
    --  [1] LobbyElement_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(LobbyElement_m.new(...), t)
    t_1._spin_these = {}
    t_1:_Init()

    return t_1
end

function t.Update(arg1, arg2) -- line: 38
    -- upvalues:
    --  [1] Players (copy)

    local t_2 = {}

    for key, _ in pairs(arg1._spin_these) do
        if not key:IsDescendantOf(workspace) and not key:IsDescendantOf(
            Players.LocalPlayer.PlayerGui
        ) then
            t_2[key] = true
        else
            key.Rotation += 15 * arg2
        end
    end

    for key_1, _ in pairs(t_2) do
        arg1._spin_these[key_1] = nil
    end
end

function t._BoardAdded(arg3, arg4) -- line: 59
    -- upvalues:
    --  [1] LobbyVisuals (copy)
    --  [2] EventLibrary_m (copy)
    --  [3] PlayerDataController_m (copy)
    --  [4] MonetizationLibrary_m (copy)
    --  [5] FighterController_m (copy)
    --  [6] MatchmakingCountdown_m (copy)
    --  [7] AdService (copy)
    --  [8] RewardSlot_m (copy)
    --  [9] Pages_m (copy)
    --  [10] ReplicatedStorage (copy)
    --  [11] ButtonEffect_m (copy)
    --  [12] CosmeticLibrary_m (copy)
    --  [13] ComplianceController_m (copy)
    --  [14] MonetizationController_m (copy)
    --  [15] Players (copy)

    local v2 = (LobbyVisuals:FindFirstChild(EventLibrary_m.LOBBY_VISUALS_PROFILE) and LobbyVisuals[EventLibrary_m.LOBBY_VISUALS_PROFILE]:FindFirstChild(
        "BillboardVideoAdsGui"
    ) or LobbyVisuals.Default.BillboardVideoAdsGui):Clone()
    arg3._spin_these[v2.MainFrame.Background.CanvasGroup.Keys.ImageLabel] = true
    arg3._spin_these[v2.MainFrame.Background.CanvasGroup.Wraps.ImageLabel] = true
    local v3 = 0
    local v4 = nil
    local v5 = false

    local function update_visuals() -- line: 71
        -- upvalues:
        --  [1] PlayerDataController_m (ref)
        --  [2] MonetizationLibrary_m (ref)
        --  [3] v2 (copy)

        local v6 = PlayerDataController_m:Get("BillboardVideoAdProgress")
        local v10 = MonetizationLibrary_m:GetNumVideoAdsForBillboardReward(
            PlayerDataController_m:Get("BillboardVideoAdClaimedToday")
        )
        v2.MainFrame.Play.Title.Text = string.format("%s<font size=\"8\"> /%s</font>", v6, v10)
    end

    PlayerDataController_m:GetDataChangedSignal("BillboardVideoAdClaimedToday"):Connect(
        update_visuals
    )
    PlayerDataController_m:GetDataChangedSignal("BillboardVideoAdProgress"):Connect(update_visuals)
    local v11 = PlayerDataController_m:Get("BillboardVideoAdProgress")
    local v15 = MonetizationLibrary_m:GetNumVideoAdsForBillboardReward(
        PlayerDataController_m:Get("BillboardVideoAdClaimedToday")
    )
    v2.MainFrame.Play.Title.Text = string.format("%s<font size=\"8\"> /%s</font>", v11, v15)

    local function can_fetch_ads() -- line: 82
        -- upvalues:
        --  [1] FighterController_m (ref)
        --  [2] MatchmakingCountdown_m (ref)
        --  [3] PlayerDataController_m (ref)
        --  [4] MonetizationLibrary_m (ref)

        local v16 = FighterController_m.LocalFighter

        if v16 then
            v16 = not FighterController_m.LocalFighter:Get("IsInDuel")

            if v16 then
                v16 = not FighterController_m.LocalFighter:Get("IsInShootingRange")

                if v16 then
                    v16 = not MatchmakingCountdown_m:IsVisible()

                    if v16 then
                        v16 = PlayerDataController_m:Get("BillboardVideoAdClaimedToday") < MonetizationLibrary_m.MAX_BILLBOARD_VIDEO_ADS_PER_DAY and true
                    end
                end
            end
        end

        return v16
    end

    local function update() -- line: 90
        -- upvalues:
        --  [1] v3 (ref)
        --  [2] v4 (ref)
        --  [3] v2 (copy)
        --  [4] can_fetch_ads (copy)
        --  [5] v5 (ref)
        --  [6] AdService (ref)
        --  [7] PlayerDataController_m (ref)
        --  [8] RewardSlot_m (ref)
        --  [9] MonetizationLibrary_m (ref)

        v3 += 1
        local v18 = v3

        if v4 then
            v4:Destroy()
            v4 = nil
        end

        v2.MainFrame.Visible = false
        v2.KeyBundle.Visible = true

        if not can_fetch_ads() then
            return
        end

        if not v5 then
            local Success, Result = pcall(
                AdService.GetAdAvailabilityNowAsync,
                AdService,
                Enum.AdFormat.RewardedVideo
            )
            wait(0.5)

            if v18 ~= v3 then
                return
            end

            local v19 = Success and Result.AdAvailabilityResult == Enum.AdAvailabilityResult.IsAvailable
            v5 = v19
        end

        local v20 = if PlayerDataController_m:Get("BillboardVideoAdClaimedToday") ~= 0 then false else true
        v2.MainFrame.Visible = v5
        v2.KeyBundle.Visible = not v5
        v2.MainFrame.Background.CanvasGroup.Keys.Visible = v20
        v2.MainFrame.Background.CanvasGroup.Wraps.Visible = not v20

        if v5 then
            local New = RewardSlot_m.new
            local v21 = if not v20 then MonetizationLibrary_m.BILLBOARD_WRAPS_REWARD_DATA else MonetizationLibrary_m.BILLBOARD_KEYS_REWARD_DATA
            v4 = New(v21)
            v4:ZoomOutViewportFrame()
            v4:UseHighResolutionImage()
            v4:HideBackground()
            v4:HideWeaponVisual()
            v4:SetInteractable(false)
            v4:SetParent(v2.MainFrame.Reward)
        end
    end

    MatchmakingCountdown_m.VisibilityChanged:Connect(update)

    local function hook_local_fighter() -- line: 143
        -- upvalues:
        --  [1] FighterController_m (ref)
        --  [2] update (copy)

        local v22 = FighterController_m:WaitForLocalFighter()
        v22:GetDataChangedSignal("IsInDuel"):Connect(update)
        v22:GetDataChangedSignal("IsInShootingRange"):Connect(update)
        update()
    end

    task.spawn(hook_local_fighter)
    PlayerDataController_m:GetDataChangedSignal("BillboardVideoAdClaimedToday"):Connect(function() -- line: 153
        -- upvalues:
        --  [1] update (copy)
        --  [2] v4 (ref)

        wait(1)
        update()
        wait(1)

        if not v4 then
            update()
        end
    end)
    task.spawn(function() -- line: 165
        -- upvalues:
        --  [1] update (copy)

        update()
        wait(2)

        while true do
            update()
            wait(15)
        end
    end)
    v2.MainFrame.Button.MouseButton1Click:Connect(function() -- line: 176
        -- upvalues:
        --  [1] Pages_m (ref)
        --  [2] ReplicatedStorage (ref)
        --  [3] AdService (ref)
        --  [4] v5 (ref)
        --  [5] update (copy)

        if Pages_m.PageSystem.CurrentPage then
            return
        end

        task.spawn(function() -- line: 181
            -- upvalues:
            --  [1] ReplicatedStorage (ref)
            --  [2] AdService (ref)

            if not ReplicatedStorage.Remotes.Misc.PlayVideoAdBillboard:InvokeServer() then
                pcall(AdService.GetAdAvailabilityNowAsync, AdService, Enum.AdFormat.RewardedVideo)
                ReplicatedStorage.Remotes.Misc.PlayVideoAdBillboard:InvokeServer()
            end
        end)
        v5 = false
        task.delay(2, function() -- line: 192
            -- upvalues:
            --  [1] v5 (ref)
            --  [2] update (ref)

            v5 = false
            update()
        end)
    end)
    ButtonEffect_m:Add(v2.MainFrame.Button, true)
    local Keybundle2 = MonetizationLibrary_m.Bundles.keybundle_2
    local KeyBundle = v2.KeyBundle
    local Title_2 = KeyBundle.Title
    Title_2.Text = Keybundle2.DisplayName
    local v24 = pairs

    for key_2, val_2 in v24(Keybundle2.Rewards) do
        local v25 = CosmeticLibrary_m.Rewards[val_2.Name]

        if
            not v25
            or v25.Type ~= "Lootbox"
            or not ComplianceController_m:ArePaidRandomItemsRestricted()
        then
            local v26 = RewardSlot_m.new(val_2)
            v26.Frame.LayoutOrder = key_2
            v26:SetParent(KeyBundle.Rewards)
            v26:OnClick(function() -- line: 219
                -- upvalues:
                --  [1] Pages_m (ref)

                if Pages_m.PageSystem.CurrentPage then
                    return
                end

                Pages_m.PageSystem:OpenPage("Shop")
                Pages_m.PageSystem:WaitForPage("Shop"):SetPage("Currency")
                Pages_m.PageSystem:WaitForPage("Shop"):InspectBundle("keybundle_2")
            end)
        end
    end

    KeyBundle.Button.MouseButton1Click:Connect(function() -- line: 230
        -- upvalues:
        --  [1] Pages_m (ref)
        --  [2] MonetizationController_m (ref)
        --  [3] Keybundle2 (copy)

        if Pages_m.PageSystem.CurrentPage then
            return
        end

        MonetizationController_m:PromptProductPurchase(Keybundle2.ProductID)
    end)
    MonetizationController_m:SetRobuxText(
        KeyBundle.Button.Title,
        Keybundle2.ProductID,
        Enum.InfoType.Product
    )
    ButtonEffect_m:Add(KeyBundle.Button)
    v2.Adornee = arg4
    local PlayerGui = Players.LocalPlayer.PlayerGui
    v2.Parent = PlayerGui
end

function t._Init(arg5) -- line: 246
    -- upvalues:
    --  [1] CollectionService (copy)

    CollectionService:GetInstanceAddedSignal("LobbyBillboardVideoAds"):Connect(function(arg6) -- line: 247
        -- upvalues:
        --  [1] arg5 (copy)

        arg5:_BoardAdded(arg6)
    end)

    for _, val_3 in pairs(CollectionService:GetTagged("LobbyBillboardVideoAds")) do
        task.defer(arg5._BoardAdded, arg5, val_3)
    end
end

return t._new()
