local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local ServerOsTime_m = require(ReplicatedStorage.Modules.ServerOsTime)
local LootLibrary_m = require(ReplicatedStorage.Modules.LootLibrary)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local MonetizationController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("MonetizationController")
)
local PlayerDataController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("PlayerDataController")
)
local ButtonEffect_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("ButtonEffect")
)
local Pages_m = require(
    Players.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("Pages")
)
local Page_m = require(Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("Page"))
local StoredStreakSlot = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild(
    "StoredStreakSlot"
)
local t = setmetatable({}, Page_m)
t.__index = t

function t._new() -- line: 19
    -- upvalues:
    --  [1] Page_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(Page_m.new(script.Name), t)
    t_1.CloseButton = t_1.PageFrame:WaitForChild("Close")
    t_1.List = t_1.PageFrame:WaitForChild("List")
    t_1.Container = t_1.List:WaitForChild("Container")
    t_1.Layout = t_1.Container:WaitForChild("Layout")
    t_1._slots = {}
    t_1._countdown_thread = nil
    t_1:_Init()

    return t_1
end

function t.Open(arg1, ...) -- line: 39
    -- upvalues:
    --  [1] Page_m (copy)

    Page_m.Open(arg1, ...)
    arg1:_Generate()
    arg1:_StartCountdownLoop()
end

function t.Close(arg2, ...) -- line: 45
    -- upvalues:
    --  [1] Page_m (copy)

    Page_m.Close(arg2, ...)
    arg2:_StartCountdownLoop()
end

function t._StartCountdownLoop(arg3) -- line: 54
    if arg3._countdown_thread then
        task.cancel(arg3._countdown_thread)
        arg3._countdown_thread = nil
    end

    if not arg3:IsOpen() then
        return
    end

    arg3._countdown_thread = task.spawn(function() -- line: 64
        -- upvalues:
        --  [1] arg3 (copy)

        while true do
            arg3:_UpdateCountdown()
            wait(1)
        end
    end)
end

function t._UpdateCountdown(arg4) -- line: 72
    -- upvalues:
    --  [1] ServerOsTime_m (copy)
    --  [2] Utility_m (copy)

    for _, val in pairs(arg4._slots) do
        local v7 = if not val.StoredStreak.ExpirationTime then nil else val.StoredStreak.ExpirationTime - ServerOsTime_m:GetRounded()
        local Icon = val.Slot.Countdown.Icon
        local v8 = v7 ~= nil
        Icon.Visible = v8
        val.Slot.Countdown.Text = if not v7 then "Oh no, you lost your win streak!" else if v7 <= 0 then "Expired" else Utility_m:TimeFormat2(
            v7
        )
        local Countdown_1 = val.Slot.Countdown
        v8 = if not v7 then Color3.fromRGB(255, 255, 255) else if not (v7 <= 0) then Color3.fromRGB(
            255,
            255,
            255
        ) else Color3.fromRGB(255, 50, 50)
        Countdown_1.TextColor3 = v8
        val.Slot.Countdown.Icon.ImageColor3 = val.Slot.Countdown.TextColor3
    end
end

function t._Generate(arg5) -- line: 83
    -- upvalues:
    --  [1] PlayerDataController_m (copy)
    --  [2] StoredStreakSlot (copy)
    --  [3] Utility_m (copy)
    --  [4] LootLibrary_m (copy)
    --  [5] ButtonEffect_m (copy)
    --  [6] ServerOsTime_m (copy)
    --  [7] Pages_m (copy)
    --  [8] MonetizationController_m (copy)
    --  [9] ReplicatedStorage (copy)

    for _, val_1 in pairs(arg5._slots) do
        val_1.Slot:Destroy()
    end

    arg5._slots = {}

    if not arg5:IsOpen() then
        return
    end

    local v15

    for key_2, val_2 in pairs(PlayerDataController_m:Get("StoredStreaks")) do
        local v10 = StoredStreakSlot:Clone()
        local Value = v10.Streak.Value
        local v11 = Utility_m:PrettyNumber(val_2.Value)
        Value.Text = v11
        local Price = v10.Button.Price
        local v12 = LootLibrary_m:GetRecoverStreakCost(val_2.ConsecutiveRecoveries)
        Price.Text = v12
        v10.LayoutOrder = key_2
        v10.Parent = arg5.Container
        table.insert(arg5._slots, { Slot = v10, StoredStreak = val_2 })
        ButtonEffect_m:Add(v10.Button)
        local Title = v10.Title
        v15 = 0
        v10.Button.MouseButton1Click:Connect(function() -- line: 106
            -- upvalues:
            --  [1] ServerOsTime_m (ref)
            --  [2] val_2 (copy)
            --  [3] Utility_m (ref)
            --  [4] LootLibrary_m (ref)
            --  [5] PlayerDataController_m (ref)
            --  [6] Pages_m (ref)
            --  [7] MonetizationController_m (ref)
            --  [8] arg5 (copy)
            --  [9] Title (copy)
            --  [10] v15 (ref)
            --  [11] ReplicatedStorage (ref)
            --  [12] key_2 (copy)

            if ServerOsTime_m:Get() > (val_2.ExpirationTime or math.huge) then
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

            local v17 = LootLibrary_m:GetRecoverStreakCost(val_2.ConsecutiveRecoveries)

            if v17 > PlayerDataController_m:Get("WeaponKeys") then
                Pages_m.PageSystem:OpenPage("Shop")
                Pages_m.PageSystem:WaitForPage("Shop"):SetPage("Currency")
                MonetizationController_m:PromptCurrencyBundlePurchase(v17, "WeaponKeys")
                arg5:CloseRequest()

                return
            end

            if Title.Text ~= "Are you sure?" then
                Title.Text = "Are you sure?"
                v15 += 1
                local v18 = v15
                wait(3)

                if v18 == v15 then
                    Title.Text = "Recover now"
                end

                return
            end

            Utility_m:CreateSound(
                "rbxassetid://18228252652",
                1,
                1,
                script,
                true,
                5
            )
            ReplicatedStorage.Remotes.Data.RecoverStreak:FireServer(key_2)
            arg5:CloseRequest()
        end)
        local Countdown_2 = v10.Countdown
        local Icon_1 = v10.Countdown.Icon
        local Price_1 = v10.Button.Price
        local Icon_2 = Price_1.Icon

        local function update() -- line: 151
            -- upvalues:
            --  [1] Price_1 (copy)
            --  [2] Icon_2 (copy)
            --  [3] Countdown_2 (copy)
            --  [4] Icon_1 (copy)

            Price_1.Position = UDim2.new(0.5, -Icon_2.AbsoluteSize.X / 2, 0.5, 0)
            Icon_2.Position = UDim2.new(0.5, Price_1.TextBounds.X / 2, 0.5, 0)
            local v25 = Countdown_2
            local New = UDim2.new
            local v26 = if Icon_1.Visible then Icon_1.AbsoluteSize.X / 2 else 0
            v25.Position = New(0.5, v26, 0.1, 0)
            Icon_1.Position = UDim2.new(0.5, -Countdown_2.TextBounds.X / 2, 0.5, 0)
        end

        Price_1:GetPropertyChangedSignal("TextBounds"):Connect(update)
        Icon_2:GetPropertyChangedSignal("AbsoluteSize"):Connect(update)
        Countdown_2:GetPropertyChangedSignal("TextBounds"):Connect(update)
        Icon_1:GetPropertyChangedSignal("AbsoluteSize"):Connect(update)
        Icon_1:GetPropertyChangedSignal("Visible"):Connect(update)
        update()
    end

    local CloseButton = arg5.CloseButton
    CloseButton.Position = #arg5._slots > 1 and UDim2.new(0.95, 16, 0.0375) or UDim2.new(
        0.95,
        16,
        0.2575,
        0
    )
    local List = arg5.List
    List.Position = #arg5._slots > 1 and UDim2.new(0.5, 9, 0, 0) or UDim2.new(0.5, 9, 0.22, 0)
    arg5:_StartCountdownLoop()
end

function t._Init(arg6) -- line: 171
    -- upvalues:
    --  [1] PlayerDataController_m (copy)
    --  [2] ButtonEffect_m (copy)

    arg6.CloseButton.MouseButton1Click:Connect(function() -- line: 172
        -- upvalues:
        --  [1] arg6 (copy)

        arg6:CloseRequest()
    end)
    arg6.Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() -- line: 176
        -- upvalues:
        --  [1] arg6 (copy)

        arg6.List.CanvasSize = UDim2.new(0, 0, 0, arg6.Layout.AbsoluteContentSize.Y)
    end)
    PlayerDataController_m:GetDataChangedSignal("StoredStreaks"):Connect(function() -- line: 180
        -- upvalues:
        --  [1] arg6 (copy)

        arg6:_Generate()
    end)
    arg6:_Generate()
    ButtonEffect_m:Add(arg6.CloseButton)
end

return t._new()
