local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local CosmeticLibrary_m = require(ReplicatedStorage.Modules.CosmeticLibrary)
local Signal_m = require(ReplicatedStorage.Modules.Signal)
local ButtonEffect_m = require(Players.LocalPlayer.PlayerScripts.Modules.ButtonEffect)
local Pages_m = require(Players.LocalPlayer.PlayerScripts.Modules.UserInterface.Pages)
local PlayerDataController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.PlayerDataController
)
local t = {}
t.__index = t

function t.new(arg1) -- line: 13
    -- upvalues:
    --  [1] t (copy)
    --  [2] Signal_m (copy)

    local t_1 = setmetatable({}, t)
    t_1.SearchUpdated = Signal_m.new()
    t_1.Customize = arg1
    t_1.Frame = t_1.Customize.BottomContainer:WaitForChild("Actions")
    t_1.BackButton = t_1.Frame:WaitForChild("Back")
    t_1.EmoteButton = t_1.Frame:WaitForChild("Emote")
    t_1.EmoteButtonEquipFrame = t_1.EmoteButton:WaitForChild("Equip")
    t_1.EmoteButtonUnequipFrame = t_1.EmoteButton:WaitForChild("Unequip")
    t_1.SearchFrame = t_1.Frame:WaitForChild("Search")
    t_1.SearchBox = t_1.SearchFrame:WaitForChild("Box")
    t_1:_Init()

    return t_1
end

function t.OnCustomizingStateChanged(arg2) -- line: 36
    arg2:_UpdateEmoteButton()
end

function t.OnStateChanged(arg3) -- line: 40
    arg3:_UpdateEmoteButton()

    if not arg3.Customize.Interface.Equipment:IsCustomizing() then
        arg3.SearchBox.Text = ""
    end
end

function t._UpdateEmoteButton(arg4) -- line: 52
    -- upvalues:
    --  [1] CosmeticLibrary_m (copy)
    --  [2] PlayerDataController_m (copy)

    local v1 = arg4.Customize.Interface.Equipment:GetSelectedCosmetic()
    local v2 = CosmeticLibrary_m.Cosmetics[v1]
    local v3 = v2

    if v3 then
        v3 = v2.Type == "Emote"
    end

    v2 = v3

    if v2 then
        v2 = CosmeticLibrary_m:OwnsCosmetic(
            PlayerDataController_m:Get("CosmeticInventory"),
            v1,
            arg4.Customize.Interface.Equipment:GetSelectedWeapon()
        )
    end

    local v6 = v3

    if v6 then
        v6 = PlayerDataController_m:IsEmoteEquipped(v1)
    end

    arg4.EmoteButton.Visible = v2
    arg4.EmoteButtonEquipFrame.Visible = not v6
    arg4.EmoteButtonUnequipFrame.Visible = v6
    local SearchFrame = arg4.SearchFrame
    SearchFrame.Size = v2 and UDim2.new(0.75, -10, 1, 0) or UDim2.new(0.875, -5, 1, 0)
end

function t._UpdateSearch(arg5) -- line: 65
    arg5.Customize.Interface.Equipment:SetCosmeticSearchQuery(arg5.SearchBox.Text)
end

function t._Init(arg6) -- line: 69
    -- upvalues:
    --  [1] Pages_m (copy)
    --  [2] PlayerDataController_m (copy)
    --  [3] ButtonEffect_m (copy)

    arg6.SearchBox:GetPropertyChangedSignal("Text"):Connect(function() -- line: 70
        -- upvalues:
        --  [1] arg6 (copy)

        arg6:_UpdateSearch()
    end)
    arg6.BackButton.MouseButton1Click:Connect(function() -- line: 74
        -- upvalues:
        --  [1] arg6 (copy)

        arg6.Customize.Interface.Equipment:CloseRequest()
    end)
    arg6.EmoteButton.MouseButton1Click:Connect(function() -- line: 78
        -- upvalues:
        --  [1] Pages_m (ref)
        --  [2] arg6 (copy)

        Pages_m.PageSystem:OpenPage("EquipEmote")
        Pages_m.PageSystem:WaitForPage("EquipEmote"):SetEmoteName(
            arg6.Customize.Interface.Equipment:GetSelectedCosmetic()
        )
    end)
    PlayerDataController_m:GetDataChangedSignal("CosmeticInventory"):Connect(function() -- line: 83
        -- upvalues:
        --  [1] arg6 (copy)

        arg6:_UpdateEmoteButton()
    end)
    local t_2 = { HoverRatio = UDim2.new(0, 10, 0, 10), ReleaseRatio = UDim2.new(0, 10, 0, 10) }
    ButtonEffect_m:Add(arg6.BackButton, nil, t_2)
    local t_3 = { HoverRatio = UDim2.new(0, 10, 0, 10), ReleaseRatio = UDim2.new(0, 10, 0, 10) }
    ButtonEffect_m:Add(arg6.EmoteButton, nil, t_3)
end

return t
