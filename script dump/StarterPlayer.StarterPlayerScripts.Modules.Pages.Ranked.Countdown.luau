local SeasonController_m = require(
    game:GetService("Players").LocalPlayer.PlayerScripts.Controllers.SeasonController
)
local t = {}
t.__index = t

function t.new(arg1) -- line: 10
    -- upvalues:
    --  [1] t (copy)

    local t_1 = setmetatable({}, t)
    t_1.Page = arg1
    t_1.Frame = t_1.Page.Container:WaitForChild("Countdown")
    t_1.Title = t_1.Frame:WaitForChild("Title")
    t_1._thread = nil
    t_1:_Init()

    return t_1
end

function t.Open(arg2) -- line: 28
    arg2:_Update()
end

function t.Close(arg3) -- line: 32
    arg3:_Cleanup()
end

function t._Cleanup(arg4) -- line: 40
    if arg4._thread then
        task.cancel(arg4._thread)
        arg4._thread = nil
    end
end

function t._Update(arg5) -- line: 47
    -- upvalues:
    --  [1] SeasonController_m (copy)

    arg5.Frame.Visible = if SeasonController_m:GetTimeRemaining() == nil then false else true

    if not arg5.Frame.Visible then
        return
    end

    arg5:_Cleanup()
    arg5._thread = task.spawn(function() -- line: 56
        -- upvalues:
        --  [1] arg5 (copy)
        --  [2] SeasonController_m (ref)

        while true do
            arg5.Title.Text = SeasonController_m:GetCountdownText() .. " \226\128\148 Your final ELO determines your Ranked season rewards!"
            wait(1)
        end
    end)
end

function t._Init(_) -- line: 64
end

return t
