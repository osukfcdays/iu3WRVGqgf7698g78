local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local CONSTANTS_m = require(ReplicatedStorage.Modules.CONSTANTS)
local Signal_m = require(ReplicatedStorage.Modules.Signal)
local ControlsController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("ControlsController")
)
local ButtonEffect_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("ButtonEffect")
)
local SettingTabSlot = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild(
    "SettingTabSlot"
)
local t = {
    { "Video", "rbxassetid://111628467664626" },
    { "Audio", "rbxassetid://77374671054355" },
    { "Game", "rbxassetid://76006565289299" },
    { "Crosshair", "rbxassetid://132790955082325" },
    { "Hotkeys", "rbxassetid://74762673547084" },
    { "Touch", "rbxassetid://123856214444472" },
    { "Account", string.format(CONSTANTS_m.HEADSHOT_IMAGE, Players.LocalPlayer.UserId) }
}
local t_8 = {}
t_8.__index = t_8

function t_8.new(arg1) -- line: 23
    -- upvalues:
    --  [1] t_8 (copy)
    --  [2] Signal_m (copy)

    local t_9 = setmetatable({}, t_8)
    t_9.Clicked = Signal_m.new()
    t_9.Page = arg1
    t_9.Frame = t_9.Page.Container:WaitForChild("Tabs")
    t_9.Background = t_9.Frame:WaitForChild("Background")
    t_9.Container = t_9.Frame:WaitForChild("Container")
    t_9.Layout = t_9.Container:WaitForChild("Layout")
    t_9._tab_frames = {}
    t_9:_Init()

    return t_9
end

function t_8.SetPage(arg2, arg3) -- line: 45
    for key, val in pairs(arg2._tab_frames) do
        local v3 = if arg3 ~= key then false else true
        local Title = val.Button.Title
        local v4 = if not v3 then Color3.fromRGB(255, 255, 255) else Color3.fromRGB(0, 0, 0)
        Title.TextColor3 = v4
        local UIStroke = val.Button.Title.UIStroke
        v4 = if not v3 then Color3.fromRGB(0, 0, 0) else Color3.fromRGB(255, 255, 255)
        UIStroke.Color = v4
        v4 = if not v3 then 0.75 else 0
        val.Button.Title.UIStroke.Transparency = v4
        val.Button.Background.Visible = v3
    end
end

function t_8._UpdateControls(arg4) -- line: 60
    -- upvalues:
    --  [1] ControlsController_m (copy)

    local Touch = arg4._tab_frames.Touch
    Touch.Visible = ControlsController_m.CurrentControls == "Touch"
    arg4._tab_frames.Hotkeys.Visible = not arg4._tab_frames.Touch.Visible
end

function t_8._Setup(arg5) -- line: 65
    -- upvalues:
    --  [1] t (copy)
    --  [2] SettingTabSlot (copy)
    --  [3] ButtonEffect_m (copy)

    local v7

    for key_1, val_1 in pairs(t) do
        local v6, v7 = table.unpack(val_1)
        local v8 = SettingTabSlot:Clone()
        v8.Button.Title.Text = v6
        v8.Button.Icon.Image = v7
        v8.LayoutOrder = key_1
        v8.Parent = arg5.Container
        arg5._tab_frames[v6] = v8
        v8.Button.MouseButton1Click:Connect(function() -- line: 75
            -- upvalues:
            --  [1] arg5 (copy)
            --  [2] v6 (copy)

            arg5.Clicked:Fire(v6)
        end)
        ButtonEffect_m:Add(v8.Button)

        if v6 == "Account" then
            local UICorner = Instance.new("UICorner")
            UICorner.CornerRadius = UDim.new(1, 0)
            UICorner.Parent = v8.Button.Icon
        end
    end
end

function t_8._Init(arg6) -- line: 89
    -- upvalues:
    --  [1] ControlsController_m (copy)

    arg6.Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() -- line: 90
        -- upvalues:
        --  [1] arg6 (copy)

        arg6.Background.Size = UDim2.new(0, arg6.Layout.AbsoluteContentSize.X, 1.25, 0)
    end)
    ControlsController_m.ControlsChanged:Connect(function() -- line: 94
        -- upvalues:
        --  [1] arg6 (copy)

        arg6:_UpdateControls()
    end)
    arg6:_Setup()
    arg6:_UpdateControls()
end

return t_8
