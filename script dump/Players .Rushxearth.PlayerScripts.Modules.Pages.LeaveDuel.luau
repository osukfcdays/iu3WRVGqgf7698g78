local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local ButtonEffect_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("ButtonEffect")
)
local Page_m = require(Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("Page"))
local t = setmetatable({}, Page_m)
t.__index = t

function t._new() -- line: 12
    -- upvalues:
    --  [1] Page_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(Page_m.new(script.Name), t)
    t_1.CloseButton = t_1.PageFrame:WaitForChild("Close")
    t_1.LeaveButton = t_1.PageFrame:WaitForChild("Leave")
    t_1.LeaveButtonOnFrame = t_1.LeaveButton:WaitForChild("On")
    t_1.LeaveButtonCountdownFrame = t_1.LeaveButton:WaitForChild("Countdown")
    t_1.LeaveButtonCountdownText = t_1.LeaveButtonCountdownFrame:WaitForChild("Title")
    t_1._countdown_hash = 0
    t_1:_Init()

    return t_1
end

function t.Open(arg1, ...) -- line: 32
    -- upvalues:
    --  [1] Page_m (copy)

    Page_m.Open(arg1, ...)
    task.spawn(arg1._Countdown, arg1)
end

function t._Countdown(arg2) -- line: 41
    arg2._countdown_hash += 1
    local _ = arg2._countdown_hash
    arg2.LeaveButtonCountdownFrame.Visible = true
    arg2.LeaveButtonOnFrame.Visible = false
    arg2.LeaveButtonCountdownFrame.Visible = false
    arg2.LeaveButtonOnFrame.Visible = true
end

function t._Init(arg3) -- line: 61
    -- upvalues:
    --  [1] ReplicatedStorage (copy)
    --  [2] ButtonEffect_m (copy)

    arg3.CloseButton.MouseButton1Click:Connect(function() -- line: 62
        -- upvalues:
        --  [1] arg3 (copy)

        arg3:CloseRequest()
    end)
    arg3.LeaveButton.MouseButton1Click:Connect(function() -- line: 66
        -- upvalues:
        --  [1] arg3 (copy)
        --  [2] ReplicatedStorage (ref)

        if arg3.LeaveButtonOnFrame.Visible then
            ReplicatedStorage.Remotes.Duels.LeaveDuel:FireServer()
            arg3:CloseRequest()
        end
    end)
    ButtonEffect_m:Add(arg3.CloseButton)
    ButtonEffect_m:Add(arg3.LeaveButton)
end

return t._new()
