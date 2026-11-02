local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GamepadService = game:GetService("GamepadService")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local _ = game:GetService("Lighting")
local Players = game:GetService("Players")
local LootLibrary_m = require(ReplicatedStorage.Modules.LootLibrary)
local ShopLibrary_m = require(ReplicatedStorage.Modules.ShopLibrary)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local Signal_m = require(ReplicatedStorage.Modules.Signal)
local ShootingRangeController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.ShootingRangeController
)
local MonetizationController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.MonetizationController
)
local PlayerDataController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.PlayerDataController
)
local FighterController_m = require(Players.LocalPlayer.PlayerScripts.Controllers.FighterController)
local CameraController_m = require(Players.LocalPlayer.PlayerScripts.Controllers.CameraController)
local MobileInputs_m = require(Players.LocalPlayer.PlayerScripts.Modules.UserInterface.MobileInputs)
local Teleporting_m = require(Players.LocalPlayer.PlayerScripts.Modules.UserInterface.Teleporting)
local Queue_m = require(Players.LocalPlayer.PlayerScripts.Modules.UserInterface.Queue)
local Pages_m = require(Players.LocalPlayer.PlayerScripts.Modules.UserInterface.Pages)
local UILibrary_m = require(Players.LocalPlayer.PlayerScripts.Modules.UILibrary)
local EquipmentState_m = require(script:WaitForChild("EquipmentState"))
local FloatingModel_m = require(script:WaitForChild("FloatingModel"))
local SpinControls_m = require(script:WaitForChild("SpinControls"))
local Interface_m = require(script:WaitForChild("Interface"))
local Camera_m = require(script:WaitForChild("Camera"))
local Scene_m = require(script:WaitForChild("Scene"))
local t = {}
t.__index = t

function t._new() -- line: 32
    -- upvalues:
    --  [1] t (copy)
    --  [2] Signal_m (copy)
    --  [3] UILibrary_m (copy)
    --  [4] EquipmentState_m (copy)
    --  [5] Camera_m (copy)
    --  [6] Scene_m (copy)
    --  [7] FloatingModel_m (copy)
    --  [8] SpinControls_m (copy)
    --  [9] Interface_m (copy)

    local t_1 = setmetatable({}, t)
    t_1.Opened = Signal_m.new()
    t_1.SelectedWeaponChanged = Signal_m.new()
    t_1.CareerPageOpened = Signal_m.new()
    t_1.CustomizingChanged = Signal_m.new()
    t_1.CustomizingStateChanged = Signal_m.new()
    t_1.CosmeticSearchChanged = Signal_m.new()
    t_1.UnlockingChanged = Signal_m.new()
    t_1.FinishedOpenEffect = Signal_m.new()
    t_1.CharmAttachmentVisibleChanged = Signal_m.new()
    t_1.Frame = UILibrary_m:GetTo("MainFrame", "Equipment")
    t_1.IsOpen = false
    t_1.EquipmentState = EquipmentState_m.new(t_1)
    t_1.Camera = Camera_m.new(t_1)
    t_1.Scene = Scene_m.new(t_1)
    t_1.FloatingModel = FloatingModel_m.new(t_1)
    t_1.SpinControls = SpinControls_m.new(t_1)
    t_1.Interface = Interface_m.new(t_1)
    t_1._is_trying_weapon = false
    t_1._from_shop = false
    t_1._was_chat_active = true
    t_1._open_hash = 0
    t_1._on_state_changed_queued = false
    t_1._on_customizing_state_changed_queued = false
    t_1:_Init()

    return t_1
end

function t.IsCareerPageOpen(arg1) -- line: 70
    return arg1.EquipmentState.IsCareerPageOpen
end

function t.IsOpenEffectDone(arg2, ...) -- line: 74
    return arg2.Camera:IsOpenEffectDone(...)
end

function t.IsUnlocking(arg3) -- line: 78
    return arg3.Scene.UnlockModel.IsUnlocking
end

function t.IsCustomizing(arg4) -- line: 82
    return arg4.EquipmentState.CustomizingType ~= nil
end

function t.GetStateID(arg5, arg6) -- line: 86
    -- upvalues:
    --  [1] PlayerDataController_m (copy)

    local _ = arg5:IsCustomizing()
    local v9 = arg5:IsCareerPageOpen()
    local v10 = arg5:GetSelectedWeapon()
    local v11 = PlayerDataController_m:GetWeaponData(v10)

    if v9 then
        return "FAKE_CAREER_STATE"
    end

    if v10 then
        local v13

        if arg6 then
            v13 = tostring(v11 ~= nil) or ""
        else
            v13 = ""
        end

        return v10 .. v13
    end

    return "nil"
end

function t.GetSelectedWeapon(arg7) -- line: 97
    return arg7.EquipmentState.SelectedWeapon
end

function t.GetSelectedCosmetic(arg8) -- line: 101
    return arg8.EquipmentState.SelectedCosmetic
end

function t.GetCosmeticSearchQuery(arg9) -- line: 105
    return arg9.EquipmentState.CosmeticSearchQuery
end

function t.GetCustomizingType(arg10) -- line: 109
    return arg10.EquipmentState.CustomizingType
end

function t.SetCosmeticSearchQuery(arg11, ...) -- line: 113
    return arg11.EquipmentState:SetCosmeticSearchQuery(...)
end

function t.SelectCosmetic(arg12, ...) -- line: 117
    return arg12.EquipmentState:SelectCosmetic(...)
end

function t.SelectWeapon(arg13, ...) -- line: 121
    return arg13.EquipmentState:SelectWeapon(...)
end

function t.OpenCareerPage(arg14, ...) -- line: 125
    return arg14.EquipmentState:OpenCareerPage(...)
end

function t.StartCustomizing(arg15, ...) -- line: 129
    return arg15.EquipmentState:StartCustomizing(...)
end

function t.FavoriteWeapon(arg16) -- line: 133
    -- upvalues:
    --  [1] ReplicatedStorage (copy)

    local v14 = arg16:GetSelectedWeapon()

    if not v14 then
        return
    end

    ReplicatedStorage.Remotes.Data.FavoriteWeapon:FireServer(v14)
end

function t.LevelUpWeapon(arg17) -- line: 143
    -- upvalues:
    --  [1] PlayerDataController_m (copy)
    --  [2] LootLibrary_m (copy)
    --  [3] Pages_m (copy)
    --  [4] MonetizationController_m (copy)
    --  [5] Utility_m (copy)
    --  [6] ReplicatedStorage (copy)

    local v15 = arg17:GetSelectedWeapon()
    local v16 = PlayerDataController_m:GetWeaponData(v15)

    if not v16 then
        return
    end

    local v17 = LootLibrary_m:GetCostToLevelUp(v16.Level, v16.XP)

    if v17 > PlayerDataController_m:Get("WeaponKeys") then
        Pages_m.PageSystem:OpenPage("Shop", true)
        Pages_m.PageSystem:WaitForPage("Shop"):SetPage("Currency")
        MonetizationController_m:PromptCurrencyBundlePurchase(v17, "WeaponKeys")

        return
    end

    Utility_m:CreateSound(
        "rbxassetid://18242015218",
        1,
        1,
        script,
        true,
        6
    )
    ReplicatedStorage.Remotes.Data.LevelUpWeapon:FireServer(v15)
end

function t.UnlockWeapon(arg18) -- line: 164
    -- upvalues:
    --  [1] ShopLibrary_m (copy)
    --  [2] PlayerDataController_m (copy)
    --  [3] Pages_m (copy)
    --  [4] MonetizationController_m (copy)
    --  [5] ReplicatedStorage (copy)

    local v18 = arg18:GetSelectedWeapon()
    local v21, v22, v23, _ = ShopLibrary_m:GetWeaponKeyPriceInfo(
        v18,
        PlayerDataController_m:Get("UnlockTokens"),
        PlayerDataController_m:Get("FreeWeaponUnlockCheck")
    )

    if not v23 and not ShopLibrary_m:IsWeaponReleased(v18) then
        return
    end

    if v21 > PlayerDataController_m:Get("WeaponKeys") and not v22 then
        Pages_m.PageSystem:OpenPage("Shop", true)
        Pages_m.PageSystem:WaitForPage("Shop"):SetPage("Currency")
        MonetizationController_m:PromptCurrencyBundlePurchase(v21, "WeaponKeys")

        return
    end

    arg18.Scene.UnlockModel:PlayAnimation()
    ReplicatedStorage.Remotes.Data.UnlockWeapon:FireServer(v18)
end

function t.TryWeapon(arg19) -- line: 183
    -- upvalues:
    --  [1] ShootingRangeController_m (copy)

    local v25 = arg19:GetSelectedWeapon()

    if not v25 then
        return
    end

    arg19._is_trying_weapon = true
    arg19._from_shop = false
    arg19:Close(nil, true)
    ShootingRangeController_m:Enter(v25)
end

function t.Open(arg20, arg21, arg22) -- line: 197
    -- upvalues:
    --  [1] CameraController_m (copy)
    --  [2] RunService (copy)
    --  [3] StarterGui (copy)
    --  [4] GamepadService (copy)

    if not arg22 and (CameraController_m:GetPublicState() or arg20.IsOpen) then
        return
    end

    arg20._open_hash += 1
    arg20:Close(true)
    arg20._renderstep_connection = RunService.RenderStepped:Connect(function(deltaTime: number) -- line: 208
        -- upvalues:
        --  [1] arg20 (copy)

        arg20:_Update(deltaTime)
    end)
    arg20._from_shop = arg21
    arg20._was_chat_active = StarterGui:GetCore("ChatActive")
    GamepadService:EnableGamepadCursor(arg20.Frame)
    pcall(StarterGui.SetCore, StarterGui, "ChatActive", false)
    arg20.IsOpen = true
    arg20.Opened:Fire()
end

function t.Close(arg24, arg25, arg26) -- line: 222
    -- upvalues:
    --  [1] GamepadService (copy)
    --  [2] StarterGui (copy)
    --  [3] Pages_m (copy)

    if not arg24.IsOpen and not arg25 then
        return
    end

    arg24._open_hash += 1

    if arg26 then
        local OpenHash = arg24._open_hash
        arg24.Camera:CloseEffect()

        if OpenHash ~= arg24._open_hash then
            return
        end
    end

    if arg24._renderstep_connection then
        arg24._renderstep_connection:Disconnect()
        arg24._renderstep_connection = nil
    end

    GamepadService:DisableGamepadCursor()
    pcall(StarterGui.SetCore, StarterGui, "ChatActive", arg24._was_chat_active)
    arg24.IsOpen = false
    arg24.Opened:Fire()

    if arg24._from_shop then
        arg24._from_shop = false
        Pages_m.PageSystem:OpenPage("Shop", true)
    end
end

function t.CloseRequest(arg27) -- line: 259
    if arg27:IsCustomizing() then
        arg27:StartCustomizing(nil)

        return
    end

    if arg27:IsOpenEffectDone() then
        arg27:Close(nil, true)
    end
end

function t._OnCustomizingStateChanged(arg28, ...) -- line: 271
    if arg28._on_customizing_state_changed_queued then
        return
    end

    arg28._on_customizing_state_changed_queued = true
    task.defer(function(...) -- line: 278
        -- upvalues:
        --  [1] arg28 (copy)

        arg28._on_customizing_state_changed_queued = false
        arg28.Interface:OnCustomizingStateChanged(...)
        arg28.FloatingModel:OnCustomizingStateChanged(...)
        arg28.Scene:OnCustomizingStateChanged(...)
    end, ...)
end

function t._OnStateChanged(arg29, ...) -- line: 286
    if arg29._on_state_changed_queued then
        return
    end

    arg29._on_state_changed_queued = true
    task.defer(function(...) -- line: 293
        -- upvalues:
        --  [1] arg29 (copy)

        arg29._on_state_changed_queued = false
        arg29.Scene:OnStateChanged(...)
        arg29.Camera:OnStateChanged(...)
        arg29.SpinControls:OnStateChanged(...)
        arg29.FloatingModel:OnStateChanged(...)
        arg29.Interface:OnStateChanged(...)
    end, ...)
end

function t._OnOpen(arg30, ...) -- line: 303
    arg30.EquipmentState:OnOpen(...)
    arg30.Camera:OnOpen(...)
    arg30.Scene:OnOpen(...)
    arg30.SpinControls:OnOpen(...)
    arg30.FloatingModel:OnOpen(...)
    arg30.Interface:OnOpen(...)
end

function t._Update(arg31, ...) -- line: 312
    arg31.Camera:Update(...)
    arg31.SpinControls:Update(...)
    arg31.FloatingModel:Update(...)
    arg31.Interface:Update(...)
end

function t._UpdateVisibility(arg32) -- line: 319
    -- upvalues:
    --  [1] PlayerDataController_m (copy)

    local v26 = arg32.IsOpen
    local Frame = arg32.Frame

    if v26 then
        v26 = not PlayerDataController_m:GetSetting("Hide HUD")
    end

    Frame.Visible = v26
end

function t._CheckInterruption(arg33) -- line: 323
    -- upvalues:
    --  [1] Queue_m (copy)
    --  [2] Teleporting_m (copy)
    --  [3] MobileInputs_m (copy)

    if Queue_m:IsVisible() or Teleporting_m.Enabled or MobileInputs_m.EditorEnabled then
        arg33:Close()
    end
end

function t._HookLocalFighter(arg34) -- line: 329
    -- upvalues:
    --  [1] FighterController_m (copy)

    local v27 = FighterController_m:WaitForLocalFighter()
    v27:GetDataChangedSignal("IsInShootingRange"):Connect(function() -- line: 332
        -- upvalues:
        --  [1] v27 (copy)
        --  [2] arg34 (copy)

        if v27:Get("IsInShootingRange") then
            arg34:Close()

            return
        end

        if arg34._is_trying_weapon and not v27:Get("IsInShootingRange") then
            arg34._is_trying_weapon = false
            arg34:Open(nil, true)
        end
    end)
    v27:GetDataChangedSignal("IsInDuel"):Connect(function() -- line: 341
        -- upvalues:
        --  [1] v27 (copy)
        --  [2] arg34 (copy)

        if v27:Get("IsInDuel") then
            arg34:Close()
        end
    end)
end

function t._Init(arg35) -- line: 348
    -- upvalues:
    --  [1] Queue_m (copy)
    --  [2] Teleporting_m (copy)
    --  [3] MobileInputs_m (copy)
    --  [4] PlayerDataController_m (copy)

    arg35.Opened:Connect(function(...) -- line: 349
        -- upvalues:
        --  [1] arg35 (copy)

        arg35:_UpdateVisibility()
        arg35:_OnOpen(...)
    end)
    arg35.SelectedWeaponChanged:Connect(function(...) -- line: 354
        -- upvalues:
        --  [1] arg35 (copy)

        arg35:_OnStateChanged(...)
    end)
    arg35.CareerPageOpened:Connect(function(...) -- line: 358
        -- upvalues:
        --  [1] arg35 (copy)

        arg35:_OnStateChanged(...)
    end)
    arg35.CustomizingChanged:Connect(function(...) -- line: 362
        -- upvalues:
        --  [1] arg35 (copy)

        arg35:_OnStateChanged(...)
        arg35:_OnCustomizingStateChanged()
    end)
    arg35.CustomizingStateChanged:Connect(function(...) -- line: 367
        -- upvalues:
        --  [1] arg35 (copy)

        arg35:_OnCustomizingStateChanged(...)
    end)
    arg35.EquipmentState.SelectedWeaponChanged:Connect(function(...) -- line: 371
        -- upvalues:
        --  [1] arg35 (copy)

        arg35.SelectedWeaponChanged:Fire(...)
    end)
    arg35.EquipmentState.CareerPageOpened:Connect(function(...) -- line: 375
        -- upvalues:
        --  [1] arg35 (copy)

        arg35.CareerPageOpened:Fire(...)
    end)
    arg35.EquipmentState.CustomizingChanged:Connect(function(...) -- line: 379
        -- upvalues:
        --  [1] arg35 (copy)

        arg35.CustomizingChanged:Fire(...)
    end)
    arg35.EquipmentState.CustomizingStateChanged:Connect(function(...) -- line: 383
        -- upvalues:
        --  [1] arg35 (copy)

        arg35.CustomizingStateChanged:Fire(...)
    end)
    arg35.EquipmentState.CosmeticSearchChanged:Connect(function(...) -- line: 387
        -- upvalues:
        --  [1] arg35 (copy)

        arg35.CosmeticSearchChanged:Fire(...)
    end)
    arg35.Scene.UnlockModel.UnlockingChanged:Connect(function(...) -- line: 391
        -- upvalues:
        --  [1] arg35 (copy)

        arg35.UnlockingChanged:Fire(...)
    end)
    arg35.Camera.FinishedOpenEffect:Connect(function(...) -- line: 395
        -- upvalues:
        --  [1] arg35 (copy)

        arg35.FinishedOpenEffect:Fire(...)
    end)
    arg35.FloatingModel.CharmAttachmentVisibleChanged:Connect(function(...) -- line: 399
        -- upvalues:
        --  [1] arg35 (copy)

        arg35.CharmAttachmentVisibleChanged:Fire(...)
    end)
    Queue_m.VisibilityChanged:Connect(function() -- line: 403
        -- upvalues:
        --  [1] arg35 (copy)

        arg35:_CheckInterruption()
    end)
    Teleporting_m.EnabledChanged:Connect(function() -- line: 407
        -- upvalues:
        --  [1] arg35 (copy)

        arg35:_CheckInterruption()
    end)
    MobileInputs_m.EditorEnabledChanged:Connect(function() -- line: 411
        -- upvalues:
        --  [1] arg35 (copy)

        arg35:_CheckInterruption()
    end)
    PlayerDataController_m:GetSettingChangedSignal("Hide HUD"):Connect(function() -- line: 415
        -- upvalues:
        --  [1] arg35 (copy)

        arg35:_UpdateVisibility()
    end)
    arg35:Close()
    arg35:_UpdateVisibility()
    task.spawn(arg35._HookLocalFighter, arg35)
end

return t._new()
