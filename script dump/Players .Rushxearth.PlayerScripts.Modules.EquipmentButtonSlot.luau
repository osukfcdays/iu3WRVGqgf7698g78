local Players = game:GetService("Players")
local WeaponStatusHandler_m = require(Players.LocalPlayer.PlayerScripts.Modules.WeaponStatusHandler)
local ButtonEffect_m = require(Players.LocalPlayer.PlayerScripts.Modules.ButtonEffect)
local EquipmentButtonSlot = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild(
    "EquipmentButtonSlot"
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
) -- line: 11
    -- upvalues:
    --  [1] t (copy)
    --  [2] EquipmentButtonSlot (copy)

    local t_1 = setmetatable({}, t)
    t_1.Name = arg1
    t_1.Frame = EquipmentButtonSlot:Clone()
    t_1.Button = t_1.Frame:WaitForChild("Button")
    t_1.Background = t_1.Button:WaitForChild("Background")
    t_1.LockedLeft = t_1.Button:WaitForChild("LockedLeft")
    t_1.LockedRight = t_1.Button:WaitForChild("LockedRight")
    t_1.Icon = t_1.Button:WaitForChild("Icon")
    t_1.Title = t_1.Button:WaitForChild("Title")
    t_1.Notification = t_1.Title:WaitForChild("Notification")
    t_1.NotificationTitle = t_1.Notification:WaitForChild("Title")
    t_1._layout_order = arg2
    t_1._is_unlocked = arg3
    t_1._display_name = arg4
    t_1._image = arg5
    t_1._status = arg6
    t_1._num_notifications = arg7 or 0
    t_1._is_icon_locked = false
    t_1._is_active = false
    t_1:_Init()

    return t_1
end

function t.SetParent(arg8, arg9) -- line: 43
    arg8.Frame.Parent = arg9
end

function t.SetCareerIcon(arg10) -- line: 47
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = arg10.Icon
    arg10.Icon.Size = UDim2.new(1.1, 0, 1.1, 0)
    arg10._is_icon_locked = true
end

function t.SetActive(arg11, arg12) -- line: 56
    if arg11._is_active == arg12 then
        return
    end

    arg11._is_active = arg12
    local Frame = arg11.Frame
    Frame:TweenSize(
        if not arg11._is_active then UDim2.new(1, 0, 0.2, 0) else UDim2.new(1, 0, 0.25, 0),
        "Out",
        if not arg11._is_active then "Quint" else "Back",
        0.5,
        true
    )
    arg11.Icon:TweenPosition(
        if arg11._is_active and not arg11._is_icon_locked then UDim2.new(0.8, 0, 0.5, 0) else UDim2.new(
            0.2,
            0,
            0.5,
            0
        ),
        "Out",
        "Quint",
        0.5,
        true
    )
    arg11.Background.Visible = arg11._is_active
    arg11.LockedLeft.Size = if arg11._is_active then UDim2.new(0.5, 0, 0.375, 0) else UDim2.new(
        0.75,
        0,
        0.375,
        0
    )
    arg11.LockedRight.Size = arg11.LockedLeft.Size
    local Icon_2 = arg11.Icon
    Icon_2.ImageTransparency = if arg11._is_active then 0 else if not arg11._is_unlocked then 0.5 else 0
    local Title = arg11.Title
    Title.TextColor3 = if arg11._is_active then Color3.fromRGB(255, 255, 255) else if not arg11._is_unlocked then Color3.fromRGB(
        0,
        0,
        0
    ) else Color3.fromRGB(255, 255, 255)
    local Title_1 = arg11.Title
    Title_1.TextTransparency = if not arg11._is_active then 0.5 else 0
    local LockedLeft_1 = arg11.LockedLeft
    LockedLeft_1.ImageTransparency = if not arg11._is_active then 0.5 else 0
    local LockedLeft_2 = arg11.LockedLeft
    LockedLeft_2.ImageColor3 = if not arg11._is_active then Color3.fromRGB(0, 0, 0) else Color3.fromRGB(
        255,
        255,
        255
    )
    arg11.LockedRight.ImageTransparency = arg11.LockedLeft.ImageTransparency
    arg11.LockedRight.ImageColor3 = arg11.LockedLeft.ImageColor3
    arg11.Frame.ClipsDescendants = not arg11._is_active
    arg11.Frame.ZIndex = if arg11._is_active then 2 else 1
    local v4 = not arg11._is_active
    local Notification = arg11.Notification
    v4 = v4 and arg11._num_notifications > 0
    Notification.Visible = v4
end

function t.Destroy(arg13) -- line: 80
    arg13.Frame:Destroy()
end

function t._Update(arg14) -- line: 88
    arg14.LockedLeft.Position = UDim2.new(0.5, -arg14.Title.TextBounds.X / 2, 0.5, 0)
    arg14.LockedRight.Position = UDim2.new(0.5, arg14.Title.TextBounds.X / 2, 0.5, 0)
    arg14.Notification.Position = UDim2.new(
        0.5,
        arg14.Title.TextBounds.X / 2 + arg14.Notification.AbsoluteSize.X / 2,
        0.5,
        0
    )
end

function t._Setup(arg15) -- line: 94
    -- upvalues:
    --  [1] WeaponStatusHandler_m (copy)

    arg15.Frame.LayoutOrder = arg15._layout_order
    arg15.LockedLeft.Visible = not arg15._is_unlocked
    arg15.LockedRight.Visible = not arg15._is_unlocked
    arg15.Title.Text = arg15._display_name
    local Title_2 = arg15.Title
    Title_2.TextColor3 = if not arg15._is_unlocked then Color3.fromRGB(0, 0, 0) else Color3.fromRGB(
        255,
        255,
        255
    )
    arg15.Icon.Image = arg15._image
    local Icon_3 = arg15.Icon
    Icon_3.ImageColor3 = arg15._is_unlocked and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(
        0,
        0,
        0
    )
    local Icon_4 = arg15.Icon
    Icon_4.ImageTransparency = if not arg15._is_unlocked then 0.5 else 0
    arg15.Icon.Visible = arg15._is_unlocked
    local Notification_2 = arg15.Notification
    Notification_2.Visible = arg15._num_notifications > 0
    arg15.NotificationTitle.Text = arg15._num_notifications
    WeaponStatusHandler_m:ApplyItemStatusToText(arg15.Title, arg15._status)
    WeaponStatusHandler_m:ApplyItemStatusToImage(arg15.LockedLeft, arg15._status)
    WeaponStatusHandler_m:ApplyItemStatusToImage(arg15.LockedRight, arg15._status)
end

function t._Init(arg16) -- line: 112
    -- upvalues:
    --  [1] ButtonEffect_m (copy)

    arg16.Title:GetPropertyChangedSignal("TextBounds"):Connect(function() -- line: 113
        -- upvalues:
        --  [1] arg16 (copy)

        arg16:_Update()
    end)
    arg16.Notification:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- line: 117
        -- upvalues:
        --  [1] arg16 (copy)

        arg16:_Update()
    end)
    arg16:_Setup()
    arg16:_Update()
    ButtonEffect_m:Add(arg16.Button, nil, { ReleaseRatio = 0.95, HoverRatio = 0.95 })
end

return t
