local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")
local BetterDebris_m = require(ReplicatedStorage.Modules.BetterDebris)
local DuelLibrary_m = require(ReplicatedStorage.Modules.DuelLibrary)
local ItemLibrary_m = require(ReplicatedStorage.Modules.ItemLibrary)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local Signal_m = require(ReplicatedStorage.Modules.Signal)
local ComplianceController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("ComplianceController")
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
local WeaponStatusHandler_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("WeaponStatusHandler")
)
local TeammateSlot_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("TeammateSlot")
)
local UILibrary_m = require(Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("UILibrary"))
local EliminatedCard = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild(
    "EliminatedCard"
)
local t = {}
t.__index = t

function t._new() -- line: 23
    -- upvalues:
    --  [1] t (copy)
    --  [2] Signal_m (copy)
    --  [3] UILibrary_m (copy)

    local t_1 = setmetatable({}, t)
    t_1.VisibilityChanged = Signal_m.new()
    t_1.Frame = UILibrary_m:GetTo("MainFrame", "EliminatedEffect")
    t_1._last_eliminated_card = nil
    t_1:_Init()

    return t_1
end

function t.IsVisible(arg1) -- line: 41
    return arg1._last_eliminated_card ~= nil
end

function t.Play(
    arg2,
    arg3,
    arg4,
    arg5,
    arg6,
    arg7
) -- line: 45
    -- upvalues:
    --  [1] Utility_m (copy)
    --  [2] Players (copy)
    --  [3] EliminatedCard (copy)
    --  [4] ComplianceController_m (copy)
    --  [5] ItemLibrary_m (copy)
    --  [6] DuelLibrary_m (copy)
    --  [7] WeaponStatusHandler_m (copy)
    --  [8] BetterDebris_m (copy)
    --  [9] DuelController_m (copy)
    --  [10] TeammateSlot_m (copy)

    if arg2._last_eliminated_card then
        arg2._last_eliminated_card:Destroy()
    end

    Utility_m:CreateSound(
        "rbxassetid://17016581922",
        0.75,
        1 + 0.1 * math.random(),
        script,
        true,
        10
    )

    if not arg3 then
        arg3 = Players.LocalPlayer
    end

    local v11 = arg3 == Players.LocalPlayer
    local v12 = if typeof(arg3) ~= "Instance" then false else true
    local v13 = if typeof(arg3) == "table" then arg3 else false
    local v14 = EliminatedCard:Clone()
    local Description = v14.Frame.Container.Clip.Container.Description
    local v16 = arg6 and " with " .. arg6 or ""
    Description.Text = "eliminated " .. (if v11 then "yourself" else "you") .. v16
    local Username = v14.Frame.Container.Clip.Container.Username
    Username.Text = not v11 and v12 and arg3.Name ~= arg3.DisplayName and "@" .. arg3.Name or ""
    local Player = v14.Frame.Container.Clip.Container.Player
    Player.Text = if v11 then "You" else v12 and ComplianceController_m:GetName(arg3) or v13 and v13.DisplayName or "???"
    local Player_1 = v14.Frame.Container.Clip.Container.Player
    Player_1.Position = if v14.Frame.Container.Clip.Container.Username.Text ~= "" then UDim2.new(
        0.2,
        0,
        0.225,
        0
    ) else UDim2.new(0.2, 0, 0.35, 0) or UDim2.new(0.2, 0, 0.225, 0)
    v14.Frame.Container.Clip.Container.Weapon.Image = ItemLibrary_m:GetViewModelImage(
        arg6,
        arg7,
        true
    ) or ""
    local Background = v14.Frame.Container.Clip.Container.Background
    Background.ImageColor3 = v12 and DuelLibrary_m:GetTeamColor(arg3:GetAttribute("TeamID")) or DuelLibrary_m.EMPTY_TEAM_COLOR
    local FakeEliminator = v14.Frame.Container.Clip.Container.PlayerSlot.FakeEliminator
    FakeEliminator.Image = v13 and v13.Image or ""
    v14.Frame.Container.Weapon.Image = v14.Frame.Container.Clip.Container.Weapon.Image

    if arg6 and ItemLibrary_m.Items[arg6] then
        WeaponStatusHandler_m:ApplyItemStatusToText(
            v14.Frame.Container.Clip.Container.Description,
            ItemLibrary_m.Items[arg6].Status
        )
    end

    v14.Parent = arg2.Frame
    BetterDebris_m:AddItem(v14, 10)
    arg2:_SetLastEliminatedCard(v14)

    if v12 then
        v13 = DuelController_m:GetDuel(Players.LocalPlayer)
        v11 = v13

        if v11 then
            v11 = v13:GetDueler(arg3)
        end

        local v20 = v13

        if v20 then
            v20 = v13.IsRanked
        end

        v13 = if v20 then nil else arg3:GetAttribute("StatisticDuelsWinStreak")
        local v21 = if v20 then nil else arg3:GetAttribute("Level")
        local DisplayELO = arg3:GetAttribute("DisplayELO")
        local v22 = TeammateSlot_m.new(
            arg3.UserId,
            arg4,
            arg5,
            nil,
            nil,
            v13,
            v21
        )
        v22.SlotFrame.Parent = v14.Frame.Container.Clip.Container.PlayerSlot

        if v20 and v11 and v11:CanShowRankToLocalPlayer() then
            v22:SetDisplayELO(DisplayELO)
        end
    end

    v14.Frame.Container.Size = UDim2.new(0, 0, 1, 0)
    v14.Frame.Container:TweenSize(
        UDim2.new(1, 0, 1, 0),
        "Out",
        "Quint",
        1,
        true
    )
    wait(5)
    Utility_m:RenderstepForLoop(0, 100, 5, function(arg8) -- line: 100
        -- upvalues:
        --  [1] v14 (copy)

        v14.GroupTransparency = (arg8 / 100) ^ 5
    end)
    v14:Destroy()

    if arg2._last_eliminated_card ~= v14 then
        return
    end

    arg2:_SetLastEliminatedCard(nil)
end

function t._UpdateVisibility(arg9) -- line: 119
    -- upvalues:
    --  [1] GuiService (copy)

    arg9.Frame.Visible = not GuiService.MenuIsOpen
end

function t._SetLastEliminatedCard(arg10, arg11) -- line: 123
    arg10._last_eliminated_card = arg11
    arg10.VisibilityChanged:Fire()
end

function t._HookLocalFighter(arg12) -- line: 128
    -- upvalues:
    --  [1] FighterController_m (copy)
    --  [2] ControlsController_m (copy)

    FighterController_m:WaitForLocalFighter().EntityAdded:Connect(function() -- line: 131
        -- upvalues:
        --  [1] arg12 (copy)
        --  [2] ControlsController_m (ref)

        if arg12._last_eliminated_card and ControlsController_m.CurrentControls == "Touch" then
            arg12._last_eliminated_card:Destroy()
            arg12:_SetLastEliminatedCard(nil)
        end
    end)
end

function t._Init(arg13) -- line: 139
    -- upvalues:
    --  [1] GuiService (copy)

    GuiService:GetPropertyChangedSignal("MenuIsOpen"):Connect(function() -- line: 140
        -- upvalues:
        --  [1] arg13 (copy)

        arg13:_UpdateVisibility()
    end)
    arg13:_UpdateVisibility()
    task.defer(arg13._HookLocalFighter, arg13)
end

return t._new()
