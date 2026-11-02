local Players = game:GetService("Players")
local ButtonEffect_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("ButtonEffect")
)
local SettingSlot_m = require(Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("SettingSlot"))
local color = Color3.fromRGB(0, 0, 0)
local color_1 = Color3.fromRGB(255, 255, 255)
local color_2 = Color3.fromRGB(100, 255, 50)
local t = setmetatable({}, SettingSlot_m)
t.__index = t

function t.new(...) -- line: 14
    -- upvalues:
    --  [1] SettingSlot_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(SettingSlot_m.new(...), t)
    t_1.ToggleContainer = t_1.ControlsSettingFrame:WaitForChild("Container")
    t_1.Background = t_1.ToggleContainer:WaitForChild("Background")
    t_1.Button = t_1.ToggleContainer:WaitForChild("Button")
    t_1.Slider = t_1.Button:WaitForChild("Slider")
    t_1._custom_value_set = false
    t_1:_Init()

    return t_1
end

function t._Update(arg1) -- line: 39
    local v4 = arg1.Value and UDim2.new(0.75, 0, 0.5, 0) or UDim2.new(0.25, 0, 0.5, 0)

    if arg1.Slider:IsDescendantOf(game) then
        arg1.Slider:TweenPosition(
            v4,
            "Out",
            "Quint",
            0.5,
            true
        )

        return
    end

    arg1.Slider.Position = v4
end

function t._Toggle(arg2) -- line: 49
    arg2:InputValue(not arg2.Value)
end

function t._Init(arg3) -- line: 53
    -- upvalues:
    --  [1] color (copy)
    --  [2] color (copy)
    --  [3] color_1 (copy)
    --  [4] color_2 (copy)
    --  [5] ButtonEffect_m (copy)

    arg3.Changed:Connect(function() -- line: 54
        -- upvalues:
        --  [1] arg3 (copy)

        arg3:_Update()
    end)
    arg3.Button.MouseButton1Click:Connect(function() -- line: 58
        -- upvalues:
        --  [1] arg3 (copy)

        arg3:_Toggle()
    end)
    arg3.Slider:GetPropertyChangedSignal("Position"):Connect(function() -- line: 62
        -- upvalues:
        --  [1] arg3 (copy)
        --  [2] color (ref)
        --  [3] color (ref)
        --  [4] color_1 (ref)
        --  [5] color_2 (ref)

        local v5 = (arg3.Slider.Position.X.Scale - 0.25) / 0.5
        arg3.Slider.ImageColor3 = color:Lerp(color, v5)
        arg3.Background.ImageColor3 = color_1:Lerp(color_2, v5)
    end)
    arg3:_Update()
    ButtonEffect_m:Add(arg3.Button, nil, { ReleaseRatio = 0.95, HoverRatio = 0.95 })
end

return t
