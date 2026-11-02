local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local MonetizationLibrary_m = require(ReplicatedStorage.Modules.MonetizationLibrary)
local MonetizationController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("MonetizationController")
)
local ButtonEffect_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("ButtonEffect")
)
local BundleSlot_m = require(Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("BundleSlot"))
local Prompt_m = require(Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("Prompt"))
local t = setmetatable({}, Prompt_m)
t.__index = t

function t.new(arg1) -- line: 13
    -- upvalues:
    --  [1] Prompt_m (copy)
    --  [2] t (copy)
    --  [3] MonetizationLibrary_m (copy)
    --  [4] BundleSlot_m (copy)

    local t_1 = setmetatable(Prompt_m.new(script.Name), t)
    t_1.Container = t_1.PromptFrame:WaitForChild("Container")
    t_1.ButtonsFrame = t_1.PromptFrame:WaitForChild("Buttons")
    t_1.ButtonsContainer = t_1.ButtonsFrame:WaitForChild("Container")
    t_1.CloseButton = t_1.ButtonsContainer:WaitForChild("Close")
    t_1.BuyButton = t_1.ButtonsContainer:WaitForChild("Buy")
    t_1.BuyButtonOwnedFrame = t_1.BuyButton:WaitForChild("Owned")
    t_1.BuyButtonReadyFrame = t_1.BuyButton:WaitForChild("Ready")
    t_1.BuyButtonReadyText = t_1.BuyButtonReadyFrame:WaitForChild("Title")
    t_1.BuyButtonReadyBubbleFrame = t_1.BuyButtonReadyFrame:WaitForChild("Bubble")
    t_1.BuyButtonReadyBubbleText = t_1.BuyButtonReadyBubbleFrame:WaitForChild("Title")
    t_1.Name = arg1
    t_1.Info = MonetizationLibrary_m.Bundles[t_1.Name]
    t_1._bundle_slot = BundleSlot_m.new(t_1.Name)
    t_1:_Init()

    return t_1
end

function t.Destroy(arg2) -- line: 41
    -- upvalues:
    --  [1] Prompt_m (copy)

    arg2._bundle_slot:Destroy()
    Prompt_m.Destroy(arg2)
end

function t._Update(arg3) -- line: 50
    if arg3._bundle_slot:IsAlreadyOwned() then
        arg3.BuyButton.Visible = true
        arg3.BuyButtonReadyFrame.Visible = false
        arg3.BuyButtonOwnedFrame.Visible = true

        return
    end

    if not arg3._bundle_slot:IsAvailableToPurchase() then
        arg3.BuyButton.Visible = false
        arg3.BuyButtonReadyFrame.Visible = false
        arg3.BuyButtonOwnedFrame.Visible = false

        return
    end

    arg3.BuyButton.Visible = true
    arg3.BuyButtonReadyFrame.Visible = true
    arg3.BuyButtonOwnedFrame.Visible = false
end

function t._Setup(arg4) -- line: 66
    -- upvalues:
    --  [1] MonetizationController_m (copy)

    arg4.BuyButtonReadyBubbleText.RichText = true
    arg4.BuyButtonReadyBubbleText.Text = arg4.Info.BubbleText or ""
    local BuyButtonReadyBubbleFrame = arg4.BuyButtonReadyBubbleFrame
    BuyButtonReadyBubbleFrame.Visible = arg4.BuyButtonReadyBubbleText.Text ~= ""
    MonetizationController_m:SetRobuxText(
        arg4.BuyButtonReadyText,
        arg4._bundle_slot:GetAssetIDForRobuxText(),
        arg4._bundle_slot:GetInfoTypeForRobuxText()
    )
    arg4._bundle_slot:HideRobuxButton()
    arg4._bundle_slot:SetAlwaysSpotlighted(true)
    arg4._bundle_slot:SetSpotlightingInputsEnabled(false)
    arg4._bundle_slot:SetParent(arg4.Container)
    arg4._bundle_slot:StartLoops()
end

function t._Init(arg5) -- line: 79
    -- upvalues:
    --  [1] ButtonEffect_m (copy)

    arg5.CloseButton.MouseButton1Click:Connect(function() -- line: 80
        -- upvalues:
        --  [1] arg5 (copy)

        arg5:CloseRequest()
    end)
    arg5.BuyButton.MouseButton1Click:Connect(function() -- line: 84
        -- upvalues:
        --  [1] arg5 (copy)

        arg5._bundle_slot:PurchaseRequest()
    end)
    arg5._bundle_slot.Tapped:Connect(function() -- line: 88
        -- upvalues:
        --  [1] arg5 (copy)

        arg5._bundle_slot:PurchaseRequest()
    end)
    arg5._bundle_slot.AvailabilityChanged:Connect(function() -- line: 92
        -- upvalues:
        --  [1] arg5 (copy)

        arg5:_Update()
    end)
    arg5._bundle_slot.OwnedChanged:Connect(function() -- line: 96
        -- upvalues:
        --  [1] arg5 (copy)

        arg5:_Update()
    end)
    arg5:_Setup()
    arg5:_Update()
    ButtonEffect_m:Add(arg5.BuyButton)
    ButtonEffect_m:Add(arg5.CloseButton)
end

return t
