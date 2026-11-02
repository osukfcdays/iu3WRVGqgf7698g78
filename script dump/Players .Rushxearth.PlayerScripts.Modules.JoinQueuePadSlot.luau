local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local CONSTANTS_m = require(ReplicatedStorage.Modules.CONSTANTS)
local Signal_m = require(ReplicatedStorage.Modules.Signal)
local FighterController_m = require(Players.LocalPlayer.PlayerScripts.Controllers.FighterController)
local ButtonEffect_m = require(Players.LocalPlayer.PlayerScripts.Modules.ButtonEffect)
local UILibrary_m = require(Players.LocalPlayer.PlayerScripts.Modules.UILibrary)
local JoinQueuePadPlayerSlot = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild(
    "JoinQueuePadPlayerSlot"
)
local JoinQueuePadTeamSlot = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild(
    "JoinQueuePadTeamSlot"
)
local JoinQueuePadTitleVS = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild(
    "JoinQueuePadTitleVS"
)
local JoinQueuePadSlot = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild(
    "JoinQueuePadSlot"
)
local t = {}
t.__index = t

function t.new(arg1) -- line: 18
    -- upvalues:
    --  [1] t (copy)
    --  [2] Signal_m (copy)
    --  [3] JoinQueuePadSlot (copy)

    local t_1 = setmetatable({}, t)
    t_1.VisibilityChanged = Signal_m.new()
    t_1.ClientQueuePad = arg1
    t_1.Frame = JoinQueuePadSlot:Clone()
    t_1._team_slots = {}
    t_1._extra_team_related_objects = {}
    t_1._update_hash = 0
    t_1:_Init()

    return t_1
end

function t.IsVisible(arg2) -- line: 39
    return arg2.Frame.Visible
end

function t._Update(arg3) -- line: 47
    -- upvalues:
    --  [1] CONSTANTS_m (copy)

    local v1 = arg3.ClientQueuePad:GetClientFightersWaiting()
    local v2 = 0

    for index = 1, arg3.ClientQueuePad:Get("NumTeams") do
        for index_1 = 1, arg3.ClientQueuePad:Get("PlayersPerTeam") do
            local v3 = arg3._team_slots[index].PlayerSlots[index_1]
            local v4 = v1[index][index_1]

            if v4 then
                v2 += 1
                v3.Headshot.Image = string.format(CONSTANTS_m.HEADSHOT_IMAGE, v4.Player.UserId)
                v3.Dots:RemoveTag("UILoadingDots")
                v3.Dots.Visible = false
            else
                v3.Headshot.Image = ""
                v3.Dots:AddTag("UILoadingDots")
                v3.Dots.Visible = true
            end
        end
    end

    v1 = if v2 > 0 then v2 < arg3.ClientQueuePad:Get("NumTeams") * arg3.ClientQueuePad:Get(
        "PlayersPerTeam"
    ) and true else false

    if not v1 then
        arg3._update_hash += 1
        arg3.Frame.Visible = false
        arg3.VisibilityChanged:Fire()

        return
    end

    task.spawn(function() -- line: 78
        -- upvalues:
        --  [1] arg3 (copy)

        local UpdateHash = arg3._update_hash
        wait(1)

        if UpdateHash ~= arg3._update_hash or arg3.Frame.Visible then
            return
        end

        local v6 = arg3
        v6._update_hash += 1
        arg3.Frame.Visible = true
        arg3.VisibilityChanged:Fire()
        arg3.Frame.Container.Position = UDim2.new(4, 0, 0, 0)
        arg3.Frame.Container:TweenPosition(
            UDim2.new(0, 0, 0, 0),
            "Out",
            "Quint",
            0.5,
            true
        )
    end)
end

function t._Generate(arg4) -- line: 95
    -- upvalues:
    --  [1] JoinQueuePadTeamSlot (copy)
    --  [2] JoinQueuePadPlayerSlot (copy)
    --  [3] JoinQueuePadTitleVS (copy)

    for _, val in pairs(arg4._team_slots) do
        val.Slot:Destroy()
    end

    for _, val_1 in pairs(arg4._extra_team_related_objects) do
        val_1:Destroy()
    end

    arg4._team_slots = {}
    arg4._extra_team_related_objects = {}
    local v7 = 1 / math.ceil((math.sqrt((arg4.ClientQueuePad:Get("PlayersPerTeam")))))
    local v8 = 0

    for index_2 = 1, arg4.ClientQueuePad:Get("NumTeams") do
        v8 += 1
        local v9 = JoinQueuePadTeamSlot:Clone()
        v9.LayoutOrder = v8
        v9.Container.Layout.CellSize = UDim2.new(v7, 0, v7, 0)
        v9.Container.Layout.StartCorner = if arg4.ClientQueuePad:Get("NumTeams") == 2 then if index_2 ~= 2 then Enum.StartCorner.TopLeft else Enum.StartCorner.TopRight or Enum.StartCorner.TopLeft else Enum.StartCorner.TopLeft
        v9.Parent = arg4.Frame.Container.Details
        local t_2 = {}

        for index_3 = 1, arg4.ClientQueuePad:Get("PlayersPerTeam") do
            local v11 = JoinQueuePadPlayerSlot:Clone()
            v11.LayoutOrder = index_3
            v11.Parent = v9.Container
            t_2[index_3] = v11
        end

        arg4._team_slots[index_2] = { Slot = v9, PlayerSlots = t_2 }

        if index_2 < arg4.ClientQueuePad:Get("NumTeams") then
            v8 += 1
            local v12 = JoinQueuePadTitleVS:Clone()
            v12.LayoutOrder = v8
            v12.Parent = arg4.Frame.Container.Details
            table.insert(arg4._extra_team_related_objects, v12)
        end
    end

    arg4.Frame.Size = UDim2.new(
        0.6666666666666666 + 0.3333333333333333 * (arg4.ClientQueuePad:Get("NumTeams") - 2),
        0,
        0.4,
        0
    )
end

function t._Setup(arg5) -- line: 145
    -- upvalues:
    --  [1] UILibrary_m (copy)

    arg5.Frame.Container.Background.ImageColor3 = UILibrary_m.BUTTON_BACKGROUND_COLOR
    arg5.Frame.Container.Background.ImageTransparency = UILibrary_m.BUTTON_BACKGROUND_TRANSPARENCY
end

function t._Init(arg6) -- line: 150
    -- upvalues:
    --  [1] FighterController_m (copy)
    --  [2] ButtonEffect_m (copy)

    arg6.Frame.Container.Join.MouseButton1Click:Connect(function() -- line: 151
        -- upvalues:
        --  [1] FighterController_m (ref)
        --  [2] arg6 (copy)

        if FighterController_m.LocalFighter and FighterController_m.LocalFighter:IsAlive() then
            FighterController_m.LocalFighter.Entity.Model:PivotTo(
                CFrame.new(arg6.ClientQueuePad:GetTeleportPosition()) * FighterController_m.LocalFighter.Entity.Model:GetPivot().Rotation
            )
        end
    end)
    arg6.ClientQueuePad.Activity:Connect(function(arg7) -- line: 157
        -- upvalues:
        --  [1] arg6 (copy)

        if arg7 == "PlayersPerTeam" then
            arg6:_Generate()
        end

        arg6:_Update()
    end)
    arg6:_Setup()
    arg6:_Generate()
    arg6:_Update()
    ButtonEffect_m:Add(arg6.Frame.Container.Join)
end

return t
