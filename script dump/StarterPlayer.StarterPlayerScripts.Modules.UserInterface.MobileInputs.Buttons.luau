local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local InputLibrary_m = require(ReplicatedStorage.Modules.InputLibrary)
local EnumLibrary_m = require(ReplicatedStorage.Modules.EnumLibrary)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local PlayerDataController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("PlayerDataController")
)
local MechanicsController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("MechanicsController")
)
local SpectateController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("SpectateController")
)
local CameraController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("CameraController")
)
local EmoteController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("EmoteController")
)
local MobileButton_m = require(script:WaitForChild("MobileButton"))
local t = {}
t.__index = t

function t.new(arg1) -- line: 19
    -- upvalues:
    --  [1] t (copy)

    local t_1 = setmetatable({}, t)
    t_1.MobileInputs = arg1
    t_1.Frame = t_1.MobileInputs.Frame:WaitForChild("Buttons")
    t_1.Buttons = {}
    t_1._generated = false
    t_1._hooked_fighter = false
    t_1._local_fighter = nil
    t_1._connections = {}
    t_1._duel_subject_connections = {}
    t_1:_Init()

    return t_1
end

function t.IsReallyVisible(arg2) -- line: 41
    return arg2.Frame.Visible and arg2.MobileInputs.Frame.Visible
end

function t.GetButtonsFromPosition(arg3, arg4, arg5) -- line: 45
    -- upvalues:
    --  [1] Players (copy)

    if require(Players.LocalPlayer.PlayerScripts.Modules.UserInterface.Inset):IsWithinAnyBar(
        arg4,
        arg5
    ) then
        return {}
    end

    local t_2 = {}

    for _, val in pairs(arg3.Buttons) do
        if val:IsReallyVisible() and val:IsWithin(arg4, arg5) then
            table.insert(t_2, val)
        end
    end

    return t_2
end

function t.GetCurrentProfile(arg6) -- line: 63
    local t_3 = {}

    for key_1, val_1 in pairs(arg6.Buttons) do
        local v8 = val_1.Frame.AbsolutePosition + val_1.Frame.AbsoluteSize * val_1.Frame.AnchorPoint - arg6.Frame.AbsolutePosition
        local t_4 = {
            Position = { v8.X, v8.Y },
            Size = { val_1.Frame.Size.X.Offset, val_1.Frame.Size.Y.Offset }
        }
        t_3[key_1] = t_4
    end

    return t_3
end

function t.EncryptProfile(arg7) -- line: 78
    -- upvalues:
    --  [1] EnumLibrary_m (copy)

    return EnumLibrary_m:EncryptTable(arg7:GetCurrentProfile())
end

function t.VerifyControls(arg8, arg9) -- line: 82
    -- upvalues:
    --  [1] MechanicsController_m (copy)
    --  [2] RunService (copy)
    --  [3] CameraController_m (copy)
    --  [4] EmoteController_m (copy)
    --  [5] PlayerDataController_m (copy)
    --  [6] SpectateController_m (copy)
    --  [7] UserInputService (copy)

    for _, val_2 in pairs(arg8._connections) do
        val_2:Disconnect()
    end

    for _, val_3 in pairs(arg8._duel_subject_connections) do
        val_3:Disconnect()
    end

    arg8._connections = {}
    arg8._duel_subject_connections = {}

    if arg8._generated then
        MechanicsController_m:MobileInput("mobile_shoot", false)
    end

    if not arg9 then
        return
    end

    arg8:_GenerateButtons()
    task.spawn(arg8._HookFighter, arg8)
    table.insert(arg8._connections, RunService.RenderStepped:Connect(function(deltaTime: number) -- line: 106
        -- upvalues:
        --  [1] arg8 (copy)

        for _, val_4 in pairs(arg8.Buttons) do
            val_4:Update(deltaTime)
        end
    end))
    table.insert(arg8._connections, CameraController_m.ActiveStateChanged:Connect(function(_) -- line: 113
        -- upvalues:
        --  [1] arg8 (copy)

        arg8:_UpdateVisibilities()
    end))
    table.insert(arg8._connections, EmoteController_m.CanEmoteChanged:Connect(function() -- line: 117
        -- upvalues:
        --  [1] arg8 (copy)

        arg8:_UpdateVisibilities()
    end))
    table.insert(arg8._connections, PlayerDataController_m:GetDataChangedSignal("SettingsProfile"):Connect(
        function() -- line: 121
            -- upvalues:
            --  [1] arg8 (copy)

            arg8:_UpdatePositionsAndSizes()
        end
    ))
    table.insert(arg8._connections, PlayerDataController_m:GetDataChangedSignal(
        "MobileButtonSettings"
    ):Connect(function() -- line: 125
        -- upvalues:
        --  [1] arg8 (copy)

        arg8:_UpdatePositionsAndSizes()
    end))

    local function update_duel_subject() -- line: 129
        -- upvalues:
        --  [1] arg8 (copy)
        --  [2] SpectateController_m (ref)

        for _, val_5 in pairs(arg8._duel_subject_connections) do
            val_5:Disconnect()
        end

        arg8._duel_subject_connections = {}
        arg8:_UpdateVisibilities()

        if not SpectateController_m.CurrentDuelSubject then
            return
        end

        table.insert(arg8._duel_subject_connections, SpectateController_m.CurrentDuelSubject.DuelInterface.Voting.VisibilityChanged:Connect(
            function() -- line: 141
                -- upvalues:
                --  [1] arg8 (ref)

                arg8:_UpdateVisibilities()
            end
        ))
    end

    table.insert(
        arg8._connections,
        SpectateController_m.DuelSubjectChanged:Connect(update_duel_subject)
    )
    update_duel_subject()
    table.insert(arg8._connections, UserInputService.InputBegan:Connect(function(arg12, _) -- line: 150
        -- upvalues:
        --  [1] arg8 (copy)

        if
            arg12.UserInputType ~= Enum.UserInputType.Touch
            and arg12.UserInputType ~= Enum.UserInputType.MouseButton1
        then
            return
        end

        for _, val_6 in pairs((arg8:GetButtonsFromPosition(arg12.Position.X, arg12.Position.Y))) do
            val_6:Button1Down(arg12)
        end
    end))
    table.insert(arg8._connections, UserInputService.InputEnded:Connect(function(arg14, _) -- line: 162
        -- upvalues:
        --  [1] arg8 (copy)

        if
            arg14.UserInputType == Enum.UserInputType.Touch
            or arg14.UserInputType == Enum.UserInputType.MouseButton1
        then
            for _, val_7 in pairs(arg8.Buttons) do
                val_7:InputEnded(arg14)
            end
        end
    end))
    table.insert(arg8._connections, MechanicsController_m.StateChanged:Connect(function(_) -- line: 170
        -- upvalues:
        --  [1] arg8 (copy)
        --  [2] MechanicsController_m (ref)

        if arg8:IsReallyVisible() and not MechanicsController_m.IsCrouching then
            arg8.Buttons.mobile_crouch:Input(false, true)
        end
    end))
end

function t.UpdatePositionsAndSizes(arg17, ...) -- line: 177
    arg17:_UpdatePositionsAndSizes(...)
end

function t._UpdateWeaponIcons(arg18, ...) -- line: 185
    for _, val_8 in pairs(arg18.Buttons) do
        val_8:UpdateWeaponIcon(...)
    end
end

function t._UpdatePositionsAndSizes(arg19, ...) -- line: 191
    for _, val_9 in pairs(arg19.Buttons) do
        val_9:UpdatePositionAndSize(...)
    end
end

function t._UpdateVisibilities(arg20, ...) -- line: 197
    for _, val_10 in pairs(arg20.Buttons) do
        val_10:UpdateVisibility(...)
    end
end

function t._UpdateMobileInputSettings(arg21, ...) -- line: 203
    for _, val_11 in pairs(arg21.Buttons) do
        val_11:UpdateMobileInputSettings(...)
    end
end

function t._GenerateButtons(arg22) -- line: 209
    -- upvalues:
    --  [1] InputLibrary_m (copy)
    --  [2] MobileButton_m (copy)

    if arg22._generated then
        return
    end

    arg22._generated = true

    for key_12, _ in pairs(InputLibrary_m.MobileButtons) do
        local v11 = MobileButton_m.new(arg22, key_12)
        v11.Frame.Parent = arg22.Frame
        arg22.Buttons[v11.Name] = v11
    end

    arg22.Frame:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- line: 222
        -- upvalues:
        --  [1] arg22 (copy)

        arg22:_UpdatePositionsAndSizes()
    end)
end

function t._HookFighter(arg23) -- line: 227
    -- upvalues:
    --  [1] MechanicsController_m (copy)

    if arg23._hooked_fighter then
        return
    end

    arg23._hooked_fighter = true
    local v13 = MechanicsController_m:WaitForLocalFighter()
    arg23._local_fighter = v13

    local function check_scoped() -- line: 235
        -- upvalues:
        --  [1] arg23 (copy)

        local v14 = false

        for key_13, _ in pairs(arg23._local_fighter:GetEquippedItems()) do
            if key_13.ItemInterface and key_13.ItemInterface:IsScopeActive() then
                v14 = true
                break
            end
        end

        for _, val_14 in pairs(arg23.Buttons) do
            val_14:SetScoped(v14)
        end
    end

    arg23._local_fighter.EquippedItemChanged:Connect(check_scoped)

    local function item_interface_added(arg24, arg25) -- line: 252
        -- upvalues:
        --  [1] check_scoped (copy)

        arg24.Mouse.Scope.ActiveChanged:Connect(check_scoped)

        if not arg25 then
            check_scoped()
        end
    end

    local function client_item_added(arg26, arg27) -- line: 260
        -- upvalues:
        --  [1] arg23 (copy)
        --  [2] item_interface_added (copy)
        --  [3] check_scoped (copy)

        arg26.ToggleOffMobileInputButton:Connect(function(arg28) -- line: 261
            -- upvalues:
            --  [1] arg23 (ref)

            arg23.Buttons[arg28]:Button1Up()
        end)
        arg26.InterfaceAdded:Connect(item_interface_added)

        if arg26.ItemInterface then
            arg26.ItemInterface.Mouse.Scope.ActiveChanged:Connect(check_scoped)

            if not arg27 then
                check_scoped()
            end
        end
    end

    arg23._local_fighter.ItemAdded:Connect(client_item_added)

    for _, val_15 in pairs(arg23._local_fighter.Items) do
        task.spawn(client_item_added, val_15, true)
    end

    task.defer(check_scoped)
    arg23._local_fighter.EquippedItemChanged:Connect(function() -- line: 280
        -- upvalues:
        --  [1] arg23 (copy)

        arg23:_UpdateMobileInputSettings()
    end)
    arg23._local_fighter.HealthChanged:Connect(function() -- line: 284
        -- upvalues:
        --  [1] arg23 (copy)

        arg23:_UpdateVisibilities()
    end)
    arg23._local_fighter.EntityAdded:Connect(function() -- line: 288
        -- upvalues:
        --  [1] arg23 (copy)

        arg23:_UpdateVisibilities()
    end)
    arg23._local_fighter.Died:Connect(function() -- line: 292
        -- upvalues:
        --  [1] arg23 (copy)

        arg23:_UpdateVisibilities()
    end)
    arg23._local_fighter:GetDataChangedSignal("IsInDuel"):Connect(function() -- line: 296
        -- upvalues:
        --  [1] arg23 (copy)

        arg23:_UpdateVisibilities()
    end)
    arg23._local_fighter:GetDataChangedSignal("QuickAttackOverrides"):Connect(function() -- line: 300
        -- upvalues:
        --  [1] arg23 (copy)

        arg23:_UpdateVisibilities()
    end)
    arg23._local_fighter.ItemAdded:Connect(function() -- line: 304
        -- upvalues:
        --  [1] arg23 (copy)

        arg23:_UpdateWeaponIcons()
    end)
    arg23._local_fighter.ItemRemoved:Connect(function() -- line: 308
        -- upvalues:
        --  [1] arg23 (copy)

        arg23:_UpdateWeaponIcons()
    end)
    arg23:_UpdateWeaponIcons()
end

function t._HookTouchGui(_) -- line: 315
    -- upvalues:
    --  [1] Utility_m (copy)
    --  [2] Players (copy)

    local JumpButton = Utility_m:SilentWaitForChild(
        Players.LocalPlayer:WaitForChild("PlayerGui"),
        "TouchGui"
    ):WaitForChild("TouchControlFrame"):WaitForChild("JumpButton")
    task.defer(JumpButton.Destroy, JumpButton)
end

function t._Init(arg30) -- line: 322
    arg30.MobileInputs.EditorEnabledChanged:Connect(function() -- line: 323
        -- upvalues:
        --  [1] arg30 (copy)

        arg30:_UpdateVisibilities()
        arg30:_UpdateWeaponIcons()
    end)
    task.defer(arg30._HookTouchGui, arg30)
end

return t
