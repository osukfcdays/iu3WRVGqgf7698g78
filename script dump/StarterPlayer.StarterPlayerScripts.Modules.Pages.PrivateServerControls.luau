local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local CONSTANTS_m = require(ReplicatedStorage.Modules.CONSTANTS)
local SettingsInfo_m = require(ReplicatedStorage.Modules.SettingsInfo)
local DuelLibrary_m = require(ReplicatedStorage.Modules.DuelLibrary)
local _ = require(ReplicatedStorage.Modules.Utility)
local PrivateServerController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("PrivateServerController")
)
local _ = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("ComplianceController")
)
local FighterController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("FighterController")
)
local ArcadeController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("ArcadeController")
)
local ButtonEffect_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("ButtonEffect")
)
local Page_m = require(Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("Page"))
local PrivateServerPlayerSlot = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild(
    "PrivateServerPlayerSlot"
)
local Settings = Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("Settings")
local t = {
    {
        "ArcadeStart",
        "",
        "",
        "Private Arcade",
        "rbxassetid://81276179444570",
        "Launch a private Arcade duel",
        "DropdownConfirm",
        DuelLibrary_m:GetArcadeModeDisplayNames()[1],
        DuelLibrary_m:GetArcadeModeDisplayNames(),
        true
    },
    {
        "ArcadeCanPlayAllMaps",
        "",
        "",
        "Play Any Map",
        "rbxassetid://18129688386",
        "Allows you to vote for any map in this duel",
        "Toggle",
        false
    },
    {
        "ArcadeEnd",
        "",
        "",
        "Private Arcade",
        "rbxassetid://81276179444570",
        "End the private Arcade duel",
        "Confirm",
        false
    },
    {
        "FreecamEnabled",
        "",
        "",
        "Freecam Access",
        "rbxassetid://17548980857",
        "Activated by pressing [Shift] + [P]",
        "Dropdown",
        "Everyone",
        { "Everyone", "Server Owner", "Nobody" }
    },
    {
        "UseLockedWeapons",
        "",
        "",
        "Use Locked Weapons",
        "rbxassetid://17229230506",
        "Allows all players to use locked weapons in duels",
        "Toggle",
        true
    },
    {
        "ShootingRangePVP",
        "",
        "",
        "Shooting Range PVP",
        "rbxassetid://119084789924359",
        "Allows you to battle each other in the Shooting Range",
        "Toggle",
        false
    }
}
local t_8 = setmetatable({}, Page_m)
t_8.__index = t_8

function t_8._new() -- line: 29
    -- upvalues:
    --  [1] Page_m (copy)
    --  [2] t_8 (copy)

    local t_9 = setmetatable(Page_m.new(script.Name), t_8)
    t_9.CloseButton = t_9.PageFrame:WaitForChild("Close")
    t_9.LockedFrame = t_9.PageFrame:WaitForChild("Locked")
    t_9.List = t_9.PageFrame:WaitForChild("List")
    t_9.Container = t_9.List:WaitForChild("Container")
    t_9.Layout = t_9.Container:WaitForChild("Layout")
    t_9.PlayersFrame = t_9.Container:WaitForChild("Players")
    t_9.PlayersContainer = t_9.PlayersFrame:WaitForChild("Container")
    t_9.PlayersLayout = t_9.PlayersContainer:WaitForChild("Layout")
    t_9.BannedPlayersFrame = t_9.Container:WaitForChild("BannedPlayers")
    t_9.BannedPlayersContainer = t_9.BannedPlayersFrame:WaitForChild("Container")
    t_9.BannedPlayersLayout = t_9.BannedPlayersContainer:WaitForChild("Layout")
    t_9._setting_objects = {}
    t_9._player_slots = {}
    t_9._arcade_mode_display_names = nil
    t_9._to_arcade_mode_name = nil
    t_9:_Init()

    return t_9
end

function t_8.Open(arg1, ...) -- line: 58
    -- upvalues:
    --  [1] Page_m (copy)

    Page_m.Open(arg1, ...)
    arg1:_UpdatePlayers()
    arg1:_UpdateArcadeStatus()
end

function t_8._UpdateArcade(arg2) -- line: 68
    -- upvalues:
    --  [1] DuelLibrary_m (copy)

    arg2._arcade_mode_display_names, arg2._to_arcade_mode_name = DuelLibrary_m:GetArcadeModeDisplayNames()
end

function t_8._UpdateArcadeStatus(arg3) -- line: 72
    -- upvalues:
    --  [1] ArcadeController_m (copy)

    if not arg3:IsOpen() then
        return
    end

    local v9 = ArcadeController_m.CurrentDuel ~= nil
    arg3._setting_objects.ArcadeStart.SettingFrame.Visible = not v9
    arg3._setting_objects.ArcadeCanPlayAllMaps.SettingFrame.Visible = not v9
    arg3._setting_objects.ArcadeEnd.SettingFrame.Visible = v9
end

function t_8._CreatePlayerSlot(
    arg4,
    arg5,
    arg6,
    arg7,
    arg8,
    arg9,
    arg10,
    arg11,
    arg12
) -- line: 84
    -- upvalues:
    --  [1] PrivateServerPlayerSlot (copy)
    --  [2] CONSTANTS_m (copy)
    --  [3] ButtonEffect_m (copy)

    local v10 = PrivateServerPlayerSlot:Clone()
    v10.Kick.Visible = arg10
    v10.Ban.Visible = arg11
    v10.Unban.Visible = arg12
    v10.Icon.Image = string.format(CONSTANTS_m.HEADSHOT_IMAGE, arg7)
    v10.DisplayName.Controls.Image = ""
    v10.DisplayName.Text = arg8
    v10.Username.Text = "@" .. arg9
    v10.LayoutOrder = arg5
    v10.Parent = arg6
    arg4._player_slots[tostring(arg7)] = v10

    local function update() -- line: 97
        -- upvalues:
        --  [1] v10 (copy)

        v10.DisplayName.Controls.Position = UDim2.new(0, v10.DisplayName.TextBounds.X, 0.5, 0)
    end

    v10.DisplayName:GetPropertyChangedSignal("TextBounds"):Connect(update)
    v10.DisplayName.Controls.Position = UDim2.new(0, v10.DisplayName.TextBounds.X, 0.5, 0)
    ButtonEffect_m:Add(v10.Kick)
    ButtonEffect_m:Add(v10.Ban)
    ButtonEffect_m:Add(v10.Unban)

    return v10
end

function t_8._UpdatePlayers(arg13) -- line: 111
    -- upvalues:
    --  [1] FighterController_m (copy)
    --  [2] CONSTANTS_m (copy)
    --  [3] Players (copy)
    --  [4] PrivateServerController_m (copy)
    --  [5] ReplicatedStorage (copy)

    if not arg13:IsOpen() then
        for _, val in pairs(arg13._player_slots) do
            val:Destroy()
        end

        arg13._player_slots = {}

        return
    end

    local t_10 = {}

    for key_1, val_1 in pairs(FighterController_m.Objects) do
        local Player = val_1.Player

        if CONSTANTS_m.IS_STUDIO or Player ~= Players.LocalPlayer then
            t_10[tostring(Player.UserId)] = true

            if not arg13._player_slots[tostring(Player.UserId)] then
                local v12 = CONSTANTS_m.IS_STUDIO
                local PlayersContainer = arg13.PlayersContainer
                local UserId = Player.UserId
                local DisplayName = Player.DisplayName
                local Name = Player.Name
                v12 = v12 or Player ~= Players.LocalPlayer
                local v13 = arg13:_CreatePlayerSlot(
                    key_1,
                    PlayersContainer,
                    UserId,
                    DisplayName,
                    Name,
                    v12,
                    true,
                    false
                )
                v13.Kick.MouseButton1Click:Connect(function() -- line: 142
                    -- upvalues:
                    --  [1] PrivateServerController_m (ref)
                    --  [2] Player (copy)

                    PrivateServerController_m:ServerKick(Player)
                end)
                v13.Ban.MouseButton1Click:Connect(function() -- line: 146
                    -- upvalues:
                    --  [1] PrivateServerController_m (ref)
                    --  [2] Player (copy)

                    PrivateServerController_m:ServerBan(Player)
                end)
            end
        end
    end

    local v15, v16

    for key_2, val_2 in pairs(PrivateServerController_m.BannedPlayers) do
        local v14, v15, v16 = table.unpack(val_2)
        t_10[tostring(v14)] = true

        if not arg13._player_slots[tostring(v14)] then
            arg13:_CreatePlayerSlot(
                key_2,
                arg13.BannedPlayersContainer,
                v14,
                v15,
                v16,
                false,
                false,
                true
            ).Unban.MouseButton1Click:Connect(function() -- line: 164
                -- upvalues:
                --  [1] ReplicatedStorage (ref)
                --  [2] v14 (copy)

                ReplicatedStorage.Remotes.PrivateServer.UnbanPlayer:FireServer(v14)
            end)
        end
    end

    local t_11 = {}

    for key_3, val_3 in pairs(arg13._player_slots) do
        if not t_10[key_3] then
            t_11[key_3] = true
            val_3:Destroy()
        end
    end

    for key_4, _ in pairs(t_11) do
        arg13._player_slots[key_4] = nil
    end
end

function t_8._Setup(arg14) -- line: 186
    -- upvalues:
    --  [1] t (copy)
    --  [2] SettingsInfo_m (copy)
    --  [3] Settings (copy)
    --  [4] ReplicatedStorage (copy)
    --  [5] CONSTANTS_m (copy)
    --  [6] Players (copy)

    for key_5, val_5 in pairs(t) do
        local v18 = val_5[1]
        local v19 = SettingsInfo_m.new(select(2, table.unpack(val_5)))
        local _ = require(Settings:WaitForChild(v19.InputType))
        local v21 = require(Settings:WaitForChild(v19.InputType)).new(v19)
        v21.SettingFrame.LayoutOrder = key_5
        v21.SettingFrame.Parent = arg14.Container
        arg14._setting_objects[v18] = v21
    end

    arg14._setting_objects.UseLockedWeapons.Replicate:Connect(function(arg15) -- line: 198
        -- upvalues:
        --  [1] ReplicatedStorage (ref)

        ReplicatedStorage.Remotes.PrivateServer.SetUseLockedWeapons:FireServer(arg15 or false)
    end)
    arg14._setting_objects.ShootingRangePVP.Replicate:Connect(function(arg16) -- line: 202
        -- upvalues:
        --  [1] ReplicatedStorage (ref)

        ReplicatedStorage.Remotes.PrivateServer.SetShootingRangePVP:FireServer(arg16 or false)
    end)
    arg14._setting_objects.FreecamEnabled.Replicate:Connect(function(arg17) -- line: 206
        -- upvalues:
        --  [1] ReplicatedStorage (ref)

        ReplicatedStorage.Remotes.PrivateServer.SetFreecamEnabled:FireServer(arg17)
    end)
    arg14._setting_objects.ArcadeCanPlayAllMaps.Replicate:Connect(function(arg18) -- line: 210
        -- upvalues:
        --  [1] ReplicatedStorage (ref)

        ReplicatedStorage.Remotes.PrivateServer.SetArcadeCanPlayAllMaps:FireServer(arg18)
    end)
    arg14._setting_objects.ArcadeStart.Replicate:Connect(function(arg19) -- line: 214
        -- upvalues:
        --  [1] arg14 (copy)
        --  [2] ReplicatedStorage (ref)

        arg14:_UpdateArcade()
        ReplicatedStorage.Remotes.PrivateServer.StartArcadeMode:FireServer(
            arg14._to_arcade_mode_name[arg19]
        )
    end)
    arg14._setting_objects.ArcadeEnd.Replicate:Connect(function() -- line: 219
        -- upvalues:
        --  [1] ReplicatedStorage (ref)

        ReplicatedStorage.Remotes.PrivateServer.EndArcadeMode:FireServer()
    end)
    arg14._setting_objects.ArcadeEnd:SetConfirmColor("Red")
    arg14._setting_objects.ArcadeCanPlayAllMaps:Scale(0.95)
    local v22 = CONSTANTS_m.IS_PRIVATE_SERVER_OWNER(Players.LocalPlayer.UserId)
    arg14.LockedFrame.Visible = not v22
    arg14.List.Visible = v22
end

function t_8._Init(arg20) -- line: 232
    -- upvalues:
    --  [1] FighterController_m (copy)
    --  [2] PrivateServerController_m (copy)
    --  [3] ArcadeController_m (copy)
    --  [4] ButtonEffect_m (copy)

    arg20.CloseButton.MouseButton1Click:Connect(function() -- line: 233
        -- upvalues:
        --  [1] arg20 (copy)

        arg20:CloseRequest()
    end)
    arg20.Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() -- line: 237
        -- upvalues:
        --  [1] arg20 (copy)

        arg20.List.CanvasSize = UDim2.new(0, 0, 0, arg20.Layout.AbsoluteContentSize.Y)
        local List_1 = arg20.List
        List_1.Active = arg20.Layout.AbsoluteContentSize.Y >= arg20.List.AbsoluteSize.Y
    end)
    arg20.PlayersLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() -- line: 242
        -- upvalues:
        --  [1] arg20 (copy)

        arg20.PlayersFrame.Size = UDim2.new(1, 0, 0, arg20.PlayersLayout.AbsoluteContentSize.Y)
    end)
    arg20.PlayersFrame:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- line: 246
        -- upvalues:
        --  [1] arg20 (copy)

        local PlayersFrame_1 = arg20.PlayersFrame
        PlayersFrame_1.Visible = arg20.PlayersFrame.AbsoluteSize.Y > 0
    end)
    arg20.BannedPlayersLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() -- line: 250
        -- upvalues:
        --  [1] arg20 (copy)

        arg20.BannedPlayersFrame.Size = UDim2.new(
            1,
            0,
            0,
            arg20.BannedPlayersLayout.AbsoluteContentSize.Y
        )
    end)
    arg20.BannedPlayersFrame:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- line: 254
        -- upvalues:
        --  [1] arg20 (copy)

        local BannedPlayersFrame_1 = arg20.BannedPlayersFrame
        BannedPlayersFrame_1.Visible = arg20.BannedPlayersFrame.AbsoluteSize.Y > 0
    end)
    FighterController_m.ObjectAdded:Connect(function() -- line: 258
        -- upvalues:
        --  [1] arg20 (copy)

        arg20:_UpdatePlayers()
    end)
    FighterController_m.ObjectRemoved:Connect(function() -- line: 262
        -- upvalues:
        --  [1] arg20 (copy)

        arg20:_UpdatePlayers()
    end)
    PrivateServerController_m.BannedPlayersChanged:Connect(function() -- line: 266
        -- upvalues:
        --  [1] arg20 (copy)

        arg20:_UpdatePlayers()
    end)
    ArcadeController_m.DuelSet:Connect(function() -- line: 270
        -- upvalues:
        --  [1] arg20 (copy)

        arg20:_UpdateArcadeStatus()
    end)
    arg20:_Setup()
    arg20:_UpdateArcade()
    ButtonEffect_m:Add(arg20.CloseButton)
end

return t_8._new()
