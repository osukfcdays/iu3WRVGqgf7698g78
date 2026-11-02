local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local DuelLibrary_m = require(ReplicatedStorage.Modules.DuelLibrary)
local ButtonEffect_m = require(Players.LocalPlayer.PlayerScripts.Modules.ButtonEffect)
local LockedMapSlot = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("LockedMapSlot")
local t = {}
local t_1 = { ReleaseRatio = 1.025, HoverRatio = 1.025 }
t.__index = t

function t.new(arg1, arg2) -- line: 13
    -- upvalues:
    --  [1] t (copy)
    --  [2] LockedMapSlot (copy)

    local t_2 = setmetatable({}, t)
    t_2.Name = arg1
    t_2.Frame = LockedMapSlot:Clone()
    t_2._ignore_button_effect = arg2
    t_2:_Init()

    return t_2
end

function t.SetParent(arg3, arg4) -- line: 30
    arg3.Frame.Parent = arg4
end

function t.Destroy(arg5) -- line: 34
    arg5.Frame:Destroy()
end

function t._Setup(arg6) -- line: 42
    -- upvalues:
    --  [1] DuelLibrary_m (copy)
    --  [2] ButtonEffect_m (copy)
    --  [3] t_1 (copy)

    local v1 = DuelLibrary_m.MapDifficulties[DuelLibrary_m.Maps[arg6.Name].Difficulty]
    local _, _, v4 = v1.Color:ToHSV()
    local Background = arg6.Frame.Button.Background
    Background.ImageColor3 = v4 < 0.1 and Color3.fromRGB(31, 31, 31) or Color3.fromRGB(0, 0, 0)
    arg6.Frame.Button.Background.Texture.ImageColor3 = v1.Color
    arg6.Frame.Button.Difficulty.BackgroundColor3 = v1.Color
    arg6.Frame.Button.Difficulty.ImageColor3 = v1.Color
    arg6.Frame.Button.Difficulty.UIStroke.Color = v1.Color
    arg6.Frame.Button.DifficultyVignette.ImageColor3 = v1.Color

    if not arg6._ignore_button_effect then
        ButtonEffect_m:Add(arg6.Frame.Button, nil, t_1)
    end
end

function t._Init(arg7) -- line: 59
    arg7:_Setup()
end

return t
