local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GamepadService = game:GetService("GamepadService")
local GuiService = game:GetService("GuiService")
local _ = game:GetService("RunService")
local Players = game:GetService("Players")
local CONSTANTS_m = require(ReplicatedStorage.Modules.CONSTANTS)
local _ = require(ReplicatedStorage.Modules.DebugLibrary)
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
local DuelController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("DuelController")
)
local MobileInputs_m = require(
    Players.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("MobileInputs")
)
local Teleporting_m = require(
    Players.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("Teleporting")
)
local Queue_m = require(
    Players.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("Queue")
)
local PageSystem_m = require(Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("PageSystem"))
local UILibrary_m = require(Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("UILibrary"))
local t = {}
t.__index = t

function t._new() -- line: 23
    -- upvalues:
    --  [1] t (copy)
    --  [2] UILibrary_m (copy)
    --  [3] PageSystem_m (copy)

    local t_1 = setmetatable({}, t)
    t_1.Frame = UILibrary_m:GetTo("MainFrame", "Pages")
    t_1.PageSystem = PageSystem_m.new(t_1.Frame)
    t_1._welcomeback_popped_up = false
    t_1._patchnotes_popped_up = false
    t_1._mobileduels_popped_up = false
    t_1._delay_next_popup = nil
    t_1:_Init()

    return t_1
end

function t.GetDefaultElement(arg1) -- line: 44
    return arg1.PageSystem:GetDefaultElement()
end

function t.CloseRequest(arg2) -- line: 48
    arg2.PageSystem:CloseRequest()
end

function t.OpenPickWeaponsPage(arg3) -- line: 52
    -- upvalues:
    --  [1] PlayerDataController_m (copy)

    arg3.PageSystem:OpenPage(
        if PlayerDataController_m:GetSetting("Pick Weapons List") == "List" then "PickWeaponsList" else "PickWeapons",
        true
    )
end

function t._UpdateVisibility(arg4) -- line: 60
    -- upvalues:
    --  [1] GuiService (copy)

    arg4.Frame.Visible = not GuiService.MenuIsOpen
end

function t._CheckInterruption(arg5) -- line: 64
    -- upvalues:
    --  [1] Queue_m (copy)
    --  [2] Teleporting_m (copy)
    --  [3] MobileInputs_m (copy)

    if not arg5.PageSystem.CurrentPage then
        return
    end

    if if not Queue_m:IsVisible() then Teleporting_m.Enabled or MobileInputs_m.EditorEnabled else arg5.PageSystem.CurrentPage.Name ~= "PickEmote" or Teleporting_m.Enabled or MobileInputs_m.EditorEnabled then
        arg5.PageSystem:CloseCurrentPage()
    end
end

function t._CheckPopUps(arg6) -- line: 74
    -- upvalues:
    --  [1] DuelController_m (copy)
    --  [2] Players (copy)
    --  [3] PlayerDataController_m (copy)
    --  [4] CONSTANTS_m (copy)
    --  [5] ControlsController_m (copy)
    --  [6] Utility_m (copy)

    if arg6.PageSystem.CurrentPage then
        return
    end

    wait(1)

    if arg6._delay_next_popup then
        local _ = arg6._delay_next_popup
        arg6._delay_next_popup = nil
        wait(arg6._delay_next_popup)
    end

    if DuelController_m:GetDuel(Players.LocalPlayer) then
        return
    end

    local StatisticDuelsPlayed = PlayerDataController_m:GetStatistic("StatisticDuelsPlayed")

    if not arg6._welcomeback_popped_up and PlayerDataController_m:Get("WelcomeBackGiftReady") then
        arg6._welcomeback_popped_up = true
        arg6._delay_next_popup = 9
        arg6.PageSystem:OpenPage("WelcomeBack", true)
    elseif
        not arg6._patchnotes_popped_up
        and PlayerDataController_m:Get("LastPatchNotesVersion") ~= CONSTANTS_m.GAME_VERSION
        and StatisticDuelsPlayed > 3
    then
        arg6._patchnotes_popped_up = true
        arg6.PageSystem:OpenPage("PatchNotes", true)
    elseif
        not arg6._mobileduels_popped_up
        and not CONSTANTS_m.IS_MOBILE_SERVER
        and StatisticDuelsPlayed > 0
        and StatisticDuelsPlayed <= 3
        and ControlsController_m.CurrentControls == "Touch"
    then
        arg6._mobileduels_popped_up = true
        arg6.PageSystem:OpenPage("MobileDuels", true)
    elseif
        StatisticDuelsPlayed > 10
        and CONSTANTS_m.IS_HUB_SERVER
        and (if not Utility_m:IsAprilFools() then not Utility_m:IsAprilFools() and not (PlayerDataController_m:Get(
            "AprilFoolsDialogAcknowledged"
        ) == -1) else PlayerDataController_m:Get("AprilFoolsDialogAcknowledged") == -1 or not Utility_m:IsAprilFools() and not (PlayerDataController_m:Get(
            "AprilFoolsDialogAcknowledged"
        ) == -1))
    then
        arg6.PageSystem:OpenPage("DialogAprilFools", true)
    end

    arg6._patchnotes_popped_up = true
end

function t._PickWeapons(arg7) -- line: 110
    -- upvalues:
    --  [1] FighterController_m (copy)
    --  [2] Players (copy)
    --  [3] DuelController_m (copy)

    local v11 = FighterController_m:GetFighter(Players.LocalPlayer)

    if not v11 then
        return
    end

    local v12 = DuelController_m:GetDuel(Players.LocalPlayer)
    local v13 = false

    if #v11.Items == 0 then
        v13 = v11:Get("CanPickWeapons")

        if v13 then
            v13 = v11:IsAlive()
        end
    end

    v11 = v12

    if v11 then
        v11 = v12.LocalDueler

        if v11 then
            v11 = v12.LocalDueler:GetStaggeredSpawnsTurn()
        end
    end

    if v13 then
        if not arg7.PageSystem.CurrentPage then
            arg7:OpenPickWeaponsPage()

            return
        end
    elseif not v11 then
        for _, val in pairs({ "PickWeapons", "PickWeaponsList" }) do
            local v14 = arg7.PageSystem:GetPage(val)

            if v14 and v14:IsOpen() then
                arg7.PageSystem:CloseCurrentPage()
            end
        end
    end
end

function t._DuelAdded(arg8, arg9) -- line: 136
    -- upvalues:
    --  [1] Players (copy)

    if not arg9:GetDueler(Players.LocalPlayer) then
        return
    end

    arg9:GetDataChangedSignal("StaggeredSpawnsOrder"):Connect(function() -- line: 141
        -- upvalues:
        --  [1] arg8 (copy)

        arg8:_PickWeapons()
    end)
    arg8:_PickWeapons()
end

function t._HookLocalFighter(arg10) -- line: 148
    -- upvalues:
    --  [1] FighterController_m (copy)

    local v15 = FighterController_m:WaitForLocalFighter()
    v15:GetDataChangedSignal("IsInDuel"):Connect(function() -- line: 151
        -- upvalues:
        --  [1] v15 (copy)
        --  [2] arg10 (copy)

        if v15:Get("IsInDuel") and arg10.PageSystem.CurrentPage then
            arg10.PageSystem:CloseCurrentPage()
        end
    end)
    v15:GetDataChangedSignal("CanPickWeapons"):Connect(function() -- line: 157
        -- upvalues:
        --  [1] arg10 (copy)

        arg10:_PickWeapons()
    end)
    v15.EntityRemoved:Connect(function() -- line: 161
        -- upvalues:
        --  [1] arg10 (copy)

        arg10:_PickWeapons()
    end)
    v15.ItemRemoved:Connect(function() -- line: 165
        -- upvalues:
        --  [1] arg10 (copy)

        arg10:_PickWeapons()
    end)
    v15.ItemAdded:Connect(function() -- line: 169
        -- upvalues:
        --  [1] arg10 (copy)

        arg10:_PickWeapons()
    end)

    local function entity_added(arg11) -- line: 173
        -- upvalues:
        --  [1] arg10 (copy)

        arg11.Died:Connect(function() -- line: 174
            -- upvalues:
            --  [1] arg10 (ref)

            arg10:_PickWeapons()
        end)
        arg10:_PickWeapons()
    end

    v15.EntityAdded:Connect(entity_added)

    if v15.Entity then
        task.defer(entity_added, v15.Entity)
    end
end

function t._SweepFromFolder(_) -- line: 188
    -- upvalues:
    --  [1] Players (copy)

    local function folder_added(arg13) -- line: 189
        -- upvalues:
        --  [1] Players (ref)

        if not arg13:IsA("SurfaceGui") or arg13.Name ~= "PagesFromServer" then
            return
        end

        local function sweep() -- line: 194
            -- upvalues:
            --  [1] arg13 (copy)
            --  [2] Players (ref)

            task.defer(function() -- line: 195
                -- upvalues:
                --  [1] arg13 (ref)
                --  [2] Players (ref)

                for _, child in pairs(arg13:GetChildren()) do
                    child.Parent = Players.LocalPlayer.PlayerScripts.UserInterface.Pages
                end
            end)
        end

        arg13.ChildAdded:Connect(sweep)
        task.defer(function() -- line: 195
            -- upvalues:
            --  [1] arg13 (copy)
            --  [2] Players (ref)

            for _, child_1 in pairs(arg13:GetChildren()) do
                child_1.Parent = Players.LocalPlayer.PlayerScripts.UserInterface.Pages
            end
        end)
    end

    Players.LocalPlayer.PlayerGui.ChildAdded:Connect(function(child_3: Instance) -- line: 206
        -- upvalues:
        --  [1] folder_added (copy)

        folder_added(child_3)
    end)

    for _, child_2 in pairs(Players.LocalPlayer.PlayerGui:GetChildren()) do
        folder_added(child_2)
    end
end

function t._Init(arg15) -- line: 215
    -- upvalues:
    --  [1] GamepadService (copy)
    --  [2] Queue_m (copy)
    --  [3] Teleporting_m (copy)
    --  [4] MobileInputs_m (copy)
    --  [5] ControlsController_m (copy)
    --  [6] PlayerDataController_m (copy)
    --  [7] DuelController_m (copy)
    --  [8] GuiService (copy)

    arg15.PageSystem.PageOpened:Connect(function() -- line: 216
        -- upvalues:
        --  [1] GamepadService (ref)
        --  [2] arg15 (copy)

        GamepadService:EnableGamepadCursor(arg15:GetDefaultElement())
    end)
    arg15.PageSystem.PageClosed:Connect(function(arg16) -- line: 220
        -- upvalues:
        --  [1] GamepadService (ref)
        --  [2] arg15 (copy)

        GamepadService:DisableGamepadCursor()
        task.defer(arg15._CheckPopUps, arg15)

        if
            arg16 ~= arg15.PageSystem:GetPage("PickWeapons")
            and arg16 ~= arg15.PageSystem:GetPage("PickWeaponsList")
        then
            task.defer(arg15._PickWeapons, arg15)
        end
    end)
    Queue_m.VisibilityChanged:Connect(function() -- line: 229
        -- upvalues:
        --  [1] arg15 (copy)

        arg15:_CheckInterruption()
    end)
    Teleporting_m.EnabledChanged:Connect(function() -- line: 233
        -- upvalues:
        --  [1] arg15 (copy)

        arg15:_CheckInterruption()
    end)
    MobileInputs_m.EditorEnabledChanged:Connect(function() -- line: 237
        -- upvalues:
        --  [1] arg15 (copy)

        arg15:_CheckInterruption()
    end)
    ControlsController_m.ControlsChanged:Connect(function() -- line: 241
        -- upvalues:
        --  [1] arg15 (copy)

        arg15:_CheckPopUps()
    end)
    PlayerDataController_m:GetDataChangedSignal("StatisticDuelsPlayed"):Connect(function() -- line: 245
        -- upvalues:
        --  [1] arg15 (copy)

        arg15:_CheckPopUps()
    end)
    PlayerDataController_m:GetDataChangedSignal("AprilFoolsDialogAcknowledged"):Connect(function() -- line: 249
        -- upvalues:
        --  [1] arg15 (copy)

        arg15:_CheckPopUps()
    end)
    DuelController_m.LocalPlayerLeftDuel:Connect(function() -- line: 253
        -- upvalues:
        --  [1] arg15 (copy)

        arg15:_CheckPopUps()
    end)
    GuiService:GetPropertyChangedSignal("MenuIsOpen"):Connect(function() -- line: 257
        -- upvalues:
        --  [1] arg15 (copy)

        arg15:_UpdateVisibility()
    end)
    arg15:_UpdateVisibility()
    task.defer(arg15._CheckPopUps, arg15)
    task.defer(arg15._SweepFromFolder, arg15)
    task.defer(arg15._HookLocalFighter, arg15)
end

return t._new()
