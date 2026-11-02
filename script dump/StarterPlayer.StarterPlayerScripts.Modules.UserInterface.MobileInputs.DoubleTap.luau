local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local PlayerDataController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("PlayerDataController")
)
local FighterController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("FighterController")
)
local t = {}
t.__index = t

function t.new(arg1) -- line: 10
    -- upvalues:
    --  [1] t (copy)

    local t_1 = setmetatable({}, t)
    t_1.MobileInputs = arg1
    t_1.Frame = t_1.MobileInputs.Frame:WaitForChild("DoubleTapArea")
    t_1._connections = {}
    t_1._shooting_connection = nil
    t_1._last_tap = 0
    t_1:_Init()

    return t_1
end

function t.IsWithin(arg2, arg3) -- line: 29
    -- upvalues:
    --  [1] PlayerDataController_m (copy)

    arg3 -= arg2.MobileInputs.Frame.AbsolutePosition.X
    local v3

    if PlayerDataController_m:GetSetting("Left Handed Touch Controls") then
        v3 = arg3 <= arg2.MobileInputs.Frame.AbsoluteSize.X / 2

        return v3
    end

    v3 = arg3 >= arg2.MobileInputs.Frame.AbsoluteSize.X / 2

    return v3
end

function t.ResetTapWindow(arg4) -- line: 36
    arg4._last_tap = 0
end

function t.UpdateVisuals(arg5) -- line: 40
    -- upvalues:
    --  [1] PlayerDataController_m (copy)

    local v4 = arg5.MobileInputs.EditorEnabled
    local Frame = arg5.Frame

    if v4 then
        v4 = PlayerDataController_m:GetSetting("Double Tap Shoot")
    end

    Frame.Visible = v4
    arg5.Frame.Position = if PlayerDataController_m:GetSetting("Left Handed Touch Controls") then UDim2.new(
        0.5,
        0,
        0.5,
        0
    ) else UDim2.new(1, 0, 0.5, 0)
end

function t.VerifyControls(arg6, arg7) -- line: 45
    -- upvalues:
    --  [1] UserInputService (copy)
    --  [2] PlayerDataController_m (copy)
    --  [3] FighterController_m (copy)

    for _, val in pairs(arg6._connections) do
        val:Disconnect()
    end

    arg6._connections = {}
    arg6:_CancelShootingConnection()
    arg6:ResetTapWindow()

    if not arg7 then
        return
    end

    table.insert(arg6._connections, UserInputService.InputBegan:Connect(function(arg8, _) -- line: 59
        -- upvalues:
        --  [1] arg6 (copy)
        --  [2] PlayerDataController_m (ref)
        --  [3] FighterController_m (ref)

        if
            arg8.UserInputType ~= Enum.UserInputType.Touch
            or arg6.MobileInputs.EditorEnabled
            or not arg6:IsWithin(arg8.Position.X)
            or #arg6.MobileInputs.Buttons:GetButtonsFromPosition(arg8.Position.X, arg8.Position.Y) > 0
        then
            return
        end

        if tick() - arg6._last_tap > PlayerDataController_m:GetSetting("Double Tap Shoot Window") then
            arg6._last_tap = tick()

            return
        end

        if not (PlayerDataController_m:GetSetting("Double Tap Shoot") or FighterController_m.LocalFighter and not FighterController_m.LocalFighter:Get(
            "IsInDuel"
        ) and not FighterController_m.LocalFighter:Get("IsInShootingRange")) then
            return
        end

        arg6:_CancelShootingConnection()
        arg6._shooting_connection = arg8:GetPropertyChangedSignal("UserInputState"):Connect(function() -- line: 82
            -- upvalues:
            --  [1] arg8 (copy)
            --  [2] arg6 (ref)

            if arg8.UserInputState == Enum.UserInputState.End then
                arg6:_CancelShootingConnection()
                arg6.MobileInputs.Buttons.Buttons.mobile_shoot:Button1Up()
            end
        end)
        arg6.MobileInputs.Buttons.Buttons.mobile_shoot:Button1Down()
    end))
end

function t._CancelShootingConnection(arg10) -- line: 97
    if arg10._shooting_connection then
        arg10._shooting_connection:Disconnect()
        arg10._shooting_connection = nil
    end
end

function t._Init(arg11) -- line: 104
    -- upvalues:
    --  [1] PlayerDataController_m (copy)

    arg11.MobileInputs.EditorEnabledChanged:Connect(function() -- line: 105
        -- upvalues:
        --  [1] arg11 (copy)

        arg11:UpdateVisuals()
    end)
    PlayerDataController_m:GetSettingChangedSignal("Left Handed Touch Controls"):Connect(function() -- line: 109
        -- upvalues:
        --  [1] arg11 (copy)

        arg11:UpdateVisuals()
    end)
    PlayerDataController_m:GetSettingChangedSignal("Double Tap Shoot"):Connect(function() -- line: 113
        -- upvalues:
        --  [1] arg11 (copy)

        arg11:UpdateVisuals()
    end)
    arg11:UpdateVisuals()
end

return t
