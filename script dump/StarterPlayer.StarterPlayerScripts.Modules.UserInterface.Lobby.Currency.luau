local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")
local _ = require(ReplicatedStorage.Modules.CONSTANTS)
local CurrencyLibrary_m = require(ReplicatedStorage.Modules.CurrencyLibrary)
local EventLibrary_m = require(ReplicatedStorage.Modules.EventLibrary)
local _ = require(ReplicatedStorage.Modules.ItemLibrary)
local TaskLibrary_m = require(ReplicatedStorage.Modules.TaskLibrary)
local TestLibrary_m = require(ReplicatedStorage.Modules.TestLibrary)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local PlayerDataController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("PlayerDataController")
)
local Matchmaking_m = require(
    Players.LocalPlayer.PlayerScripts.Modules.UserInterface.Lobby:WaitForChild("Matchmaking")
)
local MobileInputs_m = require(
    Players.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("MobileInputs")
)
local Teleporting_m = require(
    Players.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("Teleporting")
)
local Equipment_m = require(
    Players.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("Equipment")
)
local Queue_m = require(
    Players.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("Queue")
)
local Pages_m = require(
    Players.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("Pages")
)
local ButtonEffect_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("ButtonEffect")
)
local UILibrary_m = require(Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("UILibrary"))
local StudioSkipOnboarding = TestLibrary_m:GetTestAttribute("StudioSkipOnboarding")
local CurrencySlot = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("CurrencySlot")
local t = { EventCurrency = true, SkinTickets = true }
local t_1 = { Shop = true, EventOverview = true, StreakRecovery = true }
local t_2 = {}
t_2.__index = t_2

function t_2._new() -- line: 31
    -- upvalues:
    --  [1] t_2 (copy)
    --  [2] UILibrary_m (copy)

    local t_3 = setmetatable({}, t_2)
    t_3.Frame = UILibrary_m:GetTo("MainFrame", "Lobby", "Currency")
    t_3.Container = t_3.Frame:WaitForChild("Container")
    t_3._is_open = false
    t_3._is_shrinked = false
    t_3._currency_slots = {}
    t_3._setup_update_slots_logic = false
    t_3._scrolled_up_hooked = {}
    t_3._scrolled_up = {}
    t_3._keys_bubble = nil
    t_3._keys_bubble_hash = 0
    t_3:_Init()

    return t_3
end

function t_2._UpdateOnboardingBubble(arg1) -- line: 61
    -- upvalues:
    --  [1] StudioSkipOnboarding (copy)
    --  [2] PlayerDataController_m (copy)
    --  [3] TaskLibrary_m (copy)
    --  [4] Players (copy)

    if not arg1._keys_bubble or StudioSkipOnboarding then
        return
    end

    local v11 = PlayerDataController_m:Get("BeginnerTasksCompleted") >= TaskLibrary_m.NUM_BEGINNER_TASKS and true
    local v12 = arg1._is_open
    local KeysBubble = arg1._keys_bubble

    if v12 then
        v12 = not arg1._is_shrinked

        if v12 then
            v12 = not v11

            if v12 then
                v12 = PlayerDataController_m:GetStatistic("StatisticDuelsPlayed") >= 2 and true
            end
        end
    end

    KeysBubble.Visible = v12
    arg1._keys_bubble_hash += 1

    if not arg1._keys_bubble.Visible then
        return
    end

    local KeysBubbleHash = arg1._keys_bubble_hash
    task.spawn(function() -- line: 78
        -- upvalues:
        --  [1] KeysBubbleHash (copy)
        --  [2] arg1 (copy)
        --  [3] Players (ref)

        while true do
            if KeysBubbleHash ~= arg1._keys_bubble_hash then
                return
            end

            if arg1._keys_bubble:IsDescendantOf(Players) then
                arg1._keys_bubble:TweenPosition(
                    UDim2.new(0.5, 0, 1, 0),
                    "Out",
                    "Sine",
                    0.5,
                    true
                )
            end

            wait(0.5)

            if KeysBubbleHash ~= arg1._keys_bubble_hash then
                return
            end

            if arg1._keys_bubble:IsDescendantOf(Players) then
                arg1._keys_bubble:TweenPosition(
                    UDim2.new(0.5, 0, 0.875, 0),
                    "In",
                    "Sine",
                    0.5,
                    true
                )
            end

            wait(0.5)
        end
    end)
end

function t_2._IsScrolledUp(arg2) -- line: 103
    for _, val in pairs(arg2._scrolled_up) do
        if val then
            return true
        end
    end
end

function t_2._UpdateVisibility(arg3) -- line: 111
    -- upvalues:
    --  [1] Pages_m (copy)
    --  [2] t_1 (copy)
    --  [3] Matchmaking_m (copy)
    --  [4] Equipment_m (copy)
    --  [5] Queue_m (copy)
    --  [6] Teleporting_m (copy)
    --  [7] MobileInputs_m (copy)
    --  [8] GuiService (copy)
    --  [9] Players (copy)

    local v14

    if Pages_m.PageSystem.CurrentPage then
        if Pages_m.PageSystem.CurrentPage.Name ~= "StreakRecovery" then
            v14 = t_1[Pages_m.PageSystem.CurrentPage.Name]

            if v14 then
                v14 = not Matchmaking_m:IsOpened()

                if v14 then
                    v14 = not Equipment_m:IsUnlocking()

                    if v14 then
                        v14 = not Equipment_m:IsCustomizing()

                        if v14 then
                            if Equipment_m.IsOpen then
                                v14 = Equipment_m:IsOpenEffectDone()

                                if v14 then
                                    v14 = not Queue_m:IsVisible()

                                    if v14 then
                                        v14 = not Teleporting_m.Enabled

                                        if v14 then
                                            v14 = not MobileInputs_m.EditorEnabled

                                            if v14 then
                                                v14 = not GuiService.MenuIsOpen

                                                if v14 then
                                                    v14 = not arg3:_IsScrolledUp()
                                                end
                                            end
                                        end
                                    end
                                end
                            else
                                v14 = not Queue_m:IsVisible()

                                if v14 then
                                    v14 = not Teleporting_m.Enabled

                                    if v14 then
                                        v14 = not MobileInputs_m.EditorEnabled

                                        if v14 then
                                            v14 = not GuiService.MenuIsOpen

                                            if v14 then
                                                v14 = not arg3:_IsScrolledUp()
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        else
            v14 = not Matchmaking_m:IsOpened()

            if v14 then
                v14 = not Equipment_m:IsUnlocking()

                if v14 then
                    v14 = not Equipment_m:IsCustomizing()

                    if v14 then
                        if Equipment_m.IsOpen then
                            v14 = Equipment_m:IsOpenEffectDone()

                            if v14 then
                                v14 = not Queue_m:IsVisible()

                                if v14 then
                                    v14 = not Teleporting_m.Enabled

                                    if v14 then
                                        v14 = not MobileInputs_m.EditorEnabled

                                        if v14 then
                                            v14 = not GuiService.MenuIsOpen

                                            if v14 then
                                                v14 = not arg3:_IsScrolledUp()
                                            end
                                        end
                                    end
                                end
                            end
                        else
                            v14 = not Queue_m:IsVisible()

                            if v14 then
                                v14 = not Teleporting_m.Enabled

                                if v14 then
                                    v14 = not MobileInputs_m.EditorEnabled

                                    if v14 then
                                        v14 = not GuiService.MenuIsOpen

                                        if v14 then
                                            v14 = not arg3:_IsScrolledUp()
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    else
        v14 = not Matchmaking_m:IsOpened()

        if v14 then
            v14 = not Equipment_m:IsUnlocking()

            if v14 then
                v14 = not Equipment_m:IsCustomizing()

                if v14 then
                    if Equipment_m.IsOpen then
                        v14 = Equipment_m:IsOpenEffectDone()

                        if v14 then
                            v14 = not Queue_m:IsVisible()

                            if v14 then
                                v14 = not Teleporting_m.Enabled

                                if v14 then
                                    v14 = not MobileInputs_m.EditorEnabled

                                    if v14 then
                                        v14 = not GuiService.MenuIsOpen

                                        if v14 then
                                            v14 = not arg3:_IsScrolledUp()
                                        end
                                    end
                                end
                            end
                        end
                    else
                        v14 = not Queue_m:IsVisible()

                        if v14 then
                            v14 = not Teleporting_m.Enabled

                            if v14 then
                                v14 = not MobileInputs_m.EditorEnabled

                                if v14 then
                                    v14 = not GuiService.MenuIsOpen

                                    if v14 then
                                        v14 = not arg3:_IsScrolledUp()
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    arg3._is_open = v14
    arg3._is_shrinked = false

    if arg3.Container:IsDescendantOf(Players) then
        local Container = arg3.Container
        local v15 = arg3._is_open and UDim2.new(0.5, 0, 0, 0) or UDim2.new(0.5, 0, -0.15, -30)
        Container:TweenPosition(
            v15,
            "Out",
            "Quint",
            0.25,
            true
        )
        local Container_1 = arg3.Container
        v15 = arg3._is_shrinked and UDim2.new(0.0375, 20, 0.0375, 20) or UDim2.new(
            0.075,
            40,
            0.075,
            40
        )
        Container_1:TweenSize(
            v15,
            "Out",
            "Quint",
            0.25,
            true
        )
    end

    arg3:_UpdateOnboardingBubble()
end

function t_2._UpdateSlots(arg4) -- line: 126
    -- upvalues:
    --  [1] Pages_m (copy)
    --  [2] CurrencyLibrary_m (copy)
    --  [3] PlayerDataController_m (copy)
    --  [4] t (copy)
    --  [5] Utility_m (copy)

    local Shop = Pages_m.PageSystem:GetPage("Shop")
    local v16 = Shop

    if v16 then
        v16 = Shop:IsOpen()
    end

    local v17 = v16 and Shop.CurrentPage == "Ranked"
    local EventOverview = Pages_m.PageSystem:GetPage("EventOverview")
    local v18 = EventOverview

    if v18 then
        v18 = EventOverview:IsOpen()
    end

    for key_1, val_1 in pairs(arg4._currency_slots) do
        local v19 = CurrencyLibrary_m.Info[key_1]
        local v20 = PlayerDataController_m:Get(v19.DataName) or 0
        local v21 = if v19.OnlyDisplayAboveZeroBalance then v20 > 0 and (if key_1 ~= "Glory" then if key_1 == "Glory" then false else not v17 and (v16 or key_1 == "WeaponKeys" or v18 and t[key_1]) else if v17 then v16 or key_1 == "WeaponKeys" or v18 and t[key_1] else if key_1 == "Glory" then false else not v17 and (v16 or key_1 == "WeaponKeys" or v18 and t[key_1])) else if key_1 ~= "Glory" then if key_1 == "Glory" then false else not v17 and (v16 or key_1 == "WeaponKeys" or v18 and t[key_1]) else if v17 then v16 or key_1 == "WeaponKeys" or v18 and t[key_1] else if key_1 == "Glory" then false else not v17 and (v16 or key_1 == "WeaponKeys" or v18 and t[key_1])
        val_1.Visible = v21
        val_1.Title.Text = Utility_m:PrettyNumber(v20)
    end
end

function t_2._SetupUpdateSlotsLogic(arg5) -- line: 146
    -- upvalues:
    --  [1] Pages_m (copy)

    if arg5._setup_update_slots_logic then
        return
    end

    arg5._setup_update_slots_logic = true
    task.spawn(function() -- line: 153
        -- upvalues:
        --  [1] Pages_m (ref)
        --  [2] arg5 (copy)

        Pages_m.PageSystem:WaitForPage("EventOverview").OpenChanged:Connect(function() -- line: 156
            -- upvalues:
            --  [1] arg5 (ref)

            arg5:_UpdateSlots()
        end)
        arg5:_UpdateSlots()
    end)
    task.spawn(function() -- line: 163
        -- upvalues:
        --  [1] Pages_m (ref)
        --  [2] arg5 (copy)

        local v22 = Pages_m.PageSystem:WaitForPage("Shop")
        v22.OpenChanged:Connect(function() -- line: 166
            -- upvalues:
            --  [1] arg5 (ref)

            arg5:_UpdateSlots()
        end)
        v22.CurrentPageChanged:Connect(function() -- line: 170
            -- upvalues:
            --  [1] arg5 (ref)

            arg5:_UpdateSlots()
        end)
        arg5:_UpdateSlots()
    end)
end

function t_2._SetupScrollUpLogic(arg6, arg7) -- line: 178
    -- upvalues:
    --  [1] Pages_m (copy)

    if arg6._scrolled_up_hooked[arg7] then
        return
    end

    arg6._scrolled_up_hooked[arg7] = true
    local v23 = Pages_m.PageSystem:WaitForPage(arg7)
    v23.OpenChanged:Connect(function() -- line: 187
        -- upvalues:
        --  [1] v23 (copy)
        --  [2] arg6 (copy)
        --  [3] arg7 (copy)

        if not v23:IsOpen() then
            arg6._scrolled_up[arg7] = false
        end
    end)
    v23.List:GetPropertyChangedSignal("CanvasPosition"):Connect(function() -- line: 193
        -- upvalues:
        --  [1] v23 (copy)
        --  [2] arg6 (copy)
        --  [3] arg7 (copy)

        if
            not v23:IsOpen()
            or (if not (v23.List.CanvasPosition.Y > 10) then v23.List.CanvasPosition.Y <= 10 and not arg6._scrolled_up[arg7] else arg6._scrolled_up[arg7] or v23.List.CanvasPosition.Y <= 10 and not arg6._scrolled_up[arg7])
        then
            return
        end

        local ScrolledUp = arg6._scrolled_up
        local v24 = arg7
        ScrolledUp[v24] = v23.List.CanvasPosition.Y > 10
        arg6:_UpdateVisibility()
    end)
    arg6:_UpdateVisibility()
end

function t_2._Setup(arg8) -- line: 206
    -- upvalues:
    --  [1] CurrencyLibrary_m (copy)
    --  [2] EventLibrary_m (copy)
    --  [3] CurrencySlot (copy)
    --  [4] PlayerDataController_m (copy)
    --  [5] Pages_m (copy)
    --  [6] ButtonEffect_m (copy)

    for key_2, val_2 in pairs(CurrencyLibrary_m.Order) do
        local v26 = CurrencyLibrary_m.Info[val_2]

        if not v26.IsHidden and (val_2 ~= "EventCurrency" or EventLibrary_m.IS_ACTIVE) then
            local v27 = CurrencySlot:Clone()
            v27.LayoutOrder = key_2
            v27.Icon.Icon.Image = v26.Image
            v27.Buy.Visible = v26.CanBePurchasedWithRobux
            v27.Parent = arg8.Container
            arg8._currency_slots[val_2] = v27
            PlayerDataController_m:GetDataChangedSignal(v26.DataName):Connect(function() -- line: 221
                -- upvalues:
                --  [1] arg8 (copy)

                arg8:_UpdateSlots()
            end)
            v27.Buy.MouseButton1Click:Connect(function() -- line: 225
                -- upvalues:
                --  [1] Pages_m (ref)

                Pages_m.PageSystem:OpenPage("Shop", true)
                Pages_m.PageSystem:WaitForPage("Shop"):SetPage("Currency")
            end)
            ButtonEffect_m:Add(v27.Buy)

            if val_2 == "WeaponKeys" then
                arg8._keys_bubble = v27.Icon.Bubble
                v27.Icon.MouseButton1Click:Connect(function() -- line: 235
                    -- upvalues:
                    --  [1] Pages_m (ref)

                    Pages_m.PageSystem:OpenPage("Tasks", true)
                end)
                ButtonEffect_m:Add(v27.Icon)
            end
        end
    end
end

function t_2._Init(arg9) -- line: 244
    -- upvalues:
    --  [1] Equipment_m (copy)
    --  [2] Pages_m (copy)
    --  [3] t_1 (copy)
    --  [4] Queue_m (copy)
    --  [5] Teleporting_m (copy)
    --  [6] MobileInputs_m (copy)
    --  [7] Matchmaking_m (copy)
    --  [8] PlayerDataController_m (copy)
    --  [9] GuiService (copy)

    Equipment_m.UnlockingChanged:Connect(function() -- line: 245
        -- upvalues:
        --  [1] arg9 (copy)

        arg9:_UpdateVisibility()
    end)
    Equipment_m.Opened:Connect(function() -- line: 249
        -- upvalues:
        --  [1] arg9 (copy)

        arg9:_UpdateVisibility()
    end)
    Equipment_m.SelectedWeaponChanged:Connect(function() -- line: 253
        -- upvalues:
        --  [1] arg9 (copy)

        arg9:_UpdateVisibility()
    end)
    Equipment_m.CustomizingChanged:Connect(function() -- line: 257
        -- upvalues:
        --  [1] arg9 (copy)

        arg9:_UpdateVisibility()
    end)
    Equipment_m.FinishedOpenEffect:Connect(function() -- line: 261
        -- upvalues:
        --  [1] arg9 (copy)

        arg9:_UpdateVisibility()
    end)
    Pages_m.PageSystem.PageOpened:Connect(function(arg10) -- line: 265
        -- upvalues:
        --  [1] t_1 (ref)
        --  [2] arg9 (copy)

        if t_1[arg10.Name] then
            task.spawn(arg9._SetupScrollUpLogic, arg9, arg10.Name)
            task.spawn(arg9._SetupUpdateSlotsLogic, arg9)
        end

        arg9:_UpdateVisibility()
    end)
    Pages_m.PageSystem.PageClosed:Connect(function() -- line: 274
        -- upvalues:
        --  [1] arg9 (copy)

        arg9:_UpdateVisibility()
    end)
    Queue_m.VisibilityChanged:Connect(function() -- line: 278
        -- upvalues:
        --  [1] arg9 (copy)

        arg9:_UpdateVisibility()
    end)
    Teleporting_m.EnabledChanged:Connect(function() -- line: 282
        -- upvalues:
        --  [1] arg9 (copy)

        arg9:_UpdateVisibility()
    end)
    MobileInputs_m.EditorEnabledChanged:Connect(function() -- line: 286
        -- upvalues:
        --  [1] arg9 (copy)

        arg9:_UpdateVisibility()
    end)
    Matchmaking_m.OpenedChanged:Connect(function() -- line: 290
        -- upvalues:
        --  [1] arg9 (copy)

        arg9:_UpdateVisibility()
    end)
    PlayerDataController_m:GetDataChangedSignal("BeginnerTasksCompleted"):Connect(function() -- line: 294
        -- upvalues:
        --  [1] arg9 (copy)

        arg9:_UpdateOnboardingBubble()
    end)
    PlayerDataController_m:GetDataChangedSignal("StatisticDuelsPlayed"):Connect(function() -- line: 298
        -- upvalues:
        --  [1] arg9 (copy)

        arg9:_UpdateOnboardingBubble()
        arg9:_UpdateSlots()
    end)
    GuiService:GetPropertyChangedSignal("MenuIsOpen"):Connect(function() -- line: 303
        -- upvalues:
        --  [1] arg9 (copy)

        arg9:_UpdateVisibility()
    end)
    arg9:_Setup()
    arg9:_UpdateSlots()
    arg9:_UpdateVisibility()
    arg9:_UpdateOnboardingBubble()
end

return t_2._new()
