local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local PlayerDataController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("PlayerDataController")
)
local UILibrary_m = require(Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("UILibrary"))
local t = {}
t.__index = t

function t.new(arg1) -- line: 11
    -- upvalues:
    --  [1] t (copy)

    local t_1 = setmetatable({}, t)
    t_1.MobileInputs = arg1
    t_1.Frame = t_1.MobileInputs.Frame:WaitForChild("JoystickArea")
    t_1._hooked = false
    t_1._touch_gui = nil
    t_1._joystick_frame = nil
    t_1._joystick_original_position = nil
    t_1._joystick_original_anchor_point = nil
    t_1._joystick_left_handed_position = nil
    t_1._joystick_left_handed_anchor_point = nil
    t_1:_Init()

    return t_1
end

function t._Update(arg2) -- line: 40
    -- upvalues:
    --  [1] PlayerDataController_m (copy)
    --  [2] UILibrary_m (copy)

    local v3 = arg2._hooked
    local Frame = arg2.Frame
    v3 = v3 and arg2.MobileInputs.EditorEnabled
    Frame.Visible = v3

    if not arg2.Frame.Visible then
        return
    end

    local v4 = PlayerDataController_m:GetSetting("Left Handed Touch Controls")
    local JoystickFrame = arg2._joystick_frame
    JoystickFrame.Position = v4 and arg2._joystick_left_handed_position or arg2._joystick_original_position
    local JoystickFrame_1 = arg2._joystick_frame
    JoystickFrame_1.AnchorPoint = v4 and arg2._joystick_left_handed_anchor_point or arg2._joystick_original_anchor_point
    local New = Vector2.new
    local clampedValue = math.clamp(
        arg2._joystick_frame.AbsolutePosition.X + (arg2._touch_gui.AbsolutePosition.X - UILibrary_m.MainGui.AbsolutePosition.X),
        0,
        arg2.Frame.AbsoluteSize.X
    )
    local v6 = New(
        clampedValue,
        (math.clamp(
            arg2._joystick_frame.AbsolutePosition.Y + (arg2._touch_gui.AbsolutePosition.Y - UILibrary_m.MainGui.AbsolutePosition.Y),
            0,
            arg2.Frame.AbsoluteSize.Y
        ))
    )
    local vec2 = Vector2.new(
        arg2._joystick_frame.AbsolutePosition.X + arg2._joystick_frame.AbsoluteSize.X - v6.X,
        arg2._joystick_frame.AbsolutePosition.Y + arg2._joystick_frame.AbsoluteSize.Y - v6.Y
    )
    arg2.Frame.Position = UDim2.new(0, v6.X, 0, v6.Y)
    arg2.Frame.Size = UDim2.new(0, vec2.X, 0, vec2.Y)
end

function t._HookTouchGui(arg3) -- line: 68
    -- upvalues:
    --  [1] Utility_m (copy)
    --  [2] Players (copy)

    local v8 = Utility_m:SilentWaitForChild(
        Players.LocalPlayer:WaitForChild("PlayerGui"),
        "TouchGui"
    )
    local DynamicThumbstickFrame = v8:WaitForChild("TouchControlFrame"):WaitForChild(
        "DynamicThumbstickFrame"
    )
    arg3._hooked = true
    arg3._touch_gui = v8
    arg3._joystick_frame = DynamicThumbstickFrame
    arg3._joystick_original_position = arg3._joystick_frame.Position
    arg3._joystick_original_anchor_point = arg3._joystick_frame.AnchorPoint
    arg3._joystick_left_handed_position = UDim2.new(
        1 - arg3._joystick_original_position.X.Scale,
        -arg3._joystick_original_position.X.Offset,
        arg3._joystick_original_position.Y.Scale,
        arg3._joystick_original_position.Y.Offset
    )
    arg3._joystick_left_handed_anchor_point = Vector2.new(
        1 - arg3._joystick_original_anchor_point.X,
        arg3._joystick_original_anchor_point.Y
    )
    arg3._touch_gui:GetPropertyChangedSignal("AbsolutePosition"):Connect(function() -- line: 81
        -- upvalues:
        --  [1] arg3 (copy)

        arg3:_Update()
    end)
    arg3._joystick_frame:GetPropertyChangedSignal("AbsolutePosition"):Connect(function() -- line: 85
        -- upvalues:
        --  [1] arg3 (copy)

        arg3:_Update()
    end)
    arg3._joystick_frame:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- line: 89
        -- upvalues:
        --  [1] arg3 (copy)

        arg3:_Update()
    end)
    arg3:_Update()
    task.spawn(function() -- line: 97
        -- upvalues:
        --  [1] DynamicThumbstickFrame (copy)

        local ThumbstickStart = DynamicThumbstickFrame:WaitForChild("ThumbstickStart")

        local function update() -- line: 100
            -- upvalues:
            --  [1] ThumbstickStart (copy)

            ThumbstickStart.Visible = false
        end

        ThumbstickStart:GetPropertyChangedSignal("Visible"):Connect(update)
        ThumbstickStart.Visible = false
    end)
end

function t._Setup(arg4) -- line: 109
    arg4.Frame.AnchorPoint = Vector2.zero
end

function t._Init(arg5) -- line: 113
    -- upvalues:
    --  [1] UILibrary_m (copy)
    --  [2] PlayerDataController_m (copy)

    arg5.MobileInputs.EditorEnabledChanged:Connect(function() -- line: 114
        -- upvalues:
        --  [1] arg5 (copy)

        arg5:_Update()
    end)
    arg5.MobileInputs.Frame:GetPropertyChangedSignal("AbsolutePosition"):Connect(function() -- line: 118
        -- upvalues:
        --  [1] arg5 (copy)

        arg5:_Update()
    end)
    arg5.MobileInputs.Frame:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- line: 122
        -- upvalues:
        --  [1] arg5 (copy)

        arg5:_Update()
    end)
    UILibrary_m.MainGui:GetPropertyChangedSignal("AbsolutePosition"):Connect(function() -- line: 126
        -- upvalues:
        --  [1] arg5 (copy)

        arg5:_Update()
    end)
    PlayerDataController_m:GetSettingChangedSignal("Left Handed Touch Controls"):Connect(function() -- line: 130
        -- upvalues:
        --  [1] arg5 (copy)

        arg5:_Update()
    end)
    arg5:_Setup()
    arg5:_Update()
    task.defer(arg5._HookTouchGui, arg5)
end

return t
