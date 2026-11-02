local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Signal_m = require(ReplicatedStorage.Modules.Signal)
local ControlsController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("ControlsController")
)
local SettingsController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("SettingsController")
)
local UILibrary_m = require(Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("UILibrary"))
local EditorLogic_m = require(script:WaitForChild("EditorLogic"))
local DoubleTap_m = require(script:WaitForChild("DoubleTap"))
local Joystick_m = require(script:WaitForChild("Joystick"))
local Buttons_m = require(script:WaitForChild("Buttons"))
local _ = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("MobileButton")
local t = {}
t.__index = t

function t._new() -- line: 18
    -- upvalues:
    --  [1] t (copy)
    --  [2] Signal_m (copy)
    --  [3] UILibrary_m (copy)
    --  [4] DoubleTap_m (copy)
    --  [5] Joystick_m (copy)
    --  [6] Buttons_m (copy)
    --  [7] EditorLogic_m (copy)

    local t_1 = setmetatable({}, t)
    t_1.EditorEnabledChanged = Signal_m.new()
    t_1.Frame = UILibrary_m:GetTo("MobileInputs")
    t_1.EditorEnabled = false
    t_1.DoubleTap = DoubleTap_m.new(t_1)
    t_1.Joystick = Joystick_m.new(t_1)
    t_1.Buttons = Buttons_m.new(t_1)
    t_1.EditorLogic = EditorLogic_m.new(t_1)
    t_1:_Init()

    return t_1
end

function t.SwitchProfile(arg1, arg2) -- line: 39
    -- upvalues:
    --  [1] SettingsController_m (copy)

    assert(if typeof(arg2) ~= "number" then false else true)
    arg1.EditorLogic:ApplyEdits()
    SettingsController_m:SwitchSettingsProfile(arg2)
end

function t._IsEnabled(_) -- line: 49
    -- upvalues:
    --  [1] ControlsController_m (copy)

    return ControlsController_m.CurrentControls == "Touch"
end

function t._VerifyControls(arg4) -- line: 53
    local v10 = arg4:_IsEnabled()
    arg4.EditorLogic:SetEnabled(false)
    arg4.DoubleTap:VerifyControls(v10)
    arg4.Buttons:VerifyControls(v10)
end

function t._SetupVisibility(arg5) -- line: 61
    -- upvalues:
    --  [1] Players (copy)
    --  [2] ControlsController_m (copy)

    local EliminatedEffect_m = require(
        Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("UserInterface"):WaitForChild(
            "EliminatedEffect"
        )
    )
    local Equipment_m = require(
        Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("UserInterface"):WaitForChild(
            "Equipment"
        )
    )
    local Pages_m = require(
        Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("UserInterface"):WaitForChild(
            "Pages"
        )
    )

    local function update() -- line: 66
        -- upvalues:
        --  [1] arg5 (copy)
        --  [2] EliminatedEffect_m (copy)
        --  [3] Equipment_m (copy)
        --  [4] Pages_m (copy)

        local Frame = arg5.Frame
        local v14 = arg5:_IsEnabled()

        if v14 then
            v14 = not EliminatedEffect_m:IsVisible()

            if v14 then
                v14 = not Equipment_m.IsOpen and not Pages_m.PageSystem.CurrentPage
            end
        end

        Frame.Visible = v14
    end

    ControlsController_m.ControlsChanged:Connect(update)
    EliminatedEffect_m.VisibilityChanged:Connect(update)
    Pages_m.PageSystem.PagesActivity:Connect(update)
    Equipment_m.Opened:Connect(update)
    local Frame_1 = arg5.Frame
    local v15 = arg5:_IsEnabled()

    if v15 then
        v15 = not EliminatedEffect_m:IsVisible()

        if v15 then
            v15 = not Equipment_m.IsOpen and not Pages_m.PageSystem.CurrentPage
        end
    end

    Frame_1.Visible = v15
end

function t._Init(arg6) -- line: 77
    -- upvalues:
    --  [1] ControlsController_m (copy)

    arg6.EditorLogic.EnabledChanged:Connect(function() -- line: 78
        -- upvalues:
        --  [1] arg6 (copy)

        arg6.EditorEnabled = arg6.EditorLogic.Enabled
        arg6.EditorEnabledChanged:Fire()
    end)
    ControlsController_m.ControlsChanged:Connect(function() -- line: 83
        -- upvalues:
        --  [1] arg6 (copy)

        arg6:_VerifyControls()
    end)
    task.defer(arg6._SetupVisibility, arg6)
    task.defer(arg6._VerifyControls, arg6)
end

return t._new()
