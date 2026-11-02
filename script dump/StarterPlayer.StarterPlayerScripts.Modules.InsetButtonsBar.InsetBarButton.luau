local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local _ = require(ReplicatedStorage.Modules.Utility)
local Signal_m = require(ReplicatedStorage.Modules.Signal)
local ButtonEffect_m = require(Players.LocalPlayer.PlayerScripts.Modules.ButtonEffect)
local InsetBarButton = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild(
    "InsetBarButton"
)
local t = {}
t.__index = t

function t.new(
    arg1,
    arg2,
    arg3,
    arg4,
    arg5,
    arg6,
    arg7
) -- line: 14
    -- upvalues:
    --  [1] t (copy)
    --  [2] Signal_m (copy)
    --  [3] InsetBarButton (copy)

    local t_1 = setmetatable({}, t)
    t_1.Clicked = Signal_m.new()
    t_1.Entered = Signal_m.new()
    t_1.Name = arg1
    t_1.Frame = InsetBarButton:Clone()
    t_1._screen_gui_connections = {}
    t_1._display_name = arg2
    t_1._visual = arg3
    t_1._visual_position = arg4
    t_1._visual_size = arg5
    t_1._visual_color = arg6
    t_1._is_mirrored = arg7
    t_1._bubble_frame = t_1.Frame.Button.OnHover.Bubble
    t_1._bubble_effect_hash = 0
    t_1._bubble_effect_playing = false
    t_1._original_icon_size = nil
    t_1._screen_gui = nil
    t_1:_Init()

    return t_1
end

function t.SetParent(arg8, arg9) -- line: 45
    arg8.Frame.Parent = arg9
end

function t.SetMirrored(arg10, arg11) -- line: 49
    if arg11 == arg10._is_mirrored then
        return
    end

    arg10._is_mirrored = arg11
    arg10:_UpdateMirrored()
end

function t.Enter(arg12) -- line: 58
    if arg12._bubble_effect_playing then
        return
    end

    arg12.Frame.Button.OnHover.Visible = true
    arg12._bubble_frame.Visible = true
    arg12.Entered:Fire()
end

function t.Leave(arg13) -- line: 68
    if arg13._bubble_effect_playing then
        return
    end

    arg13.Frame.Button.OnHover.Visible = false
    arg13._bubble_frame.Visible = false
end

function t.SetBubbleText(arg14, arg15) -- line: 77
    arg14._bubble_frame.Container.Title.Text = arg15
end

function t.PlayJiggleEffect(arg16) -- line: 81
    arg16.Frame.Button.Icon.Size = UDim2.new(
        arg16._original_icon_size.X.Scale * 1.5,
        arg16._original_icon_size.X.Offset * 1.5,
        arg16._original_icon_size.Y.Scale * 1.5,
        arg16._original_icon_size.Y.Offset * 1.5
    )
    arg16.Frame.Button.Icon:TweenSize(
        arg16._original_icon_size,
        "Out",
        "Back",
        0.25,
        true
    )
end

function t.PlayBubbleEffect(arg17, arg18) -- line: 92
    -- upvalues:
    --  [1] Players (copy)

    arg17._bubble_effect_hash += 1

    if not arg18 then
        local _ = arg17._bubble_effect_hash
        arg17:_DisableBubbleEffect()

        return
    end

    local BubbleEffectHash_1 = arg17._bubble_effect_hash
    arg17._bubble_effect_playing = true
    arg17.Frame.Button.OnHover.Visible = true
    arg17._bubble_frame.Container.Visible = true
    arg17._bubble_frame.Container.Title.Text = arg18
    task.delay(3, function() -- line: 106
        -- upvalues:
        --  [1] BubbleEffectHash_1 (copy)
        --  [2] arg17 (copy)
        --  [3] Players (ref)

        wait(3)

        if BubbleEffectHash_1 ~= arg17._bubble_effect_hash or not arg17.Frame:IsDescendantOf(
            Players
        ) then
            return
        end

        arg17:_DisableBubbleEffect()
    end)
end

function t.Destroy(arg19) -- line: 117
    for _, val in pairs(arg19._screen_gui_connections) do
        val:Disconnect()
    end

    arg19._screen_gui_connections = {}
    arg19.Clicked:Destroy()
    arg19.Entered:Destroy()
    pcall(function() -- line: 127
        -- upvalues:
        --  [1] arg19 (copy)

        arg19.Frame:Destroy()
    end)
end

function t._GetScreenGui(arg20) -- line: 136
    -- upvalues:
    --  [1] Players (copy)

    local v1 = arg20.Frame

    while v1 do
        if v1 == Players.LocalPlayer then
            break
        end

        v1 = v1.Parent

        if v1 and v1:IsA("ScreenGui") then
            return v1
        end
    end

    return nil
end

function t._VerifyScreenGui(arg21) -- line: 150
    for _, val_1 in pairs(arg21._screen_gui_connections) do
        val_1:Disconnect()
    end

    arg21._screen_gui_connections = {}
    arg21._screen_gui = arg21:_GetScreenGui()
    arg21._bubble_frame.Parent = arg21._screen_gui

    if not arg21._screen_gui then
        return
    end

    table.insert(arg21._screen_gui_connections, arg21._screen_gui:GetPropertyChangedSignal(
        "AbsolutePosition"
    ):Connect(function() -- line: 163
        -- upvalues:
        --  [1] arg21 (copy)

        arg21:_UpdateBubble()
    end))
    arg21:_UpdateBubble()
end

function t._DisableBubbleEffect(arg22) -- line: 170
    arg22:_ResetBubbleVisibility()
    arg22._bubble_effect_playing = false
    arg22:Leave()
end

function t._ResetBubbleVisibility(arg23) -- line: 176
    local Container = arg23._bubble_frame.Container
    Container.Visible = arg23._display_name ~= nil
end

function t._UpdateBubble(arg24) -- line: 180
    if not arg24._screen_gui then
        return
    end

    arg24._bubble_frame.Container.Background.Size = UDim2.new(
        0.25,
        arg24._bubble_frame.Container.Title.TextBounds.X,
        1,
        0
    )
    local BubbleFrame = arg24._bubble_frame
    BubbleFrame.Position = UDim2.new(
        0,
        arg24.Frame.Button.OnHover.AbsolutePosition.X - arg24._screen_gui.AbsolutePosition.X + arg24.Frame.Button.OnHover.AbsoluteSize.X / 2,
        0,
        arg24.Frame.Button.OnHover.AbsolutePosition.Y + arg24.Frame.Button.OnHover.AbsoluteSize.Y - arg24._screen_gui.AbsolutePosition.Y
    )
    arg24._bubble_frame.Size = UDim2.new(
        0,
        arg24.Frame.Button.OnHover.AbsoluteSize.X,
        0,
        arg24.Frame.Button.OnHover.AbsoluteSize.Y
    )
end

function t._UpdateBubbleContainer(arg25) -- line: 190
    local v4 = 1

    for index = 1, #arg25._bubble_frame.Container.Title.Text do
        if string.sub(arg25._bubble_frame.Container.Title.Text, index, index) == "\n" then
            v4 += 1
        end
    end

    arg25._bubble_frame.Container.Size = UDim2.new(3.25, 0, v4 * 0.75, 0)
    arg25._bubble_frame.Container.Arrow.Size = UDim2.new(0.5 / v4, 0, 0.5 / v4, 0)
    arg25:_UpdateBubble()
end

function t._UpdateMirrored(arg26) -- line: 204
    local Title = arg26._bubble_frame.Container.Title
    Title.AnchorPoint = arg26._is_mirrored and Vector2.new(1, 0.5) or Vector2.new(0, 0.5)
    local Title_1 = arg26._bubble_frame.Container.Title
    Title_1.Position = arg26._is_mirrored and UDim2.new(0.875, 0, 0.5, 0) or UDim2.new(
        0.125,
        0,
        0.5,
        0
    )
    local Title_2 = arg26._bubble_frame.Container.Title
    Title_2.TextXAlignment = arg26._is_mirrored and Enum.TextXAlignment.Right or Enum.TextXAlignment.Left
    local Background_1 = arg26._bubble_frame.Container.Background
    Background_1.AnchorPoint = arg26._is_mirrored and Vector2.new(1, 0.5) or Vector2.new(0, 0.5)
    local Background_2 = arg26._bubble_frame.Container.Background
    Background_2.Position = arg26._is_mirrored and UDim2.new(1, 0, 0.5, 0) or UDim2.new(
        0,
        0,
        0.5,
        0
    )
    local Arrow_1 = arg26._bubble_frame.Container.Arrow
    Arrow_1.Position = arg26._is_mirrored and UDim2.new(0.75, 0, 0, 2) or UDim2.new(0.25, 0, 0, 2)
    local Container_2 = arg26._bubble_frame.Container
    Container_2.AnchorPoint = arg26._is_mirrored and Vector2.new(0.75, 0) or Vector2.new(0.25, 0)
end

function t._Setup(arg27) -- line: 214
    local v6 = if typeof(arg27._visual) == "string" then if #arg27._visual >= 13 then if string.sub(
        arg27._visual,
        1,
        13
    ) ~= "rbxassetid://" then false else true else false else false
    local Icon_1 = arg27.Frame.Button.Icon
    local v7 = v6 and arg27._visual or ""
    Icon_1.Image = v7
    v7 = arg27._visual_position
    local Icon_2 = arg27.Frame.Button.Icon

    if not v7 then
        v7 = UDim2.new(0.5, 0, 0.5, 0)
    end

    Icon_2.Position = v7
    v7 = arg27._visual_size
    local Icon_3 = arg27.Frame.Button.Icon

    if not v7 then
        v7 = UDim2.new(0.5, 0, 0.5, 0)
    end

    Icon_3.Size = v7
    v7 = arg27._visual_position
    local Title_3 = arg27.Frame.Button.Title

    if not v7 then
        v7 = UDim2.new(0.5, 0, 0.5, 0)
    end

    Title_3.Position = v7
    v7 = arg27._visual_size
    local Title_4 = arg27.Frame.Button.Title
    v7 = v7 or UDim2.new(0.5, 0, 0.5, 0)
    Title_4.Size = v7
    local Title_5 = arg27.Frame.Button.Title
    v7 = not v6 and arg27._visual or ""
    Title_5.Text = v7
    arg27.Frame.Button.Title.TextColor3 = arg27._visual_color
    arg27.Frame.Button.Icon.ImageColor3 = arg27._visual_color
    arg27.Frame.Button.OnHover.Visible = false
    arg27.Frame.Button.OnHover.BackgroundTransparency = 0.75
    arg27._bubble_frame.Container.Title.Text = arg27._display_name or ""
    arg27._bubble_frame.ZIndex = 999
    arg27._bubble_frame.Parent = nil
    arg27._original_icon_size = arg27.Frame.Button.Icon.Size
end

function t._Init(arg28) -- line: 235
    -- upvalues:
    --  [1] ButtonEffect_m (copy)

    arg28.Frame.AncestryChanged:Connect(function() -- line: 236
        -- upvalues:
        --  [1] arg28 (copy)

        arg28:_VerifyScreenGui()
    end)
    arg28.Frame.Destroying:Connect(function() -- line: 240
        -- upvalues:
        --  [1] arg28 (copy)

        arg28:Destroy()
    end)
    arg28.Frame.Button.MouseButton1Click:Connect(function() -- line: 244
        -- upvalues:
        --  [1] arg28 (copy)

        arg28.Clicked:Fire()
    end)
    arg28.Frame.MouseEnter:Connect(function() -- line: 248
        -- upvalues:
        --  [1] arg28 (copy)

        arg28:Enter()
    end)
    arg28.Frame.MouseLeave:Connect(function() -- line: 252
        -- upvalues:
        --  [1] arg28 (copy)

        arg28:Leave()
    end)
    arg28.Frame:GetPropertyChangedSignal("AbsolutePosition"):Connect(function() -- line: 256
        -- upvalues:
        --  [1] arg28 (copy)

        arg28:_UpdateBubble()
    end)
    arg28.Frame:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- line: 260
        -- upvalues:
        --  [1] arg28 (copy)

        arg28:_UpdateBubble()
    end)
    arg28.Frame:GetPropertyChangedSignal("Visible"):Connect(function() -- line: 264
        -- upvalues:
        --  [1] arg28 (copy)

        arg28:Leave()
    end)
    arg28.Frame.Button.OnHover:GetPropertyChangedSignal("AbsolutePosition"):Connect(function() -- line: 268
        -- upvalues:
        --  [1] arg28 (copy)

        arg28:_UpdateBubble()
    end)
    arg28.Frame.Button.OnHover:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- line: 272
        -- upvalues:
        --  [1] arg28 (copy)

        arg28:_UpdateBubble()
    end)
    arg28._bubble_frame.Container.Title:GetPropertyChangedSignal("TextBounds"):Connect(function() -- line: 276
        -- upvalues:
        --  [1] arg28 (copy)

        arg28:_UpdateBubble()
    end)
    arg28._bubble_frame.Container.Title:GetPropertyChangedSignal("Text"):Connect(function() -- line: 280
        -- upvalues:
        --  [1] arg28 (copy)

        arg28:_UpdateBubbleContainer()
    end)
    arg28:_Setup()
    arg28:_UpdateMirrored()
    arg28:_UpdateBubble()
    arg28:_ResetBubbleVisibility()
    arg28:_UpdateBubbleContainer()
    arg28:_VerifyScreenGui()
    arg28:Leave()
    ButtonEffect_m:Add(arg28.Frame.Button, true)
end

return t
