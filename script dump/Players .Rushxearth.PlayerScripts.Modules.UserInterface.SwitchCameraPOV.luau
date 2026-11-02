local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local _ = require(ReplicatedStorage.Modules.CONSTANTS)
local _ = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("PlayerDataController")
)
local ControlsController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("ControlsController")
)
local CameraController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("CameraController")
)
local _ = require(Players.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("Pages"))
local UILibrary_m = require(Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("UILibrary"))
local t = {}
t.__index = t

function t._new() -- line: 16
    -- upvalues:
    --  [1] t (copy)
    --  [2] UILibrary_m (copy)

    local t_1 = setmetatable({}, t)
    t_1.Frame = UILibrary_m:GetTo("MainFrame", "BottomStack", "SwitchCameraPOV")
    t_1.Container = t_1.Frame:WaitForChild("Container")
    t_1.Title = t_1.Container:WaitForChild("Title")
    t_1.KeybindIcon = t_1.Container:WaitForChild("Keybind")
    t_1._effect_hash = 0
    t_1:_Init()

    return t_1
end

function t._SwitchEffect(_) -- line: 41
end

function t._UpdateControls(arg2) -- line: 76
    -- upvalues:
    --  [1] ControlsController_m (copy)

    local KeybindIcon = arg2.KeybindIcon
    KeybindIcon.Visible = ControlsController_m.CurrentControls ~= "Touch"
end

function t._Init(arg3) -- line: 80
    -- upvalues:
    --  [1] CameraController_m (copy)
    --  [2] ControlsController_m (copy)

    CameraController_m.POVStateChanged:Connect(function(_, _, arg6) -- line: 81
        -- upvalues:
        --  [1] arg3 (copy)

        if arg6 then
            arg3:_SwitchEffect()
        end
    end)
    ControlsController_m.ControlsChanged:Connect(function() -- line: 87
        -- upvalues:
        --  [1] arg3 (copy)

        arg3:_UpdateControls()
    end)
    arg3:_UpdateControls()
end

return t._new()
