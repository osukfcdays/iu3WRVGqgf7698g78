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
local WeaponStatusHandler_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("WeaponStatusHandler")
)
local ButtonEffect_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("ButtonEffect")
)
local VoteBanFrame_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("VoteBanFrame")
)
local Page_m = require(Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("Page"))
local PickWeaponRandomListSlot = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild(
    "PickWeaponRandomListSlot"
)
local PickWeaponListChosenSlot = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild(
    "PickWeaponListChosenSlot"
)
local PickWeaponListSlot = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild(
    "PickWeaponListSlot"
)
local t = setmetatable({}, Page_m)
t.__index = t

function t._new() -- line: 27
    -- upvalues:
    --  [1] Page_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(Page_m.new(script.Name), t)
    t_1.ChosenWeaponsFrame = t_1.PageFrame:WaitForChild("ChosenWeapons")
    t_1.HeaderFrame = t_1.PageFrame:WaitForChild("Header")
    t_1.FreeWeaponsFrame = t_1.HeaderFrame:WaitForChild("FreeWeapons")
    t_1.MapFrame = t_1.HeaderFrame:WaitForChild("Map")
    t_1.MapTitle = t_1.MapFrame:WaitForChild("Title")
    t_1.ListContainer = t_1.PageFrame:WaitForChild("ListContainer")
    t_1.List = t_1.ListContainer:WaitForChild("List")
    t_1.Container = t_1.List:WaitForChild("Container")
    t_1.Layout = t_1.Container:WaitForChild("Layout")
    t_1.LastPickedDivider = t_1.Container:WaitForChild("LastPickedDivider")
    t_1.CantBeClosedFromInputs = true
    t_1.DisableGlowyBackground = true
    t_1.UseDarkBlurryBackground = true
    t_1._current_slot = 1
    t_1._chosen_weapons = {}
    t_1._chosen_weapon_slots = {}
    t_1._pick_weapon_slots = {}
    t_1._ban_frames = {}
    t_1:_Init()

    return t_1
end

function t.SetCurrentSlot(arg1, arg2) -- line: 61
    -- upvalues:
    --  [1] ItemLibrary_m (copy)
    --  [2] FighterController_m (copy)
    --  [3] Utility_m (copy)
    --  [4] PlayerDataController_m (copy)
    --  [5] PickWeaponListSlot (copy)
    --  [6] ButtonEffect_m (copy)
    --  [7] WeaponStatusHandler_m (copy)
    --  [8] VoteBanFrame_m (copy)
    --  [9] PickWeaponRandomListSlot (copy)

    arg1._chosen_weapon_slots[arg1._current_slot].Button.Hover.Visible = false
    arg1._current_slot = arg2
    arg1.ChosenWeaponsFrame:TweenPosition(
        UDim2.new(0.5 - 0.125 * (arg1._current_slot - 1), 0, 0.1, 0),
        "Out",
        "Quint",
        0.25,
        true
    )
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

    for _, val in pairs(arg1._pick_weapon_slots) do
        val:Destroy()
    end

    arg1._pick_weapon_slots = {}
    arg1.LastPickedDivider.Visible = false
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

    table.sort(t_2, function(arg3, arg4) -- line: 89
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

                local v21 = PickWeaponListSlot:Clone()
                v21.LayoutOrder = if v17 then -3 else key_2 * 2
                v21.ZIndex = v21.LayoutOrder
                local Picture = v21.Button.Icon.Picture
                local v23 = v20 and ItemLibrary_m:GetViewModelImageFromWeaponData(v20) or ItemLibrary_m:GetViewModelImage(
                    val_2.Name
                ) or ""
                Picture.Image = v23
                v21.Button.Title.Text = val_2.Name
                v21.Parent = arg1.Container
                ButtonEffect_m:Add(v21.Button, nil, { HoverRatio = 1.025, ReleaseRatio = 1.025 })
                table.insert(arg1._pick_weapon_slots, v21)
                WeaponStatusHandler_m:ApplyItemStatusToText(v21.Button.Title, val_2.Status)

                if v18 then
                    v21.Button.Icon.ClipsDescendants = true
                    v21.Button.Title.Visible = false
                    local v24 = VoteBanFrame_m.new(v21.Button, UDim2.new(1, 0, 0.9, 0))
                    table.insert(arg1._ban_frames, v24)
                    v24.CreateSound:Connect(function(...) -- line: 142
                        -- upvalues:
                        --  [1] Utility_m (ref)

                        Utility_m:CreateSound(...)
                    end)
                    task.delay(
                        v16 * 0.125,
                        v24.Play,
                        v24,
                        nil,
                        true
                    )
                    v16 += 1
                else
                    v21.Button.MouseButton1Click:Connect(function() -- line: 149
                        -- upvalues:
                        --  [1] arg1 (copy)
                        --  [2] val_2 (copy)

                        arg1:_InputPickWeapon(val_2.Name)
                    end)
                    table.insert(t_3, val_2.Name)
                end

                arg1.LastPickedDivider.Visible = arg1.LastPickedDivider.Visible or v17
            end
        end
    end

    if #t_3 > 1 then
        v16 = PickWeaponRandomListSlot:Clone()
        v16.LayoutOrder = -1
        v16.Parent = arg1.Container
        ButtonEffect_m:Add(v16.Button, nil, { HoverRatio = 1.025, ReleaseRatio = 1.025 })
        table.insert(arg1._pick_weapon_slots, v16)
        v16.Button.MouseButton1Click:Connect(function() -- line: 166
            -- upvalues:
            --  [1] arg1 (copy)
            --  [2] t_3 (copy)

            arg1:_InputPickWeapon(t_3[math.random(#t_3)])
        end)
    end

    table.sort(arg1._pick_weapon_slots, function(arg5, arg6) -- line: 171
        return arg5.LayoutOrder < arg6.LayoutOrder
    end)

    for key_3, val_3 in pairs(arg1._pick_weapon_slots) do
        val_3.Button.Size = UDim2.new(0.75, 0, 1, 0)
        val_3.Button:TweenSize(
            UDim2.new(1, 0, 1, 0),
            "Out",
            "Back",
            0.05 * key_3,
            true
        )
    end

    arg1.List.CanvasPosition = if FighterController_m.LocalFighter:Get(
        "WeaponClassRestrictionDisabled"
    ) then arg1.List.CanvasPosition else Vector2.new(0, 0)
end

function t.PickWeapon(arg7, arg8, arg9) -- line: 184
    -- upvalues:
    --  [1] PlayerDataController_m (copy)
    --  [2] ItemLibrary_m (copy)

    local v30 = PlayerDataController_m:GetWeaponData(arg9)
    arg7._chosen_weapons[arg8] = arg9
    local Picture_1 = arg7._chosen_weapon_slots[arg8].Button.Picture
    Picture_1.Image = v30 and ItemLibrary_m:GetViewModelImageFromWeaponData(v30) or ItemLibrary_m:GetViewModelImage(
        arg9
    ) or ""
end

function t.Finish(arg10) -- line: 191
    -- upvalues:
    --  [1] DuelController_m (copy)
    --  [2] Players (copy)
    --  [3] ReplicatedStorage (copy)
    --  [4] ControlsController_m (copy)
    --  [5] GamepadService (copy)

    local v32 = DuelController_m:GetDuel(Players.LocalPlayer)

    if v32 and v32.LocalDueler and v32.LocalDueler:GetStaggeredSpawnsTurn() then
        ReplicatedStorage.Remotes.Duels.PickWeaponsAheadOfTime:FireServer(arg10._chosen_weapons)
    else
        ReplicatedStorage.Remotes.Replication.Fighter.PickWeapons:FireServer(arg10._chosen_weapons)
    end

    arg10.Closed:Fire()

    if ControlsController_m.CurrentControls == "Gamepad" then
        GamepadService:DisableGamepadCursor()
    end
end

function t.Start(arg11) -- line: 207
    -- upvalues:
    --  [1] FighterController_m (copy)
    --  [2] PickWeaponListChosenSlot (copy)
    --  [3] ButtonEffect_m (copy)
    --  [4] ControlsController_m (copy)
    --  [5] GamepadService (copy)

    arg11:Clear()

    for index = 1, FighterController_m.LocalFighter:GetMaxEquippableWeapons() do
        local v33 = PickWeaponListChosenSlot:Clone()
        v33.LayoutOrder = index
        v33.Parent = arg11.ChosenWeaponsFrame
        ButtonEffect_m:Add(v33.Button)
        arg11._chosen_weapon_slots[index] = v33
        v33.Button.MouseButton1Click:Connect(function() -- line: 217
            -- upvalues:
            --  [1] index (copy)
            --  [2] arg11 (copy)

            if index == 1 or arg11._chosen_weapons[index - 1] then
                arg11:SetCurrentSlot(index)
            end
        end)
    end

    arg11:SetCurrentSlot(1)

    if ControlsController_m.CurrentControls == "Gamepad" then
        GamepadService:EnableGamepadCursor(arg11.ChosenWeaponsFrame)
    end

    arg11:_UpdateMap()
    arg11:_UpdateFreeWeapons()
end

function t.Clear(arg12) -- line: 234
    for _, val_4 in pairs(arg12._chosen_weapon_slots) do
        val_4:Destroy()
    end

    for _, val_5 in pairs(arg12._pick_weapon_slots) do
        val_5:Destroy()
    end

    for _, val_6 in pairs(arg12._ban_frames) do
        val_6:Destroy()
    end

    arg12._current_slot = 1
    arg12._chosen_weapons = {}
    arg12._chosen_weapon_slots = {}
    arg12._pick_weapon_slots = {}
    arg12._ban_frames = {}
end

function t.Open(arg13, ...) -- line: 254
    -- upvalues:
    --  [1] Page_m (copy)

    Page_m.Open(arg13, ...)
    arg13:Start()
end

function t._InputPickWeapon(arg14, arg15) -- line: 263
    -- upvalues:
    --  [1] FighterController_m (copy)

    arg14:PickWeapon(arg14._current_slot, arg15)

    if arg14._current_slot == FighterController_m.LocalFighter:GetMaxEquippableWeapons() then
        arg14:Finish()

        return
    end

    arg14:SetCurrentSlot(arg14._current_slot + 1)
end

function t._UpdateFreeWeapons(arg16) -- line: 273
    -- upvalues:
    --  [1] FFlagController_m (copy)

    arg16.FreeWeaponsFrame.Visible = FFlagController_m:IsFreeWeaponsActive()
    local MapFrame = arg16.MapFrame
    MapFrame.Size = arg16.FreeWeaponsFrame.Visible and UDim2.new(1, 0, 1.5, 0) or UDim2.new(
        1,
        0,
        1,
        0
    )
    local MapTitle = arg16.MapTitle
    MapTitle.Size = arg16.FreeWeaponsFrame.Visible and UDim2.new(0.875, 0, 0.467, 0) or UDim2.new(
        0.875,
        0,
        0.7,
        0
    )
    arg16:_UpdateMap()
end

function t._UpdateMap(arg17) -- line: 280
    -- upvalues:
    --  [1] DuelController_m (copy)
    --  [2] Players (copy)
    --  [3] FighterController_m (copy)

    local v36 = DuelController_m:GetDuel(Players.LocalPlayer)
    local v37 = v36

    if v37 then
        v37 = v36.Map and v36.Map.Name
    end

    local v38 = FighterController_m.LocalFighter

    if v38 then
        v38 = FighterController_m.LocalFighter:Get("IsInShootingRange")
    end

    local MapFrame_1 = arg17.MapFrame
    MapFrame_1.Visible = if v37 then not arg17.FreeWeaponsFrame.Visible else v38 and not arg17.FreeWeaponsFrame.Visible
    local MapTitle_1 = arg17.MapTitle
    MapTitle_1.Text = v37 and "Map: " .. v37 or (if not v38 then "" else "Try out any weapon here for free!")
end

function t._Init(arg18) -- line: 290
    arg18.Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() -- line: 291
        -- upvalues:
        --  [1] arg18 (copy)

        arg18.List.CanvasSize = UDim2.new(0, 0, 0, arg18.Layout.AbsoluteContentSize.Y)
    end)
    arg18.List:GetPropertyChangedSignal("CanvasPosition"):Connect(function() -- line: 295
        -- upvalues:
        --  [1] arg18 (copy)

        local ListContainer = arg18.ListContainer
        ListContainer.ClipsDescendants = arg18.List.CanvasPosition.Y > 5
    end)
end

return t._new()
