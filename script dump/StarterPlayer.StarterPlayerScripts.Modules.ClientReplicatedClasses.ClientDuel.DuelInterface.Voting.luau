local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GamepadService = game:GetService("GamepadService")
local TweenService = game:GetService("TweenService")
local _ = game:GetService("Lighting")
local Players = game:GetService("Players")
local DuelLibrary_m = require(ReplicatedStorage.Modules.DuelLibrary)
local ItemLibrary_m = require(ReplicatedStorage.Modules.ItemLibrary)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local Signal_m = require(ReplicatedStorage.Modules.Signal)
local ControlsController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.ControlsController
)
local _ = require(Players.LocalPlayer.PlayerScripts.Modules.VoteBanFrame)
local ButtonEffect_m = require(Players.LocalPlayer.PlayerScripts.Modules.ButtonEffect)
local WeaponSlot_m = require(Players.LocalPlayer.PlayerScripts.Modules.WeaponSlot)
local MapSlot_m = require(Players.LocalPlayer.PlayerScripts.Modules.MapSlot)
local VoteWeaponTabButton = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild(
    "VoteWeaponTabButton"
)
local BanIcon = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("BanIcon")
local t = {}
t.__index = t

function t.new(arg1) -- line: 29
    -- upvalues:
    --  [1] t (copy)
    --  [2] Signal_m (copy)

    local t_1 = setmetatable({}, t)
    t_1.VisibilityChanged = Signal_m.new()
    t_1.DuelInterface = arg1
    t_1.Frame = t_1.DuelInterface.Frame:WaitForChild("Voting")
    t_1.MapsFrame = t_1.Frame:WaitForChild("Maps")
    t_1.MapsCenter = t_1.MapsFrame:WaitForChild("MapsCenter")
    t_1.MapsCenterLayout = t_1.MapsCenter:WaitForChild("Layout")
    t_1.MapsList = t_1.MapsFrame:WaitForChild("MapsList")
    t_1.MapsListContainer = t_1.MapsList:WaitForChild("Container")
    t_1.MapsListMaximizedFrame = t_1.MapsListContainer:WaitForChild("Maximized")
    t_1.MapsListMaximizedLayout = t_1.MapsListMaximizedFrame:WaitForChild("Layout")
    t_1.MapsListMinimizedFrame = t_1.MapsListContainer:WaitForChild("Minimized")
    t_1.MapsListMinimizedLayout = t_1.MapsListMinimizedFrame:WaitForChild("Layout")
    t_1.MapsListCentererFrame = t_1.MapsListContainer:WaitForChild("Centerer")
    t_1.MapsChosenEffectFrame = t_1.MapsFrame:WaitForChild("ChosenEffect")
    t_1.MapsArcadeModeFrame = t_1.MapsFrame:WaitForChild("ArcadeMode")
    t_1.MapsArcadeModeTitle = t_1.MapsArcadeModeFrame:WaitForChild("Container"):WaitForChild(
        "Title"
    )
    t_1.WeaponsFrame = t_1.Frame:WaitForChild("Weapons")
    t_1.WeaponsMapFrame = t_1.WeaponsFrame:WaitForChild("Map")
    t_1.WeaponsMapContainer = t_1.WeaponsMapFrame:WaitForChild("Container")
    t_1.WeaponsMapTitle = t_1.WeaponsMapContainer:WaitForChild("Title")
    t_1.WeaponsContainer = t_1.WeaponsFrame:WaitForChild("Container")
    t_1.WeaponsTabsFrame = t_1.WeaponsContainer:WaitForChild("Tabs")
    t_1.WeaponsList = t_1.WeaponsContainer:WaitForChild("List")
    t_1.WeaponsListContainer = t_1.WeaponsList:WaitForChild("Container")
    t_1.WeaponsListLayout = t_1.WeaponsListContainer:WaitForChild("Layout")
    t_1.RemainingBansFrame = t_1.Frame:WaitForChild("RemainingBans")
    t_1.RemainingBansContainer = t_1.RemainingBansFrame:WaitForChild("Container")
    t_1.RemainingBansStart = t_1.RemainingBansFrame:WaitForChild("Start")
    t_1.RemainingBansFinish = t_1.RemainingBansFrame:WaitForChild("Finish")
    t_1._destroyed = false
    t_1._generate_hash = 0
    t_1._last_vote_options_type = nil
    t_1._remaining_ban_icons_generated = false
    t_1._remaining_ban_icons_generate_hash = 0
    t_1._remaining_ban_icons = {}
    t_1._map_slots = {}
    t_1._map_chosen_slot = nil
    t_1._map_chosen_hash = 0
    t_1._weapon_class_selected = nil
    t_1._weapon_tab_buttons = {}
    t_1._weapon_slots = {}
    t_1._weapon_slots_banned = {}
    t_1._weapon_ban_icons = {}
    t_1._last_map_chosen_result = nil
    t_1._ban_sound_debounce = {}
    t_1:_Init()

    return t_1
end

function t.IsOpen(arg2) -- line: 89
    return not arg2._destroyed and arg2.Frame.Visible
end

function t.PlayMapChosenEffect(arg3, arg4) -- line: 93
    -- upvalues:
    --  [1] MapSlot_m (copy)

    local udim2_3 = UDim2.new(0, 0, 0, 0)
    local udim2_4 = UDim2.new(0.5, 0, 3, 0)

    for _, val in pairs(arg3._map_slots) do
        if val.Name == arg4.Name then
            local v4 = val.Frame.AbsolutePosition + val.Frame.AbsoluteSize * 0.5 - arg3.MapsChosenEffectFrame.AbsolutePosition
            udim2_4 = UDim2.new(0, v4.X, 0, v4.Y)
            udim2_3 = UDim2.new(0, val.Frame.AbsoluteSize.X, 0, val.Frame.AbsoluteSize.Y)
        end
    end

    arg3:_ClearMaps()
    arg3:_ClearMapChosenEffect()
    arg3._last_map_chosen_result = arg4
    arg3._map_chosen_hash += 1
    local MapChosenHash = arg3._map_chosen_hash
    arg3._map_chosen_slot = MapSlot_m.new(arg4.Name, true)
    arg3._map_chosen_slot.Frame.SizeConstraint = Enum.SizeConstraint.RelativeXY
    arg3._map_chosen_slot.Frame.Size = udim2_3
    arg3._map_chosen_slot.Frame.Position = udim2_4
    arg3._map_chosen_slot:SetParent(arg3.MapsChosenEffectFrame)
    arg3._map_chosen_slot.Frame:TweenSizeAndPosition(
        UDim2.new(1, 0, 1, 0),
        UDim2.new(0.5, 0, 0.5, 0),
        "Out",
        "Quint",
        0.75,
        true
    )
    arg3.WeaponsMapTitle.Text = "Map: " .. arg4.Name
    arg3.DuelInterface:CreateSound(
        "rbxassetid://103035811146294",
        1,
        1,
        script,
        true,
        5
    )
    wait(1.25)

    if MapChosenHash ~= arg3._map_chosen_hash then
        return
    end

    arg3._map_chosen_slot.Frame:TweenSize(
        UDim2.new(0, 0, 0, 0),
        "In",
        "Quint",
        0.75,
        true
    )
    wait(0.75)

    if MapChosenHash ~= arg3._map_chosen_hash then
        return
    end

    arg3._map_chosen_slot:Destroy()
    arg3._map_chosen_slot = nil
end

function t.Generate(arg5) -- line: 141
    -- upvalues:
    --  [1] GamepadService (copy)
    --  [2] ControlsController_m (copy)

    arg5._generate_hash += 1
    local v5 = arg5.DuelInterface.ClientDuel:Get("VoteOptions")

    if v5 then
        v5 = not arg5.DuelInterface:IsPageOpen()
    end

    arg5.Frame.Visible = v5
    arg5.VisibilityChanged:Fire()

    if not v5 then
        GamepadService:DisableGamepadCursor()
        arg5._remaining_ban_icons_generated = false
        arg5._remaining_ban_icons_generate_hash += 0
        arg5:_ClearMaps()
        arg5:_ClearWeapons()

        return
    end

    if
        not GamepadService.GamepadCursorEnabled
        and ControlsController_m.CurrentControls == "Gamepad"
    then
        GamepadService:EnableGamepadCursor(arg5.Frame)
    end

    task.spawn(function() -- line: 162
        -- upvalues:
        --  [1] arg5 (copy)

        local v6 = arg5.DuelInterface.ClientDuel:Get("VoteOptionsType")

        if arg5._last_vote_options_type ~= v6 then
            arg5._last_vote_options_type = v6
            arg5._remaining_ban_icons_generated = false
            local v7 = arg5
            v7._remaining_ban_icons_generate_hash += 0
        end

        if v6 == "Maps" then
            arg5:_ClearWeapons()
            arg5:_GenerateMaps()

            return
        end

        if v6 == "Weapons" then
            arg5:_ClearMaps()
            arg5:_GenerateWeapons()
        end
    end)
end

function t.Destroy(arg6) -- line: 181
    arg6._destroyed = true
    arg6.VisibilityChanged:Destroy()
    arg6:_ClearMaps()
    arg6:_ClearMapChosenEffect()
    arg6:_ClearWeapons()
end

function t._PlayBanSound(arg7, arg8, ...) -- line: 195
    if arg7._ban_sound_debounce[arg8] then
        return
    end

    arg7._ban_sound_debounce[arg8] = true
    task.defer(function(...) -- line: 202
        -- upvalues:
        --  [1] arg7 (copy)
        --  [2] arg8 (copy)

        arg7._ban_sound_debounce[arg8] = nil
        arg7.DuelInterface:CreateSound(arg8, ...)
    end, ...)
end

function t._ClearMapChosenEffect(arg9) -- line: 208
    arg9._map_chosen_hash += 1

    if arg9._map_chosen_slot then
        arg9._map_chosen_slot:Destroy()
        arg9._map_chosen_slot = nil
    end
end

function t._SetWeaponClassSelected(arg10, arg11) -- line: 217
    arg10._weapon_class_selected = arg11
    arg10:_UpdateWeapons()
end

function t._UpdateWeapons(arg12) -- line: 222
    -- upvalues:
    --  [1] ItemLibrary_m (copy)

    local v8, v9

    for key_1, _ in pairs(ItemLibrary_m.Classes) do
        v8 = if key_1 ~= arg12._weapon_class_selected then false else true
        v9 = arg12._weapon_tab_buttons[key_1]
        local Title = v9.Title
        local v10 = v8 and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(255, 255, 255)
        Title.TextColor3 = v10
        local Icon = v9.Title.Icon
        v10 = v8 and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(255, 255, 255)
        Icon.ImageColor3 = v10
        local Background = v9.Background
        v10 = v8 and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(0, 0, 0)
        Background.ImageColor3 = v10
        v10 = if not v8 then 0.25 else 0
        v9.Background.ImageTransparency = v10
        v9.Background.UIGradient.Enabled = not v8
    end

    for key_2, val_2 in pairs(arg12._weapon_slots) do
        v8 = val_2.Frame
        v9 = ItemLibrary_m.Items[key_2].Class == arg12._weapon_class_selected
        v8.Visible = v9
    end
end

function t._GenerateRemainingBans(arg13) -- line: 239
    -- upvalues:
    --  [1] Players (copy)
    --  [2] DuelLibrary_m (copy)
    --  [3] BanIcon (copy)
    --  [4] Utility_m (copy)
    --  [5] TweenService (copy)
    --  [6] ItemLibrary_m (copy)

    for _, val_3 in pairs(arg13._weapon_ban_icons) do
        val_3:Destroy()
    end

    arg13._weapon_ban_icons = {}
    local v11 = arg13.DuelInterface.ClientDuel:Get("VoteOptions")
    local v12 = arg13.DuelInterface.ClientDuel:Get("VoteOptionsType")
    local v14 = (if v12 == "Weapons" then arg13.DuelInterface.ClientDuel:Get("MaxWeaponBansPerTeam") else arg13.DuelInterface.ClientDuel:Get(
        "MaxMapBansPerTeam"
    )) or 0
    local v13 = arg13.DuelInterface.ClientDuel:Get("VoteBansRemaining") or {}
    local v15 = false

    if not arg13._remaining_ban_icons_generated then
        local v16 = pairs

        for _, val_4 in v16(arg13._remaining_ban_icons) do
            for _, val_5 in pairs(val_4) do
                val_5:Destroy()
            end
        end

        arg13._remaining_ban_icons = {}
        arg13._remaining_ban_icons_generated = true
        local RemainingBanIconsGenerateHash = arg13._remaining_ban_icons_generate_hash
        RemainingBanIconsGenerateHash += 1
        arg13._remaining_ban_icons_generate_hash = RemainingBanIconsGenerateHash
        local RemainingBanIconsGenerateHash_1 = arg13._remaining_ban_icons_generate_hash
        local t_3 = {}
        local v18 = arg13.DuelInterface.ClientDuel.Duelers

        for _, val_6 in pairs(v18) do
            local v19 = val_6:Get("TeamID")

            if v19 then
                t_3[v19] = true
            end
        end

        local v20 = arg13.DuelInterface.ClientDuel:GetDueler(Players.LocalPlayer)
        v18 = 1

        for key_7, _ in pairs(t_3) do
            if v20 and key_7 ~= v20:Get("TeamID") then
            end

            local v21 = DuelLibrary_m:GetTeamColor(key_7)

            for _ = 1, v14 - (v13[key_7] or 0) do
                local v22 = 1 - (v18 - 1) * 0.1
                local v23 = BanIcon:Clone()
                v23.ImageColor3 = Utility_m:DarkenColor(v21, v22 * 0.5)
                v23.Icon.ImageColor3 = Utility_m:DarkenColor(v21, v22)
                v23.LayoutOrder = v18
                v23.ZIndex = -v18
                local v25 = arg13._remaining_ban_icons[key_7]
                local RemainingBanIcons = arg13._remaining_ban_icons

                if not v25 then
                    v25 = {}
                end

                RemainingBanIcons[key_7] = v25
                table.insert(arg13._remaining_ban_icons[key_7], v23)
                task.delay((v18 - 1) * 0.25 + 0.125, function() -- line: 295
                    -- upvalues:
                    --  [1] RemainingBanIconsGenerateHash_1 (copy)
                    --  [2] arg13 (copy)
                    --  [3] v23 (copy)
                    --  [4] TweenService (ref)
                    --  [5] v18 (ref)

                    if RemainingBanIconsGenerateHash_1 ~= arg13._remaining_ban_icons_generate_hash then
                        return
                    end

                    v23.UIScale.Scale = 0.25
                    v23.Parent = arg13.RemainingBansContainer
                    TweenService:Create(
                        v23.UIScale,
                        TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
                        { Scale = 1 }
                    ):Play()
                    arg13.DuelInterface:CreateSound(
                        "rbxassetid://92837039207579",
                        1.25,
                        v18 * 0.075 + 0.75,
                        script,
                        true,
                        5
                    )
                end)
                v18 += 1
                v15 = true
            end
        end

        arg13.RemainingBansContainer.Position = arg13.RemainingBansStart.Position
        arg13.RemainingBansContainer:TweenPosition(
            arg13.RemainingBansContainer.Position,
            "Out",
            "Linear",
            0,
            true
        )
        arg13.RemainingBansContainer.Size = arg13.RemainingBansStart.Size
        arg13.RemainingBansContainer:TweenSize(
            arg13.RemainingBansContainer.Size,
            "Out",
            "Linear",
            0,
            true
        )
        task.spawn(function() -- line: 317
            -- upvalues:
            --  [1] arg13 (copy)
            --  [2] Players (ref)

            local RemainingBanIconsGenerateHash_2 = arg13._remaining_ban_icons_generate_hash
            wait(1)

            if arg13._remaining_ban_icons_generate_hash ~= RemainingBanIconsGenerateHash_2 then
                return
            end

            if arg13.RemainingBansContainer:IsDescendantOf(Players) then
                arg13.RemainingBansContainer:TweenPosition(
                    arg13.RemainingBansFinish.Position,
                    "InOut",
                    "Quint",
                    0.5,
                    true
                )
                arg13.RemainingBansContainer:TweenSize(
                    arg13.RemainingBansFinish.Size,
                    "InOut",
                    "Quint",
                    0.5,
                    true
                )

                return
            end

            arg13.RemainingBansContainer.Position = arg13.RemainingBansFinish.Position
            arg13.RemainingBansContainer.Size = arg13.RemainingBansFinish.Size
        end)
        arg13:_SetWeaponClassSelected("Primary")
    end

    for key_8, val_8 in pairs(arg13._remaining_ban_icons) do
        local v28 = v14 - (v13[key_8] or 0)

        for key_9, val_9 in pairs(val_8) do
            local v29 = v28 >= key_9
            val_9.Visible = v29
        end
    end

    if v12 == "Weapons" then
        v13 = {}

        for _, val_10 in pairs(v11) do
            local IsBanned = val_10.IsBanned

            if IsBanned then
                local v30 = DuelLibrary_m:GetTeamColor(IsBanned)
                local v31 = ItemLibrary_m.Items[val_10.Name]
                v13[v31.Class] = (v13[v31.Class] or 0) + 1
                local v32 = v13[v31.Class]
                local v33 = BanIcon:Clone()
                v33.ImageColor3 = Utility_m:DarkenColor(v30, 0.5)
                v33.Icon.ImageColor3 = Utility_m:DarkenColor(v30, 1)
                v33.LayoutOrder = v32
                v33.ZIndex = -v32
                v33.Parent = arg13._weapon_tab_buttons[v31.Class].Bans
                table.insert(arg13._weapon_ban_icons, v33)
                local v34 = ItemLibrary_m.ViewModels[val_10.Name].ImageCentered
                local Icon_3 = v33.Weapon.Icon

                if not v34 then
                    v34 = v31.Image
                end

                Icon_3.Image = v34
                v33.Weapon.ZIndex = 10
                v33.Weapon.Visible = true
            end
        end
    end

    if v15 then
        wait(1.25)
    end
end

function t._ClearWeapons(arg14) -- line: 384
    for _, val_11 in pairs(arg14._weapon_slots) do
        val_11:Destroy()
    end

    arg14._weapon_slots = {}
    arg14._weapon_slots_banned = {}
    arg14.WeaponsFrame.Visible = false
end

function t._GenerateWeapons(arg15) -- line: 395
    -- upvalues:
    --  [1] Players (copy)
    --  [2] WeaponSlot_m (copy)
    --  [3] ReplicatedStorage (copy)
    --  [4] TweenService (copy)

    arg15.WeaponsFrame.Visible = true
    local GenerateHash = arg15._generate_hash
    arg15:_GenerateRemainingBans()

    if GenerateHash ~= arg15._generate_hash then
        return
    end

    local v35 = arg15.DuelInterface.ClientDuel:Get("VoteOptions")
    local v36 = arg15.DuelInterface.ClientDuel:GetDueler(Players.LocalPlayer)

    for key_12, val_12 in pairs(v35) do
        local Name = val_12.Name

        if not arg15._weapon_slots[Name] then
            local v37 = WeaponSlot_m.new(Name)
            v37.Frame.LayoutOrder = key_12
            v37.Frame.Parent = arg15.WeaponsListContainer

            if v36 then
                v37.Frame.Button.MouseButton1Click:Connect(function() -- line: 424
                    -- upvalues:
                    --  [1] ReplicatedStorage (ref)
                    --  [2] Name (copy)

                    ReplicatedStorage.Remotes.Duels.Vote:FireServer(Name)
                end)
            else
                v37:DisableButton()
            end

            v37.PlayBanFrameSound:Connect(function(...) -- line: 431
                -- upvalues:
                --  [1] arg15 (copy)

                arg15:_PlayBanSound(...)
            end)
            arg15._weapon_slots[Name] = v37
            local UIScale_1 = Instance.new("UIScale")
            UIScale_1.Scale = 0.25
            UIScale_1.Parent = v37.Frame
            TweenService:Create(
                UIScale_1,
                TweenInfo.new(
                    math.sqrt(key_12) * 0.1 + 0.1,
                    Enum.EasingStyle.Quint,
                    Enum.EasingDirection.Out
                ),
                { Scale = 1 }
            ):Play()
        end
    end

    for _, val_13 in pairs(v35) do
        local Name_1 = val_13.Name
        local v40 = arg15._weapon_slots[Name_1]

        if v40 and val_13.IsBanned and not arg15._weapon_slots_banned[Name_1] then
            arg15._weapon_slots_banned[Name_1] = true
            v40:ToggleBanned(0, val_13.IsBanned)
        end
    end

    arg15:_UpdateWeapons()
end

function t._ClearMaps(arg16) -- line: 461
    for _, val_14 in pairs(arg16._map_slots) do
        val_14:Destroy()
    end

    arg16._map_slots = {}
    arg16.MapsCenter.Visible = false
    arg16.MapsList.Visible = false
end

function t._GenerateMaps(arg17) -- line: 472
    -- upvalues:
    --  [1] Players (copy)
    --  [2] MapSlot_m (copy)
    --  [3] ReplicatedStorage (copy)
    --  [4] TweenService (copy)

    if arg17._map_chosen_slot then
        return
    end

    local v41 = arg17.DuelInterface.ClientDuel:Get("VoteSelectionMode")
    local v42 = arg17.DuelInterface.ClientDuel:Get("VoteOptions")
    local v43 = #v42 <= 6 and true
    arg17.MapsList.Visible = not v43
    arg17.MapsCenter.Visible = v43
    arg17.MapsCenterLayout.FillDirectionMaxCells = if #v42 == 4 then 2 else 0
    local GenerateHash_1 = arg17._generate_hash
    arg17:_GenerateRemainingBans()

    if GenerateHash_1 ~= arg17._generate_hash then
        return
    end

    local t_4 = {}

    if not v43 and #v42 > 3 then
        local rng = Random.new(arg17.DuelInterface.ClientDuel:Get("DuelSeed"))
        local t_5 = {}

        for _, val_15 in pairs(v42) do
            if val_15.Name ~= "Random" then
                table.insert(t_5, val_15)
            end
        end

        for _ = 1, 3 do
            t_4[table.remove(t_5, rng:NextInteger(1, #t_5))] = true
        end
    end

    local v47 = arg17.DuelInterface.ClientDuel:GetDueler(Players.LocalPlayer)
    local v48 = 0
    local v49

    for key_16, val_16 in pairs(v42) do
        v48 += val_16.Votes

        if not arg17._map_slots[val_16.Name] then
            v49 = if not v43 then if not t_4[val_16] then arg17.MapsListMinimizedFrame else arg17.MapsListMaximizedFrame else arg17.MapsCenter
            local v50 = MapSlot_m.new(val_16.Name, not v47)
            local v51
            v50.Frame.LayoutOrder, v51 = key_16, v49
            v50:SetParent(v51)
            arg17._map_slots[val_16.Name] = v50
            v50.CreateSound:Connect(function(...) -- line: 530
                -- upvalues:
                --  [1] arg17 (copy)

                arg17:_PlayBanSound(...)
            end)

            if v47 then
                v50.Frame.Button.MouseButton1Click:Connect(function() -- line: 535
                    -- upvalues:
                    --  [1] ReplicatedStorage (ref)
                    --  [2] val_16 (copy)

                    ReplicatedStorage.Remotes.Duels.Vote:FireServer(val_16.Name)
                end)
            end

            if v49 ~= arg17.MapsListMaximizedFrame then
                local UIScale_2 = Instance.new("UIScale")
                UIScale_2.Scale = 0.25
                UIScale_2.Parent = v50.Frame
                TweenService:Create(
                    UIScale_2,
                    TweenInfo.new(
                        math.sqrt(key_16) * 0.1 + 0.1,
                        Enum.EasingStyle.Quint,
                        Enum.EasingDirection.Out
                    ),
                    { Scale = 1 }
                ):Play()
            end
        end
    end

    v47 = nil
    local t_6 = {}
    v43 = {}

    for _, val_17 in pairs(arg17.DuelInterface.ClientDuel.Duelers) do
        v49 = val_17:Get("LastVote")

        if v49 then
            local v54 = t_6[v49] or {}
            t_6[v49] = v54
            table.insert(t_6[v49], val_17.Player.UserId)
        end

        if val_17.Player == Players.LocalPlayer then
            v47 = v49
        end

        v43[tostring(val_17.Player.UserId)] = val_17:Get("TeamID")
    end

    for _, val_18 in pairs(v42) do
        local v55 = arg17._map_slots[val_18.Name]

        if v55 then
            if val_18.IsBanned then
                v55.VoteBanFrame:Play(val_18.IsBanned, true)
            else
                local Votes = val_18.Votes
                v55:UpdateVotes(
                    Votes,
                    v48,
                    t_6[val_18.Name],
                    v43,
                    val_18.Name == v47,
                    v41
                )
            end
        end
    end
end

function t._UpdateLists(arg18) -- line: 583
    arg18.MapsList.CanvasSize = UDim2.new(
        0,
        0,
        0,
        arg18.MapsListMinimizedFrame.AbsolutePosition.Y + arg18.MapsListMinimizedLayout.AbsoluteContentSize.Y - arg18.MapsListContainer.AbsolutePosition.Y + 10
    )
    local MapsList_1 = arg18.MapsList
    local v59 = arg18.MapsList.CanvasPosition.Y > 5
    MapsList_1.ClipsDescendants = v59
    arg18.WeaponsList.CanvasSize = UDim2.new(0, 0, 0, arg18.WeaponsListLayout.AbsoluteContentSize.Y)
    local WeaponsList_1 = arg18.WeaponsList
    v59 = arg18.WeaponsList.CanvasPosition.Y > 5
    WeaponsList_1.ClipsDescendants = v59
    arg18.WeaponsTabsFrame.Visible = arg18.WeaponsListLayout.AbsoluteContentSize.Y > 0 and true
    v59 = arg18._last_map_chosen_result
    local WeaponsMapFrame = arg18.WeaponsMapFrame
    v59 = v59 and arg18.WeaponsTabsFrame.Visible
    WeaponsMapFrame.Visible = v59
    local MapsListMaximizedFrame = arg18.MapsListMaximizedFrame
    v59 = arg18.MapsListMaximizedLayout.AbsoluteContentSize.Y > 0
    MapsListMaximizedFrame.Visible = v59
    local MapsListMinimizedFrame = arg18.MapsListMinimizedFrame
    v59 = arg18.MapsListMinimizedLayout.AbsoluteContentSize.Y > 0
    MapsListMinimizedFrame.Visible = v59
    arg18.MapsListCentererFrame.Size = UDim2.new(
        0,
        0,
        0,
        math.max(0, arg18.MapsList.AbsoluteWindowSize.Y - arg18.MapsList.CanvasSize.Y.Offset) / 2
    )
end

function t._Setup(arg19) -- line: 595
    -- upvalues:
    --  [1] ItemLibrary_m (copy)
    --  [2] VoteWeaponTabButton (copy)
    --  [3] ButtonEffect_m (copy)
    --  [4] DuelLibrary_m (copy)

    for key_19, val_19 in pairs(ItemLibrary_m.Classes) do
        local Icon_4 = VoteWeaponTabButton:Clone()
        Icon_4.Title.Text = key_19
        Icon_4.Title.Icon.Image = val_19.ImageDiagonalLeft
        Icon_4.LayoutOrder = val_19.Slot
        Icon_4.Parent = arg19.WeaponsTabsFrame
        arg19._weapon_tab_buttons[key_19] = Icon_4
        Icon_4.MouseButton1Click:Connect(function() -- line: 604
            -- upvalues:
            --  [1] arg19 (copy)
            --  [2] key_19 (copy)

            arg19:_SetWeaponClassSelected(key_19)
        end)
        ButtonEffect_m:Add(Icon_4)
        local Title_1 = Icon_4.Title
        local Icon_4 = Title_1.Icon
        Title_1:GetPropertyChangedSignal("TextBounds"):Connect(function() --[[ update ]] -- line: 613
            -- upvalues:
            --  [1] Icon_4 (copy)
            --  [2] Title_1 (copy)

            Icon_4.Position = UDim2.new(0.5, -Title_1.TextBounds.X / 2, 0.5, 0)
        end)
        Icon_4.Position = UDim2.new(0.5, -Title_1.TextBounds.X / 2, 0.5, 0)
    end

    local v63 = arg19.DuelInterface.ClientDuel:Get("ArcadeMode")
    local MapsArcadeModeTitle = arg19.MapsArcadeModeTitle
    MapsArcadeModeTitle.Text = v63 and "Gamemode: " .. DuelLibrary_m.ArcadeModes[v63].DisplayName or ""
    arg19.MapsArcadeModeFrame.Visible = v63
end

function t._Init(arg20) -- line: 627
    arg20.MapsList:GetPropertyChangedSignal("CanvasPosition"):Connect(function() -- line: 628
        -- upvalues:
        --  [1] arg20 (copy)

        arg20:_UpdateLists()
    end)
    arg20.MapsList:GetPropertyChangedSignal("AbsoluteWindowSize"):Connect(function() -- line: 632
        -- upvalues:
        --  [1] arg20 (copy)

        arg20:_UpdateLists()
    end)
    arg20.MapsList:GetPropertyChangedSignal("CanvasSize"):Connect(function() -- line: 636
        -- upvalues:
        --  [1] arg20 (copy)

        arg20:_UpdateLists()
    end)
    arg20.WeaponsListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() -- line: 640
        -- upvalues:
        --  [1] arg20 (copy)

        arg20:_UpdateLists()
    end)
    arg20.WeaponsList:GetPropertyChangedSignal("CanvasPosition"):Connect(function() -- line: 644
        -- upvalues:
        --  [1] arg20 (copy)

        arg20:_UpdateLists()
    end)
    arg20.MapsListMaximizedLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() -- line: 648
        -- upvalues:
        --  [1] arg20 (copy)

        arg20:_UpdateLists()
    end)
    arg20.MapsListMinimizedLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() -- line: 652
        -- upvalues:
        --  [1] arg20 (copy)

        arg20:_UpdateLists()
    end)
    arg20.MapsListContainer:GetPropertyChangedSignal("AbsolutePosition"):Connect(function() -- line: 656
        -- upvalues:
        --  [1] arg20 (copy)

        arg20:_UpdateLists()
    end)
    arg20.MapsListMinimizedFrame:GetPropertyChangedSignal("AbsolutePosition"):Connect(function() -- line: 660
        -- upvalues:
        --  [1] arg20 (copy)

        task.defer(arg20._UpdateLists, arg20)
    end)
    arg20:_Setup()
    arg20:_UpdateLists()
end

return t
