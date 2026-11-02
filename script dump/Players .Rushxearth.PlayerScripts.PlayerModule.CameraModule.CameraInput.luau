local ContextActionService = game:GetService("ContextActionService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local _ = game:GetService("RunService")
local UserGameSettings = UserSettings():GetService("UserGameSettings")
local VRService = game:GetService("VRService")
local GuiService = game:GetService("GuiService")
local FlagUtil_m = require(
    script.Parent.Parent:WaitForChild("CommonUtils"):WaitForChild("FlagUtil")
)
local UserPSSinkUnknownTouchEvents = FlagUtil_m.getUserFlag("UserPSSinkUnknownTouchEvents")
local UserPSTextboxResetCameraInput = FlagUtil_m.getUserFlag("UserPSTextboxResetCameraInput")
local UserFixVRCameraGamepadReset = FlagUtil_m.getUserFlag("UserFixVRCameraGamepadReset")
local UserPlayerScriptsSupportTVRemoteKeycodes = FlagUtil_m.getUserFlag(
    "UserPlayerScriptsSupportTVRemoteKeycodes"
)
local Value = Enum.ContextActionPriority.Medium.Value
local LocalPlayer = Players.LocalPlayer
local v2 = Vector2.new(1, 0.77) * 0.06981317007977318 * 60
local v3 = Vector2.new(1, 0.77) * 0.008726646259971648
local v4 = Vector2.new(1, 0.77) * 0.12217304763960307
local v5 = Vector2.new(1, 0.66) * 0.017453292519943295
local BindableEvent = Instance.new("BindableEvent")
local BindableEvent_1 = Instance.new("BindableEvent")
local Event = BindableEvent.Event
local Event_1 = BindableEvent_1.Event
UserInputService.InputBegan:Connect(function(input: InputObject, gameProcessedEvent: boolean) -- line: 46
    -- upvalues:
    --  [1] BindableEvent (copy)

    if not gameProcessedEvent and input.UserInputType == Enum.UserInputType.MouseButton2 then
        BindableEvent:Fire()
    end
end)
UserInputService.InputEnded:Connect(function(arg3, _) -- line: 52
    -- upvalues:
    --  [1] BindableEvent_1 (copy)

    if arg3.UserInputType == Enum.UserInputType.MouseButton2 then
        BindableEvent_1:Fire()
    end
end)

local function thumbstickCurve(arg5) -- line: 63
    local v6 = (math.exp((math.abs(arg5) - 0.1) / 0.9 * 2) - 1) / 6.38905609893065

    return math.sign(arg5) * math.clamp(v6, 0, 1)
end

local function adjustTouchPitchSensitivity(u1: Vector2) -- line: 77
    local CurrentCamera = workspace.CurrentCamera

    if not CurrentCamera then
        return u1
    end

    local v8 = CurrentCamera.CFrame:ToEulerAnglesYXZ()

    if u1.Y * v8 >= 0 then
        return u1
    end

    local v9 = Vector2.new(1, (1 - (math.abs(v8) * 2 / 3.141592653589793) ^ 0.75) * 0.75 + 0.25) * u1

    return v9
end

local function isInDynamicThumbstickArea(vec1: Vector3) -- line: 103
    -- upvalues:
    --  [1] LocalPlayer (copy)

    local v10 = LocalPlayer:FindFirstChildOfClass("PlayerGui")
    local v11 = v10

    if v11 then
        v11 = v10:FindFirstChild("TouchGui")
    end

    v10 = v11

    if v10 then
        v10 = v11:FindFirstChild("TouchControlFrame")
    end

    local v12 = v10

    if v12 then
        v12 = v10:FindFirstChild("DynamicThumbstickFrame")
    end

    return if v12 then if v11.Enabled then vec1.X >= v12.AbsolutePosition.X and vec1.Y >= v12.AbsolutePosition.Y and vec1.X <= (v12.AbsolutePosition + v12.AbsoluteSize).X and vec1.Y <= (v12.AbsolutePosition + v12.AbsoluteSize).Y else false else false
end

local t = {}
local t_1 = {}
local v13 = 0

local _ = function() --[[ incPanInputCount ]] -- line: 133
    -- upvalues:
    --  [1] v13 (ref)

    v13 = math.max(0, v13 + 1)
end

local _ = function() --[[ decPanInputCount ]] -- line: 137
    -- upvalues:
    --  [1] v13 (ref)

    v13 = math.max(0, v13 - 1)
end

local _ = function() --[[ resetPanInputCount ]] -- line: 141
    -- upvalues:
    --  [1] v13 (ref)

    v13 = 0
end

local t_2 = { Thumbstick2 = Vector2.new(), ButtonLeft = 0, ButtonRight = 0 }
local t_3 = { Left = 0, Right = 0, I = 0, O = 0 }
local t_4 = { Movement = Vector2.new(), Wheel = 0, Pan = Vector2.new(), Pinch = 0 }
local t_5 = { Move = Vector2.new(), Pinch = 0 }
local BindableEvent_2 = Instance.new("BindableEvent")
t.gamepadZoomPress = BindableEvent_2.Event
local v14

if UserFixVRCameraGamepadReset then
    v14 = Instance.new("BindableEvent")
    t.gamepadReset = v14.Event
else
    v14 = VRService.VREnabled and Instance.new("BindableEvent") or nil

    if VRService.VREnabled then
        t.gamepadReset = v14.Event
    end
end

function t.getRotationActivated() -- line: 182
    -- upvalues:
    --  [1] UserPlayerScriptsSupportTVRemoteKeycodes (copy)
    --  [2] v13 (ref)
    --  [3] t_2 (copy)

    return if not UserPlayerScriptsSupportTVRemoteKeycodes then v13 > 0 or t_2.Thumbstick2.Magnitude > 0 else v13 > 0 or t_2.Thumbstick2.Magnitude > 0 or t_2.ButtonRight - t_2.ButtonLeft ~= 0
end

function t.getRotation(arg6: any, b1: boolean?) -- line: 192
    -- upvalues:
    --  [1] UserGameSettings (copy)
    --  [2] t_3 (copy)
    --  [3] UserPlayerScriptsSupportTVRemoteKeycodes (copy)
    --  [4] t_2 (copy)
    --  [5] t_4 (copy)
    --  [6] adjustTouchPitchSensitivity (copy)
    --  [7] t_5 (copy)
    --  [8] v2 (copy)
    --  [9] v3 (copy)
    --  [10] v4 (copy)
    --  [11] v5 (copy)

    local vec2_1 = Vector2.new(1, UserGameSettings:GetCameraYInvertValue())
    local v17 = Vector2.new(t_3.Right - t_3.Left, 0) * arg6
    local v18 = if UserPlayerScriptsSupportTVRemoteKeycodes then (t_2.Thumbstick2 + Vector2.new(
        t_2.ButtonRight - t_2.ButtonLeft,
        0
    )) * UserGameSettings.GamepadCameraSensitivity * arg6 else t_2.Thumbstick2 * UserGameSettings.GamepadCameraSensitivity * arg6
    local Movement = t_4.Movement
    local Pan = t_4.Pan
    local v19 = adjustTouchPitchSensitivity(t_5.Move)

    if b1 then
        v17 = Vector2.new()
    end

    return (v17 * 2.0943951023931953 + v18 * v2 + Movement * v3 + Pan * v4 + v19 * v5) * vec2_1
end

function t.getZoomDelta() -- line: 223
    -- upvalues:
    --  [1] t_3 (copy)
    --  [2] t_4 (copy)
    --  [3] t_5 (copy)

    return (t_3.O - t_3.I) * 0.1 + (-t_4.Wheel + t_4.Pinch) * 1 + -t_5.Pinch * 0.04
end

local function thumbstick(_, _, arg9) -- line: 231
    -- upvalues:
    --  [1] t_2 (copy)
    --  [2] thumbstickCurve (ref)

    local Position = arg9.Position
    t_2[arg9.KeyCode.Name] = Vector2.new(thumbstickCurve(Position.X), -thumbstickCurve(Position.Y))

    return Enum.ContextActionResult.Pass
end

local function directionalButtons(_, arg11, arg12) -- line: 237
    -- upvalues:
    --  [1] t_2 (copy)
    --  [2] thumbstickCurve (ref)

    if arg11 == Enum.UserInputState.Cancel then
        t_2[arg12.KeyCode.Name] = 0
    else
        t_2[arg12.KeyCode.Name] = thumbstickCurve(arg12.Position.Z)
    end

    return Enum.ContextActionResult.Pass
end

local _ = function(arg13) --[[ mouseMovement ]] -- line: 246
    -- upvalues:
    --  [1] t_4 (copy)

    local Delta = arg13.Delta
    t_4.Movement = Vector2.new(Delta.X, Delta.Y)
end

local _ = function(_, _, arg16) --[[ mouseWheel ]] -- line: 251
    -- upvalues:
    --  [1] t_4 (copy)

    t_4.Wheel = arg16.Position.Z

    return Enum.ContextActionResult.Pass
end

local function keypress(_, arg18, arg19) -- line: 256
    -- upvalues:
    --  [1] t_3 (copy)

    local v24 = t_3
    local Name_2 = arg19.KeyCode.Name
    v24[Name_2] = if arg18 ~= Enum.UserInputState.Begin then 0 else 1
end

local function gamepadZoomPress(_, arg21, _) -- line: 260
    -- upvalues:
    --  [1] BindableEvent_2 (copy)

    if arg21 == Enum.UserInputState.Begin then
        BindableEvent_2:Fire()
    end
end

local function gamepadReset(_, arg24, _) -- line: 266
    -- upvalues:
    --  [1] v14 (ref)

    if arg24 == Enum.UserInputState.Begin then
        v14:Fire()
    end
end

local function resetInputDevices() -- line: 272
    -- upvalues:
    --  [1] t_2 (copy)
    --  [2] t_3 (copy)
    --  [3] t_4 (copy)
    --  [4] t_5 (copy)
    --  [5] v13 (ref)

    for _, val in pairs({ t_2, t_3, t_4, t_5 }) do
        for key_1, val_1 in pairs(val) do
            if type(val_1) == "boolean" then
                val[key_1] = false
            else
                val[key_1] *= 0
            end
        end
    end

    v13 = 0
end

local t_7 = {}
local v26 = nil
local v27 = nil

local function touchBegan(u2: userdata, b2: boolean) -- line: 298
    -- upvalues:
    --  [1] v26 (ref)
    --  [2] isInDynamicThumbstickArea (copy)
    --  [3] v13 (ref)
    --  [4] t_7 (ref)

    assert(u2.UserInputType == Enum.UserInputType.Touch)
    assert(if u2.UserInputState ~= Enum.UserInputState.Begin then false else true)

    if v26 == nil and isInDynamicThumbstickArea(u2.Position) and not b2 then
        v26 = u2

        return
    end

    if not b2 then
        v13 = math.max(0, v13 + 1)
    end

    t_7[u2] = b2
end

local function touchEnded(u3: userdata, _: boolean) -- line: 318
    -- upvalues:
    --  [1] v26 (ref)
    --  [2] t_7 (ref)
    --  [3] v27 (ref)
    --  [4] v13 (ref)

    assert(u3.UserInputType == Enum.UserInputType.Touch)
    assert(if u3.UserInputState ~= Enum.UserInputState.End then false else true)

    if u3 == v26 then
        v26 = nil
    end

    if t_7[u3] == false then
        v27 = nil
        v13 = math.max(0, v13 - 1)
    end

    t_7[u3] = nil
end

local function touchChanged(arg26, arg27) -- line: 337
    -- upvalues:
    --  [1] v26 (ref)
    --  [2] t_7 (ref)
    --  [3] UserPSSinkUnknownTouchEvents (copy)
    --  [4] t_5 (copy)
    --  [5] v27 (ref)

    assert(arg26.UserInputType == Enum.UserInputType.Touch)
    assert(if arg26.UserInputState ~= Enum.UserInputState.Change then false else true)

    if arg26 == v26 then
        return
    end

    if t_7[arg26] == nil then
        if UserPSSinkUnknownTouchEvents then
            t_7[arg26] = true
        else
            t_7[arg26] = arg27
        end
    end

    local t_8 = {}

    for key_2, val_2 in pairs(t_7) do
        if not val_2 then
            table.insert(t_8, key_2)
        end
    end

    if #t_8 == 1 and t_7[arg26] == false then
        local Delta_1 = arg26.Delta
        local v31 = t_5
        v31.Move = v31.Move + Vector2.new(Delta_1.X, Delta_1.Y)
    end

    if #t_8 == 2 then
        local Magnitude = (t_8[1].Position - t_8[2].Position).Magnitude

        if v27 then
            local v32 = t_5
            v32.Pinch += Magnitude - v27
        end

        v27 = Magnitude

        return
    end

    v27 = nil
end

local function resetTouchState() -- line: 385
    -- upvalues:
    --  [1] t_7 (ref)
    --  [2] v26 (ref)
    --  [3] v27 (ref)
    --  [4] v13 (ref)

    t_7 = {}
    v26 = nil
    v27 = nil
    v13 = 0
end

local function pointerAction(arg28, arg29, arg30, arg31) -- line: 393
    -- upvalues:
    --  [1] t_4 (copy)

    if not arg31 then
        t_4.Wheel = arg28
        t_4.Pan = arg29
        t_4.Pinch = -arg30
    end
end

local function inputBegan(arg32, arg33) -- line: 401
    -- upvalues:
    --  [1] touchBegan (ref)
    --  [2] v13 (ref)

    if arg32.UserInputType == Enum.UserInputType.Touch then
        touchBegan(arg32, arg33)

        return
    end

    if arg32.UserInputType == Enum.UserInputType.MouseButton2 and not arg33 then
        v13 = math.max(0, v13 + 1)
    end
end

local function inputChanged(arg34, arg35) -- line: 410
    -- upvalues:
    --  [1] touchChanged (ref)
    --  [2] t_4 (copy)

    if arg34.UserInputType == Enum.UserInputType.Touch then
        touchChanged(arg34, arg35)

        return
    end

    if arg34.UserInputType == Enum.UserInputType.MouseMovement then
        local Delta_2 = arg34.Delta
        t_4.Movement = Vector2.new(Delta_2.X, Delta_2.Y)
    end
end

local function inputEnded(arg36, arg37) -- line: 419
    -- upvalues:
    --  [1] touchEnded (ref)
    --  [2] v13 (ref)

    if arg36.UserInputType == Enum.UserInputType.Touch then
        touchEnded(arg36, arg37)

        return
    end

    if arg36.UserInputType == Enum.UserInputType.MouseButton2 then
        v13 = math.max(0, v13 - 1)
    end
end

local v34 = false

function t.setInputEnabled(arg38) -- line: 430
    -- upvalues:
    --  [1] v34 (ref)
    --  [2] resetInputDevices (copy)
    --  [3] resetTouchState (ref)
    --  [4] ContextActionService (copy)
    --  [5] thumbstick (copy)
    --  [6] Value (copy)
    --  [7] UserPlayerScriptsSupportTVRemoteKeycodes (copy)
    --  [8] directionalButtons (copy)
    --  [9] keypress (copy)
    --  [10] VRService (copy)
    --  [11] gamepadReset (copy)
    --  [12] gamepadZoomPress (copy)
    --  [13] t_1 (ref)
    --  [14] UserInputService (copy)
    --  [15] inputBegan (copy)
    --  [16] inputChanged (copy)
    --  [17] inputEnded (copy)
    --  [18] pointerAction (copy)
    --  [19] GuiService (copy)

    if v34 == arg38 then
        return
    end

    v34 = arg38
    resetInputDevices()
    resetTouchState()

    if v34 then
        ContextActionService:BindActionAtPriority(
            "RbxCameraThumbstick",
            thumbstick,
            false,
            Value,
            Enum.KeyCode.Thumbstick2
        )

        if UserPlayerScriptsSupportTVRemoteKeycodes then
            ContextActionService:BindActionAtPriority(
                "RbxCameraDirectionalButtons",
                directionalButtons,
                false,
                Value,
                Enum.KeyCode.ButtonLeft,
                Enum.KeyCode.ButtonRight
            )
        end

        ContextActionService:BindActionAtPriority(
            "RbxCameraKeypress",
            keypress,
            false,
            Value,
            Enum.KeyCode.Left,
            Enum.KeyCode.Right,
            Enum.KeyCode.I,
            Enum.KeyCode.O
        )

        if VRService.VREnabled then
            ContextActionService:BindAction(
                "RbxCameraGamepadReset",
                gamepadReset,
                false,
                Enum.KeyCode.ButtonL3
            )
        end

        ContextActionService:BindAction(
            "RbxCameraGamepadZoom",
            gamepadZoomPress,
            false,
            Enum.KeyCode.ButtonR3
        )
        table.insert(t_1, UserInputService.InputBegan:Connect(inputBegan))
        table.insert(t_1, UserInputService.InputChanged:Connect(inputChanged))
        table.insert(t_1, UserInputService.InputEnded:Connect(inputEnded))
        table.insert(t_1, UserInputService.PointerAction:Connect(pointerAction))
        table.insert(t_1, GuiService.MenuOpened:connect(resetTouchState))

        return
    end

    ContextActionService:UnbindAction("RbxCameraThumbstick")

    if UserPlayerScriptsSupportTVRemoteKeycodes then
        ContextActionService:UnbindAction("RbxCameraDirectionalButtons")
    end

    ContextActionService:UnbindAction("RbxCameraMouseMove")
    ContextActionService:UnbindAction("RbxCameraMouseWheel")
    ContextActionService:UnbindAction("RbxCameraKeypress")
    ContextActionService:UnbindAction("RbxCameraGamepadZoom")

    if VRService.VREnabled then
        ContextActionService:UnbindAction("RbxCameraGamepadReset")
    end

    for _, val_3 in pairs(t_1) do
        val_3:Disconnect()
    end

    t_1 = {}
end

function t.getInputEnabled() -- line: 513
    -- upvalues:
    --  [1] v34 (ref)

    return v34
end

function t.resetInputForFrameEnd() -- line: 517
    -- upvalues:
    --  [1] t_4 (copy)
    --  [2] t_5 (copy)

    t_4.Movement = Vector2.new()
    t_5.Move = Vector2.new()
    t_5.Pinch = 0
    t_4.Wheel = 0
    t_4.Pan = Vector2.new()
    t_4.Pinch = 0
end

UserInputService.WindowFocused:Connect(resetInputDevices)
UserInputService.WindowFocusReleased:Connect(resetInputDevices)

if UserPSTextboxResetCameraInput then
    UserInputService.TextBoxFocusReleased:Connect(resetInputDevices)
end

local v43 = false
local v44 = false
local v45 = 0

function t.getHoldPan() -- line: 541
    -- upvalues:
    --  [1] v43 (ref)

    return v43
end

function t.getTogglePan() -- line: 545
    -- upvalues:
    --  [1] v44 (ref)

    return v44
end

function t.getPanning() -- line: 549
    -- upvalues:
    --  [1] v44 (ref)
    --  [2] v43 (ref)

    return v44 or v43
end

function t.setTogglePan(b4: boolean) -- line: 553
    -- upvalues:
    --  [1] v44 (ref)

    v44 = b4
end

local v47 = false
local v48 = nil
local v49 = nil

function t.enableCameraToggleInput() -- line: 561
    -- upvalues:
    --  [1] v47 (ref)
    --  [2] v43 (ref)
    --  [3] v44 (ref)
    --  [4] v48 (ref)
    --  [5] v49 (ref)
    --  [6] Event (ref)
    --  [7] v45 (ref)
    --  [8] Event_1 (ref)
    --  [9] UserInputService (copy)

    if v47 then
        return
    end

    v47 = true
    v43 = false
    v44 = false

    if v48 then
        v48:Disconnect()
    end

    if v49 then
        v49:Disconnect()
    end

    v48 = Event:Connect(function() -- line: 578
        -- upvalues:
        --  [1] v43 (ref)
        --  [2] v45 (ref)

        v43 = true
        v45 = tick()
    end)
    v49 = Event_1:Connect(function() -- line: 583
        -- upvalues:
        --  [1] v43 (ref)
        --  [2] v45 (ref)
        --  [3] v44 (ref)
        --  [4] UserInputService (ref)

        v43 = false

        if tick() - v45 < 0.3 and (v44 or UserInputService:GetMouseDelta().Magnitude < 2) then
            v44 = not v44
        end
    end)
end

function t.disableCameraToggleInput() -- line: 591
    -- upvalues:
    --  [1] v47 (ref)
    --  [2] v48 (ref)
    --  [3] v49 (ref)

    if not v47 then
        return
    end

    v47 = false

    if v48 then
        v48:Disconnect()
        v48 = nil
    end

    if v49 then
        v49:Disconnect()
        v49 = nil
    end
end

return t
