local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CONSTANTS_m = require(ReplicatedStorage.Modules.CONSTANTS)
local _ = require(ReplicatedStorage.Modules.CosmeticLibrary)
local BetterDebris_m = require(ReplicatedStorage.Modules.BetterDebris)
local ItemLibrary_m = require(ReplicatedStorage.Modules.ItemLibrary)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local Signal_m = require(ReplicatedStorage.Modules.Signal)
local PlayerDataController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("PlayerDataController")
)
local WeaponStatusHandler_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("WeaponStatusHandler")
)
local ButtonEffect_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("ButtonEffect")
)
local RewardSlot_m = require(Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("RewardSlot"))
local UILibrary_m = require(Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("UILibrary"))
local Page_m = require(Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("Page"))
local PatchNoteBalancingOverviewSlot = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild(
    "PatchNoteBalancingOverviewSlot"
)
local PatchNoteContentSummarySlot = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild(
    "PatchNoteContentSummarySlot"
)
local PatchNoteBalanceChangeSlot = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild(
    "PatchNoteBalanceChangeSlot"
)
local PatchNoteViewMoreButton = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild(
    "PatchNoteViewMoreButton"
)
local PatchNoteThumbnailSlot = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild(
    "PatchNoteThumbnailSlot"
)
local ViewPatchNotesSlot = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild(
    "ViewPatchNotesSlot"
)
local PatchNoteChangeSlot = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild(
    "PatchNoteChangeSlot"
)
local PatchNotesSlot = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild(
    "PatchNotesSlot"
)
local PatchNotes = Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("PatchNotes")
local t = {
    "Release",
    "FreezeRay",
    "Matchmaking",
    "Cosmetics",
    "NewMaps",
    "Gamemodes",
    "2024SpookyEvent",
    "Weapons",
    "2024FestiveEvent",
    "BridgeMap",
    "Ranked",
    "TheHunt",
    "Cosmetics2",
    "Gamemodes2",
    "Emotes",
    "Season1",
    "2025SpookyEvent",
    "2025FestiveEvent",
    "LaborOfLove",
    "Lucky",
    "Season3",
    "2026SummerEvent",
    "WildcatRelease",
    "RIA26",
    "2026SpookyEvent"
}
local t_1 = {
    { Color3.fromRGB(100, 255, 50), "rbxassetid://72868042131575" },
    { Color3.fromRGB(255, 50, 50), "rbxassetid://129990470163489" },
    { Color3.fromRGB(166, 166, 166), "rbxassetid://125168324521437" }
}
local t_5 = {
    Title = { Weight = 600, Transparency = 0, Size = 1.5, Spaces = 3, Prefix = "", NewLine = 2 },
    Header = {
        Weight = 500,
        Transparency = 0.125,
        Size = 0.875,
        Spaces = 9,
        Prefix = "",
        NewLine = 0.5
    },
    Description = {
        Weight = 400,
        Transparency = 0.25,
        Size = 0.75,
        Spaces = 12,
        Prefix = "\226\128\162 ",
        NewLine = nil
    },
    Description2 = {
        Weight = 400,
        Transparency = 0.5,
        Size = 0.75,
        Spaces = 18,
        Prefix = "\226\150\170  ",
        NewLine = nil
    }
}
local t_6 = setmetatable({}, Page_m)
t_6.__index = t_6

function t_6._new() -- line: 50
    -- upvalues:
    --  [1] Page_m (copy)
    --  [2] t_6 (copy)

    local t_7 = setmetatable(Page_m.new(script.Name), t_6)
    t_7.PageContainer = t_7.PageFrame:WaitForChild("Container")
    t_7.CloseButton = t_7.PageContainer:WaitForChild("Close")
    t_7.List = t_7.PageContainer:WaitForChild("List")
    t_7.Container = t_7.List:WaitForChild("Container")
    t_7.Layout = t_7.Container:WaitForChild("Layout")
    t_7.ViewMoreButton = t_7.PageContainer:WaitForChild("ViewMore")
    t_7.ViewMoreList = t_7.PageContainer:WaitForChild("ViewMoreList")
    t_7.ViewMoreContainer = t_7.ViewMoreList:WaitForChild("Container")
    t_7.ViewMoreLayout = t_7.ViewMoreContainer:WaitForChild("Layout")
    t_7._current_patch_notes_slot = nil
    t_7._elements = {}
    t_7:_Init()

    return t_7
end

function t_6.SetViewMoreListVisible(arg1, arg2) -- line: 75
    arg1.ViewMoreList.Visible = arg2
    arg1.ViewMoreList.CanvasPosition = Vector2.zero
    arg1.List.Visible = not arg2
    arg1.List.CanvasPosition = Vector2.zero
    arg1.ViewMoreButton.Visible = not arg2
end

function t_6.ScrollTo(arg3, arg4, arg5) -- line: 83
    -- upvalues:
    --  [1] TweenService (copy)
    --  [2] BetterDebris_m (copy)
    --  [3] Utility_m (copy)

    if not arg4 then
        return
    end

    TweenService:Create(
        arg3.List,
        TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
        {
            CanvasPosition = Vector2.new(
                0,
                arg4.AbsolutePosition.Y - arg3.Container.AbsolutePosition.Y
            )
        }
    ):Play()
    local Frame = Instance.new("Frame")
    Frame.BackgroundColor3 = arg5 or Color3.fromRGB(255, 255, 255)
    Frame.AnchorPoint = Vector2.new(0.5, 0.5)
    Frame.Position = UDim2.new(0.5, 0, 0.5, 0)
    Frame.Size = UDim2.new(1, 0, 20, 0)
    Frame.Parent = arg4
    Frame:TweenSize(
        UDim2.new(1, 0, 1, 0),
        "Out",
        "Quint",
        0.5,
        true
    )
    BetterDebris_m:AddItem(Frame, 3)
    local UIGradient = Instance.new("UIGradient")
    UIGradient.Transparency = NumberSequence.new(
        {
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(0.125, 0),
            NumberSequenceKeypoint.new(0.875, 0),
            NumberSequenceKeypoint.new(1, 1)
        }
    )
    UIGradient.Parent = Frame
    task.spawn(
        Utility_m.RenderstepForLoop,
        Utility_m,
        0,
        100,
        1,
        function(arg6) -- line: 103
            -- upvalues:
            --  [1] Frame (copy)

            Frame.BackgroundTransparency = 0 + 1 * (arg6 / 100) ^ 4
        end
    )
end

function t_6.Open(arg7, ...) -- line: 110
    -- upvalues:
    --  [1] Page_m (copy)
    --  [2] t (copy)
    --  [3] RunService (copy)

    Page_m.Open(arg7, ...)
    arg7:_UpdateSize()
    arg7:SetViewMoreListVisible(false)
    task.defer(arg7._Generate, arg7, t[#t])
    local IsOpenHash = arg7._is_open_hash
    task.delay(0.5, function() -- line: 118
        -- upvalues:
        --  [1] arg7 (copy)
        --  [2] IsOpenHash (copy)
        --  [3] RunService (ref)

        for _, val in pairs(arg7._elements) do
            if IsOpenHash ~= arg7._is_open_hash then
                return
            end

            pcall(function() -- line: 124
                -- upvalues:
                --  [1] val (copy)

                val[1].Parent = val[2]
            end)
            RunService.RenderStepped:Wait()
        end
    end)
end

function t_6.Close(arg8, ...) -- line: 133
    -- upvalues:
    --  [1] Page_m (copy)

    for _, val_1 in pairs(arg8._elements) do
        val_1[1].Parent = nil
    end

    Page_m.Close(arg8, ...)
end

function t_6._Generate(arg9, arg10) -- line: 145
    -- upvalues:
    --  [1] PatchNotes (copy)
    --  [2] PatchNotesSlot (copy)
    --  [3] ReplicatedStorage (copy)
    --  [4] ButtonEffect_m (copy)
    --  [5] t (copy)
    --  [6] PlayerDataController_m (copy)
    --  [7] Signal_m (copy)
    --  [8] PatchNoteViewMoreButton (copy)
    --  [9] RunService (copy)
    --  [10] PatchNoteBalancingOverviewSlot (copy)
    --  [11] t_1 (copy)
    --  [12] ItemLibrary_m (copy)
    --  [13] PatchNoteBalanceChangeSlot (copy)
    --  [14] PatchNoteContentSummarySlot (copy)
    --  [15] RewardSlot_m (copy)
    --  [16] PatchNoteThumbnailSlot (copy)
    --  [17] t_5 (copy)
    --  [18] PatchNoteChangeSlot (copy)
    --  [19] WeaponStatusHandler_m (copy)

    if arg9._current_patch_notes_slot then
        arg9._current_patch_notes_slot:Destroy()
        arg9._current_patch_notes_slot = nil
    end

    arg9._elements = {}
    local v10 = require(PatchNotes:WaitForChild(arg10))
    local v11 = PatchNotesSlot:Clone()
    v11.LayoutOrder = 1
    v11.Container.Thumbnail.Image = v10.Image or ""
    local Thumbnail = v11.Container.Thumbnail
    Thumbnail.Visible = if v11.Container.Thumbnail.Image == "" then false else true
    v11.Container.Details.Title.Text = v10.Title
    v11.Container.Details.Changes.Date.Text = v10.Date
    v11.Parent = arg9.Container
    arg9._current_patch_notes_slot = v11
    v11.Container.Details.Changes.CodeButton.Button.MouseButton1Click:Connect(function() -- line: 164
        -- upvalues:
        --  [1] v11 (copy)
        --  [2] ReplicatedStorage (ref)
        --  [3] v10 (copy)

        v11.Container.Details.Changes.CodeButton.Visible = false
        ReplicatedStorage.Remotes.Data.RedeemCode:InvokeServer(string.lower(v10.Code))
    end)
    v11.Container.Details.Changes.Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(
        function() -- line: 169
            -- upvalues:
            --  [1] v11 (copy)

            v11.Size = UDim2.new(
                1,
                0,
                0,
                v11.Container.Details.Changes.AbsolutePosition.Y - v11.AbsolutePosition.Y + v11.Container.Details.Changes.Layout.AbsoluteContentSize.Y
            )
        end
    )
    ButtonEffect_m:Add(v11.Container.Details.Changes.CodeButton.Button)
    local v14 = t

    if v10.Code and arg10 == v14[#t] then
        local task_delay = task.delay
        local CodeButton = v11.Container.Details.Changes.CodeButton
        task_delay(20, function() -- line: 178
            -- upvalues:
            --  [1] CodeButton (copy)
            --  [2] PlayerDataController_m (ref)
            --  [3] v10 (copy)

            CodeButton.Visible = not PlayerDataController_m:Get("RedeemedCodes")[string.lower(
                v10.Code
            )]
        end)
    end

    local v17 = Signal_m.new()
    local v18 = true
    local _ = nil
    local v20 = 0
    local t_10 = {}
    local v21 = false
    local t_11 = {}
    local v22 = 0

    local _ = function() --[[ new_layout_order ]] -- line: 192
        -- upvalues:
        --  [1] v22 (ref)

        v22 += 1

        return v22
    end

    local _ = function(arg11) --[[ register_element ]] -- line: 197
        -- upvalues:
        --  [1] arg9 (copy)
        --  [2] v11 (copy)

        arg11.Parent = arg9._is_open and v11.Container.Details.Changes or nil
        table.insert(arg9._elements, { arg11, v11.Container.Details.Changes })
    end

    local function add_to_collapsed_list(arg12, arg13, arg14) -- line: 202
        -- upvalues:
        --  [1] t_10 (ref)
        --  [2] v20 (ref)
        --  [3] PatchNoteViewMoreButton (ref)
        --  [4] v18 (ref)
        --  [5] v17 (copy)
        --  [6] ButtonEffect_m (ref)
        --  [7] RunService (ref)

        if t_10 then
            arg12.Visible = false
            table.insert(t_10, arg12)

            if arg13 then
                arg13.Visible = false
                table.insert(t_10, arg13)

                return
            end
        else
            if v20 == 10 then
                local UIGradient_1 = Instance.new("UIGradient")
                UIGradient_1.Transparency = NumberSequence.new(
                    { NumberSequenceKeypoint.new(0, 0.5), NumberSequenceKeypoint.new(1, 1) }
                )
                UIGradient_1.Rotation = 90
                UIGradient_1.Parent = arg12
                local t_14 = {}
                t_10 = t_14
                local v24 = PatchNoteViewMoreButton:Clone()
                v24.Parent = arg12

                local function expand() -- line: 223
                    -- upvalues:
                    --  [1] v18 (ref)
                    --  [2] t_14 (copy)
                    --  [3] UIGradient_1 (copy)
                    --  [4] v24 (copy)

                    if v18 then
                        return
                    end

                    for _, val_2 in pairs(t_14) do
                        val_2.Visible = true
                    end

                    UIGradient_1:Destroy()
                    v24:Destroy()
                end

                v24.MouseButton1Click:Connect(expand)
                v17:Connect(expand)
                ButtonEffect_m:Add(v24)
                RunService.RenderStepped:Wait()

                return
            end

            v20 += arg14 or 1
        end
    end

    local function generate_balancing_overview(arg15) -- line: 247
        -- upvalues:
        --  [1] v21 (ref)
        --  [2] PatchNoteBalancingOverviewSlot (ref)
        --  [3] v22 (ref)
        --  [4] t_1 (ref)
        --  [5] ItemLibrary_m (ref)
        --  [6] PatchNoteBalanceChangeSlot (ref)
        --  [7] v17 (copy)
        --  [8] arg9 (copy)
        --  [9] t_11 (copy)
        --  [10] ButtonEffect_m (ref)
        --  [11] v11 (copy)

        v21 = true
        local v25 = PatchNoteBalancingOverviewSlot:Clone()
        v22 += 1
        v25.LayoutOrder = v22

        for index = 1, 3 do
            local v26 = t_1[index]
            local v27 = arg15[index + 1] or {}

            for _, val_3 in pairs(v27) do
                assert(ItemLibrary_m.ViewModels[val_3], val_3)
                local v28 = PatchNoteBalanceChangeSlot:Clone()
                v28.Button.Label.Icon.Image = v26[2]
                v28.Button.Label.Icon.ImageColor3 = v26[1]
                v28.Button.Background.BackgroundColor3 = v26[1]
                v28.Button.Background.UIStroke.Color = v26[1]
                local v29 = ItemLibrary_m.ViewModels[val_3].ImageCentered
                local Picture = v28.Button.Graphic.Picture

                if not v29 then
                    v29 = ItemLibrary_m.Items[val_3].Image
                end

                Picture.Image = v29
                v28.Parent = v25.Slots
                v28.Button.MouseButton1Click:Connect(function() -- line: 268
                    -- upvalues:
                    --  [1] v17 (ref)
                    --  [2] arg9 (ref)
                    --  [3] t_11 (ref)
                    --  [4] val_3 (copy)
                    --  [5] v26 (copy)

                    v17:Fire()
                    task.defer(arg9.ScrollTo, arg9, t_11[val_3], v26[1])
                end)
                ButtonEffect_m:Add(v28.Button)
            end
        end

        v25.Parent = arg9._is_open and v11.Container.Details.Changes or nil
        table.insert(arg9._elements, { v25, v11.Container.Details.Changes })
        local Layout = v25.Slots.Layout

        local function update() -- line: 281
            -- upvalues:
            --  [1] v25 (copy)
            --  [2] Layout (copy)

            v25.Size = UDim2.new(1, 0, 0, Layout.AbsoluteContentSize.Y)
        end

        Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(update)
        v25.Size = UDim2.new(1, 0, 0, Layout.AbsoluteContentSize.Y)
    end

    local function generate_content_summary(arg16) -- line: 289
        -- upvalues:
        --  [1] PatchNoteContentSummarySlot (ref)
        --  [2] v22 (ref)
        --  [3] RewardSlot_m (ref)
        --  [4] v21 (ref)
        --  [5] ItemLibrary_m (ref)
        --  [6] t_11 (copy)
        --  [7] add_to_collapsed_list (copy)
        --  [8] arg9 (copy)
        --  [9] v11 (copy)

        local v33 = arg16[3]

        for index_1 = 1, math.ceil(#v33 / 7) do
            local v34 = PatchNoteContentSummarySlot:Clone()
            v22 += 1
            v34.LayoutOrder = v22
            v34.Slots.Layout.HorizontalAlignment = Enum.HorizontalAlignment[arg16[2] or "Center"]

            for index_2 = (index_1 - 1) * 7 + 1, index_1 * 7 do
                local v35 = v33[index_2]

                if v35 then
                    local v36 = if typeof(v35) == "table" then v35 else { Name = v35 }
                    local v37 = RewardSlot_m.new(v36)
                    v37.Frame.LayoutOrder = index_2
                    v37:SetParent(v34.Slots)

                    if v21 and ItemLibrary_m.Items[v36.Name] then
                        t_11[v36.Name] = v34
                    end
                end
            end

            add_to_collapsed_list(v34, nil, 3)
            local Layout_1 = arg9._is_open and v11.Container.Details.Changes or nil
            v34.Parent = Layout_1
            table.insert(arg9._elements, { v34, v11.Container.Details.Changes })
            local Layout_1 = v34.Slots.Layout
            Layout_1:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() --[[ update ]] -- line: 320
                -- upvalues:
                --  [1] v34 (copy)
                --  [2] Layout_1 (copy)

                v34.Size = UDim2.new(1, 0, 0, Layout_1.AbsoluteContentSize.Y)
            end)
            v34.Size = UDim2.new(1, 0, 0, Layout_1.AbsoluteContentSize.Y)
        end
    end

    local function generate_thumbnail(arg17) -- line: 329
        -- upvalues:
        --  [1] PatchNoteThumbnailSlot (ref)
        --  [2] v22 (ref)
        --  [3] add_to_collapsed_list (copy)
        --  [4] arg9 (copy)
        --  [5] v11 (copy)

        local v40 = arg17[2]
        local v41 = arg17[3]
        local v42 = PatchNoteThumbnailSlot:Clone()
        v22 += 1
        v42.LayoutOrder = v22
        v42.Thumbnail.Image = v40
        v42.Title.Text = v41
        v42.Title.AutoLocalize = false
        add_to_collapsed_list(v42)
        v42.Parent = arg9._is_open and v11.Container.Details.Changes or nil
        table.insert(arg9._elements, { v42, v11.Container.Details.Changes })
    end

    local function generate_text(arg18) -- line: 343
        -- upvalues:
        --  [1] t_5 (ref)
        --  [2] _ (ref)
        --  [3] v20 (ref)
        --  [4] t_10 (ref)
        --  [5] PatchNoteChangeSlot (ref)
        --  [6] v22 (ref)
        --  [7] arg9 (copy)
        --  [8] v11 (copy)
        --  [9] v21 (ref)
        --  [10] ItemLibrary_m (ref)
        --  [11] WeaponStatusHandler_m (ref)
        --  [12] t_11 (copy)
        --  [13] add_to_collapsed_list (copy)

        local v44 = arg18[1]
        local v45 = arg18[2]
        local v46 = t_5[v44]
        assert(v46 ~= nil, v44, arg18)

        if v44 == "Title" then
            _ = arg18
            v20 = 0
            t_10 = nil
        end

        local v48 = nil

        if v46.NewLine then
            v48 = PatchNoteChangeSlot:Clone()
            v22 += 1
            v48.LayoutOrder = v22
            v48.Text = ""
            v48.Size = UDim2.new(v48.Size.X.Scale, 0, v48.Size.Y.Scale * v46.NewLine, 0)
            v48.AutoLocalize = false
            v48.Parent = arg9._is_open and v11.Container.Details.Changes or nil
            table.insert(arg9._elements, { v48, v11.Container.Details.Changes })
        end

        local v50 = PatchNoteChangeSlot:Clone()
        v22 += 1
        v50.LayoutOrder = v22
        v50.Text = string.format(
            "%s%s<font weight=\"%s\">%s</font>",
            string.rep(" ", v46.Spaces),
            v46.Prefix,
            v46.Weight,
            v45
        )
        v50.TextTransparency = v46.Transparency
        v50.Size = UDim2.new(
            v50.Size.X.Scale,
            0,
            v50.Size.Y.Scale * math.ceil(#v45 / 80) * v46.Size,
            0
        )
        v50.AutoLocalize = false
        v50.Parent = arg9._is_open and v11.Container.Details.Changes or nil
        table.insert(arg9._elements, { v50, v11.Container.Details.Changes })

        if v21 and v44 == "Header" and ItemLibrary_m.Items[v45] then
            WeaponStatusHandler_m:ApplyItemStatusToText(v50, ItemLibrary_m.Items[v45].Status)
            t_11[v45] = v50
        end

        add_to_collapsed_list(v50, v48)
    end

    local _ = function(arg19) --[[ generate ]] -- line: 383
        -- upvalues:
        --  [1] generate_thumbnail (copy)
        --  [2] generate_balancing_overview (copy)
        --  [3] generate_content_summary (copy)
        --  [4] generate_text (copy)

        local v52 = arg19[1]

        if v52 == "Thumbnail" then
            return generate_thumbnail(arg19)
        end

        if v52 == "BalancingOverview" then
            return generate_balancing_overview(arg19)
        end

        if v52 == "ContentSummary" then
            return generate_content_summary(arg19)
        end

        return generate_text(arg19)
    end

    local v56, v63

    for _, val_4 in pairs(v10.Changes) do
        if typeof(val_4[1]) == "function" then
            local v53 = pairs
            local v54 = val_4[1]
            local g_select = select
            local _ = g_select(2, table.unpack(val_4))

            for _, val_5 in v53(v54(g_select(2, table.unpack(val_4)))) do
                v56 = val_5[1]

                if v56 == "Thumbnail" then
                    local v57 = val_5[2]
                    local v58 = val_5[3]
                    local v59 = PatchNoteThumbnailSlot:Clone()
                    v22 += 1
                    v59.LayoutOrder = v22
                    v59.Thumbnail.Image = v57
                    v59.Title.Text = v58
                    v59.Title.AutoLocalize = false
                    add_to_collapsed_list(v59)
                    local v60 = arg9._is_open and v11.Container.Details.Changes or nil
                    v59.Parent = v60
                    table.insert(arg9._elements, { v59, v11.Container.Details.Changes })
                elseif v56 == "BalancingOverview" then
                    local _ = generate_balancing_overview(val_5)
                elseif v56 == "ContentSummary" then
                    local _ = generate_content_summary(val_5)
                else
                    v63 = generate_text(val_5)
                end
            end
        else
            local v64 = val_4[1]

            if v64 == "Thumbnail" then
                local v65 = val_4[2]
                local v66 = val_4[3]
                local v67 = PatchNoteThumbnailSlot:Clone()
                v22 += 1
                v67.LayoutOrder = v22
                v67.Thumbnail.Image = v65
                v67.Title.Text = v66
                v67.Title.AutoLocalize, v56, v63 = false, add_to_collapsed_list, v67
                v56(v63)
                local v68 = arg9._is_open and v11.Container.Details.Changes or nil
                v67.Parent = v68
                table.insert(arg9._elements, { v67, v11.Container.Details.Changes })
            elseif v64 == "BalancingOverview" then
                local _ = generate_balancing_overview(val_4)
            elseif v64 == "ContentSummary" then
                local _ = generate_content_summary(val_4)
            else
                local _ = generate_text(val_4)
            end
        end
    end

    v18 = false
    arg9.ViewMoreButton.Visible = true
end

function t_6._UpdateList(arg20) -- line: 411
    arg20.CloseButton.Position = UDim2.new(0.975, 0, 0.0225, arg20.PageFrame.AbsoluteSize.Y * 0.125)
    arg20.ViewMoreButton.Position = arg20.CloseButton.Position + UDim2.new(0, 0, 0.05, 0)
    arg20.List.Position = UDim2.new(0.5, 9, 0, arg20.PageFrame.AbsoluteSize.Y * 0.125)
    arg20.List.Size = UDim2.new(0.85, 0, 0, arg20.PageFrame.AbsoluteSize.Y * 0.75)
    arg20.List.CanvasSize = UDim2.new(0, 0, 0, arg20.Layout.AbsoluteContentSize.Y)
    arg20.ViewMoreList.Position = UDim2.new(0.5, 9, 0, arg20.PageFrame.AbsoluteSize.Y * 0.125)
    arg20.ViewMoreList.Size = UDim2.new(0.85, 0, 0, arg20.PageFrame.AbsoluteSize.Y * 0.75)
    arg20.ViewMoreList.CanvasSize = UDim2.new(0, 0, 0, arg20.ViewMoreLayout.AbsoluteContentSize.Y)
end

function t_6._UpdateSize(arg21) -- line: 422
    -- upvalues:
    --  [1] UILibrary_m (copy)

    arg21.PageContainer.Size = UDim2.new(
        0,
        math.min(1000, UILibrary_m.MainGui.AbsoluteSize.X * 0.875),
        1,
        0
    )
end

function t_6._SetupViewMoreSlots(arg22) -- line: 426
    -- upvalues:
    --  [1] t (copy)
    --  [2] PatchNotes (copy)
    --  [3] ViewPatchNotesSlot (copy)
    --  [4] Utility_m (copy)
    --  [5] ButtonEffect_m (copy)

    for key_6, val_6 in pairs(t) do
        local color = require(PatchNotes:WaitForChild(val_6))
        local v73 = ViewPatchNotesSlot:Clone()
        v73.Button.Title.Text = color.Title
        local v74 = color.Subtitle
        local Subtitle = v73.Button.Subtitle

        if not v74 then
            v74 = color.Date
        end

        Subtitle.Text = v74
        v73.Button.Thumbnail.Image = color.Image
        v73.LayoutOrder = -key_6
        v73.Parent = arg22.ViewMoreContainer
        v73.Button.MouseButton1Click:Connect(function() -- line: 437
            -- upvalues:
            --  [1] arg22 (copy)
            --  [2] val_6 (copy)

            arg22:SetViewMoreListVisible(false)
            task.defer(arg22._Generate, arg22, val_6)
        end)
        local color = Color3.fromRGB(64, 64, 64)
        local color_1 = Color3.fromRGB(255, 255, 255)

        local function v74(arg23) --[[ set ]] -- line: 446
            -- upvalues:
            --  [1] v73 (copy)
            --  [2] color (copy)
            --  [3] color_1 (copy)

            v73.Button.Thumbnail.ImageTransparency = 0.375 - 0.375 * arg23
            v73.Button.Thumbnail.ImageColor3 = color:Lerp(color_1, arg23)
            v73.Button.Stroke.Size = UDim2.new(1, 2 - 8 * arg23, 1, 2 - 8 * arg23)
            v73.Button.Stroke.UIStroke.Thickness = 4 * arg23
        end

        v73.Button.Thumbnail.ImageTransparency = 0.375
        v73.Button.Thumbnail.ImageColor3 = color:Lerp(color_1, 0)
        v73.Button.Stroke.Size = UDim2.new(1, 2, 1, 2)
        v73.Button.Stroke.UIStroke.Thickness = 0
        local v76 = 0
        local v77 = 0

        local _ = function(arg24) --[[ tween ]] -- line: 458
            -- upvalues:
            --  [1] v76 (ref)
            --  [2] Utility_m (ref)
            --  [3] v77 (ref)
            --  [4] v74 (copy)

            v76 += 1
            local v78 = v76
            local v79 = Utility_m
            v79:RenderstepForLoop(v77, arg24, 0.15 * (if not (arg24 < v77) then 1 else -1), function(
                arg25
            ) -- line: 462
                -- upvalues:
                --  [1] v78 (copy)
                --  [2] v76 (ref)
                --  [3] v77 (ref)
                --  [4] v74 (ref)

                if v78 ~= v76 then
                    return true
                end

                v77 = arg25
                v74(1 - (1 - v77) ^ 3)
            end)
        end

        v73.Button.MouseLeave:Connect(function() -- line: 472
            -- upvalues:
            --  [1] v76 (ref)
            --  [2] Utility_m (ref)
            --  [3] v77 (ref)
            --  [4] v74 (copy)

            v76 += 1
            local v83 = v76
            local v84 = Utility_m
            v84:RenderstepForLoop(v77, 0, 0.15 * (if not (0 < v77) then 1 else -1), function(arg26) -- line: 462
                -- upvalues:
                --  [1] v83 (copy)
                --  [2] v76 (ref)
                --  [3] v77 (ref)
                --  [4] v74 (ref)

                if v83 ~= v76 then
                    return true
                end

                v77 = arg26
                v74(1 - (1 - v77) ^ 3)
            end)
        end)
        v73.Button.SelectionLost:Connect(function() -- line: 476
            -- upvalues:
            --  [1] v76 (ref)
            --  [2] Utility_m (ref)
            --  [3] v77 (ref)
            --  [4] v74 (copy)

            v76 += 1
            local v88 = v76
            local v89 = Utility_m
            v89:RenderstepForLoop(v77, 0, 0.15 * (if not (0 < v77) then 1 else -1), function(arg27) -- line: 462
                -- upvalues:
                --  [1] v88 (copy)
                --  [2] v76 (ref)
                --  [3] v77 (ref)
                --  [4] v74 (ref)

                if v88 ~= v76 then
                    return true
                end

                v77 = arg27
                v74(1 - (1 - v77) ^ 3)
            end)
        end)
        v73.Button.MouseEnter:Connect(function() -- line: 480
            -- upvalues:
            --  [1] v76 (ref)
            --  [2] Utility_m (ref)
            --  [3] v77 (ref)
            --  [4] v74 (copy)

            v76 += 1
            local v93 = v76
            local v94 = Utility_m
            v94:RenderstepForLoop(v77, 1, 0.15 * (if not (1 < v77) then 1 else -1), function(arg28) -- line: 462
                -- upvalues:
                --  [1] v93 (copy)
                --  [2] v76 (ref)
                --  [3] v77 (ref)
                --  [4] v74 (ref)

                if v93 ~= v76 then
                    return true
                end

                v77 = arg28
                v74(1 - (1 - v77) ^ 3)
            end)
        end)
        v73.Button.SelectionGained:Connect(function() -- line: 484
            -- upvalues:
            --  [1] v76 (ref)
            --  [2] Utility_m (ref)
            --  [3] v77 (ref)
            --  [4] v74 (copy)

            v76 += 1
            local v98 = v76
            local v99 = Utility_m
            v99:RenderstepForLoop(v77, 1, 0.15 * (if not (1 < v77) then 1 else -1), function(arg29) -- line: 462
                -- upvalues:
                --  [1] v98 (copy)
                --  [2] v76 (ref)
                --  [3] v77 (ref)
                --  [4] v74 (ref)

                if v98 ~= v76 then
                    return true
                end

                v77 = arg29
                v74(1 - (1 - v77) ^ 3)
            end)
        end)
        ButtonEffect_m:Add(v73.Button, nil, { ReleaseRatio = 0.975, HoverRatio = 0.975 })
    end
end

function t_6._Init(arg30) -- line: 492
    -- upvalues:
    --  [1] PlayerDataController_m (copy)
    --  [2] CONSTANTS_m (copy)
    --  [3] ReplicatedStorage (copy)
    --  [4] UILibrary_m (copy)
    --  [5] ButtonEffect_m (copy)

    arg30.CloseButton.MouseButton1Click:Connect(function() -- line: 493
        -- upvalues:
        --  [1] PlayerDataController_m (ref)
        --  [2] CONSTANTS_m (ref)
        --  [3] ReplicatedStorage (ref)
        --  [4] arg30 (copy)

        if PlayerDataController_m:Get("LastPatchNotesVersion") ~= CONSTANTS_m.GAME_VERSION then
            ReplicatedStorage.Remotes.Misc.ViewedPatchNotes:FireServer()
        end

        arg30:CloseRequest()
    end)
    arg30.Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() -- line: 501
        -- upvalues:
        --  [1] arg30 (copy)

        arg30:_UpdateList()
    end)
    arg30.ViewMoreLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() -- line: 505
        -- upvalues:
        --  [1] arg30 (copy)

        arg30:_UpdateList()
    end)
    arg30.PageFrame:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- line: 509
        -- upvalues:
        --  [1] arg30 (copy)

        arg30:_UpdateList()
    end)
    arg30.ViewMoreButton.MouseButton1Click:Connect(function() -- line: 513
        -- upvalues:
        --  [1] arg30 (copy)

        arg30:SetViewMoreListVisible(true)
    end)
    UILibrary_m.MainGui:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- line: 517
        -- upvalues:
        --  [1] arg30 (copy)

        arg30:_UpdateSize()
    end)
    arg30:_SetupViewMoreSlots()
    arg30:_UpdateSize()
    arg30:_UpdateList()
    arg30:SetViewMoreListVisible(false)
    ButtonEffect_m:Add(arg30.CloseButton)
    ButtonEffect_m:Add(arg30.ViewMoreButton)
end

return t_6._new()
