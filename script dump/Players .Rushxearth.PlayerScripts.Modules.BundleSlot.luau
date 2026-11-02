local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local MonetizationLibrary_m = require(ReplicatedStorage.Modules.MonetizationLibrary)
local CurrencyLibrary_m = require(ReplicatedStorage.Modules.CurrencyLibrary)
local CosmeticLibrary_m = require(ReplicatedStorage.Modules.CosmeticLibrary)
local SeasonLibrary_m = require(ReplicatedStorage.Modules.SeasonLibrary)
local EventLibrary_m = require(ReplicatedStorage.Modules.EventLibrary)
local ServerOsTime_m = require(ReplicatedStorage.Modules.ServerOsTime)
local ShopLibrary_m = require(ReplicatedStorage.Modules.ShopLibrary)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local Signal_m = require(ReplicatedStorage.Modules.Signal)
local MonetizationController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.MonetizationController
)
local ComplianceController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.ComplianceController
)
local PlayerDataController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.PlayerDataController
)
local ControlsController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.ControlsController
)
local Spotlight_m = require(Players.LocalPlayer.PlayerScripts.Modules.UserInterface.Spotlight)
local ButtonEffect_m = require(Players.LocalPlayer.PlayerScripts.Modules.ButtonEffect)
local RewardSlot_m = require(Players.LocalPlayer.PlayerScripts.Modules.RewardSlot)
local t = {}
local Bundles = Players.LocalPlayer.PlayerScripts.UserInterface.Bundles
t.__index = t

function t.new(arg1) -- line: 26
    -- upvalues:
    --  [1] t (copy)
    --  [2] Signal_m (copy)
    --  [3] MonetizationLibrary_m (copy)
    --  [4] Bundles (copy)

    local t_1 = setmetatable({}, t)
    t_1.Tapped = Signal_m.new()
    t_1.AvailabilityChanged = Signal_m.new()
    t_1.OwnedChanged = Signal_m.new()
    t_1.Name = arg1
    t_1.Info = MonetizationLibrary_m.Bundles[t_1.Name]
    t_1.Frame = Bundles[arg1]:Clone()
    t_1._connections = {}
    t_1._is_currency_bundle = if t_1.Info.Type ~= "Currency" then false else true
    t_1._is_gamepass_bundle = t_1.Info.Type == "Gamepass"
    t_1._is_purchaseable_callback = nil
    t_1._is_spotlighting_inputs_enabled = true
    t_1._is_always_spotlighted = false
    t_1._superstarterbundle_loop_hash = 0
    t_1._is_owned = false
    t_1._is_robux_button_hidden = false
    t_1:_Init()

    return t_1
end

function t.IsAvailableToPurchase(arg2) -- line: 56
    -- upvalues:
    --  [1] PlayerDataController_m (copy)

    if arg2._is_gamepass_bundle then
        return not PlayerDataController_m:Get("GamepassBundlesClaimed")[arg2.Info.GamepassName]
    end

    if arg2.Name == "superstarter_bundle" then
        return arg2:_IsSuperStarterBundleAvailable()
    end

    if arg2.Name == "contrabandseason_bundle" then
        return not arg2:_IsContrabandSeasonBundleOwned()
    end

    if arg2.Name == "primeseason_bundle" then
        return not arg2:_IsPrimeSeasonBundleOwned()
    end

    return true
end

function t.IsAlreadyOwned(arg3) -- line: 70
    return arg3._is_owned
end

function t.GetAssetIDForRobuxText(arg4) -- line: 74
    -- upvalues:
    --  [1] MonetizationLibrary_m (copy)

    return arg4._is_gamepass_bundle and MonetizationLibrary_m.Gamepasses[arg4.Info.GamepassName].GamepassID or arg4.Info.ProductID
end

function t.GetInfoTypeForRobuxText(arg5) -- line: 78
    return arg5._is_gamepass_bundle and Enum.InfoType.GamePass or Enum.InfoType.Product
end

function t.SetParent(arg6, arg7) -- line: 82
    arg6.Frame.Parent = arg7
end

function t.SetIsOwned(arg8, arg9) -- line: 86
    arg8._is_owned = arg9
    arg8.OwnedChanged:Fire()
    arg8:_UpdateOwned()
end

function t.SetAlwaysSpotlighted(arg10, arg11) -- line: 92
    arg10._is_always_spotlighted = arg11
    arg10:_SetSpotlightStatus(false)
end

function t.SetSpotlightingInputsEnabled(arg12, arg13) -- line: 97
    arg12._is_spotlighting_inputs_enabled = arg13
    arg12:_SetSpotlightStatus(false)
end

function t.HideRobuxButton(arg14) -- line: 102
    arg14._is_robux_button_hidden = true
    arg14:_UpdateOwned()
end

function t.StartLoops(arg15) -- line: 107
    if arg15._update_superstarterbundle then
        task.spawn(function() -- line: 109
            -- upvalues:
            --  [1] arg15 (copy)

            local v5 = arg15
            v5._superstarterbundle_loop_hash += 1
            local SuperstarterbundleLoopHash = arg15._superstarterbundle_loop_hash

            while true do
                if SuperstarterbundleLoopHash ~= arg15._superstarterbundle_loop_hash then
                    break
                end

                arg15._update_superstarterbundle()
                wait(1)
            end
        end)
    end
end

function t.StopLoops(arg16) -- line: 121
    arg16._superstarterbundle_loop_hash += 1
end

function t.PurchaseRequest(arg17) -- line: 125
    -- upvalues:
    --  [1] MonetizationController_m (copy)
    --  [2] MonetizationLibrary_m (copy)

    if not arg17:IsAvailableToPurchase() then
        return
    end

    if arg17._is_gamepass_bundle then
        MonetizationController_m:PromptGamePassPurchase(
            MonetizationLibrary_m.Gamepasses[arg17.Info.GamepassName].GamepassID
        )

        return
    end

    MonetizationController_m:PromptProductPurchase(arg17.Info.ProductID)
end

function t.Destroy(arg18) -- line: 137
    for _, val in pairs(arg18._connections) do
        val:Disconnect()
    end

    arg18:StopLoops()
    arg18.Tapped:Destroy()
    arg18.AvailabilityChanged:Destroy()
    arg18.OwnedChanged:Destroy()
    arg18.Frame:Destroy()
end

function t._UpdateOwned(arg19) -- line: 155
    local v6 = not arg19._is_robux_button_hidden
    local Button = arg19.Frame.Container.Button
    v6 = v6 and not arg19._is_owned
    Button.Visible = v6

    if arg19.Frame.Container:FindFirstChild("Claimed") then
        v6 = not arg19._is_robux_button_hidden
        local Claimed = arg19.Frame.Container.Claimed
        v6 = v6 and arg19._is_owned
        Claimed.Visible = v6
    end
end

function t._GetSuperStarterBundleTimeRemaining(_) -- line: 163
    -- upvalues:
    --  [1] MonetizationLibrary_m (copy)
    --  [2] ServerOsTime_m (copy)
    --  [3] PlayerDataController_m (copy)

    local SUPERSTARTERBUNDLEOFFERDURATION = MonetizationLibrary_m.SUPER_STARTER_BUNDLE_OFFER_DURATION
    local v7 = ServerOsTime_m:GetRounded()

    return (math.max(
        0,
        SUPERSTARTERBUNDLEOFFERDURATION - (v7 - PlayerDataController_m:Get(
            "SuperStarterBundleStartTime"
        ))
    ))
end

function t._IsSuperStarterBundleOwned(_) -- line: 167
    -- upvalues:
    --  [1] PlayerDataController_m (copy)

    return PlayerDataController_m:Get("SuperStarterBundlePurchased")
end

function t._IsSuperStarterBundleAvailable(arg22) -- line: 171
    return if arg22:_GetSuperStarterBundleTimeRemaining() > 0 then not arg22:_IsSuperStarterBundleOwned() else false
end

function t._IsPrimeSeasonBundleOwned(_) -- line: 175
    -- upvalues:
    --  [1] PlayerDataController_m (copy)
    --  [2] SeasonLibrary_m (copy)

    local v10 = PlayerDataController_m:Get("Seasons")[SeasonLibrary_m.CurrentSeason.Name]
    local v9 = v10

    if v9 then
        v9 = v10.BattlePass
    end

    v10 = v9 and v9.MaxPassTrackNum or 0

    return v10 >= 2
end

function t._IsContrabandSeasonBundleOwned(_) -- line: 183
    -- upvalues:
    --  [1] PlayerDataController_m (copy)
    --  [2] SeasonLibrary_m (copy)

    local v13 = PlayerDataController_m:Get("Seasons")[SeasonLibrary_m.CurrentSeason.Name]
    local v12 = v13

    if v12 then
        v12 = v13.BattlePass
    end

    return v12 and v12.SeasonPassBundleOwned
end

function t._SetSpotlightStatus(arg25, arg26) -- line: 190
    -- upvalues:
    --  [1] Spotlight_m (copy)

    if arg25._is_spotlighting_inputs_enabled and arg26 then
        Spotlight_m:ChangeSubject(arg25.Frame.Container.Background)
    else
        Spotlight_m:ChangeSubject(nil, arg25.Frame.Container.Background)
    end

    if arg26 or arg25._is_always_spotlighted then
        arg25.Frame.Container.Icon.ImageColor3 = Color3.fromRGB(32, 32, 32)
        arg25.Frame.Container.Icon.ImageTransparency = 0.75
        arg25.Frame.Container.Rewards.Visible = true
        arg25.Frame.Container.Button.BubbleContainer.Visible = false

        return
    end

    arg25.Frame.Container.Icon.ImageColor3 = Color3.fromRGB(255, 255, 255)
    arg25.Frame.Container.Icon.ImageTransparency = 0.25
    arg25.Frame.Container.Rewards.Visible = false
    arg25.Frame.Container.Button.BubbleContainer.Visible = true
end

function t._SetupStandardWeaponsBundle(arg27) -- line: 212
    -- upvalues:
    --  [1] MonetizationLibrary_m (copy)
    --  [2] ShopLibrary_m (copy)
    --  [3] RewardSlot_m (copy)
    --  [4] ControlsController_m (copy)

    for key_1, val_1 in pairs(MonetizationLibrary_m:GetStandardWeaponBundleWeapons()) do
        local v17 = not ShopLibrary_m:IsWeaponReleased(val_1)
        local v18 = RewardSlot_m.new({ Name = val_1 })
        v18.Frame.LayoutOrder = -(#ShopLibrary_m.OwnableWeaponsAlphabetized) + key_1 + (if v17 then -999999999 else 0)
        v18:SetInteractable(ControlsController_m.CurrentControls ~= "Touch")
        v18:SetParent(arg27.Frame.Container.Rewards)

        if v17 then
            v18:SetNameText("???")
            v18:LockedImage()
        end
    end
end

function t._SetupCurrencyVisuals(arg28) -- line: 228
    -- upvalues:
    --  [1] Utility_m (copy)
    --  [2] EventLibrary_m (copy)
    --  [3] CurrencyLibrary_m (copy)

    arg28.Frame.Container.Value.Text = "+ " .. Utility_m:PrettyNumber(
        arg28.Info.Rewards[1].Quantity
    )

    local function update() -- line: 231
        -- upvalues:
        --  [1] arg28 (copy)

        arg28.Frame.Container.Value.Visible = not arg28.Frame.Container.Rewards.Visible
    end

    arg28.Frame.Container.Rewards:GetPropertyChangedSignal("Visible"):Connect(update)
    arg28.Frame.Container.Value.Visible = not arg28.Frame.Container.Rewards.Visible

    if string.sub(arg28.Name, 1, 20) == "eventcurrencybundle_" then
        local v22 = EventLibrary_m.EVENT_DETAILS.BUNDLE_BACKGROUND_IMAGES[tonumber(
            (string.sub(arg28.Name, 21))
        )]
        local Icon_2 = arg28.Frame.Container.Icon

        if not v22 then
            v22 = EventLibrary_m.EVENT_DETAILS.BUNDLE_BACKGROUND_IMAGES[1]
        end

        Icon_2.Image = v22
        arg28.Frame.Container.Background.ImageColor3 = CurrencyLibrary_m.Info.EventCurrency.Color
    end
end

function t._SetupGamepassVisuals(arg29) -- line: 248
    -- upvalues:
    --  [1] PlayerDataController_m (copy)

    local function update_1() --[[ update ]] -- line: 249
        -- upvalues:
        --  [1] arg29 (copy)
        --  [2] PlayerDataController_m (ref)

        arg29:SetIsOwned(
            PlayerDataController_m:Get("GamepassBundlesClaimed")[arg29.Info.GamepassName]
        )
        arg29.AvailabilityChanged:Fire()
    end

    table.insert(
        arg29._connections,
        PlayerDataController_m:GetDataChangedSignal("GamepassBundlesClaimed"):Connect(update_1)
    )
    local v25 = PlayerDataController_m:Get("GamepassBundlesClaimed")
    arg29:SetIsOwned(v25[arg29.Info.GamepassName])
    arg29.AvailabilityChanged:Fire()
end

function t._SetupContrabandSeasonBundle(arg30) -- line: 258
    -- upvalues:
    --  [1] PlayerDataController_m (copy)

    local function update_2() --[[ update ]] -- line: 259
        -- upvalues:
        --  [1] arg30 (copy)

        arg30:SetIsOwned(arg30:_IsContrabandSeasonBundleOwned())
        arg30.AvailabilityChanged:Fire()
    end

    table.insert(
        arg30._connections,
        PlayerDataController_m:GetDataChangedSignal("Seasons"):Connect(update_2)
    )
    arg30:SetIsOwned(arg30:_IsContrabandSeasonBundleOwned())
    arg30.AvailabilityChanged:Fire()
end

function t._SetupPrimeSeasonBundle(arg31) -- line: 268
    -- upvalues:
    --  [1] PlayerDataController_m (copy)

    local function update_3() --[[ update ]] -- line: 269
        -- upvalues:
        --  [1] arg31 (copy)

        arg31:SetIsOwned(arg31:_IsPrimeSeasonBundleOwned())
        arg31.AvailabilityChanged:Fire()
    end

    table.insert(
        arg31._connections,
        PlayerDataController_m:GetDataChangedSignal("Seasons"):Connect(update_3)
    )
    arg31:SetIsOwned(arg31:_IsPrimeSeasonBundleOwned())
    arg31.AvailabilityChanged:Fire()
end

function t._SetupSuperStarterBundle(arg32) -- line: 278
    -- upvalues:
    --  [1] Utility_m (copy)
    --  [2] PlayerDataController_m (copy)

    function arg32._update_superstarterbundle() -- line: 279
        -- upvalues:
        --  [1] arg32 (copy)
        --  [2] Utility_m (ref)

        local v28 = arg32:_GetSuperStarterBundleTimeRemaining()
        arg32.Frame.Container.Countdown.Title.Text = if v28 <= 0 then "This offer is no longer available" else "Offer ends in " .. Utility_m:TimeFormat2(
            v28
        )
        arg32:SetIsOwned(arg32:_IsSuperStarterBundleOwned())
        arg32.AvailabilityChanged:Fire()
    end

    local Connections_3 = arg32._connections
    local SuperStarterBundlePurchased = PlayerDataController_m:GetDataChangedSignal(
        "SuperStarterBundlePurchased"
    )
    table.insert(
        Connections_3,
        SuperStarterBundlePurchased:Connect(arg32._update_superstarterbundle)
    )
    arg32._update_superstarterbundle()

    local function update_4() --[[ update ]] -- line: 291
        -- upvalues:
        --  [1] arg32 (copy)

        arg32.Frame.Container.Countdown.Background.Size = UDim2.new(
            1.125,
            arg32.Frame.Container.Countdown.Title.TextBounds.X,
            1,
            0
        )
        arg32.Frame.Container.Countdown.Title.Icon.Position = UDim2.new(
            1,
            -arg32.Frame.Container.Countdown.Title.TextBounds.X,
            0.5,
            0
        )
    end

    arg32.Frame.Container.Countdown.Title:GetPropertyChangedSignal("TextBounds"):Connect(update_4)
    update_4()
    arg32:SetAlwaysSpotlighted(true)
end

function t._SetupRewards(arg33) -- line: 302
    -- upvalues:
    --  [1] CosmeticLibrary_m (copy)
    --  [2] ComplianceController_m (copy)
    --  [3] RewardSlot_m (copy)
    --  [4] ControlsController_m (copy)

    for key_2, val_2 in pairs(arg33.Info.Rewards) do
        local v31 = CosmeticLibrary_m.Rewards[val_2.Name]

        if
            not v31
            or v31.Type ~= "Lootbox"
            or not ComplianceController_m:ArePaidRandomItemsRestricted()
        then
            local v32 = RewardSlot_m.new(val_2)
            v32.Frame.LayoutOrder = key_2
            v32:SetInteractable(ControlsController_m.CurrentControls ~= "Touch")
            v32:SetParent(arg33.Frame.Container.Rewards)
        end
    end
end

function t._Setup(arg34) -- line: 317
    -- upvalues:
    --  [1] MonetizationController_m (copy)

    arg34.Frame.Container.Title.Text = arg34.Info.DisplayName
    arg34.Frame.Container.Button.BubbleContainer.Bubble.Title.RichText = true
    arg34.Frame.Container.Button.BubbleContainer.Bubble.Title.Text = arg34.Info.BubbleText or ""
    local Bubble = arg34.Frame.Container.Button.BubbleContainer.Bubble
    Bubble.Visible = arg34.Frame.Container.Button.BubbleContainer.Bubble.Title.Text ~= ""
    MonetizationController_m:SetRobuxText(
        arg34.Frame.Container.Button.Title,
        arg34:GetAssetIDForRobuxText(),
        arg34:GetInfoTypeForRobuxText()
    )
    arg34:_SetupRewards()
    arg34:_SetSpotlightStatus(false)

    if arg34._is_currency_bundle then
        arg34:_SetupCurrencyVisuals()
    end

    if arg34._is_gamepass_bundle then
        arg34:_SetupGamepassVisuals()
    end

    if arg34.Name == "standardweapons_bundle" then
        arg34:_SetupStandardWeaponsBundle()

        return
    end

    if arg34.Name == "contrabandseason_bundle" then
        arg34:_SetupContrabandSeasonBundle()

        return
    end

    if arg34.Name == "primeseason_bundle" then
        arg34:_SetupPrimeSeasonBundle()

        return
    end

    if arg34.Name == "superstarter_bundle" then
        arg34:_SetupSuperStarterBundle()
    end
end

function t._Init(arg35) -- line: 347
    -- upvalues:
    --  [1] ButtonEffect_m (copy)

    arg35.Frame.Container.MouseButton1Click:Connect(function() -- line: 348
        -- upvalues:
        --  [1] arg35 (copy)

        arg35.Tapped:Fire()
    end)
    arg35.Frame.Container.MouseEnter:Connect(function() -- line: 352
        -- upvalues:
        --  [1] arg35 (copy)

        arg35:_SetSpotlightStatus(true)
    end)
    arg35.Frame.Container.MouseLeave:Connect(function() -- line: 356
        -- upvalues:
        --  [1] arg35 (copy)

        arg35:_SetSpotlightStatus(false)
    end)
    arg35:_Setup()
    arg35:_UpdateOwned()
    ButtonEffect_m:Add(arg35.Frame.Container, nil, { HoverRatio = 1.025, ReleaseRatio = 1.025 })
end

return t
