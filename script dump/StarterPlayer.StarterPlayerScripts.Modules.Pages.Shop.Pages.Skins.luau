local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local MonetizationLibrary_m = require(ReplicatedStorage.Modules.MonetizationLibrary)
local CosmeticLibrary_m = require(ReplicatedStorage.Modules.CosmeticLibrary)
local _ = require(ReplicatedStorage.Modules.Utility)
local MonetizationController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.MonetizationController
)
local ComplianceController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.ComplianceController
)
local PlayerDataController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.PlayerDataController
)
local Spotlight_m = require(Players.LocalPlayer.PlayerScripts.Modules.UserInterface.Spotlight)
local ButtonEffect_m = require(Players.LocalPlayer.PlayerScripts.Modules.ButtonEffect)
local RewardSlot_m = require(Players.LocalPlayer.PlayerScripts.Modules.RewardSlot)
local t = {}
t.__index = t

function t.new(arg1) -- line: 17
    -- upvalues:
    --  [1] t (copy)

    local t_1 = setmetatable({}, t)
    t_1.Pages = arg1
    t_1.Frame = t_1.Pages.Frame:WaitForChild("Skins")
    t_1.Container = t_1.Frame:WaitForChild("Container")
    t_1.SlotsFrame = t_1.Container:WaitForChild("Slots")
    t_1.InspectFrame = t_1.Container:WaitForChild("Inspect")
    t_1.InspectRewardsFrame = t_1.InspectFrame:WaitForChild("Rewards")
    t_1.InspectNameDisplayFrame = t_1.InspectFrame:WaitForChild("NameDisplay")
    t_1.InspectNameDisplayBackground = t_1.InspectNameDisplayFrame:WaitForChild("Background")
    t_1.InspectNameDisplayElementsFrame = t_1.InspectNameDisplayFrame:WaitForChild("Elements")
    t_1.InspectNameDisplayLayout = t_1.InspectNameDisplayElementsFrame:WaitForChild("Layout")
    t_1.InspectNameDisplayTitleContainerFrame = t_1.InspectNameDisplayElementsFrame:WaitForChild(
        "TitleContainer"
    )
    t_1.InspectNameDisplayTitle = t_1.InspectNameDisplayTitleContainerFrame:WaitForChild("Title")
    t_1.InspectNameDisplaySlotFrameContainer = t_1.InspectNameDisplayElementsFrame:WaitForChild(
        "Slot"
    ):WaitForChild("Container")
    t_1.InspectDescriptionFrame = t_1.InspectNameDisplaySlotFrameContainer:WaitForChild(
        "Description"
    )
    t_1.InspectDescriptionArrow = t_1.InspectDescriptionFrame:WaitForChild("Arrow")
    t_1.InspectDescriptionBackground = t_1.InspectDescriptionFrame:WaitForChild("Background")
    t_1.InspectDescriptionTitle = t_1.InspectDescriptionFrame:WaitForChild("Title")
    t_1.InspectButtonsFrame = t_1.InspectFrame:WaitForChild("Buttons")
    t_1.InspectBackButton = t_1.InspectButtonsFrame:WaitForChild("Back")
    t_1.InspectBuyItemButton = t_1.InspectButtonsFrame:WaitForChild("BuyItem")
    t_1.InspectBuyItemText = t_1.InspectBuyItemButton:WaitForChild("Value")
    t_1.InspectBuyBundleButton = t_1.InspectButtonsFrame:WaitForChild("BuyBundle")
    t_1.InspectBuyBundleText = t_1.InspectBuyBundleButton:WaitForChild("Value")
    t_1.InspectDiscountTitle = t_1.InspectButtonsFrame:WaitForChild("Discount"):WaitForChild(
        "Bubble"
    ):WaitForChild("Title")
    t_1.InspectPreviewFrame = t_1.InspectFrame:WaitForChild("Preview")
    t_1.InspectPreviewContainer = t_1.InspectPreviewFrame:WaitForChild("Container")
    t_1._inspected_bundle_name = false
    t_1._inspected_bundle_info = nil
    t_1._selected_product_and_reward = nil
    t_1._inspected_reward_slots = {}
    t_1._selected_reward_slot = nil
    t_1._preview_reward_slot = nil
    t_1:_Init()

    return t_1
end

function t.SelectProductAndReward(arg2, arg3) -- line: 63
    -- upvalues:
    --  [1] MonetizationController_m (copy)
    --  [2] CosmeticLibrary_m (copy)
    --  [3] PlayerDataController_m (copy)
    --  [4] RewardSlot_m (copy)

    if arg2._selected_reward_slot then
        arg2._selected_reward_slot:Destroy()
        arg2._selected_reward_slot = nil
    end

    if arg2._preview_reward_slot then
        arg2._preview_reward_slot:Destroy()
        arg2._preview_reward_slot = nil
    end

    arg2._selected_product_and_reward = arg3
    arg2.InspectNameDisplayFrame.Visible = if arg2._selected_product_and_reward == nil then false else true
    local v1 = arg2._selected_product_and_reward
    local InspectBuyItemButton = arg2.InspectBuyItemButton
    v1 = v1 and arg2._selected_product_and_reward[1] ~= nil
    InspectBuyItemButton.Visible = v1

    if not arg2._selected_product_and_reward then
        return
    end

    if arg2.InspectBuyItemButton.Visible then
        local v2 = arg2._selected_product_and_reward
        local v3 = MonetizationController_m
        local InspectBuyItemText = arg2.InspectBuyItemText
        v2 = v2 and arg2._selected_product_and_reward[1]
        v3:SetRobuxText(InspectBuyItemText, v2)
    end

    local v4 = arg2._selected_product_and_reward[3]
    local v5 = CosmeticLibrary_m.Cosmetics[v4.Name]
    arg2.InspectNameDisplayTitle.Text = v4.Name .. (if not v5 then "" else "  \226\128\162  " .. v5.Type .. " ")
    arg2.InspectDescriptionTitle.Text = (v5 and v5.ItemName and v4.Weapon or "") .. " not included"
    local v8 = v5
    local InspectDescriptionFrame = arg2.InspectDescriptionFrame

    if v8 then
        v8 = v5.ItemName

        if v8 then
            v8 = v4.Weapon

            if v8 then
                v8 = not PlayerDataController_m:GetWeaponData(v4.Weapon)
            end
        end
    end

    InspectDescriptionFrame.Visible = v8
    arg2._selected_reward_slot = RewardSlot_m.new(v4)
    arg2._selected_reward_slot:HideWeaponVisual()
    arg2._selected_reward_slot:SetNameText("")
    arg2._selected_reward_slot:SetInteractable(false)
    arg2._selected_reward_slot.Frame.Parent = arg2.InspectNameDisplaySlotFrameContainer
    arg2._preview_reward_slot = RewardSlot_m.new(v4)
    arg2._preview_reward_slot:ZoomOutViewportFrame()
    arg2._preview_reward_slot:UseHighResolutionImage()
    arg2._preview_reward_slot:HideBackground()
    arg2._preview_reward_slot:HideWeaponVisual()
    arg2._preview_reward_slot:SetNameText("")
    arg2._preview_reward_slot:SetInteractable(false)
    arg2._preview_reward_slot.Frame.Parent = arg2.InspectPreviewContainer
    arg2.InspectPreviewContainer.Position = UDim2.new(0.5, 0, 0.6, 0)
    arg2.InspectPreviewContainer:TweenPosition(
        UDim2.new(0.5, 0, 0.5, 0),
        "Out",
        "Quint",
        0.25,
        true
    )
end

function t.Inspect(arg4, arg5) -- line: 112
    -- upvalues:
    --  [1] MonetizationLibrary_m (copy)
    --  [2] MonetizationController_m (copy)
    --  [3] CosmeticLibrary_m (copy)
    --  [4] ComplianceController_m (copy)
    --  [5] RewardSlot_m (copy)

    if arg5 == arg4._inspected_bundle_name then
        return
    end

    for _, val in pairs(arg4._inspected_reward_slots) do
        val:Destroy()
    end

    arg4._inspected_reward_slots = {}
    arg4._inspected_bundle_name = arg5
    local v9 = arg4._inspected_bundle_name and MonetizationLibrary_m.Bundles[arg4._inspected_bundle_name]
    arg4._inspected_bundle_info = v9
    arg4:SelectProductAndReward(nil)
    arg4.SlotsFrame.Visible = not arg4._inspected_bundle_name
    arg4.SlotsFrame.Position = if arg4.SlotsFrame.Visible then UDim2.new(0.375, 0, 0, 0) else UDim2.new(
        0.5,
        0,
        0,
        0
    )
    arg4.SlotsFrame:TweenPosition(
        UDim2.new(0.5, 0, 0, 0),
        "Out",
        "Quint",
        0.25,
        true
    )
    arg4.InspectFrame.Visible = not arg4.SlotsFrame.Visible
    arg4.InspectFrame.Position = if arg4.InspectFrame.Visible then UDim2.new(0.625, 0, 0, 0) else UDim2.new(
        0.5,
        0,
        0,
        0
    )
    arg4.InspectFrame:TweenPosition(
        UDim2.new(0.5, 0, 0, 0),
        "Out",
        "Quint",
        0.25,
        true
    )

    if not arg4._inspected_bundle_name then
        return
    end

    MonetizationController_m:SetRobuxText(
        arg4.InspectBuyBundleText,
        arg4._inspected_bundle_info.ProductID
    )
    MonetizationController_m:SetRobuxTextWithFormat(
        "<s>%s</s>",
        arg4.InspectDiscountTitle,
        table.unpack(arg4._inspected_bundle_info.SetRobuxTextArgs)
    )

    for key_1, val_1 in pairs(arg4._inspected_bundle_info.RewardsWithIndividualProductIDs) do
        local v13 = val_1[3]
        local v14 = CosmeticLibrary_m.Rewards[v13.Name]

        if
            not v14
            or v14.Type ~= "Lootbox"
            or not ComplianceController_m:ArePaidRandomItemsRestricted()
        then
            local v15 = RewardSlot_m.new(v13)
            v15.Frame.LayoutOrder = key_1
            v15:EnableOwnedLogic(true)
            v15:SetParent(arg4.InspectRewardsFrame)
            table.insert(arg4._inspected_reward_slots, v15)
            v15:OnClick(function() -- line: 155
                -- upvalues:
                --  [1] arg4 (copy)
                --  [2] val_1 (copy)

                arg4:SelectProductAndReward(val_1)
            end)

            if not arg4._selected_product_and_reward and val_1[1] then
                arg4:SelectProductAndReward(val_1)
            end
        end
    end

    if not arg4._selected_product_and_reward then
        arg4:SelectProductAndReward(arg4._inspected_bundle_info.RewardsWithIndividualProductIDs[1])
    end
end

function t.Open(arg6) -- line: 169
    arg6:Inspect(nil)
end

function t.Close(arg7) -- line: 173
    arg7:Inspect(nil)
end

function t.Setup(arg8) -- line: 177
    -- upvalues:
    --  [1] MonetizationLibrary_m (copy)
    --  [2] Spotlight_m (copy)
    --  [3] ButtonEffect_m (copy)
    --  [4] CosmeticLibrary_m (copy)
    --  [5] ComplianceController_m (copy)
    --  [6] RewardSlot_m (copy)

    for key_2, val_2 in pairs(MonetizationLibrary_m.Bundles) do
        if val_2.IsCosmeticBundle then
            local Container = arg8.SlotsFrame:WaitForChild(key_2):WaitForChild("Container")
            local Rewards = Container:WaitForChild("Rewards")
            Container:WaitForChild("Title").Text = val_2.DisplayName
            Container.MouseButton1Click:Connect(function() -- line: 190
                -- upvalues:
                --  [1] arg8 (copy)
                --  [2] key_2 (copy)

                arg8:Inspect(key_2)
            end)
            Container.MouseEnter:Connect(function() -- line: 194
                -- upvalues:
                --  [1] Spotlight_m (ref)
                --  [2] Container (copy)

                Spotlight_m:ChangeSubject(Container)
            end)
            Container.MouseLeave:Connect(function() -- line: 198
                -- upvalues:
                --  [1] Spotlight_m (ref)
                --  [2] Container (copy)

                Spotlight_m:ChangeSubject(nil, Container)
            end)
            ButtonEffect_m:Add(Container, nil, { HoverRatio = 1.025, ReleaseRatio = 1.025 })

            for key_3, val_3 in pairs(val_2.RewardsWithIndividualProductIDs) do
                if val_3[1] then
                    local v17 = val_3[3]
                    local v18 = CosmeticLibrary_m.Rewards[v17.Name]

                    if
                        not v18
                        or v18.Type ~= "Lootbox"
                        or not ComplianceController_m:ArePaidRandomItemsRestricted()
                    then
                        local v19 = RewardSlot_m.new(v17)
                        v19.Frame.LayoutOrder = key_3
                        v19:SetInteractable(false)
                        v19:SetNameText("")
                        v19:HideWeaponVisual()
                        v19:SetParent(Rewards)
                    end
                end
            end
        end
    end

    arg8:Inspect(nil)
end

function t._UpdateLayout(arg9) -- line: 232
    arg9.InspectNameDisplayTitleContainerFrame.Size = UDim2.new(
        0,
        arg9.InspectNameDisplayTitle.TextBounds.X,
        0.75,
        0
    )
    arg9.InspectNameDisplayBackground.Size = UDim2.new(
        0,
        arg9.InspectNameDisplayLayout.AbsoluteContentSize.X + arg9.InspectNameDisplayTitleContainerFrame.AbsoluteSize.Y * 0.5,
        1,
        0
    )
    arg9.InspectDescriptionBackground.Size = UDim2.new(
        0,
        arg9.InspectDescriptionTitle.TextBounds.X + arg9.InspectDescriptionFrame.AbsoluteSize.Y,
        1,
        0
    )
end

function t._Init(arg10) -- line: 238
    -- upvalues:
    --  [1] MonetizationController_m (copy)
    --  [2] ButtonEffect_m (copy)

    arg10.InspectBuyBundleButton.MouseButton1Click:Connect(function() -- line: 239
        -- upvalues:
        --  [1] MonetizationController_m (ref)
        --  [2] arg10 (copy)

        MonetizationController_m:PromptProductPurchase(arg10._inspected_bundle_info.ProductID)
    end)
    arg10.InspectBuyItemButton.MouseButton1Click:Connect(function() -- line: 243
        -- upvalues:
        --  [1] MonetizationController_m (ref)
        --  [2] arg10 (copy)

        MonetizationController_m:PromptProductPurchase(arg10._selected_product_and_reward[1])
    end)
    arg10.InspectBackButton.MouseButton1Click:Connect(function() -- line: 247
        -- upvalues:
        --  [1] arg10 (copy)

        arg10:Inspect(nil)
    end)
    arg10.InspectNameDisplayTitle:GetPropertyChangedSignal("TextBounds"):Connect(function() -- line: 251
        -- upvalues:
        --  [1] arg10 (copy)

        arg10:_UpdateLayout()
    end)
    arg10.InspectNameDisplayTitleContainerFrame:GetPropertyChangedSignal("AbsoluteSize"):Connect(
        function() -- line: 255
            -- upvalues:
            --  [1] arg10 (copy)

            arg10:_UpdateLayout()
        end
    )
    arg10.InspectNameDisplayLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() -- line: 259
        -- upvalues:
        --  [1] arg10 (copy)

        arg10:_UpdateLayout()
    end)
    arg10.InspectDescriptionTitle:GetPropertyChangedSignal("TextBounds"):Connect(function() -- line: 263
        -- upvalues:
        --  [1] arg10 (copy)

        arg10:_UpdateLayout()
    end)
    arg10.Pages.Shop.CurrentPageChanged:Connect(function() -- line: 267
        -- upvalues:
        --  [1] arg10 (copy)

        arg10:Inspect(nil)
    end)
    arg10:_UpdateLayout()
    ButtonEffect_m:Add(arg10.InspectBackButton)
    ButtonEffect_m:Add(arg10.InspectBuyItemButton)
    ButtonEffect_m:Add(arg10.InspectBuyBundleButton)
end

return t
