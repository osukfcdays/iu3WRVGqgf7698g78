local Players = game:GetService("Players")
local Pages_m = require(
    Players.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("Pages")
)
local UILibrary_m = require(Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("UILibrary"))
local t = {}
t.__index = t

function t._new() -- line: 9
    -- upvalues:
    --  [1] t (copy)
    --  [2] UILibrary_m (copy)

    local t_1 = setmetatable({}, t)
    t_1.Frame = UILibrary_m:GetTo("MainFrame", "JoystickModal")
    t_1:_Init()

    return t_1
end

function t._Update(arg1) -- line: 29
    -- upvalues:
    --  [1] Pages_m (copy)

    local Frame = arg1.Frame
    Frame.Visible = Pages_m.PageSystem.CurrentPage ~= nil
end

function t._Init(arg2) -- line: 33
    -- upvalues:
    --  [1] Pages_m (copy)

    Pages_m.PageSystem.PagesActivity:Connect(function() -- line: 34
        -- upvalues:
        --  [1] arg2 (copy)

        arg2:_Update()
    end)
    arg2:_Update()
end

return t._new()
