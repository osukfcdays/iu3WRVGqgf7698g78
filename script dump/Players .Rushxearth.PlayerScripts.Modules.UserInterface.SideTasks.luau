local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GuiService = game:GetService("GuiService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CONSTANTS_m = require(ReplicatedStorage.Modules.CONSTANTS)
local StatisticsLibrary_m = require(ReplicatedStorage.Modules.StatisticsLibrary)
local ContractsLibrary_m = require(ReplicatedStorage.Modules.ContractsLibrary)
local TaskLibrary_m = require(ReplicatedStorage.Modules.TaskLibrary)
local ItemLibrary_m = require(ReplicatedStorage.Modules.ItemLibrary)
local Spring_m = require(ReplicatedStorage.Modules.Spring)
local ShootingRangeController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("ShootingRangeController")
)
local PlayerDataController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("PlayerDataController")
)
local SpectateController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("SpectateController")
)
local FighterController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("FighterController")
)
local LobbyController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("LobbyController")
)
local TimerController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("TimerController")
)
local WeaponStatusHandler_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("WeaponStatusHandler")
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
local ButtonEffect_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("ButtonEffect")
)
local RewardSlot_m = require(Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("RewardSlot"))
local UILibrary_m = require(Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("UILibrary"))
local SideContractSlot = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild(
    "SideContractSlot"
)
local SideTaskSlot = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("SideTaskSlot")
local udim2 = UDim2.new(-1, -10, 0.5, 0)
local udim2_1 = UDim2.new(0, 10, 0.5, 0)
local udim2_2 = UDim2.new(0.25, 90, 0.208, 75)
local t = {}
t.__index = t

function t._new() -- line: 40
    -- upvalues:
    --  [1] t (copy)
    --  [2] UILibrary_m (copy)

    local t_1 = setmetatable({}, t)
    t_1.Frame = UILibrary_m:GetTo("MainFrame", "SideTasks")
    t_1._local_fighter = nil
    t_1._side_slots = {}
    t_1._duel_connections = {}
    t_1._teleport_cooldown = 0
    t_1._generate_queued = false
    t_1._center_alert_hash = 0
    t_1._center_alert_connection = nil
    t_1._is_open = false
    t_1:_Init()

    return t_1
end

function t._PlayCenterAlertEffect(arg1) -- line: 69
    -- upvalues:
    --  [1] Pages_m (copy)
    --  [2] PlayerDataController_m (copy)
    --  [3] TaskLibrary_m (copy)
    --  [4] Spring_m (copy)
    --  [5] RunService (copy)
    --  [6] udim2_1 (copy)
    --  [7] udim2 (copy)
    --  [8] udim2_2 (copy)

    local v16 = arg1._local_fighter

    if v16 then
        v16 = arg1._local_fighter:Get("IsInShootingRange")

        if v16 then
            v16 = not Pages_m.PageSystem.CurrentPage

            if v16 then
                v16 = PlayerDataController_m:Get("BeginnerTasksCompleted") < TaskLibrary_m.NUM_BEGINNER_TASKS and true
            end
        end
    end

    if not v16 then
        return
    end

    if arg1._center_alert_connection then
        arg1._center_alert_connection:Disconnect()
        arg1._center_alert_connection = nil
    end

    arg1._center_alert_hash += 1
    v16 = arg1._center_alert_hash
    local v18 = Spring_m.new(0, 1, 10)
    arg1._center_alert_connection = RunService.RenderStepped:Connect(function() -- line: 86
        -- upvalues:
        --  [1] arg1 (copy)
        --  [2] v16 (copy)
        --  [3] v18 (copy)
        --  [4] udim2_1 (ref)
        --  [5] udim2 (ref)

        if arg1._center_alert_hash ~= v16 then
            return
        end

        local Value = v18.Value
        local v20 = arg1.Frame.Parent.AbsolutePosition + arg1.Frame.Parent.AbsoluteSize / 2 - arg1.Frame.Container.AbsoluteSize.X * Vector2.new(
            0.5,
            0
        ) - arg1.Frame.AbsolutePosition
        local udim2_3 = UDim2.new(0, v20.X, 0, v20.Y)
        local udim2_4 = UDim2.new(
            udim2_1.X.Scale + (udim2_3.X.Scale - udim2_1.X.Scale) * Value,
            udim2_1.X.Offset + (udim2_3.X.Offset - udim2_1.X.Offset) * Value,
            udim2_1.Y.Scale + (udim2_3.Y.Scale - udim2_1.Y.Scale) * Value,
            udim2_1.Y.Offset + (udim2_3.Y.Offset - udim2_1.Y.Offset) * Value
        )
        arg1.Frame.Container:TweenPosition(
            if not arg1._is_open then udim2 else udim2_4,
            "InOut",
            "Linear",
            0,
            true
        )
        arg1.Frame.Container.Background.UIGradient.Transparency = NumberSequence.new(0, 1 - Value)
    end)
    v18.Target = 1
    arg1.Frame.Container.Size = udim2_2
    arg1.Frame.Container:TweenSize(
        UDim2.new(
            udim2_2.X.Scale * 1.25,
            udim2_2.X.Offset * 1.25,
            udim2_2.Y.Scale * 1.25,
            udim2_2.Y.Offset * 1.25
        ),
        "InOut",
        "Quint",
        0.75,
        true
    )

    for _ = 1, 5 do
        wait(0.06)

        if arg1._center_alert_hash ~= v16 then
            return
        end

        arg1.Frame.Container.Visible = true
        wait(0.12)

        if arg1._center_alert_hash ~= v16 then
            return
        end
    end

    wait(2)

    if arg1._center_alert_hash ~= v16 then
        return
    end

    v18.Target = 0
    arg1.Frame.Container:TweenSize(
        udim2_2,
        "Out",
        "Quint",
        0.5,
        true
    )
    wait(2)

    if arg1._center_alert_hash ~= v16 then
        return
    end

    arg1._center_alert_connection:Disconnect()
    arg1._center_alert_connection = nil
    arg1.Frame.Container.Position = if arg1._is_open then udim2_1 else udim2
    arg1.Frame.Container.Background.UIGradient.Transparency = NumberSequence.new(0, 1)
end

function t._UpdateBackground(arg2) -- line: 149
    arg2.Frame.Container.Background.Size = UDim2.new(
        1,
        0,
        0,
        arg2.Frame.Container.Slots.BackgroundEnd.AbsolutePosition.Y - arg2.Frame.Container.Slots.AbsolutePosition.Y
    )
end

function t._Generate(arg3) -- line: 153
    -- upvalues:
    --  [1] WeaponStatusHandler_m (copy)
    --  [2] PlayerDataController_m (copy)
    --  [3] TaskLibrary_m (copy)
    --  [4] Pages_m (copy)
    --  [5] Equipment_m (copy)
    --  [6] Queue_m (copy)
    --  [7] Teleporting_m (copy)
    --  [8] MobileInputs_m (copy)
    --  [9] GuiService (copy)
    --  [10] SpectateController_m (copy)
    --  [11] ContractsLibrary_m (copy)
    --  [12] CONSTANTS_m (copy)
    --  [13] ItemLibrary_m (copy)
    --  [14] SideTaskSlot (copy)
    --  [15] UILibrary_m (copy)
    --  [16] RewardSlot_m (copy)
    --  [17] StatisticsLibrary_m (copy)
    --  [18] SideContractSlot (copy)
    --  [19] TimerController_m (copy)
    --  [20] udim2_1 (copy)
    --  [21] udim2 (copy)

    for _, val in pairs(arg3._side_slots) do
        val:Destroy()
    end

    arg3._side_slots = {}
    WeaponStatusHandler_m:ClearStatusElements(arg3.Frame.Container.Slots.Header.Title)
    arg3._generate_cooldown = tick() + 0.2
    local StatisticFavoriteWeapon = PlayerDataController_m:GetStatistic("StatisticFavoriteWeapon")
    local v24 = arg3._local_fighter and arg3._local_fighter.EquippedItem and arg3._local_fighter.EquippedItem.Name or (if StatisticFavoriteWeapon == "N/A" then "Assault Rifle" else StatisticFavoriteWeapon or "Assault Rifle")
    local v25 = PlayerDataController_m:Get("BeginnerTasksCompleted")
    local v26 = v25 >= TaskLibrary_m.NUM_BEGINNER_TASKS and true
    local v27 = arg3._local_fighter

    if v27 then
        v27 = not Pages_m.PageSystem.CurrentPage

        if v27 then
            v27 = not Equipment_m.IsOpen

            if v27 then
                v27 = not Queue_m:IsVisible()

                if v27 then
                    v27 = not Teleporting_m.Enabled

                    if v27 then
                        v27 = not MobileInputs_m.EditorEnabled

                        if v27 then
                            v27 = not GuiService.MenuIsOpen

                            if v27 then
                                if PlayerDataController_m:GetSetting("Hide Tasks In Duels") then
                                    if SpectateController_m.CurrentDuelSubject then
                                        v27 = false

                                        if SpectateController_m.CurrentDuelSubject:Get("Status") == "RoundStarting" then
                                            if SpectateController_m.CurrentDuelSubject then
                                                v27 = SpectateController_m.CurrentDuelSubject.LocalDueler

                                                if v27 then
                                                    v27 = false

                                                    if SpectateController_m.CurrentDuelSubject:Get(
                                                        "Status"
                                                    ) ~= "GameOver" then
                                                        v27 = not SpectateController_m.CurrentDuelSubject.DuelInterface.Voting:IsOpen()

                                                        if v27 then
                                                            v27 = not SpectateController_m.CurrentDuelSubject.DuelInterface.Scoreboard:IsOpen()

                                                            if v27 then
                                                                v27 = not SpectateController_m.CurrentDuelSubject:Get(
                                                                    "HideMostDuelInterfaceElements"
                                                                )

                                                                if v27 then
                                                                    v27 = not PlayerDataController_m:GetSetting(
                                                                        "Hide HUD"
                                                                    )

                                                                    if v27 then
                                                                        v27 = true

                                                                        if not (PlayerDataController_m:GetStatistic(
                                                                            "StatisticDuelsPlayed"
                                                                        ) >= 2) then
                                                                            v27 = arg3._local_fighter

                                                                            if v27 then
                                                                                v27 = arg3._local_fighter:Get(
                                                                                    "IsInShootingRange"
                                                                                )
                                                                            end
                                                                        end
                                                                    end
                                                                end
                                                            end
                                                        end
                                                    end
                                                end
                                            else
                                                v27 = not PlayerDataController_m:GetSetting(
                                                    "Hide HUD"
                                                )

                                                if v27 then
                                                    v27 = true

                                                    if not (PlayerDataController_m:GetStatistic(
                                                        "StatisticDuelsPlayed"
                                                    ) >= 2) then
                                                        v27 = arg3._local_fighter

                                                        if v27 then
                                                            v27 = arg3._local_fighter:Get(
                                                                "IsInShootingRange"
                                                            )
                                                        end
                                                    end
                                                end
                                            end
                                        end
                                    elseif SpectateController_m.CurrentDuelSubject then
                                        v27 = SpectateController_m.CurrentDuelSubject.LocalDueler

                                        if v27 then
                                            v27 = false

                                            if SpectateController_m.CurrentDuelSubject:Get("Status") ~= "GameOver" then
                                                v27 = not SpectateController_m.CurrentDuelSubject.DuelInterface.Voting:IsOpen()

                                                if v27 then
                                                    v27 = not SpectateController_m.CurrentDuelSubject.DuelInterface.Scoreboard:IsOpen()

                                                    if v27 then
                                                        v27 = not SpectateController_m.CurrentDuelSubject:Get(
                                                            "HideMostDuelInterfaceElements"
                                                        )

                                                        if v27 then
                                                            v27 = not PlayerDataController_m:GetSetting(
                                                                "Hide HUD"
                                                            )

                                                            if v27 then
                                                                v27 = true

                                                                if not (PlayerDataController_m:GetStatistic(
                                                                    "StatisticDuelsPlayed"
                                                                ) >= 2) then
                                                                    v27 = arg3._local_fighter

                                                                    if v27 then
                                                                        v27 = arg3._local_fighter:Get(
                                                                            "IsInShootingRange"
                                                                        )
                                                                    end
                                                                end
                                                            end
                                                        end
                                                    end
                                                end
                                            end
                                        end
                                    else
                                        v27 = not PlayerDataController_m:GetSetting("Hide HUD")

                                        if v27 then
                                            v27 = true

                                            if not (PlayerDataController_m:GetStatistic(
                                                "StatisticDuelsPlayed"
                                            ) >= 2) then
                                                v27 = arg3._local_fighter

                                                if v27 then
                                                    v27 = arg3._local_fighter:Get(
                                                        "IsInShootingRange"
                                                    )
                                                end
                                            end
                                        end
                                    end
                                elseif SpectateController_m.CurrentDuelSubject then
                                    v27 = SpectateController_m.CurrentDuelSubject.LocalDueler

                                    if v27 then
                                        v27 = false

                                        if SpectateController_m.CurrentDuelSubject:Get("Status") ~= "GameOver" then
                                            v27 = not SpectateController_m.CurrentDuelSubject.DuelInterface.Voting:IsOpen()

                                            if v27 then
                                                v27 = not SpectateController_m.CurrentDuelSubject.DuelInterface.Scoreboard:IsOpen()

                                                if v27 then
                                                    v27 = not SpectateController_m.CurrentDuelSubject:Get(
                                                        "HideMostDuelInterfaceElements"
                                                    )

                                                    if v27 then
                                                        v27 = not PlayerDataController_m:GetSetting(
                                                            "Hide HUD"
                                                        )

                                                        if v27 then
                                                            v27 = true

                                                            if not (PlayerDataController_m:GetStatistic(
                                                                "StatisticDuelsPlayed"
                                                            ) >= 2) then
                                                                v27 = arg3._local_fighter

                                                                if v27 then
                                                                    v27 = arg3._local_fighter:Get(
                                                                        "IsInShootingRange"
                                                                    )
                                                                end
                                                            end
                                                        end
                                                    end
                                                end
                                            end
                                        end
                                    end
                                else
                                    v27 = not PlayerDataController_m:GetSetting("Hide HUD")

                                    if v27 then
                                        v27 = true

                                        if not (PlayerDataController_m:GetStatistic(
                                            "StatisticDuelsPlayed"
                                        ) >= 2) then
                                            v27 = arg3._local_fighter

                                            if v27 then
                                                v27 = arg3._local_fighter:Get("IsInShootingRange")
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    local v28 = v27

    if v28 then
        v28 = if PlayerDataController_m:Get("TasksInterfaceOverride") == nil then false else true
    end

    local v29 = not v28

    if v29 then
        v29 = v27

        if v29 then
            v29 = not PlayerDataController_m:AreTasksCompleted()
        end
    end

    local v30 = not v28

    if v30 then
        v30 = not v29

        if v30 then
            v30 = v27

            if v30 then
                v30 = #ContractsLibrary_m:GetWeaponContracts(v24) > 0 and true
            end
        end
    end

    local v31 = v28 or v29 or v30
    arg3._is_open = v31
    v27 = CONSTANTS_m.SHOOTING_RANGE_ACTIVE and v29 and v25 <= TaskLibrary_m.NUM_BEGINNER_TASKS - 2
    local v32 = CONSTANTS_m.QUEUES_ACTIVE and not v28 and not v27
    local ToShootingRange = arg3.Frame.Container.Slots.ToShootingRange
    local v33 = v27

    if v33 then
        v33 = arg3._local_fighter

        if v33 then
            v33 = not arg3._local_fighter:Get("IsInShootingRange")

            if v33 then
                v33 = not SpectateController_m.CurrentDuelSubject
            end
        end
    end

    ToShootingRange.Visible = v33
    local ToDuels = arg3.Frame.Container.Slots.ToDuels
    v33 = v32

    if v33 then
        v33 = not SpectateController_m.CurrentDuelSubject
    end

    ToDuels.Visible = v33
    local ButtonsBuffer = arg3.Frame.Container.Slots.ButtonsBuffer
    v33 = arg3.Frame.Container.Slots.ToShootingRange.Visible or arg3.Frame.Container.Slots.ToDuels.Visible
    ButtonsBuffer.Visible = v33
    local Title = arg3.Frame.Container.Slots.Header.Title

    if v28 then
        v33 = "Special Mission"
    elseif v30 then
        v33 = v24

        if not v33 then
            v33 = if v29 then if v26 then "Daily Tasks" else "Beginner Tasks   [" .. v25 + 1 .. " / " .. TaskLibrary_m.NUM_BEGINNER_TASKS .. "]" or "" else ""
        end
    else
        v33 = if v29 then if v26 then "Daily Tasks" else "Beginner Tasks   [" .. v25 + 1 .. " / " .. TaskLibrary_m.NUM_BEGINNER_TASKS .. "]" or "" else ""
    end

    Title.Text = v33
    local Icon = arg3.Frame.Container.Slots.Header.Title.Icon
    v33 = v30 and ItemLibrary_m.ViewModels[v24].Image or "rbxassetid://17653923757"
    Icon.Image = v33
    local Icon_1 = arg3.Frame.Container.Slots.Header.Title.Icon
    v33 = v30 and UDim2.new(6, 0, 4.5, 0) or UDim2.new(2, 0, 1.5, 0)
    Icon_1.Size = v33

    if not v28 and v30 then
        WeaponStatusHandler_m:ApplyItemStatusToText(
            arg3.Frame.Container.Slots.Header.Title,
            ItemLibrary_m.Items[v24].Status
        )
    end

    function v32(arg4, arg5) --[[ create_task_slot ]] -- line: 197
        -- upvalues:
        --  [1] TaskLibrary_m (ref)
        --  [2] SideTaskSlot (ref)
        --  [3] arg3 (copy)
        --  [4] UILibrary_m (ref)
        --  [5] RewardSlot_m (ref)

        local v34 = arg5.TaskInfo or TaskLibrary_m.Info[arg5.Name]
        local v35 = arg5.Goal or v34.Goal
        local v36 = v35 <= arg5.Progress and true
        local v37 = SideTaskSlot:Clone()
        v37.LayoutOrder = arg4
        v37.Container.Progress.Bar.Size = UDim2.new(math.clamp(arg5.Progress / v35, 0, 1), 0, 1, 2)
        local Bar_1 = v37.Container.Progress.Bar
        Bar_1.BackgroundColor3 = v36 and Color3.fromRGB(100, 255, 50) or Color3.fromRGB(0, 190, 255)
        v37.Container.TitleContainer.Title.Text = v34.Title
        v37.Container.Goal.Text = string.format(
            "%s <font size=\"8\">/ %s</font>",
            arg5.Progress,
            v35
        )
        v37.Container.Goal.Visible = not v36
        v37.Container.Icon.Image = v34.Icon
        v37.Completed.Visible = v36
        v37.Parent = arg3.Frame.Container.Slots
        table.insert(arg3._side_slots, v37)
        UILibrary_m:ScrollingTextLabel(
            v37.Container.TitleContainer,
            v37.Container.TitleContainer.Title,
            v37.Container.Goal
        )

        if not v36 then
            local v39 = pairs
            local v40 = arg5.BonusRewards or {}

            for _, val_1 in v39({ v34.Rewards, v40 }) do
                for _, val_2 in pairs(val_1) do
                    v35 = RewardSlot_m.new(val_2)
                    v35:SetBubbleAutoCloseDelay(3)
                    v35:SetParent(v37.Reward)
                end
            end
        end
    end

    if v28 then
        for key_3, val_3 in pairs(PlayerDataController_m:Get("TasksInterfaceOverride")) do
            v32(key_3, val_3)
        end
    end

    if v29 then
        for key_4, val_4 in pairs(PlayerDataController_m:Get("Tasks")) do
            v32(key_4, val_4)
        end
    end

    v32 = false

    if v30 then
        v32 = true

        for key_5, val_5 in pairs(ContractsLibrary_m:GetWeaponContracts(v24)) do
            v28 = ContractsLibrary_m.Contracts[val_5]
            v27 = StatisticsLibrary_m.Info[v28.StatisticName]
            local v44 = PlayerDataController_m:GetWeaponStatistic(
                v28.Identifier,
                v28.StatisticName,
                v28.ExtraStatisticNames
            )

            for _, val_6 in pairs(v28.Milestones) do
                local v45, v46 = table.unpack(val_6)

                if not (v44 >= v45) then
                    v32 = false
                    local v47 = SideContractSlot:Clone()
                    v47.LayoutOrder = key_5
                    v47.Container.Progress.Bar.Size = UDim2.new(
                        math.clamp(v44 / v45, 0, 1),
                        0,
                        1,
                        2
                    )
                    v47.Container.Goal.Text = string.format(
                        "%s <font size=\"8\">/ %s</font>",
                        v27.TostringFunction(v44),
                        v27.TostringFunction(v45)
                    )
                    v47.Container.TitleContainer.Title.Text = v28.FullDisplayName
                    v47.Parent = arg3.Frame.Container.Slots
                    table.insert(arg3._side_slots, v47)
                    UILibrary_m:ScrollingTextLabel(
                        v47.Container.TitleContainer,
                        v47.Container.TitleContainer.Title,
                        v47.Container.Goal
                    )

                    if not v46 then
                        break
                    end

                    local v49 = RewardSlot_m.new(v46)
                    v49:SetBubbleAutoCloseDelay(3)
                    v49.Frame.Parent = v47.Reward
                    break
                end
            end
        end
    end

    arg3.Frame.Container.Slots.ContractsCompleted.Visible = v32
    arg3.Frame.Container.Slots.ContractsCompleted.Title.Text = "Congratulations! You've completed every " .. v24 .. " contract!"
    TimerController_m:OnStep("LobbyTasks", "TaskRefresh", if not v29 or not v26 or not PlayerDataController_m:AreTasksCompleted() then nil else function(
        _,
        arg7
    ) -- line: 284
        -- upvalues:
        --  [1] arg3 (copy)

        arg3.Frame.Container.Slots.Header.Title.Text = "New tasks in " .. arg7
    end)
    local Container_3 = arg3.Frame.Container
    Container_3:TweenPosition(
        if arg3._is_open then udim2_1 else udim2,
        "Out",
        "Quint",
        if not arg3._is_open then 1.25 else 0.25,
        true
    )
    arg3:_UpdateBackground()
end

function t._GenerateThrottled(arg8) -- line: 292
    if tick() > arg8._generate_cooldown then
        arg8:_Generate()

        return
    end

    if arg8._generate_queued then
        return
    end

    arg8._generate_queued = true
    task.delay(arg8._generate_cooldown - tick(), function() -- line: 304
        -- upvalues:
        --  [1] arg8 (copy)

        arg8._generate_queued = false
        arg8:_Generate()
    end)
end

function t._UpdateCurrentDuelSubject(arg9) -- line: 310
    -- upvalues:
    --  [1] SpectateController_m (copy)

    for _, val_7 in pairs(arg9._duel_connections) do
        val_7:Disconnect()
    end

    arg9._duel_connections = {}

    if not SpectateController_m.CurrentDuelSubject then
        arg9:_Generate()

        return
    end

    table.insert(arg9._duel_connections, SpectateController_m.CurrentDuelSubject:GetDataChangedSignal(
        "Status"
    ):Connect(function() -- line: 322
        -- upvalues:
        --  [1] arg9 (copy)

        arg9:_Generate()
    end))
    table.insert(arg9._duel_connections, SpectateController_m.CurrentDuelSubject:GetDataChangedSignal(
        "HideMostDuelInterfaceElements"
    ):Connect(function() -- line: 326
        -- upvalues:
        --  [1] arg9 (copy)

        arg9:_Generate()
    end))
    table.insert(arg9._duel_connections, SpectateController_m.CurrentDuelSubject.DuelInterface.Voting.VisibilityChanged:Connect(
        function() -- line: 330
            -- upvalues:
            --  [1] arg9 (copy)

            arg9:_Generate()
        end
    ))
    table.insert(arg9._duel_connections, SpectateController_m.CurrentDuelSubject.DuelInterface.Scoreboard.VisibilityChanged:Connect(
        function() -- line: 334
            -- upvalues:
            --  [1] arg9 (copy)

            arg9:_Generate()
        end
    ))
    arg9:_Generate()
end

function t._HookLocalFighter(arg10) -- line: 341
    -- upvalues:
    --  [1] FighterController_m (copy)

    arg10._local_fighter = FighterController_m:WaitForLocalFighter()
    arg10._local_fighter:GetDataChangedSignal("IsInShootingRange"):Connect(function() -- line: 344
        -- upvalues:
        --  [1] arg10 (copy)

        arg10:_Generate()
        arg10:_PlayCenterAlertEffect()
    end)
    arg10._local_fighter:GetDataChangedSignal("IsInDuel"):Connect(function() -- line: 349
        -- upvalues:
        --  [1] arg10 (copy)

        arg10:_Generate()
    end)
    arg10._local_fighter.EquippedItemChanged:Connect(function() -- line: 353
        -- upvalues:
        --  [1] arg10 (copy)

        arg10:_GenerateThrottled()
    end)
    arg10:_Generate()
    arg10:_PlayCenterAlertEffect()
end

function t._Init(arg11) -- line: 361
    -- upvalues:
    --  [1] ShootingRangeController_m (copy)
    --  [2] LobbyController_m (copy)
    --  [3] PlayerDataController_m (copy)
    --  [4] Equipment_m (copy)
    --  [5] Pages_m (copy)
    --  [6] Queue_m (copy)
    --  [7] Teleporting_m (copy)
    --  [8] MobileInputs_m (copy)
    --  [9] SpectateController_m (copy)
    --  [10] GuiService (copy)
    --  [11] ButtonEffect_m (copy)

    arg11.Frame.Container.Slots.ToShootingRange.Button.MouseButton1Click:Connect(function() -- line: 362
        -- upvalues:
        --  [1] arg11 (copy)
        --  [2] ShootingRangeController_m (ref)

        if tick() < arg11._teleport_cooldown then
            return
        end

        arg11._teleport_cooldown = tick() + 1
        ShootingRangeController_m:Enter(true)
    end)
    arg11.Frame.Container.Slots.ToDuels.Button.MouseButton1Click:Connect(function() -- line: 371
        -- upvalues:
        --  [1] arg11 (copy)
        --  [2] LobbyController_m (ref)

        if tick() < arg11._teleport_cooldown then
            return
        end

        arg11._teleport_cooldown = tick() + 1
        LobbyController_m:ToDuels()
    end)
    arg11.Frame.Container.Slots:GetPropertyChangedSignal("AbsolutePosition"):Connect(function() -- line: 380
        -- upvalues:
        --  [1] arg11 (copy)

        arg11:_UpdateBackground()
    end)
    arg11.Frame.Container.Slots.BackgroundEnd:GetPropertyChangedSignal("AbsolutePosition"):Connect(
        function() -- line: 384
            -- upvalues:
            --  [1] arg11 (copy)

            arg11:_UpdateBackground()
        end
    )
    PlayerDataController_m:GetDataChangedSignal("BeginnerTasksCompleted"):Connect(function() -- line: 388
        -- upvalues:
        --  [1] arg11 (copy)

        arg11:_Generate()
        arg11:_PlayCenterAlertEffect()
    end)
    PlayerDataController_m:GetDataChangedSignal("Tasks"):Connect(function() -- line: 393
        -- upvalues:
        --  [1] arg11 (copy)

        arg11:_Generate()
    end)
    PlayerDataController_m:GetSettingChangedSignal("Hide Tasks In Duels"):Connect(function() -- line: 397
        -- upvalues:
        --  [1] arg11 (copy)

        arg11:_Generate()
    end)
    PlayerDataController_m:GetSettingChangedSignal("Hide HUD"):Connect(function() -- line: 401
        -- upvalues:
        --  [1] arg11 (copy)

        arg11:_Generate()
    end)
    PlayerDataController_m:GetDataChangedSignal("StatisticDuelsPlayed"):Connect(function() -- line: 405
        -- upvalues:
        --  [1] arg11 (copy)

        arg11:_Generate()
    end)
    PlayerDataController_m:GetDataChangedSignal("TasksInterfaceOverride"):Connect(function() -- line: 409
        -- upvalues:
        --  [1] arg11 (copy)

        arg11:_Generate()
    end)
    PlayerDataController_m.StatisticsUpdated:Connect(function() -- line: 413
        -- upvalues:
        --  [1] arg11 (copy)

        arg11:_Generate()
    end)
    Equipment_m.Opened:Connect(function() -- line: 417
        -- upvalues:
        --  [1] arg11 (copy)

        arg11:_Generate()
    end)
    Pages_m.PageSystem.PagesActivity:Connect(function() -- line: 421
        -- upvalues:
        --  [1] arg11 (copy)

        arg11:_Generate()
        arg11:_PlayCenterAlertEffect()
    end)
    Queue_m.VisibilityChanged:Connect(function() -- line: 426
        -- upvalues:
        --  [1] arg11 (copy)

        arg11:_Generate()
    end)
    Teleporting_m.EnabledChanged:Connect(function() -- line: 430
        -- upvalues:
        --  [1] arg11 (copy)

        arg11:_Generate()
    end)
    MobileInputs_m.EditorEnabledChanged:Connect(function() -- line: 434
        -- upvalues:
        --  [1] arg11 (copy)

        arg11:_Generate()
    end)
    SpectateController_m.DuelSubjectChanged:Connect(function() -- line: 438
        -- upvalues:
        --  [1] arg11 (copy)

        arg11:_UpdateCurrentDuelSubject()
    end)
    GuiService:GetPropertyChangedSignal("MenuIsOpen"):Connect(function() -- line: 442
        -- upvalues:
        --  [1] arg11 (copy)

        arg11:_Generate()
    end)
    arg11:_Generate()
    arg11:_UpdateCurrentDuelSubject()
    arg11:_UpdateBackground()
    task.spawn(arg11._HookLocalFighter, arg11)
    ButtonEffect_m:Add(arg11.Frame.Container.Slots.ToDuels.Button)
    ButtonEffect_m:Add(arg11.Frame.Container.Slots.ToShootingRange.Button)
end

return t._new()
