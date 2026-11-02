local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local CONSTANTS_m = require(ReplicatedStorage.Modules.CONSTANTS)
local LeaderboardLibrary_m = require(ReplicatedStorage.Modules.LeaderboardLibrary)
local EventLibrary_m = require(ReplicatedStorage.Modules.EventLibrary)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local LeaderboardController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.LeaderboardController
)
local ComplianceController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.ComplianceController
)
local ButtonEffect_m = require(Players.LocalPlayer.PlayerScripts.Modules.ButtonEffect)
local RankIcon_m = require(Players.LocalPlayer.PlayerScripts.Modules.RankIcon)
local LeaderboardPlayerSlot = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild(
    "LeaderboardPlayerSlot"
)
local LobbyVisuals = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("LobbyVisuals")
local t = {}
t.__index = t

function t.new(arg1) -- line: 19
    -- upvalues:
    --  [1] t (copy)
    --  [2] LobbyVisuals (copy)
    --  [3] EventLibrary_m (copy)

    local t_1 = setmetatable({}, t)
    t_1.Part = arg1
    local v1 = LobbyVisuals:FindFirstChild(EventLibrary_m.LOBBY_VISUALS_PROFILE) and LobbyVisuals[EventLibrary_m.LOBBY_VISUALS_PROFILE]:FindFirstChild(
        "LeaderboardGui"
    ) or LobbyVisuals.Default.LeaderboardGui
    t_1.SurfaceGui = v1:Clone()
    t_1._display_id = t_1.Part:GetAttribute("DisplayID")
    t_1._leaderboard_buttons = {}
    t_1._leaderboard_name = nil
    t_1._leaderboard_serial = nil
    t_1._leaderboard_connections = {}
    t_1._generate_hash = 0
    t_1._player_slots = {}
    t_1:_Init()

    return t_1
end

function t.SelectLeaderboard(arg2, arg3) -- line: 42
    -- upvalues:
    --  [1] LeaderboardController_m (copy)

    for _, val in pairs(arg2._leaderboard_connections) do
        val:Disconnect()
    end

    arg2._leaderboard_connections = {}
    arg2._leaderboard_name = arg3
    arg2._leaderboard_serial = LeaderboardController_m.LeaderboardSerials[arg2._leaderboard_name]
    arg2:_UpdateButtons()
    task.spawn(arg2._Generate, arg2)

    if not arg2._leaderboard_name then
        return
    end

    table.insert(arg2._leaderboard_connections, LeaderboardController_m:GetLeaderboardRefreshedSignal(
        arg2._leaderboard_name
    ):Connect(function() -- line: 58
        -- upvalues:
        --  [1] arg2 (copy)

        arg2:Refresh()
    end))
end

function t.Refresh(arg4) -- line: 63
    arg4:SelectLeaderboard(arg4._leaderboard_name)
end

function t._UpdateCanvasSize(arg5) -- line: 71
    arg5.SurfaceGui.List.CanvasSize = UDim2.new(
        0,
        0,
        0,
        arg5.SurfaceGui.List.Container.Layout.AbsoluteContentSize.Y
    )
end

function t._UpdateButtons(arg6) -- line: 75
    -- upvalues:
    --  [1] LeaderboardLibrary_m (copy)

    for key_1, val_1 in pairs(arg6._leaderboard_buttons) do
        local Icon = val_1.Button.Icon
        local v3 = LeaderboardLibrary_m.DisplayInfo[key_1]
        local v4 = if key_1 ~= arg6._leaderboard_name then "Icon" else "IconFilled"
        Icon.Image = v3[v4]
        local Icon_1 = val_1.Button.Icon
        local v5 = if key_1 ~= arg6._leaderboard_name then UDim2.new(0.6, 0, 0.6, 0) else UDim2.new(
            1,
            0,
            1,
            0
        ) or UDim2.new(0.6, 0, 0.6, 0)
        Icon_1.Size = v5
    end
end

function t._LiveDisplay(arg7, arg8) -- line: 82
    while true do
        arg7.SurfaceGui.Live.Text = "\226\128\162 LIVE"
        wait(1)

        if arg8 ~= arg7._generate_hash then
            return
        end

        arg7.SurfaceGui.Live.Text = "LIVE"
        wait(0.25)

        if arg8 == arg7._generate_hash then
            continue
        end

        return
    end
end

function t._Generate(arg9) -- line: 102
    -- upvalues:
    --  [1] LeaderboardLibrary_m (copy)
    --  [2] ComplianceController_m (copy)
    --  [3] Utility_m (copy)
    --  [4] LeaderboardPlayerSlot (copy)
    --  [5] CONSTANTS_m (copy)
    --  [6] RankIcon_m (copy)

    for _, val_2 in pairs(arg9._player_slots) do
        val_2:Destroy()
    end

    arg9._player_slots = {}
    arg9._generate_hash += 1
    arg9.SurfaceGui.Title.Text = "Loading..."
    arg9.SurfaceGui.LiveBackground.Visible = false
    arg9.SurfaceGui.Live.Visible = false
    local v6 = LeaderboardLibrary_m.DisplayInfo[arg9._leaderboard_name] or {}
    local GenerateHash = arg9._generate_hash
    local t_2 = {}
    local v7 = pairs
    local v8 = arg9._leaderboard_serial and arg9._leaderboard_serial.Players or {}

    for _, val_3 in v7(v8) do
        table.insert(t_2, (tonumber(val_3.key)))
    end

    v7 = if arg9._leaderboard_serial then if #arg9._leaderboard_serial.Players ~= 0 then #t_2 == 0 and {} or ComplianceController_m:GetUserInfos(
        t_2,
        25
    ) else {} or ComplianceController_m:GetUserInfos(t_2, 25) else {} or ComplianceController_m:GetUserInfos(
        t_2,
        25
    )

    if GenerateHash ~= arg9._generate_hash then
        return
    end

    local Title = arg9.SurfaceGui.Title
    Title.Text = v6 and v6.DisplayName or "\226\128\162 \226\128\162 \226\128\162"
    arg9.SurfaceGui.Live.Visible = v6.LiveDisplayEnabled
    arg9.SurfaceGui.LiveBackground.Visible = v6.LiveDisplayEnabled

    if v6.LiveDisplayEnabled then
        task.spawn(arg9._LiveDisplay, arg9, GenerateHash)
    end

    local v10 = pairs
    local v11 = arg9._leaderboard_serial and arg9._leaderboard_serial.Players or {}
    local v13, v15

    for key_4, val_4 in v10(v11) do
        local Key = val_4.key
        local Value = val_4.value
        local v12 = v7[Key]

        if v12 then
            v13 = v12.DisplayName
            v15 = v13 .. (v12.HasVerifiedBadge and utf8.char(57344) or "") or "\226\128\162 \226\128\162 \226\128\162"
        else
            v15 = "\226\128\162 \226\128\162 \226\128\162"
        end

        v13 = if not v12 or not v12.Username then nil else if v6.SanitizeUsernames then Utility_m:SanitizeName(
            v12.Username
        ) else v12.Username
        local v16 = v12 and v13 and "@" .. v13 or ""
        v13 = LeaderboardPlayerSlot:Clone()
        v13.Left.Headshot.Image = string.format(CONSTANTS_m.HEADSHOT_IMAGE, Key)
        v13.Left.Rank.Text = "#" .. key_4
        local Rank = v13.Left.Rank
        local v17 = key_4 == 1 and Color3.fromRGB(255, 215, 0) or Color3.fromRGB(255, 255, 255)
        Rank.TextColor3 = v17
        v17 = v13.Left.Rank
        v17[if key_4 ~= 1 then "First" else "Normal"]:Destroy()
        v13.Left.DisplayName.Text = v15
        local DisplayName = v13.Left.DisplayName
        local v19 = key_4 == 1 and UDim2.new(2, 0, 0.4, 0) or UDim2.new(3, 0, 0.4, 0)
        DisplayName.Size = v19
        v13.Left.Username.Text = v16
        v13.Left.UserID.Text = "#" .. Key
        v13.Right.Icon.Value.Text = Utility_m:PrettyNumber(Value)
        local Icon_2 = v13.Right.Icon
        local v20 = v6 and v6.Icon or ""
        Icon_2.Image = v20
        v13.Right.Icon.UIGradient.Color = v6.ColorSequence
        v13.Right.Icon.Value.Position = v6.TextPosition
        v13.Right.Icon.Value.UIStroke.UIGradient.Color = v6.DarkColorSequence
        local v21 = if key_4 ~= 1 then UDim2.new(1, 0, 0.15, 0) else UDim2.new(1, 0, 0.25, 0) or UDim2.new(
            1,
            0,
            0.15,
            0
        )
        v13.Size = v21
        v13.LayoutOrder = key_4
        v13.Parent = arg9.SurfaceGui.List.Container
        table.insert(arg9._player_slots, v13)

        if arg9._leaderboard_name == "Highest ELO" then
            v13.Right.Icon.Visible = false
            local Rank_1 = v13.Right.Rank
            local v22 = if key_4 ~= 1 then UDim2.new(1.5, 0, 1.5, 0) else UDim2.new(1, 0, 1, 0) or UDim2.new(
                1.5,
                0,
                1.5,
                0
            )
            Rank_1.Size = v22
            v16 = RankIcon_m.new(Value, tonumber(Key), key_4)
            v16:SetParent(v13.Right.Rank)
            v16:SetLabelFromELOEvent(nil, Value, 10)
            v16:GetLabel().BackgroundTransparency = 1
            v15 = Instance.new("UIStroke")
            v15.Thickness = 2
            v15.Parent = v16:GetLabelText()
        end

        wait(0.06)

        if GenerateHash ~= arg9._generate_hash then
            return
        end
    end
end

function t._Setup(arg10) -- line: 194
    -- upvalues:
    --  [1] LeaderboardLibrary_m (copy)
    --  [2] LobbyVisuals (copy)
    --  [3] EventLibrary_m (copy)
    --  [4] ButtonEffect_m (copy)
    --  [5] Players (copy)

    local v23 = nil

    for key_5, val_5 in pairs(LeaderboardLibrary_m.Order) do
        if LeaderboardLibrary_m.DisplayInfo[val_5].DisplayID == arg10._display_id then
            local v24 = (LobbyVisuals:FindFirstChild(EventLibrary_m.LOBBY_VISUALS_PROFILE) and LobbyVisuals[EventLibrary_m.LOBBY_VISUALS_PROFILE]:FindFirstChild(
                "LeaderboardButton"
            ) or LobbyVisuals.Default.LeaderboardButton):Clone()
            v24.LayoutOrder = key_5
            v24.Parent = arg10.SurfaceGui.Buttons
            arg10._leaderboard_buttons[val_5] = v24
            v24.Button.MouseButton1Click:Connect(function() -- line: 209
                -- upvalues:
                --  [1] arg10 (copy)
                --  [2] val_5 (copy)

                arg10:SelectLeaderboard(val_5)
            end)
            ButtonEffect_m:Add(v24.Button, nil, { HoverRatio = 1.05, ReleaseRatio = 1.05 })
            v23 = v23 or val_5
        end
    end

    arg10:SelectLeaderboard(v23)
    arg10.SurfaceGui.Adornee = arg10.Part
    arg10.SurfaceGui.Parent = Players.LocalPlayer.PlayerGui
end

function t._Init(arg11) -- line: 223
    arg11.SurfaceGui.List.Container.Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(
        function() -- line: 224
            -- upvalues:
            --  [1] arg11 (copy)

            arg11:_UpdateCanvasSize()
        end
    )
    arg11:_Setup()
    arg11:_UpdateButtons()
    arg11:_UpdateCanvasSize()
end

return t
