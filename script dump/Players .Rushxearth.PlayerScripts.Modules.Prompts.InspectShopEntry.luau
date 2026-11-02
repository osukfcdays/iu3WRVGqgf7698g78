local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local CosmeticLibrary_m = require(ReplicatedStorage.Modules.CosmeticLibrary)
local CurrencyLibrary_m = require(ReplicatedStorage.Modules.CurrencyLibrary)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local Signal_m = require(ReplicatedStorage.Modules.Signal)
local MonetizationController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("MonetizationController")
)
local PlayerDataController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("PlayerDataController")
)
local ComplianceController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("ComplianceController")
)
local ShopController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("ShopController")
)
local ButtonEffect_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("ButtonEffect")
)
local RewardSlot_m = require(Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("RewardSlot"))
local Prompt_m = require(Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("Prompt"))
local ShopEntryBuyButton = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild(
    "ShopEntryBuyButton"
)
local t = setmetatable({}, Prompt_m)
t.__index = t

function t.new(arg1) -- line: 21
    -- upvalues:
    --  [1] Prompt_m (copy)
    --  [2] t (copy)
    --  [3] Signal_m (copy)
    --  [4] ShopController_m (copy)

    local t_1 = setmetatable(Prompt_m.new(script.Name), t)
    t_1.InspectCurrencyPage = Signal_m.new()
    t_1.Title = t_1.PromptFrame:WaitForChild("Title")
    t_1.LimitedFrame = t_1.PromptFrame:WaitForChild("Limited")
    t_1.Container = t_1.PromptFrame:WaitForChild("Container")
    t_1.LockedText = t_1.PromptFrame:WaitForChild("Locked")
    t_1.DisabledText = t_1.PromptFrame:WaitForChild("Disabled")
    t_1.CloseButton = t_1.PromptFrame:WaitForChild("Close")
    t_1.ViewContentsButton = t_1.PromptFrame:WaitForChild("ViewContents")
    t_1.ButtonsFrame = t_1.PromptFrame:WaitForChild("Buttons")
    t_1.AreYouSureTitle = t_1.ButtonsFrame:WaitForChild("AreYouSure")
    t_1.Name = arg1
    t_1.ShopEntry = ShopController_m:GetShopEntry(arg1)
    t_1._close_on_purchase = if t_1.ShopEntry.EntryType ~= "Daily" then false else true
    t_1._reward_slots = {}
    t_1._update_text_bounds = {}
    t_1._robux_buy_buttons = {}
    t_1:_Init()

    return t_1
end

function t.Destroy(arg2) -- line: 53
    -- upvalues:
    --  [1] Prompt_m (copy)

    for _, val in pairs(arg2._reward_slots) do
        val:Destroy()
    end

    arg2.InspectCurrencyPage:Destroy()
    Prompt_m.Destroy(arg2)
end

function t._Update(arg3) -- line: 67
    -- upvalues:
    --  [1] PlayerDataController_m (copy)
    --  [2] CosmeticLibrary_m (copy)
    --  [3] ComplianceController_m (copy)

    local v10 = PlayerDataController_m:Get("CosmeticInventory")
    local v11 = arg3.ShopEntry.Rewards[1]
    local v12 = CosmeticLibrary_m.Cosmetics[v11.Name]
    local v13 = v12

    if v13 then
        v13 = CosmeticLibrary_m.Types[v12.Type]
    end

    local v14 = CosmeticLibrary_m.Rewards[v11.Name]
    local v16 = CosmeticLibrary_m:OwnsCosmetic(v10, v11.Name, v11.Weapon)
    v10 = v11.Weapon

    if v10 then
        v10 = if v11.Weapon ~= "IsRandom" then if v11.Weapon ~= "IsUniversal" then not PlayerDataController_m:GetWeaponData(
            v11.Weapon
        ) else false else false
    end

    local Title = arg3.Title
    local v18

    if v13 and v13.IsWeaponCosmetic then
        v18 = (if v11.Weapon ~= "IsRandom" then if v11.Weapon ~= "IsUniversal" then v11.Weapon else "Universal" else "Random") .. " " .. v12.Type
    else
        v18 = if not v12 then v11.Name else v12.Type
    end

    Title.Text = v18
    arg3.LockedText.Visible = v16 or v10
    local LockedText = arg3.LockedText
    v18 = if v16 then "Unavailable\nYou already own this" else v10 and "Unavailable\nYou don't own " .. (v11.Weapon or "") or ""
    LockedText.Text = v18
    local DisabledText = arg3.DisabledText
    v18 = not arg3.LockedText.Visible

    if v18 then
        v18 = v14

        if v18 then
            v18 = if v14.Type == "Lootbox" then ComplianceController_m:ArePaidRandomItemsRestricted() else false
        end
    end

    DisabledText.Visible = v18
    local ViewContentsButton = arg3.ViewContentsButton
    v18 = v14 and v14.Type == "Lootbox" or v13 and v13.IsWeaponCosmetic and v11.Weapon == "IsRandom"
    ViewContentsButton.Visible = v18
    local ButtonsFrame = arg3.ButtonsFrame
    v18 = not arg3.DisabledText.Visible and not arg3.LockedText.Visible
    ButtonsFrame.Visible = v18
    arg3.AreYouSureTitle.Visible = false

    for _, val_1 in pairs(arg3._robux_buy_buttons) do
        local v19 = not v16 and not v10
        val_1.Visible = v19
    end
end

function t._Setup(arg4) -- line: 91
    -- upvalues:
    --  [1] CurrencyLibrary_m (copy)
    --  [2] PlayerDataController_m (copy)
    --  [3] ShopEntryBuyButton (copy)
    --  [4] Utility_m (copy)
    --  [5] ButtonEffect_m (copy)
    --  [6] MonetizationController_m (copy)
    --  [7] ShopController_m (copy)
    --  [8] RewardSlot_m (copy)

    arg4.LimitedFrame.Visible = arg4.ShopEntry.IsLimited

    for key_2, val_2 in pairs(arg4.ShopEntry.Prices) do
        local v20 = CurrencyLibrary_m.Info[key_2]

        if not v20.OnlyDisplayBuyButtonAboveZeroBalance or not (PlayerDataController_m:Get(key_2) <= 0) then
            local v21 = ShopEntryBuyButton:Clone()
            v21.LayoutOrder = v20.OrderIndex
            v21.Robux.Visible = false
            v21.Free.Visible = if val_2 ~= 0 then false else true
            local Currency = v21.Currency
            local Icon = val_2 > 0
            Currency.Visible = Icon
            v21.Currency.Value.Text = Utility_m:PrettyNumber(val_2)
            v21.Currency.Value.Icon.Image = v20.ImageFlatOutline
            v21.Currency.Value.Icon.ImageLabel.Image = v20.ImageFlat
            v21.Currency.Background.ImageColor3 = v20.Color
            v21.Currency.Background.UIGradient.Color = v20.ColorGradient
            v21.Parent = arg4.ButtonsFrame
            ButtonEffect_m:Add(v21)
            v21.MouseButton1Click:Connect(function() -- line: 114
                -- upvalues:
                --  [1] PlayerDataController_m (ref)
                --  [2] v20 (copy)
                --  [3] val_2 (copy)
                --  [4] MonetizationController_m (ref)
                --  [5] key_2 (copy)
                --  [6] arg4 (copy)
                --  [7] Utility_m (ref)
                --  [8] v21 (copy)
                --  [9] ShopController_m (ref)

                if PlayerDataController_m:Get(v20.DataName) < val_2 then
                    if MonetizationController_m:PromptCurrencyBundlePurchase(val_2, key_2) then
                        arg4.InspectCurrencyPage:Fire()
                        arg4:CloseRequest()

                        return
                    end

                    Utility_m:CreateSound(
                        "rbxassetid://17153811469",
                        2,
                        1,
                        script,
                        true,
                        5
                    )

                    return
                else
                    if v20.NeedsAreYouSurePrompt and not arg4.AreYouSureTitle.Visible then
                        for _, val_3 in pairs(arg4.ButtonsFrame:GetChildren()) do
                            if val_3:IsA("GuiBase2d") then
                                val_3.Visible = false
                            end
                        end

                        v21.Visible = true
                        arg4.AreYouSureTitle.Visible = true

                        return
                    end

                    Utility_m:CreateSound(
                        "rbxassetid://18210861148",
                        1,
                        1,
                        script,
                        true,
                        5
                    )
                    ShopController_m:PurchaseShopEntry(arg4.Name, key_2)
                    arg4:_Update()

                    if arg4._close_on_purchase then
                        arg4:CloseRequest()
                    end

                    return
                end
            end)
            local Currency = v21.Currency.Value
            local Icon = Currency.Icon

            local function update() -- line: 151
                -- upvalues:
                --  [1] Icon (copy)
                --  [2] Currency (copy)

                Icon.Position = UDim2.new(0.5, Currency.TextBounds.X / 2, 0.5, 0)
            end

            Currency:GetPropertyChangedSignal("TextBounds"):Connect(update)
            v21.AncestryChanged:Connect(update)
            Icon.Position = UDim2.new(0.5, Currency.TextBounds.X / 2, 0.5, 0)
        end
    end

    local v26 = pairs
    local v27 = arg4.ShopEntry.ProductIDs or {}

    for key_4, val_4 in v26(v27) do
        local v28 = ShopEntryBuyButton:Clone()
        v28.LayoutOrder = 9999 + val_4
        v28.Free.Visible = false
        v28.Currency.Visible = false
        v28.Robux.Visible = true
        v28.Robux.Title.Text = "Buy \195\151" .. val_4
        v28.Robux.Title.Visible = if val_4 == 1 then false else true
        local Value_1 = v28.Robux.Value
        local udim2 = if val_4 ~= 1 then UDim2.new(0.5, 0, 0.625, 0) else UDim2.new(0.5, 0, 0.5, 0)
        Value_1.Position = udim2
        v28.Parent = arg4.ButtonsFrame
        table.insert(arg4._robux_buy_buttons, v28)
        ButtonEffect_m:Add(v28)
        MonetizationController_m:SetRobuxText(v28.Robux.Value, key_4, Enum.InfoType.Product)
        v28.MouseButton1Click:Connect(function() -- line: 174
            -- upvalues:
            --  [1] arg4 (copy)
            --  [2] ShopController_m (ref)
            --  [3] val_4 (copy)

            if arg4._close_on_purchase then
                arg4:CloseRequest()
            end

            ShopController_m:PurchaseShopEntry(arg4.Name, nil, val_4)
        end)
    end

    for key_5, val_5 in pairs(arg4.ShopEntry.Rewards) do
        local v30 = RewardSlot_m.new(val_5)
        v30.Frame.LayoutOrder = key_5
        v30:SetParent(arg4.Container)
        table.insert(arg4._reward_slots, v30)
    end
end

function t._Init(arg5) -- line: 193
    -- upvalues:
    --  [1] PlayerDataController_m (copy)
    --  [2] ButtonEffect_m (copy)

    arg5.CloseButton.MouseButton1Click:Connect(function() -- line: 194
        -- upvalues:
        --  [1] arg5 (copy)

        arg5:CloseRequest()
    end)
    arg5.ViewContentsButton.MouseButton1Click:Connect(function() -- line: 198
        -- upvalues:
        --  [1] arg5 (copy)

        arg5.OpenPrompt:Fire(
            "InspectLootbox",
            arg5.ShopEntry.Rewards[1].Name,
            arg5.ShopEntry.Rewards[1].Weapon,
            "InspectShopEntry",
            arg5.Name
        )
    end)
    local Connections = arg5._connections
    local CosmeticInventory = PlayerDataController_m:GetDataChangedSignal("CosmeticInventory")
    table.insert(Connections, CosmeticInventory:Connect(function() -- line: 202
        -- upvalues:
        --  [1] arg5 (copy)

        arg5:_Update()
    end))
    local Connections_1 = arg5._connections
    local WeaponInventory = PlayerDataController_m:GetDataChangedSignal("WeaponInventory")
    table.insert(Connections_1, WeaponInventory:Connect(function() -- line: 206
        -- upvalues:
        --  [1] arg5 (copy)

        arg5:_Update()
    end))
    arg5:_Setup()
    arg5:_Update()
    ButtonEffect_m:Add(arg5.CloseButton)
    ButtonEffect_m:Add(arg5.ViewContentsButton)
end

return t
