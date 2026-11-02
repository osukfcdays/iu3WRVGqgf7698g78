local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local CONSTANTS_m = require(ReplicatedStorage.Modules.CONSTANTS)
local CosmeticLibrary_m = require(ReplicatedStorage.Modules.CosmeticLibrary)
local ItemLibrary_m = require(ReplicatedStorage.Modules.ItemLibrary)
local ShopLibrary_m = require(ReplicatedStorage.Modules.ShopLibrary)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local PlayerDataController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("PlayerDataController")
)
local WeaponStatusHandler_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("WeaponStatusHandler")
)
local ButtonEffect_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("ButtonEffect")
)
local CosmeticSlot_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("CosmeticSlot")
)
local PromptSystem_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("PromptSystem")
)
local WeaponSlot_m = require(Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("WeaponSlot"))
local Page_m = require(Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("Page"))
local CosmeticSlotBubble = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild(
    "CosmeticSlotBubble"
)
local t = { "Weapon", "Skin", "Wrap", "Charm", "Finisher", "Emote" }
local t_1 = setmetatable({}, Page_m)
t_1.__index = t_1

function t_1._new() -- line: 23
    -- upvalues:
    --  [1] Page_m (copy)
    --  [2] t_1 (copy)
    --  [3] PromptSystem_m (copy)

    local t_2 = setmetatable(Page_m.new(script.Name), t_1)
    t_2.CloseButton = t_2.PageFrame:WaitForChild("Close")
    t_2.PromptsFrame = t_2.PageFrame:WaitForChild("Prompts")
    t_2.List = t_2.PageFrame:WaitForChild("List")
    t_2.Container = t_2.List:WaitForChild("Container")
    t_2.Layout = t_2.Container:WaitForChild("Layout")
    t_2.TabsFrame = t_2.Container:WaitForChild("Tabs")
    t_2.SlotsFrame = t_2.Container:WaitForChild("Slots")
    t_2.SlotsContainer = t_2.SlotsFrame:WaitForChild("Container")
    t_2.SlotsLayout = t_2.SlotsContainer:WaitForChild("Layout")
    t_2.SearchFrame = t_2.Container:WaitForChild("Search")
    t_2.SearchBox = t_2.SearchFrame:WaitForChild("Box")
    t_2.LockedSlotsFrame = t_2.Container:WaitForChild("LockedSlots")
    t_2.LockedSlotsContainer = t_2.LockedSlotsFrame:WaitForChild("Container")
    t_2.LockedSlotsLayout = t_2.LockedSlotsContainer:WaitForChild("Layout")
    t_2.Divider = t_2.Container:WaitForChild("Divider")
    t_2.CurrentTab = nil
    t_2.PromptSystem = PromptSystem_m.new(t_2.PromptsFrame)
    t_2._slots = {}
    t_2._close_bubbles = {}
    t_2._generate_hash = 0
    t_2._search_query = ""
    t_2:_Init()

    return t_2
end

function t_1.SetTab(arg1, arg2) -- line: 59
    -- upvalues:
    --  [1] t (copy)

    arg1.CurrentTab = arg2

    for _, val in pairs(t) do
        local v9 = if val ~= arg1.CurrentTab then false else true
        local v10 = arg1.TabsFrame:WaitForChild(val)
        local Background = v10:WaitForChild("Background")
        local Title = v10:WaitForChild("Title")
        local v11 = v9 and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(255, 255, 255)
        Title.TextColor3 = v11
        v11 = v9 and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(0, 0, 0)
        Background.ImageColor3 = v11
        v11 = if not v9 then 0.25 else 0
        Background.ImageTransparency = v11
        Background:WaitForChild("UIGradient").Enabled = not v9
    end

    arg1:_Generate()
end

function t_1.Open(arg3, ...) -- line: 77
    -- upvalues:
    --  [1] Page_m (copy)

    Page_m.Open(arg3, ...)
    arg3.SearchBox.Text = ""
    arg3:_Generate()
end

function t_1.Close(arg4) -- line: 83
    -- upvalues:
    --  [1] Page_m (copy)

    Page_m.Close(arg4)
    arg4:_Generate()
end

function t_1._UpdateLayouts(arg5) -- line: 92
    arg5.List.CanvasSize = UDim2.new(0, 0, 0, arg5.Layout.AbsoluteContentSize.Y)
    local List_1 = arg5.List
    List_1.Active = arg5.Layout.AbsoluteContentSize.Y >= arg5.List.AbsoluteSize.Y
    arg5.SlotsFrame.Size = UDim2.new(1, 0, 0, arg5.SlotsLayout.AbsoluteContentSize.Y)
    local SlotsFrame_1 = arg5.SlotsFrame
    SlotsFrame_1.Visible = arg5.SlotsLayout.AbsoluteContentSize.Y > 0
    arg5.LockedSlotsFrame.Size = UDim2.new(1, 0, 0, arg5.LockedSlotsLayout.AbsoluteContentSize.Y)
    local LockedSlotsFrame_1 = arg5.LockedSlotsFrame
    LockedSlotsFrame_1.Visible = arg5.LockedSlotsLayout.AbsoluteContentSize.Y > 0
end

function t_1._UpdateSearch(arg6, arg7) -- line: 101
    -- upvalues:
    --  [1] Utility_m (copy)

    arg7.Frame.Visible = Utility_m:IsVisibleFromSearch(
        arg6._search_query,
        table.unpack(arg7.SearchArgs)
    )
end

function t_1._BulkUpdateSearch(arg8) -- line: 105
    arg8._search_query = string.lower(arg8.SearchBox.Text)

    for _, val_1 in pairs(arg8._slots) do
        arg8:_UpdateSearch(val_1)
    end
end

function t_1._CloseBubbles(arg9) -- line: 113
    for _, val_2 in pairs(arg9._close_bubbles) do
        val_2()
    end
end

function t_1._GenerateWeapons(arg10) -- line: 119
    -- upvalues:
    --  [1] PlayerDataController_m (copy)
    --  [2] ShopLibrary_m (copy)
    --  [3] CONSTANTS_m (copy)
    --  [4] ItemLibrary_m (copy)
    --  [5] WeaponSlot_m (copy)
    --  [6] CosmeticSlotBubble (copy)
    --  [7] WeaponStatusHandler_m (copy)

    local GenerateHash = arg10._generate_hash
    local v14 = PlayerDataController_m:GetUnlockedWeapons()

    for key_3, val_3 in pairs(
        ShopLibrary_m:GetReleasedOwnableWeapons(
            CONSTANTS_m.WEAPON_REVEAL_TIME_OFFSET,
            ShopLibrary_m.OwnableWeaponsAlphabetized
        )
    ) do
        if GenerateHash ~= arg10._generate_hash then
            return
        end

        local v16 = ItemLibrary_m.Items[val_3]
        local v17 = not v14[val_3]
        local v18 = v16.Status .. " " .. v16.Class
        local v19 = ItemLibrary_m.Statuses[v16.Status]
        local v20 = WeaponSlot_m.new(val_3)
        v20.Frame.LayoutOrder = key_3 - v19.Value * 999999
        local Frame_1 = v20.Frame
        local v21 = v17 and arg10.LockedSlotsContainer or arg10.SlotsContainer
        Frame_1.Parent = v21

        if v17 then
            v20:Lock()

            if not ShopLibrary_m:IsWeaponReleased(val_3) then
                v20:HideName()
            end
        end

        local v22 = nil

        local function update_background() -- line: 147
            -- upvalues:
            --  [1] v22 (ref)

            v22.Background.Size = UDim2.new(
                0,
                v22.Title.TextBounds.X + v22.Background.AbsoluteSize.Y,
                1,
                0
            )
        end

        arg10._close_bubbles[val_3] = function() -- line: 151
            -- upvalues:
            --  [1] v20 (copy)
            --  [2] v22 (ref)

            v20.Frame.ZIndex = 0

            if v22 then
                v22:Destroy()
                v22 = nil
            end
        end

        local function open_bubble() -- line: 160
            -- upvalues:
            --  [1] arg10 (copy)
            --  [2] v20 (copy)
            --  [3] v22 (ref)
            --  [4] CosmeticSlotBubble (ref)
            --  [5] v18 (copy)
            --  [6] WeaponStatusHandler_m (ref)
            --  [7] v16 (copy)
            --  [8] update_background (copy)

            arg10:_CloseBubbles()
            v20.Frame.ZIndex = 1
            v22 = CosmeticSlotBubble:Clone()
            v22.Title.Text = v18
            v22.Parent = v20.Frame.Button
            WeaponStatusHandler_m:ApplyItemStatusToText(v22.Title, v16.Status)

            local _ = function() --[[ update ]] -- line: 171
                -- upvalues:
                --  [1] v22 (ref)

                v22.Background.Size = UDim2.new(
                    0,
                    v22.Title.TextBounds.X + v22.Background.AbsoluteSize.Y,
                    1,
                    0
                )
            end

            v22.Background:GetPropertyChangedSignal("AbsoluteSize"):Connect(update_background)
            v22.Title:GetPropertyChangedSignal("TextBounds"):Connect(update_background)
            v22.Background.Size = UDim2.new(
                0,
                v22.Title.TextBounds.X + v22.Background.AbsoluteSize.Y,
                1,
                0
            )
            v22.Size = UDim2.new(0, 0, 0.125, 0)
            v22:TweenSize(
                UDim2.new(5, 0, 0.25, 0),
                "Out",
                "Quint",
                0.25,
                true
            )
        end

        v20.Frame.Button.MouseEnter:Connect(open_bubble)
        v20.Frame.Button.MouseButton1Click:Connect(open_bubble)

        if not v17 then
            arg10.Divider.Visible = true
        end

        local t_3 = {
            Object = v20,
            Frame = v20.Frame,
            SearchArgs = { v20.Frame.Button.Title.Text, v20.Frame.Button.Title, v18, nil }
        }
        table.insert(arg10._slots, t_3)
        arg10:_UpdateSearch(t_3)

        if key_3 % 5 == 0 then
            wait(0.03)
        end
    end
end

function t_1._GenerateCosmetics(arg11) -- line: 208
    -- upvalues:
    --  [1] PlayerDataController_m (copy)
    --  [2] CosmeticLibrary_m (copy)
    --  [3] ShopLibrary_m (copy)
    --  [4] CosmeticSlot_m (copy)
    --  [5] CosmeticSlotBubble (copy)

    local v25 = PlayerDataController_m:GetUnlockedWeapons()
    local v26 = PlayerDataController_m:Get("CosmeticInventory")
    local GenerateHash_1 = arg11._generate_hash

    for key_4, val_4 in pairs(CosmeticLibrary_m.CosmeticsAlphabetized) do
        if GenerateHash_1 ~= arg11._generate_hash then
            return
        end

        local v27 = CosmeticLibrary_m.Cosmetics[val_4]

        if
            v27.Type == arg11.CurrentTab
            and (v27.Type ~= "Skin" or v25[v27.ItemName] or ShopLibrary_m:IsWeaponReleased(
                v27.ItemName
            ))
        then
            local v28 = v26
            local v29 = not CosmeticLibrary_m:OwnsCosmeticForSomething(v28, val_4)

            if not v27.Hidden or not v29 then
                local v30 = arg11.Divider.Visible
                local Divider = arg11.Divider
                v30 = v30 or not v29
                Divider.Visible = v30
                local Divider = CosmeticSlot_m.new(val_4, v29)
                local Frame_2 = Divider.Frame
                local v32 = key_4 - CosmeticLibrary_m.Rarities[v27.Rarity].Value * 10000
                local v33 = if not v29 then 0 else 9999999
                Frame_2.LayoutOrder = v32 + v33
                local Frame_3 = Divider.Frame
                v28 = v29 and arg11.LockedSlotsContainer or arg11.SlotsContainer
                Frame_3.Parent = v28
                local v34 = nil

                local function v28() --[[ update_background ]] -- line: 242
                    -- upvalues:
                    --  [1] v34 (ref)

                    v34.Background.Size = UDim2.new(
                        0,
                        v34.Title.TextBounds.X + v34.Background.AbsoluteSize.Y,
                        1,
                        0
                    )
                end

                arg11._close_bubbles[val_4] = function() -- line: 246
                    -- upvalues:
                    --  [1] Divider (copy)
                    --  [2] v34 (ref)

                    Divider.Frame.ZIndex = 0

                    if v34 then
                        v34:Destroy()
                        v34 = nil
                    end
                end

                local function v32() --[[ open_bubble ]] -- line: 255
                    -- upvalues:
                    --  [1] v27 (copy)
                    --  [2] arg11 (copy)
                    --  [3] Divider (copy)
                    --  [4] v34 (ref)
                    --  [5] CosmeticSlotBubble (ref)
                    --  [6] v28 (copy)

                    if not v27.Description then
                        return
                    end

                    arg11:_CloseBubbles()
                    Divider.Frame.ZIndex = 1
                    v34 = CosmeticSlotBubble:Clone()
                    v34.Title.Text = v27.Description or ""
                    v34.Parent = Divider.Frame.Button

                    local _ = function() --[[ update ]] -- line: 268
                        -- upvalues:
                        --  [1] v34 (ref)

                        v34.Background.Size = UDim2.new(
                            0,
                            v34.Title.TextBounds.X + v34.Background.AbsoluteSize.Y,
                            1,
                            0
                        )
                    end

                    v34.Title:GetPropertyChangedSignal("TextBounds"):Connect(v28)
                    v34.Background:GetPropertyChangedSignal("AbsoluteSize"):Connect(v28)
                    v34.Background.Size = UDim2.new(
                        0,
                        v34.Title.TextBounds.X + v34.Background.AbsoluteSize.Y,
                        1,
                        0
                    )
                    v34.Size = UDim2.new(0, 0, 0.125, 0)
                    v34:TweenSize(
                        UDim2.new(5, 0, 0.25, 0),
                        "Out",
                        "Quint",
                        0.25,
                        true
                    )
                end

                Divider.Frame.Button.MouseEnter:Connect(v32)
                Divider.Frame.Button.MouseButton1Click:Connect(function() -- line: 282
                    -- upvalues:
                    --  [1] CosmeticLibrary_m (ref)
                    --  [2] v27 (copy)
                    --  [3] v29 (copy)
                    --  [4] arg11 (copy)
                    --  [5] val_4 (copy)
                    --  [6] v32 (copy)

                    if CosmeticLibrary_m.Types[v27.Type].IsWeaponCosmetic and v27.Type ~= "Skin" and not v29 then
                        arg11:_CloseBubbles()
                        arg11.PromptSystem:Open("InspectCosmetic", val_4)

                        return
                    end

                    v32()
                end)
                local t_5 = {
                    Object = Divider,
                    Frame = Divider.Frame,
                    SearchArgs = {
                        Divider.Frame.Button.Title.ContentText,
                        Divider.Frame.Button.Title,
                        v27.Description,
                        nil
                    }
                }
                table.insert(arg11._slots, t_5)
                arg11:_UpdateSearch(t_5)

                if key_4 % 5 == 0 then
                    wait(0.03)
                end
            end
        end
    end
end

function t_1._Generate(arg12) -- line: 309
    for _, val_5 in pairs(arg12._slots) do
        val_5.Object:Destroy()
    end

    arg12._slots = {}
    arg12._close_bubbles = {}
    arg12._generate_hash += 1
    arg12.Divider.Visible = false
    arg12:_UpdateLayouts()

    if not arg12._is_open then
        return
    end

    task.spawn(function() -- line: 325
        -- upvalues:
        --  [1] arg12 (copy)

        if arg12.CurrentTab == "Weapon" then
            arg12:_GenerateWeapons()
        else
            arg12:_GenerateCosmetics()
        end

        arg12:_UpdateLayouts()
    end)
end

function t_1._Setup(arg13) -- line: 336
    -- upvalues:
    --  [1] t (copy)
    --  [2] ButtonEffect_m (copy)

    for _, val_6 in pairs(t) do
        local v37 = arg13.TabsFrame:WaitForChild(val_6)
        v37.MouseButton1Click:Connect(function() -- line: 340
            -- upvalues:
            --  [1] arg13 (copy)
            --  [2] val_6 (copy)

            arg13:SetTab(val_6)
        end)
        ButtonEffect_m:Add(v37)
    end
end

function t_1._Init(arg14) -- line: 348
    -- upvalues:
    --  [1] ButtonEffect_m (copy)

    arg14.CloseButton.MouseButton1Click:Connect(function() -- line: 349
        -- upvalues:
        --  [1] arg14 (copy)

        arg14:CloseRequest()
    end)
    arg14.Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() -- line: 353
        -- upvalues:
        --  [1] arg14 (copy)

        arg14:_UpdateLayouts()
    end)
    arg14.SlotsLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() -- line: 357
        -- upvalues:
        --  [1] arg14 (copy)

        arg14:_UpdateLayouts()
    end)
    arg14.LockedSlotsLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() -- line: 361
        -- upvalues:
        --  [1] arg14 (copy)

        arg14:_UpdateLayouts()
    end)
    arg14.SearchBox:GetPropertyChangedSignal("Text"):Connect(function() -- line: 365
        -- upvalues:
        --  [1] arg14 (copy)

        arg14:_BulkUpdateSearch()
    end)
    arg14:_Setup()
    arg14:SetTab("Weapon")
    ButtonEffect_m:Add(arg14.CloseButton)
end

return t_1._new()
