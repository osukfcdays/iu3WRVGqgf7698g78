local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Signal_m = require(ReplicatedStorage.Modules.Signal)
local UILibrary_m = require(Players.LocalPlayer.PlayerScripts.Modules.UILibrary)
local InsetBarButton_m = require(script:WaitForChild("InsetBarButton"))
local InsetButtonsBar = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild(
    "InsetButtonsBar"
)
local t = {}
t.__index = t

function t.new(arg1, arg2, arg3, arg4) -- line: 13
    -- upvalues:
    --  [1] t (copy)
    --  [2] Signal_m (copy)
    --  [3] InsetButtonsBar (copy)

    local t_1 = setmetatable({}, t)
    t_1.OpenedChanged = Signal_m.new()
    t_1.Frame = InsetButtonsBar:Clone()
    t_1.Container = t_1.Frame:WaitForChild("Container")
    t_1.Layout = t_1.Container:WaitForChild("Layout")
    t_1.IsOpen = nil
    t_1.Buttons = {}
    t_1._background_transparency = arg1
    t_1._background_color = arg2
    t_1._visual_color = arg3
    t_1._is_mirrored = arg4
    t_1._num_buttons_visible_while_closed = 1
    t_1:_Init()

    return t_1
end

function t.IsWithin(arg5, arg6, arg7) -- line: 40
    -- upvalues:
    --  [1] UILibrary_m (copy)

    local v2 = arg5.Frame.Visible

    if v2 then
        v2 = if arg5:GetNumVisibleButtons() > 0 then UILibrary_m:IsWithinBounds(
            arg6,
            arg7,
            arg5.Frame.AbsolutePosition,
            arg5.Frame.AbsoluteSize
        ) else false
    end

    return v2
end

function t.GetVisualColor(arg8) -- line: 44
    return arg8._visual_color
end

function t.GetBackgroundColor(arg9) -- line: 48
    return arg9._background_color
end

function t.GetNumVisibleButtons(arg10) -- line: 52
    local v3 = 0

    for _, val in pairs(arg10.Buttons) do
        if val.Frame.Visible then
            v3 += 1
        end
    end

    return v3
end

function t.SetMirrored(arg11, arg12) -- line: 64
    if arg12 == arg11._is_mirrored then
        return
    end

    arg11._is_mirrored = arg12
    arg11:_UpdateMirrored()
end

function t.Toggle(arg13, arg14, _) -- line: 73
    arg13.IsOpen = if arg14 ~= nil then arg14 else not arg13.IsOpen
    arg13.OpenedChanged:Fire(arg13.IsOpen)
end

function t.SetClosedButtonsVisible(arg16, arg17) -- line: 78
    arg16._num_buttons_visible_while_closed = arg17
    arg16.OpenedChanged:Fire(arg16.IsOpen)
end

function t.CreateButton(
    arg18,
    arg19,
    arg20,
    arg21,
    arg22,
    arg23,
    arg24
) -- line: 83
    -- upvalues:
    --  [1] InsetBarButton_m (copy)

    local v5 = InsetBarButton_m.new(
        arg20,
        arg21,
        arg22,
        arg23,
        arg24,
        arg18._visual_color,
        arg18._is_mirrored
    )
    local Frame = v5.Frame
    local v6 = if not arg18._is_mirrored then 1 else -1
    Frame.LayoutOrder = arg19 * v6
    v5:SetParent(arg18.Container)
    v5.Frame:GetPropertyChangedSignal("Visible"):Connect(function() -- line: 88
        -- upvalues:
        --  [1] arg18 (copy)

        arg18:Toggle(arg18.IsOpen)
    end)
    v5.Entered:Connect(function() -- line: 92
        -- upvalues:
        --  [1] arg18 (copy)
        --  [2] arg20 (copy)

        for key_1, val_1 in pairs(arg18.Buttons) do
            if key_1 ~= arg20 then
                val_1:PlayBubbleEffect(nil)
                val_1:Leave()
            end
        end
    end)
    arg18.Buttons[v5.Name] = v5

    return v5
end

function t.RemoveButton(arg25, arg26) -- line: 106
    local v7 = arg25.Buttons[arg26]

    if not v7 then
        return
    end

    arg25.Buttons[arg26] = nil
    v7:Destroy()
    arg25:Toggle(arg25.IsOpen)
end

function t.Destroy(arg27) -- line: 118
    for _, val_2 in pairs(arg27.Buttons) do
        val_2:Destroy()
    end

    arg27.Frame:Destroy()
    arg27.OpenedChanged:Destroy()
end

function t._UpdateMirrored(arg28) -- line: 131
    local Container = arg28.Container
    Container.AnchorPoint = arg28._is_mirrored and Vector2.new(1, 0) or Vector2.new(0, 0)
    local Container_1 = arg28.Container
    Container_1.Position = arg28._is_mirrored and UDim2.new(1, 0, 0, 0) or UDim2.new(0, 0, 0, 0)
    local Layout = arg28.Layout
    Layout.HorizontalAlignment = arg28._is_mirrored and Enum.HorizontalAlignment.Right or Enum.HorizontalAlignment.Left

    for _, val_3 in pairs(arg28.Buttons) do
        val_3.Frame.LayoutOrder = math.abs(val_3.Frame.LayoutOrder) * (if arg28._is_mirrored then -1 else 1)
        val_3:SetMirrored(arg28._is_mirrored)
    end
end

function t._LeaveButtons(arg29) -- line: 142
    for _, val_4 in pairs(arg29.Buttons) do
        val_4:Leave()
    end
end

function t._UpdateSize(arg30) -- line: 148
    -- upvalues:
    --  [1] Players (copy)

    local v10 = arg30.IsOpen and UDim2.new(arg30:GetNumVisibleButtons(), 0, 1, 0) or UDim2.new(
        arg30._num_buttons_visible_while_closed,
        0,
        1,
        0
    )

    if arg30.Frame:IsDescendantOf(Players) then
        arg30.Frame:TweenSize(
            v10,
            "Out",
            "Quint",
            0.25,
            true
        )

        return
    end

    arg30.Frame.Size = v10
end

function t._Setup(arg31) -- line: 158
    arg31.Frame.BackgroundTransparency = arg31._background_transparency
    arg31.Frame.BackgroundColor3 = arg31._background_color
    arg31.Frame:AddTag("CoreGuiBackground")
end

function t._Init(arg32) -- line: 164
    arg32.OpenedChanged:Connect(function() -- line: 165
        -- upvalues:
        --  [1] arg32 (copy)

        arg32:_UpdateSize()
        arg32:_LeaveButtons()
    end)
    arg32:_Setup()
    arg32:_UpdateSize()
    arg32:_UpdateMirrored()
    arg32:Toggle(false)
end

return t
