local ReplicatedStorage = game:GetService("ReplicatedStorage")
local _ = game:GetService("TweenService")
local Players = game:GetService("Players")
local CONSTANTS_m = require(ReplicatedStorage.Modules.CONSTANTS)
local ServerOsTime_m = require(ReplicatedStorage.Modules.ServerOsTime)
local DuelLibrary_m = require(ReplicatedStorage.Modules.DuelLibrary)
local Signal_m = require(ReplicatedStorage.Modules.Signal)
local VoteBanFrame_m = require(Players.LocalPlayer.PlayerScripts.Modules.VoteBanFrame)
local ButtonEffect_m = require(Players.LocalPlayer.PlayerScripts.Modules.ButtonEffect)
local VoterSlot = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("VoterSlot")
local MapSlot = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("MapSlot")
local t = {}
local t_1 = { ReleaseRatio = 1.025, HoverRatio = 1.025 }
t.__index = t

function t.new(arg1, arg2) -- line: 19
    -- upvalues:
    --  [1] t (copy)
    --  [2] Signal_m (copy)
    --  [3] MapSlot (copy)
    --  [4] VoteBanFrame_m (copy)

    local t_2 = setmetatable({}, t)
    t_2.CreateSound = Signal_m.new()
    t_2.Name = arg1
    t_2.Frame = MapSlot:Clone()
    t_2.VoteBanFrame = VoteBanFrame_m.new(t_2.Frame.Button)
    t_2._ignore_button_effect = arg2
    t_2._voter_slots = {}
    t_2._is_banned = false
    t_2._tag_background = t_2.Frame.Button.Tag.Background
    t_2._tag_title = t_2.Frame.Button.Tag.Title
    t_2:_Init()

    return t_2
end

function t.SetParent(arg3, arg4) -- line: 43
    arg3.Frame.Parent = arg4
end

function t.UpdateVotes(
    arg5,
    arg6,
    arg7,
    arg8,
    arg9,
    arg10,
    arg11
) -- line: 47
    -- upvalues:
    --  [1] VoterSlot (copy)
    --  [2] CONSTANTS_m (copy)
    --  [3] DuelLibrary_m (copy)

    local t_3 = {}
    local v2 = arg8 or {}

    for _, val in pairs(v2) do
        t_3[tostring(val)] = true

        if not arg5._voter_slots[tostring(val)] then
            local v3 = VoterSlot:Clone()
            v3.Headshot.Image = string.format(CONSTANTS_m.HEADSHOT_IMAGE, val)
            v3.Background.ImageColor3 = DuelLibrary_m:GetTeamColor(arg9[tostring(val)])
            v3.Parent = arg5.Frame.Button.Votes
            arg5._voter_slots[tostring(val)] = v3
        end
    end

    local t_4 = {}

    for key_1, val_1 in pairs(arg5._voter_slots) do
        if not t_3[key_1] then
            t_4[key_1] = true
            val_1:Destroy()
        end
    end

    for key_2, _ in pairs(t_4) do
        arg5._voter_slots[key_2] = nil
    end

    local Votes = arg5.Frame.Button.Votes
    Votes.Visible = arg6 ~= nil
    arg5.Frame.Button.Title.Text = arg5.Name .. (if arg11 == "Chance" and arg6 and arg6 > 0 then " [" .. math.floor(
        arg6 / arg7 * 100
    ) .. "%]" else "")
    local Title_1 = arg5.Frame.Button.Title
    Title_1.TextColor3 = arg10 and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(255, 255, 255)
    local Background_1 = arg5.Frame.Button.Background
    Background_1.ImageColor3 = arg10 and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(0, 0, 0)
    arg5.Frame.Button.Votes.Chance.Visible = false
end

function t.Destroy(arg12) -- line: 89
    arg12.CreateSound:Destroy()
    arg12.VoteBanFrame:Destroy()
    arg12.Frame:Destroy()
end

function t._Update(arg13) -- line: 99
    arg13._tag_background.Size = UDim2.new(0.5, arg13._tag_title.TextBounds.X, 1, 0)
end

function t._Setup(arg14) -- line: 103
    -- upvalues:
    --  [1] DuelLibrary_m (copy)
    --  [2] ServerOsTime_m (copy)
    --  [3] ButtonEffect_m (copy)
    --  [4] t_1 (copy)

    local v8 = if arg14.Name ~= "Random" then false else true
    local v9 = DuelLibrary_m.Maps[arg14.Name]
    local v10 = if not v8 then v9.Image else ""
    local v11 = DuelLibrary_m.MapDifficulties
    local v12 = if not v8 then v9.Difficulty else "None"
    local v13 = v11[v12]
    v11 = if v8 then false else ServerOsTime_m:Get() < v9.ReleaseTime + DuelLibrary_m.NEW_MAP_RELEASE_DURATION and true
    v12 = if not v11 then v9 and v9.MapTag else "tag_newrelease"
    v11 = DuelLibrary_m.MapTags[v12]
    arg14.Frame.Button.Picture.Image = v10
    arg14.Frame.Button.Random.Visible = v8
    arg14.Frame.Button.Background.Texture.ImageColor3 = v13.Color
    arg14.Frame.Button.Difficulty.BackgroundColor3 = v13.Color
    arg14.Frame.Button.Difficulty.UIStroke.Color = v13.Color
    arg14.Frame.Button.DifficultyVignette.ImageColor3 = v13.Color
    local DifficultyVignette = arg14.Frame.Button.DifficultyVignette
    DifficultyVignette.ImageTransparency = if not (v13.Value >= DuelLibrary_m.MapDifficulties.Hard.Value) then 0.5 else 0
    arg14.Frame.Button.Tag.Visible = v12
    local TagTitle = arg14._tag_title
    TagTitle.Text = v11 and v11.DisplayName or ""
    local TagTitle_1 = arg14._tag_title
    TagTitle_1.TextColor3 = v11 and v11.SecondaryColor or Color3.fromRGB(255, 255, 255)
    local TagBackground_1 = arg14._tag_background
    TagBackground_1.ImageColor3 = v11 and v11.Color or Color3.fromRGB(0, 0, 0)

    if not arg14._ignore_button_effect then
        ButtonEffect_m:Add(arg14.Frame.Button, nil, t_1)
    end
end

function t._Init(arg15) -- line: 129
    arg15.VoteBanFrame.CreateSound:Connect(function(...) -- line: 130
        -- upvalues:
        --  [1] arg15 (copy)

        arg15.CreateSound:Fire(...)
    end)
    arg15._tag_title:GetPropertyChangedSignal("TextBounds"):Connect(function() -- line: 134
        -- upvalues:
        --  [1] arg15 (copy)

        arg15:_Update()
    end)
    arg15:_Setup()
    arg15:_Update()
    arg15:UpdateVotes()
end

return t
