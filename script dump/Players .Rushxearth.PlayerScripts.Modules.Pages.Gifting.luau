local MarketplaceService = game:GetService("MarketplaceService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local _ = game:GetService("GuiService")
local Players = game:GetService("Players")
local CONSTANTS_m = require(ReplicatedStorage.Modules.CONSTANTS)
local MonetizationLibrary_m = require(ReplicatedStorage.Modules.MonetizationLibrary)
local SeasonLibrary_m = require(ReplicatedStorage.Modules.SeasonLibrary)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local MonetizationController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("MonetizationController")
)
local PlayerDataController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("PlayerDataController")
)
local _ = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("ComplianceController")
)
local ButtonEffect_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("ButtonEffect")
)
local PromptSystem_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("PromptSystem")
)
local DropdownSlot_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("DropdownSlot")
)
local RewardSlot_m = require(Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("RewardSlot"))
local Page_m = require(Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("Page"))
local GiftPlayerEmptySlot = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild(
    "GiftPlayerEmptySlot"
)
local GiftProductSlot = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild(
    "GiftProductSlot"
)
local GiftPlayerSlot = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild(
    "GiftPlayerSlot"
)
local t = {
    "None",
    "Enjoy!",
    "Thanks!",
    "Surprise!",
    "I appreciate you!",
    "You're the best!",
    "Thanks for everything!",
    "You played well!",
    "You owe me!",
    "Happy birthday!",
    "Merry Christmas!",
    "Happy holidays!",
    "Congratulations!",
    "Custom"
}
local t_1 = setmetatable({}, Page_m)
t_1.__index = t_1

function t_1._new() -- line: 28
    -- upvalues:
    --  [1] Page_m (copy)
    --  [2] t_1 (copy)
    --  [3] PromptSystem_m (copy)

    local t_2 = setmetatable(Page_m.new(script.Name), t_1)
    t_2.CloseButton = t_2.PageFrame:WaitForChild("Close")
    t_2.PromptsFrame = t_2.PageFrame:WaitForChild("Prompts")
    t_2.BackButton = t_2.PageFrame:WaitForChild("Back")
    t_2.Container = t_2.PageFrame:WaitForChild("Container")
    t_2.SelectPlayerFrame = t_2.Container:WaitForChild("SelectPlayer")
    t_2.PlayersList = t_2.SelectPlayerFrame:WaitForChild("List")
    t_2.PlayersContainer = t_2.PlayersList:WaitForChild("Container")
    t_2.PlayersLayout = t_2.PlayersContainer:WaitForChild("Layout")
    t_2.PlayersGiftRewardFrame = t_2.PlayersContainer:WaitForChild("GiftReward")
    t_2.PlayersGiftRewardProgressBar = t_2.PlayersGiftRewardFrame:WaitForChild("Progress"):WaitForChild(
        "Bar"
    )
    t_2.PlayersGiftRewardContainer = t_2.PlayersGiftRewardFrame:WaitForChild("Container")
    t_2.PlayersGiftRewardGoalText = t_2.PlayersGiftRewardFrame:WaitForChild("Goal")
    t_2.PlayersOfflineGiftFrame = t_2.PlayersContainer:WaitForChild("OfflineGift")
    t_2.PlayersOfflineGiftBox = t_2.PlayersOfflineGiftFrame:WaitForChild("Input"):WaitForChild(
        "Box"
    )
    t_2.PlayersOfflineGiftButton = t_2.PlayersOfflineGiftFrame:WaitForChild("Button")
    t_2.PlayersOfflineGiftButtonOn = t_2.PlayersOfflineGiftButton:WaitForChild("On")
    t_2.PlayersOfflineGiftButtonOff = t_2.PlayersOfflineGiftButton:WaitForChild("Off")
    t_2.PlayersOfflineGiftButtonIcon = t_2.PlayersOfflineGiftButton:WaitForChild("Icon")
    t_2.PlayersOfflineGiftButtonCountdown = t_2.PlayersOfflineGiftButton:WaitForChild("Countdown")
    t_2.SelectProductFrame = t_2.Container:WaitForChild("SelectProduct")
    t_2.ProductsEmptyFrame = t_2.SelectProductFrame:WaitForChild("Empty")
    t_2.ProductsDotsFrame = t_2.SelectProductFrame:WaitForChild("Dots")
    t_2.ProductsList = t_2.SelectProductFrame:WaitForChild("List")
    t_2.ProductsContainer = t_2.ProductsList:WaitForChild("Container")
    t_2.ProductsLayout = t_2.ProductsContainer:WaitForChild("Layout")
    t_2.ProductsPlayerFrame = t_2.ProductsContainer:WaitForChild("Player")
    t_2.ProductsPlayerPicture = t_2.ProductsPlayerFrame:WaitForChild("Picture")
    t_2.ProductsPlayerUsernameText = t_2.ProductsPlayerFrame:WaitForChild("Username")
    t_2.ProductsPlayerDisplayNameText = t_2.ProductsPlayerFrame:WaitForChild("DisplayName")
    t_2.ConfirmPurchaseFrame = t_2.Container:WaitForChild("ConfirmPurchase")
    t_2.ConfirmPurchaseDotsFrame = t_2.ConfirmPurchaseFrame:WaitForChild("Dots")
    t_2.ConfirmPurchaseList = t_2.ConfirmPurchaseFrame:WaitForChild("List")
    t_2.ConfirmPurchaseContainer = t_2.ConfirmPurchaseList:WaitForChild("Container")
    t_2.ConfirmPurchaseLayout = t_2.ConfirmPurchaseContainer:WaitForChild("Layout")
    t_2.ConfirmPurchasePlayerFrame = t_2.ConfirmPurchaseContainer:WaitForChild("Player")
    t_2.ConfirmPurchasePlayerPicture = t_2.ConfirmPurchasePlayerFrame:WaitForChild("Picture")
    t_2.ConfirmPurchasePlayerUsernameText = t_2.ConfirmPurchasePlayerFrame:WaitForChild("Username")
    t_2.ConfirmPurchasePlayerDisplayNameText = t_2.ConfirmPurchasePlayerFrame:WaitForChild(
        "DisplayName"
    )
    t_2.ConfirmPurchaseProductFrame = t_2.ConfirmPurchaseContainer:WaitForChild("Product")
    t_2.ConfirmPurchaseProductIcon = t_2.ConfirmPurchaseProductFrame:WaitForChild("Icon")
    t_2.ConfirmPurchaseProductTitleText = t_2.ConfirmPurchaseProductFrame:WaitForChild(
        "DisplayName"
    )
    t_2.ConfirmPurchaseWarningsFrame = t_2.ConfirmPurchaseContainer:WaitForChild("Warnings")
    t_2.ConfirmPurchaseWarningsGiftTicketsFrame = t_2.ConfirmPurchaseWarningsFrame:WaitForChild(
        "GiftTickets"
    )
    t_2.ConfirmPurchaseWarningsGiftTicketsText = t_2.ConfirmPurchaseWarningsGiftTicketsFrame:WaitForChild(
        "Icon"
    ):WaitForChild("Quantity")
    t_2.ConfirmPurchaseWarningsOfflineGiftingFrame = t_2.ConfirmPurchaseWarningsFrame:WaitForChild(
        "OfflineGifting"
    )
    t_2.ConfirmPurchaseBuyFrame = t_2.ConfirmPurchaseContainer:WaitForChild("Buy")
    t_2.ConfirmPurchaseBuyButton = t_2.ConfirmPurchaseBuyFrame:WaitForChild("Button")
    t_2.ConfirmPurchaseBuyButtonGiftTicketIcon = t_2.ConfirmPurchaseBuyButton:WaitForChild(
        "GiftTicket"
    )
    t_2.ConfirmPurchaseBuyButtonRobuxPrice = t_2.ConfirmPurchaseBuyButton:WaitForChild("Robux")
    t_2.ConfirmPurchaseSettingsFrame = t_2.ConfirmPurchaseContainer:WaitForChild("Settings")
    t_2.ConfirmPurchaseSettingsContainer = t_2.ConfirmPurchaseSettingsFrame:WaitForChild(
        "Container"
    )
    t_2.ConfirmPurchaseSettingsLayout = t_2.ConfirmPurchaseSettingsContainer:WaitForChild("Layout")
    t_2.ConfirmPurchaseSettingsNoteFrame = t_2.ConfirmPurchaseSettingsContainer:WaitForChild("Note")
    t_2.ConfirmPurchaseSettingsNoteDropdownFrame = t_2.ConfirmPurchaseSettingsNoteFrame:WaitForChild(
        "Dropdown"
    )
    t_2.ConfirmPurchaseSettingsNoteDropdownButton = t_2.ConfirmPurchaseSettingsNoteDropdownFrame:WaitForChild(
        "Button"
    )
    t_2.ConfirmPurchaseSettingsNoteDropdownButtonTitle = t_2.ConfirmPurchaseSettingsNoteDropdownButton:WaitForChild(
        "Title"
    )
    t_2.ConfirmPurchaseSettingsCustomNoteFrame = t_2.ConfirmPurchaseSettingsContainer:WaitForChild(
        "CustomNote"
    )
    t_2.ConfirmPurchaseSettingsCustomNoteContainer = t_2.ConfirmPurchaseSettingsCustomNoteFrame:WaitForChild(
        "Container"
    )
    t_2.ConfirmPurchaseSettingsCustomNoteLockedFrame = t_2.ConfirmPurchaseSettingsCustomNoteContainer:WaitForChild(
        "Locked"
    )
    t_2.ConfirmPurchaseSettingsCustomNoteUnlockedFrame = t_2.ConfirmPurchaseSettingsCustomNoteContainer:WaitForChild(
        "Unlocked"
    )
    t_2.ConfirmPurchaseSettingsCustomNoteBox = t_2.ConfirmPurchaseSettingsCustomNoteUnlockedFrame:WaitForChild(
        "Box"
    )
    t_2.ConfirmPurchaseSettingsCustomNoteCount = t_2.ConfirmPurchaseSettingsCustomNoteUnlockedFrame:WaitForChild(
        "Count"
    )
    t_2.ConfirmPurchaseSettingsAnonymousFrame = t_2.ConfirmPurchaseSettingsContainer:WaitForChild(
        "Anonymous"
    )
    t_2.ConfirmPurchaseSettingsAnonymousTitle = t_2.ConfirmPurchaseSettingsAnonymousFrame:WaitForChild(
        "Title"
    )
    t_2.ConfirmPurchaseSettingsAnonymousButton = t_2.ConfirmPurchaseSettingsAnonymousFrame:WaitForChild(
        "Button"
    )
    t_2.ConfirmPurchaseSettingsAnonymousEmpty = t_2.ConfirmPurchaseSettingsAnonymousButton:WaitForChild(
        "Empty"
    )
    t_2.ConfirmPurchaseSettingsAnonymousFilled = t_2.ConfirmPurchaseSettingsAnonymousButton:WaitForChild(
        "Filled"
    )
    t_2.PromptSystem = PromptSystem_m.new(t_2.PromptsFrame)
    t_2._open_animation_disabled = true
    t_2._selected_player_input = nil
    t_2._selected_product_id = nil
    t_2._selected_player_lookup = nil
    t_2._player_slots = {}
    t_2._gift_slots = {}
    t_2._fetch_player_data_hash = 0
    t_2._generate_hash = 0
    t_2._dont_redirect = nil
    t_2:_Init()

    return t_2
end

function t_1.CloseRequest(arg1) -- line: 120
    -- upvalues:
    --  [1] Page_m (copy)

    if arg1._dont_redirect then
        arg1._dont_redirect = nil
        Page_m.CloseRequest(arg1)

        return
    end

    arg1.OpenPage:Fire("Shop", true)
end

function t_1.Open(arg2, ...) -- line: 129
    -- upvalues:
    --  [1] Page_m (copy)

    Page_m.Open(arg2, ...)
    arg2:SelectPlayer(nil)
    task.spawn(arg2._FetchGiftImages, arg2)
    task.spawn(arg2._GeneratePlayers, arg2)
end

function t_1.Close(arg3, ...) -- line: 136
    -- upvalues:
    --  [1] Page_m (copy)

    arg3:SelectPlayer(nil)
    arg3:_StopNoteDropdown()
    Page_m.Close(arg3, ...)
end

function t_1.DontRedirect(arg4) -- line: 142
    arg4._dont_redirect = true
end

function t_1.SelectPlayer(arg5, arg6) -- line: 147
    assert(
        not arg6 or (if typeof(arg6) ~= "string" then if typeof(arg6) == "Instance" then arg6:IsA(
            "Player"
        ) else false else true),
        "Argument 1 invalid, expected a Player or string or nil, got " .. tostring(arg6)
    )
    arg5._fetch_player_data_hash += 1
    arg5._selected_player_input = arg6
    arg5._selected_player_lookup = nil
    arg5:_UpdateFrameVisibility()

    if arg5._selected_player_input then
        task.spawn(arg5._FetchSelectedPlayerData, arg5)
    else
        arg5:SelectProduct(nil)
    end

    task.spawn(arg5._GeneratePlayers, arg5)
end

function t_1.SelectProduct(arg7, arg8) -- line: 165
    assert(
        not arg8 or (if typeof(arg8) ~= "number" then false else true),
        "Argument 1 invalid, expected a number or nil, got " .. tostring(arg8)
    )
    arg7._fetch_player_data_hash += 1
    arg7._selected_product_id = arg8
    arg7:_UpdateFrameVisibility()
end

function t_1.ConfirmPurchase(arg9) -- line: 174
    -- upvalues:
    --  [1] ReplicatedStorage (copy)

    if not arg9._selected_player_input or not arg9._selected_product_id then
        return
    end

    arg9.ConfirmPurchaseList.Visible = false
    arg9.ConfirmPurchaseDotsFrame.Visible = true
    arg9.ConfirmPurchaseDotsFrame:AddTag("UILoadingDots")
    ReplicatedStorage.Remotes.Misc.PromptGiftProductPurchase:InvokeServer(
        arg9._selected_product_id,
        arg9._selected_player_lookup.UserID,
        arg9._selected_player_lookup.IsOfflineGift,
        arg9:_GetGiftNote(),
        arg9.ConfirmPurchaseSettingsAnonymousFilled.Visible
    )
    arg9.ConfirmPurchaseList.Visible = true
    arg9.ConfirmPurchaseDotsFrame.Visible = false
    arg9.ConfirmPurchaseDotsFrame:RemoveTag("UILoadingDots")
    arg9:SelectPlayer(nil)
end

function t_1._StopNoteDropdown(arg10) -- line: 202
    if arg10._note_dropdown_slot then
        arg10._note_dropdown_slot:Cancel()
        arg10._note_dropdown_slot = nil
    end

    arg10.ConfirmPurchaseSettingsNoteDropdownButton.Visible = true
end

function t_1._StartNoteDropdown(arg11) -- line: 211
    -- upvalues:
    --  [1] DropdownSlot_m (copy)
    --  [2] t (copy)

    arg11:_StopNoteDropdown()
    arg11.ConfirmPurchaseSettingsNoteDropdownButton.Visible = false
    arg11._note_dropdown_slot = DropdownSlot_m.new(
        arg11.ConfirmPurchaseSettingsNoteDropdownFrame,
        t
    )
    arg11._note_dropdown_slot.Selected:Connect(function(mouse: Instance) -- line: 218
        -- upvalues:
        --  [1] arg11 (copy)

        if mouse then
            arg11.ConfirmPurchaseSettingsNoteDropdownButtonTitle.Text = mouse
        end

        arg11:_StopNoteDropdown()
    end)
end

function t_1._GetGiftNote(arg13) -- line: 227
    local Text = arg13.ConfirmPurchaseSettingsNoteDropdownButtonTitle.Text

    if Text == "None" then
        return ""
    end

    if Text == "Custom" then
        if arg13.ConfirmPurchaseSettingsCustomNoteUnlockedFrame.Visible then
            return arg13.ConfirmPurchaseSettingsCustomNoteBox.Text
        end

        return ""
    else
        return Text
    end
end

function t_1._VerifyNote(arg14) -- line: 245
    -- upvalues:
    --  [1] MonetizationLibrary_m (copy)

    arg14.ConfirmPurchaseSettingsCustomNoteBox.Text = MonetizationLibrary_m:SanitizeGiftNote(
        arg14.ConfirmPurchaseSettingsCustomNoteBox.Text
    ) or ""
    arg14.ConfirmPurchaseSettingsCustomNoteCount.Text = #arg14.ConfirmPurchaseSettingsCustomNoteBox.Text .. " / " .. MonetizationLibrary_m.MAX_GIFTING_NOTE_CHARACTER_COUNT
    local ConfirmPurchaseSettingsCustomNoteCount = arg14.ConfirmPurchaseSettingsCustomNoteCount
    ConfirmPurchaseSettingsCustomNoteCount.TextColor3 = #arg14.ConfirmPurchaseSettingsCustomNoteBox.Text >= MonetizationLibrary_m.MAX_GIFTING_NOTE_CHARACTER_COUNT and Color3.fromRGB(
        255,
        50,
        50
    ) or Color3.fromRGB(255, 255, 255)
    local ConfirmPurchaseSettingsCustomNoteCount_1 = arg14.ConfirmPurchaseSettingsCustomNoteCount
    ConfirmPurchaseSettingsCustomNoteCount_1.TextTransparency = if not (#arg14.ConfirmPurchaseSettingsCustomNoteBox.Text >= MonetizationLibrary_m.MAX_GIFTING_NOTE_CHARACTER_COUNT) then 0.5 else 0
end

function t_1._UpdateGiftReward(arg15) -- line: 252
    -- upvalues:
    --  [1] PlayerDataController_m (copy)
    --  [2] MonetizationLibrary_m (copy)
    --  [3] Utility_m (copy)

    local v14 = PlayerDataController_m:Get("GiftRobuxSpentProgress")
    local v16 = MonetizationLibrary_m:GetGiftRewardRobuxSpentRequirement(
        PlayerDataController_m:Get("GiftRobuxSpentRewardsClaimed")
    )
    arg15.PlayersGiftRewardProgressBar.Size = UDim2.new(math.clamp(v14 / v16, 0, 1), 0, 1, 2)
    arg15.PlayersGiftRewardGoalText.Text = Utility_m:PrettyNumber(v14) .. " / " .. Utility_m:PrettyNumber(
        v16
    ) .. " points"
end

function t_1._OfflineGiftingCooldown(arg16) -- line: 260
    arg16.PlayersOfflineGiftButtonCountdown.Visible = true
    arg16.PlayersOfflineGiftButtonIcon.Visible = false

    for index = 15, 1, -1 do
        arg16.PlayersOfflineGiftButtonCountdown.Text = index
        wait(1)
    end

    arg16.PlayersOfflineGiftButtonCountdown.Visible = false
    arg16.PlayersOfflineGiftButtonIcon.Visible = true
end

function t_1._UpdateOfflineGiftingButton(arg17) -- line: 273
    -- upvalues:
    --  [1] Players (copy)
    --  [2] CONSTANTS_m (copy)

    local v18 = arg17.PlayersOfflineGiftButtonIcon.Visible
    local PlayersOfflineGiftButtonOn = arg17.PlayersOfflineGiftButtonOn

    if v18 then
        v18 = if arg17.PlayersOfflineGiftBox.Text ~= "" then if string.lower(
            arg17.PlayersOfflineGiftBox.Text
        ) == string.lower(Players.LocalPlayer.Name) then CONSTANTS_m.IS_STUDIO else true else false
    end

    PlayersOfflineGiftButtonOn.Visible = v18
    arg17.PlayersOfflineGiftButtonOff.Visible = not arg17.PlayersOfflineGiftButtonOn.Visible
end

function t_1._FetchGiftImages(arg18) -- line: 278
    -- upvalues:
    --  [1] MonetizationLibrary_m (copy)
    --  [2] MarketplaceService (copy)

    for key, val in pairs(MonetizationLibrary_m.Gifts) do
        if not val.ImageID then
            task.spawn(function() -- line: 284
                -- upvalues:
                --  [1] MarketplaceService (ref)
                --  [2] val (copy)
                --  [3] arg18 (copy)
                --  [4] key (copy)

                local Success, Result = pcall(
                    MarketplaceService.GetProductInfoAsync,
                    MarketplaceService,
                    val.ProductID,
                    Enum.InfoType.Product
                )

                if val.ImageID then
                    return
                end

                if Success then
                    val.ImageID = "rbxassetid://" .. Result.IconImageAssetId
                    arg18._gift_slots[key].Slot.Icon.Image = val.ImageID

                    return
                end

                warn("Failed to fetch gamepass info:", Result)
            end)
        end
    end
end

function t_1._FetchSelectedPlayerData(arg19) -- line: 301
    -- upvalues:
    --  [1] ReplicatedStorage (copy)

    arg19._fetch_player_data_hash += 1
    local FetchPlayerDataHash = arg19._fetch_player_data_hash
    arg19.ProductsDotsFrame.Visible = true
    arg19.ProductsDotsFrame:AddTag("UILoadingDots")
    arg19.ProductsList.Visible = false
    arg19._selected_player_lookup = nil
    wait(0.25)

    if arg19._fetch_player_data_hash ~= FetchPlayerDataHash then
        return
    end

    local v19, v20 = ReplicatedStorage.Remotes.Misc.RequestGiftingDetails:InvokeServer(
        arg19._selected_player_input
    )

    if arg19._fetch_player_data_hash ~= FetchPlayerDataHash then
        return
    end

    arg19.ProductsDotsFrame:RemoveTag("UILoadingDots")
    arg19.ProductsDotsFrame.Visible = false
    arg19.ProductsList.Visible = true

    if v19 and v20 then
        arg19._selected_player_lookup = v20
    else
        if v20 then
            arg19.PromptSystem:Open("ErrorMessage", "Whoops!", v20)
        end

        arg19:SelectPlayer(nil)
    end

    arg19:_UpdateProducts()
end

function t_1._UpdateConfirmPurchasePage(arg20) -- line: 340
    -- upvalues:
    --  [1] MonetizationLibrary_m (copy)
    --  [2] PlayerDataController_m (copy)
    --  [3] CONSTANTS_m (copy)
    --  [4] MonetizationController_m (copy)

    if not arg20._selected_player_input or not arg20._selected_product_id then
        return
    end

    local v21 = MonetizationLibrary_m.Gifts[tostring(arg20._selected_product_id)]
    local v23 = PlayerDataController_m:Get("GiftTickets")[tostring(arg20._selected_product_id)] or 0
    local v24 = if typeof(arg20._selected_player_input) ~= "string" then false else true
    arg20.ConfirmPurchasePlayerPicture.Image = string.format(
        CONSTANTS_m.HEADSHOT_IMAGE,
        arg20._selected_player_lookup.UserID
    )
    arg20.ConfirmPurchasePlayerUsernameText.Text = if not arg20._selected_player_lookup.DisplayName then "" else if arg20._selected_player_lookup.DisplayName == arg20._selected_player_lookup.Name then "" else "@" .. arg20._selected_player_lookup.Name
    local v25 = arg20._selected_player_lookup.DisplayName
    local ConfirmPurchasePlayerDisplayNameText = arg20.ConfirmPurchasePlayerDisplayNameText

    if not v25 then
        v25 = "@" .. arg20._selected_player_lookup.Name
    end

    ConfirmPurchasePlayerDisplayNameText.Text = v25
    local ConfirmPurchasePlayerDisplayNameText_1 = arg20.ConfirmPurchasePlayerDisplayNameText
    v25 = if arg20.ConfirmPurchasePlayerUsernameText.Text ~= "" then UDim2.new(0.15, 0, 0.4, 0) else UDim2.new(
        0.15,
        0,
        0.5,
        0
    ) or UDim2.new(0.15, 0, 0.4, 0)
    ConfirmPurchasePlayerDisplayNameText_1.Position = v25
    arg20.ConfirmPurchaseProductIcon.Image = v21.ImageID or ""
    arg20.ConfirmPurchaseProductTitleText.Text = v21.DisplayName
    local v26 = arg20._selected_player_lookup.DisplayName
    local ConfirmPurchaseSettingsAnonymousTitle = arg20.ConfirmPurchaseSettingsAnonymousTitle
    v26 = v26 or arg20._selected_player_lookup.Name
    ConfirmPurchaseSettingsAnonymousTitle.Text = "Hide my name from " .. v26
    arg20.ConfirmPurchaseSettingsCustomNoteLockedFrame.Visible = v24
    arg20.ConfirmPurchaseSettingsCustomNoteUnlockedFrame.Visible = not v24
    arg20.ConfirmPurchaseWarningsGiftTicketsFrame.Visible = v23 > 0 and true
    arg20.ConfirmPurchaseWarningsGiftTicketsText.Text = "\195\151" .. v23
    arg20.ConfirmPurchaseBuyButtonGiftTicketIcon.Visible = v23 > 0 and true
    local ConfirmPurchaseBuyButtonRobuxPrice = arg20.ConfirmPurchaseBuyButtonRobuxPrice
    ConfirmPurchaseBuyButtonRobuxPrice.Visible = v23 <= 0
    arg20.ConfirmPurchaseWarningsOfflineGiftingFrame.Visible = v24
    MonetizationController_m:SetRobuxText(
        arg20.ConfirmPurchaseBuyButtonRobuxPrice,
        arg20._selected_product_id,
        Enum.InfoType.Product
    )
end

function t_1._UpdateFrameVisibility(arg21) -- line: 373
    arg21.BackButton.Visible = if arg21._selected_player_input == nil then false else true
    arg21.SelectPlayerFrame.Visible = not arg21._selected_player_input
    local v28 = arg21._selected_player_input
    local SelectProductFrame = arg21.SelectProductFrame

    if v28 then
        v28 = not arg21._selected_product_id
    end

    SelectProductFrame.Visible = v28
    v28 = arg21._selected_player_input
    local ConfirmPurchaseFrame = arg21.ConfirmPurchaseFrame
    v28 = v28 and arg21._selected_product_id
    ConfirmPurchaseFrame.Visible = v28
    arg21.PlayersList.CanvasPosition = Vector2.new(0, 0)
    arg21.ProductsList.CanvasPosition = Vector2.new(0, 0)
    arg21.ConfirmPurchaseSettingsAnonymousFilled.Visible = false
    arg21.ConfirmPurchaseSettingsAnonymousEmpty.Visible = true
    arg21.ConfirmPurchaseSettingsCustomNoteBox.Text = ""
    arg21.ConfirmPurchaseSettingsNoteDropdownButtonTitle.Text = "Surprise!"
    arg21:_UpdateProducts()
    arg21:_UpdateConfirmPurchasePage()
end

function t_1._UpdateProducts(arg22) -- line: 391
    -- upvalues:
    --  [1] PlayerDataController_m (copy)
    --  [2] SeasonLibrary_m (copy)
    --  [3] MonetizationLibrary_m (copy)
    --  [4] CONSTANTS_m (copy)

    if not arg22._selected_player_input or arg22._selected_product_id then
        return
    end

    local v29 = PlayerDataController_m:Get("GiftTickets")

    for key_1, val_1 in pairs(arg22._gift_slots) do
        local v30 = v29[key_1] or 0
        val_1.Slot.Button.GiftTicket.Visible = v30 > 0 and true
        val_1.Slot.Button.GiftTicket.Quantity.Text = "\195\151" .. v30
        local v31 = arg22._selected_player_lookup
        local Slot = val_1.Slot

        if v31 then
            v31 = arg22._selected_player_lookup.CanReceiveGifts
            v31 = v31 and (if val_1.Info.GiftType ~= "Gamepass" then if val_1.Info.GiftName ~= "BattlePassLevels10" then if val_1.Info.GiftName ~= "primeseason_bundle" then val_1.Info.GiftName ~= "contrabandseason_bundle" or not arg22._selected_player_lookup.CurrentSeasonSeasonPassBundleOwned else arg22._selected_player_lookup.CurrentSeasonMaxPassTrackNum < MonetizationLibrary_m.Bundles.primeseason_bundle.BattlePassMaxPassTrackNum and (val_1.Info.GiftName ~= "contrabandseason_bundle" or not arg22._selected_player_lookup.CurrentSeasonSeasonPassBundleOwned) else arg22._selected_player_lookup.CurrentSeasonPassLevel < SeasonLibrary_m.CurrentSeason.NumBattlePassTiers and (if val_1.Info.GiftName ~= "primeseason_bundle" then val_1.Info.GiftName ~= "contrabandseason_bundle" or not arg22._selected_player_lookup.CurrentSeasonSeasonPassBundleOwned else arg22._selected_player_lookup.CurrentSeasonMaxPassTrackNum < MonetizationLibrary_m.Bundles.primeseason_bundle.BattlePassMaxPassTrackNum and (val_1.Info.GiftName ~= "contrabandseason_bundle" or not arg22._selected_player_lookup.CurrentSeasonSeasonPassBundleOwned)) else not arg22._selected_player_lookup.GamepassesOwned[val_1.Info.GiftName] and (if val_1.Info.GiftName ~= "BattlePassLevels10" then if val_1.Info.GiftName ~= "primeseason_bundle" then val_1.Info.GiftName ~= "contrabandseason_bundle" or not arg22._selected_player_lookup.CurrentSeasonSeasonPassBundleOwned else arg22._selected_player_lookup.CurrentSeasonMaxPassTrackNum < MonetizationLibrary_m.Bundles.primeseason_bundle.BattlePassMaxPassTrackNum and (val_1.Info.GiftName ~= "contrabandseason_bundle" or not arg22._selected_player_lookup.CurrentSeasonSeasonPassBundleOwned) else arg22._selected_player_lookup.CurrentSeasonPassLevel < SeasonLibrary_m.CurrentSeason.NumBattlePassTiers and (if val_1.Info.GiftName ~= "primeseason_bundle" then val_1.Info.GiftName ~= "contrabandseason_bundle" or not arg22._selected_player_lookup.CurrentSeasonSeasonPassBundleOwned else arg22._selected_player_lookup.CurrentSeasonMaxPassTrackNum < MonetizationLibrary_m.Bundles.primeseason_bundle.BattlePassMaxPassTrackNum and (val_1.Info.GiftName ~= "contrabandseason_bundle" or not arg22._selected_player_lookup.CurrentSeasonSeasonPassBundleOwned))))
        end

        Slot.Visible = v31
    end

    local v32 = arg22._selected_player_lookup
    local ProductsEmptyFrame = arg22.ProductsEmptyFrame
    v32 = v32 and not arg22._selected_player_lookup.CanReceiveGifts
    ProductsEmptyFrame.Visible = v32
    arg22.ProductsPlayerFrame.Visible = not arg22.ProductsEmptyFrame.Visible
    local ProductsPlayerPicture = arg22.ProductsPlayerPicture
    v32 = if arg22._selected_player_lookup then string.format(
        CONSTANTS_m.HEADSHOT_IMAGE,
        arg22._selected_player_lookup.UserID
    ) else ""
    ProductsPlayerPicture.Image = v32
    local ProductsPlayerUsernameText = arg22.ProductsPlayerUsernameText
    v32 = if not arg22._selected_player_lookup then "" else if not arg22._selected_player_lookup.DisplayName then "" else if arg22._selected_player_lookup.DisplayName == arg22._selected_player_lookup.Name then "" else "@" .. arg22._selected_player_lookup.Name
    ProductsPlayerUsernameText.Text = v32
    local ProductsPlayerDisplayNameText = arg22.ProductsPlayerDisplayNameText
    v32 = if not arg22._selected_player_lookup then "" else arg22._selected_player_lookup.DisplayName or "@" .. arg22._selected_player_lookup.Name
    ProductsPlayerDisplayNameText.Text = v32
    local ProductsPlayerDisplayNameText_1 = arg22.ProductsPlayerDisplayNameText
    v32 = if arg22.ProductsPlayerUsernameText.Text ~= "" then UDim2.new(0.15, 0, 0.4, 0) else UDim2.new(
        0.15,
        0,
        0.5,
        0
    ) or UDim2.new(0.15, 0, 0.4, 0)
    ProductsPlayerDisplayNameText_1.Position = v32
end

function t_1._GeneratePlayers(arg23) -- line: 420
    -- upvalues:
    --  [1] Players (copy)
    --  [2] Utility_m (copy)
    --  [3] CONSTANTS_m (copy)
    --  [4] GiftPlayerSlot (copy)
    --  [5] ButtonEffect_m (copy)
    --  [6] GiftPlayerEmptySlot (copy)

    for _, val_2 in pairs(arg23._player_slots) do
        val_2:Destroy()
    end

    arg23._player_slots = {}
    arg23._generate_hash += 1
    local GenerateHash = arg23._generate_hash
    local players = Players:GetPlayers()
    table.sort(players, function(arg24, arg25) -- line: 431
        -- upvalues:
        --  [1] Utility_m (ref)

        return Utility_m:StringLessThan(arg24.DisplayName, arg25.DisplayName)
    end)
    local index_1 = table.find(players, Players.LocalPlayer)

    if index_1 then
        table.remove(players, index_1)
    end

    table.insert(players, 1, Players.LocalPlayer)

    for key_3, val_3 in pairs(players) do
        if val_3 ~= Players.LocalPlayer or CONSTANTS_m.IS_STUDIO then
            local v33 = GiftPlayerSlot:Clone()
            v33.Username.Text = if val_3.DisplayName == val_3.Name then "" else "@" .. val_3.Name
            v33.DisplayName.Text = val_3.DisplayName
            local DisplayName = v33.DisplayName
            local v35 = if v33.Username.Text ~= "" then UDim2.new(0.175, 0, 0.4, 0) else UDim2.new(
                0.175,
                0,
                0.5,
                0
            ) or UDim2.new(0.175, 0, 0.4, 0)
            DisplayName.Position = v35
            v33.Icon.Image = string.format(CONSTANTS_m.HEADSHOT_IMAGE, val_3.UserId)
            v33.LayoutOrder = key_3
            v33.Parent = arg23.PlayersContainer
            ButtonEffect_m:Add(v33.Button)
            table.insert(arg23._player_slots, v33)
            v33.Button.MouseButton1Click:Connect(function() -- line: 458
                -- upvalues:
                --  [1] arg23 (copy)
                --  [2] val_3 (copy)

                arg23:SelectPlayer(val_3)
            end)

            if GenerateHash ~= arg23._generate_hash then
                return
            end
        end
    end

    for _ = #arg23._player_slots + 1, 6 do
        local v36 = GiftPlayerEmptySlot:Clone()
        v36.Parent = arg23.PlayersContainer
        table.insert(arg23._player_slots, v36)

        if GenerateHash ~= arg23._generate_hash then
            return
        end
    end

    if
        typeof(arg23._selected_player_input) == "Instance"
        and arg23._selected_player_input.Parent ~= Players
    then
        arg23:SelectPlayer(nil)
    end
end

function t_1._Setup(arg26) -- line: 486
    -- upvalues:
    --  [1] MonetizationLibrary_m (copy)
    --  [2] GiftProductSlot (copy)
    --  [3] ButtonEffect_m (copy)
    --  [4] RewardSlot_m (copy)

    for key_4, val_4 in pairs(MonetizationLibrary_m.GiftOrder) do
        local v37 = MonetizationLibrary_m.Gifts[val_4]
        local v38 = GiftProductSlot:Clone()
        v38.Icon.Image = ""
        v38.DisplayName.Text = v37.DisplayName
        v38.LayoutOrder = key_4
        v38.Parent = arg26.ProductsContainer
        ButtonEffect_m:Add(v38.Button)
        v38.Button.MouseButton1Click:Connect(function() -- line: 497
            -- upvalues:
            --  [1] arg26 (copy)
            --  [2] v37 (copy)

            arg26:SelectProduct(v37.ProductID)
        end)
        arg26._gift_slots[val_4] = { Slot = v38, Info = v37 }
    end

    RewardSlot_m.new(
        { Name = MonetizationLibrary_m.GIFT_REWARD_DATA, Quantity = 1, Weapon = "IsRandom" }
    ):SetParent(arg26.PlayersGiftRewardContainer)
end

function t_1._Init(arg27) -- line: 510
    -- upvalues:
    --  [1] PlayerDataController_m (copy)
    --  [2] MonetizationController_m (copy)
    --  [3] ButtonEffect_m (copy)

    arg27.CloseButton.MouseButton1Click:Connect(function() -- line: 511
        -- upvalues:
        --  [1] arg27 (copy)

        arg27:CloseRequest()
    end)
    arg27.BackButton.MouseButton1Click:Connect(function() -- line: 515
        -- upvalues:
        --  [1] arg27 (copy)

        if arg27._selected_product_id then
            arg27:SelectProduct(nil)

            return
        end

        if arg27._selected_player_input then
            arg27:SelectPlayer(nil)
        end
    end)
    arg27.ConfirmPurchaseBuyButton.MouseButton1Click:Connect(function() -- line: 523
        -- upvalues:
        --  [1] arg27 (copy)

        arg27:ConfirmPurchase()
    end)
    arg27.ConfirmPurchaseSettingsLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() -- line: 527
        -- upvalues:
        --  [1] arg27 (copy)

        arg27.ConfirmPurchaseSettingsFrame.Size = UDim2.new(
            1,
            0,
            0,
            arg27.ConfirmPurchaseSettingsLayout.AbsoluteContentSize.Y
        )
    end)
    arg27.PlayersLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() -- line: 531
        -- upvalues:
        --  [1] arg27 (copy)

        arg27.PlayersList.CanvasSize = UDim2.new(0, 0, 0, arg27.PlayersLayout.AbsoluteContentSize.Y)
    end)
    arg27.ProductsLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() -- line: 535
        -- upvalues:
        --  [1] arg27 (copy)

        arg27.ProductsList.CanvasSize = UDim2.new(
            0,
            0,
            0,
            arg27.ProductsLayout.AbsoluteContentSize.Y
        )
    end)
    arg27.ConfirmPurchaseLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() -- line: 539
        -- upvalues:
        --  [1] arg27 (copy)

        arg27.ConfirmPurchaseList.CanvasSize = UDim2.new(
            0,
            0,
            0,
            arg27.ConfirmPurchaseLayout.AbsoluteContentSize.Y
        )
    end)
    arg27.ConfirmPurchaseSettingsNoteDropdownButtonTitle:GetPropertyChangedSignal("Text"):Connect(
        function() -- line: 543
            -- upvalues:
            --  [1] arg27 (copy)

            local ConfirmPurchaseSettingsCustomNoteFrame = arg27.ConfirmPurchaseSettingsCustomNoteFrame
            ConfirmPurchaseSettingsCustomNoteFrame.Visible = arg27.ConfirmPurchaseSettingsNoteDropdownButtonTitle.Text == "Custom"
        end
    )
    arg27.PlayersOfflineGiftBox:GetPropertyChangedSignal("Text"):Connect(function() -- line: 547
        -- upvalues:
        --  [1] arg27 (copy)

        arg27:_UpdateOfflineGiftingButton()
    end)
    arg27.PlayersOfflineGiftButtonIcon:GetPropertyChangedSignal("Visible"):Connect(function() -- line: 551
        -- upvalues:
        --  [1] arg27 (copy)

        arg27:_UpdateOfflineGiftingButton()
    end)
    arg27.PlayersOfflineGiftButton.MouseButton1Click:Connect(function() -- line: 555
        -- upvalues:
        --  [1] arg27 (copy)

        if
            not arg27.PlayersOfflineGiftButtonOn.Visible
            or not arg27.PlayersOfflineGiftButtonIcon.Visible
        then
            return
        end

        local Text_3 = arg27.PlayersOfflineGiftBox.Text
        task.defer(arg27._OfflineGiftingCooldown, arg27)
        arg27.PlayersOfflineGiftBox.Text = ""
        arg27:SelectPlayer(Text_3)
    end)
    arg27.ConfirmPurchaseSettingsCustomNoteBox:GetPropertyChangedSignal("Text"):Connect(function() -- line: 567
        -- upvalues:
        --  [1] arg27 (copy)

        arg27:_VerifyNote()
    end)
    arg27.ConfirmPurchaseSettingsAnonymousButton.MouseButton1Click:Connect(function() -- line: 571
        -- upvalues:
        --  [1] arg27 (copy)

        arg27.ConfirmPurchaseSettingsAnonymousEmpty.Visible = not arg27.ConfirmPurchaseSettingsAnonymousEmpty.Visible
        arg27.ConfirmPurchaseSettingsAnonymousFilled.Visible = not arg27.ConfirmPurchaseSettingsAnonymousEmpty.Visible
    end)
    arg27.ConfirmPurchaseSettingsNoteDropdownButton.MouseButton1Click:Connect(function() -- line: 576
        -- upvalues:
        --  [1] arg27 (copy)

        arg27:_StartNoteDropdown()
    end)
    PlayerDataController_m:GetDataChangedSignal("GiftTickets"):Connect(function() -- line: 580
        -- upvalues:
        --  [1] arg27 (copy)

        arg27:_UpdateProducts()
    end)
    PlayerDataController_m:GetDataChangedSignal("GiftRobuxSpentProgress"):Connect(function() -- line: 585
        -- upvalues:
        --  [1] arg27 (copy)

        arg27:_UpdateGiftReward()
    end)
    PlayerDataController_m:GetDataChangedSignal("GiftRobuxSpentRewardsClaimed"):Connect(function() -- line: 589
        -- upvalues:
        --  [1] arg27 (copy)

        arg27:_UpdateGiftReward()
    end)
    MonetizationController_m.PurchaseFinished:Connect(function() -- line: 593
        -- upvalues:
        --  [1] arg27 (copy)

        arg27:SelectPlayer(nil)
    end)
    arg27:_Setup()
    arg27:SelectPlayer(nil)
    arg27:_UpdateGiftReward()
    ButtonEffect_m:Add(arg27.BackButton)
    ButtonEffect_m:Add(arg27.CloseButton)
    ButtonEffect_m:Add(arg27.PlayersOfflineGiftButton)
    ButtonEffect_m:Add(arg27.ConfirmPurchaseSettingsAnonymousButton)
    local t_5 = { HoverRatio = UDim2.new(0, 10, 0, 10), ReleaseRatio = UDim2.new(0, 10, 0, 10) }
    ButtonEffect_m:Add(arg27.ConfirmPurchaseBuyButton, nil, t_5)
    ButtonEffect_m:Add(
        arg27.ConfirmPurchaseSettingsNoteDropdownButton,
        nil,
        { ReleaseRatio = 1.025, HoverRatio = 1.025 }
    )
end

return t_1._new()
