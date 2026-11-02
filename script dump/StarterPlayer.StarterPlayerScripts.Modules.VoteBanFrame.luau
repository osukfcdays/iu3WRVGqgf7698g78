local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local DuelLibrary_m = require(ReplicatedStorage.Modules.DuelLibrary)
local Signal_m = require(ReplicatedStorage.Modules.Signal)
local VoteBanFrame = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("VoteBanFrame")
local color = Color3.fromRGB(255, 50, 50)
local color_1 = Color3.fromRGB(127, 25, 25)
local t = {}
t.__index = t

function t.new(arg1, arg2) -- line: 15
    -- upvalues:
    --  [1] t (copy)
    --  [2] Signal_m (copy)
    --  [3] VoteBanFrame (copy)

    local t_1 = setmetatable({}, t)
    t_1.CreateSound = Signal_m.new()
    t_1.Frame = VoteBanFrame:Clone()
    t_1.Icon = t_1.Frame:WaitForChild("Icon")
    t_1.Outline = t_1.Frame:WaitForChild("Outline")
    t_1.Background = t_1.Frame:WaitForChild("Background")
    t_1._parent = arg1
    t_1._size = arg2 or UDim2.new(1, 0, 1, 0)
    t_1._played = false
    t_1:_Init()

    return t_1
end

function t.Play(arg3, arg4, arg5) -- line: 38
    -- upvalues:
    --  [1] color (copy)
    --  [2] DuelLibrary_m (copy)
    --  [3] color_1 (copy)
    --  [4] TweenService (copy)

    if arg3._played then
        return
    end

    arg3._played = true
    local v2 = not arg4 and color or DuelLibrary_m:GetTeamColor(arg4)
    local color_2 = Color3.new(v2.R * 0.5, v2.G * 0.5, v2.B * 0.5)
    local v3 = arg5 and v2 or color
    local v4 = arg5 and color_2 or color_1
    local v5 = arg5 and color or v2
    v2 = arg5 and color_1 or color_2
    arg3.Icon.ImageColor3 = v3
    arg3.Icon.Size = UDim2.new(1, -16, 1, -16)
    arg3.Icon.Position = UDim2.new(0.5, 0, 0.4, 0)
    arg3.Icon.Rotation = -45
    arg3.Outline.ImageColor3 = v3
    arg3.Outline.SliceScale = 0
    arg3.Background.ImageColor3 = v4
    arg3.Frame.Visible = true
    TweenService:Create(
        arg3.Icon,
        TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        {
            Size = UDim2.new(0.75, -16, 0.75, -16),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            Rotation = 0
        }
    ):Play()
    TweenService:Create(
        arg3.Icon,
        TweenInfo.new(1, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut),
        { ImageColor3 = v5 }
    ):Play()
    TweenService:Create(
        arg3.Outline,
        TweenInfo.new(0.125, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
        { SliceScale = 0.375 }
    ):Play()
    TweenService:Create(
        arg3.Outline,
        TweenInfo.new(1, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut),
        { ImageColor3 = v5 }
    ):Play()
    TweenService:Create(
        arg3.Background,
        TweenInfo.new(1, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut),
        { ImageColor3 = v2 }
    ):Play()
    arg3.CreateSound:Fire(
        "rbxassetid://115599786018668",
        0.75,
        1.5,
        script,
        true,
        5
    )
    arg3.CreateSound:Fire(
        "rbxassetid://101678983789054",
        0.5,
        1,
        script,
        true,
        5
    )
end

function t.Destroy(arg6) -- line: 72
    arg6._played = true
    arg6.Frame:Destroy()
end

function t._Setup(arg7) -- line: 81
    arg7.Frame.Visible = false
    arg7.Frame.Size = arg7._size
    arg7.Frame.Parent = arg7._parent
end

function t._Init(arg8) -- line: 87
    arg8:_Setup()
end

return t
