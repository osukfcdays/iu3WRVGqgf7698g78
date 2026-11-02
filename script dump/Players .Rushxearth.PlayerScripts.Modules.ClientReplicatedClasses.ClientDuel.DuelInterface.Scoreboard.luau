local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")
local DuelLibrary_m = require(ReplicatedStorage.Modules.DuelLibrary)
local ItemLibrary_m = require(ReplicatedStorage.Modules.ItemLibrary)
local Signal_m = require(ReplicatedStorage.Modules.Signal)
local SpectateController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.SpectateController
)
local ScoreboardPlayerSlot_m = require(script:WaitForChild("ScoreboardPlayerSlot"))
local BanIcon = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("BanIcon")
local t = {}
t.__index = t

function t.new(arg1) -- line: 19
    -- upvalues:
    --  [1] t (copy)
    --  [2] Signal_m (copy)

    local t_1 = setmetatable({}, t)
    t_1.VisibilityChanged = Signal_m.new()
    t_1.DuelInterface = arg1
    t_1.Frame = t_1.DuelInterface.Frame:WaitForChild("Scoreboard")
    t_1.Container = t_1.Frame:WaitForChild("Container")
    t_1.Layout = t_1.Container:WaitForChild("Layout")
    t_1.TopFrame = t_1.Container:WaitForChild("Top")
    t_1.TopBackground = t_1.TopFrame:WaitForChild("Background")
    t_1.TopText = t_1.TopFrame:WaitForChild("Score")
    t_1.BottomFrame = t_1.Container:WaitForChild("Bottom")
    t_1.BottomBackground = t_1.BottomFrame:WaitForChild("Background")
    t_1.BottomInformationText = t_1.BottomFrame:WaitForChild("Information")
    t_1.ButtonsFrame = t_1.Container:WaitForChild("Buttons")
    t_1.ButtonsContainer = t_1.ButtonsFrame:WaitForChild("Container")
    t_1.BannedWeaponsFrame = t_1.Container:WaitForChild("BannedWeapons")
    t_1.BannedWeaponsContainer = t_1.BannedWeaponsFrame:WaitForChild("Container")
    t_1.PlayersFrame = t_1.Container:WaitForChild("Players")
    t_1.PlayersBottomFade = t_1.PlayersFrame:WaitForChild("BottomFade")
    t_1.PlayersTopFade = t_1.PlayersFrame:WaitForChild("TopFade")
    t_1.PlayersList = t_1.PlayersFrame:WaitForChild("List")
    t_1.PlayersContainer = t_1.PlayersList:WaitForChild("Container")
    t_1.PlayersLayout = t_1.PlayersContainer:WaitForChild("Layout")
    t_1._destroyed = false
    t_1._scoreboard_open = false
    t_1._scoreboard_player_slots = {}
    t_1._scoreboard_local_player_slot = nil
    t_1._neutral_team_color_index = 0
    t_1._banned_weapon_icons = {}
    t_1:_Init()

    return t_1
end

function t.IsOpen(arg2) -- line: 61
    return not arg2._destroyed and arg2.Frame.Visible
end

function t.GetTeamColor(arg3, arg4) -- line: 65
    -- upvalues:
    --  [1] DuelLibrary_m (copy)

    local v3 = DuelLibrary_m:GetTeamColor(arg4)

    if arg4 then
        return v3
    end

    local v4, v5, v6 = v3:ToHSV()
    arg3._neutral_team_color_index += 1

    return Color3.fromHSV(
        v4,
        v5,
        v6 - (if arg3._neutral_team_color_index % 2 == 0 then 0.05 else 0)
    )
end

function t.GetBackgroundTransparency(_) -- line: 80
    -- upvalues:
    --  [1] GuiService (copy)

    return 0 + 0.25 * GuiService.PreferredTransparency
end

function t.Open(arg6, arg7) -- line: 84
    if arg6._destroyed then
        return
    end

    arg6._scoreboard_open = if arg7 ~= nil then arg7 else arg6._scoreboard_open
    local v11 = arg6._scoreboard_open
    local Frame = arg6.Frame

    if v11 then
        v11 = not arg6.DuelInterface:IsPageOpen()

        if v11 then
            v11 = not arg6.DuelInterface.Voting:IsOpen()

            if v11 then
                v11 = not arg6.DuelInterface.FinalResults:IsActive()

                if v11 then
                    v11 = if arg6.DuelInterface.ClientDuel:Get("Status") == "GameOver" then false else true
                end
            end
        end
    end

    Frame.Visible = v11
    arg6.VisibilityChanged:Fire()
    arg6:Generate()
end

function t.UpdatePreferredTransparency(arg8) -- line: 95
    local v12 = arg8:GetBackgroundTransparency()
    arg8.TopBackground.ImageTransparency = v12
    arg8.BottomBackground.ImageTransparency = v12

    for _, val in pairs(arg8._scoreboard_player_slots) do
        val:UpdatePreferredTransparency(v12)
    end
end

function t.Generate(arg9) -- line: 106
    -- upvalues:
    --  [1] DuelLibrary_m (copy)
    --  [2] SpectateController_m (copy)
    --  [3] BanIcon (copy)
    --  [4] ItemLibrary_m (copy)
    --  [5] ScoreboardPlayerSlot_m (copy)

    for _, val_1 in pairs(arg9._scoreboard_player_slots) do
        val_1:Destroy()
    end

    for _, val_2 in pairs(arg9._banned_weapon_icons) do
        val_2:Destroy()
    end

    arg9._banned_weapon_icons = {}
    arg9._scoreboard_player_slots = {}
    arg9._scoreboard_local_player_slot = nil
    arg9._neutral_team_color_index = 0

    if arg9._destroyed or not arg9.Frame.Visible then
        return
    end

    local v13 = arg9.DuelInterface.ClientDuel:Get("PlaySourceName")
    local v14 = v13

    if v14 then
        v14 = DuelLibrary_m.PlaySources[v13].DisplayName
    end

    local v15 = arg9.DuelInterface.ClientDuel.Map and arg9.DuelInterface.ClientDuel.Map.Name
    local v16 = arg9.DuelInterface.ClientDuel.Map

    if v16 then
        v16 = arg9.DuelInterface.ClientDuel.Map:GetScoreboardDisplay()
    end

    local BottomInformationText = arg9.BottomInformationText
    BottomInformationText.Text = if v16 then v16 else if v15 and v14 and v15 == v14 then v15 else if v15 and not v14 then v15 else if v14 and v15 then string.format(
        "%s   \226\128\162   %s",
        v14,
        v15
    ) else if not v14 then "" else if v15 then "" else v14
    v16 = SpectateController_m.CurrentSubject
    v14 = v16

    if v14 then
        v14 = v16:Get("WeaponPool")
    end

    v15 = v16

    if v15 then
        v15 = v16:Get("WeaponPoolFilterType")
    end

    if v15 == "Blacklist" and #v14 > 0 and not arg9.DuelInterface.ClientDuel:Get("ArcadeMode") then
        arg9.BannedWeaponsFrame.Visible = true

        for key_3, val_3 in pairs(v14) do
            local v18 = BanIcon:Clone()
            v18.ImageColor3 = Color3.fromRGB(127, 25, 25)
            v18.Icon.ImageColor3 = Color3.fromRGB(255, 50, 50)
            v18.LayoutOrder = key_3
            local Icon_1 = v18.Weapon.Icon
            local v19 = ItemLibrary_m.ViewModels[val_3].ImageCentered or ItemLibrary_m.Items[val_3].Image
            Icon_1.Image = v19
            v18.Weapon.ZIndex = 10
            v18.Weapon.Visible = true
            v18.Parent = arg9.BannedWeaponsContainer
            table.insert(arg9._banned_weapon_icons, v18)
        end
    else
        arg9.BannedWeaponsFrame.Visible = false
    end

    v14 = arg9.DuelInterface:GetLoggedClientDuelers(true)

    for key_4, val_4 in pairs(v14) do
        v15 = arg9._scoreboard_player_slots[val_4]

        if v15 then
            v15.Frame.LayoutOrder = key_4
            v15:Update()
        else
            local v20 = ScoreboardPlayerSlot_m.new(arg9, val_4)
            v20.Frame.LayoutOrder = key_4
            v20.Frame.Parent = arg9.PlayersContainer
            arg9._scoreboard_player_slots[val_4] = v20

            if val_4.IsLocalPlayer then
                arg9._scoreboard_local_player_slot = v20
            end
        end
    end

    local t_2 = {}

    for key_5, val_5 in pairs(arg9._scoreboard_player_slots) do
        if not table.find(v14, key_5) then
            val_5:Destroy()
            t_2[key_5] = true

            if key_5.IsLocalPlayer then
                arg9._scoreboard_local_player_slot = nil
            end
        end
    end

    for key_6, _ in pairs(t_2) do
        arg9._scoreboard_player_slots[key_6] = nil
    end
end

function t.Destroy(arg10) -- line: 203
    arg10._destroyed = true

    for _, val_7 in pairs(arg10._scoreboard_player_slots) do
        val_7:Destroy()
    end

    arg10._scoreboard_player_slots = {}
    arg10._scoreboard_local_player_slot = nil
    arg10.VisibilityChanged:Destroy()
end

function t._UpdateFade(arg11) -- line: 220
    local v21 = arg11.PlayersFrame.AbsoluteSize.X * 0.2
    local maximum = math.max(
        0,
        arg11.PlayersList.AbsoluteCanvasSize.Y - arg11.PlayersList.AbsoluteWindowSize.Y - 5 - arg11.PlayersList.CanvasPosition.Y
    )
    local maximum_1 = math.max(0, arg11.PlayersList.CanvasPosition.Y - 5)
    local clampedValue = math.clamp(1 - maximum / v21, 0, 1)
    local clampedValue_1 = math.clamp(1 - maximum_1 / v21, 0, 1)
    arg11.PlayersBottomFade.BackgroundTransparency = clampedValue * 0.5 + 0.5
    arg11.PlayersTopFade.BackgroundTransparency = clampedValue_1 * 0.5 + 0.5
    arg11.PlayersList.ClipsDescendants = math.abs(
        arg11.PlayersList.AbsoluteCanvasSize.Y - arg11.PlayersList.AbsoluteWindowSize.Y
    ) > 5 and true
end

function t._UpdateLayout(arg12) -- line: 232
    local PlayersFrame = arg12.PlayersFrame
    local New = UDim2.new
    PlayersFrame.Size = New(
        1,
        0,
        0,
        (math.min(
            arg12.PlayersLayout.AbsoluteContentSize.Y,
            (arg12.DuelInterface.Frame.AbsoluteSize.Y - (arg12.Layout.AbsoluteContentSize.Y - arg12.PlayersFrame.AbsoluteSize.Y)) * 0.5
        ))
    )
    arg12.PlayersList.CanvasSize = UDim2.new(0, 0, 0, arg12.PlayersLayout.AbsoluteContentSize.Y)
end

function t._UpdateButtonsVisibility(arg13) -- line: 239
    arg13.ButtonsFrame.Visible = #arg13.ButtonsContainer:GetChildren() > 0 and true
end

function t._Setup(arg14) -- line: 243
    arg14.TopText.Text = if SHOW_WEAPON_IN_GUNGAME and arg14.DuelInterface.ClientDuel:Get(
        "IsGunGame"
    ) then "WEAPON" else if arg14.DuelInterface.ClientDuel:Get("ScoresBehavior") == "Duelers" then "POINTS" else "DMG"
end

function t._Init(arg15) -- line: 249
    arg15.PlayersFrame:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- line: 250
        -- upvalues:
        --  [1] arg15 (copy)

        arg15:_UpdateLayout()
        arg15:_UpdateFade()
    end)
    arg15.PlayersLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() -- line: 255
        -- upvalues:
        --  [1] arg15 (copy)

        arg15:_UpdateLayout()
    end)
    arg15.Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() -- line: 259
        -- upvalues:
        --  [1] arg15 (copy)

        arg15:_UpdateLayout()
    end)
    arg15.DuelInterface.Frame:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- line: 263
        -- upvalues:
        --  [1] arg15 (copy)

        arg15:_UpdateLayout()
    end)
    arg15.PlayersList:GetPropertyChangedSignal("CanvasPosition"):Connect(function() -- line: 267
        -- upvalues:
        --  [1] arg15 (copy)

        arg15:_UpdateFade()
    end)
    arg15.PlayersList:GetPropertyChangedSignal("AbsoluteCanvasSize"):Connect(function() -- line: 271
        -- upvalues:
        --  [1] arg15 (copy)

        arg15:_UpdateFade()
    end)
    arg15.PlayersList:GetPropertyChangedSignal("AbsoluteWindowSize"):Connect(function() -- line: 275
        -- upvalues:
        --  [1] arg15 (copy)

        arg15:_UpdateFade()
    end)
    arg15.DuelInterface.FinalResults.Activated:Connect(function() -- line: 279
        -- upvalues:
        --  [1] arg15 (copy)

        arg15:Open(nil)
    end)
    arg15.DuelInterface.Voting.VisibilityChanged:Connect(function() -- line: 283
        -- upvalues:
        --  [1] arg15 (copy)

        arg15:Open(nil)
    end)
    arg15.ButtonsContainer.ChildAdded:Connect(function() -- line: 287
        -- upvalues:
        --  [1] arg15 (copy)

        arg15:_UpdateButtonsVisibility()
    end)
    arg15.ButtonsContainer.ChildRemoved:Connect(function() -- line: 291
        -- upvalues:
        --  [1] arg15 (copy)

        arg15:_UpdateButtonsVisibility()
    end)
    arg15:_Setup()
    arg15:_UpdateLayout()
    arg15:_UpdateButtonsVisibility()
end

return t
