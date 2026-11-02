local ReplicatedStorage = game:GetService("ReplicatedStorage")
local AdService = game:GetService("AdService")
local Players = game:GetService("Players")
local CONSTANTS_m = require(ReplicatedStorage.Modules.CONSTANTS)
local ScavengerHuntLibrary_m = require(ReplicatedStorage.Modules.ScavengerHuntLibrary)
local MonetizationLibrary_m = require(ReplicatedStorage.Modules.MonetizationLibrary)
local CurrencyLibrary_m = require(ReplicatedStorage.Modules.CurrencyLibrary)
local SeasonLibrary_m = require(ReplicatedStorage.Modules.SeasonLibrary)
local ServerOsTime_m = require(ReplicatedStorage.Modules.ServerOsTime)
local ShopLibrary_m = require(ReplicatedStorage.Modules.ShopLibrary)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local PlayerDataController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.PlayerDataController
)
local ButtonEffect_m = require(Players.LocalPlayer.PlayerScripts.Modules.ButtonEffect)
local Pages_m = require(Players.LocalPlayer.PlayerScripts.Modules.UserInterface.Pages)
local t = {}
t.__index = t

function t.new(arg1) -- line: 22
    -- upvalues:
    --  [1] t (copy)

    local t_1 = setmetatable({}, t)
    t_1.Right = arg1
    t_1.Frame = t_1.Right.Container:WaitForChild("LockedActions")
    t_1.Container = t_1.Frame:WaitForChild("Container")
    t_1.Layout = t_1.Container:WaitForChild("Layout")
    t_1.TryWeaponFrame = t_1.Container:WaitForChild("TryWeapon")
    t_1.TryWeaponButton = t_1.TryWeaponFrame:WaitForChild("Button")
    t_1.SpecialOfferFrame = t_1.Container:WaitForChild("SpecialOffer")
    t_1.SpecialOfferDescription = t_1.SpecialOfferFrame:WaitForChild("Description")
    t_1.SpecialOfferCountdown = t_1.SpecialOfferFrame:WaitForChild("Countdown")
    t_1.SpecialOfferButton = t_1.SpecialOfferFrame:WaitForChild("Button")
    t_1.SpecialOfferButtonLockedFrame = t_1.SpecialOfferButton:WaitForChild("Locked")
    t_1.SpecialOfferButtonUnlockedFrame = t_1.SpecialOfferButton:WaitForChild("Unlocked")
    t_1.BuyFrame = t_1.Container:WaitForChild("Buy")
    t_1.BuyDescription = t_1.BuyFrame:WaitForChild("Description")
    t_1.BuyCountdown = t_1.BuyFrame:WaitForChild("Countdown")
    t_1.BuyButton = t_1.BuyFrame:WaitForChild("Button")
    t_1.BuyButtonLockedFrame = t_1.BuyButton:WaitForChild("Locked")
    t_1.BuyButtonFreeFrame = t_1.BuyButton:WaitForChild("Free")
    t_1.BuyButtonKeysFrame = t_1.BuyButton:WaitForChild("Keys")
    t_1.BuyButtonKeysPrice = t_1.BuyButtonKeysFrame:WaitForChild("Price")
    t_1.BuyButtonKeysPriceIconOutline = t_1.BuyButtonKeysPrice:WaitForChild("Icon")
    t_1.BuyButtonKeysPriceIcon = t_1.BuyButtonKeysPriceIconOutline:WaitForChild("ImageLabel")
    t_1.ScavengerFrame = t_1.Container:WaitForChild("Scavenger")
    t_1.ScavengerTitle = t_1.ScavengerFrame:WaitForChild("Title")
    t_1.ScavengerProgress = t_1.ScavengerFrame:WaitForChild("Progress")
    t_1.ScavengerIcon = t_1.ScavengerFrame:WaitForChild("Icon")
    t_1.ScavengerButton = t_1.ScavengerFrame:WaitForChild("Button")
    t_1.FreeTrialFrame = t_1.Container:WaitForChild("FreeTrial")
    t_1.FreeTrialReadyFrame = t_1.FreeTrialFrame:WaitForChild("Ready")
    t_1.FreeTrialNotReadyFrame = t_1.FreeTrialFrame:WaitForChild("NotReady")
    t_1.FreeTrialWaitingFrame = t_1.FreeTrialNotReadyFrame:WaitForChild("Waiting")
    t_1.FreeTrialWaitingDotsFrame = t_1.FreeTrialWaitingFrame:WaitForChild("Dots")
    t_1.FreeTrialUnavailable = t_1.FreeTrialNotReadyFrame:WaitForChild("Unavailable")
    t_1.FreeTrialButton = t_1.FreeTrialNotReadyFrame:WaitForChild("Button")
    t_1.FreeTrialButtonTitle = t_1.FreeTrialButton:WaitForChild("Title")
    t_1.FreeTrialButtonIcon = t_1.FreeTrialButtonTitle:WaitForChild("Icon")
    t_1._update_information_hash = 0
    t_1:_Init()

    return t_1
end

function t.OnStateChanged(arg2) -- line: 73
    arg2:_UpdateInformation()
end

function t._InteractSpecialOffer(arg3) -- line: 81
    -- upvalues:
    --  [1] SeasonLibrary_m (copy)
    --  [2] MonetizationLibrary_m (copy)
    --  [3] Pages_m (copy)

    local v1 = arg3.Right.Interface.Equipment:GetSelectedWeapon()
    local v2, v3 = SeasonLibrary_m:GetRewardSeasonPassPosition(v1)
    local v4 = if arg3.SpecialOfferDescription.Text == "Early access!" then "standardweapons_bundle" else MonetizationLibrary_m:GetBundleContainingReward(
        v1
    )

    if v2 and v3 then
        Pages_m.PageSystem:OpenPage("BattlePass", true)
        Pages_m.PageSystem:WaitForPage("BattlePass"):Preview(v2, v3)

        return
    end

    if v4 == "contrabandseason_bundle" or v4 == "primeseason_bundle" then
        Pages_m.PageSystem:OpenPage("BattlePass", true)
        Pages_m.PageSystem:WaitForPage("BattlePass"):InspectBundle(v4)

        return
    end

    if v4 then
        Pages_m.PageSystem:OpenPage("Shop", true)
        Pages_m.PageSystem:WaitForPage("Shop"):SetPage("Bundles")
        task.delay(0.1, function() -- line: 96
            -- upvalues:
            --  [1] Pages_m (ref)
            --  [2] v4 (copy)

            Pages_m.PageSystem:WaitForPage("Shop"):InspectBundle(v4)
        end)
    end
end

function t._UpdateInformation(arg4) -- line: 102
    -- upvalues:
    --  [1] PlayerDataController_m (copy)
    --  [2] ShopLibrary_m (copy)
    --  [3] MonetizationLibrary_m (copy)
    --  [4] SeasonLibrary_m (copy)
    --  [5] CONSTANTS_m (copy)
    --  [6] ScavengerHuntLibrary_m (copy)
    --  [7] ServerOsTime_m (copy)
    --  [8] Utility_m (copy)
    --  [9] AdService (copy)

    arg4._update_information_hash += 1
    local UpdateInformationHash = arg4._update_information_hash
    local v5 = arg4.Right.Interface.Equipment:GetSelectedWeapon()
    local v6 = PlayerDataController_m:GetWeaponData(v5)
    local v7 = v5

    if v7 then
        v7 = not v6
    end

    arg4.Frame.Visible = v7

    if not v7 then
        arg4.FreeTrialWaitingDotsFrame:RemoveTag("UILoadingDots")

        return
    end

    local v10, v11, v12, _ = ShopLibrary_m:GetWeaponKeyPriceInfo(
        v5,
        PlayerDataController_m:Get("UnlockTokens"),
        PlayerDataController_m:Get("FreeWeaponUnlockCheck")
    )
    local v14 = MonetizationLibrary_m:GetBundleContainingReward(v5)
    local v15, _ = SeasonLibrary_m:GetRewardSeasonPassPosition(v5)
    local v17 = ShopLibrary_m:GetTimeUntilWeaponRelease(v5)
    v11 = not v12

    if v11 then
        v11 = v17 > 0
    end

    v7 = v11 and v17 <= CONSTANTS_m.WEAPON_REVEAL_TIME_OFFSET
    v6 = v7 and v17 <= CONSTANTS_m.WEAPON_EARLY_ACCESS_TIME_OFFSET
    local v18 = ScavengerHuntLibrary_m.InfoByWeapon[v5]
    local v20 = MonetizationLibrary_m:GetNumVideoAdsForFreeWeaponTrial(v5)
    local v21 = PlayerDataController_m:Get("FreeWeaponTrialsRemaining")[v5] or 0
    local v22 = v21 > 0 and true
    v21 = v22 or v20 and PlayerDataController_m:Get("NumFreeWeaponTrialsFromVideoAdsToday") < MonetizationLibrary_m.MAX_FREE_WEAPON_TRIALS_PER_DAY and true
    local v23 = if v14 == "superstarter_bundle" then ServerOsTime_m:GetRounded() - PlayerDataController_m:Get(
        "SuperStarterBundleStartTime"
    ) < MonetizationLibrary_m.SUPER_STARTER_BUNDLE_OFFER_DURATION and true else true
    local BuyFrame = arg4.BuyFrame
    local v25 = v6 or v10 < math.huge
    BuyFrame.Visible = v25
    arg4.BuyButtonLockedFrame.Visible = v11
    v25 = not v11
    local BuyButtonFreeFrame = arg4.BuyButtonFreeFrame
    v25 = v25 and v10 <= 0
    BuyButtonFreeFrame.Visible = v25
    v25 = not v11
    local BuyButtonKeysFrame = arg4.BuyButtonKeysFrame
    v25 = v25 and v10 > 0
    BuyButtonKeysFrame.Visible = v25
    arg4.BuyButtonKeysPrice.Text = if v11 then "" else Utility_m:PrettyNumber(v10)
    local BuyDescription = arg4.BuyDescription
    v25 = if v11 then UDim2.new(0.175, 0, 0.35, 0) else UDim2.new(0.175, 0, 0.5, 0)
    BuyDescription.Position = v25
    v25 = if v11 then "Coming soon!" else "Unlock now!"
    arg4.BuyDescription.Text = v25
    arg4.BuyCountdown.Text = if not v11 then "" else "in " .. Utility_m:TimeFormat2(v17, 2)
    v25 = not v12 and (v14 and v23 or v7 or v15)
    arg4.SpecialOfferFrame.Visible = v25
    v25 = v7 and not v6
    arg4.SpecialOfferButtonLockedFrame.Visible = v25
    arg4.SpecialOfferButtonUnlockedFrame.Visible = not v7 or v6
    local SpecialOfferDescription = arg4.SpecialOfferDescription
    local v26 = if not v7 then UDim2.new(0.175, 0, 0.5, 0) else if not v6 then UDim2.new(
        0.175,
        0,
        0.35,
        0
    ) else UDim2.new(0.175, 0, 0.5, 0)
    SpecialOfferDescription.Position = v26
    v26 = if not v7 then "Special offer!" else "Early access!"
    arg4.SpecialOfferDescription.Text = v26
    local SpecialOfferCountdown = arg4.SpecialOfferCountdown
    v26 = if not v7 or v6 then "" else "in " .. Utility_m:TimeFormat2(
        v17 - CONSTANTS_m.WEAPON_EARLY_ACCESS_TIME_OFFSET,
        2
    )
    SpecialOfferCountdown.Text = v26
    v26 = not v12
    local TryWeaponFrame = arg4.TryWeaponFrame
    v26 = v26 and not v11 and table.find(ShopLibrary_m.OwnableWeapons, v5)
    TryWeaponFrame.Visible = v26
    local ScavengerFrame = arg4.ScavengerFrame
    v26 = v18 ~= nil
    ScavengerFrame.Visible = v26
    local ScavengerTitle = arg4.ScavengerTitle
    v26 = if v18 then if v18.NumObjects ~= 1 then v18.ObjectsNamePlural else v18.ObjectsName or v18.ObjectsNamePlural else ""
    ScavengerTitle.Text = v26
    local ScavengerProgress = arg4.ScavengerProgress

    if not v18 then
        v26 = ""
    else
        v26 = string.format(
            "%s / %s",
            #(PlayerDataController_m:Get("ScavengerHunts")[v18.Name] or {}),
            v18.NumObjects
        )
    end

    ScavengerProgress.Text = v26
    local ScavengerIcon = arg4.ScavengerIcon
    v26 = if v18 then v18.ObjectsImage else ""
    ScavengerIcon.Image = v26
    arg4.FreeTrialFrame.Visible = v21
    arg4.FreeTrialReadyFrame.Visible = v22
    arg4.FreeTrialNotReadyFrame.Visible = not v22
    arg4.FreeTrialButtonTitle.Text = string.format(
        "%s <font size=\"8\">/ %s</font>",
        PlayerDataController_m:Get("FreeWeaponTrialsProgressFromVideoAds")[v5] or 0,
        v20 or -1
    )
    arg4.FreeTrialButton.Visible = false
    arg4.FreeTrialUnavailable.Visible = false
    arg4.FreeTrialWaitingFrame.Visible = true
    arg4.FreeTrialWaitingDotsFrame:AddTag("UILoadingDots")
    task.spawn(function() -- line: 164
        -- upvalues:
        --  [1] v21 (copy)
        --  [2] v22 (copy)
        --  [3] AdService (ref)
        --  [4] UpdateInformationHash (copy)
        --  [5] arg4 (copy)

        if not v21 or v22 then
            return
        end

        local Success, Result = pcall(
            AdService.GetAdAvailabilityNowAsync,
            AdService,
            Enum.AdFormat.RewardedVideo
        )
        wait(1)

        if UpdateInformationHash ~= arg4._update_information_hash then
            return
        end

        local v30 = Success and Result.AdAvailabilityResult == Enum.AdAvailabilityResult.IsAvailable
        arg4.FreeTrialButton.Visible = v30
        arg4.FreeTrialUnavailable.Visible = not v30
        arg4.FreeTrialWaitingFrame.Visible = false
        arg4.FreeTrialWaitingDotsFrame:RemoveTag("UILoadingDots")
    end)
end

function t._Update(arg5) -- line: 186
    arg5.Frame.Size = UDim2.new(1, 0, 0, arg5.Layout.AbsoluteContentSize.Y)
    arg5.BuyButtonKeysPrice.Position = UDim2.new(
        0.5,
        -arg5.BuyButtonKeysPriceIconOutline.AbsoluteSize.X / 2,
        0.5,
        0
    )
    arg5.BuyButtonKeysPriceIconOutline.Position = UDim2.new(
        0.5,
        arg5.BuyButtonKeysPrice.TextBounds.X / 2,
        0.5,
        0
    )
    arg5.FreeTrialButtonIcon.Position = UDim2.new(
        0.5,
        -arg5.FreeTrialButtonTitle.TextBounds.X / 2,
        0.5,
        0
    )
end

function t._Setup(arg6) -- line: 193
    -- upvalues:
    --  [1] CurrencyLibrary_m (copy)

    arg6.BuyButtonKeysPriceIconOutline.Image = CurrencyLibrary_m.Info.WeaponKeys.ImageFlatOutline
    arg6.BuyButtonKeysPriceIcon.Image = CurrencyLibrary_m.Info.WeaponKeys.ImageFlat
end

function t._Init(arg7) -- line: 198
    -- upvalues:
    --  [1] ReplicatedStorage (copy)
    --  [2] PlayerDataController_m (copy)
    --  [3] ButtonEffect_m (copy)

    arg7.Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() -- line: 199
        -- upvalues:
        --  [1] arg7 (copy)

        arg7:_Update()
    end)
    arg7.BuyButtonKeysPrice:GetPropertyChangedSignal("TextBounds"):Connect(function() -- line: 203
        -- upvalues:
        --  [1] arg7 (copy)

        arg7:_Update()
    end)
    arg7.BuyButtonKeysPriceIconOutline:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- line: 207
        -- upvalues:
        --  [1] arg7 (copy)

        arg7:_Update()
    end)
    arg7.BuyButton.MouseButton1Click:Connect(function() -- line: 211
        -- upvalues:
        --  [1] arg7 (copy)

        arg7.Right.Interface.Equipment:UnlockWeapon()
    end)
    arg7.TryWeaponButton.MouseButton1Click:Connect(function() -- line: 215
        -- upvalues:
        --  [1] arg7 (copy)

        arg7.Right.Interface.Equipment:TryWeapon()
    end)
    arg7.SpecialOfferButton.MouseButton1Click:Connect(function() -- line: 219
        -- upvalues:
        --  [1] arg7 (copy)

        arg7:_InteractSpecialOffer()
    end)
    arg7.FreeTrialButton.MouseButton1Click:Connect(function() -- line: 223
        -- upvalues:
        --  [1] arg7 (copy)
        --  [2] ReplicatedStorage (ref)

        local v32 = arg7.Right.Interface.Equipment:GetSelectedWeapon()
        ReplicatedStorage.Remotes.Misc.PlayVideoAdWeaponTrial:FireServer(v32)
    end)
    arg7.FreeTrialUnavailable.MouseButton1Click:Connect(function() -- line: 228
        -- upvalues:
        --  [1] arg7 (copy)

        arg7:_UpdateInformation()
    end)
    PlayerDataController_m:GetDataChangedSignal("WeaponInventory"):Connect(function() -- line: 232
        -- upvalues:
        --  [1] arg7 (copy)

        arg7:_UpdateInformation()
    end)
    PlayerDataController_m:GetDataChangedSignal("UnlockTokens"):Connect(function() -- line: 236
        -- upvalues:
        --  [1] arg7 (copy)

        arg7:_UpdateInformation()
    end)
    PlayerDataController_m:GetDataChangedSignal("FreeWeaponUnlockCheck"):Connect(function() -- line: 240
        -- upvalues:
        --  [1] arg7 (copy)

        arg7:_UpdateInformation()
    end)
    PlayerDataController_m:GetDataChangedSignal("ScavengerHunts"):Connect(function() -- line: 244
        -- upvalues:
        --  [1] arg7 (copy)

        arg7:_UpdateInformation()
    end)
    PlayerDataController_m:GetDataChangedSignal("FreeWeaponTrialsRemaining"):Connect(function() -- line: 248
        -- upvalues:
        --  [1] arg7 (copy)

        arg7:_UpdateInformation()
    end)
    PlayerDataController_m:GetDataChangedSignal("FreeWeaponTrialsProgressFromVideoAds"):Connect(function() -- line: 252
        -- upvalues:
        --  [1] arg7 (copy)

        arg7:_UpdateInformation()
    end)
    PlayerDataController_m:GetDataChangedSignal("NumFreeWeaponTrialsFromVideoAdsToday"):Connect(function() -- line: 256
        -- upvalues:
        --  [1] arg7 (copy)

        arg7:_UpdateInformation()
    end)
    arg7:_Setup()
    arg7:_Update()
    local t_2 = { HoverRatio = UDim2.new(0, 10, 0, 10), ReleaseRatio = UDim2.new(0, 10, 0, 10) }
    ButtonEffect_m:Add(arg7.BuyButton, nil, t_2)
    local t_3 = { HoverRatio = UDim2.new(0, 10, 0, 10), ReleaseRatio = UDim2.new(0, 10, 0, 10) }
    ButtonEffect_m:Add(arg7.TryWeaponButton, nil, t_3)
    local t_4 = { HoverRatio = UDim2.new(0, 10, 0, 10), ReleaseRatio = UDim2.new(0, 10, 0, 10) }
    ButtonEffect_m:Add(arg7.SpecialOfferButton, nil, t_4)
    local t_5 = { HoverRatio = UDim2.new(0, 10, 0, 10), ReleaseRatio = UDim2.new(0, 10, 0, 10) }
    ButtonEffect_m:Add(arg7.FreeTrialButton, nil, t_5)
    local t_6 = { HoverRatio = UDim2.new(0, 10, 0, 10), ReleaseRatio = UDim2.new(0, 10, 0, 10) }
    ButtonEffect_m:Add(arg7.FreeTrialUnavailable, nil, t_6)
    local t_7 = { HoverRatio = UDim2.new(0, 10, 0, 10), ReleaseRatio = UDim2.new(0, 10, 0, 10) }
    ButtonEffect_m:Add(arg7.ScavengerButton, nil, t_7)
end

return t
