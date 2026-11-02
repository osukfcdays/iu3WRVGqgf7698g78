local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local Signal_m = require(ReplicatedStorage.Modules.Signal)
local PlayerDataController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.PlayerDataController
)
local ControlsController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.ControlsController
)
local CameraController_m = require(Players.LocalPlayer.PlayerScripts.Controllers.CameraController)
local EmoteController_m = require(Players.LocalPlayer.PlayerScripts.Controllers.EmoteController)
local OutOfBoundsParts_m = require(
    Players.LocalPlayer.PlayerScripts.Modules.GameComponents.OutOfBoundsParts
)
local EliminatedEffect_m = require(
    Players.LocalPlayer.PlayerScripts.Modules.UserInterface.EliminatedEffect
)
local Pages_m = require(Players.LocalPlayer.PlayerScripts.Modules.UserInterface.Pages)
local UILibrary_m = require(Players.LocalPlayer.PlayerScripts.Modules.UILibrary)
local AudioVisualizers_m = require(script:WaitForChild("AudioVisualizers"))
local DamageIndicators_m = require(script:WaitForChild("DamageIndicators"))
local EliminationSlots_m = require(script:WaitForChild("EliminationSlots"))
local EquippedDisplays_m = require(script:WaitForChild("EquippedDisplays"))
local WarningEffect_m = require(script:WaitForChild("WarningEffect"))
local BottomCenter_m = require(script:WaitForChild("BottomCenter"))
local SmokeScreen_m = require(script:WaitForChild("SmokeScreen"))
local BottomRight_m = require(script:WaitForChild("BottomRight"))
local BottomLeft_m = require(script:WaitForChild("BottomLeft"))
local SpeedLines_m = require(script:WaitForChild("SpeedLines"))
local Spectators_m = require(script:WaitForChild("Spectators"))
local Keybinds_m = require(script:WaitForChild("Keybinds"))
local Flashed_m = require(script:WaitForChild("Flashed"))
local Frozen_m = require(script:WaitForChild("Frozen"))
local Splats_m = require(script:WaitForChild("Splats"))
local Health_m = require(script:WaitForChild("Health"))
local Hotbar_m = require(script:WaitForChild("Hotbar"))
local Other_m = require(script:WaitForChild("Other"))
local ESP_m = require(script:WaitForChild("ESP"))
local FighterInterface = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild(
    "FighterInterface"
)
local t = {}
t.__index = t

function t.new(arg1) -- line: 40
    -- upvalues:
    --  [1] t (copy)
    --  [2] Signal_m (copy)
    --  [3] FighterInterface (copy)
    --  [4] AudioVisualizers_m (copy)
    --  [5] DamageIndicators_m (copy)
    --  [6] EliminationSlots_m (copy)
    --  [7] EquippedDisplays_m (copy)
    --  [8] WarningEffect_m (copy)
    --  [9] BottomCenter_m (copy)
    --  [10] BottomRight_m (copy)
    --  [11] SmokeScreen_m (copy)
    --  [12] BottomLeft_m (copy)
    --  [13] Spectators_m (copy)
    --  [14] SpeedLines_m (copy)
    --  [15] Flashed_m (copy)
    --  [16] Frozen_m (copy)
    --  [17] Splats_m (copy)
    --  [18] Health_m (copy)
    --  [19] Hotbar_m (copy)
    --  [20] Keybinds_m (copy)
    --  [21] Other_m (copy)
    --  [22] ESP_m (copy)

    local t_1 = setmetatable({}, t)
    t_1.ActiveChanged = Signal_m.new()
    t_1.HotbarClicked = Signal_m.new()
    t_1.ClientFighter = arg1
    t_1.Frame = FighterInterface:Clone()
    t_1.AudioVisualizers = AudioVisualizers_m.new(t_1)
    t_1.DamageIndicators = DamageIndicators_m.new(t_1)
    t_1.EliminationSlots = EliminationSlots_m.new(t_1)
    t_1.EquippedDisplays = EquippedDisplays_m.new(t_1)
    t_1.WarningEffect = WarningEffect_m.new(t_1)
    t_1.BottomCenter = BottomCenter_m.new(t_1)
    t_1.BottomRight = BottomRight_m.new(t_1)
    t_1.SmokeScreen = SmokeScreen_m.new(t_1)
    t_1.BottomLeft = BottomLeft_m.new(t_1)
    t_1.Spectators = Spectators_m.new(t_1)
    t_1.SpeedLines = SpeedLines_m.new(t_1)
    t_1.Flashed = Flashed_m.new(t_1)
    t_1.Frozen = Frozen_m.new(t_1)
    t_1.Splats = Splats_m.new(t_1)
    t_1.Health = Health_m.new(t_1)
    t_1.Hotbar = Hotbar_m.new(t_1)
    t_1.Keybinds = Keybinds_m.new(t_1)
    t_1.Other = Other_m.new(t_1)
    t_1.ESP = ESP_m.new(t_1)
    t_1._destroyed = false
    t_1._connections = {}
    t_1._original_sizings = {}
    t_1:_Init()

    return t_1
end

function t.RefillAmmoEffect(arg2, ...) -- line: 81
    return arg2.Other:RefillAmmoEffect(...)
end

function t.HealEffect(arg3, ...) -- line: 85
    return arg3.Health:HealEffect(...)
end

function t.HurtEffect(arg4, ...) -- line: 89
    return arg4.Health:HurtEffect(...)
end

function t.DamageIndicator(arg5, ...) -- line: 93
    return arg5.DamageIndicators:Create(...)
end

function t.ClearDamageIndicators(arg6, ...) -- line: 97
    return arg6.DamageIndicators:Clear(...)
end

function t.SplatEffect(arg7, ...) -- line: 101
    return arg7.Splats:Create(...)
end

function t.EliminationEffect(arg8, ...) -- line: 105
    return arg8.EliminationSlots:Create(...)
end

function t.HotbarRollEffect(arg9, ...) -- line: 109
    return arg9.Hotbar:RollEffect(...)
end

function t.IsActive(arg10) -- line: 113
    return arg10.Frame.Visible
end

function t.CreateSound(arg11, ...) -- line: 117
    -- upvalues:
    --  [1] Utility_m (copy)

    if not arg11:IsActive() then
        return
    end

    return Utility_m:CreateSound(...)
end

function t.Update(arg12, arg13, arg14) -- line: 125
    if not arg14.IsSpectating then
        arg12.SmokeScreen:Hide()
        arg12:_SetFrameVisible(false)

        return
    end

    arg12.AudioVisualizers:Update(arg13, arg14)
    arg12.DamageIndicators:Update(arg13, arg14)
    arg12.EquippedDisplays:Update(arg13, arg14)
    arg12.SmokeScreen:Update(arg13, arg14)
    arg12.SpeedLines:Update(arg13, arg14)
    arg12.Hotbar:Update(arg13, arg14)
    arg12.ESP:Update(arg13, arg14)
    arg12:_SetFrameVisible(true)
end

function t.Destroy(arg15) -- line: 142
    arg15._destroyed = true

    for _, val in pairs(arg15._connections) do
        val:Disconnect()
    end

    arg15._connections = {}
    arg15.ActiveChanged:Destroy()
    arg15.HotbarClicked:Destroy()
    arg15.AudioVisualizers:Destroy()
    arg15.DamageIndicators:Destroy()
    arg15.EliminationSlots:Destroy()
    arg15.EquippedDisplays:Destroy()
    arg15.WarningEffect:Destroy()
    arg15.BottomCenter:Destroy()
    arg15.SmokeScreen:Destroy()
    arg15.BottomRight:Destroy()
    arg15.BottomLeft:Destroy()
    arg15.SpeedLines:Destroy()
    arg15.Spectators:Destroy()
    arg15.Keybinds:Destroy()
    arg15.Flashed:Destroy()
    arg15.Frozen:Destroy()
    arg15.Splats:Destroy()
    arg15.Health:Destroy()
    arg15.Hotbar:Destroy()
    arg15.Other:Destroy()
    arg15.ESP:Destroy()
    arg15.Frame:Destroy()
end

function t._UpdateSizing(arg16) -- line: 181
    -- upvalues:
    --  [1] UILibrary_m (copy)

    local v20 = UILibrary_m.MainGui.AbsoluteSize.X / arg16.Frame.AbsoluteSize.X
    local v21 = UILibrary_m.MainGui.AbsoluteSize.Y / arg16.Frame.AbsoluteSize.Y

    for _, val_1 in pairs(
        {
            "ESP",
            "DamageVignette",
            "FrozenVignette",
            "HealVignette",
            "WarningVignette",
            "SpeedLinesThick",
            "SpeedLinesThin",
            "RefillAmmoVignette"
        }
    ) do
        local v22 = arg16.Frame[val_1]
        local v23 = arg16._original_sizings[v22]
        local OriginalSizings = arg16._original_sizings

        if not v23 then
            v23 = { Position = v22.Position, Size = v22.Size }
        end

        OriginalSizings[v22] = v23
        local udim2 = UDim2.new(
            arg16._original_sizings[v22].Size.X.Scale * v20,
            arg16._original_sizings[v22].Size.X.Offset * v20,
            arg16._original_sizings[v22].Size.Y.Scale * v21,
            arg16._original_sizings[v22].Size.Y.Offset * v21
        )
        v22.Size = udim2
        local udim2_1 = UDim2.new(
            0.5 + (arg16._original_sizings[v22].Position.X.Scale - 0.5) * v20,
            0,
            0.5 + (arg16._original_sizings[v22].Position.Y.Scale - 0.5) * v21,
            0
        )
        v22.Position = udim2_1
    end
end

function t._UpdateVisibility(arg17) -- line: 209
    -- upvalues:
    --  [1] Pages_m (copy)
    --  [2] EliminatedEffect_m (copy)

    local v24 = not Pages_m.PageSystem.CurrentPage
    local v25 = EliminatedEffect_m:IsVisible()
    local v26 = v24
    local EliminationSlots = arg17.EliminationSlots

    if v26 then
        v26 = not v25
    end

    EliminationSlots:SetVisible(v26)
    v26 = v24
    local BottomCenter = arg17.BottomCenter

    if v26 then
        v26 = if #arg17.ClientFighter.Items > 0 then not v25 else false
    end

    BottomCenter:SetVisible(v26)
    v26 = v24
    local BottomRight = arg17.BottomRight

    if v26 then
        v26 = if #arg17.ClientFighter.Items > 0 then not v25 else false
    end

    BottomRight:SetVisible(v26)
    v26 = v24
    local BottomLeft = arg17.BottomLeft

    if v26 then
        v26 = #arg17.ClientFighter.Items > 0
    end

    BottomLeft:SetVisible(v26)
end

function t._SetFrameVisible(arg18, arg19) -- line: 219
    if arg18.Frame.Visible == arg19 then
        return
    end

    arg18.Frame.Visible = arg19
    arg18.ActiveChanged:Fire()
end

function t._EntityRemoved(arg20) -- line: 228
    arg20.Frozen:Refresh()
end

function t._EntityAdded(arg21) -- line: 232
    arg21.EliminationSlots:Clear()
    arg21.DamageIndicators:Clear()
    arg21.SmokeScreen:Clear()

    if not arg21.ClientFighter.Entity then
        arg21.Health:Refresh()
        arg21.Frozen:Refresh()

        return
    end

    table.insert(arg21._connections, arg21.ClientFighter.Entity.HealthChanged:Connect(function() -- line: 243
        -- upvalues:
        --  [1] arg21 (copy)

        arg21.Health:Refresh()
    end))
    table.insert(arg21._connections, arg21.ClientFighter.Entity:GetDataChangedSignal("IsFrozen"):Connect(
        function() -- line: 247
            -- upvalues:
            --  [1] arg21 (copy)

            arg21.Frozen:Refresh()
        end
    ))
    table.insert(arg21._connections, arg21.ClientFighter.Entity.Died:Connect(function() -- line: 251
        -- upvalues:
        --  [1] arg21 (copy)

        arg21.Frozen:Refresh()
        arg21.Keybinds:Refresh()
    end))
    arg21.Health:Refresh()
    arg21.Frozen:Refresh()
    arg21.Keybinds:Refresh()
end

function t._Setup(arg22) -- line: 261
    -- upvalues:
    --  [1] UILibrary_m (copy)

    arg22:_SetFrameVisible(false)
    arg22.Frame.Name = arg22.ClientFighter.Player.Name
    arg22.Frame.Parent = UILibrary_m:GetTo("MainFrame", "FighterInterfaces")
end

function t._Init(arg23) -- line: 267
    -- upvalues:
    --  [1] CameraController_m (copy)
    --  [2] ControlsController_m (copy)
    --  [3] EmoteController_m (copy)
    --  [4] Pages_m (copy)
    --  [5] EliminatedEffect_m (copy)
    --  [6] PlayerDataController_m (copy)
    --  [7] OutOfBoundsParts_m (copy)

    arg23.Frame:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- line: 268
        -- upvalues:
        --  [1] arg23 (copy)

        arg23:_UpdateSizing()
    end)
    arg23.Hotbar.Clicked:Connect(function(...) -- line: 272
        -- upvalues:
        --  [1] arg23 (copy)

        arg23.HotbarClicked:Fire(...)
    end)
    table.insert(arg23._connections, arg23.ClientFighter.EntityAdded:Connect(function() -- line: 276
        -- upvalues:
        --  [1] arg23 (copy)

        arg23:_EntityAdded()
    end))
    table.insert(arg23._connections, arg23.ClientFighter.EntityRemoved:Connect(function() -- line: 280
        -- upvalues:
        --  [1] arg23 (copy)

        arg23:_EntityRemoved()
    end))
    table.insert(arg23._connections, arg23.ClientFighter.EquippedItemChanged:Connect(function() -- line: 284
        -- upvalues:
        --  [1] arg23 (copy)

        arg23.Keybinds:Refresh()
        arg23.Hotbar:UpdateVisuals()
        arg23.Hotbar:EquipEffect(arg23.ClientFighter.EquippedItem)
        arg23.EquippedDisplays:UpdateVisibility()
        arg23.EquippedDisplays:UpdateVisuals()
    end))
    table.insert(arg23._connections, arg23.ClientFighter.ItemAdded:Connect(function(
        instance: Instance
    ) -- line: 292
        -- upvalues:
        --  [1] arg23 (copy)

        arg23.Keybinds:Refresh()
        arg23.Hotbar:ItemAdded(instance)
        arg23.EquippedDisplays:ItemAdded(instance)
        arg23:_UpdateVisibility()
    end))
    table.insert(arg23._connections, arg23.ClientFighter.ItemRemoved:Connect(function(
        instance_1: Instance
    ) -- line: 299
        -- upvalues:
        --  [1] arg23 (copy)

        arg23.Keybinds:Refresh()
        arg23.Hotbar:ItemRemoved(instance_1)
        arg23.EquippedDisplays:ItemRemoved(instance_1)
        arg23:_UpdateVisibility()
    end))
    local Connections_8 = arg23._connections
    local NumSpectators = arg23.ClientFighter:GetDataChangedSignal("NumSpectators")
    table.insert(Connections_8, NumSpectators:Connect(function() -- line: 306
        -- upvalues:
        --  [1] arg23 (copy)

        arg23.Spectators:Refresh()
    end))
    local Connections_9 = arg23._connections
    local IsInDuel = arg23.ClientFighter:GetDataChangedSignal("IsInDuel")
    table.insert(Connections_9, IsInDuel:Connect(function() -- line: 310
        -- upvalues:
        --  [1] arg23 (copy)

        arg23.Keybinds:Refresh()
    end))
    local Connections_10 = arg23._connections
    local QuickAttackOverrides = arg23.ClientFighter:GetDataChangedSignal("QuickAttackOverrides")
    table.insert(Connections_10, QuickAttackOverrides:Connect(function() -- line: 314
        -- upvalues:
        --  [1] arg23 (copy)

        arg23.Keybinds:Refresh()
    end))
    local Connections_11 = arg23._connections
    local CheaterMode = arg23.ClientFighter:GetDataChangedSignal("CheaterMode")
    table.insert(Connections_11, CheaterMode:Connect(function() -- line: 318
        -- upvalues:
        --  [1] arg23 (copy)

        arg23.ESP:Refresh()
    end))
    local Connections_12 = arg23._connections
    local IsAprilFools = arg23.ClientFighter:GetDataChangedSignal("IsAprilFools")
    table.insert(Connections_12, IsAprilFools:Connect(function() -- line: 322
        -- upvalues:
        --  [1] arg23 (copy)

        arg23.Health:Refresh()
    end))
    local Connections_13 = arg23._connections
    local InfiniteAmmo = arg23.ClientFighter:GetDataChangedSignal("InfiniteAmmo")
    table.insert(Connections_13, InfiniteAmmo:Connect(function() -- line: 326
        -- upvalues:
        --  [1] arg23 (copy)

        arg23.Hotbar:UpdateAmmo()
        arg23.EquippedDisplays:UpdateAmmo()
    end))
    local Connections_14 = arg23._connections
    local InfiniteAmmoReserve = arg23.ClientFighter:GetDataChangedSignal("InfiniteAmmoReserve")
    table.insert(Connections_14, InfiniteAmmoReserve:Connect(function() -- line: 331
        -- upvalues:
        --  [1] arg23 (copy)

        arg23.Hotbar:UpdateAmmo()
        arg23.EquippedDisplays:UpdateAmmo()
    end))
    local Connections_15 = arg23._connections
    local EquippedItemID = arg23.ClientFighter:GetDataChangedSignal("EquippedItemID")
    table.insert(Connections_15, EquippedItemID:Connect(function() -- line: 336
        -- upvalues:
        --  [1] arg23 (copy)

        arg23.Hotbar:UpdateLayouts()
    end))
    local Connections_16 = arg23._connections
    local IsInShootingRange = arg23.ClientFighter:GetDataChangedSignal("IsInShootingRange")
    table.insert(Connections_16, IsInShootingRange:Connect(function() -- line: 340
        -- upvalues:
        --  [1] arg23 (copy)

        arg23.Keybinds:Refresh()
    end))
    table.insert(arg23._connections, CameraController_m.StateChanged:Connect(function() -- line: 344
        -- upvalues:
        --  [1] arg23 (copy)

        arg23.Keybinds:Refresh()
    end))
    table.insert(arg23._connections, ControlsController_m.ControlsChanged:Connect(function() -- line: 348
        -- upvalues:
        --  [1] arg23 (copy)

        arg23.Keybinds:Refresh()
        arg23.Spectators:Refresh()
        arg23.Hotbar:UpdateVisibility()
    end))
    table.insert(arg23._connections, EmoteController_m.CanEmoteChanged:Connect(function() -- line: 354
        -- upvalues:
        --  [1] arg23 (copy)

        arg23.Keybinds:Refresh()
    end))
    table.insert(arg23._connections, Pages_m.PageSystem.PageOpened:Connect(function() -- line: 358
        -- upvalues:
        --  [1] arg23 (copy)

        arg23:_UpdateVisibility()
    end))
    table.insert(arg23._connections, Pages_m.PageSystem.PageClosed:Connect(function() -- line: 362
        -- upvalues:
        --  [1] arg23 (copy)

        arg23:_UpdateVisibility()
    end))
    table.insert(arg23._connections, EliminatedEffect_m.VisibilityChanged:Connect(function() -- line: 366
        -- upvalues:
        --  [1] arg23 (copy)

        arg23:_UpdateVisibility()
    end))
    local Connections_23 = arg23._connections
    local v27 = PlayerDataController_m:GetSettingChangedSignal("Spectators Display")
    table.insert(Connections_23, v27:Connect(function() -- line: 370
        -- upvalues:
        --  [1] arg23 (copy)

        arg23.Spectators:UpdateParent()
    end))
    local Connections_24 = arg23._connections
    local v28 = PlayerDataController_m:GetSettingChangedSignal("Padded HUD")
    table.insert(Connections_24, v28:Connect(function() -- line: 374
        -- upvalues:
        --  [1] arg23 (copy)

        arg23.Spectators:Refresh()
    end))
    local Connections_25 = arg23._connections
    local v29 = PlayerDataController_m:GetSettingChangedSignal("Health Bar Display")
    table.insert(Connections_25, v29:Connect(function() -- line: 378
        -- upvalues:
        --  [1] arg23 (copy)

        arg23.Health:UpdateParent()
    end))
    local Connections_26 = arg23._connections
    local v30 = PlayerDataController_m:GetSettingChangedSignal("Keybinds Interface")
    table.insert(Connections_26, v30:Connect(function() -- line: 382
        -- upvalues:
        --  [1] arg23 (copy)

        arg23.Keybinds:Refresh()
    end))
    local Connections_27 = arg23._connections
    local v31 = PlayerDataController_m:GetSettingChangedSignal("Equipped Weapon Display")
    table.insert(Connections_27, v31:Connect(function() -- line: 386
        -- upvalues:
        --  [1] arg23 (copy)

        arg23.Hotbar:UpdateAmmo()
        arg23.Hotbar:UpdateVisibility()
        arg23.EquippedDisplays:UpdateAmmo()
        arg23.EquippedDisplays:UpdateVisibility()
        arg23.EquippedDisplays:UpdateParents()
    end))
    local Connections_28 = arg23._connections
    local v32 = PlayerDataController_m:GetSettingChangedSignal("Hotbar Slot Ammo")
    table.insert(Connections_28, v32:Connect(function() -- line: 394
        -- upvalues:
        --  [1] arg23 (copy)

        arg23.Hotbar:UpdateAmmo()
        arg23.EquippedDisplays:UpdateAmmo()
    end))
    local Connections_29 = arg23._connections
    local v33 = PlayerDataController_m:GetSettingChangedSignal("Equipped Weapon Icon")
    table.insert(Connections_29, v33:Connect(function() -- line: 399
        -- upvalues:
        --  [1] arg23 (copy)

        arg23.EquippedDisplays:UpdateParents()
    end))
    local Connections_30 = arg23._connections
    local v34 = PlayerDataController_m:GetSettingChangedSignal("Equipped Weapon Ammo")
    table.insert(Connections_30, v34:Connect(function() -- line: 403
        -- upvalues:
        --  [1] arg23 (copy)

        arg23.EquippedDisplays:UpdateParents()
    end))
    local Connections_31 = arg23._connections
    local v35 = PlayerDataController_m:GetSettingChangedSignal("Hotbar Display")
    table.insert(Connections_31, v35:Connect(function() -- line: 407
        -- upvalues:
        --  [1] arg23 (copy)

        arg23.Hotbar:UpdateParent()
        arg23.Hotbar:UpdateVisibility()
        arg23.EquippedDisplays:UpdateParents()
    end))

    if arg23.ClientFighter.IsLocalPlayer then
        table.insert(arg23._connections, OutOfBoundsParts_m.Warning:Connect(function(arg26) -- line: 414
            -- upvalues:
            --  [1] arg23 (copy)

            arg23.WarningEffect:SetEnabled(true, arg26)
        end))
        table.insert(arg23._connections, OutOfBoundsParts_m.SteppedOut:Connect(function() -- line: 418
            -- upvalues:
            --  [1] arg23 (copy)

            arg23.WarningEffect:SetEnabled(false)
        end))
    end

    arg23:_Setup()
    arg23:_UpdateSizing()
    arg23:_UpdateVisibility()
    arg23.ESP:Refresh()
    arg23.Keybinds:Refresh()
    arg23.Spectators:Refresh()
    arg23.EliminationSlots:Refresh()
    task.defer(arg23._EntityAdded, arg23)
end

return t
