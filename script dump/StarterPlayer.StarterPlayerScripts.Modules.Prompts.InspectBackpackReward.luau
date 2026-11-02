local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local CONSTANTS_m = require(ReplicatedStorage.Modules.CONSTANTS)
local CosmeticLibrary_m = require(ReplicatedStorage.Modules.CosmeticLibrary)
local ServerOsTime_m = require(ReplicatedStorage.Modules.ServerOsTime)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local Signal_m = require(ReplicatedStorage.Modules.Signal)
local PlayerDataController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("PlayerDataController")
)
local FighterController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("FighterController")
)
local ButtonEffect_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("ButtonEffect")
)
local RewardSlot_m = require(Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("RewardSlot"))
local Prompt_m = require(Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("Prompt"))
local t = setmetatable({}, Prompt_m)
t.__index = t

function t.new(arg1) -- line: 18
    -- upvalues:
    --  [1] Prompt_m (copy)
    --  [2] t (copy)
    --  [3] Signal_m (copy)

    local t_1 = setmetatable(Prompt_m.new(script.Name), t)
    t_1.ClosePage = Signal_m.new()
    t_1.Title = t_1.PromptFrame:WaitForChild("Title")
    t_1.ExpireText = t_1.PromptFrame:WaitForChild("Expire")
    t_1.ExpireLeftIcon = t_1.ExpireText:WaitForChild("LeftIcon")
    t_1.ExpireRightIcon = t_1.ExpireText:WaitForChild("RightIcon")
    t_1.Container = t_1.PromptFrame:WaitForChild("Container")
    t_1.CloseButton = t_1.PromptFrame:WaitForChild("Close")
    t_1.ButtonsFrame = t_1.PromptFrame:WaitForChild("Buttons")
    t_1.ViewContentsButton = t_1.ButtonsFrame:WaitForChild("ViewContents")
    t_1.UseButton = t_1.ButtonsFrame:WaitForChild("Use")
    t_1.Use3Button = t_1.ButtonsFrame:WaitForChild("Use3")
    t_1.UseMaxButton = t_1.ButtonsFrame:WaitForChild("UseMax")
    t_1.UseMaxButtonText = t_1.UseMaxButton:WaitForChild("Price")
    t_1._index = arg1
    t_1._reward_data = nil
    t_1._cosmetic_info = nil
    t_1._reward_info = nil
    t_1._reward_slot = nil
    t_1._expire_hash = 0
    t_1._is_using = false
    t_1:_Init()

    return t_1
end

function t.Use(arg2, arg3) -- line: 53
    -- upvalues:
    --  [1] FighterController_m (copy)
    --  [2] ReplicatedStorage (copy)
    --  [3] CosmeticLibrary_m (copy)

    if
        arg2._is_using
        or not FighterController_m.LocalFighter
        or FighterController_m.LocalFighter:Get("IsInDuel")
        or FighterController_m.LocalFighter:Get("IsInShootingRange")
    then
        return
    end

    arg2._is_using = true
    local v7 = arg2._reward_info and arg2._reward_info.Type == "Lootbox"

    if ReplicatedStorage.Remotes.Data.UseUnclaimedReward:InvokeServer(arg2._index, arg3) ~= "Success" then
        if v7 then
            arg2.OpenPrompt:Fire(
                "ErrorMessage",
                "Whoops!",
                "Failed to open, you probably already have everything!"
            )
        elseif
            arg2._cosmetic_info
            and CosmeticLibrary_m.Types[arg2._cosmetic_info.Type].IsWeaponCosmetic
        then
            arg2.OpenPrompt:Fire(
                "ErrorMessage",
                "Whoops!",
                "Failed to use, this item is probably already unlocked for all possible weapons!"
            )
        else
            arg2.OpenPrompt:Fire(
                "ErrorMessage",
                "Whoops!",
                "Failed to use, this item is probably already unlocked!"
            )
        end
    elseif v7 then
        if arg2._reward_info and arg2._reward_info.SoundProfile then
            arg2.ClosePage:Fire()
        else
            arg2:CloseRequest()
        end
    end

    arg2._is_using = false
end

function t.Destroy(arg4) -- line: 84
    -- upvalues:
    --  [1] Prompt_m (copy)

    arg4:_Clear()
    Prompt_m.Destroy(arg4)
end

function t._UpdateTextBounds(arg5) -- line: 93
    arg5.ExpireLeftIcon.Position = UDim2.new(0.5, -arg5.ExpireText.TextBounds.X / 2, 0.5, 0)
    arg5.ExpireRightIcon.Position = UDim2.new(0.5, arg5.ExpireText.TextBounds.X / 2, 0.5, 0)
end

function t._UpdateExpireText(arg6) -- line: 98
    -- upvalues:
    --  [1] ServerOsTime_m (copy)
    --  [2] Utility_m (copy)

    local ExpireText = arg6.ExpireText
    ExpireText.Text = if not arg6._reward_data then "" else if not arg6._reward_data.ExpireTime then "" else if ServerOsTime_m:Get() >= arg6._reward_data.ExpireTime then "This item has expired" else "Expires in " .. Utility_m:TimeFormat2(
        arg6._reward_data.ExpireTime - ServerOsTime_m:GetRounded()
    )
end

function t._Clear(arg7) -- line: 105
    if arg7._reward_slot then
        arg7._reward_slot:Destroy()
        arg7._reward_slot = nil
    end

    arg7._expire_hash += 1
end

function t._Update(arg8) -- line: 114
    -- upvalues:
    --  [1] PlayerDataController_m (copy)
    --  [2] CosmeticLibrary_m (copy)
    --  [3] CONSTANTS_m (copy)
    --  [4] RewardSlot_m (copy)

    arg8:_Clear()
    local v12 = PlayerDataController_m:Get("UnclaimedRewards")
    arg8._reward_data = v12[arg8._index]
    local v13 = arg8._reward_data

    if v13 then
        v13 = CosmeticLibrary_m.Cosmetics[arg8._reward_data.Name]
    end

    arg8._cosmetic_info = v13
    v13 = arg8._reward_data

    if v13 then
        v13 = CosmeticLibrary_m.Rewards[arg8._reward_data.Name]
    end

    arg8._reward_info = v13

    if not arg8._reward_data then
        task.defer(arg8.CloseRequest, arg8)

        return
    end

    local v14 = if arg8._reward_data.Weapon ~= "IsRandom" then if arg8._reward_data.Weapon ~= "IsUniversal" then arg8._reward_data.Weapon else "Universal" else "Random"
    local v15 = arg8._reward_data.Quantity or 1
    arg8.Title.Text = if arg8._cosmetic_info and v14 then v14 .. " " .. arg8._cosmetic_info.Type else if not arg8._cosmetic_info then arg8._reward_data.Name else arg8._cosmetic_info.Type
    local ExpireText_1 = arg8.ExpireText
    local v16 = arg8._reward_data.ExpireTime ~= nil
    ExpireText_1.Visible = v16
    local ViewContentsButton = arg8.ViewContentsButton
    v16 = arg8._reward_info and arg8._reward_info.Type == "Lootbox" or arg8._cosmetic_info and CosmeticLibrary_m.Types[arg8._cosmetic_info.Type].IsWeaponCosmetic and arg8._reward_data.Weapon == "IsRandom"
    ViewContentsButton.Visible = v16
    v16 = arg8.ViewContentsButton.Visible
    local Use3Button = arg8.Use3Button
    v16 = v16 and v15 >= 3
    Use3Button.Visible = v16
    v16 = arg8.ViewContentsButton.Visible
    local UseMaxButton = arg8.UseMaxButton
    v16 = v16 and v15 > 3
    UseMaxButton.Visible = v16
    arg8.UseMaxButtonText.Text = "\195\151" .. math.min(CONSTANTS_m.MAX_BACKPACK_USE_QUANTITY, v15)
    arg8._reward_slot = RewardSlot_m.new(arg8._reward_data)
    arg8._reward_slot:SetParent(arg8.Container)

    if arg8.ExpireText.Visible then
        task.spawn(function() -- line: 143
            -- upvalues:
            --  [1] arg8 (copy)

            local v17 = arg8
            v17._expire_hash += 1
            local ExpireHash = arg8._expire_hash

            while true do
                if arg8._destroyed and ExpireHash == arg8._expire_hash then
                    break
                end

                arg8:_UpdateExpireText()
                wait(1)
            end
        end)
    end
end

function t._Init(arg9) -- line: 155
    -- upvalues:
    --  [1] CONSTANTS_m (copy)
    --  [2] PlayerDataController_m (copy)
    --  [3] ButtonEffect_m (copy)

    arg9.CloseButton.MouseButton1Click:Connect(function() -- line: 156
        -- upvalues:
        --  [1] arg9 (copy)

        arg9:CloseRequest()
    end)
    arg9.UseButton.MouseButton1Click:Connect(function() -- line: 160
        -- upvalues:
        --  [1] arg9 (copy)

        arg9:Use(1)
    end)
    arg9.Use3Button.MouseButton1Click:Connect(function() -- line: 164
        -- upvalues:
        --  [1] arg9 (copy)

        arg9:Use(3)
    end)
    arg9.UseMaxButton.MouseButton1Click:Connect(function() -- line: 168
        -- upvalues:
        --  [1] arg9 (copy)
        --  [2] CONSTANTS_m (ref)

        arg9:Use(CONSTANTS_m.MAX_BACKPACK_USE_QUANTITY)
    end)
    arg9.ViewContentsButton.MouseButton1Click:Connect(function() -- line: 172
        -- upvalues:
        --  [1] arg9 (copy)

        if arg9._reward_data then
            arg9.OpenPrompt:Fire(
                "InspectLootbox",
                arg9._reward_data.Name,
                arg9._reward_data.Weapon,
                "InspectBackpackReward",
                arg9._index
            )
        end
    end)
    arg9.ExpireText:GetPropertyChangedSignal("TextBounds"):Connect(function() -- line: 178
        -- upvalues:
        --  [1] arg9 (copy)

        arg9:_UpdateTextBounds()
    end)
    local Connections = arg9._connections
    local UnclaimedRewards = PlayerDataController_m:GetDataChangedSignal("UnclaimedRewards")
    table.insert(Connections, UnclaimedRewards:Connect(function() -- line: 182
        -- upvalues:
        --  [1] arg9 (copy)

        arg9:_Update()
    end))
    arg9:_Update()
    arg9:_UpdateTextBounds()
    ButtonEffect_m:Add(arg9.UseButton)
    ButtonEffect_m:Add(arg9.Use3Button)
    ButtonEffect_m:Add(arg9.UseMaxButton)
    ButtonEffect_m:Add(arg9.CloseButton)
    ButtonEffect_m:Add(arg9.ViewContentsButton)
end

return t
