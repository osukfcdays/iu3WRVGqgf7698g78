local Utility_m = require(game:GetService("ReplicatedStorage").Modules.Utility)
local t = {}
t.__index = t

local function verify_confirm(arg1) -- line: 8
    return arg1
end

local function verify_boolean(arg2) -- line: 12
    if typeof(arg2) == "boolean" then
        return arg2
    end
end

local function verify_hotkey(arg3) -- line: 18
    -- upvalues:
    --  [1] Utility_m (copy)

    if arg3 == nil or arg3 == "nil" then
        return "nil"
    end

    if Utility_m:GetInputEnumFromName(arg3) then
        return arg3
    end
end

local function verify_color(arg4) -- line: 26
    -- upvalues:
    --  [1] Utility_m (copy)

    if Utility_m:IsValidHex(arg4) then
        return arg4
    end
end

function t.new(
    arg5,
    arg6,
    arg7,
    arg8,
    arg9,
    arg10,
    arg11,
    ...
) -- line: 32
    -- upvalues:
    --  [1] t (copy)
    --  [2] verify_confirm (copy)
    --  [3] verify_boolean (copy)
    --  [4] verify_hotkey (copy)
    --  [5] verify_color (copy)

    local v1 = false

    if #arg10 >= 7 then
        v1 = if string.sub(arg10, #arg10 - 6, #arg10) ~= "Confirm" then false else true
    end

    local v2 = if v1 and arg10 ~= "Confirm" then string.sub(arg10, 1, #arg10 - 7) else arg10
    local t_1 = setmetatable({}, t)
    t_1.Section = arg5
    t_1.Name = arg6
    t_1.DisplayName = arg7
    t_1.Image = arg8
    t_1.Description = arg9
    t_1.DefaultValue = arg11
    t_1.InputType = v2
    t_1.IsConfirmSetting = v1
    t_1.VerifyInput = nil
    t_1.Options = nil
    t_1.Min = nil
    t_1.Max = nil
    t_1.Increment = nil
    t_1.IsPercent = nil
    v2 = { ... }

    if t_1.InputType == "Confirm" then
        t_1.VerifyInput = verify_confirm
    elseif
        t_1.InputType == "Toggle"
        or t_1.InputType == "ToggleConfirm"
        or t_1.InputType == "Checkbox"
    then
        t_1.VerifyInput = verify_boolean
    elseif t_1.InputType == "Hotkey" then
        t_1.VerifyInput = verify_hotkey
    elseif t_1.InputType == "Color" then
        t_1.VerifyInput = verify_color
    elseif
        t_1.InputType == "Options"
        or t_1.InputType == "OptionsConfirm"
        or t_1.InputType == "Dropdown"
        or t_1.InputType == "DropdownConfirm"
    then
        v1 = table.unpack(v2)
        t_1.Options = v1

        function t_1.VerifyInput(arg12) -- line: 70
            -- upvalues:
            --  [1] v1 (copy)

            return typeof(arg12) == "string" and table.find(v1, arg12) and arg12 or nil
        end
    elseif t_1.InputType == "Slider" or t_1.InputType == "SliderConfirm" then
        t_1.Min, t_1.Max, t_1.Increment, t_1.IsPercent = table.unpack(v2)

        function t_1.VerifyInput(arg13) -- line: 81
            -- upvalues:
            --  [1] t_1 (copy)

            local substring = string.sub(arg13, 1, #arg13 - 1)

            if
                arg13
                and typeof(arg13) == "string"
                and #arg13 > 1
                and string.sub(arg13, #arg13) == "%"
                and tonumber(substring)
            then
                arg13 = tonumber((string.sub(arg13, 1, #arg13 - 1))) / 100
            else
                arg13 = tonumber(arg13)
            end

            local v4 = string.lower((tostring(arg13))) ~= "nan" and typeof(arg13) == "number" and math.floor(
                math.clamp(arg13, t_1.Min, t_1.Max) * t_1.Increment + 0.5
            ) / t_1.Increment or nil

            return v4
        end
    end

    t_1:_Init()

    return t_1
end

function t._Init(_) -- line: 107
end

return t
