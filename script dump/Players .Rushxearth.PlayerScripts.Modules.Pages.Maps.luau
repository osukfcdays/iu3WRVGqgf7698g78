local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local ContractsLibrary_m = require(ReplicatedStorage.Modules.ContractsLibrary)
local DuelLibrary_m = require(ReplicatedStorage.Modules.DuelLibrary)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local MatchmakingController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.MatchmakingController
)
local PlayerDataController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.PlayerDataController
)
local ArcadeController_m = require(Players.LocalPlayer.PlayerScripts.Controllers.ArcadeController)
local Equipment_m = require(
    Players.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("Equipment")
)
local ContractSlot_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("BaseContractSlot"):WaitForChild(
        "ContractSlot"
    )
)
local StatisticsList_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("StatisticsList")
)
local LockedMapSlot_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("LockedMapSlot")
)
local PromptSystem_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("PromptSystem")
)
local ButtonEffect_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("ButtonEffect")
)
local MapSlot_m = require(Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("MapSlot"))
local Page_m = require(Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("Page"))
local ContractDivider = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild(
    "ContractDivider"
)
local _ = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("LockedMapSlot")
local PlaySourceLabel = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild(
    "PlaySourceLabel"
)
local EmptySlot = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("EmptySlot")
local t = setmetatable({}, Page_m)
t.__index = t

function t._new() -- line: 30
    -- upvalues:
    --  [1] Page_m (copy)
    --  [2] t (copy)
    --  [3] PromptSystem_m (copy)
    --  [4] StatisticsList_m (copy)

    local t_1 = setmetatable(Page_m.new(script.Name), t)
    t_1.PromptsFrame = t_1.PageFrame:WaitForChild("Prompts")
    t_1.PageContainer = t_1.PageFrame:WaitForChild("Container")
    t_1.CloseButton = t_1.PageContainer:WaitForChild("Close")
    t_1.CloseButtonIcon = t_1.CloseButton:WaitForChild("Icon")
    t_1.List = t_1.PageContainer:WaitForChild("List")
    t_1.Container = t_1.List:WaitForChild("Container")
    t_1.Layout = t_1.Container:WaitForChild("Layout")
    t_1.SlotsFrame = t_1.Container:WaitForChild("Slots")
    t_1.SlotsContainer = t_1.SlotsFrame:WaitForChild("Container")
    t_1.SlotsLayout = t_1.SlotsContainer:WaitForChild("Layout")
    t_1.InspectList = t_1.PageContainer:WaitForChild("Inspect")
    t_1.InspectContainer = t_1.InspectList:WaitForChild("Container")
    t_1.InspectLayout = t_1.InspectContainer:WaitForChild("Layout")
    t_1.InspectDetailsFrame = t_1.InspectContainer:WaitForChild("Details")
    t_1.InspectDetailsFrameUIScale = t_1.InspectDetailsFrame:WaitForChild("UIScale")
    t_1.InspectDetailsContainer = t_1.InspectDetailsFrame:WaitForChild("Container")
    t_1.InspectDetailsLayout = t_1.InspectDetailsContainer:WaitForChild("Layout")
    t_1.InspectDetailsThumbnail = t_1.InspectDetailsContainer:WaitForChild("Thumbnail")
    t_1.InspectDetailsTextLabelsFrame = t_1.InspectDetailsContainer:WaitForChild("TextLabels")
    t_1.InspectDetailsTextLabelsContainer = t_1.InspectDetailsTextLabelsFrame:WaitForChild(
        "Container"
    )
    t_1.InspectDetailsTextLabelsLayout = t_1.InspectDetailsTextLabelsContainer:WaitForChild(
        "Layout"
    )
    t_1.InspectDetailsTitle = t_1.InspectDetailsTextLabelsContainer:WaitForChild("Title")
    t_1.InspectDetailsDescription = t_1.InspectDetailsTextLabelsContainer:WaitForChild(
        "Description"
    )
    t_1.InspectDetailsCreator = t_1.InspectDetailsTextLabelsContainer:WaitForChild("Creator")
    t_1.InspectQueuesFrame = t_1.InspectContainer:WaitForChild("Queues")
    t_1.InspectQueuesFrameUIScale = t_1.InspectQueuesFrame:WaitForChild("UIScale")
    t_1.InspectQueuesContainer = t_1.InspectQueuesFrame:WaitForChild("Container")
    t_1.InspectQueuesLabelsFrame = t_1.InspectQueuesContainer:WaitForChild("Labels")
    t_1.InspectQueuesLabelsLayout = t_1.InspectQueuesLabelsFrame:WaitForChild("Layout")
    t_1.InspectStatisticsFrame = t_1.InspectContainer:WaitForChild("Statistics")
    t_1.InspectStatisticsFrameUIScale = t_1.InspectStatisticsFrame:WaitForChild("UIScale")
    t_1.InspectStatisticsContainer = t_1.InspectStatisticsFrame:WaitForChild("Container")
    t_1.InspectStatisticsLayout = t_1.InspectStatisticsContainer:WaitForChild("Layout")
    t_1.InspectStatisticsTextLabelsFrame = t_1.InspectStatisticsContainer:WaitForChild("TextLabels")
    t_1.InspectStatisticsTextLabelsContainer = t_1.InspectStatisticsTextLabelsFrame:WaitForChild(
        "Container"
    )
    t_1.InspectStatisticsTextLabelsLayout = t_1.InspectStatisticsTextLabelsContainer:WaitForChild(
        "Layout"
    )
    t_1.PromptSystem = PromptSystem_m.new(t_1.PromptsFrame)
    t_1.StatisticsList = StatisticsList_m.new(t_1.InspectStatisticsTextLabelsContainer, 1, true)
    t_1._map_slots = {}
    t_1._locked_map_slots = {}
    t_1._empty_map_slots = {}
    t_1._map_slot_ui_scales = {}
    t_1._map_slot_tweens = {}
    t_1._inspected_map_name = nil
    t_1._inspected_map_info = nil
    t_1._inspected_map_locked_slot = nil
    t_1._inspected_queue_labels = {}
    t_1._inspected_map_contract_slots = {}
    t_1._inspect_tweens = {}
    t_1:_Init()

    return t_1
end

function t.CloseRequest(arg1) -- line: 94
    -- upvalues:
    --  [1] Page_m (copy)

    if arg1._inspected_map_name then
        arg1:Inspect(nil)

        return
    end

    Page_m.CloseRequest(arg1)
end

function t.Inspect(arg2, arg3) -- line: 102
    -- upvalues:
    --  [1] DuelLibrary_m (copy)
    --  [2] LockedMapSlot_m (copy)
    --  [3] PlaySourceLabel (copy)
    --  [4] MatchmakingController_m (copy)
    --  [5] ArcadeController_m (copy)
    --  [6] Equipment_m (copy)
    --  [7] PlayerDataController_m (copy)
    --  [8] ContractsLibrary_m (copy)
    --  [9] ContractDivider (copy)
    --  [10] ContractSlot_m (copy)
    --  [11] TweenService (copy)

    for _, val in pairs(arg2._inspect_tweens) do
        val:Cancel()
    end

    for _, val_1 in pairs(arg2._inspected_queue_labels) do
        val_1:Destroy()
    end

    for _, val_2 in pairs(arg2._inspected_map_contract_slots) do
        val_2:Destroy()
    end

    arg2._inspected_map_contract_slots = {}
    arg2._inspect_tweens = {}
    arg2._inspected_queue_labels = {}

    if arg2._inspected_map_locked_slot then
        arg2._inspected_map_locked_slot:Destroy()
        arg2._inspected_map_locked_slot = nil
    end

    arg2._inspected_map_name = arg3
    arg2._inspected_map_info = DuelLibrary_m.Maps[arg2._inspected_map_name]
    arg2.List.Visible = not arg2._inspected_map_name
    arg2.InspectList.Visible = arg2._inspected_map_name
    local CloseButtonIcon = arg2.CloseButtonIcon
    CloseButtonIcon.Image = if not arg2._inspected_map_name then "rbxassetid://17838290166" else "rbxassetid://17562685319"

    if not arg2._inspected_map_name then
        arg2:_PlayMapSlotsTween()

        return
    end

    local v11 = arg2:_IsMapUnlocked(arg2._inspected_map_name)
    local InspectDetailsTitle = arg2.InspectDetailsTitle
    InspectDetailsTitle.Text = v11 and arg2._inspected_map_name or "Discover this map in a duel to learn more!"
    arg2.InspectDetailsTitle.TextTransparency = if not v11 then 0.5 else 0
    local InspectDetailsTitle_2 = arg2.InspectDetailsTitle
    InspectDetailsTitle_2.FontFace = v11 and Font.fromId(
        12187365977,
        Enum.FontWeight.Bold,
        Enum.FontStyle.Normal
    ) or Font.fromId(12187365977, Enum.FontWeight.Medium, Enum.FontStyle.Italic)
    local InspectDetailsTitle_3 = arg2.InspectDetailsTitle
    InspectDetailsTitle_3.Size = v11 and UDim2.new(0.95, 0, 0.066, 0) or UDim2.new(
        0.95,
        0,
        0.035,
        0
    )
    local InspectDetailsThumbnail = arg2.InspectDetailsThumbnail
    InspectDetailsThumbnail.Image = v11 and arg2._inspected_map_info.Image or ""
    local InspectDetailsDescription = arg2.InspectDetailsDescription
    InspectDetailsDescription.Text = if not v11 then "" else if arg2._inspected_map_info.Description then "\226\128\162 " .. arg2._inspected_map_info.Description else ""
    local InspectDetailsCreator = arg2.InspectDetailsCreator
    InspectDetailsCreator.Text = if not v11 then "" else if #arg2._inspected_map_info.Contributors > 0 then string.format(
        "\226\128\162 Created by %s with contributions from %s",
        arg2:_GetUsernamesString(arg2._inspected_map_info.Creators),
        arg2:_GetUsernamesString(arg2._inspected_map_info.Contributors)
    ) else if #arg2._inspected_map_info.Creators > 0 then string.format(
        "\226\128\162 Created by %s",
        arg2:_GetUsernamesString(arg2._inspected_map_info.Creators)
    ) else ""
    local InspectDetailsDescription_1 = arg2.InspectDetailsDescription
    InspectDetailsDescription_1.Visible = arg2.InspectDetailsDescription.Text ~= ""
    local InspectDetailsCreator_1 = arg2.InspectDetailsCreator
    InspectDetailsCreator_1.Visible = arg2.InspectDetailsCreator.Text ~= ""

    if not v11 then
        arg2._inspected_map_locked_slot = LockedMapSlot_m.new(arg2._inspected_map_name, true)
        arg2._inspected_map_locked_slot.Frame.Size = UDim2.new(1, 0, 1, 0)
        arg2._inspected_map_locked_slot.Frame.SizeConstraint = Enum.SizeConstraint.RelativeXY
        arg2._inspected_map_locked_slot.Frame.Position = UDim2.new(0.5, 0, 0.5, 0)
        arg2._inspected_map_locked_slot.Frame.AnchorPoint = Vector2.new(0.5, 0.5)
        arg2._inspected_map_locked_slot.Frame.Button.Difficulty.UIStroke.Enabled = false
        arg2._inspected_map_locked_slot:SetParent(arg2.InspectDetailsThumbnail)
    end

    local function create_playsource_label(arg4, arg5, arg6, arg7) -- line: 165
        -- upvalues:
        --  [1] DuelLibrary_m (ref)
        --  [2] PlaySourceLabel (ref)
        --  [3] arg2 (copy)
        --  [4] MatchmakingController_m (ref)
        --  [5] ArcadeController_m (ref)
        --  [6] Equipment_m (ref)

        local v14 = DuelLibrary_m.PlaySources[arg5]

        if
            v14
            and v14.DatabaseInfo
            and typeof(v14.DatabaseInfo.CanBeStartedFromClient) == "function"
            and not v14.DatabaseInfo.CanBeStartedFromClient()
        then
            return
        end

        local v15 = arg6 or v14 and v14.AssignedColor or Color3.fromRGB(0, 0, 0)
        local v16 = arg7 or v15:Lerp(Color3.fromRGB(0, 0, 0), 0.5)
        local v17 = PlaySourceLabel:Clone()
        v17.LayoutOrder = arg4
        local Title = v17.Container.Title
        Title.Text = v14 and v14.DisplayName or arg5
        v17.Play.ImageColor3 = v15
        v17.Parent = arg2.InspectQueuesLabelsFrame
        table.insert(arg2._inspected_queue_labels, v17)

        local function update() -- line: 182
            -- upvalues:
            --  [1] v17 (copy)

            v17.Size = UDim2.new(0.05, v17.Container.Title.TextBounds.X, 0.05, 0)
        end

        v17.Container.Title:GetPropertyChangedSignal("TextBounds"):Connect(update)
        v17.Size = UDim2.new(0.05, v17.Container.Title.TextBounds.X, 0.05, 0)

        local function hover() -- line: 189
            -- upvalues:
            --  [1] v17 (copy)
            --  [2] v15 (copy)
            --  [3] v16 (copy)

            v17.Play.Visible = true
            v17.Container.Title.Visible = false
            v17.Container.Title.TextColor3 = v15
            v17.Background.ImageColor3 = v16
        end

        local function unhover() -- line: 196
            -- upvalues:
            --  [1] v17 (copy)
            --  [2] v16 (copy)
            --  [3] v15 (copy)

            v17.Play.Visible = false
            v17.Container.Title.Visible = true
            v17.Container.Title.TextColor3 = v16
            v17.Background.ImageColor3 = v15
        end

        v17.Play.Visible = false
        v17.Container.Title.Visible = true
        v17.Container.Title.TextColor3 = v16
        v17.Background.ImageColor3 = v15

        if v14 then
            v17.MouseButton1Click:Connect(function() -- line: 206
                -- upvalues:
                --  [1] v14 (copy)
                --  [2] MatchmakingController_m (ref)
                --  [3] arg5 (copy)
                --  [4] ArcadeController_m (ref)
                --  [5] arg2 (ref)
                --  [6] Equipment_m (ref)

                local v20 = if v14.Type == "MatchmakingQueue" then MatchmakingController_m:QueueInto(
                    arg5
                ) else if v14.Type == "ArcadeMode" then ArcadeController_m:ToArcadeServer(arg5) else assert(
                    false,
                    "???"
                )

                if v20 == "Success" then
                    arg2.Closed:Fire()
                    Equipment_m:Close()

                    return
                end

                arg2.PromptSystem:Open(
                    "ErrorMessage",
                    "Whoops!",
                    v20 or "Server failed to respond, please try again"
                )
            end)
            v17.MouseEnter:Connect(hover)
            v17.SelectionGained:Connect(hover)
            v17.MouseLeave:Connect(unhover)
            v17.SelectionLost:Connect(unhover)
        end
    end

    if arg2._inspected_map_info.IsHidden then
        create_playsource_label(1, "N/A", Color3.fromRGB(0, 0, 0), Color3.fromRGB(255, 255, 255))
    elseif #arg2._inspected_map_info.PlaySources == 0 then
        create_playsource_label(
            1,
            "Private Servers",
            Color3.fromRGB(0, 0, 0),
            Color3.fromRGB(255, 255, 255)
        )
    else
        for key_3, val_3 in pairs(arg2._inspected_map_info.PlaySources) do
            create_playsource_label(key_3, val_3)
        end
    end

    arg2.InspectStatisticsFrame.Visible = PlayerDataController_m:GetMapStatistic(
        arg3,
        "StatisticPlaytime"
    ) > 0 and true
    arg2.StatisticsList:Generate(false, "MapStatistics", arg3)

    if v11 then
        create_playsource_label = 50

        for key_4, val_4 in pairs(ContractsLibrary_m:GetMapContracts(arg2._inspected_map_name)) do
            if key_4 > 1 then
                local v23 = ContractDivider:Clone()
                v23.LayoutOrder = create_playsource_label
                v23.Parent = arg2.InspectContainer
                table.insert(arg2._inspected_map_contract_slots, v23)
                create_playsource_label += 1
            end

            local v24 = ContractSlot_m.new("MapStatistics", val_4)
            v24.Frame.LayoutOrder = create_playsource_label
            v24.Frame.Parent = arg2.InspectContainer
            table.insert(arg2._inspected_map_contract_slots, v24)
            create_playsource_label += 1
        end
    end

    arg2.InspectDetailsFrameUIScale.Scale = 0.5
    arg2.InspectQueuesFrameUIScale.Scale = 0.5
    arg2.InspectStatisticsFrameUIScale.Scale = 0.5
    local v26 = TweenService:Create(
        arg2.InspectDetailsFrameUIScale,
        TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
        { Scale = 1 }
    )
    v26:Play()
    table.insert(arg2._inspect_tweens, v26)
    local v28 = TweenService:Create(
        arg2.InspectQueuesFrameUIScale,
        TweenInfo.new(0.375, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
        { Scale = 1 }
    )
    v28:Play()
    table.insert(arg2._inspect_tweens, v28)
    local v30 = TweenService:Create(
        arg2.InspectStatisticsFrameUIScale,
        TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
        { Scale = 1 }
    )
    v30:Play()
    table.insert(arg2._inspect_tweens, v30)
end

function t.Open(arg8, ...) -- line: 279
    -- upvalues:
    --  [1] Page_m (copy)

    Page_m.Open(arg8, ...)
    arg8:Inspect(nil)
    arg8:_UpdateMapSlots()
    arg8:_PlayMapSlotsTween()
end

function t._IsMapUnlocked(_, arg10) -- line: 290
    -- upvalues:
    --  [1] DuelLibrary_m (copy)
    --  [2] PlayerDataController_m (copy)

    return if DuelLibrary_m.Maps[arg10] then if #DuelLibrary_m.Maps[arg10].PlaySources ~= 0 then PlayerDataController_m:GetMapStatistic(
        arg10,
        "StatisticPlaytime"
    ) > 0 and true else true else PlayerDataController_m:GetMapStatistic(arg10, "StatisticPlaytime") > 0 and true
end

function t._PlayMapSlotsTween(arg11) -- line: 294
    -- upvalues:
    --  [1] TweenService (copy)

    for _, val_5 in pairs(arg11._map_slot_tweens) do
        val_5:Cancel()
    end

    arg11._map_slot_tweens = {}

    local function play(arg12, arg13) -- line: 301
        -- upvalues:
        --  [1] TweenService (ref)
        --  [2] arg11 (copy)

        arg13.Scale = 0.25
        local v34 = TweenService:Create(
            arg13,
            TweenInfo.new(
                math.sqrt(arg12) * 0.1 + 0.1,
                Enum.EasingStyle.Quint,
                Enum.EasingDirection.Out
            ),
            { Scale = 1 }
        )
        v34:Play()
        table.insert(arg11._map_slot_tweens, v34)
    end

    for key_6, val_6 in pairs(arg11._map_slots) do
        play(key_6, val_6[2].Frame.UIScale)
    end

    for key_7, val_7 in pairs(arg11._locked_map_slots) do
        play(key_7, val_7[2].Frame.UIScale)
    end

    for key_8, val_8 in pairs(arg11._empty_map_slots) do
        play(#arg11._map_slots + key_8, val_8.UIScale)
    end
end

function t._GetUsernamesString(_, arg15) -- line: 321
    local v35 = ""

    for key_9, val_9 in pairs(arg15) do
        v35 = (v35 .. (if key_9 ~= 1 then if key_9 ~= #arg15 then ", " else ", & " else "")) .. "@" .. val_9
    end

    return v35
end

function t._UpdateMapSlots(arg16) -- line: 332
    if not arg16:IsOpen() then
        return
    end

    for _, val_10 in pairs(arg16._map_slots) do
        val_10[2].Frame.Visible = arg16:_IsMapUnlocked(val_10[1])
    end

    for _, val_11 in pairs(arg16._locked_map_slots) do
        val_11[2].Frame.Visible = not arg16:_IsMapUnlocked(val_11[1])
    end
end

function t._UpdateList(arg17) -- line: 346
    arg17.CloseButton.Position = UDim2.new(0.975, 0, 0.0225, arg17.PageFrame.AbsoluteSize.Y * 0.125)
    arg17.List.CanvasSize = UDim2.new(0, 0, 0, arg17.Layout.AbsoluteContentSize.Y)
    local List_1 = arg17.List
    List_1.Active = arg17.Layout.AbsoluteContentSize.Y >= arg17.List.AbsoluteSize.Y
    arg17.List.Position = UDim2.new(0.5, 9, 0, arg17.PageFrame.AbsoluteSize.Y * 0.125)
    arg17.List.Size = UDim2.new(0.85, 0, 0, arg17.PageFrame.AbsoluteSize.Y * 0.75)
    arg17.InspectList.Position = arg17.List.Position
    arg17.InspectList.Size = arg17.List.Size
end

function t._Setup(arg18) -- line: 356
    -- upvalues:
    --  [1] Utility_m (copy)
    --  [2] DuelLibrary_m (copy)
    --  [3] MapSlot_m (copy)
    --  [4] LockedMapSlot_m (copy)
    --  [5] EmptySlot (copy)

    local v40 = Utility_m:CloneTable(DuelLibrary_m.MapOrder)
    table.sort(v40, function(arg19, arg20) -- line: 359
        -- upvalues:
        --  [1] DuelLibrary_m (ref)

        return DuelLibrary_m:SortMaps(arg19, arg20)
    end)

    local function create_map_slot(arg21, arg22) -- line: 363
        -- upvalues:
        --  [1] MapSlot_m (ref)
        --  [2] arg18 (copy)

        local v41 = MapSlot_m.new(arg22)
        v41.Frame.LayoutOrder = arg21
        v41:SetParent(arg18.SlotsContainer)
        table.insert(arg18._map_slots, { arg22, v41 })
        v41.Frame.Button.MouseButton1Click:Connect(function() -- line: 369
            -- upvalues:
            --  [1] arg18 (ref)
            --  [2] arg22 (copy)

            arg18:Inspect(arg22)
        end)
        Instance.new("UIScale").Parent = v41.Frame
    end

    local function create_locked_map_slot(arg23, arg24) -- line: 377
        -- upvalues:
        --  [1] DuelLibrary_m (ref)
        --  [2] LockedMapSlot_m (ref)
        --  [3] arg18 (copy)

        local _ = DuelLibrary_m.Maps[arg24]
        local v43 = LockedMapSlot_m.new(arg24)
        v43.Frame.LayoutOrder = arg23
        v43:SetParent(arg18.SlotsContainer)
        table.insert(arg18._locked_map_slots, { arg24, v43 })
        v43.Frame.Button.MouseButton1Click:Connect(function() -- line: 384
            -- upvalues:
            --  [1] arg18 (ref)
            --  [2] arg24 (copy)

            arg18:Inspect(arg24)
        end)
        Instance.new("UIScale").Parent = v43.Frame
    end

    for key_12, val_12 in pairs(v40) do
        create_map_slot(key_12, val_12)
        create_locked_map_slot(key_12, val_12)
    end

    for _ = 1, math.max(0, 9 - #v40) + (3 - (if #v40 > 9 then (#v40 - 1) % 3 + 1 else 0)) do
        local v46 = EmptySlot:Clone()
        v46.LayoutOrder = 9999999
        v46.Parent = arg18.SlotsContainer
        table.insert(arg18._empty_map_slots, v46)
        Instance.new("UIScale").Parent = v46
    end
end

function t._Init(arg25) -- line: 408
    -- upvalues:
    --  [1] PlayerDataController_m (copy)
    --  [2] ButtonEffect_m (copy)

    arg25.CloseButton.MouseButton1Click:Connect(function() -- line: 409
        -- upvalues:
        --  [1] arg25 (copy)

        arg25:CloseRequest()
    end)
    arg25.Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() -- line: 413
        -- upvalues:
        --  [1] arg25 (copy)

        arg25:_UpdateList()
    end)
    arg25.SlotsLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() -- line: 417
        -- upvalues:
        --  [1] arg25 (copy)

        arg25.SlotsFrame.Size = UDim2.new(1, 0, 0, arg25.SlotsLayout.AbsoluteContentSize.Y)
    end)
    arg25.InspectLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() -- line: 421
        -- upvalues:
        --  [1] arg25 (copy)

        arg25.InspectList.CanvasSize = UDim2.new(0, 0, 0, arg25.InspectLayout.AbsoluteContentSize.Y)
        local InspectList_1 = arg25.InspectList
        InspectList_1.Active = arg25.InspectLayout.AbsoluteContentSize.Y >= arg25.InspectList.AbsoluteSize.Y
    end)
    arg25.InspectDetailsTextLabelsLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(
        function() -- line: 426
            -- upvalues:
            --  [1] arg25 (copy)

            arg25.InspectDetailsTextLabelsFrame.Size = UDim2.new(
                1,
                0,
                0,
                arg25.InspectDetailsTextLabelsLayout.AbsoluteContentSize.Y
            )
        end
    )
    arg25.InspectDetailsLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() -- line: 430
        -- upvalues:
        --  [1] arg25 (copy)

        arg25.InspectDetailsFrame.Size = UDim2.new(
            1,
            0,
            0,
            arg25.InspectDetailsLayout.AbsoluteContentSize.Y
        )
    end)
    arg25.InspectQueuesLabelsLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() -- line: 434
        -- upvalues:
        --  [1] arg25 (copy)

        arg25.InspectQueuesFrame.Size = UDim2.new(
            1,
            0,
            0.088,
            arg25.InspectQueuesLabelsLayout.AbsoluteContentSize.Y
        )
    end)
    arg25.InspectStatisticsLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() -- line: 438
        -- upvalues:
        --  [1] arg25 (copy)

        arg25.InspectStatisticsFrame.Size = UDim2.new(
            1,
            0,
            0,
            arg25.InspectStatisticsLayout.AbsoluteContentSize.Y
        )
    end)
    arg25.InspectStatisticsTextLabelsLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(
        function() -- line: 442
            -- upvalues:
            --  [1] arg25 (copy)

            arg25.InspectStatisticsTextLabelsFrame.Size = UDim2.new(
                1,
                0,
                0,
                arg25.InspectStatisticsTextLabelsLayout.AbsoluteContentSize.Y
            )
        end
    )
    arg25.PageFrame:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- line: 446
        -- upvalues:
        --  [1] arg25 (copy)

        arg25:_UpdateList()
    end)
    PlayerDataController_m.StatisticsUpdated:Connect(function() -- line: 450
        -- upvalues:
        --  [1] arg25 (copy)

        arg25:_UpdateMapSlots()
    end)
    arg25:_Setup()
    arg25:_UpdateList()
    arg25:_UpdateMapSlots()
    arg25:Inspect(nil)
    ButtonEffect_m:Add(arg25.CloseButton)
end

return t._new()
