local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local GamepadService = game:GetService("GamepadService")
local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")
local InputLibrary_m = require(ReplicatedStorage.Modules.InputLibrary)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local Signal_m = require(ReplicatedStorage.Modules.Signal)
local ControlsController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.ControlsController
)
local UserInterface = Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("UserInterface")
local MainGui = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("MainGui")
local t = {
    "Shutdown",
    "PurchasePrompt",
    "MobileInputs",
    "Inset",
    "SwitchCameraPOV",
    "Pages",
    "Panels",
    "Equipment",
    "Queue",
    "EliminatedEffect",
    "Spectate",
    "HUD",
    "Lobby",
    "Notifications",
    "SideTasks",
    "Teleporting",
    "PlayerList",
    "MatchmakingCountdown",
    "Spotlight",
    "JoystickModal",
    "SideParty",
    "BossHealth",
    "MainGlowyBackground",
    "WarningMessages",
    "DarkBlurryBackground"
}
local t_1 = {}
t_1.__index = t_1

function t_1._new() -- line: 25
    -- upvalues:
    --  [1] t_1 (copy)
    --  [2] Signal_m (copy)
    --  [3] MainGui (copy)

    local t_2 = setmetatable({}, t_1)
    t_2.ElementsLoaded = Signal_m.new()
    t_2.PageSystemPagesActivity = Signal_m.new()
    t_2.EquipmentOpened = Signal_m.new()
    t_2.MainGui = MainGui
    t_2._are_elements_loaded = false
    t_2._elements = {}
    t_2._selected_object_connections = {}
    t_2._gamepad_connections = {}
    t_2:_Init()

    return t_2
end

function t_1.GetDefaultElement(arg1) -- line: 48
    return arg1._elements.Pages and arg1._elements.Pages:GetDefaultElement() or nil
end

function t_1.IsPageOpen(arg2, arg3) -- line: 53
    local v2 = arg2._elements[arg3 or "Pages"]

    return v2 and v2.PageSystem and v2.PageSystem.CurrentPage
end

function t_1.IsEquipmentOpen(arg4) -- line: 60
    return arg4._elements.Equipment and arg4._elements.Equipment.IsOpen
end

function t_1.GetPage(arg5, ...) -- line: 64
    local v5 = arg5._elements.Pages

    if v5 then
        v5 = arg5._elements.Pages.PageSystem:GetPage(...)
    end

    return v5
end

function t_1.OpenPage(arg6, ...) -- line: 68
    local v6 = arg6._elements.Pages

    if v6 then
        v6 = arg6._elements.Pages.PageSystem:OpenPage(...)
    end

    return v6
end

function t_1.WaitUntilLoaded(arg7) -- line: 72
    if not arg7._are_elements_loaded then
        arg7.ElementsLoaded:Wait()
    end
end

function t_1.CloseRequest(arg8) -- line: 78
    local v7 = arg8:IsPageOpen()

    if v7 then
        if not v7.CantBeClosedFromInputs then
            arg8._elements.Pages:CloseRequest()
        end

        return
    end

    if arg8:IsEquipmentOpen() then
        arg8._elements.Equipment:CloseRequest()

        return
    end

    local v8 = arg8:_GetSpectatedDuelInterface()

    if
        v8
        and (v8.FinalResults.Buttons.LeaveFrame.Visible or v8.FinalResults.Buttons.ContinueFrame.Visible)
    then
        if v8.FinalResults.Buttons.ContinueFrame.Visible then
            v8.FinalResults.Buttons:Continue()

            return
        end

        v8.FinalResults.Buttons:LeaveRequest()

        return
    end
end

function t_1.PrimaryAction(arg9) -- line: 105
    -- upvalues:
    --  [1] Utility_m (copy)

    if
        arg9._elements.Lobby
        and arg9._elements.Lobby.Play
        and arg9._elements.Lobby.Play.IsPlayVisible
        and Utility_m:IsUIElementVisible(arg9._elements.Lobby.Play.PlayButton)
    then
        arg9._elements.Lobby.Play:OpenPlayPage()

        return
    end

    local v9 = arg9:_GetSpectatedDuelInterface()

    if v9 and v9.FinalResults.Buttons.PlayAgainFrame.Visible then
        v9.FinalResults.Buttons:PlayAgain()

        return
    end
end

function t_1.SecondaryAction(arg10) -- line: 119
    if not arg10._elements.Pages then
        return
    end

    local v10 = arg10:_GetSpectatedDuelInterface()

    if v10 then
        if v10.FinalResults.Buttons.RematchFrame.Visible then
            v10.FinalResults.Buttons:Rematch()
        end

        return
    end

    local v11 = arg10:_GetSpectatedSubject()
    local v12 = v11

    if v12 then
        v12 = v11:Get("IsInShootingRange") or v11:Get("IsInDuel")
    end

    local v13 = arg10:IsPageOpen()
    local v14, v15

    if not v13 then
        if not v12 or v13 and v13.Name ~= "Party" then
            v14 = arg10._elements.Lobby and arg10._elements.Lobby.Party and arg10._elements.Lobby.Party.IsVisible
            v15 = arg10._elements.SideParty and arg10._elements.SideParty.IsVisible

            if v14 or v15 then
                arg10._elements.Pages.PageSystem:OpenPage("Party", true)

                return
            end
        end

        return
    end

    if v13 and v13.Name ~= "Party" then
        v14 = arg10._elements.Lobby and arg10._elements.Lobby.Party and arg10._elements.Lobby.Party.IsVisible
        v15 = arg10._elements.SideParty and arg10._elements.SideParty.IsVisible

        if v14 or v15 then
            arg10._elements.Pages.PageSystem:OpenPage("Party", true)

            return
        end
    end
end

function t_1.TertiaryAction(arg11) -- line: 149
    -- upvalues:
    --  [1] Utility_m (copy)

    if
        arg11._elements.Lobby
        and arg11._elements.Lobby.Play
        and arg11._elements.Lobby.Play.IsHubVisible
        and Utility_m:IsUIElementVisible(arg11._elements.Lobby.Play.HubButton)
    then
        arg11._elements.Lobby.Play:GoBackToHub()
    end
end

function t_1.QuaternaryAction(arg12) -- line: 155
    -- upvalues:
    --  [1] Utility_m (copy)

    if
        arg12._elements.Lobby
        and arg12._elements.Lobby.Play
        and arg12._elements.Lobby.Play.IsRematchVisible
        and Utility_m:IsUIElementVisible(arg12._elements.Lobby.Play.RematchButton)
    then
        arg12._elements.Lobby.Play:RematchRequest()
    end
end

function t_1._GetSpectatedSubject(_) -- line: 165
    -- upvalues:
    --  [1] Players (copy)

    return require(Players.LocalPlayer.PlayerScripts.Controllers.SpectateController).CurrentSubject
end

function t_1._GetSpectatedDuelInterface(_) -- line: 170
    -- upvalues:
    --  [1] Players (copy)

    local SpectateController_m = require(
        Players.LocalPlayer.PlayerScripts.Controllers.SpectateController
    )

    return SpectateController_m.CurrentDuelSubject and SpectateController_m.CurrentDuelSubject.DuelInterface
end

function t_1._CheckSelectedObjectVisible(_) -- line: 175
    -- upvalues:
    --  [1] GuiService (copy)
    --  [2] Utility_m (copy)
    --  [3] GamepadService (copy)

    if GuiService.SelectedObject and not Utility_m:IsUIElementVisible(GuiService.SelectedObject) then
        GamepadService:DisableGamepadCursor()
    end
end

function t_1._UpdateSelectedObject(arg16) -- line: 181
    -- upvalues:
    --  [1] Players (copy)
    --  [2] GuiService (copy)
    --  [3] GamepadService (copy)

    if not Players.LocalPlayer:FindFirstChild("PlayerGui") then
        return
    end

    if not GuiService.SelectedObject then
        local v17 = arg16:GetDefaultElement()
        local v18 = v17 and v17:IsDescendantOf(Players.LocalPlayer.PlayerGui) and v17 or nil

        if v17 then
            GamepadService:EnableGamepadCursor(v18)
            GuiService.SelectedObject = v18

            return
        end

        GamepadService:DisableGamepadCursor()
        GuiService.SelectedObject = nil

        return
    else
        for _, val in pairs(arg16._selected_object_connections) do
            val:Disconnect()
        end

        arg16._selected_object_connections = {}
        table.insert(arg16._selected_object_connections, GuiService.SelectedObject.AncestryChanged:Connect(
            function() -- line: 207
                -- upvalues:
                --  [1] arg16 (copy)

                arg16:_CheckSelectedObjectVisible()
            end
        ))
        table.insert(arg16._selected_object_connections, GuiService.SelectedObject:GetPropertyChangedSignal(
            "Visible"
        ):Connect(function() -- line: 211
            -- upvalues:
            --  [1] arg16 (copy)

            arg16:_CheckSelectedObjectVisible()
        end))
        arg16:_CheckSelectedObjectVisible()

        return
    end
end

function t_1._UpdateGamepadControls(arg17) -- line: 218
    -- upvalues:
    --  [1] ControlsController_m (copy)

    for _, val_1 in pairs(arg17._gamepad_connections) do
        val_1:Disconnect()
    end

    for _, val_2 in pairs(arg17._selected_object_connections) do
        val_2:Disconnect()
    end

    arg17._gamepad_connections = {}
    arg17._selected_object_connections = {}

    if ControlsController_m.CurrentControls ~= "Gamepad" then
        return
    end
end

function t_1._Setup(arg18) -- line: 243
    -- upvalues:
    --  [1] t (copy)
    --  [2] UserInterface (copy)
    --  [3] Players (copy)

    task.defer(function() -- line: 244
        -- upvalues:
        --  [1] t (ref)
        --  [2] arg18 (copy)
        --  [3] UserInterface (ref)

        for _, val_3 in pairs(t) do
            arg18._elements[val_3] = require(UserInterface:WaitForChild(val_3))
        end

        arg18._elements.Pages.PageSystem.PagesActivity:Connect(function(...) -- line: 251
            -- upvalues:
            --  [1] arg18 (ref)

            arg18.PageSystemPagesActivity:Fire(...)
        end)
        arg18._elements.Equipment.Opened:Connect(function(...) -- line: 255
            -- upvalues:
            --  [1] arg18 (ref)

            arg18.EquipmentOpened:Fire(...)
        end)
        arg18._are_elements_loaded = true
        arg18.ElementsLoaded:Fire()
    end)
    arg18.MainGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
end

function t_1._Init(arg19) -- line: 267
    -- upvalues:
    --  [1] ControlsController_m (copy)
    --  [2] UserInputService (copy)
    --  [3] InputLibrary_m (copy)

    ControlsController_m.ControlsChanged:Connect(function() -- line: 268
        -- upvalues:
        --  [1] arg19 (copy)

        arg19:_UpdateGamepadControls()
    end)
    UserInputService.InputBegan:Connect(function(input: InputObject, gameProcessedEvent: boolean) -- line: 272
        -- upvalues:
        --  [1] InputLibrary_m (ref)
        --  [2] arg19 (copy)

        if gameProcessedEvent then
            return
        end

        if InputLibrary_m:InputIs(input, "UICancelAction") then
            arg19:CloseRequest()

            return
        end

        if InputLibrary_m:InputIs(input, "UIPrimaryAction") then
            arg19:PrimaryAction()

            return
        end

        if InputLibrary_m:InputIs(input, "UISecondaryAction") then
            arg19:SecondaryAction()

            return
        end

        if InputLibrary_m:InputIs(input, "UITertiaryAction") then
            arg19:TertiaryAction()

            return
        end

        if InputLibrary_m:InputIs(input, "UIQuaternaryAction") then
            arg19:QuaternaryAction()
        end
    end)
    arg19:_Setup()
    arg19:_UpdateGamepadControls()
end

return t_1._new()
