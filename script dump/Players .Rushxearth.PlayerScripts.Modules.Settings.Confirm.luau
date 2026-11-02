local SettingSlot_m = require(
    game:GetService("Players").LocalPlayer.PlayerScripts.Modules:WaitForChild("SettingSlot")
)
local t = setmetatable({}, SettingSlot_m)
t.__index = t

function t.new(...) -- line: 8
    -- upvalues:
    --  [1] SettingSlot_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(SettingSlot_m.new(...), t)
    t_1.GreenFrame = t_1.ControlsConfirmButton:WaitForChild("Green")
    t_1.RedFrame = t_1.ControlsConfirmButton:WaitForChild("Red")
    t_1:_Init()

    return t_1
end

function t.SetConfirmColor(arg1, arg2) -- line: 23
    local GreenFrame = arg1.GreenFrame
    GreenFrame.Visible = arg2 == "Green"
    local RedFrame = arg1.RedFrame
    RedFrame.Visible = arg2 == "Red"
end

function t._Confirm(arg3) -- line: 32
    arg3:SetValue(not arg3.Value, nil, true)
end

function t._Setup(arg4) -- line: 36
    arg4.ControlsConfirmButton.Size = UDim2.new(1.538, 0, 0.625, 0)
    arg4.ControlsConfirmButton.Position = UDim2.new(-0.03, 0, 0.5, 0)
end

function t._Init(arg5) -- line: 41
    arg5:_Setup()
end

return t
