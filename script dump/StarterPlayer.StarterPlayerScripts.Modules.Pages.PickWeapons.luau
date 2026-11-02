local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GamepadService = game:GetService("GamepadService")
local Players = game:GetService("Players")
local _ = require(ReplicatedStorage.Modules.CONSTANTS)
local ItemLibrary_m = require(ReplicatedStorage.Modules.ItemLibrary)
local _ = require(ReplicatedStorage.Modules.ShopLibrary)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local PlayerDataController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("PlayerDataController")
)
local ControlsController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("ControlsController")
)
local FighterController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("FighterController")
)
local FFlagController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("FFlagController")
)
local DuelController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("DuelController")
)
local ButtonEffect_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("ButtonEffect")
)
local WeaponSlot_m = require(Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("WeaponSlot"))
local UILibrary_m = require(Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("UILibrary"))
local Page_m = require(Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("Page"))
local PickWeaponRandomSlot = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild(
    "PickWeaponRandomSlot"
)
local PickWeaponChosenSlot = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild(
    "PickWeaponChosenSlot"
)
local t = setmetatable({}, Page_m)
t.__index = t

function t._new() -- line: 26
    -- upvalues:
    --  [1] Page_m (copy)
    --  [2] t (copy)
    --  [3] UILibrary_m (copy)

    local t_1 = setmetatable(Page_m.new(script.Name), t)
    t_1.ChosenWeaponsFrame = t_1.PageFrame:WaitForChild("ChosenWeapons")
    t_1.HeaderFrame = t_1.PageFrame:WaitForChild("Header")
    t_1.FreeWeaponsFrame = t_1.HeaderFrame:WaitForChild("FreeWeapons")
    t_1.MapFrame = t_1.HeaderFrame:WaitForChild("Map")
    t_1.MapTitle = t_1.MapFrame:WaitForChild("Title")
    t_1.List = t_1.PageFrame:WaitForChild("List")
    t_1.Container = t_1.List:WaitForChild("Container")
    t_1.Layout = t_1.Container:WaitForChild("Layout")
    t_1.CantBeClosedFromInputs = true
    t_1.DisableGlowyBackground = true
    t_1.UseDarkBlurryBackground = true
    t_1._current_slot = 1
    t_1._chosen_weapons = {}
    t_1._chosen_weapon_slots = {}
    t_1._weapon_slot_cleanup = {}
    t_1._ban_frames = {}
    t_1._mainframe = UILibrary_m:GetTo("MainFrame")
    t_1:_Init()

    return t_1
end

function t.SetCurrentSlot(arg1, arg2) -- line: 59
    -- upvalues:
    --  [1] ItemLibrary_m (copy)
    --  [2] FighterController_m (copy)
    --  [3] Utility_m (copy)
    --  [4] PlayerDataController_m (copy)
    --  [5] WeaponSlot_m (copy)
    --  [6] PickWeaponRandomSlot (copy)
    --  [7] ButtonEffect_m (copy)

    arg1._chosen_weapon_slots[arg1._current_slot].Button.Hover.Visible = false
    arg1._current_slot = arg2
    arg1._chosen_weapon_slots[arg1._current_slot].Button.Hover.Visible = true
    arg1._chosen_weapon_slots[arg1._current_slot].Button.Background.ImageTransparency = 0
    arg1._chosen_weapon_slots[arg1._current_slot].Button.Hover.Size = UDim2.new(1.5, 0, 1.5, 0)
    arg1._chosen_weapon_slots[arg1._current_slot].Button.Hover:TweenSize(
        UDim2.new(1, 8, 1, 8),
        "Out",
        "Back",
        0.25,
        true
    )
    local _ = UDim2.new(1, 8, 1, 8)

    for _, val in pairs(arg1._weapon_slot_cleanup) do
        val:Destroy()
    end

    arg1._weapon_slot_cleanup = {}
    local t_2 = {}

    for _, val_1 in pairs(ItemLibrary_m.ItemsAlphabetized) do
        local v11 = ItemLibrary_m.Items[val_1]

        if
            v11.Class == ItemLibrary_m.SlotToClass[arg1._current_slot].Name
            or FighterController_m.LocalFighter:Get("WeaponClassRestrictionDisabled")
        then
            table.insert(t_2, v11)
        end
    end

    table.sort(t_2, function(arg3, arg4) -- line: 85
        -- upvalues:
        --  [1] ItemLibrary_m (ref)
        --  [2] Utility_m (ref)

        local v12 = ItemLibrary_m.Items[arg3.Name]
        local v13 = ItemLibrary_m.Items[arg4.Name]
        local v14

        if v12.Class ~= v13.Class then
            v14 = ItemLibrary_m.Classes[v12.Class].Slot < ItemLibrary_m.Classes[v13.Class].Slot

            return v14
        end

        if v12.Status ~= v13.Status then
            v14 = ItemLibrary_m.Statuses[v12.Status].Value > ItemLibrary_m.Statuses[v13.Status].Value

            return v14
        end

        return Utility_m:StringLessThan(arg3.Name, arg4.Name)
    end)
    local v15 = FighterController_m.LocalFighter

    if v15 then
        v15 = FighterController_m.LocalFighter:Get("LastPickedWeapons")
    end

    local t_3 = {}
    local v16 = 0

    for key_2, val_2 in pairs(t_2) do
        if FighterController_m.LocalFighter then
            local v17 = FighterController_m.LocalFighter:Get("WeaponPool")
            local v18 = if FighterController_m.LocalFighter:Get("WeaponPoolFilterType") == "Blacklist" then table.find(
                v17,
                val_2.Name
            ) else false

            if
                FighterController_m.LocalFighter
                and (FighterController_m.LocalFighter:CanUseWeapon(val_2.Name) or v18)
            then
                local v20 = PlayerDataController_m:GetWeaponData(val_2.Name)
                v17 = v15

                if v17 then
                    v17 = if table.find(v15, val_2.Name) == nil then false else true
                end

                local v22 = WeaponSlot_m.new(val_2.Name, v20)
                local v21 = if not v17 then key_2 else -999999998
                v22.Frame.LayoutOrder = v21
                v22.Frame.Parent = arg1.Container
                table.insert(arg1._weapon_slot_cleanup, v22)
                v22.PlayBanFrameSound:Connect(function(...) -- line: 125
                    -- upvalues:
                    --  [1] Utility_m (ref)

                    Utility_m:CreateSound(...)
                end)

                if v18 then
                    v22:ToggleBanned(v16 * 0.125, nil)
                    v16 += 1
                else
                    v22.Frame.Button.MouseButton1Click:Connect(function() -- line: 133
                        -- upvalues:
                        --  [1] arg1 (copy)
                        --  [2] val_2 (copy)

                        arg1:_InputPickWeapon(val_2.Name)
                    end)
                    table.insert(t_3, val_2.Name)
                end
            end
        end
    end

    if #t_3 > 1 then
        v16 = PickWeaponRandomSlot:Clone()
        v16.LayoutOrder = -9999999999
        v16.Parent = arg1.Container
        ButtonEffect_m:Add(v16.Button)
        table.insert(arg1._weapon_slot_cleanup, v16)
        v16.Button.MouseButton1Click:Connect(function() -- line: 148
            -- upvalues:
            --  [1] arg1 (copy)
            --  [2] t_3 (copy)

            arg1:_InputPickWeapon(t_3[math.random(#t_3)])
        end)
    end

    arg1.List.CanvasPosition = if FighterController_m.LocalFighter:Get(
        "WeaponClassRestrictionDisabled"
    ) then arg1.List.CanvasPosition else Vector2.new(0, 0)
end

function t.PickWeapon(arg5, arg6, arg7) -- line: 157
    -- upvalues:
    --  [1] PlayerDataController_m (copy)
    --  [2] ItemLibrary_m (copy)

    local v27 = PlayerDataController_m:GetWeaponData(arg7)
    arg5._chosen_weapons[arg6] = arg7
    local Picture = arg5._chosen_weapon_slots[arg6].Button.Picture
    Picture.Image = v27 and ItemLibrary_m:GetViewModelImageFromWeaponData(v27) or ItemLibrary_m:GetViewModelImage(
        arg7
    ) or ""
end

function t.Finish(arg8) -- line: 164
    -- upvalues:
    --  [1] DuelController_m (copy)
    --  [2] Players (copy)
    --  [3] ReplicatedStorage (copy)
    --  [4] ControlsController_m (copy)
    --  [5] GamepadService (copy)

    local v29 = DuelController_m:GetDuel(Players.LocalPlayer)

    if v29 and v29.LocalDueler and v29.LocalDueler:GetStaggeredSpawnsTurn() then
        ReplicatedStorage.Remotes.Duels.PickWeaponsAheadOfTime:FireServer(arg8._chosen_weapons)
    else
        ReplicatedStorage.Remotes.Replication.Fighter.PickWeapons:FireServer(arg8._chosen_weapons)
    end

    arg8.Closed:Fire()

    if ControlsController_m.CurrentControls == "Gamepad" then
        GamepadService:DisableGamepadCursor()
    end
end

function t.Start(arg9) -- line: 180
    -- upvalues:
    --  [1] FighterController_m (copy)
    --  [2] PickWeaponChosenSlot (copy)
    --  [3] ButtonEffect_m (copy)
    --  [4] ControlsController_m (copy)
    --  [5] GamepadService (copy)

    arg9:Clear()

    for index = 1, FighterController_m.LocalFighter:GetMaxEquippableWeapons() do
        local v30 = PickWeaponChosenSlot:Clone()
        v30.LayoutOrder = index
        v30.Parent = arg9.ChosenWeaponsFrame
        ButtonEffect_m:Add(v30.Button)
        arg9._chosen_weapon_slots[index] = v30
        v30.Button.MouseButton1Click:Connect(function() -- line: 190
            -- upvalues:
            --  [1] index (copy)
            --  [2] arg9 (copy)

            if index == 1 or arg9._chosen_weapons[index - 1] then
                arg9:SetCurrentSlot(index)
            end
        end)
    end

    arg9:SetCurrentSlot(1)

    if ControlsController_m.CurrentControls == "Gamepad" then
        GamepadService:EnableGamepadCursor(arg9.ChosenWeaponsFrame)
    end

    arg9:_UpdateMap()
    arg9:_UpdateFreeWeapons()
end

function t.Clear(arg10) -- line: 207
    for _, val_3 in pairs(arg10._chosen_weapon_slots) do
        val_3:Destroy()
    end

    for _, val_4 in pairs(arg10._weapon_slot_cleanup) do
        val_4:Destroy()
    end

    for _, val_5 in pairs(arg10._ban_frames) do
        val_5:Destroy()
    end

    arg10._current_slot = 1
    arg10._chosen_weapons = {}
    arg10._chosen_weapon_slots = {}
    arg10._weapon_slot_cleanup = {}
    arg10._ban_frames = {}
end

function t.Open(arg11, ...) -- line: 227
    -- upvalues:
    --  [1] Page_m (copy)

    Page_m.Open(arg11, ...)
    arg11:Start()
end

function t._UpdateList(arg12) -- line: 236
    arg12.List.CanvasSize = UDim2.new(0, 0, 0, arg12.Layout.AbsoluteContentSize.Y)
    local List_2 = arg12.List
    List_2.ClipsDescendants = arg12.List.CanvasPosition.Y > 5
    arg12.List.Size = UDim2.new(
        1,
        0,
        0,
        arg12._mainframe.AbsolutePosition.Y + arg12._mainframe.AbsoluteSize.Y - arg12.List.AbsolutePosition.Y
    )
end

function t._InputPickWeapon(arg13, arg14) -- line: 242
    -- upvalues:
    --  [1] FighterController_m (copy)

    arg13:PickWeapon(arg13._current_slot, arg14)

    if arg13._current_slot == FighterController_m.LocalFighter:GetMaxEquippableWeapons() then
        arg13:Finish()

        return
    end

    arg13:SetCurrentSlot(arg13._current_slot + 1)
end

function t._UpdateFreeWeapons(arg15) -- line: 252
    -- upvalues:
    --  [1] FFlagController_m (copy)

    arg15.FreeWeaponsFrame.Visible = FFlagController_m:IsFreeWeaponsActive()
    arg15:_UpdateMap()
end

function t._UpdateMap(arg16) -- line: 257
    -- upvalues:
    --  [1] DuelController_m (copy)
    --  [2] Players (copy)
    --  [3] FighterController_m (copy)

    local v33 = DuelController_m:GetDuel(Players.LocalPlayer)
    local v34 = v33

    if v34 then
        v34 = v33.Map and v33.Map.Name
    end

    local v35 = FighterController_m.LocalFighter

    if v35 then
        v35 = FighterController_m.LocalFighter:Get("IsInShootingRange")
    end

    local MapFrame = arg16.MapFrame
    MapFrame.Visible = if v34 then not arg16.FreeWeaponsFrame.Visible else v35 and not arg16.FreeWeaponsFrame.Visible
    local MapTitle = arg16.MapTitle
    MapTitle.Text = v34 and "Map: " .. v34 or (if not v35 then "" else "Try out any weapon here for free!")
end

function t._Init(arg17) -- line: 267
    arg17.Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() -- line: 268
        -- upvalues:
        --  [1] arg17 (copy)

        arg17:_UpdateList()
    end)
    arg17.List:GetPropertyChangedSignal("CanvasPosition"):Connect(function() -- line: 272
        -- upvalues:
        --  [1] arg17 (copy)

        arg17:_UpdateList()
    end)
    arg17:_UpdateList()
end

return t._new()
