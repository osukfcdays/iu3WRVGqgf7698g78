local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")
local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")
local InputLibrary_m = require(ReplicatedStorage.Modules.InputLibrary)
local Signal_m = require(ReplicatedStorage.Modules.Signal)
local _ = require(Players.LocalPlayer.PlayerScripts.Controllers.PlayerDataController)
local ControlsController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.ControlsController
)
local SpectateController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.SpectateController
)
local FighterController_m = require(Players.LocalPlayer.PlayerScripts.Controllers.FighterController)
local MatchmakingCountdown_m = require(
    Players.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("MatchmakingCountdown")
)
local MobileInputs_m = require(
    Players.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("MobileInputs")
)
local Teleporting_m = require(
    Players.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("Teleporting")
)
local Equipment_m = require(
    Players.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("Equipment")
)
local Pages_m = require(
    Players.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("Pages")
)
local Queue_m = require(
    Players.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("Queue")
)
local UILibrary_m = require(Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("UILibrary"))
local Elements_m = require(script:WaitForChild("Elements"))
local Inspect_m = require(script:WaitForChild("Inspect"))
local t = {}
t.__index = t

function t._new() -- line: 29
    -- upvalues:
    --  [1] t (copy)
    --  [2] Signal_m (copy)
    --  [3] UILibrary_m (copy)
    --  [4] Elements_m (copy)
    --  [5] Inspect_m (copy)

    local t_1 = setmetatable({}, t)
    t_1.OpenedChanged = Signal_m.new()
    t_1.ClosedByInputsChanged = Signal_m.new()
    t_1.BaseVisibilityChanged = Signal_m.new()
    t_1.Frame = UILibrary_m:GetTo("PlayerList")
    t_1.Container = t_1.Frame:WaitForChild("Container")
    t_1.IsOpen = nil
    t_1.ClosedByInputs = false
    t_1.Elements = Elements_m.new(t_1)
    t_1.Inspect = Inspect_m.new(t_1)
    t_1._local_fighter = nil
    t_1._opened_connections = {}
    t_1._is_disabled = false
    t_1._scale = 1
    t_1:_Init()

    return t_1
end

function t.GetBaseVisibility(arg1) -- line: 58
    -- upvalues:
    --  [1] MobileInputs_m (copy)
    --  [2] Teleporting_m (copy)
    --  [3] SpectateController_m (copy)
    --  [4] Equipment_m (copy)
    --  [5] Pages_m (copy)
    --  [6] MatchmakingCountdown_m (copy)
    --  [7] GuiService (copy)
    --  [8] Queue_m (copy)

    local v10 = not MobileInputs_m.EditorEnabled

    if v10 then
        v10 = not Teleporting_m.Enabled

        if v10 then
            v10 = not SpectateController_m.CurrentDuelSubject

            if v10 then
                v10 = not Equipment_m.IsOpen

                if v10 then
                    v10 = not Pages_m.PageSystem.CurrentPage

                    if v10 then
                        v10 = not MatchmakingCountdown_m:IsVisible()

                        if v10 then
                            v10 = not GuiService.MenuIsOpen

                            if v10 then
                                v10 = not Queue_m:IsVisible()

                                if v10 then
                                    local v11 = arg1._local_fighter

                                    if v11 then
                                        v11 = arg1._local_fighter:Get("IsInShootingRange")
                                    end

                                    v10 = not v11
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    return v10
end

function t.SetDisabled(arg2, arg3) -- line: 70
    if arg3 == arg2._is_disabled then
        return
    end

    arg2._is_disabled = arg3
    arg2:_UpdateVisibility()
end

function t.SetScale(arg4, arg5) -- line: 79
    arg4._scale = arg5
    arg4.Container.Size = UDim2.new(arg4._scale, 0, arg4._scale, 0)
    arg4:_UpdateSize()
    arg4.Inspect:SetScale(arg5)
end

function t.SetClosedByInputs(arg6, arg7) -- line: 86
    arg6.ClosedByInputs = arg7
    arg6.ClosedByInputsChanged:Fire()
end

function t.SetIsFriend(arg8, arg9, arg10) -- line: 91
    for key, val in pairs(arg8.Elements.PlayerListSlots) do
        if key.Player == arg9 then
            val:SetIsFriend(arg10)
        end
    end
end

function t.SetIsBlocked(arg11, arg12, arg13) -- line: 99
    for key_1, val_1 in pairs(arg11.Elements.PlayerListSlots) do
        if key_1.Player == arg12 then
            val_1:SetIsBlocked(arg13)
        end
    end
end

function t.SetRequestDuration(arg14, arg15, ...) -- line: 107
    local v12 = arg14.Elements:GetPlayerListSlot(arg15)

    if v12 then
        v12:SetRequestDuration(...)
    end
end

function t.SelectPlayerExternally(arg16, arg17) -- line: 115
    arg16.Inspect:SelectPlayer(arg16.Elements:GetPlayerListSlot(arg17))
end

function t.OnOpened(arg18) -- line: 119
    -- upvalues:
    --  [1] GuiService (copy)

    local AbsoluteSize = arg18.Frame.Parent:GetPropertyChangedSignal("AbsoluteSize")
    arg18:AddOpenedConnection(AbsoluteSize:Connect(function() -- line: 120
        -- upvalues:
        --  [1] arg18 (copy)

        arg18:_UpdateSize()
    end))
    local TopbarInset = GuiService:GetPropertyChangedSignal("TopbarInset")
    arg18:AddOpenedConnection(TopbarInset:Connect(function() -- line: 124
        -- upvalues:
        --  [1] arg18 (copy)

        arg18:_UpdatePosition()
    end))
    arg18:_UpdateSize()
    arg18:_UpdatePosition()
    arg18.Elements:OnOpened()
    arg18.Inspect:OnOpened()
end

function t.AddOpenedConnection(arg19, arg20) -- line: 136
    table.insert(arg19._opened_connections, arg20)
end

function t._IsVisibleRegardlessOfInputs(arg21) -- line: 144
    local v13 = arg21:GetBaseVisibility()

    if v13 then
        v13 = not arg21._is_disabled
    end

    return v13
end

function t._UpdateSize(arg22) -- line: 148
    arg22.Frame.Size = UDim2.new(
        0,
        math.min(320, arg22.Frame.Parent.AbsoluteSize.X * 0.5),
        0.5 * arg22._scale,
        0
    )
end

function t._UpdatePosition(arg23) -- line: 152
    -- upvalues:
    --  [1] GuiService (copy)

    arg23.Container.Position = UDim2.new(1, 0, 0, GuiService.TopbarInset.Height)
end

function t._UpdateVisibility(arg24) -- line: 156
    arg24.BaseVisibilityChanged:Fire()
    local v14 = arg24:_IsVisibleRegardlessOfInputs()

    if v14 then
        v14 = not arg24.ClosedByInputs
    end

    if v14 == arg24.IsOpen then
        return
    end

    arg24.IsOpen = v14
    arg24.OpenedChanged:Fire()
    local task_defer = task.defer
    local TweenPosition = arg24.Frame.TweenPosition
    task_defer(
        TweenPosition,
        arg24.Frame,
        arg24.IsOpen and UDim2.new(1, -10, 0, 10) or UDim2.new(1, 650, 0, 10),
        "Out",
        "Quint",
        0.25,
        true
    )

    if arg24.IsOpen then
        arg24:OnOpened()

        return
    end

    for _, val_2 in pairs(arg24._opened_connections) do
        val_2:Disconnect()
    end

    arg24._opened_connections = {}
end

function t._HookGetCore(_, arg26, arg27) -- line: 180
    -- upvalues:
    --  [1] StarterGui (copy)

    task.spawn(function() -- line: 181
        -- upvalues:
        --  [1] StarterGui (ref)
        --  [2] arg26 (copy)
        --  [3] arg27 (copy)

        local v16 = nil

        while not v16 do
            local Success, Result = pcall(StarterGui.GetCore, StarterGui, arg26)

            if Success then
                v16 = Result
                break
            end

            wait(1)
        end

        v16.Event:Connect(arg27)
    end)
end

function t._HookLocalFighter(arg28) -- line: 199
    -- upvalues:
    --  [1] FighterController_m (copy)

    arg28._local_fighter = FighterController_m:WaitForLocalFighter()
    arg28._local_fighter:GetDataChangedSignal("IsInShootingRange"):Connect(function() -- line: 202
        -- upvalues:
        --  [1] arg28 (copy)

        arg28:_UpdateVisibility()
    end)
    arg28:_UpdateVisibility()
end

function t._Init(arg29) -- line: 209
    -- upvalues:
    --  [1] ControlsController_m (copy)
    --  [2] SpectateController_m (copy)
    --  [3] Equipment_m (copy)
    --  [4] Pages_m (copy)
    --  [5] Teleporting_m (copy)
    --  [6] MobileInputs_m (copy)
    --  [7] MatchmakingCountdown_m (copy)
    --  [8] GuiService (copy)
    --  [9] Queue_m (copy)
    --  [10] UserInputService (copy)
    --  [11] InputLibrary_m (copy)

    arg29.ClosedByInputsChanged:Connect(function() -- line: 210
        -- upvalues:
        --  [1] arg29 (copy)

        arg29:_UpdateVisibility()
    end)
    arg29:_HookGetCore("PlayerFriendedEvent", function(arg30) -- line: 214
        -- upvalues:
        --  [1] arg29 (copy)

        arg29:SetIsFriend(arg30, true)
    end)
    arg29:_HookGetCore("PlayerUnfriendedEvent", function(arg31) -- line: 218
        -- upvalues:
        --  [1] arg29 (copy)

        arg29:SetIsFriend(arg31, false)
    end)
    arg29:_HookGetCore("PlayerBlockedEvent", function(arg32) -- line: 222
        -- upvalues:
        --  [1] arg29 (copy)

        arg29:SetIsBlocked(arg32, true)
    end)
    arg29:_HookGetCore("PlayerUnblockedEvent", function(arg33) -- line: 226
        -- upvalues:
        --  [1] arg29 (copy)

        arg29:SetIsBlocked(arg33, false)
    end)
    ControlsController_m.ControlsChanged:Connect(function() -- line: 230
        -- upvalues:
        --  [1] arg29 (copy)

        arg29:_UpdateVisibility()
    end)
    SpectateController_m.DuelSubjectChanged:Connect(function() -- line: 234
        -- upvalues:
        --  [1] arg29 (copy)

        arg29:_UpdateVisibility()
    end)
    Equipment_m.Opened:Connect(function() -- line: 238
        -- upvalues:
        --  [1] arg29 (copy)

        arg29:_UpdateVisibility()
    end)
    Pages_m.PageSystem.PagesActivity:Connect(function() -- line: 242
        -- upvalues:
        --  [1] arg29 (copy)

        arg29:_UpdateVisibility()
    end)
    Teleporting_m.EnabledChanged:Connect(function() -- line: 246
        -- upvalues:
        --  [1] arg29 (copy)

        arg29:_UpdateVisibility()
    end)
    MobileInputs_m.EditorEnabledChanged:Connect(function() -- line: 250
        -- upvalues:
        --  [1] arg29 (copy)

        arg29:_UpdateVisibility()
    end)
    MatchmakingCountdown_m.VisibilityChanged:Connect(function() -- line: 254
        -- upvalues:
        --  [1] arg29 (copy)

        arg29:_UpdateVisibility()
    end)
    GuiService:GetPropertyChangedSignal("MenuIsOpen"):Connect(function() -- line: 258
        -- upvalues:
        --  [1] arg29 (copy)

        arg29:_UpdateVisibility()
    end)
    Queue_m.VisibilityChanged:Connect(function() -- line: 262
        -- upvalues:
        --  [1] arg29 (copy)

        arg29:_UpdateVisibility()
    end)
    UserInputService.InputBegan:Connect(function(input: InputObject, gameProcessedEvent: boolean) -- line: 266
        -- upvalues:
        --  [1] arg29 (copy)
        --  [2] InputLibrary_m (ref)
        --  [3] UserInputService (ref)

        if
            not gameProcessedEvent
            and arg29:_IsVisibleRegardlessOfInputs()
            and InputLibrary_m:InputIs(input, "OpenPlayerList")
            and not UserInputService:IsKeyDown(Enum.KeyCode.LeftAlt)
        then
            arg29:SetClosedByInputs(not arg29.ClosedByInputs)
        end
    end)
    arg29:_UpdateSize()
    arg29:_UpdatePosition()
    arg29:_UpdateVisibility()
    task.defer(arg29._HookLocalFighter, arg29)
end

return t._new()
