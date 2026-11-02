local NameDisplay_m = require(script:WaitForChild("NameDisplay"))
local Description_m = require(script:WaitForChild("Description"))
local Cosmetics_m = require(script:WaitForChild("Cosmetics"))
local Actions_m = require(script:WaitForChild("Actions"))
local Options_m = require(script:WaitForChild("Options"))
local t = {}
t.__index = t

function t.new(arg1) -- line: 10
    -- upvalues:
    --  [1] t (copy)
    --  [2] Options_m (copy)
    --  [3] Actions_m (copy)
    --  [4] Cosmetics_m (copy)
    --  [5] NameDisplay_m (copy)
    --  [6] Description_m (copy)

    local t_1 = setmetatable({}, t)
    t_1.Interface = arg1
    t_1.Frame = t_1.Interface.Frame:WaitForChild("Customize")
    t_1.TopFrame = t_1.Frame:WaitForChild("Top")
    t_1.BottomFrame = t_1.Frame:WaitForChild("Bottom")
    t_1.BottomContainer = t_1.BottomFrame:WaitForChild("Container")
    t_1.Options = Options_m.new(t_1)
    t_1.Actions = Actions_m.new(t_1)
    t_1.Cosmetics = Cosmetics_m.new(t_1)
    t_1.NameDisplay = NameDisplay_m.new(t_1)
    t_1.Description = Description_m.new(t_1)
    t_1:_Init()

    return t_1
end

function t.SetVisible(arg2, arg3) -- line: 33
    local BottomFrame = arg2.BottomFrame
    local v6 = arg3 and UDim2.new(0.5, 0, 1, 0) or UDim2.new(0.5, 0, 1.5, 0)
    BottomFrame:TweenPosition(
        v6,
        "Out",
        "Quint",
        0.25,
        true
    )
    local TopFrame = arg2.TopFrame
    v6 = arg3 and UDim2.new(0.5, 0, 0, 0) or UDim2.new(0.5, 0, -0.5, 0)
    TopFrame:TweenPosition(
        v6,
        "Out",
        "Quint",
        0.25,
        true
    )
end

function t.OnCustomizingStateChanged(arg4, ...) -- line: 38
    arg4.Options:OnCustomizingStateChanged(...)
    arg4.Actions:OnCustomizingStateChanged(...)
    arg4.Cosmetics:OnCustomizingStateChanged(...)
    arg4.Description:OnCustomizingStateChanged(...)
    arg4.NameDisplay:OnCustomizingStateChanged(...)
end

function t.OnStateChanged(arg5, ...) -- line: 46
    arg5.Cosmetics:OnStateChanged(...)
    arg5.Actions:OnStateChanged(...)
    arg5.Options:OnStateChanged(...)
end

function t._Setup(arg6) -- line: 56
    arg6.Frame.Visible = true
end

function t._Init(arg7) -- line: 60
    arg7:_Setup()
end

return t
