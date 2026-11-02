local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local CONSTANTS_m = require(ReplicatedStorage.Modules.CONSTANTS)
local EventLibrary_m = require(ReplicatedStorage.Modules.EventLibrary)
local DuelLibrary_m = require(ReplicatedStorage.Modules.DuelLibrary)
local TeammateSlot_m = require(Players.LocalPlayer.PlayerScripts.Modules.TeammateSlot)
local LobbyVisuals = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("LobbyVisuals")
local QueuePadPlayerSlot = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild(
    "QueuePadPlayerSlot"
)
local t = {}
t.__index = t

function t.new(arg1) -- line: 15
    -- upvalues:
    --  [1] t (copy)

    local t_1 = setmetatable({}, t)
    t_1.ClientQueuePad = arg1
    t_1._visuals_folder = t_1.ClientQueuePad:Get("Model"):WaitForChild("Visuals")
    t_1._teammate_slots = {}
    t_1._team_slots = {}
    t_1._pads = {}
    t_1._surface_guis = {}
    t_1:_Init()

    return t_1
end

function t.Destroy(arg2) -- line: 35
    for _, val in pairs(arg2._surface_guis) do
        val:Destroy()
    end
end

function t._UpdateQueueName(arg3) -- line: 45
    -- upvalues:
    --  [1] DuelLibrary_m (copy)
    --  [2] CONSTANTS_m (copy)

    local v1 = arg3.ClientQueuePad:Get("NumTeams")
    local v2 = arg3.ClientQueuePad:Get("PlayersPerTeam")
    local v3 = arg3.ClientQueuePad:Get("InfinitePlayersPerTeam")
    local v4 = arg3.ClientQueuePad:GetActualQueueName()
    local v5 = DuelLibrary_m.MatchmakingQueues[v4]

    for key_1, val_1 in pairs(arg3._surface_guis) do
        local Warning = val_1.MainFrame.Warning
        local v6 = if key_1 ~= 1 then false else if not v5 then CONSTANTS_m.IS_PUBLIC_SERVER else not v5.AreStreaksDisabled() and CONSTANTS_m.IS_PUBLIC_SERVER
        Warning.Visible = v6
    end

    v4 = v5 and v5.TitleName
    local string_rep = string.rep((if not v3 then v2 else "\226\136\158") .. "v", v1)
    arg3._visuals_folder:WaitForChild("QueueName"):WaitForChild("Players"):WaitForChild(
        "SurfaceGui"
    ):WaitForChild("TextLabel").Text = string.sub(string_rep, 1, #string_rep - 1)
    arg3._visuals_folder:WaitForChild("QueueName"):WaitForChild("Title"):WaitForChild("SurfaceGui"):WaitForChild(
        "Frame"
    ):WaitForChild("TextLabel").Text = v4 or ""
    arg3._visuals_folder:WaitForChild("QueueName"):WaitForChild("Title"):WaitForChild("SurfaceGui").Enabled = v4
    arg3._visuals_folder:WaitForChild("QueueName"):WaitForChild("Title").Transparency = if v4 then 0.4 else 1
end

function t._Update(arg4) -- line: 67
    -- upvalues:
    --  [1] TeammateSlot_m (copy)
    --  [2] DuelLibrary_m (copy)
    --  [3] EventLibrary_m (copy)

    for _, val_2 in pairs(arg4._teammate_slots) do
        val_2:Destroy()
    end

    arg4._teammate_slots = {}
    local v10 = arg4.ClientQueuePad:Get("PlayersPerTeam")
    local v11 = arg4.ClientQueuePad:Get("InfinitePlayersPerTeam")
    local v12 = arg4.ClientQueuePad:GetClientFightersWaiting()

    for key_3, val_3 in pairs(v12) do
        local v13 = arg4._team_slots[key_3]
        local v14 = v11 and #val_3 or v10
        local v17 = if not v11 then v10 else "\226\136\158"
        v13.Slot.Title.Text = #val_3 .. "/" .. v17
        v13.Slot.Full.Visible = if v10 <= #val_3 then not v11 else false
        v13.SetCellSize(v14)
        v13.CreatePlayerSlots(v14)

        for key_4, val_4 in pairs(val_3) do
            v14 = v13.PlayerSlots[key_4]

            if v14 then
                local v20 = TeammateSlot_m.new(
                    val_4.Player.UserId,
                    val_4:Get("Controls"),
                    1,
                    false,
                    true,
                    val_4.Player:GetAttribute("StatisticDuelsWinStreak"),
                    val_4.Player:GetAttribute("Level")
                )
                v20.SlotFrame.Container.Background.Visible = false
                v20.SlotFrame.Parent = v14
                table.insert(arg4._teammate_slots, v20)
            end
        end
    end

    local v25

    for key_5, val_5 in pairs(arg4._pads) do
        local v21 = DuelLibrary_m.Teams[key_5]
        v10 = #v12[key_5] > 0 and true
        local v22 = not v10
        local v23 = v10 and v21.PadColor or Color3.fromRGB(202, 203, 209)
        local v24 = v10 and v21.PadColor2 or Color3.fromRGB(252, 250, 255)

        if EventLibrary_m.LOBBY_VISUALS_PROFILE == "Festive" then
            val_5.Outer.Anchored = v22
            val_5.Inner.Anchored = v22
            v25 = if not v10 then 1 else 0.02
            val_5.Glow.Transparency = v25
            v25 = if not v10 then 1 else 0.02
            val_5.Outer.Transparency = v25
            v25 = if not v10 then 1 else 0.02
            val_5.Inner.Transparency = v25
            v25 = if not v10 then 1 else 0
            val_5.Extra.Ribbon.Transparency = v25
        elseif EventLibrary_m.LOBBY_VISUALS_PROFILE == "Spooky" then
            val_5.Outer.Anchored = v22
            val_5.Inner.Anchored = v22
            v25 = if not v10 then 1 else 0.02
            val_5.Glow.Transparency = v25
            val_5.Glow.Color = v23
        else
            val_5.Outer.Anchored = v22
            val_5.Outer2.Anchored = v22
            val_5.Outer3.Anchored = v22
            val_5.Inner.Anchored = v22
            val_5.Inner2.Anchored = v22
            val_5.Inner3.Anchored = v22
            v25 = if not v10 then 1 else 0.02
            val_5.Glow.Transparency = v25
            v25 = if not v10 then 0.75 else 0
            val_5.Outer.Transparency = v25
            v25 = if not v10 then 0.75 else 0
            val_5.Inner.Transparency = v25
            val_5.Glow.Color = v23
            val_5.Inner.Color = v23
            val_5.Outer.Color = v23
            val_5.Inner2.Color = v24
            val_5.Inner3.Color = v24
            val_5.Outer2.Color = v24
            val_5.Outer3.Color = v24
        end
    end

    arg4:_UpdateQueueName()
end

function t._SetupSurfaceGui(arg5, arg6) -- line: 144
    -- upvalues:
    --  [1] DuelLibrary_m (copy)
    --  [2] LobbyVisuals (copy)
    --  [3] EventLibrary_m (copy)
    --  [4] QueuePadPlayerSlot (copy)
    --  [5] Players (copy)

    local v26 = DuelLibrary_m.Teams[arg6]
    local v27 = LobbyVisuals:FindFirstChild(EventLibrary_m.LOBBY_VISUALS_PROFILE) and LobbyVisuals[EventLibrary_m.LOBBY_VISUALS_PROFILE]:FindFirstChild(
        "QueuePadBoardGui"
    ) or LobbyVisuals.Default.QueuePadBoardGui
    local v28 = v27:Clone()
    v28.Name = v28.Name .. arg5.ClientQueuePad:Get("Model").Name
    v27 = LobbyVisuals:FindFirstChild(EventLibrary_m.LOBBY_VISUALS_PROFILE) and LobbyVisuals[EventLibrary_m.LOBBY_VISUALS_PROFILE]:FindFirstChild(
        "QueuePadTeamSlot"
    ) or LobbyVisuals.Default.QueuePadTeamSlot
    local v29 = v27:Clone()
    v29.Logo.Image = v26.Logo
    v29.LayoutOrder = arg6
    v29.Parent = v28.MainFrame.TeamSlotContainer
    v27 = {}

    local function create_player_slots(arg7) -- line: 159
        -- upvalues:
        --  [1] v27 (copy)
        --  [2] QueuePadPlayerSlot (ref)
        --  [3] v29 (copy)

        for _, val_6 in pairs(v27) do
            val_6:Destroy()
        end

        table.clear(v27)

        for index = 1, arg7 do
            local v30 = QueuePadPlayerSlot:Clone()
            v30.LayoutOrder = index
            v30.Parent = v29.Players
            v27[index] = v30
        end
    end

    local function set_cell_size(arg8) -- line: 174
        -- upvalues:
        --  [1] v29 (copy)

        local maximum = math.max(arg8, 1)
        local squareRoot = math.sqrt(maximum)
        local v31 = 1 / math.ceil(squareRoot)
        v29.Players.Layout.CellSize = UDim2.new(v31, -1, v31, -1)
    end

    v28.Adornee = arg5._visuals_folder:WaitForChild("Board" .. arg6)
    v28.Parent = Players.LocalPlayer.PlayerGui
    arg5._surface_guis[arg6] = v28
    arg5._team_slots[arg6] = {
        Slot = v29,
        PlayerSlots = v27,
        SetCellSize = set_cell_size,
        CreatePlayerSlots = create_player_slots
    }
end

function t._SetupPad(arg9, arg10) -- line: 194
    arg9.ClientQueuePad:Get("Model"):WaitForChild("Important"):WaitForChild("Team" .. arg10).Transparency = 1
    local v35 = arg9._visuals_folder:WaitForChild("Team" .. arg10)
    local v36 = v35:Clone()
    v36.Outer.CanCollide = false
    v36.Outer.CanTouch = false
    v36.Outer.CanQuery = false
    v36.Outer.Anchored = true
    local Attachment = Instance.new("Attachment")
    Attachment.CFrame = CFrame.Angles(0, 0, 1.5707963267948966)
    Attachment.Parent = v36.Outer
    local AlignPosition = Instance.new("AlignPosition")
    AlignPosition.RigidityEnabled = true
    AlignPosition.Mode = Enum.PositionAlignmentMode.OneAttachment
    AlignPosition.Position = v36.Outer.Position
    AlignPosition.Attachment0 = Attachment
    AlignPosition.Parent = v36.Outer
    local AlignOrientation = Instance.new("AlignOrientation")
    AlignOrientation.CFrame = Attachment.WorldCFrame
    AlignOrientation.Mode = Enum.OrientationAlignmentMode.OneAttachment
    AlignOrientation.AlignType = Enum.AlignType.PrimaryAxisParallel
    AlignOrientation.RigidityEnabled = true
    AlignOrientation.Attachment0 = Attachment
    AlignOrientation.Parent = v36.Outer
    local AngularVelocity = Instance.new("AngularVelocity")
    AngularVelocity.AngularVelocity = Vector3.new(0, 2 * (if arg10 % 2 == 0 then 1 else -1), 0)
    AngularVelocity.MaxTorque = 10000
    AngularVelocity.Attachment0 = Attachment
    AngularVelocity.Parent = v36.Outer
    v36.Inner.CanCollide = false
    v36.Inner.CanTouch = false
    v36.Inner.CanQuery = false
    v36.Inner.Anchored = true
    local Attachment_1 = Instance.new("Attachment")
    Attachment_1.CFrame = CFrame.Angles(0, 0, 1.5707963267948966)
    Attachment_1.Parent = v36.Inner
    local AlignPosition_1 = Instance.new("AlignPosition")
    AlignPosition_1.RigidityEnabled = true
    AlignPosition_1.Mode = Enum.PositionAlignmentMode.OneAttachment
    AlignPosition_1.Position = v36.Inner.Position
    AlignPosition_1.Attachment0 = Attachment_1
    AlignPosition_1.Parent = v36.Inner
    local AlignOrientation_1 = Instance.new("AlignOrientation")
    AlignOrientation_1.CFrame = Attachment_1.WorldCFrame
    AlignOrientation_1.Mode = Enum.OrientationAlignmentMode.OneAttachment
    AlignOrientation_1.AlignType = Enum.AlignType.PrimaryAxisParallel
    AlignOrientation_1.RigidityEnabled = true
    AlignOrientation_1.Attachment0 = Attachment_1
    AlignOrientation_1.Parent = v36.Inner
    local AngularVelocity_1 = Instance.new("AngularVelocity")
    AngularVelocity_1.AngularVelocity = Vector3.new(0, -2 * (if arg10 % 2 == 0 then 1 else -1), 0)
    AngularVelocity_1.MaxTorque = 10000
    AngularVelocity_1.Attachment0 = Attachment_1
    AngularVelocity_1.Parent = v36.Inner
    v36.Parent = v35.Parent
    arg9._pads[arg10] = v36
    v35:Destroy()
end

function t._Setup(arg11) -- line: 265
    for index_1 = 1, arg11.ClientQueuePad:Get("NumTeams") do
        arg11:_SetupSurfaceGui(index_1)
        arg11:_SetupPad(index_1)
    end

    arg11:_Update()
end

function t._Init(arg12) -- line: 274
    arg12.ClientQueuePad.Activity:Connect(function() -- line: 275
        -- upvalues:
        --  [1] arg12 (copy)

        arg12:_Update()
    end)
    task.spawn(arg12._Setup, arg12)
end

return t
