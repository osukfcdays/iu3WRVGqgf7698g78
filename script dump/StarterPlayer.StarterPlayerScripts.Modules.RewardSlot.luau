local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CosmeticLibrary_m = require(ReplicatedStorage.Modules.CosmeticLibrary)
local ItemLibrary_m = require(ReplicatedStorage.Modules.ItemLibrary)
local ShopLibrary_m = require(ReplicatedStorage.Modules.ShopLibrary)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local WeaponStatusHandler_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("WeaponStatusHandler")
)
local CosmeticSlot_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("CosmeticSlot")
)
local ButtonEffect_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("ButtonEffect")
)
local UILibrary_m = require(Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("UILibrary"))
local RewardBubble = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("RewardBubble")
local RewardSlot = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("RewardSlot")
local t = {}
t.__index = t

function t.new(arg1, arg2, arg3) -- line: 22
    -- upvalues:
    --  [1] t (copy)
    --  [2] CosmeticLibrary_m (copy)
    --  [3] RewardSlot (copy)

    local t_1 = setmetatable({}, t)
    t_1.RewardData = arg1
    t_1.CosmeticInfo = CosmeticLibrary_m.Cosmetics[t_1.RewardData.Name]
    t_1.RewardInfo = CosmeticLibrary_m.Rewards[t_1.RewardData.Name]
    t_1.Frame = RewardSlot:Clone()
    t_1.CosmeticSlot = nil
    t_1._ignore_button_effects = arg2
    t_1._is_locked = arg3
    t_1._key_slot_frame = nil
    t_1._bubble_hash = 0
    t_1._bubble_frame = nil
    t_1._bubble_reward_slot = nil
    t_1._bubble_connections = {}
    t_1._bubble_auto_close_delay = nil
    t_1._on_click_callback = nil
    t_1:_Init()

    return t_1
end

function t.GetRewardBubbleTitle(arg4) -- line: 50
    -- upvalues:
    --  [1] Utility_m (copy)
    --  [2] CosmeticLibrary_m (copy)

    local v5 = arg4.RewardData.Quantity or 1
    local v6, v7, v8

    if arg4.RewardInfo then
        v6 = arg4.RewardInfo.BubbleTitle

        if not v6 then
            if arg4.RewardInfo then
                if arg4.RewardInfo.Type == "Weapon" then
                    if arg4:_IsUnreleasedWeapon() then
                        return "COMING SOON"
                    else
                        v6 = arg4.RewardInfo.DisplayName

                        if not v6 then
                            if arg4.RewardInfo then
                                if arg4.RewardInfo.PrioritizeNameOverQuantity then
                                    if v5 == 1 then
                                        v6 = arg4.RewardInfo.DisplayName

                                        if not v6 then
                                            if arg4.RewardInfo then
                                                v7 = Utility_m:PrettyNumber(v5)
                                                v8 = v5 ~= 1 and arg4.RewardInfo.DisplayNamePlural or arg4.RewardInfo.DisplayName
                                                v6 = "\195\151" .. v7 .. " " .. v8 or arg4.RewardData.Name .. " " .. CosmeticLibrary_m.Cosmetics[arg4.RewardData.Name].Type
                                            else
                                                v6 = arg4.RewardData.Name .. " " .. CosmeticLibrary_m.Cosmetics[arg4.RewardData.Name].Type
                                            end
                                        end
                                    elseif arg4.RewardInfo then
                                        v7 = Utility_m:PrettyNumber(v5)
                                        v8 = v5 ~= 1 and arg4.RewardInfo.DisplayNamePlural or arg4.RewardInfo.DisplayName
                                        v6 = "\195\151" .. v7 .. " " .. v8 or arg4.RewardData.Name .. " " .. CosmeticLibrary_m.Cosmetics[arg4.RewardData.Name].Type
                                    else
                                        v6 = arg4.RewardData.Name .. " " .. CosmeticLibrary_m.Cosmetics[arg4.RewardData.Name].Type
                                    end
                                elseif arg4.RewardInfo then
                                    v7 = Utility_m:PrettyNumber(v5)
                                    v8 = v5 ~= 1 and arg4.RewardInfo.DisplayNamePlural or arg4.RewardInfo.DisplayName
                                    v6 = "\195\151" .. v7 .. " " .. v8 or arg4.RewardData.Name .. " " .. CosmeticLibrary_m.Cosmetics[arg4.RewardData.Name].Type
                                else
                                    v6 = arg4.RewardData.Name .. " " .. CosmeticLibrary_m.Cosmetics[arg4.RewardData.Name].Type
                                end
                            elseif arg4.RewardInfo then
                                v7 = Utility_m:PrettyNumber(v5)
                                v8 = v5 ~= 1 and arg4.RewardInfo.DisplayNamePlural or arg4.RewardInfo.DisplayName
                                v6 = "\195\151" .. v7 .. " " .. v8 or arg4.RewardData.Name .. " " .. CosmeticLibrary_m.Cosmetics[arg4.RewardData.Name].Type
                            else
                                v6 = arg4.RewardData.Name .. " " .. CosmeticLibrary_m.Cosmetics[arg4.RewardData.Name].Type
                            end
                        end
                    end
                elseif arg4.RewardInfo then
                    if arg4.RewardInfo.PrioritizeNameOverQuantity then
                        if v5 == 1 then
                            v6 = arg4.RewardInfo.DisplayName

                            if not v6 then
                                if arg4.RewardInfo then
                                    v7 = Utility_m:PrettyNumber(v5)
                                    v8 = v5 ~= 1 and arg4.RewardInfo.DisplayNamePlural or arg4.RewardInfo.DisplayName
                                    v6 = "\195\151" .. v7 .. " " .. v8 or arg4.RewardData.Name .. " " .. CosmeticLibrary_m.Cosmetics[arg4.RewardData.Name].Type
                                else
                                    v6 = arg4.RewardData.Name .. " " .. CosmeticLibrary_m.Cosmetics[arg4.RewardData.Name].Type
                                end
                            end
                        elseif arg4.RewardInfo then
                            v7 = Utility_m:PrettyNumber(v5)
                            v8 = v5 ~= 1 and arg4.RewardInfo.DisplayNamePlural or arg4.RewardInfo.DisplayName
                            v6 = "\195\151" .. v7 .. " " .. v8 or arg4.RewardData.Name .. " " .. CosmeticLibrary_m.Cosmetics[arg4.RewardData.Name].Type
                        else
                            v6 = arg4.RewardData.Name .. " " .. CosmeticLibrary_m.Cosmetics[arg4.RewardData.Name].Type
                        end
                    elseif arg4.RewardInfo then
                        v7 = Utility_m:PrettyNumber(v5)
                        v8 = v5 ~= 1 and arg4.RewardInfo.DisplayNamePlural or arg4.RewardInfo.DisplayName
                        v6 = "\195\151" .. v7 .. " " .. v8 or arg4.RewardData.Name .. " " .. CosmeticLibrary_m.Cosmetics[arg4.RewardData.Name].Type
                    else
                        v6 = arg4.RewardData.Name .. " " .. CosmeticLibrary_m.Cosmetics[arg4.RewardData.Name].Type
                    end
                elseif arg4.RewardInfo then
                    v7 = Utility_m:PrettyNumber(v5)
                    v8 = v5 ~= 1 and arg4.RewardInfo.DisplayNamePlural or arg4.RewardInfo.DisplayName
                    v6 = "\195\151" .. v7 .. " " .. v8 or arg4.RewardData.Name .. " " .. CosmeticLibrary_m.Cosmetics[arg4.RewardData.Name].Type
                else
                    v6 = arg4.RewardData.Name .. " " .. CosmeticLibrary_m.Cosmetics[arg4.RewardData.Name].Type
                end
            elseif arg4.RewardInfo then
                if arg4.RewardInfo.PrioritizeNameOverQuantity then
                    if v5 == 1 then
                        v6 = arg4.RewardInfo.DisplayName

                        if not v6 then
                            if arg4.RewardInfo then
                                v7 = Utility_m:PrettyNumber(v5)
                                v8 = v5 ~= 1 and arg4.RewardInfo.DisplayNamePlural or arg4.RewardInfo.DisplayName
                                v6 = "\195\151" .. v7 .. " " .. v8 or arg4.RewardData.Name .. " " .. CosmeticLibrary_m.Cosmetics[arg4.RewardData.Name].Type
                            else
                                v6 = arg4.RewardData.Name .. " " .. CosmeticLibrary_m.Cosmetics[arg4.RewardData.Name].Type
                            end
                        end
                    elseif arg4.RewardInfo then
                        v7 = Utility_m:PrettyNumber(v5)
                        v8 = v5 ~= 1 and arg4.RewardInfo.DisplayNamePlural or arg4.RewardInfo.DisplayName
                        v6 = "\195\151" .. v7 .. " " .. v8 or arg4.RewardData.Name .. " " .. CosmeticLibrary_m.Cosmetics[arg4.RewardData.Name].Type
                    else
                        v6 = arg4.RewardData.Name .. " " .. CosmeticLibrary_m.Cosmetics[arg4.RewardData.Name].Type
                    end
                elseif arg4.RewardInfo then
                    v7 = Utility_m:PrettyNumber(v5)
                    v8 = v5 ~= 1 and arg4.RewardInfo.DisplayNamePlural or arg4.RewardInfo.DisplayName
                    v6 = "\195\151" .. v7 .. " " .. v8 or arg4.RewardData.Name .. " " .. CosmeticLibrary_m.Cosmetics[arg4.RewardData.Name].Type
                else
                    v6 = arg4.RewardData.Name .. " " .. CosmeticLibrary_m.Cosmetics[arg4.RewardData.Name].Type
                end
            elseif arg4.RewardInfo then
                v7 = Utility_m:PrettyNumber(v5)
                v8 = v5 ~= 1 and arg4.RewardInfo.DisplayNamePlural or arg4.RewardInfo.DisplayName
                v6 = "\195\151" .. v7 .. " " .. v8 or arg4.RewardData.Name .. " " .. CosmeticLibrary_m.Cosmetics[arg4.RewardData.Name].Type
            else
                v6 = arg4.RewardData.Name .. " " .. CosmeticLibrary_m.Cosmetics[arg4.RewardData.Name].Type
            end
        end

        return v6
    end

    if arg4.RewardInfo then
        if arg4.RewardInfo.Type == "Weapon" then
            if arg4:_IsUnreleasedWeapon() then
                return "COMING SOON"
            end

            v6 = arg4.RewardInfo.DisplayName

            if not v6 then
                if arg4.RewardInfo then
                    if arg4.RewardInfo.PrioritizeNameOverQuantity then
                        if v5 == 1 then
                            v6 = arg4.RewardInfo.DisplayName

                            if not v6 then
                                if arg4.RewardInfo then
                                    v7 = Utility_m:PrettyNumber(v5)
                                    v8 = v5 ~= 1 and arg4.RewardInfo.DisplayNamePlural or arg4.RewardInfo.DisplayName
                                    v6 = "\195\151" .. v7 .. " " .. v8 or arg4.RewardData.Name .. " " .. CosmeticLibrary_m.Cosmetics[arg4.RewardData.Name].Type
                                else
                                    v6 = arg4.RewardData.Name .. " " .. CosmeticLibrary_m.Cosmetics[arg4.RewardData.Name].Type
                                end
                            end
                        elseif arg4.RewardInfo then
                            v7 = Utility_m:PrettyNumber(v5)
                            v8 = v5 ~= 1 and arg4.RewardInfo.DisplayNamePlural or arg4.RewardInfo.DisplayName
                            v6 = "\195\151" .. v7 .. " " .. v8 or arg4.RewardData.Name .. " " .. CosmeticLibrary_m.Cosmetics[arg4.RewardData.Name].Type
                        else
                            v6 = arg4.RewardData.Name .. " " .. CosmeticLibrary_m.Cosmetics[arg4.RewardData.Name].Type
                        end
                    elseif arg4.RewardInfo then
                        v7 = Utility_m:PrettyNumber(v5)
                        v8 = v5 ~= 1 and arg4.RewardInfo.DisplayNamePlural or arg4.RewardInfo.DisplayName
                        v6 = "\195\151" .. v7 .. " " .. v8 or arg4.RewardData.Name .. " " .. CosmeticLibrary_m.Cosmetics[arg4.RewardData.Name].Type
                    else
                        v6 = arg4.RewardData.Name .. " " .. CosmeticLibrary_m.Cosmetics[arg4.RewardData.Name].Type
                    end
                elseif arg4.RewardInfo then
                    v7 = Utility_m:PrettyNumber(v5)
                    v8 = v5 ~= 1 and arg4.RewardInfo.DisplayNamePlural or arg4.RewardInfo.DisplayName
                    v6 = "\195\151" .. v7 .. " " .. v8 or arg4.RewardData.Name .. " " .. CosmeticLibrary_m.Cosmetics[arg4.RewardData.Name].Type
                else
                    v6 = arg4.RewardData.Name .. " " .. CosmeticLibrary_m.Cosmetics[arg4.RewardData.Name].Type
                end
            end

            return v6
        else
            if arg4.RewardInfo then
                if arg4.RewardInfo.PrioritizeNameOverQuantity then
                    if v5 == 1 then
                        v6 = arg4.RewardInfo.DisplayName

                        if not v6 then
                            if arg4.RewardInfo then
                                v7 = Utility_m:PrettyNumber(v5)
                                v8 = v5 ~= 1 and arg4.RewardInfo.DisplayNamePlural or arg4.RewardInfo.DisplayName
                                v6 = "\195\151" .. v7 .. " " .. v8 or arg4.RewardData.Name .. " " .. CosmeticLibrary_m.Cosmetics[arg4.RewardData.Name].Type
                            else
                                v6 = arg4.RewardData.Name .. " " .. CosmeticLibrary_m.Cosmetics[arg4.RewardData.Name].Type
                            end
                        end
                    elseif arg4.RewardInfo then
                        v7 = Utility_m:PrettyNumber(v5)
                        v8 = v5 ~= 1 and arg4.RewardInfo.DisplayNamePlural or arg4.RewardInfo.DisplayName
                        v6 = "\195\151" .. v7 .. " " .. v8 or arg4.RewardData.Name .. " " .. CosmeticLibrary_m.Cosmetics[arg4.RewardData.Name].Type
                    else
                        v6 = arg4.RewardData.Name .. " " .. CosmeticLibrary_m.Cosmetics[arg4.RewardData.Name].Type
                    end
                elseif arg4.RewardInfo then
                    v7 = Utility_m:PrettyNumber(v5)
                    v8 = v5 ~= 1 and arg4.RewardInfo.DisplayNamePlural or arg4.RewardInfo.DisplayName
                    v6 = "\195\151" .. v7 .. " " .. v8 or arg4.RewardData.Name .. " " .. CosmeticLibrary_m.Cosmetics[arg4.RewardData.Name].Type
                else
                    v6 = arg4.RewardData.Name .. " " .. CosmeticLibrary_m.Cosmetics[arg4.RewardData.Name].Type
                end
            elseif arg4.RewardInfo then
                v7 = Utility_m:PrettyNumber(v5)
                v8 = v5 ~= 1 and arg4.RewardInfo.DisplayNamePlural or arg4.RewardInfo.DisplayName
                v6 = "\195\151" .. v7 .. " " .. v8 or arg4.RewardData.Name .. " " .. CosmeticLibrary_m.Cosmetics[arg4.RewardData.Name].Type
            else
                v6 = arg4.RewardData.Name .. " " .. CosmeticLibrary_m.Cosmetics[arg4.RewardData.Name].Type
            end

            return v6
        end
    else
        if arg4.RewardInfo then
            if arg4.RewardInfo.PrioritizeNameOverQuantity then
                if v5 == 1 then
                    v6 = arg4.RewardInfo.DisplayName

                    if not v6 then
                        if arg4.RewardInfo then
                            v7 = Utility_m:PrettyNumber(v5)
                            v8 = v5 ~= 1 and arg4.RewardInfo.DisplayNamePlural or arg4.RewardInfo.DisplayName
                            v6 = "\195\151" .. v7 .. " " .. v8 or arg4.RewardData.Name .. " " .. CosmeticLibrary_m.Cosmetics[arg4.RewardData.Name].Type
                        else
                            v6 = arg4.RewardData.Name .. " " .. CosmeticLibrary_m.Cosmetics[arg4.RewardData.Name].Type
                        end
                    end
                elseif arg4.RewardInfo then
                    v7 = Utility_m:PrettyNumber(v5)
                    v8 = v5 ~= 1 and arg4.RewardInfo.DisplayNamePlural or arg4.RewardInfo.DisplayName
                    v6 = "\195\151" .. v7 .. " " .. v8 or arg4.RewardData.Name .. " " .. CosmeticLibrary_m.Cosmetics[arg4.RewardData.Name].Type
                else
                    v6 = arg4.RewardData.Name .. " " .. CosmeticLibrary_m.Cosmetics[arg4.RewardData.Name].Type
                end
            elseif arg4.RewardInfo then
                v7 = Utility_m:PrettyNumber(v5)
                v8 = v5 ~= 1 and arg4.RewardInfo.DisplayNamePlural or arg4.RewardInfo.DisplayName
                v6 = "\195\151" .. v7 .. " " .. v8 or arg4.RewardData.Name .. " " .. CosmeticLibrary_m.Cosmetics[arg4.RewardData.Name].Type
            else
                v6 = arg4.RewardData.Name .. " " .. CosmeticLibrary_m.Cosmetics[arg4.RewardData.Name].Type
            end
        elseif arg4.RewardInfo then
            v7 = Utility_m:PrettyNumber(v5)
            v8 = v5 ~= 1 and arg4.RewardInfo.DisplayNamePlural or arg4.RewardInfo.DisplayName
            v6 = "\195\151" .. v7 .. " " .. v8 or arg4.RewardData.Name .. " " .. CosmeticLibrary_m.Cosmetics[arg4.RewardData.Name].Type
        else
            v6 = arg4.RewardData.Name .. " " .. CosmeticLibrary_m.Cosmetics[arg4.RewardData.Name].Type
        end

        return v6
    end
end

function t.GetRewardBubbleDescription(arg5) -- line: 60
    -- upvalues:
    --  [1] Utility_m (copy)
    --  [2] ShopLibrary_m (copy)
    --  [3] ItemLibrary_m (copy)

    local v9

    if arg5.RewardInfo then
        v9 = arg5.RewardInfo.BubbleDescription

        if not v9 then
            if arg5.RewardInfo then
                if arg5.RewardInfo.Type == "Lootbox" then
                    if arg5.RewardData.Weapon then
                        if arg5.RewardData.Weapon ~= "IsRandom" then
                            if arg5.RewardData.Weapon ~= "IsUniversal" then
                                v9 = "Contains special items for " .. arg5.RewardData.Weapon .. "!"

                                if not v9 then
                                    v9 = arg5.RewardInfo.LootboxDescription

                                    if not v9 then
                                        if arg5.RewardInfo then
                                            if arg5.RewardInfo.Type == "Weapon" then
                                                if arg5:_IsUnreleasedWeapon() then
                                                    v9 = "in " .. Utility_m:TimeFormat2(
                                                        ShopLibrary_m:GetTimeUntilWeaponRelease(
                                                            arg5.RewardData.Name
                                                        )
                                                    ) .. "!"

                                                    if not v9 then
                                                        v9 = ItemLibrary_m.Items[arg5.RewardData.Name].Status .. " Weapon"

                                                        if not v9 then
                                                            if arg5.RewardData.Weapon == "IsUniversal" then
                                                                return "Given to all weapons forever!"
                                                            elseif arg5.RewardData.Weapon == "IsRandom" then
                                                                return "Given to a random weapon!"
                                                            else
                                                                v9 = arg5.RewardData.Weapon and "Given to " .. arg5.RewardData.Weapon .. "!" or arg5.CosmeticInfo and arg5.CosmeticInfo.Description or "???"
                                                            end
                                                        end
                                                    end
                                                else
                                                    v9 = ItemLibrary_m.Items[arg5.RewardData.Name].Status .. " Weapon"

                                                    if not v9 then
                                                        if arg5.RewardData.Weapon == "IsUniversal" then
                                                            return "Given to all weapons forever!"
                                                        elseif arg5.RewardData.Weapon == "IsRandom" then
                                                            return "Given to a random weapon!"
                                                        else
                                                            v9 = arg5.RewardData.Weapon and "Given to " .. arg5.RewardData.Weapon .. "!" or arg5.CosmeticInfo and arg5.CosmeticInfo.Description or "???"
                                                        end
                                                    end
                                                end
                                            elseif arg5.RewardData.Weapon == "IsUniversal" then
                                                return "Given to all weapons forever!"
                                            elseif arg5.RewardData.Weapon == "IsRandom" then
                                                return "Given to a random weapon!"
                                            else
                                                v9 = arg5.RewardData.Weapon and "Given to " .. arg5.RewardData.Weapon .. "!" or arg5.CosmeticInfo and arg5.CosmeticInfo.Description or "???"
                                            end
                                        elseif arg5.RewardData.Weapon == "IsUniversal" then
                                            return "Given to all weapons forever!"
                                        elseif arg5.RewardData.Weapon == "IsRandom" then
                                            return "Given to a random weapon!"
                                        else
                                            v9 = arg5.RewardData.Weapon and "Given to " .. arg5.RewardData.Weapon .. "!" or arg5.CosmeticInfo and arg5.CosmeticInfo.Description or "???"
                                        end
                                    end
                                end
                            else
                                v9 = arg5.RewardInfo.LootboxDescription

                                if not v9 then
                                    if arg5.RewardInfo then
                                        if arg5.RewardInfo.Type == "Weapon" then
                                            if arg5:_IsUnreleasedWeapon() then
                                                v9 = "in " .. Utility_m:TimeFormat2(
                                                    ShopLibrary_m:GetTimeUntilWeaponRelease(
                                                        arg5.RewardData.Name
                                                    )
                                                ) .. "!"

                                                if not v9 then
                                                    v9 = ItemLibrary_m.Items[arg5.RewardData.Name].Status .. " Weapon"

                                                    if not v9 then
                                                        if arg5.RewardData.Weapon == "IsUniversal" then
                                                            return "Given to all weapons forever!"
                                                        elseif arg5.RewardData.Weapon == "IsRandom" then
                                                            return "Given to a random weapon!"
                                                        else
                                                            v9 = arg5.RewardData.Weapon and "Given to " .. arg5.RewardData.Weapon .. "!" or arg5.CosmeticInfo and arg5.CosmeticInfo.Description or "???"
                                                        end
                                                    end
                                                end
                                            else
                                                v9 = ItemLibrary_m.Items[arg5.RewardData.Name].Status .. " Weapon"

                                                if not v9 then
                                                    if arg5.RewardData.Weapon == "IsUniversal" then
                                                        return "Given to all weapons forever!"
                                                    elseif arg5.RewardData.Weapon == "IsRandom" then
                                                        return "Given to a random weapon!"
                                                    else
                                                        v9 = arg5.RewardData.Weapon and "Given to " .. arg5.RewardData.Weapon .. "!" or arg5.CosmeticInfo and arg5.CosmeticInfo.Description or "???"
                                                    end
                                                end
                                            end
                                        elseif arg5.RewardData.Weapon == "IsUniversal" then
                                            return "Given to all weapons forever!"
                                        elseif arg5.RewardData.Weapon == "IsRandom" then
                                            return "Given to a random weapon!"
                                        else
                                            v9 = arg5.RewardData.Weapon and "Given to " .. arg5.RewardData.Weapon .. "!" or arg5.CosmeticInfo and arg5.CosmeticInfo.Description or "???"
                                        end
                                    elseif arg5.RewardData.Weapon == "IsUniversal" then
                                        return "Given to all weapons forever!"
                                    elseif arg5.RewardData.Weapon == "IsRandom" then
                                        return "Given to a random weapon!"
                                    else
                                        v9 = arg5.RewardData.Weapon and "Given to " .. arg5.RewardData.Weapon .. "!" or arg5.CosmeticInfo and arg5.CosmeticInfo.Description or "???"
                                    end
                                end
                            end
                        else
                            v9 = arg5.RewardInfo.LootboxDescription

                            if not v9 then
                                if arg5.RewardInfo then
                                    if arg5.RewardInfo.Type == "Weapon" then
                                        if arg5:_IsUnreleasedWeapon() then
                                            v9 = "in " .. Utility_m:TimeFormat2(
                                                ShopLibrary_m:GetTimeUntilWeaponRelease(
                                                    arg5.RewardData.Name
                                                )
                                            ) .. "!"

                                            if not v9 then
                                                v9 = ItemLibrary_m.Items[arg5.RewardData.Name].Status .. " Weapon"

                                                if not v9 then
                                                    if arg5.RewardData.Weapon == "IsUniversal" then
                                                        return "Given to all weapons forever!"
                                                    elseif arg5.RewardData.Weapon == "IsRandom" then
                                                        return "Given to a random weapon!"
                                                    else
                                                        v9 = arg5.RewardData.Weapon and "Given to " .. arg5.RewardData.Weapon .. "!" or arg5.CosmeticInfo and arg5.CosmeticInfo.Description or "???"
                                                    end
                                                end
                                            end
                                        else
                                            v9 = ItemLibrary_m.Items[arg5.RewardData.Name].Status .. " Weapon"

                                            if not v9 then
                                                if arg5.RewardData.Weapon == "IsUniversal" then
                                                    return "Given to all weapons forever!"
                                                elseif arg5.RewardData.Weapon == "IsRandom" then
                                                    return "Given to a random weapon!"
                                                else
                                                    v9 = arg5.RewardData.Weapon and "Given to " .. arg5.RewardData.Weapon .. "!" or arg5.CosmeticInfo and arg5.CosmeticInfo.Description or "???"
                                                end
                                            end
                                        end
                                    elseif arg5.RewardData.Weapon == "IsUniversal" then
                                        return "Given to all weapons forever!"
                                    elseif arg5.RewardData.Weapon == "IsRandom" then
                                        return "Given to a random weapon!"
                                    else
                                        v9 = arg5.RewardData.Weapon and "Given to " .. arg5.RewardData.Weapon .. "!" or arg5.CosmeticInfo and arg5.CosmeticInfo.Description or "???"
                                    end
                                elseif arg5.RewardData.Weapon == "IsUniversal" then
                                    return "Given to all weapons forever!"
                                elseif arg5.RewardData.Weapon == "IsRandom" then
                                    return "Given to a random weapon!"
                                else
                                    v9 = arg5.RewardData.Weapon and "Given to " .. arg5.RewardData.Weapon .. "!" or arg5.CosmeticInfo and arg5.CosmeticInfo.Description or "???"
                                end
                            end
                        end
                    else
                        v9 = arg5.RewardInfo.LootboxDescription

                        if not v9 then
                            if arg5.RewardInfo then
                                if arg5.RewardInfo.Type == "Weapon" then
                                    if arg5:_IsUnreleasedWeapon() then
                                        v9 = "in " .. Utility_m:TimeFormat2(
                                            ShopLibrary_m:GetTimeUntilWeaponRelease(
                                                arg5.RewardData.Name
                                            )
                                        ) .. "!"

                                        if not v9 then
                                            v9 = ItemLibrary_m.Items[arg5.RewardData.Name].Status .. " Weapon"

                                            if not v9 then
                                                if arg5.RewardData.Weapon == "IsUniversal" then
                                                    return "Given to all weapons forever!"
                                                elseif arg5.RewardData.Weapon == "IsRandom" then
                                                    return "Given to a random weapon!"
                                                else
                                                    v9 = arg5.RewardData.Weapon and "Given to " .. arg5.RewardData.Weapon .. "!" or arg5.CosmeticInfo and arg5.CosmeticInfo.Description or "???"
                                                end
                                            end
                                        end
                                    else
                                        v9 = ItemLibrary_m.Items[arg5.RewardData.Name].Status .. " Weapon"

                                        if not v9 then
                                            if arg5.RewardData.Weapon == "IsUniversal" then
                                                return "Given to all weapons forever!"
                                            elseif arg5.RewardData.Weapon == "IsRandom" then
                                                return "Given to a random weapon!"
                                            else
                                                v9 = arg5.RewardData.Weapon and "Given to " .. arg5.RewardData.Weapon .. "!" or arg5.CosmeticInfo and arg5.CosmeticInfo.Description or "???"
                                            end
                                        end
                                    end
                                elseif arg5.RewardData.Weapon == "IsUniversal" then
                                    return "Given to all weapons forever!"
                                elseif arg5.RewardData.Weapon == "IsRandom" then
                                    return "Given to a random weapon!"
                                else
                                    v9 = arg5.RewardData.Weapon and "Given to " .. arg5.RewardData.Weapon .. "!" or arg5.CosmeticInfo and arg5.CosmeticInfo.Description or "???"
                                end
                            elseif arg5.RewardData.Weapon == "IsUniversal" then
                                return "Given to all weapons forever!"
                            elseif arg5.RewardData.Weapon == "IsRandom" then
                                return "Given to a random weapon!"
                            else
                                v9 = arg5.RewardData.Weapon and "Given to " .. arg5.RewardData.Weapon .. "!" or arg5.CosmeticInfo and arg5.CosmeticInfo.Description or "???"
                            end
                        end
                    end
                elseif arg5.RewardInfo then
                    if arg5.RewardInfo.Type == "Weapon" then
                        if arg5:_IsUnreleasedWeapon() then
                            v9 = "in " .. Utility_m:TimeFormat2(
                                ShopLibrary_m:GetTimeUntilWeaponRelease(arg5.RewardData.Name)
                            ) .. "!"

                            if not v9 then
                                v9 = ItemLibrary_m.Items[arg5.RewardData.Name].Status .. " Weapon"

                                if not v9 then
                                    if arg5.RewardData.Weapon == "IsUniversal" then
                                        return "Given to all weapons forever!"
                                    elseif arg5.RewardData.Weapon == "IsRandom" then
                                        return "Given to a random weapon!"
                                    else
                                        v9 = arg5.RewardData.Weapon and "Given to " .. arg5.RewardData.Weapon .. "!" or arg5.CosmeticInfo and arg5.CosmeticInfo.Description or "???"
                                    end
                                end
                            end
                        else
                            v9 = ItemLibrary_m.Items[arg5.RewardData.Name].Status .. " Weapon"

                            if not v9 then
                                if arg5.RewardData.Weapon == "IsUniversal" then
                                    return "Given to all weapons forever!"
                                elseif arg5.RewardData.Weapon == "IsRandom" then
                                    return "Given to a random weapon!"
                                else
                                    v9 = arg5.RewardData.Weapon and "Given to " .. arg5.RewardData.Weapon .. "!" or arg5.CosmeticInfo and arg5.CosmeticInfo.Description or "???"
                                end
                            end
                        end
                    elseif arg5.RewardData.Weapon == "IsUniversal" then
                        return "Given to all weapons forever!"
                    elseif arg5.RewardData.Weapon == "IsRandom" then
                        return "Given to a random weapon!"
                    else
                        v9 = arg5.RewardData.Weapon and "Given to " .. arg5.RewardData.Weapon .. "!" or arg5.CosmeticInfo and arg5.CosmeticInfo.Description or "???"
                    end
                elseif arg5.RewardData.Weapon == "IsUniversal" then
                    return "Given to all weapons forever!"
                elseif arg5.RewardData.Weapon == "IsRandom" then
                    return "Given to a random weapon!"
                else
                    v9 = arg5.RewardData.Weapon and "Given to " .. arg5.RewardData.Weapon .. "!" or arg5.CosmeticInfo and arg5.CosmeticInfo.Description or "???"
                end
            elseif arg5.RewardInfo then
                if arg5.RewardInfo.Type == "Weapon" then
                    if arg5:_IsUnreleasedWeapon() then
                        v9 = "in " .. Utility_m:TimeFormat2(
                            ShopLibrary_m:GetTimeUntilWeaponRelease(arg5.RewardData.Name)
                        ) .. "!"

                        if not v9 then
                            v9 = ItemLibrary_m.Items[arg5.RewardData.Name].Status .. " Weapon"

                            if not v9 then
                                if arg5.RewardData.Weapon == "IsUniversal" then
                                    return "Given to all weapons forever!"
                                elseif arg5.RewardData.Weapon == "IsRandom" then
                                    return "Given to a random weapon!"
                                else
                                    v9 = arg5.RewardData.Weapon and "Given to " .. arg5.RewardData.Weapon .. "!" or arg5.CosmeticInfo and arg5.CosmeticInfo.Description or "???"
                                end
                            end
                        end
                    else
                        v9 = ItemLibrary_m.Items[arg5.RewardData.Name].Status .. " Weapon"

                        if not v9 then
                            if arg5.RewardData.Weapon == "IsUniversal" then
                                return "Given to all weapons forever!"
                            elseif arg5.RewardData.Weapon == "IsRandom" then
                                return "Given to a random weapon!"
                            else
                                v9 = arg5.RewardData.Weapon and "Given to " .. arg5.RewardData.Weapon .. "!" or arg5.CosmeticInfo and arg5.CosmeticInfo.Description or "???"
                            end
                        end
                    end
                elseif arg5.RewardData.Weapon == "IsUniversal" then
                    return "Given to all weapons forever!"
                elseif arg5.RewardData.Weapon == "IsRandom" then
                    return "Given to a random weapon!"
                else
                    v9 = arg5.RewardData.Weapon and "Given to " .. arg5.RewardData.Weapon .. "!" or arg5.CosmeticInfo and arg5.CosmeticInfo.Description or "???"
                end
            elseif arg5.RewardData.Weapon == "IsUniversal" then
                return "Given to all weapons forever!"
            elseif arg5.RewardData.Weapon == "IsRandom" then
                return "Given to a random weapon!"
            else
                v9 = arg5.RewardData.Weapon and "Given to " .. arg5.RewardData.Weapon .. "!" or arg5.CosmeticInfo and arg5.CosmeticInfo.Description or "???"
            end
        end

        return v9
    end

    if arg5.RewardInfo then
        if arg5.RewardInfo.Type == "Lootbox" then
            if arg5.RewardData.Weapon then
                if arg5.RewardData.Weapon ~= "IsRandom" then
                    if arg5.RewardData.Weapon ~= "IsUniversal" then
                        v9 = "Contains special items for " .. arg5.RewardData.Weapon .. "!"

                        if not v9 then
                            v9 = arg5.RewardInfo.LootboxDescription

                            if not v9 then
                                if arg5.RewardInfo then
                                    if arg5.RewardInfo.Type == "Weapon" then
                                        if arg5:_IsUnreleasedWeapon() then
                                            v9 = "in " .. Utility_m:TimeFormat2(
                                                ShopLibrary_m:GetTimeUntilWeaponRelease(
                                                    arg5.RewardData.Name
                                                )
                                            ) .. "!"

                                            if not v9 then
                                                v9 = ItemLibrary_m.Items[arg5.RewardData.Name].Status .. " Weapon"

                                                if not v9 then
                                                    if arg5.RewardData.Weapon == "IsUniversal" then
                                                        return "Given to all weapons forever!"
                                                    elseif arg5.RewardData.Weapon == "IsRandom" then
                                                        return "Given to a random weapon!"
                                                    else
                                                        v9 = arg5.RewardData.Weapon and "Given to " .. arg5.RewardData.Weapon .. "!" or arg5.CosmeticInfo and arg5.CosmeticInfo.Description or "???"
                                                    end
                                                end
                                            end
                                        else
                                            v9 = ItemLibrary_m.Items[arg5.RewardData.Name].Status .. " Weapon"

                                            if not v9 then
                                                if arg5.RewardData.Weapon == "IsUniversal" then
                                                    return "Given to all weapons forever!"
                                                elseif arg5.RewardData.Weapon == "IsRandom" then
                                                    return "Given to a random weapon!"
                                                else
                                                    v9 = arg5.RewardData.Weapon and "Given to " .. arg5.RewardData.Weapon .. "!" or arg5.CosmeticInfo and arg5.CosmeticInfo.Description or "???"
                                                end
                                            end
                                        end
                                    elseif arg5.RewardData.Weapon == "IsUniversal" then
                                        return "Given to all weapons forever!"
                                    elseif arg5.RewardData.Weapon == "IsRandom" then
                                        return "Given to a random weapon!"
                                    else
                                        v9 = arg5.RewardData.Weapon and "Given to " .. arg5.RewardData.Weapon .. "!" or arg5.CosmeticInfo and arg5.CosmeticInfo.Description or "???"
                                    end
                                elseif arg5.RewardData.Weapon == "IsUniversal" then
                                    return "Given to all weapons forever!"
                                elseif arg5.RewardData.Weapon == "IsRandom" then
                                    return "Given to a random weapon!"
                                else
                                    v9 = arg5.RewardData.Weapon and "Given to " .. arg5.RewardData.Weapon .. "!" or arg5.CosmeticInfo and arg5.CosmeticInfo.Description or "???"
                                end
                            end
                        end

                        return v9
                    end

                    v9 = arg5.RewardInfo.LootboxDescription

                    if not v9 then
                        if arg5.RewardInfo then
                            if arg5.RewardInfo.Type == "Weapon" then
                                if arg5:_IsUnreleasedWeapon() then
                                    v9 = "in " .. Utility_m:TimeFormat2(
                                        ShopLibrary_m:GetTimeUntilWeaponRelease(
                                            arg5.RewardData.Name
                                        )
                                    ) .. "!"

                                    if not v9 then
                                        v9 = ItemLibrary_m.Items[arg5.RewardData.Name].Status .. " Weapon"

                                        if not v9 then
                                            if arg5.RewardData.Weapon == "IsUniversal" then
                                                return "Given to all weapons forever!"
                                            end

                                            if arg5.RewardData.Weapon == "IsRandom" then
                                                return "Given to a random weapon!"
                                            end

                                            v9 = arg5.RewardData.Weapon and "Given to " .. arg5.RewardData.Weapon .. "!" or arg5.CosmeticInfo and arg5.CosmeticInfo.Description or "???"
                                        end
                                    end
                                else
                                    v9 = ItemLibrary_m.Items[arg5.RewardData.Name].Status .. " Weapon"

                                    if not v9 then
                                        if arg5.RewardData.Weapon == "IsUniversal" then
                                            return "Given to all weapons forever!"
                                        end

                                        if arg5.RewardData.Weapon == "IsRandom" then
                                            return "Given to a random weapon!"
                                        end

                                        v9 = arg5.RewardData.Weapon and "Given to " .. arg5.RewardData.Weapon .. "!" or arg5.CosmeticInfo and arg5.CosmeticInfo.Description or "???"
                                    end
                                end
                            else
                                if arg5.RewardData.Weapon == "IsUniversal" then
                                    return "Given to all weapons forever!"
                                end

                                if arg5.RewardData.Weapon == "IsRandom" then
                                    return "Given to a random weapon!"
                                end

                                v9 = arg5.RewardData.Weapon and "Given to " .. arg5.RewardData.Weapon .. "!" or arg5.CosmeticInfo and arg5.CosmeticInfo.Description or "???"
                            end
                        else
                            if arg5.RewardData.Weapon == "IsUniversal" then
                                return "Given to all weapons forever!"
                            end

                            if arg5.RewardData.Weapon == "IsRandom" then
                                return "Given to a random weapon!"
                            end

                            v9 = arg5.RewardData.Weapon and "Given to " .. arg5.RewardData.Weapon .. "!" or arg5.CosmeticInfo and arg5.CosmeticInfo.Description or "???"
                        end
                    end

                    return v9
                else
                    v9 = arg5.RewardInfo.LootboxDescription

                    if not v9 then
                        if arg5.RewardInfo then
                            if arg5.RewardInfo.Type == "Weapon" then
                                if arg5:_IsUnreleasedWeapon() then
                                    v9 = "in " .. Utility_m:TimeFormat2(
                                        ShopLibrary_m:GetTimeUntilWeaponRelease(
                                            arg5.RewardData.Name
                                        )
                                    ) .. "!"

                                    if not v9 then
                                        v9 = ItemLibrary_m.Items[arg5.RewardData.Name].Status .. " Weapon"

                                        if not v9 then
                                            if arg5.RewardData.Weapon == "IsUniversal" then
                                                return "Given to all weapons forever!"
                                            end

                                            if arg5.RewardData.Weapon == "IsRandom" then
                                                return "Given to a random weapon!"
                                            end

                                            v9 = arg5.RewardData.Weapon and "Given to " .. arg5.RewardData.Weapon .. "!" or arg5.CosmeticInfo and arg5.CosmeticInfo.Description or "???"
                                        end
                                    end
                                else
                                    v9 = ItemLibrary_m.Items[arg5.RewardData.Name].Status .. " Weapon"

                                    if not v9 then
                                        if arg5.RewardData.Weapon == "IsUniversal" then
                                            return "Given to all weapons forever!"
                                        end

                                        if arg5.RewardData.Weapon == "IsRandom" then
                                            return "Given to a random weapon!"
                                        end

                                        v9 = arg5.RewardData.Weapon and "Given to " .. arg5.RewardData.Weapon .. "!" or arg5.CosmeticInfo and arg5.CosmeticInfo.Description or "???"
                                    end
                                end
                            else
                                if arg5.RewardData.Weapon == "IsUniversal" then
                                    return "Given to all weapons forever!"
                                end

                                if arg5.RewardData.Weapon == "IsRandom" then
                                    return "Given to a random weapon!"
                                end

                                v9 = arg5.RewardData.Weapon and "Given to " .. arg5.RewardData.Weapon .. "!" or arg5.CosmeticInfo and arg5.CosmeticInfo.Description or "???"
                            end
                        else
                            if arg5.RewardData.Weapon == "IsUniversal" then
                                return "Given to all weapons forever!"
                            end

                            if arg5.RewardData.Weapon == "IsRandom" then
                                return "Given to a random weapon!"
                            end

                            v9 = arg5.RewardData.Weapon and "Given to " .. arg5.RewardData.Weapon .. "!" or arg5.CosmeticInfo and arg5.CosmeticInfo.Description or "???"
                        end
                    end

                    return v9
                end
            else
                v9 = arg5.RewardInfo.LootboxDescription

                if not v9 then
                    if arg5.RewardInfo then
                        if arg5.RewardInfo.Type == "Weapon" then
                            if arg5:_IsUnreleasedWeapon() then
                                v9 = "in " .. Utility_m:TimeFormat2(
                                    ShopLibrary_m:GetTimeUntilWeaponRelease(arg5.RewardData.Name)
                                ) .. "!"

                                if not v9 then
                                    v9 = ItemLibrary_m.Items[arg5.RewardData.Name].Status .. " Weapon"

                                    if not v9 then
                                        if arg5.RewardData.Weapon == "IsUniversal" then
                                            return "Given to all weapons forever!"
                                        end

                                        if arg5.RewardData.Weapon == "IsRandom" then
                                            return "Given to a random weapon!"
                                        end

                                        v9 = arg5.RewardData.Weapon and "Given to " .. arg5.RewardData.Weapon .. "!" or arg5.CosmeticInfo and arg5.CosmeticInfo.Description or "???"
                                    end
                                end
                            else
                                v9 = ItemLibrary_m.Items[arg5.RewardData.Name].Status .. " Weapon"

                                if not v9 then
                                    if arg5.RewardData.Weapon == "IsUniversal" then
                                        return "Given to all weapons forever!"
                                    end

                                    if arg5.RewardData.Weapon == "IsRandom" then
                                        return "Given to a random weapon!"
                                    end

                                    v9 = arg5.RewardData.Weapon and "Given to " .. arg5.RewardData.Weapon .. "!" or arg5.CosmeticInfo and arg5.CosmeticInfo.Description or "???"
                                end
                            end
                        else
                            if arg5.RewardData.Weapon == "IsUniversal" then
                                return "Given to all weapons forever!"
                            end

                            if arg5.RewardData.Weapon == "IsRandom" then
                                return "Given to a random weapon!"
                            end

                            v9 = arg5.RewardData.Weapon and "Given to " .. arg5.RewardData.Weapon .. "!" or arg5.CosmeticInfo and arg5.CosmeticInfo.Description or "???"
                        end
                    else
                        if arg5.RewardData.Weapon == "IsUniversal" then
                            return "Given to all weapons forever!"
                        end

                        if arg5.RewardData.Weapon == "IsRandom" then
                            return "Given to a random weapon!"
                        end

                        v9 = arg5.RewardData.Weapon and "Given to " .. arg5.RewardData.Weapon .. "!" or arg5.CosmeticInfo and arg5.CosmeticInfo.Description or "???"
                    end
                end

                return v9
            end
        elseif arg5.RewardInfo then
            if arg5.RewardInfo.Type == "Weapon" then
                if arg5:_IsUnreleasedWeapon() then
                    v9 = "in " .. Utility_m:TimeFormat2(
                        ShopLibrary_m:GetTimeUntilWeaponRelease(arg5.RewardData.Name)
                    ) .. "!"

                    if not v9 then
                        v9 = ItemLibrary_m.Items[arg5.RewardData.Name].Status .. " Weapon"

                        if not v9 then
                            if arg5.RewardData.Weapon == "IsUniversal" then
                                return "Given to all weapons forever!"
                            elseif arg5.RewardData.Weapon == "IsRandom" then
                                return "Given to a random weapon!"
                            else
                                v9 = arg5.RewardData.Weapon and "Given to " .. arg5.RewardData.Weapon .. "!" or arg5.CosmeticInfo and arg5.CosmeticInfo.Description or "???"
                            end
                        end
                    end

                    return v9
                end

                v9 = ItemLibrary_m.Items[arg5.RewardData.Name].Status .. " Weapon"

                if not v9 then
                    if arg5.RewardData.Weapon == "IsUniversal" then
                        return "Given to all weapons forever!"
                    end

                    if arg5.RewardData.Weapon == "IsRandom" then
                        return "Given to a random weapon!"
                    end

                    v9 = arg5.RewardData.Weapon and "Given to " .. arg5.RewardData.Weapon .. "!" or arg5.CosmeticInfo and arg5.CosmeticInfo.Description or "???"
                end

                return v9
            else
                if arg5.RewardData.Weapon == "IsUniversal" then
                    return "Given to all weapons forever!"
                end

                if arg5.RewardData.Weapon == "IsRandom" then
                    return "Given to a random weapon!"
                end

                v9 = arg5.RewardData.Weapon and "Given to " .. arg5.RewardData.Weapon .. "!" or arg5.CosmeticInfo and arg5.CosmeticInfo.Description or "???"

                return v9
            end
        else
            if arg5.RewardData.Weapon == "IsUniversal" then
                return "Given to all weapons forever!"
            end

            if arg5.RewardData.Weapon == "IsRandom" then
                return "Given to a random weapon!"
            end

            v9 = arg5.RewardData.Weapon and "Given to " .. arg5.RewardData.Weapon .. "!" or arg5.CosmeticInfo and arg5.CosmeticInfo.Description or "???"

            return v9
        end
    elseif arg5.RewardInfo then
        if arg5.RewardInfo.Type == "Weapon" then
            if arg5:_IsUnreleasedWeapon() then
                v9 = "in " .. Utility_m:TimeFormat2(
                    ShopLibrary_m:GetTimeUntilWeaponRelease(arg5.RewardData.Name)
                ) .. "!"

                if not v9 then
                    v9 = ItemLibrary_m.Items[arg5.RewardData.Name].Status .. " Weapon"

                    if not v9 then
                        if arg5.RewardData.Weapon == "IsUniversal" then
                            return "Given to all weapons forever!"
                        elseif arg5.RewardData.Weapon == "IsRandom" then
                            return "Given to a random weapon!"
                        else
                            v9 = arg5.RewardData.Weapon and "Given to " .. arg5.RewardData.Weapon .. "!" or arg5.CosmeticInfo and arg5.CosmeticInfo.Description or "???"
                        end
                    end
                end

                return v9
            end

            v9 = ItemLibrary_m.Items[arg5.RewardData.Name].Status .. " Weapon"

            if not v9 then
                if arg5.RewardData.Weapon == "IsUniversal" then
                    return "Given to all weapons forever!"
                end

                if arg5.RewardData.Weapon == "IsRandom" then
                    return "Given to a random weapon!"
                end

                v9 = arg5.RewardData.Weapon and "Given to " .. arg5.RewardData.Weapon .. "!" or arg5.CosmeticInfo and arg5.CosmeticInfo.Description or "???"
            end

            return v9
        else
            if arg5.RewardData.Weapon == "IsUniversal" then
                return "Given to all weapons forever!"
            end

            if arg5.RewardData.Weapon == "IsRandom" then
                return "Given to a random weapon!"
            end

            v9 = arg5.RewardData.Weapon and "Given to " .. arg5.RewardData.Weapon .. "!" or arg5.CosmeticInfo and arg5.CosmeticInfo.Description or "???"

            return v9
        end
    else
        if arg5.RewardData.Weapon == "IsUniversal" then
            return "Given to all weapons forever!"
        end

        if arg5.RewardData.Weapon == "IsRandom" then
            return "Given to a random weapon!"
        end

        v9 = arg5.RewardData.Weapon and "Given to " .. arg5.RewardData.Weapon .. "!" or arg5.CosmeticInfo and arg5.CosmeticInfo.Description or "???"

        return v9
    end
end

function t.SetParent(arg6, arg7) -- line: 71
    arg6.Frame.Parent = arg7
end

function t.SetInteractable(arg8, arg9) -- line: 75
    arg8.Frame.Reward.Interactable = arg9

    if arg8.CosmeticSlot then
        arg8.CosmeticSlot:SetInteractable(arg9)
    end
end

function t.SetWeapon(arg10, arg11) -- line: 83
    -- upvalues:
    --  [1] ItemLibrary_m (copy)
    --  [2] WeaponStatusHandler_m (copy)

    if arg10.CosmeticSlot then
        return arg10.CosmeticSlot:SetWeapon(arg11)
    end

    local v22 = if arg11 ~= "IsRandom" then arg11 else if not arg10.RewardInfo then arg11 else if arg10.RewardInfo.Type ~= "Lootbox" then arg11 else nil

    if not v22 then
        arg10.Frame.Reward.Weapon.Visible = false

        return
    end

    local v23 = ItemLibrary_m.Items[v22]
    local v24 = ItemLibrary_m.ViewModels[v22]
    local v25 = v22 == "IsUniversal" or v22 == "IsRandom"
    local v26 = if v22 ~= "IsUniversal" then if v22 ~= "IsRandom" then if not v24 then "" else v24.ImageCentered or v24.Image else ItemLibrary_m.RANDOM_WEAPON_ICON else ItemLibrary_m.UNIVERSAL_WEAPON_ICON
    arg10.Frame.Reward.Weapon.Visible = true
    arg10.Frame.Reward.Weapon.Container.IconCanvas.Icon.Image = v26
    arg10.Frame.Reward.Weapon.Container.IconCanvas.Icon.ImageTransparency = if not v25 then 0 else 0.25
    local Icon_1 = arg10.Frame.Reward.Weapon.Container.IconCanvas.Icon
    Icon_1.Size = v25 and UDim2.new(0.7, 0, 0.7, 0) or UDim2.new(4, 0, 4, 0)
    local v28 = WeaponStatusHandler_m
    local Background = arg10.Frame.Reward.Weapon.Container.Background
    v28:ApplyItemStatusToBackground(
        Background,
        arg10.Frame.Reward.Weapon.Container.Outline.UIStroke,
        v23 and v23.Status or "Standard"
    )
end

function t.OnClick(arg12, arg13) -- line: 112
    arg12._on_click_callback = arg13
end

function t.EnableOwnedLogic(arg14, arg15) -- line: 116
    if arg14.CosmeticSlot then
        arg14.CosmeticSlot:EnableOwnedLogic(arg15)
    end
end

function t.HideWeaponVisual(arg16) -- line: 122
    arg16.Frame.Reward.Weapon.Visible = false

    if arg16.CosmeticSlot then
        arg16.CosmeticSlot.Frame.Button.Weapon.Visible = false
    end
end

function t.HideBackground(arg17) -- line: 130
    if arg17.CosmeticSlot then
        arg17.CosmeticSlot:HideBackground()
    end
end

function t.ZoomOutViewportFrame(arg18) -- line: 136
    if arg18.CosmeticSlot then
        arg18.CosmeticSlot:ZoomOutViewportFrame()
    end
end

function t.UseHighResolutionImage(arg19) -- line: 142
    if arg19.RewardInfo then
        local v30 = arg19.RewardInfo.ImageHighResolution
        local Icon_2 = arg19.Frame.Reward.Icon
        v30 = v30 or arg19.RewardInfo.Image
        Icon_2.Image = v30
    end

    if arg19.CosmeticSlot then
        arg19.CosmeticSlot:UseHighResolutionImage()
    end
end

function t.SetNameText(arg20, arg21) -- line: 152
    arg20.Frame.Reward.Title.Text = arg21

    if arg20.CosmeticSlot then
        arg20.CosmeticSlot.Frame.Button.Title.Text = arg21
    end
end

function t.LockedImage(arg22) -- line: 160
    arg22.Frame.Reward.Icon.ImageColor3 = Color3.fromRGB(0, 0, 0)
    arg22.Frame.Reward.Icon.ImageTransparency = 0.5

    if arg22.CosmeticSlot then
        arg22.CosmeticSlot.Frame.Button.Icon.ImageColor3 = Color3.fromRGB(0, 0, 0)
        arg22.CosmeticSlot.Frame.Button.Icon.ImageTransparency = 0.5
    end
end

function t.InvertNameText(arg23) -- line: 170
    if arg23.RewardInfo and arg23.RewardInfo.Type == "Weapon" then
        arg23.Frame.Reward.Title.Visible = false

        return
    end

    arg23.Frame.Reward.Title.TextColor3 = Color3.fromRGB(0, 0, 0)
    arg23.Frame.Reward.Title.UIStroke.Enabled = false
end

function t.SetBubbleAutoCloseDelay(arg24, arg25) -- line: 179
    arg24._bubble_auto_close_delay = arg25
end

function t.CloseBubble(arg26) -- line: 183
    -- upvalues:
    --  [1] RunService (copy)

    arg26._bubble_hash += 1

    for _, val in pairs(arg26._bubble_connections) do
        val:Disconnect()
    end

    arg26._bubble_connections = {}
    arg26._open_bubble_upwards = nil

    if arg26._bubble_frame then
        arg26._bubble_frame:Destroy()
        arg26._bubble_frame = nil
    end

    if arg26._bubble_reward_slot then
        arg26._bubble_reward_slot:Destroy()
        arg26._bubble_reward_slot = nil
    end

    RunService:UnbindFromRenderStep("RewardSlotOpenBubble")
end

function t.OpenBubble(arg27, arg28, arg29) -- line: 206
    -- upvalues:
    --  [1] RewardBubble (copy)
    --  [2] UILibrary_m (copy)
    --  [3] t (copy)
    --  [4] ItemLibrary_m (copy)
    --  [5] WeaponStatusHandler_m (copy)
    --  [6] GuiService (copy)
    --  [7] UserInputService (copy)
    --  [8] Players (copy)
    --  [9] RunService (copy)

    arg27:CloseBubble()
    arg27._open_bubble_upwards = arg28
    arg27._bubble_hash += 1
    local v31 = arg29 or 1
    local BubbleHash = arg27._bubble_hash
    local v32 = UDim2.new(
        RewardBubble.Size.X.Scale * v31,
        RewardBubble.Size.X.Offset * v31,
        RewardBubble.Size.Y.Scale * v31,
        RewardBubble.Size.Y.Offset * v31
    )
    local udim2 = UDim2.new(v32.X.Scale / 2, v32.X.Offset / 2, v32.Y.Scale / 2, v32.Y.Offset / 2)
    arg27._bubble_frame = RewardBubble:Clone()
    arg27._bubble_frame.Title.Text = arg27:GetRewardBubbleTitle()
    arg27._bubble_frame.Description.Text = arg27:GetRewardBubbleDescription()
    arg27._bubble_frame.Size = udim2
    arg27._bubble_frame.Parent = UILibrary_m:GetTo("MainFrame")
    arg27._bubble_frame:TweenSize(
        v32,
        "Out",
        "Back",
        0.25,
        true
    )
    arg27._bubble_reward_slot = t.new(arg27.RewardData, true)
    arg27._bubble_reward_slot:OnClick(function() -- line: 225
    end)
    arg27._bubble_reward_slot:InvertNameText()
    arg27._bubble_reward_slot:SetParent(arg27._bubble_frame.Reward)

    if arg27:_IsUnreleasedWeapon() then
        arg27._bubble_reward_slot:LockedImage()
    end

    if arg27.RewardInfo and arg27.RewardInfo.Type == "Weapon" then
        v32 = ItemLibrary_m.Items[arg27.RewardInfo.DisplayName] and ItemLibrary_m.Items[arg27.RewardInfo.DisplayName].Status
        WeaponStatusHandler_m:ApplyItemStatusToText(arg27._bubble_frame.Title, v32)
        WeaponStatusHandler_m:ApplyItemStatusToText(arg27._bubble_frame.Description, v32)
    elseif arg27.RewardData and arg27.RewardData.Weapon then
        local v33 = ItemLibrary_m.Items[arg27.RewardData.Weapon]
        local v34 = WeaponStatusHandler_m
        local Description_1 = arg27._bubble_frame.Description
        v33 = v33 and ItemLibrary_m.Items[arg27.RewardData.Weapon].Status
        v34:ApplyItemStatusToText(Description_1, v33)
    elseif arg27.RewardInfo and arg27.RewardInfo.NameStatus then
        WeaponStatusHandler_m:ApplyItemStatusToText(
            arg27._bubble_frame.Title,
            arg27.RewardInfo.NameStatus
        )
    end

    local BubbleConnections = arg27._bubble_connections
    local MenuIsOpen = GuiService:GetPropertyChangedSignal("MenuIsOpen")
    table.insert(BubbleConnections, MenuIsOpen:Connect(function() -- line: 243
        -- upvalues:
        --  [1] GuiService (ref)
        --  [2] arg27 (copy)

        if GuiService.MenuIsOpen then
            arg27:CloseBubble()
        end
    end))
    table.insert(arg27._bubble_connections, UserInputService.InputBegan:Connect(function(
        input: InputObject
    ) -- line: 249
        -- upvalues:
        --  [1] arg27 (copy)

        if
            input.UserInputType == Enum.UserInputType.MouseButton1
            or input.KeyCode == Enum.KeyCode.Return
            or input.UserInputType == Enum.UserInputType.Touch
            or input.KeyCode == Enum.KeyCode.ButtonA
            or input.KeyCode == Enum.KeyCode.ButtonB
        then
            arg27:CloseBubble()
        end
    end))
    table.insert(arg27._bubble_connections, arg27.Frame.AncestryChanged:Connect(function() -- line: 255
        -- upvalues:
        --  [1] arg27 (copy)
        --  [2] Players (ref)

        if
            not arg27.Frame:IsDescendantOf(workspace)
            and Players.LocalPlayer:FindFirstChild("PlayerGui")
            and not arg27.Frame:IsDescendantOf(Players.LocalPlayer.PlayerGui)
        then
            arg27:CloseBubble()
        end
    end))
    local BubbleConnections_3 = arg27._bubble_connections
    local AbsolutePosition = arg27.Frame:GetPropertyChangedSignal("AbsolutePosition")
    table.insert(BubbleConnections_3, AbsolutePosition:Connect(function() -- line: 261
        -- upvalues:
        --  [1] arg27 (copy)

        arg27:_UpdateBubblePosition()
    end))
    local BubbleConnections_4 = arg27._bubble_connections
    local AbsoluteSize = arg27.Frame:GetPropertyChangedSignal("AbsoluteSize")
    table.insert(BubbleConnections_4, AbsoluteSize:Connect(function() -- line: 265
        -- upvalues:
        --  [1] arg27 (copy)

        arg27:_UpdateBubblePosition()
    end))
    RunService:BindToRenderStep("RewardSlotOpenBubble", Enum.RenderPriority.Camera.Value - 1, function() -- line: 269
        -- upvalues:
        --  [1] arg27 (copy)

        arg27:_UpdateBubblePosition()
    end)
    arg27:_UpdateBubblePosition()

    if arg27._bubble_auto_close_delay then
        task.delay(arg27._bubble_auto_close_delay, function() -- line: 276
            -- upvalues:
            --  [1] arg27 (copy)
            --  [2] BubbleHash (copy)
            --  [3] udim2 (copy)

            if arg27._bubble_hash ~= BubbleHash then
                return
            end

            arg27._bubble_frame:TweenSize(
                udim2,
                "In",
                "Quint",
                0.25,
                true
            )
            wait(0.25)

            if arg27._bubble_hash ~= BubbleHash then
                return
            end

            arg27:CloseBubble()
        end)
    end
end

function t.Destroy(arg31) -- line: 294
    arg31:CloseBubble()
    arg31.Frame:Destroy()

    if arg31.CosmeticSlot then
        arg31.CosmeticSlot:Destroy()
    end
end

function t._IsUnreleasedWeapon(arg32) -- line: 307
    -- upvalues:
    --  [1] ShopLibrary_m (copy)

    local v36 = arg32.RewardInfo

    if v36 then
        v36 = if arg32.RewardInfo.Type == "Weapon" then not table.find(
            ShopLibrary_m:GetReleasedOwnableWeapons(),
            arg32.RewardData.Name
        ) else false
    end

    return v36
end

function t._OnClick(arg33) -- line: 311
    if arg33._on_click_callback then
        return arg33._on_click_callback()
    end

    arg33:OpenBubble()
end

function t._GetLayerCollector(arg34) -- line: 319
    local Parent = arg34.Frame.Parent

    while Parent do
        if Parent:IsA("LayerCollector") then
            break
        end

        Parent = Parent.Parent
    end

    return Parent
end

function t._UpdateBubblePosition(arg35) -- line: 329
    -- upvalues:
    --  [1] UILibrary_m (copy)

    if not arg35._bubble_frame.Parent then
        return
    end

    local v39 = arg35:_GetLayerCollector()
    local v40 = v39

    if v40 then
        v40 = v39:IsA("SurfaceGui")
    end

    local v42, v43

    if v40 then
        local v41 = v39.Adornee or v39.Parent

        if v41:IsA("BasePart") then
            local screenPoint = workspace.CurrentCamera:WorldToScreenPoint(v41.Position)
            v42 = if screenPoint.Z < 0 then -arg35._bubble_frame.AbsoluteSize * 10 else UILibrary_m:ScreenPointToPosition(
                screenPoint
            )
        else
            v42 = Vector2.new()
        end

        v43 = Vector2.new()
    else
        v42 = arg35.Frame.AbsolutePosition
        v43 = arg35.Frame.AbsoluteSize
    end

    v42 -= arg35._bubble_frame.Parent.AbsolutePosition
    v39 = if arg35._open_bubble_upwards ~= true then if arg35._open_bubble_upwards ~= false then v42.Y + v43.Y / 2 < arg35._bubble_frame.Parent.AbsoluteSize.Y / 2 else true else false
    local BubbleFrame_1 = arg35._bubble_frame
    local New = UDim2.new
    local clampedValue = math.clamp(
        v42.X + v43.X / 2,
        arg35._bubble_frame.AbsoluteSize.X / 2 + 10,
        arg35._bubble_frame.Parent.AbsoluteSize.X - arg35._bubble_frame.AbsoluteSize.X / 2 - 10
    )
    local Y = v42.Y
    local v45 = if not v39 then 0 else v43.Y
    BubbleFrame_1.Position = New(
        0,
        clampedValue,
        if v40 then 0 else if not v39 then -0.02 else 0.02,
        Y + v45
    )
    local BubbleFrame_2 = arg35._bubble_frame
    BubbleFrame_2.AnchorPoint = if not v39 then Vector2.new(0.5, 1) else Vector2.new(0.5, 0)
    local Arrow = arg35._bubble_frame.Arrow
    local New_1 = UDim2.new
    local clampedValue_1 = math.clamp(
        v42.X + v43.X / 2 - (arg35._bubble_frame.AbsolutePosition.X - arg35._bubble_frame.Parent.AbsolutePosition.X),
        arg35._bubble_frame.Arrow.AbsoluteSize.X * 0.875 + 10,
        arg35._bubble_frame.AbsoluteSize.X - arg35._bubble_frame.Arrow.AbsoluteSize.X * 0.875 - 10
    )
    local v47 = if not v39 then -2 else 2
    Arrow.Position = New_1(0, clampedValue_1, if v39 then 0 else 1, v47)
end

function t._Setup(arg36) -- line: 379
    -- upvalues:
    --  [1] CosmeticSlot_m (copy)
    --  [2] ItemLibrary_m (copy)
    --  [3] Utility_m (copy)
    --  [4] WeaponStatusHandler_m (copy)
    --  [5] ButtonEffect_m (copy)

    if arg36.CosmeticInfo then
        arg36.CosmeticSlot = CosmeticSlot_m.new(
            arg36.RewardData.Name,
            arg36._is_locked,
            arg36._ignore_button_effects
        )
        arg36.CosmeticSlot:SetQuantity(arg36.RewardData.Quantity)
        arg36.CosmeticSlot.Frame.Parent = arg36.Frame
        arg36.CosmeticSlot.Frame.Button.MouseButton1Click:Connect(function() -- line: 385
            -- upvalues:
            --  [1] arg36 (copy)

            arg36:_OnClick()
        end)
    elseif arg36.RewardInfo then
        local v48 = ItemLibrary_m.Items[arg36.RewardData.Name]
        local v49 = arg36.RewardInfo.Type == "Weapon" or arg36.RewardInfo.PrioritizeNameOverQuantity and (arg36.RewardData.Quantity or 1) == 1
        arg36.Frame.Reward.Visible = true
        local Title_2 = arg36.Frame.Reward.Title
        Title_2.Text = v49 and arg36.RewardInfo.DisplayName or "\195\151" .. Utility_m:PrettyNumber(
            arg36.RewardData.Quantity or 1
        )
        local Title_3 = arg36.Frame.Reward.Title
        Title_3.Size = v49 and UDim2.new(0.9, 0, 0.2, 0) or UDim2.new(0.9, 0, 0.4, 0)
        arg36.Frame.Reward.Icon.Image = arg36.RewardInfo.Image
        arg36.Frame.Reward.Icon.Size = UDim2.new(
            arg36.RewardInfo.ImageScale,
            0,
            arg36.RewardInfo.ImageScale,
            0
        )
        local v51 = WeaponStatusHandler_m
        v51:ApplyItemStatusToText(
            arg36.Frame.Reward.Title,
            arg36.RewardInfo.NameStatus or v48 and v48.Status
        )
        arg36.Frame.Reward.MouseButton1Click:Connect(function() -- line: 400
            -- upvalues:
            --  [1] arg36 (copy)

            arg36:_OnClick()
        end)

        if not arg36._ignore_button_effects then
            ButtonEffect_m:Add(arg36.Frame.Reward)
        end
    else
        warn("reward_data = {")

        for key_1, val_1 in pairs(arg36.RewardData) do
            warn("\t", key_1, val_1)
        end

        warn("}")
        assert(false, arg36.RewardData.Name)
    end

    arg36:SetWeapon(arg36.RewardData.Weapon)
end

function t._Init(arg37) -- line: 420
    arg37:_Setup()
end

return t
