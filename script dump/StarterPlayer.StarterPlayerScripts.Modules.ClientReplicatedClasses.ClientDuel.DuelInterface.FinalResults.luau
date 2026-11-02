local Signal_m = require(game:GetService("ReplicatedStorage").Modules.Signal)
local Buttons_m = require(script:WaitForChild("Buttons"))
local Summary_m = require(script:WaitForChild("Summary"))
local Winners_m = require(script:WaitForChild("Winners"))
local t = {}
t.__index = t

function t.new(arg1) -- line: 11
    -- upvalues:
    --  [1] t (copy)
    --  [2] Signal_m (copy)
    --  [3] Summary_m (copy)
    --  [4] Winners_m (copy)
    --  [5] Buttons_m (copy)

    local t_1 = setmetatable({}, t)
    t_1.Activated = Signal_m.new()
    t_1.PageChanged = Signal_m.new()
    t_1.CurrentPage = nil
    t_1.DuelInterface = arg1
    t_1.Frame = t_1.DuelInterface.Frame:WaitForChild("FinalResults")
    t_1.Summary = Summary_m.new(t_1)
    t_1.Winners = Winners_m.new(t_1)
    t_1.Buttons = Buttons_m.new(t_1)
    t_1._is_active = false
    t_1:_Init()

    return t_1
end

function t.IsActive(arg2) -- line: 35
    return arg2._is_active
end

function t.SetPage(arg3, arg4) -- line: 39
    arg3.CurrentPage = arg4
    arg3.PageChanged:Fire()
    arg3.Winners:SetVisible(if arg3.CurrentPage ~= "Winners" then false else true)
    arg3.Summary:SetVisible(if arg3.CurrentPage ~= "Summary" then false else true)
end

function t.Play(arg5, ...) -- line: 47
    arg5._is_active = true
    arg5.Activated:Fire()

    return arg5.Winners:Play(...)
end

function t.UpdateVisibility(arg6) -- line: 54
    local Frame = arg6.Frame
    local v5 = arg6:IsActive()

    if v5 then
        v5 = not arg6.DuelInterface:IsPageOpen()
    end

    Frame.Visible = v5
end

function t.Destroy(arg7) -- line: 58
    arg7.Activated:Destroy()
    arg7.PageChanged:Destroy()
    arg7.Summary:Destroy()
    arg7.Winners:Destroy()
    arg7.Buttons:Destroy()
end

function t._Setup(arg8) -- line: 71
    arg8.Frame.Visible = false
end

function t._Init(arg9) -- line: 75
    arg9.Activated:Connect(function() -- line: 76
        -- upvalues:
        --  [1] arg9 (copy)

        arg9:UpdateVisibility()
    end)
    arg9:_Setup()
    arg9:SetPage("Winners")
end

return t
