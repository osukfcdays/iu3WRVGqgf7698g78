local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")
local TweenService = game:GetService("TweenService")
local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")
local Signal_m = require(ReplicatedStorage.Modules.Signal)
local SpectateController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.SpectateController
)
local Matchmaking_m = require(
    Players.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("Lobby"):WaitForChild(
        "Matchmaking"
    )
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
local Queue_m = require(
    Players.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("Queue")
)
local Pages_m = require(
    Players.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("Pages")
)
local UILibrary_m = require(Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("UILibrary"))
local BossHealthBar = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("BossHealthBar")
local t = {}
t.__index = t

function t._new() -- line: 23
    -- upvalues:
    --  [1] t (copy)
    --  [2] UILibrary_m (copy)
    --  [3] Signal_m (copy)

    local t_1 = setmetatable({}, t)
    t_1.Frame = UILibrary_m:GetTo("MainFrame", "BossHealth")
    t_1.Container = t_1.Frame:WaitForChild("Container")
    t_1._duel_subject_connections = {}
    t_1._boss_health_bars = {}
    t_1._last_changed_health_bar_frame = nil
    t_1._update_health_bar_internal = Signal_m.new()
    t_1:_Init()

    return t_1
end

function t._UpdateVisibility(arg1) -- line: 49
    -- upvalues:
    --  [1] SpectateController_m (copy)
    --  [2] Pages_m (copy)
    --  [3] Equipment_m (copy)
    --  [4] Queue_m (copy)
    --  [5] Teleporting_m (copy)
    --  [6] MobileInputs_m (copy)
    --  [7] Matchmaking_m (copy)
    --  [8] GuiService (copy)

    local v8 = SpectateController_m.CurrentDuelSubject

    if v8 then
        v8 = SpectateController_m.CurrentDuelSubject.DuelInterface.Voting:IsOpen()
    end

    local v9 = not v8
    local Frame = arg1.Frame

    if v9 then
        v9 = not Pages_m.PageSystem.CurrentPage

        if v9 then
            v9 = not Equipment_m.IsOpen

            if v9 then
                v9 = not Queue_m:IsVisible()

                if v9 then
                    v9 = not Teleporting_m.Enabled

                    if v9 then
                        v9 = not MobileInputs_m.EditorEnabled

                        if v9 then
                            v9 = not Matchmaking_m:IsVisible()

                            if v9 then
                                v9 = not GuiService.MenuIsOpen
                            end
                        end
                    end
                end
            end
        end
    end

    Frame.Visible = v9
end

function t._DuelSubjectChanged(arg2) -- line: 55
    -- upvalues:
    --  [1] SpectateController_m (copy)

    for _, val in pairs(arg2._duel_subject_connections) do
        val:Disconnect()
    end

    arg2._duel_subject_connections = {}
    arg2:_UpdateVisibility()

    if not SpectateController_m.CurrentDuelSubject then
        return
    end

    table.insert(arg2._duel_subject_connections, SpectateController_m.CurrentDuelSubject.DuelInterface.Voting.VisibilityChanged:Connect(
        function() -- line: 67
            -- upvalues:
            --  [1] arg2 (copy)

            arg2:_UpdateVisibility()
        end
    ))
end

function t._HumanoidAdded(arg3, arg4) -- line: 72
    -- upvalues:
    --  [1] BossHealthBar (copy)
    --  [2] Players (copy)
    --  [3] TweenService (copy)

    arg3:_HumanoidRemoved(arg4)
    local t_2 = {}
    local t_3 = {}
    local v10 = BossHealthBar:Clone()
    v10.Parent = arg3.Container

    local function update_name() -- line: 81
        -- upvalues:
        --  [1] v10 (copy)
        --  [2] arg4 (copy)
        --  [3] Players (ref)

        local Title = v10.Title
        local v11 = arg4.Parent and arg4.Parent.Name or ""
        Title.Text = v11
        v11 = not arg4.Parent
        local Title_1 = v10.Title

        if not v11 then
            v11 = not Players:GetPlayerFromCharacter(arg4.Parent)
        end

        Title_1.AutoLocalize = v11
    end

    table.insert(t_2, arg4.Parent:GetPropertyChangedSignal("Name"):Connect(update_name))
    local Title_2 = v10.Title
    local v12 = arg4.Parent and arg4.Parent.Name or ""
    Title_2.Text = v12
    v12 = not arg4.Parent
    local Title_3 = v10.Title

    if not v12 then
        v12 = not Players:GetPlayerFromCharacter(arg4.Parent)
    end

    Title_3.AutoLocalize = v12
    local v13 = false

    local function update_visibility() -- line: 91
        -- upvalues:
        --  [1] v10 (copy)
        --  [2] arg3 (copy)
        --  [3] arg4 (copy)
        --  [4] v13 (ref)
        --  [5] BossHealthBar (ref)

        local v14 = arg3.Frame.Visible
        local v15 = v10
        v14 = v14 and arg4.Health > 0 and arg4.RootPart and (arg4.RootPart.Position - workspace.CurrentCamera.CFrame.Position).Magnitude <= 256
        v15.Visible = v14

        if v10.Visible and not v13 then
            v10.Size = UDim2.new(0, 0, 0, 0)
            v10:TweenSize(
                BossHealthBar.Size,
                "Out",
                "Quint",
                0.5,
                true
            )
        end

        v13 = v10.Visible
    end

    table.insert(t_2, arg3._update_health_bar_internal:Connect(update_visibility))
    table.insert(t_2, arg3.Frame:GetPropertyChangedSignal("Visible"):Connect(update_visibility))
    table.insert(t_3, task.defer(function() -- line: 105
        -- upvalues:
        --  [1] update_visibility (copy)

        while true do
            update_visibility()
            wait(1)
        end
    end))
    local v17 = nil
    local v18 = nil

    local function refresh() -- line: 115
        -- upvalues:
        --  [1] arg3 (copy)
        --  [2] v10 (copy)
        --  [3] arg4 (copy)
        --  [4] v17 (ref)
        --  [5] v18 (ref)
        --  [6] TweenService (ref)
        --  [7] update_visibility (copy)

        arg3._last_changed_health_bar_frame = v10
        arg3._update_health_bar_internal:Fire()
        local Health = arg4.Health
        local clampedValue = math.clamp(Health / arg4.MaxHealth, 0, 1)
        local v19 = Color3.fromRGB(255, 50, 50):Lerp(
            Color3.fromRGB(255, 215, 0):Lerp(Color3.fromRGB(100, 255, 50), clampedValue),
            clampedValue
        )
        local v20 = Color3.new(v19.R / 2, v19.G / 2, v19.B / 2)
        v10.Health.BackgroundColor3 = v20
        v10.Health.UIStroke.Color = v20
        v10.Health.Bar.BackgroundColor3 = v19
        local Bar = v10.Health.Bar
        Bar.Visible = clampedValue > 0 and true
        v10.Health.Bar.UIStroke.Color = v19
        local Title_4 = v10.Health.Bar.Value.Title
        Title_4.Text = Health > 1 and math.ceil(Health) or ""
        v20 = if not v17 then 1 else if not (clampedValue < v17) then 0.5 else 1
        local udim2 = UDim2.new(math.max(0.06, clampedValue), 2, 1, 2)

        if v18 then
            v18:Pause()
        end

        v18 = TweenService:Create(
            v10.Health.Bar,
            TweenInfo.new(0.5 / v20, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
            { Size = udim2 }
        )
        v18:Play()
        v17 = clampedValue
        update_visibility()
    end

    table.insert(t_2, arg4:GetPropertyChangedSignal("MaxHealth"):Connect(refresh))
    table.insert(t_2, arg4:GetPropertyChangedSignal("Health"):Connect(refresh))
    refresh()
    arg3._boss_health_bars[arg4] = { Frame = v10, Connections = t_2, Threads = t_3 }
end

function t._HumanoidRemoved(arg5, arg6) -- line: 159
    local v24 = arg5._boss_health_bars[arg6]

    if not v24 then
        return
    end

    v24.Frame:Destroy()

    for _, val_1 in pairs(v24.Connections) do
        val_1:Disconnect()
    end

    for _, val_2 in pairs(v24.Threads) do
        pcall(task.cancel, val_2)
    end

    arg5._boss_health_bars[arg6] = nil
end

function t._Init(arg7) -- line: 179
    -- upvalues:
    --  [1] Equipment_m (copy)
    --  [2] Pages_m (copy)
    --  [3] Queue_m (copy)
    --  [4] Matchmaking_m (copy)
    --  [5] Teleporting_m (copy)
    --  [6] MobileInputs_m (copy)
    --  [7] GuiService (copy)
    --  [8] SpectateController_m (copy)
    --  [9] CollectionService (copy)

    Equipment_m.Opened:Connect(function() -- line: 180
        -- upvalues:
        --  [1] arg7 (copy)

        arg7:_UpdateVisibility()
    end)
    Pages_m.PageSystem.PageOpened:Connect(function() -- line: 184
        -- upvalues:
        --  [1] arg7 (copy)

        arg7:_UpdateVisibility()
    end)
    Pages_m.PageSystem.PageClosed:Connect(function() -- line: 188
        -- upvalues:
        --  [1] arg7 (copy)

        arg7:_UpdateVisibility()
    end)
    Queue_m.VisibilityChanged:Connect(function() -- line: 192
        -- upvalues:
        --  [1] arg7 (copy)

        arg7:_UpdateVisibility()
    end)
    Matchmaking_m.VisibilityChanged:Connect(function() -- line: 196
        -- upvalues:
        --  [1] arg7 (copy)

        arg7:_UpdateVisibility()
    end)
    Teleporting_m.EnabledChanged:Connect(function() -- line: 200
        -- upvalues:
        --  [1] arg7 (copy)

        arg7:_UpdateVisibility()
    end)
    MobileInputs_m.EditorEnabledChanged:Connect(function() -- line: 204
        -- upvalues:
        --  [1] arg7 (copy)

        arg7:_UpdateVisibility()
    end)
    GuiService:GetPropertyChangedSignal("MenuIsOpen"):Connect(function() -- line: 208
        -- upvalues:
        --  [1] arg7 (copy)

        arg7:_UpdateVisibility()
    end)
    SpectateController_m.DuelSubjectChanged:Connect(function() -- line: 212
        -- upvalues:
        --  [1] arg7 (copy)

        arg7:_DuelSubjectChanged()
    end)
    CollectionService:GetInstanceAddedSignal("BossHealthBar"):Connect(function(arg8) -- line: 216
        -- upvalues:
        --  [1] arg7 (copy)

        arg7:_HumanoidAdded(arg8)
    end)
    CollectionService:GetInstanceRemovedSignal("BossHealthBar"):Connect(function(arg9) -- line: 220
        -- upvalues:
        --  [1] arg7 (copy)

        arg7:_HumanoidRemoved(arg9)
    end)

    for _, val_3 in pairs(CollectionService:GetTagged("BossHealthBar")) do
        task.defer(arg7._HumanoidAdded, arg7, val_3)
    end

    arg7:_UpdateVisibility()
    task.defer(arg7._DuelSubjectChanged, arg7)
end

return t._new()
