local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local GamepadService = game:GetService("GamepadService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CONSTANTS_m = require(ReplicatedStorage.Modules.CONSTANTS)
local Signal_m = require(ReplicatedStorage.Modules.Signal)
local PlayerDataController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.PlayerDataController
)
local ControlsController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.ControlsController
)
local UILibrary_m = require(Players.LocalPlayer.PlayerScripts.Modules.UILibrary)
local EmoteWheelSlot_m = require(script:WaitForChild("EmoteWheelSlot"))
local EmoteWheel = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("EmoteWheel")
local v2 = 6.283185307179586 / CONSTANTS_m.MAX_EQUIPPABLE_EMOTES
local v3 = v2 * -0.5
local t = {}
t.__index = t

function t.new() -- line: 22
    -- upvalues:
    --  [1] t (copy)
    --  [2] Signal_m (copy)
    --  [3] EmoteWheel (copy)

    local t_1 = setmetatable({}, t)
    t_1.EmoteKeyPicked = Signal_m.new()
    t_1.EmoteWheelSlotHighlighted = Signal_m.new()
    t_1.Frame = EmoteWheel:Clone()
    t_1._is_enabled = false
    t_1._connections = {}
    t_1._input_connections = {}
    t_1._emote_wheel_slots = {}
    t_1._finish_picking_bindable = nil
    t_1._last_highlighted_wheel_slot = nil
    t_1._generate_hash = 0
    t_1:_Init()

    return t_1
end

function t.GetLastHighlightedSlot(arg1) -- line: 47
    return arg1._last_highlighted_wheel_slot
end

function t.GetEmoteWheelSlot(arg2, arg3) -- line: 51
    return arg2._emote_wheel_slots[arg3]
end

function t.GetEmoteSlotFromScreenPosition(arg4, arg5, arg6) -- line: 55
    -- upvalues:
    --  [1] UILibrary_m (copy)
    --  [2] v2 (copy)
    --  [3] v3 (copy)

    local v4 = arg5 or UILibrary_m:GetMouseLocation()
    local v5 = arg4.Frame.AbsolutePosition + arg4.Frame.AbsoluteSize / 2

    if (v4 - v5).Magnitude <= arg4.Frame.AbsoluteSize.X * 0.1 then
        return
    end

    local v6 = math.atan2(v4.Y - v5.Y, v4.X - v5.X) + 1.5707963267948966
    local t_2 = { v6 - 6.283185307179586, v6, v6 + 6.283185307179586 }

    for key, val in pairs(arg4._emote_wheel_slots) do
        if val.EquippedData or arg6 then
            for _, val_1 in pairs(t_2) do
                local num = tonumber(key)

                if v2 * (num - 1) + v3 <= val_1 and val_1 < v2 * num + v3 then
                    return val, key
                end
            end
        end
    end
end

function t.SetEnabled(arg7, arg8) -- line: 83
    -- upvalues:
    --  [1] PlayerDataController_m (copy)

    arg7:_Clear()
    arg7._is_enabled = arg8

    if not arg7._is_enabled then
        return
    end

    table.insert(arg7._connections, PlayerDataController_m:GetDataChangedSignal("EquippedEmotes"):Connect(
        function() -- line: 92
            -- upvalues:
            --  [1] arg7 (copy)

            arg7:_Generate()
        end
    ))
    task.spawn(arg7._Generate, arg7, true)
end

function t.HighlightSlot(arg9, arg10) -- line: 99
    arg9._last_highlighted_wheel_slot = arg10

    for _, val_2 in pairs(arg9._emote_wheel_slots) do
        val_2:SetHighlighted(val_2 == arg9._last_highlighted_wheel_slot)
    end

    arg9.EmoteWheelSlotHighlighted:Fire()
end

function t.StopInputs(arg11) -- line: 109
    for _, val_3 in pairs(arg11._input_connections) do
        val_3:Disconnect()
    end

    arg11._input_connections = {}

    if arg11._finish_picking_bindable then
        arg11._finish_picking_bindable:Destroy()
        arg11._finish_picking_bindable = nil
    end

    arg11:HighlightSlot(nil)
end

function t.FinishInputs(arg12) -- line: 124
    if arg12._finish_picking_bindable then
        arg12._finish_picking_bindable:Fire()
    end
end

function t.StartInputs(arg13, arg14) -- line: 130
    -- upvalues:
    --  [1] UserInputService (copy)
    --  [2] ControlsController_m (copy)
    --  [3] RunService (copy)
    --  [4] GamepadService (copy)
    --  [5] UILibrary_m (copy)

    arg13:StopInputs()
    arg13._finish_picking_bindable = Instance.new("BindableEvent")
    local v8 = nil
    local v9 = false

    local function finish() -- line: 138
        -- upvalues:
        --  [1] arg13 (copy)
        --  [2] v8 (ref)
        --  [3] arg14 (copy)

        local v10, v11 = arg13:GetEmoteSlotFromScreenPosition(v8, arg14)
        local v12 = v10

        if v12 then
            v12 = if arg14 then v11 else v10.EquippedData and v11
        end

        arg13.EmoteKeyPicked:Fire(v12)
    end

    arg13._finish_picking_bindable.Event:Connect(finish)

    local _ = function(arg15, arg16) --[[ set_last_mouse_location ]] -- line: 147
        -- upvalues:
        --  [1] arg13 (copy)
        --  [2] arg14 (copy)
        --  [3] v8 (ref)

        local v13, _ = arg13:GetEmoteSlotFromScreenPosition(arg15, arg14)

        if not v13 and arg16 then
            return
        end

        v8 = arg15
        arg13:HighlightSlot(v13)
    end

    table.insert(arg13._input_connections, UserInputService.InputBegan:Connect(function(
        input: InputObject
    ) -- line: 158
        -- upvalues:
        --  [1] v9 (ref)

        if
            input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch
            or input.KeyCode == Enum.KeyCode.ButtonA
        then
            v9 = true
        end
    end))
    table.insert(arg13._input_connections, UserInputService.InputEnded:Connect(function(
        input_1: InputObject
    ) -- line: 164
        -- upvalues:
        --  [1] v9 (ref)
        --  [2] arg13 (copy)
        --  [3] v8 (ref)
        --  [4] arg14 (copy)

        if
            (input_1.UserInputType == Enum.UserInputType.MouseButton1 or input_1.UserInputType == Enum.UserInputType.Touch or input_1.KeyCode == Enum.KeyCode.ButtonA)
            and v9
        then
            local v15, v16 = arg13:GetEmoteSlotFromScreenPosition(v8, arg14)
            local v17 = v15

            if v17 then
                v17 = if arg14 then v16 else v15.EquippedData and v16
            end

            arg13.EmoteKeyPicked:Fire(v17)
        end
    end))
    table.insert(arg13._input_connections, UserInputService.InputChanged:Connect(function(
        input_2: InputObject
    ) -- line: 172
        -- upvalues:
        --  [1] ControlsController_m (ref)
        --  [2] arg13 (copy)
        --  [3] arg14 (copy)
        --  [4] v8 (ref)

        if ControlsController_m.CurrentControls ~= "Gamepad" then
            return
        end

        if input_2.KeyCode == Enum.KeyCode.Thumbstick1 or input_2.KeyCode == Enum.KeyCode.Thumbstick2 then
            local v18 = arg13:_ThumbstickPositionToScreenPosition(input_2.Position)
            local v19, _ = arg13:GetEmoteSlotFromScreenPosition(v18, arg14)

            if not v19 then
                return
            end

            v8 = v18
            arg13:HighlightSlot(v19)
        end
    end))
    table.insert(arg13._input_connections, RunService.RenderStepped:Connect(function() -- line: 182
        -- upvalues:
        --  [1] ControlsController_m (ref)
        --  [2] GamepadService (ref)
        --  [3] UILibrary_m (ref)
        --  [4] arg13 (copy)
        --  [5] arg14 (copy)
        --  [6] v8 (ref)

        if ControlsController_m.CurrentControls == "Gamepad" then
            if GamepadService.GamepadCursorEnabled then
                GamepadService:DisableGamepadCursor()
            end

            return
        end

        local mouseLocation, v21 = UILibrary_m:GetMouseLocation()
        local v22, _ = arg13:GetEmoteSlotFromScreenPosition(mouseLocation, arg14)

        if not v22 and v21 then
            return
        end

        v8 = mouseLocation
        arg13:HighlightSlot(v22)
    end))
end

function t.Destroy(arg20) -- line: 195
    arg20:_Clear()
    arg20:SetEnabled(false)
    arg20:StopInputs()
    arg20.Frame:Destroy()
    arg20.EmoteKeyPicked:Destroy()
    arg20.EmoteWheelSlotHighlighted:Destroy()
end

function t._NormalizeAngle(_, arg22) -- line: 209
    return if not (arg22 < 0) then if not (arg22 > 6.283185307179586) then arg22 else arg22 - 6.283185307179586 else arg22 + 6.283185307179586
end

function t._ThumbstickPositionToScreenPosition(arg23, arg24) -- line: 219
    local v24 = arg23.Frame.AbsolutePosition + arg23.Frame.AbsoluteSize / 2

    if arg24.Magnitude <= 0.5 then
        return v24
    end

    return v24 + Vector2.new(arg24.X, -arg24.Y) * 1000
end

function t._ClearSlots(arg25) -- line: 229
    for _, val_4 in pairs(arg25._emote_wheel_slots) do
        val_4:Destroy()
    end

    arg25._emote_wheel_slots = {}
end

function t._Clear(arg26) -- line: 237
    for _, val_5 in pairs(arg26._connections) do
        val_5:Disconnect()
    end

    arg26._connections = {}
    arg26:_ClearSlots()
end

function t._Generate(arg27, arg28) -- line: 246
    -- upvalues:
    --  [1] PlayerDataController_m (copy)
    --  [2] CONSTANTS_m (copy)
    --  [3] EmoteWheelSlot_m (copy)
    --  [4] v3 (copy)

    arg27._generate_hash += 1
    local GenerateHash = arg27._generate_hash
    local t_3 = {}

    for key_6, val_6 in pairs(arg27._emote_wheel_slots) do
        local v25 = val_6.EquippedData and val_6.EquippedData.Name or nil
        t_3[key_6] = v25
    end

    arg27:_ClearSlots()
    local v26 = PlayerDataController_m:Get("EquippedEmotes")
    local v27 = 360 / CONSTANTS_m.MAX_EQUIPPABLE_EMOTES

    for index = 1, CONSTANTS_m.MAX_EQUIPPABLE_EMOTES do
        if GenerateHash ~= arg27._generate_hash then
            return
        end

        local str = tostring(index)
        local v28 = EmoteWheelSlot_m.new(v26[str])
        v28:SetRotation(v27 * 0.5 + (index - 1) * v27 + math.deg(v3))
        v28.Frame.Parent = arg27.Frame.Slots
        arg27._emote_wheel_slots[str] = v28

        if not arg28 then
            if t_3[str] ~= (v28.EquippedData and v28.EquippedData.Name or nil) then
                v28:EquipBounceEffect()
                task.defer(arg27.HighlightSlot, arg27, v28)
            end
        end
    end
end

function t._Init(_) -- line: 281
end

return t
