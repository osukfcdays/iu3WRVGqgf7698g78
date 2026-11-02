local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local ItemLibrary_m = require(ReplicatedStorage.Modules.ItemLibrary)
local Signal_m = require(ReplicatedStorage.Modules.Signal)
local WeaponStatusHandler_m = require(Players.LocalPlayer.PlayerScripts.Modules.WeaponStatusHandler)
local VoteBanFrame_m = require(Players.LocalPlayer.PlayerScripts.Modules.VoteBanFrame)
local ButtonEffect_m = require(Players.LocalPlayer.PlayerScripts.Modules.ButtonEffect)
local WeaponSlot = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("WeaponSlot")
local t = {}
t.__index = t

function t.new(arg1, arg2) -- line: 16
    -- upvalues:
    --  [1] t (copy)
    --  [2] Signal_m (copy)
    --  [3] WeaponSlot (copy)

    local t_1 = setmetatable({}, t)
    t_1.PlayBanFrameSound = Signal_m.new()
    t_1.Name = arg1
    t_1.WeaponData = arg2
    t_1.Frame = WeaponSlot:Clone()
    t_1._destroyed = false
    t_1._vote_ban_frame = nil
    t_1:_Init()

    return t_1
end

function t.DisableButton(arg3) -- line: 37
    arg3.Frame.Button.Interactable = false
end

function t.ToggleBanned(arg4, arg5, arg6) -- line: 41
    -- upvalues:
    --  [1] VoteBanFrame_m (copy)

    arg4.Frame.Button.Icon.ClipsDescendants = true
    arg4.Frame.Button.Title.Visible = false
    local v1 = VoteBanFrame_m.new(arg4.Frame.Button, UDim2.new(0.75, 0, 0.75, 0))
    v1.CreateSound:Connect(function(...) -- line: 47
        -- upvalues:
        --  [1] arg4 (copy)

        arg4.PlayBanFrameSound:Fire(...)
    end)
    task.delay(
        arg5,
        v1.Play,
        v1,
        arg6,
        true
    )
end

function t.HideName(arg7) -- line: 54
    arg7.Frame.Button.Title.Text = "???"
end

function t.Lock(arg8) -- line: 58
    arg8.Frame.Button.Locked.Visible = true
    arg8.Frame.Button.Title.TextTransparency = 0.5
    arg8.Frame.Button.Icon.Picture.ImageColor3 = Color3.fromRGB(0, 0, 0)
    arg8.Frame.Button.Icon.Picture.ImageTransparency = 0.5
end

function t.Destroy(arg9) -- line: 65
    if arg9._destroyed then
        return
    end

    arg9._destroyed = true
    arg9.PlayBanFrameSound:Destroy()

    if arg9._vote_ban_frame then
        arg9._vote_ban_frame:Destroy()
    end

    pcall(function() -- line: 78
        -- upvalues:
        --  [1] arg9 (copy)

        arg9.Frame:Destroy()
    end)
end

function t._Setup(arg10) -- line: 87
    -- upvalues:
    --  [1] ItemLibrary_m (copy)
    --  [2] WeaponStatusHandler_m (copy)

    arg10.Frame.Button.Title.Text = arg10.Name
    local Picture_1 = arg10.Frame.Button.Icon.Picture
    Picture_1.Image = arg10.WeaponData and ItemLibrary_m:GetViewModelImageFromWeaponData(
        arg10.WeaponData
    ) or ItemLibrary_m:GetViewModelImage(arg10.Name) or ""
    WeaponStatusHandler_m:ApplyItemStatusToBackground(
        arg10.Frame.Button.Background,
        arg10.Frame.Button.Background.UIStroke,
        ItemLibrary_m.Items[arg10.Name].Status
    )
end

function t._Init(arg11) -- line: 93
    -- upvalues:
    --  [1] ButtonEffect_m (copy)

    arg11.Frame.Destroying:Connect(function() -- line: 94
        -- upvalues:
        --  [1] arg11 (copy)

        arg11:Destroy()
    end)
    arg11:_Setup()
    ButtonEffect_m:Add(arg11.Frame.Button)
end

return t
