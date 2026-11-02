local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local Signal_m = require(ReplicatedStorage.Modules.Signal)
local t = {}
t.__index = t

function t.new(arg1) -- line: 10
    -- upvalues:
    --  [1] t (copy)
    --  [2] Signal_m (copy)

    assert(
        if typeof(arg1) == "Instance" then arg1:IsA("Frame") else false,
        "Argument 1 invalid, expected a Frame, got " .. tostring(arg1)
    )
    local t_1 = setmetatable({}, t)
    t_1.Frame = arg1
    t_1.RedFrame = t_1.Frame:WaitForChild("Red")
    t_1.RedTextBox = t_1.RedFrame:WaitForChild("Box")
    t_1.GreenFrame = t_1.Frame:WaitForChild("Green")
    t_1.GreenTextBox = t_1.GreenFrame:WaitForChild("Box")
    t_1.BlueFrame = t_1.Frame:WaitForChild("Blue")
    t_1.BlueTextBox = t_1.BlueFrame:WaitForChild("Box")
    t_1.HexFrame = t_1.Frame:WaitForChild("Hex")
    t_1.HexTextBox = t_1.HexFrame:WaitForChild("Box")
    t_1.HexOutline = t_1.HexFrame:WaitForChild("Outline")
    t_1.Value = nil
    t_1.Updated = Signal_m.new()
    t_1.Changed = Signal_m.new()
    t_1:_Init()

    return t_1
end

function t.SetColor(arg2, arg3, arg4) -- line: 42
    arg2.Value = arg3
    arg2.Updated:Fire(arg2.Value, arg4 or false)
    arg2:_ValueChanged()
end

function t.SetStartingColor(arg5, arg6) -- line: 49
    arg5.Value = arg6
    arg5.Changed:Fire(arg5.Value)
    arg5:_ValueChanged()
end

function t.Destroy(arg7) -- line: 55
    arg7.Updated:Destroy()
    arg7.Changed:Destroy()
end

function t._ClampColorChannel(_, arg9) -- line: 65
    local floorValue = math.floor(tonumber(arg9) or 0)

    return (math.clamp(floorValue, 0, 255))
end

function t._ValueChanged(arg10) -- line: 69
    -- upvalues:
    --  [1] Utility_m (copy)

    local Value = arg10.Value
    local v2 = Utility_m:Color3FromHex(Value)
    local v4 = arg10:_ClampColorChannel(v2.R * 255)
    local v6 = arg10:_ClampColorChannel(v2.G * 255)
    local v8 = arg10:_ClampColorChannel(v2.B * 255)
    arg10.RedTextBox.Text = v4
    arg10.GreenTextBox.Text = v6
    arg10.BlueTextBox.Text = v8
    arg10.HexTextBox.Text = Value
    arg10.HexOutline.ImageColor3 = v2
end

function t._UpdateFromRGB(arg11) -- line: 85
    -- upvalues:
    --  [1] Utility_m (copy)

    local v9 = arg11:_ClampColorChannel(arg11.RedTextBox.Text)
    local v10 = arg11:_ClampColorChannel(arg11.GreenTextBox.Text)
    local v14 = arg11:_ClampColorChannel(arg11.BlueTextBox.Text)
    local color = Color3.fromRGB(v9, v10, v14)
    arg11:SetColor((Utility_m:HexFromColor3(color)))
end

function t._UpdateFromHex(arg12) -- line: 95
    -- upvalues:
    --  [1] Utility_m (copy)

    local lowerText = string.lower(arg12.HexTextBox.Text)
    arg12:SetColor(Utility_m:IsValidHex(lowerText) and lowerText or "#000000")
end

function t._Init(arg13) -- line: 102
    arg13.RedTextBox.FocusLost:Connect(function() -- line: 103
        -- upvalues:
        --  [1] arg13 (copy)

        arg13:_UpdateFromRGB()
    end)
    arg13.GreenTextBox.FocusLost:Connect(function() -- line: 107
        -- upvalues:
        --  [1] arg13 (copy)

        arg13:_UpdateFromRGB()
    end)
    arg13.BlueTextBox.FocusLost:Connect(function() -- line: 111
        -- upvalues:
        --  [1] arg13 (copy)

        arg13:_UpdateFromRGB()
    end)
    arg13.HexTextBox.FocusLost:Connect(function() -- line: 115
        -- upvalues:
        --  [1] arg13 (copy)

        arg13:_UpdateFromHex()
    end)
    arg13:SetStartingColor("#ffffff")
end

return t
