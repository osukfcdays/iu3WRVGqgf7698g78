local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local _ = require(ReplicatedStorage.Modules.CONSTANTS)
local _ = require(ReplicatedStorage.Modules.SeasonLibrary)
local EventLibrary_m = require(ReplicatedStorage.Modules.EventLibrary)
local PlayerDataController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.PlayerDataController
)
local FighterController_m = require(Players.LocalPlayer.PlayerScripts.Controllers.FighterController)
local SeasonController_m = require(Players.LocalPlayer.PlayerScripts.Controllers.SeasonController)
local ShopController_m = require(Players.LocalPlayer.PlayerScripts.Controllers.ShopController)
local ButtonEffect_m = require(Players.LocalPlayer.PlayerScripts.Modules.ButtonEffect)
local udim2 = UDim2.new(0.125, 0, 0.875, 0)
local t = {}
t.__index = t

function t.new(arg1) -- line: 19
    -- upvalues:
    --  [1] t (copy)

    local t_1 = setmetatable({}, t)
    t_1.Shop = arg1
    t_1.Frame = t_1.Shop.Container:WaitForChild("Tabs")
    t_1.CloseButton = t_1.Frame:WaitForChild("Close")
    t_1.RankedButton = t_1.Frame:WaitForChild("Ranked")
    t_1.CurrencyButton = t_1.Frame:WaitForChild("Currency")
    t_1.CurrencyIcon = t_1.CurrencyButton:WaitForChild("Icon")
    t_1.CurrencyEventIcon = t_1.CurrencyButton:WaitForChild("EventIcon")
    t_1.WeaponsButton = t_1.Frame:WaitForChild("Weapons")
    t_1.GiftingButton = t_1.Frame:WaitForChild("Gifting")
    t_1.RewardsButton = t_1.Frame:WaitForChild("Rewards")
    t_1.MoreButton = t_1.Frame:WaitForChild("More")
    t_1.LessButton = t_1.Frame:WaitForChild("Less")
    t_1._buttons = {}
    t_1._more_buttons_visible = false
    t_1:_Init()

    return t_1
end

function t.Open(arg2) -- line: 47
    arg2:_CloseMoreTabs()
end

function t.Close(arg3) -- line: 51
    arg3:_CloseMoreTabs()
end

function t.Setup(arg4) -- line: 55
    arg4:_CloseMoreTabs()
end

function t._OpenMoreTabs(arg5) -- line: 63
    -- upvalues:
    --  [1] udim2 (copy)

    arg5._more_buttons_visible = true

    for _, val in pairs(arg5._buttons) do
        val.Visible = false
    end

    arg5.MoreButton.Visible = false
    arg5.LessButton.Visible = true

    for _, val_1 in pairs(
        { arg5.RankedButton, arg5.WeaponsButton, arg5.GiftingButton, arg5.RewardsButton }
    ) do
        val_1.Size = UDim2.new(udim2.X.Scale * 0.5, 0, udim2.Y.Scale * 0.5, 0)
        val_1:TweenSize(
            udim2,
            "Out",
            "Quint",
            0.25,
            true
        )
        val_1.Visible = true
    end

    arg5:_UpdateVisibility()
end

function t._CloseMoreTabs(arg6) -- line: 82
    -- upvalues:
    --  [1] udim2 (copy)

    arg6._more_buttons_visible = false

    for _, val_2 in pairs(arg6._buttons) do
        val_2.Size = UDim2.new(udim2.X.Scale * 0.5, 0, udim2.Y.Scale * 0.5, 0)
        val_2:TweenSize(
            udim2,
            "Out",
            "Quint",
            0.25,
            true
        )
        val_2.Visible = true
    end

    arg6.MoreButton.Visible = true
    arg6.LessButton.Visible = false
    arg6.WeaponsButton.Visible = false
    arg6.GiftingButton.Visible = false
    arg6.RewardsButton.Visible = false
    arg6.RankedButton.Visible = false
    arg6:_UpdateVisibility()
end

function t._UpdateEvent(arg7) -- line: 101
    -- upvalues:
    --  [1] EventLibrary_m (copy)
    --  [2] PlayerDataController_m (copy)

    local v1 = EventLibrary_m.IS_ACTIVE

    if v1 then
        v1 = PlayerDataController_m:GetStatistic("StatisticDuelsPlayed") >= EventLibrary_m.NUM_GAMES_NEEDED_TO_PARTICIPATE and true
    end

    arg7.CurrencyEventIcon.Visible = v1
    arg7.CurrencyEventIcon.Image = EventLibrary_m.EVENT_DETAILS.CURRENCY_IMAGE
    local CurrencyIcon = arg7.CurrencyIcon
    CurrencyIcon.Position = v1 and UDim2.new(0.4, 0, 0.5, 0) or UDim2.new(0.5, 0, 0.5, 0)
end

function t._UpdateVisibility(arg8) -- line: 109
    -- upvalues:
    --  [1] SeasonController_m (copy)
    --  [2] PlayerDataController_m (copy)

    local v3 = arg8._more_buttons_visible
    local RankedButton = arg8.RankedButton

    if v3 then
        v3 = SeasonController_m:IsRankedUnlocked() or PlayerDataController_m:Get("Glory") > 0 and true
    end

    RankedButton.Visible = v3
    v3 = arg8._more_buttons_visible
    local WeaponsButton = arg8.WeaponsButton

    if v3 then
        v3 = arg8.LocalFighter

        if v3 then
            v3 = not arg8.LocalFighter:Get("IsInShootingRange")

            if v3 then
                v3 = not arg8.LocalFighter:Get("IsInDuel")
            end
        end
    end

    WeaponsButton.Visible = v3
end

function t._Update(arg9) -- line: 114
    -- upvalues:
    --  [1] PlayerDataController_m (copy)
    --  [2] ShopController_m (copy)
    --  [3] ReplicatedStorage (copy)

    for _, val_3 in pairs(arg9.Shop.PAGE_NAMES) do
        local v4 = if val_3 ~= arg9.Shop.CurrentPage then false else true
        local v5 = arg9.Frame:WaitForChild(val_3)
        local Background = v5:WaitForChild("Background")
        local Title = v5:WaitForChild("Title")
        local UIStroke = Title:WaitForChild("UIStroke")
        local v6 = v4 and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(255, 255, 255)
        Title.TextColor3 = v6
        v6 = v4 and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(0, 0, 0)
        UIStroke.Color = v6
        v6 = if not v4 then 0.75 else 0
        UIStroke.Transparency = v6
        v6 = v4 and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(0, 0, 0)
        Background.ImageColor3 = v6
        v6 = if not v4 then 0.25 else 0
        Background.ImageTransparency = v6
        Background:WaitForChild("UIGradient").Enabled = not v4
    end

    if
        arg9.Shop.CurrentPage == "Daily"
        and PlayerDataController_m:Get("LastDailyShopSeen") ~= ShopController_m.DailyShopDay
    then
        ReplicatedStorage.Remotes.Misc.ViewedDailyShop:FireServer()
    end
end

function t._HookLocalFighter(arg10) -- line: 135
    -- upvalues:
    --  [1] FighterController_m (copy)

    arg10.LocalFighter = FighterController_m:WaitForLocalFighter()
    arg10.LocalFighter:GetDataChangedSignal("IsInShootingRange"):Connect(function() -- line: 138
        -- upvalues:
        --  [1] arg10 (copy)

        arg10:_UpdateVisibility()
    end)
    arg10.LocalFighter:GetDataChangedSignal("IsInDuel"):Connect(function() -- line: 142
        -- upvalues:
        --  [1] arg10 (copy)

        arg10:_UpdateVisibility()
    end)
    arg10:_UpdateVisibility()
end

function t._Setup(arg11) -- line: 149
    -- upvalues:
    --  [1] ButtonEffect_m (copy)
    --  [2] PlayerDataController_m (copy)

    for _, val_4 in pairs(arg11.Shop.PAGE_NAMES) do
        local v7 = arg11.Frame:WaitForChild(val_4)
        arg11._buttons[val_4] = v7
        v7.MouseButton1Click:Connect(function() -- line: 154
            -- upvalues:
            --  [1] arg11 (copy)
            --  [2] val_4 (copy)

            arg11.Shop:SetPage(val_4)
        end)
        ButtonEffect_m:Add(v7)

        if val_4 == "Daily" then
            local function update() -- line: 161
                -- upvalues:
                --  [1] v7 (copy)
                --  [2] arg11 (copy)
                --  [3] val_4 (copy)
                --  [4] PlayerDataController_m (ref)

                local v8 = false
                local NotificationBubble = v7.NotificationBubble

                if arg11.Shop.CurrentPage ~= val_4 then
                    v8 = not PlayerDataController_m:Get("ClaimedLoginRewardToday")
                end

                NotificationBubble.Visible = v8
            end

            PlayerDataController_m:GetDataChangedSignal("ClaimedLoginRewardToday"):Connect(update)
            arg11.Shop.CurrentPageChanged:Connect(update)
            local v9 = false
            local NotificationBubble_1 = v7.NotificationBubble

            if arg11.Shop.CurrentPage ~= val_4 then
                v9 = not PlayerDataController_m:Get("ClaimedLoginRewardToday")
            end

            NotificationBubble_1.Visible = v9
        end
    end
end

function t._Init(arg12) -- line: 172
    -- upvalues:
    --  [1] PlayerDataController_m (copy)
    --  [2] ButtonEffect_m (copy)

    arg12.CloseButton.MouseButton1Click:Connect(function() -- line: 173
        -- upvalues:
        --  [1] arg12 (copy)

        arg12.Shop:CloseRequest()
    end)
    arg12.Shop.CurrentPageChanged:Connect(function() -- line: 177
        -- upvalues:
        --  [1] arg12 (copy)

        arg12:_Update()
    end)
    arg12.MoreButton.MouseButton1Click:Connect(function() -- line: 181
        -- upvalues:
        --  [1] arg12 (copy)

        arg12:_OpenMoreTabs()
    end)
    arg12.LessButton.MouseButton1Click:Connect(function() -- line: 185
        -- upvalues:
        --  [1] arg12 (copy)

        arg12:_CloseMoreTabs()
    end)
    PlayerDataController_m:GetDataChangedSignal("StatisticDuelsPlayed"):Connect(function() -- line: 189
        -- upvalues:
        --  [1] arg12 (copy)

        arg12:_UpdateEvent()
    end)
    PlayerDataController_m:GetDataChangedSignal("Glory"):Connect(function() -- line: 193
        -- upvalues:
        --  [1] arg12 (copy)

        arg12:_UpdateVisibility()
    end)
    arg12:_Setup()
    arg12:_UpdateEvent()
    arg12:_UpdateVisibility()
    task.defer(arg12._HookLocalFighter, arg12)
    ButtonEffect_m:Add(arg12.CloseButton)
    ButtonEffect_m:Add(arg12.MoreButton)
    ButtonEffect_m:Add(arg12.LessButton)
end

return t
