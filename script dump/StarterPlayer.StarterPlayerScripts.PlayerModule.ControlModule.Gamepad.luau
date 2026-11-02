local UserInputService = game:GetService("UserInputService")
local ContextActionService = game:GetService("ContextActionService")
local UserPlayerScriptsSupportTVRemoteKeycodes = require(
    script.Parent.Parent:WaitForChild("CommonUtils"):WaitForChild("FlagUtil")
).getUserFlag("UserPlayerScriptsSupportTVRemoteKeycodes")
local UserInputType_None = Enum.UserInputType.None
local BaseCharacterController_m = require(script.Parent:WaitForChild("BaseCharacterController"))
local t = setmetatable({}, BaseCharacterController_m)
t.__index = t

function t.new(arg1) -- line: 26
    -- upvalues:
    --  [1] BaseCharacterController_m (copy)
    --  [2] t (copy)
    --  [3] UserInputType_None (copy)

    local t_1 = setmetatable(BaseCharacterController_m.new(), t)
    t_1.CONTROL_ACTION_PRIORITY = arg1
    t_1.forwardValue = 0
    t_1.backwardValue = 0
    t_1.leftValue = 0
    t_1.rightValue = 0
    t_1.thumbstickVector = Vector3.new(0, 0, 0)
    t_1.activeGamepad = UserInputType_None
    t_1.gamepadConnectedConn = nil
    t_1.gamepadDisconnectedConn = nil

    return t_1
end

function t.Enable(t1: table, b1: boolean) -- line: 43
    -- upvalues:
    --  [1] UserInputType_None (copy)

    if b1 == t1.enabled then
        return true
    end

    t1.forwardValue = 0
    t1.backwardValue = 0
    t1.leftValue = 0
    t1.rightValue = 0
    t1.thumbstickVector = Vector3.new(0, 0, 0)
    t1.moveVector = Vector3.new(0, 0, 0)
    t1.isJumping = false

    if b1 then
        t1.activeGamepad = t1:GetHighestPriorityGamepad()

        if t1.activeGamepad ~= UserInputType_None then
            t1:BindContextActions()
            t1:ConnectGamepadConnectionListeners()
        else
            return false
        end
    else
        t1:UnbindContextActions()
        t1:DisconnectGamepadConnectionListeners()
        t1.activeGamepad = UserInputType_None
    end

    t1.enabled = b1

    return true
end

function t.GetHighestPriorityGamepad(_) -- line: 80
    -- upvalues:
    --  [1] UserInputService (copy)
    --  [2] UserInputType_None (copy)

    local gamepads = UserInputService:GetConnectedGamepads()
    local v3 = UserInputType_None

    for _, val in pairs(gamepads) do
        if val.Value < v3.Value then
            v3 = val
        end
    end

    return v3
end

function t.UpdateMovement(arg3) -- line: 91
    arg3.moveVector = arg3.thumbstickVector + Vector3.new(
        0,
        0,
        arg3.forwardValue + arg3.backwardValue
    )
end

function t.BindContextActions(arg4) -- line: 95
    -- upvalues:
    --  [1] UserInputType_None (copy)
    --  [2] UserPlayerScriptsSupportTVRemoteKeycodes (copy)
    --  [3] ContextActionService (copy)

    if arg4.activeGamepad == UserInputType_None then
        return false
    end

    local function v6(_, arg6, _) -- line: 102
        -- upvalues:
        --  [1] arg4 (copy)

        local v4 = arg4
        v4.isJumping = arg6 == Enum.UserInputState.Begin

        return Enum.ContextActionResult.Sink
    end

    ContextActionService:BindActivate(arg4.activeGamepad, Enum.KeyCode.ButtonR2)

    if UserPlayerScriptsSupportTVRemoteKeycodes then
        ContextActionService:BindActionAtPriority(
            "jumpAction",
            v6,
            false,
            arg4.CONTROL_ACTION_PRIORITY,
            Enum.KeyCode.ButtonA,
            Enum.KeyCode.ButtonCenter
        )
        ContextActionService:BindActionAtPriority(
            "moveDirectionalButton",
            function(_, arg12, arg13) -- line: 141
                -- upvalues:
                --  [1] arg4 (copy)

                if arg12 == Enum.UserInputState.Cancel then
                    arg4.forwardValue = 0
                    arg4.backwardValue = 0
                    arg4:UpdateMovement()

                    return Enum.ContextActionResult.Sink
                end

                local v9 = 0
                v9 = if not (arg13.Position.magnitude > 0.2) then v9 else arg13.Position.Z

                if arg13.KeyCode == Enum.KeyCode.ButtonUp then
                    arg4.forwardValue = -v9
                elseif arg13.KeyCode == Enum.KeyCode.ButtonDown then
                    arg4.backwardValue = v9
                end

                arg4:UpdateMovement()

                return Enum.ContextActionResult.Sink
            end,
            false,
            arg4.CONTROL_ACTION_PRIORITY,
            Enum.KeyCode.ButtonUp,
            Enum.KeyCode.ButtonDown
        )
    else
        ContextActionService:BindActionAtPriority(
            "jumpAction",
            v6,
            false,
            arg4.CONTROL_ACTION_PRIORITY,
            Enum.KeyCode.ButtonA
        )
    end

    ContextActionService:BindActionAtPriority(
        "moveThumbstick",
        function(_, arg9, arg10) -- line: 107
            -- upvalues:
            --  [1] UserPlayerScriptsSupportTVRemoteKeycodes (ref)
            --  [2] arg4 (copy)

            if arg9 == Enum.UserInputState.Cancel then
                if UserPlayerScriptsSupportTVRemoteKeycodes then
                    arg4.thumbstickVector = Vector3.new(0, 0, 0)
                    arg4:UpdateMovement()
                else
                    arg4.moveVector = Vector3.new(0, 0, 0)
                end

                return Enum.ContextActionResult.Sink
            end

            if arg4.activeGamepad ~= arg10.UserInputType then
                return Enum.ContextActionResult.Pass
            end

            if arg10.KeyCode ~= Enum.KeyCode.Thumbstick1 then
                return
            end

            if UserPlayerScriptsSupportTVRemoteKeycodes then
                if arg10.Position.magnitude > 0.2 then
                    arg4.thumbstickVector = Vector3.new(arg10.Position.X, 0, -arg10.Position.Y)
                else
                    arg4.thumbstickVector = Vector3.new(0, 0, 0)
                end

                arg4:UpdateMovement()
            elseif arg10.Position.magnitude > 0.2 then
                arg4.moveVector = Vector3.new(arg10.Position.X, 0, -arg10.Position.Y)
            else
                arg4.moveVector = Vector3.new(0, 0, 0)
            end

            return Enum.ContextActionResult.Sink
        end,
        false,
        arg4.CONTROL_ACTION_PRIORITY,
        Enum.KeyCode.Thumbstick1
    )

    return true
end

function t.UnbindContextActions(arg14) -- line: 180
    -- upvalues:
    --  [1] UserInputType_None (copy)
    --  [2] ContextActionService (copy)
    --  [3] UserPlayerScriptsSupportTVRemoteKeycodes (copy)

    if arg14.activeGamepad ~= UserInputType_None then
        ContextActionService:UnbindActivate(arg14.activeGamepad, Enum.KeyCode.ButtonR2)
    end

    if UserPlayerScriptsSupportTVRemoteKeycodes then
        ContextActionService:UnbindAction("moveDirectionalButton")
    end

    ContextActionService:UnbindAction("moveThumbstick")
    ContextActionService:UnbindAction("jumpAction")
end

function t.OnNewGamepadConnected(arg15) -- line: 191
    -- upvalues:
    --  [1] UserInputType_None (copy)

    local v10 = arg15:GetHighestPriorityGamepad()

    if v10 == arg15.activeGamepad then
        return
    end

    if v10 == UserInputType_None then
        warn("Gamepad:OnNewGamepadConnected found no connected gamepads")
        arg15:UnbindContextActions()

        return
    end

    if arg15.activeGamepad ~= UserInputType_None then
        arg15:UnbindContextActions()
    end

    arg15.activeGamepad = v10
    arg15:BindContextActions()
end

function t.OnCurrentGamepadDisconnected(arg16) -- line: 218
    -- upvalues:
    --  [1] UserInputType_None (copy)
    --  [2] ContextActionService (copy)

    if arg16.activeGamepad ~= UserInputType_None then
        ContextActionService:UnbindActivate(arg16.activeGamepad, Enum.KeyCode.ButtonR2)
    end

    local v11 = arg16:GetHighestPriorityGamepad()

    if arg16.activeGamepad ~= UserInputType_None and v11 == arg16.activeGamepad then
        warn(
            "Gamepad:OnCurrentGamepadDisconnected found the supposedly disconnected gamepad in connectedGamepads."
        )
        arg16:UnbindContextActions()
        arg16.activeGamepad = UserInputType_None

        return
    end

    if v11 == UserInputType_None then
        arg16:UnbindContextActions()
        arg16.activeGamepad = UserInputType_None

        return
    end

    arg16.activeGamepad = v11
    ContextActionService:BindActivate(arg16.activeGamepad, Enum.KeyCode.ButtonR2)
end

function t.ConnectGamepadConnectionListeners(arg17) -- line: 243
    -- upvalues:
    --  [1] UserInputService (copy)

    arg17.gamepadConnectedConn = UserInputService.GamepadConnected:Connect(function(_) -- line: 244
        -- upvalues:
        --  [1] arg17 (copy)

        arg17:OnNewGamepadConnected()
    end)
    arg17.gamepadDisconnectedConn = UserInputService.GamepadDisconnected:Connect(function(
        gamepadNum: UserInputType
    ) -- line: 248
        -- upvalues:
        --  [1] arg17 (copy)

        if arg17.activeGamepad == gamepadNum then
            arg17:OnCurrentGamepadDisconnected()
        end
    end)
end

function t.DisconnectGamepadConnectionListeners(arg20) -- line: 255
    if arg20.gamepadConnectedConn then
        arg20.gamepadConnectedConn:Disconnect()
        arg20.gamepadConnectedConn = nil
    end

    if arg20.gamepadDisconnectedConn then
        arg20.gamepadDisconnectedConn:Disconnect()
        arg20.gamepadDisconnectedConn = nil
    end
end

return t
