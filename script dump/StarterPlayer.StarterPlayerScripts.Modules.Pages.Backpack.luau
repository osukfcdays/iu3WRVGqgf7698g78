local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local CosmeticLibrary_m = require(ReplicatedStorage.Modules.CosmeticLibrary)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local PlayerDataController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("PlayerDataController")
)
local ButtonEffect_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("ButtonEffect")
)
local PromptSystem_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("PromptSystem")
)
local RewardSlot_m = require(Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("RewardSlot"))
local Page_m = require(Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("Page"))
local CosmeticSlotEmpty = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild(
    "CosmeticSlotEmpty"
)
local t = setmetatable({}, Page_m)
t.__index = t

function t._new() -- line: 17
    -- upvalues:
    --  [1] Page_m (copy)
    --  [2] t (copy)
    --  [3] PromptSystem_m (copy)

    local t_1 = setmetatable(Page_m.new(script.Name), t)
    t_1.CloseButton = t_1.PageFrame:WaitForChild("Close")
    t_1.PromptsFrame = t_1.PageFrame:WaitForChild("Prompts")
    t_1.List = t_1.PageFrame:WaitForChild("List")
    t_1.Container = t_1.List:WaitForChild("Container")
    t_1.Layout = t_1.Container:WaitForChild("Layout")
    t_1.SlotsFrame = t_1.Container:WaitForChild("Slots")
    t_1.SlotsContainer = t_1.SlotsFrame:WaitForChild("Container")
    t_1.SlotsLayout = t_1.SlotsContainer:WaitForChild("Layout")
    t_1.PromptSystem = PromptSystem_m.new(t_1.PromptsFrame)
    t_1._slots = {}
    t_1._generation_queued = false
    t_1:_Init()

    return t_1
end

function t.Open(arg1, ...) -- line: 43
    -- upvalues:
    --  [1] Page_m (copy)

    Page_m.Open(arg1, ...)
    arg1:_Generate()
end

function t.Close(arg2, ...) -- line: 48
    -- upvalues:
    --  [1] Page_m (copy)

    Page_m.Close(arg2, ...)
    arg2:_Generate()
end

function t._Generate(arg3) -- line: 57
    -- upvalues:
    --  [1] PlayerDataController_m (copy)
    --  [2] CosmeticLibrary_m (copy)
    --  [3] Utility_m (copy)
    --  [4] RewardSlot_m (copy)
    --  [5] CosmeticSlotEmpty (copy)

    for _, val in pairs(arg3._slots) do
        val:Destroy()
    end

    arg3._slots = {}

    if not arg3:IsOpen() then
        return
    end

    local v7 = PlayerDataController_m:Get("UnclaimedRewards")

    if #v7 == 0 then
        arg3.Closed:Fire()

        return
    end

    local t_2 = table.clone(v7)
    table.sort(t_2, function(arg4, arg5) -- line: 77
        -- upvalues:
        --  [1] CosmeticLibrary_m (ref)
        --  [2] Utility_m (ref)

        local v8 = CosmeticLibrary_m.Rewards[arg4.Name] ~= nil
        local v9 = if CosmeticLibrary_m.Rewards[arg5.Name] == nil then false else true

        if v8 ~= v9 then
            return v9
        end

        local v10 = not v8 and CosmeticLibrary_m.Rarities[CosmeticLibrary_m.Cosmetics[arg4.Name].Rarity].Value
        local v11 = not v9

        if v11 then
            v11 = CosmeticLibrary_m.Rarities[CosmeticLibrary_m.Cosmetics[arg5.Name].Rarity].Value
        end

        if v10 ~= v11 then
            return v10 > v11
        end

        v11 = not v8 and CosmeticLibrary_m.Types[CosmeticLibrary_m.Cosmetics[arg4.Name].Type].Value
        v10 = not v9

        if v10 then
            v10 = CosmeticLibrary_m.Types[CosmeticLibrary_m.Cosmetics[arg5.Name].Type].Value
        end

        if v11 ~= v10 then
            return v10 < v11
        end

        v11 = arg4.Quantity or 1
        v10 = arg5.Quantity or 1
        local v14 = if v11 ~= v10 then v10 < v11 else nil
        v11 = if arg4.Name == arg5.Name then nil else Utility_m:StringLessThan(arg4.Name, arg5.Name)
        v10 = v8 and CosmeticLibrary_m.Rewards[arg4.Name].Type == "Lootbox"
        v8 = v9 and CosmeticLibrary_m.Rewards[arg5.Name].Type == "Lootbox"

        if v10 ~= v8 then
            return v8
        end

        if v10 and v8 then
            if v11 ~= nil then
                return v11
            end

            if v14 ~= nil then
                return v14
            end
        else
            if v14 ~= nil then
                return v14
            end

            if v11 ~= nil then
                return v11
            end
        end

        v14 = arg4.Weapon
        v11 = arg5.Weapon

        if v14 ~= v11 then
            if v14 and not v11 then
                return false
            end

            if not v14 and v11 then
                return true
            end

            return Utility_m:StringLessThan(arg4.Weapon, arg5.Weapon)
        end

        return false
    end)

    for key_1, val_1 in pairs(t_2) do
        local index = table.find(v7, val_1)
        local v15 = CosmeticLibrary_m.Rewards[val_1.Name]

        if v15 and v15.Type ~= "Lootbox" then
        end

        local v16 = RewardSlot_m.new(val_1)
        v16.Frame.LayoutOrder = key_1
        v16:SetParent(arg3.SlotsContainer)
        table.insert(arg3._slots, v16)
        v16:OnClick(function() -- line: 153
            -- upvalues:
            --  [1] arg3 (copy)
            --  [2] index (copy)

            arg3.PromptSystem:Open("InspectBackpackReward", index)
        end)
    end

    for _ = 1, 12 - ((#arg3._slots - 1) % 6 + 1) do
        local v17 = CosmeticSlotEmpty:Clone()
        v17.Background.BackgroundTransparency = 0.5
        v17.LayoutOrder = 9999999
        v17.Parent = arg3.SlotsContainer
        table.insert(arg3._slots, v17)
    end
end

function t._QueueGenerate(arg6) -- line: 167
    if arg6._generation_queued then
        return
    end

    arg6._generation_queued = true
    task.defer(function() -- line: 174
        -- upvalues:
        --  [1] arg6 (copy)

        arg6._generation_queued = false
        arg6:_Generate()
    end)
end

function t._Init(arg7) -- line: 180
    -- upvalues:
    --  [1] PlayerDataController_m (copy)
    --  [2] ButtonEffect_m (copy)

    arg7.CloseButton.MouseButton1Click:Connect(function() -- line: 181
        -- upvalues:
        --  [1] arg7 (copy)

        arg7:CloseRequest()
    end)
    arg7.Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() -- line: 185
        -- upvalues:
        --  [1] arg7 (copy)

        arg7.List.CanvasSize = UDim2.new(0, 0, 0, arg7.Layout.AbsoluteContentSize.Y)
        local List_1 = arg7.List
        List_1.Active = arg7.Layout.AbsoluteContentSize.Y >= arg7.List.AbsoluteSize.Y
    end)
    arg7.SlotsLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() -- line: 190
        -- upvalues:
        --  [1] arg7 (copy)

        arg7.SlotsFrame.Size = UDim2.new(1, 0, 0, arg7.SlotsLayout.AbsoluteContentSize.Y)
    end)
    arg7.PromptSystem.PromptAdded:Connect(function(arg8) -- line: 194
        -- upvalues:
        --  [1] arg7 (copy)

        if arg8.ClosePage then
            arg8.ClosePage:Connect(function() -- line: 196
                -- upvalues:
                --  [1] arg7 (ref)

                arg7.Closed:Fire()
            end)
        end
    end)
    PlayerDataController_m:GetDataChangedSignal("UnclaimedRewards"):Connect(function() -- line: 202
        -- upvalues:
        --  [1] arg7 (copy)

        arg7:_QueueGenerate()
    end)
    arg7:_Generate()
    ButtonEffect_m:Add(arg7.CloseButton)
end

return t._new()
