local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local CosmeticLibrary_m = require(ReplicatedStorage.Modules.CosmeticLibrary)
local _ = require(ReplicatedStorage.Modules.CurrencyLibrary)
local EventLibrary_m = require(ReplicatedStorage.Modules.EventLibrary)
local LootLibrary_m = require(ReplicatedStorage.Modules.LootLibrary)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local MonetizationController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.MonetizationController
)
local PlayerDataController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.PlayerDataController
)
local BigShopSlot_m = require(Players.LocalPlayer.PlayerScripts.Modules.BaseShopSlot.BigShopSlot)
local ShopController_m = require(Players.LocalPlayer.PlayerScripts.Controllers.ShopController)
local ShopSlot_m = require(Players.LocalPlayer.PlayerScripts.Modules.BaseShopSlot.ShopSlot)
local ButtonEffect_m = require(Players.LocalPlayer.PlayerScripts.Modules.ButtonEffect)
local LoginRewards_m = require(script:WaitForChild("LoginRewards"))
local t = {}
t.__index = t

function t.new(arg1) -- line: 20
    -- upvalues:
    --  [1] t (copy)
    --  [2] LoginRewards_m (copy)

    local t_1 = setmetatable({}, t)
    t_1.Pages = arg1
    t_1.Frame = t_1.Pages.Frame:WaitForChild("Daily")
    t_1.Container = t_1.Frame:WaitForChild("Container")
    t_1.Layout = t_1.Container:WaitForChild("Layout")
    t_1.CountdownFrame = t_1.Container:WaitForChild("Countdown")
    t_1.CountdownTimer = t_1.CountdownFrame:WaitForChild("Timer")
    t_1.CountdownRefreshButton = t_1.CountdownFrame:WaitForChild("Refresh")
    t_1.CountdownRefreshPrice = t_1.CountdownRefreshButton:WaitForChild("Price")
    t_1.CountdownRefreshPriceIcon = t_1.CountdownRefreshPrice:WaitForChild("Icon")
    t_1.SkinsFrame = t_1.Container:WaitForChild("Skins")
    t_1.SkinsContainer = t_1.SkinsFrame:WaitForChild("Container")
    t_1.SkinsLayout = t_1.SkinsContainer:WaitForChild("Layout")
    t_1.FinishersFrame = t_1.Container:WaitForChild("Finishers")
    t_1.FinishersContainer = t_1.FinishersFrame:WaitForChild("Container")
    t_1.FinishersHeaderIcon = t_1.FinishersContainer:WaitForChild("Header"):WaitForChild("Icon")
    t_1.FinishersSlotsFrame = t_1.FinishersContainer:WaitForChild("Slots")
    t_1.FinishersSlotsLayout = t_1.FinishersSlotsFrame:WaitForChild("Layout")
    t_1.WrapsFrame = t_1.Container:WaitForChild("Wraps")
    t_1.WrapsContainer = t_1.WrapsFrame:WaitForChild("Container")
    t_1.WrapsHeaderIcon = t_1.WrapsContainer:WaitForChild("Header"):WaitForChild("Icon")
    t_1.WrapsSlotsFrame = t_1.WrapsContainer:WaitForChild("Slots")
    t_1.WrapsSlotsLayout = t_1.WrapsSlotsFrame:WaitForChild("Layout")
    t_1.CharmsFrame = t_1.Container:WaitForChild("Charms")
    t_1.CharmsContainer = t_1.CharmsFrame:WaitForChild("Container")
    t_1.CharmsHeaderIcon = t_1.CharmsContainer:WaitForChild("Header"):WaitForChild("Icon")
    t_1.CharmsSlotsFrame = t_1.CharmsContainer:WaitForChild("Slots")
    t_1.CharmsSlotsLayout = t_1.CharmsSlotsFrame:WaitForChild("Layout")
    t_1.LoginRewards = LoginRewards_m.new(t_1)
    t_1._is_open_hash = 0
    t_1._shop_slots = {}
    t_1:_Init()

    return t_1
end

function t.Generate(arg2) -- line: 65
    -- upvalues:
    --  [1] PlayerDataController_m (copy)
    --  [2] EventLibrary_m (copy)
    --  [3] ShopController_m (copy)
    --  [4] CosmeticLibrary_m (copy)
    --  [5] BigShopSlot_m (copy)
    --  [6] ShopSlot_m (copy)

    for _, val in pairs(arg2._shop_slots) do
        val:Destroy()
    end

    arg2._shop_slots = {}

    if not arg2.Pages.Shop:IsOpen() then
        return
    end

    local v2 = PlayerDataController_m:GetStatistic("StatisticDuelsPlayed") >= EventLibrary_m.NUM_GAMES_NEEDED_TO_PARTICIPATE and true
    local _ = PlayerDataController_m:Get("CosmeticInventory")

    for key_1, val_1 in pairs(ShopController_m:GetDailyShop()) do
        if not val_1.Prices.EventCurrency or v2 then
            local v5 = CosmeticLibrary_m.Cosmetics[val_1.Rewards[1].Name]
            local v6 = if v5.Type ~= "Finisher" then if v5.Type ~= "Wrap" then if v5.Type ~= "Charm" then arg2.SkinsContainer else arg2.CharmsSlotsFrame or arg2.SkinsContainer else arg2.WrapsSlotsFrame or (if v5.Type ~= "Charm" then arg2.SkinsContainer else arg2.CharmsSlotsFrame or arg2.SkinsContainer) else arg2.FinishersSlotsFrame or (if v5.Type ~= "Wrap" then if v5.Type ~= "Charm" then arg2.SkinsContainer else arg2.CharmsSlotsFrame or arg2.SkinsContainer else arg2.WrapsSlotsFrame or (if v5.Type ~= "Charm" then arg2.SkinsContainer else arg2.CharmsSlotsFrame or arg2.SkinsContainer))
            local v7 = if v5.Type == "Skin" then BigShopSlot_m else if v5.Type ~= "Emote" then ShopSlot_m else BigShopSlot_m
            local v8 = arg2.Pages.Shop:CreateShopSlot(v7, nil, val_1.EntryName)
            v8.Frame.LayoutOrder = key_1
            v8.Frame.ZIndex = key_1
            v8.Frame.Parent = v6
            table.insert(arg2._shop_slots, v8)

            if v5.Type == "Emote" and v5.EmoteDescription then
                v8:SetDescription(v5.EmoteDescription)
            end
        end
    end
end

function t.Open(arg3) -- line: 105
    arg3._is_open_hash += 1
    task.spawn(arg3._CountdownLoop, arg3)
    arg3:Generate()
    arg3:_UpdateFrame()
    arg3:_UpdateSizes()
    arg3.LoginRewards:Open()
end

function t.Close(arg4) -- line: 114
    arg4._is_open_hash += 1
    arg4:Generate()
    arg4.LoginRewards:Close()
end

function t.Setup(arg5) -- line: 120
    arg5:Generate()
    arg5.LoginRewards:Setup()
end

function t._CountdownLoop(arg6) -- line: 129
    -- upvalues:
    --  [1] Utility_m (copy)
    --  [2] ShopController_m (copy)

    arg6._is_open_hash += 1
    local IsOpenHash = arg6._is_open_hash

    while true do
        if IsOpenHash ~= arg6._is_open_hash then
            break
        end

        arg6.CountdownTimer.Text = "<font transparency=\"0.5\" size=\"9\">shop will refresh in</font> " .. Utility_m:TimeFormat2(
            ShopController_m:GetDailyShopRefreshTimeRemaining()
        )
        wait(1)
    end
end

function t._UpdateRefreshText(arg7) -- line: 139
    -- upvalues:
    --  [1] LootLibrary_m (copy)
    --  [2] PlayerDataController_m (copy)

    arg7.CountdownRefreshPrice.Text = LootLibrary_m:GetCostToRefreshDailyShop(
        PlayerDataController_m:Get("DailyShopRefreshesToday")
    )
end

function t._UpdateSizes(arg8) -- line: 143
    arg8.SkinsFrame.Size = UDim2.new(
        1,
        0,
        0,
        arg8.SkinsLayout.AbsoluteContentSize.Y + arg8.SkinsFrame.AbsoluteSize.X * 440 / 1173 * 0.05
    )
    arg8.FinishersFrame.Size = UDim2.new(
        1,
        0,
        0,
        arg8.FinishersSlotsLayout.AbsoluteContentSize.Y + arg8.FinishersSlotsFrame.AbsolutePosition.Y - arg8.FinishersContainer.AbsolutePosition.Y + 0.05 * arg8.FinishersContainer.AbsoluteSize.Y
    )
    arg8.WrapsFrame.Size = UDim2.new(
        1,
        0,
        0,
        arg8.WrapsSlotsLayout.AbsoluteContentSize.Y + arg8.WrapsSlotsFrame.AbsolutePosition.Y - arg8.WrapsContainer.AbsolutePosition.Y + 0.05 * arg8.WrapsContainer.AbsoluteSize.Y
    )
    arg8.CharmsFrame.Size = UDim2.new(
        1,
        0,
        0,
        arg8.CharmsSlotsLayout.AbsoluteContentSize.Y + arg8.CharmsSlotsFrame.AbsolutePosition.Y - arg8.CharmsContainer.AbsolutePosition.Y + 0.05 * arg8.CharmsContainer.AbsoluteSize.Y
    )
end

function t._UpdateFrame(arg9) -- line: 150
    arg9.Frame.Size = UDim2.new(1, 0, 0, arg9.Layout.AbsoluteContentSize.Y)
end

function t._Setup(arg10) -- line: 154
    -- upvalues:
    --  [1] CosmeticLibrary_m (copy)

    arg10.FinishersHeaderIcon = CosmeticLibrary_m.Types.Finisher.Image
    arg10.WrapsHeaderIcon = CosmeticLibrary_m.Types.Wrap.Image
    arg10.CharmsHeaderIcon = CosmeticLibrary_m.Types.Charm.Image
end

function t._Init(arg11) -- line: 160
    -- upvalues:
    --  [1] LootLibrary_m (copy)
    --  [2] PlayerDataController_m (copy)
    --  [3] MonetizationController_m (copy)
    --  [4] ShopController_m (copy)
    --  [5] Utility_m (copy)
    --  [6] ButtonEffect_m (copy)

    arg11.Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() -- line: 161
        -- upvalues:
        --  [1] arg11 (copy)

        arg11:_UpdateFrame()
    end)
    arg11.SkinsFrame:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- line: 165
        -- upvalues:
        --  [1] arg11 (copy)

        arg11:_UpdateSizes()
    end)
    arg11.SkinsLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() -- line: 169
        -- upvalues:
        --  [1] arg11 (copy)

        arg11:_UpdateSizes()
    end)
    arg11.FinishersSlotsLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() -- line: 173
        -- upvalues:
        --  [1] arg11 (copy)

        arg11:_UpdateSizes()
    end)
    arg11.FinishersSlotsFrame:GetPropertyChangedSignal("AbsolutePosition"):Connect(function() -- line: 177
        -- upvalues:
        --  [1] arg11 (copy)

        arg11:_UpdateSizes()
    end)
    arg11.FinishersContainer:GetPropertyChangedSignal("AbsolutePosition"):Connect(function() -- line: 181
        -- upvalues:
        --  [1] arg11 (copy)

        arg11:_UpdateSizes()
    end)
    arg11.FinishersContainer:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- line: 185
        -- upvalues:
        --  [1] arg11 (copy)

        arg11:_UpdateSizes()
    end)
    arg11.WrapsSlotsLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() -- line: 189
        -- upvalues:
        --  [1] arg11 (copy)

        arg11:_UpdateSizes()
    end)
    arg11.WrapsSlotsFrame:GetPropertyChangedSignal("AbsolutePosition"):Connect(function() -- line: 193
        -- upvalues:
        --  [1] arg11 (copy)

        arg11:_UpdateSizes()
    end)
    arg11.WrapsContainer:GetPropertyChangedSignal("AbsolutePosition"):Connect(function() -- line: 197
        -- upvalues:
        --  [1] arg11 (copy)

        arg11:_UpdateSizes()
    end)
    arg11.WrapsContainer:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- line: 201
        -- upvalues:
        --  [1] arg11 (copy)

        arg11:_UpdateSizes()
    end)
    arg11.CharmsSlotsLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() -- line: 205
        -- upvalues:
        --  [1] arg11 (copy)

        arg11:_UpdateSizes()
    end)
    arg11.CharmsSlotsFrame:GetPropertyChangedSignal("AbsolutePosition"):Connect(function() -- line: 209
        -- upvalues:
        --  [1] arg11 (copy)

        arg11:_UpdateSizes()
    end)
    arg11.CharmsContainer:GetPropertyChangedSignal("AbsolutePosition"):Connect(function() -- line: 213
        -- upvalues:
        --  [1] arg11 (copy)

        arg11:_UpdateSizes()
    end)
    arg11.CharmsContainer:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- line: 217
        -- upvalues:
        --  [1] arg11 (copy)

        arg11:_UpdateSizes()
    end)
    arg11.CountdownRefreshPriceIcon:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- line: 221
        -- upvalues:
        --  [1] arg11 (copy)

        arg11.CountdownRefreshPrice.Position = UDim2.new(
            0.5,
            -arg11.CountdownRefreshPriceIcon.AbsoluteSize.X / 2,
            0.5,
            0
        )
        arg11.CountdownRefreshPriceIcon.Position = UDim2.new(
            0.5,
            arg11.CountdownRefreshPrice.TextBounds.X / 2,
            0.5,
            0
        )
    end)
    arg11.CountdownRefreshButton.MouseButton1Click:Connect(function() -- line: 226
        -- upvalues:
        --  [1] LootLibrary_m (ref)
        --  [2] PlayerDataController_m (ref)
        --  [3] arg11 (copy)
        --  [4] MonetizationController_m (ref)
        --  [5] ShopController_m (ref)
        --  [6] Utility_m (ref)

        local v12 = LootLibrary_m:GetCostToRefreshDailyShop(
            PlayerDataController_m:Get("DailyShopRefreshesToday")
        )

        if v12 > PlayerDataController_m:Get("WeaponKeys") then
            arg11.Pages.Shop:SetPage("Currency")
            MonetizationController_m:PromptCurrencyBundlePurchase(v12, "WeaponKeys")

            return
        end

        ShopController_m:BuyDailyShopRefresh()
        Utility_m:CreateSound(
            "rbxassetid://18100002432",
            1.25,
            1,
            script,
            true,
            5
        )
    end)
    PlayerDataController_m:GetDataChangedSignal("DailyShopRefreshesToday"):Connect(function() -- line: 239
        -- upvalues:
        --  [1] arg11 (copy)

        arg11:_UpdateRefreshText()
    end)
    PlayerDataController_m:GetDataChangedSignal("CosmeticInventory"):Connect(function() -- line: 243
        -- upvalues:
        --  [1] arg11 (copy)

        arg11:Generate()
    end)
    PlayerDataController_m:GetDataChangedSignal("WeaponInventory"):Connect(function() -- line: 247
        -- upvalues:
        --  [1] arg11 (copy)

        arg11:Generate()
    end)
    ShopController_m.DailyShopRefreshed:Connect(function() -- line: 251
        -- upvalues:
        --  [1] arg11 (copy)

        arg11:Generate()
    end)
    arg11:_Setup()
    arg11:_UpdateFrame()
    arg11:_UpdateSizes()
    arg11:_UpdateRefreshText()
    ButtonEffect_m:Add(arg11.CountdownRefreshButton)
end

return t
