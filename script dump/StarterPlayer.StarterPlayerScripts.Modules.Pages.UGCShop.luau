local MarketplaceService = game:GetService("MarketplaceService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local MonetizationLibrary_m = require(ReplicatedStorage.Modules.MonetizationLibrary)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local MonetizationController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("MonetizationController")
)
local PlayerDataController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("PlayerDataController")
)
local BaseContractSlot_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("BaseContractSlot")
)
local ButtonEffect_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("ButtonEffect")
)
local PromptSystem_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("PromptSystem")
)
local RewardSlot_m = require(Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("RewardSlot"))
local Page_m = require(Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("Page"))
local UGCEmptySlot = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("UGCEmptySlot")
local UGCSlot = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("UGCSlot")
local t = setmetatable({}, Page_m)
t.__index = t

function t._new() -- line: 24
    -- upvalues:
    --  [1] Page_m (copy)
    --  [2] t (copy)
    --  [3] PromptSystem_m (copy)
    --  [4] BaseContractSlot_m (copy)

    local t_1 = setmetatable(Page_m.new(script.Name), t)
    t_1.CloseButton = t_1.PageFrame:WaitForChild("Close")
    t_1.PromptsFrame = t_1.PageFrame:WaitForChild("Prompts")
    t_1.List = t_1.PageFrame:WaitForChild("List")
    t_1.Container = t_1.List:WaitForChild("Container")
    t_1.Layout = t_1.Container:WaitForChild("Layout")
    t_1.SlotsFrame = t_1.Container:WaitForChild("Slots")
    t_1.SlotsContainer = t_1.SlotsFrame:WaitForChild("Container")
    t_1.SlotsLayout = t_1.SlotsContainer:WaitForChild("Layout")
    t_1.CartFrame = t_1.Container:WaitForChild("Cart")
    t_1.CartContainer = t_1.CartFrame:WaitForChild("Container")
    t_1.ItemsText = t_1.CartContainer:WaitForChild("Items")
    t_1.BuyButton = t_1.CartContainer:WaitForChild("Buy")
    t_1.BuyDisclaimerFrame = t_1.BuyButton:WaitForChild("Disclaimer")
    t_1.BuyLockedFrame = t_1.BuyButton:WaitForChild("Locked")
    t_1.BuyRobuxFrame = t_1.BuyButton:WaitForChild("Robux")
    t_1.BuyText = t_1.BuyButton:WaitForChild("Value")
    t_1.NextRewardContainer = t_1.CartContainer:WaitForChild("NextRewardContainer")
    t_1.NextRewardTitle = t_1.CartContainer:WaitForChild("NextRewardTitle")
    t_1.NextRewardDescription = t_1.CartContainer:WaitForChild("NextRewardDescription")
    t_1.NextRewardProgressBFrame = t_1.CartContainer:WaitForChild("NextRewardProgress")
    t_1.NextRewardProgressBar = t_1.NextRewardProgressBFrame:WaitForChild("Bar")
    t_1.PromptSystem = PromptSystem_m.new(t_1.PromptsFrame)
    t_1._next_reward_slot = nil
    t_1._contract_slot = BaseContractSlot_m.new()
    t_1._verified_ugc = false
    t_1._ugc_slots = {}
    t_1._robux_prices = {}
    t_1._shopping_cart = {}
    t_1:_Init()

    return t_1
end

function t.Buy(_, arg2) -- line: 67
    -- upvalues:
    --  [1] MonetizationController_m (copy)
    --  [2] MonetizationLibrary_m (copy)

    MonetizationController_m:PromptPurchase(MonetizationLibrary_m.UGCs[arg2].AssetID)
end

function t.BuyCart(arg3) -- line: 71
    -- upvalues:
    --  [1] Utility_m (copy)
    --  [2] MonetizationLibrary_m (copy)
    --  [3] MonetizationController_m (copy)

    if not next(arg3._shopping_cart) then
        Utility_m:CreateSound(
            "rbxassetid://17153811469",
            2,
            1,
            script,
            true,
            5
        )

        return
    end

    local t_2 = {}

    for key, _ in pairs(arg3._shopping_cart) do
        table.insert(
            t_2,
            {
                Type = Enum.MarketplaceProductType.AvatarAsset,
                Id = tostring(MonetizationLibrary_m.UGCs[key].AssetID)
            }
        )
    end

    MonetizationController_m:PromptBulkPurchase(t_2)
end

function t.Close(arg4, ...) -- line: 86
    -- upvalues:
    --  [1] Page_m (copy)

    arg4:_ClearCart()
    Page_m.Close(arg4, ...)
end

function t._GetNumItemsInCart(arg5) -- line: 95
    -- upvalues:
    --  [1] MonetizationLibrary_m (copy)

    local v9 = 0
    local v10 = 0
    local v11 = false

    for key_1, _ in pairs(arg5._shopping_cart) do
        v9 += 1
        v10 += arg5._robux_prices[key_1] or 0
        v11 = v11 or MonetizationLibrary_m.UGCs[key_1].CanBeMisleading
    end

    return v9, v10, v11
end

function t._UpdateCartVisuals(arg6) -- line: 109
    -- upvalues:
    --  [1] Utility_m (copy)

    for key_2, val_2 in pairs(arg6._ugc_slots) do
        val_2.Enabled.Button.Added.Visible = arg6._shopping_cart[key_2]
    end

    local v13, v14, v15 = arg6:_GetNumItemsInCart()
    arg6.BuyText.Text = utf8.char(57346) .. " " .. Utility_m:PrettyNumber(v14)
    arg6.ItemsText.Text = v13 .. " item" .. (if v13 == 1 then "" else "s")
    arg6.ItemsText.TextColor3 = if v13 >= 20 then Color3.fromRGB(255, 50, 50) else Color3.fromRGB(
        255,
        255,
        255
    )
    local BuyLockedFrame = arg6.BuyLockedFrame
    BuyLockedFrame.Visible = v13 == 0
    local BuyRobuxFrame = arg6.BuyRobuxFrame
    BuyRobuxFrame.Visible = v13 > 0
    arg6.BuyDisclaimerFrame.Visible = v15
end

function t._ClearCart(arg7) -- line: 124
    if not next(arg7._shopping_cart) then
        return false
    end

    arg7._shopping_cart = {}
    arg7:_UpdateCartVisuals()

    return true
end

function t._AddToCart(arg8, arg9) -- line: 135
    if arg8._shopping_cart[arg9] or arg8:_GetNumItemsInCart() >= 20 then
        return false
    end

    arg8._shopping_cart[arg9] = true
    arg8:_UpdateCartVisuals()

    return true
end

function t._RemoveFromCart(arg10, arg11) -- line: 146
    if not arg10._shopping_cart[arg11] then
        return false
    end

    arg10._shopping_cart[arg11] = nil
    arg10:_UpdateCartVisuals()

    return true
end

function t._UpdateContractSlot(arg12) -- line: 157
    -- upvalues:
    --  [1] PlayerDataController_m (copy)

    arg12._contract_slot:SetProgress(#PlayerDataController_m:Get("UGCPurchased"))
end

function t._UpdateNextReward(arg13) -- line: 161
    -- upvalues:
    --  [1] PlayerDataController_m (copy)
    --  [2] MonetizationLibrary_m (copy)
    --  [3] RewardSlot_m (copy)

    if arg13._next_reward_slot then
        arg13._next_reward_slot:Destroy()
        arg13._next_reward_slot = nil
    end

    local v20 = #PlayerDataController_m:Get("UGCPurchased")
    local v21, v22 = MonetizationLibrary_m:GetNextUGCMilestone(v20)
    local v23 = if v21 == nil then false else true
    arg13.NextRewardContainer.Visible = v23
    arg13.NextRewardTitle.Visible = v23
    arg13.NextRewardDescription.Visible = v23
    arg13.NextRewardProgressBFrame.Visible = v23
    arg13.NextRewardProgressBar.Visible = v23
    local v24 = if not v23 then 0.1 else 0.2
    arg13.CartFrame.Size = UDim2.new(1, 0, v24, 0)

    if not v23 then
        return
    end

    v23 = v21.PurchaseRequirement - v20
    local v25 = if v22 then v22.PurchaseRequirement else 0
    arg13.NextRewardProgressBar.Size = UDim2.new(
        math.clamp((v20 - v25) / (v21.PurchaseRequirement - v25), 0, 1),
        0,
        1,
        2
    )
    arg13.NextRewardDescription.Text = string.format(
        "Purchase %s more UGC item%s for a FREE reward!",
        v23,
        if v23 == 1 then "" else "s"
    )

    if v21.Reward then
        arg13._next_reward_slot = RewardSlot_m.new(v21.Reward)
        arg13._next_reward_slot:SetParent(arg13.NextRewardContainer)
    end
end

function t._UpdateLayout(arg14) -- line: 195
    arg14.List.CanvasSize = UDim2.new(0, 0, 0, arg14.Layout.AbsoluteContentSize.Y)
    arg14.SlotsFrame.Size = UDim2.new(
        1,
        0,
        0,
        arg14.SlotsLayout.AbsoluteContentSize.Y + arg14.SlotsFrame.AbsoluteSize.X * 0.042
    )
end

function t._Setup(arg15) -- line: 200
    -- upvalues:
    --  [1] MonetizationLibrary_m (copy)
    --  [2] UGCSlot (copy)
    --  [3] ButtonEffect_m (copy)
    --  [4] PlayerDataController_m (copy)
    --  [5] Utility_m (copy)
    --  [6] MarketplaceService (copy)
    --  [7] Players (copy)
    --  [8] MonetizationController_m (copy)
    --  [9] UGCEmptySlot (copy)

    arg15._contract_slot:SetTitle("Exclusive Rewards")
    arg15._contract_slot:SetImage("rbxassetid://71823401853501", UDim2.new(1.5, 0, 0.75, 0))
    arg15._contract_slot:SetContractImage("rbxassetid://17619445340", UDim2.new(0.05, 0, 0.5, 0))
    arg15._contract_slot:SetDescription(
        "Purchase UGC items for exclusive rewards in the game (RIVALS)"
    )
    local v27

    for _, val_3 in pairs(MonetizationLibrary_m.UGCMilestoneOrder) do
        v27 = MonetizationLibrary_m.UGCMilestones[val_3]
        arg15._contract_slot:AddMilestone(v27.PurchaseRequirement, v27.Reward)
    end

    arg15._contract_slot.Frame.Parent = arg15.Container

    for key_4, val_4 in pairs(MonetizationLibrary_m.UGCOrder) do
        local v27 = MonetizationLibrary_m.UGCs[val_4]
        local v28 = nil
        local v29 = UGCSlot:Clone()
        v29.Enabled.Visible = false
        v29.Waiting.Visible = true
        v29.Waiting.Dots:AddTag("UILoadingDots")
        v29.LayoutOrder = key_4
        v29.Parent = arg15.SlotsContainer
        ButtonEffect_m:Add(v29.Enabled.Button)
        arg15._ugc_slots[val_4] = v29

        local _ = function() --[[ check_is_owned ]] -- line: 227
            -- upvalues:
            --  [1] PlayerDataController_m (ref)
            --  [2] val_4 (copy)

            return table.find(PlayerDataController_m:Get("UGCPurchased"), val_4)
        end

        v29.Enabled.Button.MouseButton1Click:Connect(function() -- line: 231
            -- upvalues:
            --  [1] PlayerDataController_m (ref)
            --  [2] val_4 (copy)
            --  [3] Utility_m (ref)
            --  [4] arg15 (copy)

            if table.find(PlayerDataController_m:Get("UGCPurchased"), val_4) then
                Utility_m:CreateSound(
                    "rbxassetid://17153811469",
                    2,
                    1,
                    script,
                    true,
                    5
                )

                return
            end

            if not arg15._robux_prices[val_4] then
                arg15:Buy(val_4)

                return
            end

            if arg15._shopping_cart[val_4] then
                arg15:_RemoveFromCart(val_4)

                return
            end

            if not arg15:_AddToCart(val_4) then
                Utility_m:CreateSound(
                    "rbxassetid://17153811469",
                    2,
                    1,
                    script,
                    true,
                    5
                )
            end
        end)

        local function update_owned() -- line: 248
            -- upvalues:
            --  [1] PlayerDataController_m (ref)
            --  [2] val_4 (copy)
            --  [3] v29 (copy)
            --  [4] v28 (ref)
            --  [5] Utility_m (ref)
            --  [6] arg15 (copy)

            local index = table.find(PlayerDataController_m:Get("UGCPurchased"), val_4)
            local Description = v29.Enabled.Button.Description
            Description.Text = if index then "\226\156\133 Owned" else if v28 then utf8.char(57346) .. " " .. Utility_m:PrettyNumber(
                v28.PriceInRobux or 0
            ) else "\226\128\162 \226\128\162 \226\128\162"

            if index then
                arg15:_RemoveFromCart(val_4)
            end
        end

        PlayerDataController_m:GetDataChangedSignal("UGCPurchased"):Connect(update_owned)
        update_owned()
        task.spawn(function() -- line: 263
            -- upvalues:
            --  [1] MarketplaceService (ref)
            --  [2] v27 (copy)
            --  [3] v28 (ref)
            --  [4] arg15 (copy)
            --  [5] val_4 (copy)
            --  [6] PlayerDataController_m (ref)
            --  [7] Players (ref)
            --  [8] MonetizationController_m (ref)
            --  [9] v29 (copy)

            local Success, Result = pcall(
                MarketplaceService.GetProductInfoAsync,
                MarketplaceService,
                v27.AssetID,
                Enum.InfoType.Asset
            )

            if not Success then
                return
            end

            v28 = Result
            arg15._robux_prices[val_4] = v28.PriceInRobux

            if not table.find(PlayerDataController_m:Get("UGCPurchased"), val_4) then
                local Success_1, Result_1 = pcall(
                    MarketplaceService.PlayerOwnsAssetAsync,
                    MarketplaceService,
                    Players.LocalPlayer,
                    v27.AssetID
                )

                if not Success_1 then
                    return
                end

                if Result_1 and not arg15._verified_ugc then
                    arg15._verified_ugc = true
                    MonetizationController_m:VerifyUGC()
                end
            end

            v29.Waiting.Visible = false
            v29.Enabled.Visible = true
            v29.Enabled.Button.Icon.Image = "rbxthumb://type=Asset&id=" .. v27.AssetID .. "&w=150&h=150"
            v29.Enabled.Button.Title.Text = v28.Name or ""
        end)
    end

    for _ = 1, 6 - ((#MonetizationLibrary_m.UGCOrder - 1) % 6 + 1) do
        local v32 = UGCEmptySlot:Clone()
        v32.LayoutOrder = 65535
        v32.Parent = arg15.SlotsContainer
    end
end

function t._Init(arg16) -- line: 300
    -- upvalues:
    --  [1] PlayerDataController_m (copy)
    --  [2] ButtonEffect_m (copy)

    arg16.CloseButton.MouseButton1Click:Connect(function() -- line: 301
        -- upvalues:
        --  [1] arg16 (copy)

        arg16:CloseRequest()
    end)
    arg16.Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() -- line: 305
        -- upvalues:
        --  [1] arg16 (copy)

        arg16:_UpdateLayout()
    end)
    arg16.SlotsLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() -- line: 309
        -- upvalues:
        --  [1] arg16 (copy)

        arg16:_UpdateLayout()
    end)
    arg16.SlotsFrame:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- line: 313
        -- upvalues:
        --  [1] arg16 (copy)

        arg16:_UpdateLayout()
    end)
    arg16.BuyButton.MouseButton1Click:Connect(function() -- line: 317
        -- upvalues:
        --  [1] arg16 (copy)

        arg16:BuyCart()
    end)
    PlayerDataController_m:GetDataChangedSignal("UGCPurchased"):Connect(function() -- line: 321
        -- upvalues:
        --  [1] arg16 (copy)

        arg16:_UpdateNextReward()
        arg16:_UpdateContractSlot()
    end)
    arg16:_Setup()
    arg16:_UpdateLayout()
    arg16:_UpdateNextReward()
    arg16:_UpdateContractSlot()
    arg16:_UpdateCartVisuals()
    ButtonEffect_m:Add(arg16.BuyButton)
    ButtonEffect_m:Add(arg16.CloseButton)
end

return t._new()
