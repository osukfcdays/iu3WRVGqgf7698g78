local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local Signal_m = require(ReplicatedStorage.Modules.Signal)
local PlayerDataController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.PlayerDataController
)
local ControlsController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.ControlsController
)
local UILibrary_m = require(Players.LocalPlayer.PlayerScripts.Modules.UILibrary)
local t = {}
t.__index = t

function t.new(arg1) -- line: 15
    -- upvalues:
    --  [1] t (copy)
    --  [2] Signal_m (copy)

    local t_1 = setmetatable({}, t)
    t_1.MouseDownChanged = Signal_m.new()
    t_1.Equipment = arg1
    t_1._connections = {}
    t_1._frame = Instance.new("ImageButton")
    t_1._is_mouse_down = nil
    t_1._last_position = nil
    t_1._velocity = Vector2.zero
    t_1._rad = Vector2.zero
    t_1._last_state = nil
    t_1._start_resetting = nil
    t_1:_Init()

    return t_1
end

function t.IsMouseDown(arg2) -- line: 40
    return arg2._is_mouse_down
end

function t.GetCFrame(arg3) -- line: 44
    return CFrame.Angles(0, arg3._rad.X, 0) * CFrame.Angles(arg3._rad.Y, 0, 0)
end

function t.Update(arg4, _) -- line: 48
    if arg4._velocity.Magnitude <= 0.001 and not arg4._is_mouse_down then
        if arg4._start_resetting and tick() <= arg4._start_resetting then
            return
        end

        if arg4._rad.X < -3.141592653589793 then
            arg4._rad = Vector2.new(arg4._rad.X + 6.283185307179586, arg4._rad.Y)
        elseif arg4._rad.X > 3.141592653589793 then
            arg4._rad = Vector2.new(arg4._rad.X - 6.283185307179586, arg4._rad.Y)
        end

        if arg4._rad.Y < -3.141592653589793 then
            arg4._rad = Vector2.new(arg4._rad.X, arg4._rad.Y + 6.283185307179586)
        elseif arg4._rad.Y > 3.141592653589793 then
            arg4._rad = Vector2.new(arg4._rad.X, arg4._rad.Y - 6.283185307179586)
        end

        local v1 = if not arg4._start_resetting then 1 else math.clamp(
            ((tick() - arg4._start_resetting) / 4) ^ 2,
            0,
            1
        )
        arg4._rad *= 1 - v1 * 0.05

        return
    end

    arg4._start_resetting = tick() + 0
    arg4._velocity *= 0.975
    arg4:_Increment(arg4._velocity)
end

function t.OnStateChanged(arg6) -- line: 77
    arg6:_CheckResetSpin()
end

function t.OnOpen(arg7) -- line: 81
    -- upvalues:
    --  [1] UILibrary_m (copy)

    local Frame = arg7._frame
    Frame.Parent = arg7.Equipment.IsOpen and UILibrary_m.MainGui or nil
    arg7:_VerifyControls()
end

function t._CheckResetSpin(arg8) -- line: 90
    local v3 = arg8.Equipment:GetStateID()

    if v3 == arg8._last_state then
        return
    end

    arg8._last_state = v3
    arg8._velocity = Vector2.zero
    arg8._rad = Vector2.zero
end

function t._IsDisabled(arg9) -- line: 102
    -- upvalues:
    --  [1] PlayerDataController_m (copy)

    local v4 = arg9.Equipment:GetSelectedWeapon()
    local v5 = PlayerDataController_m:GetWeaponData(v4)
    local v6 = v4

    if v6 then
        v6 = not v5
    end

    return v6
end

function t._GetMouseLocation(_) -- line: 109
    -- upvalues:
    --  [1] UILibrary_m (copy)

    return UILibrary_m:GetMouseLocation()
end

function t._Increment(arg11, arg12) -- line: 113
    arg11._rad += arg12
    arg11._rad = Vector2.new(arg11._rad.X % 6.283185307179586, arg11._rad.Y % 6.283185307179586)
end

function t._VerifyControls(arg13) -- line: 118
    -- upvalues:
    --  [1] ControlsController_m (copy)
    --  [2] UserInputService (copy)

    for _, val in pairs(arg13._connections) do
        val:Disconnect()
    end

    arg13._connections = {}

    if not arg13.Equipment.IsOpen then
        return
    end

    arg13._last_position = nil
    arg13._velocity = Vector2.zero
    arg13._is_mouse_down = nil
    arg13.MouseDownChanged:Fire()

    local _ = function(arg14) --[[ sanity_check ]] -- line: 134
        -- upvalues:
        --  [1] ControlsController_m (ref)
        --  [2] arg13 (copy)

        return if ControlsController_m.CurrentControls ~= "Touch" then not arg13._is_mouse_down else arg14 ~= arg13._is_mouse_down
    end

    table.insert(arg13._connections, arg13._frame.InputBegan:Connect(function(input: InputObject) -- line: 142
        -- upvalues:
        --  [1] arg13 (copy)

        if arg13:_IsDisabled() or arg13._is_mouse_down then
            return
        end

        if
            input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.MouseButton2
            or input.UserInputType == Enum.UserInputType.Touch
        then
            arg13._last_position = nil
            arg13._velocity = Vector2.zero
            arg13._is_mouse_down = input
            arg13.MouseDownChanged:Fire()
        end
    end))
    table.insert(arg13._connections, UserInputService.InputEnded:Connect(function(
        input_1: InputObject
    ) -- line: 155
        -- upvalues:
        --  [1] ControlsController_m (ref)
        --  [2] arg13 (copy)

        if if ControlsController_m.CurrentControls ~= "Touch" then not arg13._is_mouse_down else input_1 ~= arg13._is_mouse_down then
            return
        end

        if
            input_1.UserInputType == Enum.UserInputType.MouseButton1
            or input_1.UserInputType == Enum.UserInputType.MouseButton2
            or input_1.UserInputType == Enum.UserInputType.Touch
        then
            arg13._is_mouse_down = nil
            arg13.MouseDownChanged:Fire()

            if arg13._last_position then
                arg13._velocity = (arg13:_GetMouseLocation() - arg13._last_position) / 400
            end
        end
    end))
    table.insert(arg13._connections, UserInputService.InputChanged:Connect(function(
        input_2: InputObject
    ) -- line: 170
        -- upvalues:
        --  [1] ControlsController_m (ref)
        --  [2] arg13 (copy)

        local v10 = if ControlsController_m.CurrentControls ~= "Touch" then not arg13._is_mouse_down else input_2 ~= arg13._is_mouse_down

        if v10 then
            return
        end

        v10 = arg13:_GetMouseLocation()

        if arg13._last_position then
            local v11 = arg13
            v11:_Increment(
                (v10 - arg13._last_position) / 800 * (if ControlsController_m.CurrentControls ~= "Touch" then 1 else 3)
            )
        end

        arg13._last_position = v10
    end))
end

function t._Setup(arg18) -- line: 185
    arg18._frame.Name = "EquipmentSpinControls"
    arg18._frame.AnchorPoint = Vector2.new(0.5, 0.5)
    arg18._frame.Position = UDim2.new(0.5, 0, 0.5, 0)
    arg18._frame.Size = UDim2.new(1, 0, 1, 0)
    arg18._frame.Image = ""
    arg18._frame.BackgroundTransparency = 1
    arg18._frame.ZIndex = -1000
    arg18._frame.Visible = true
end

function t._Init(arg19) -- line: 196
    arg19:_Setup()
end

return t
