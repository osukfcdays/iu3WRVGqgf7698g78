local FlagUtil_m = require(
    script.Parent.Parent:WaitForChild("CommonUtils"):WaitForChild("FlagUtil")
)
local Value = Enum.ContextActionPriority.Medium.Value
local Players = game:GetService("Players")
local ContextActionService = game:GetService("ContextActionService")
local UserInputService = game:GetService("UserInputService")
local GameSettings = UserSettings().GameSettings
local CameraUtils_m = require(script.Parent:WaitForChild("CameraUtils"))
local UserFixStuckShiftLock = FlagUtil_m.getUserFlag("UserFixStuckShiftLock")
local t = {}
t.__index = t

function t.new() -- line: 33
    -- upvalues:
    --  [1] t (copy)
    --  [2] GameSettings (copy)
    --  [3] Players (copy)
    --  [4] UserInputService (copy)

    local t_1 = setmetatable({}, t)
    t_1.isMouseLocked = false
    t_1.savedMouseCursor = nil
    t_1.boundKeys = { Enum.KeyCode.LeftShift, Enum.KeyCode.RightShift }
    t_1.mouseLockToggledEvent = Instance.new("BindableEvent")
    local v3 = script:FindFirstChild("BoundKeys")

    if not v3 or not v3:IsA("StringValue") then
        if v3 then
            v3:Destroy()
        end

        v3 = Instance.new("StringValue")
        assert(v3, "")
        v3.Name = "BoundKeys"
        v3.Value = "LeftShift,RightShift"
        v3.Parent = script
    end

    if v3 then
        v3.Changed:Connect(function(arg1) -- line: 58
            -- upvalues:
            --  [1] t_1 (copy)

            t_1:OnBoundKeysObjectChanged(arg1)
        end)
        t_1:OnBoundKeysObjectChanged(v3.Value)
    end

    GameSettings.Changed:Connect(function(arg2) -- line: 65
        -- upvalues:
        --  [1] t_1 (copy)

        if arg2 == "ControlMode" or arg2 == "ComputerMovementMode" then
            t_1:UpdateMouseLockAvailability()
        end
    end)
    Players.LocalPlayer:GetPropertyChangedSignal("DevEnableMouseLock"):Connect(function() -- line: 72
        -- upvalues:
        --  [1] t_1 (copy)

        t_1:UpdateMouseLockAvailability()
    end)
    Players.LocalPlayer:GetPropertyChangedSignal("DevComputerMovementMode"):Connect(function() -- line: 77
        -- upvalues:
        --  [1] t_1 (copy)

        t_1:UpdateMouseLockAvailability()
    end)
    UserInputService:GetPropertyChangedSignal("PreferredInput"):Connect(function() -- line: 81
        -- upvalues:
        --  [1] t_1 (copy)

        t_1:UpdateMouseLockAvailability()
    end)
    t_1:UpdateMouseLockAvailability()

    return t_1
end

function t.GetIsMouseLocked(arg3) -- line: 90
    return arg3.isMouseLocked
end

function t.GetBindableToggleEvent(arg4) -- line: 94
    return arg4.mouseLockToggledEvent.Event
end

function t.GetMouseLockOffset(_) -- line: 98
    return Vector3.new(1.75, 0, 0)
end

function t.UpdateMouseLockAvailability(arg6) -- line: 102
    -- upvalues:
    --  [1] Players (copy)
    --  [2] GameSettings (copy)
    --  [3] UserInputService (copy)

    local DevEnableMouseLock_1 = Players.LocalPlayer.DevEnableMouseLock
    local v4 = Players.LocalPlayer.DevComputerMovementMode == Enum.DevComputerMovementMode.Scriptable
    local v5 = GameSettings.ControlMode == Enum.ControlMode.MouseLockSwitch
    local v6 = GameSettings.ComputerMovementMode == Enum.ComputerMovementMode.ClickToMove
    local v8 = UserInputService.PreferredInput == Enum.PreferredInput.KeyboardAndMouse and DevEnableMouseLock_1 and v5 and not v6 and not v4

    if v8 ~= arg6.enabled then
        arg6:EnableMouseLock(v8)
    end
end

function t.OnBoundKeysObjectChanged(t1: table, s1: string) -- line: 115
    t1.boundKeys = {}

    for key in string.gmatch(s1, "[^%s,]+") do
        for _, val in pairs(Enum.KeyCode:GetEnumItems()) do
            if key == val.Name then
                t1.boundKeys[#t1.boundKeys + 1] = val
                break
            end
        end
    end

    t1:UnbindContextActions()
    t1:BindContextActions()
end

function t.OnMouseLockToggled(arg7) -- line: 130
    -- upvalues:
    --  [1] CameraUtils_m (copy)

    arg7.isMouseLocked = not arg7.isMouseLocked

    if arg7.isMouseLocked then
        local CursorImage = script:FindFirstChild("CursorImage")

        if CursorImage and CursorImage:IsA("StringValue") and CursorImage.Value then
            CameraUtils_m.setMouseIconOverride(CursorImage.Value)
        else
            if CursorImage then
                CursorImage:Destroy()
            end

            local CursorImage_StringValue = Instance.new("StringValue")
            assert(CursorImage_StringValue, "")
            CursorImage_StringValue.Name = "CursorImage"
            CursorImage_StringValue.Value = "rbxasset://textures/MouseLockedCursor.png"
            CursorImage_StringValue.Parent = script
            CameraUtils_m.setMouseIconOverride("rbxasset://textures/MouseLockedCursor.png")
        end
    else
        CameraUtils_m.restoreMouseIcon()
    end

    arg7.mouseLockToggledEvent:Fire()
end

function t.DoMouseLockSwitch(arg8, _, arg10, _) -- line: 155
    if arg10 == Enum.UserInputState.Begin then
        arg8:OnMouseLockToggled()

        return Enum.ContextActionResult.Sink
    end

    return Enum.ContextActionResult.Pass
end

function t.BindContextActions(arg12) -- line: 163
    -- upvalues:
    --  [1] ContextActionService (copy)
    --  [2] Value (copy)

    ContextActionService:BindActionAtPriority(
        "MouseLockSwitchAction",
        function(arg13, arg14, arg15) -- line: 164
            -- upvalues:
            --  [1] arg12 (copy)

            return arg12:DoMouseLockSwitch(arg13, arg14, arg15)
        end,
        false,
        Value,
        unpack(arg12.boundKeys)
    )
end

function t.UnbindContextActions(_) -- line: 169
    -- upvalues:
    --  [1] ContextActionService (copy)

    ContextActionService:UnbindAction("MouseLockSwitchAction")
end

function t.IsMouseLocked(arg17) -- line: 173
    return arg17.enabled and arg17.isMouseLocked
end

function t.EnableMouseLock(t2: table, b1: boolean) -- line: 177
    -- upvalues:
    --  [1] CameraUtils_m (copy)
    --  [2] UserFixStuckShiftLock (copy)

    if b1 ~= t2.enabled then
        t2.enabled = b1

        if t2.enabled then
            t2:BindContextActions()

            return
        end

        CameraUtils_m.restoreMouseIcon()
        t2:UnbindContextActions()

        if UserFixStuckShiftLock then
            if t2.isMouseLocked then
                t2.isMouseLocked = false
                t2.mouseLockToggledEvent:Fire()

                return
            end
        else
            if t2.isMouseLocked then
                t2.mouseLockToggledEvent:Fire()
            end

            t2.isMouseLocked = false
        end
    end
end

return t
