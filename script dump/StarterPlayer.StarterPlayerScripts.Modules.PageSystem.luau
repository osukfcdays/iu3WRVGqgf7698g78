local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GamepadService = game:GetService("GamepadService")
local Players = game:GetService("Players")
local _ = require(ReplicatedStorage.Modules.CONSTANTS)
local Signal_m = require(ReplicatedStorage.Modules.Signal)
local ControlsController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.ControlsController
)
local Pages = Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("Pages")
local t = {}
t.__index = t

function t.new(arg1) -- line: 15
    -- upvalues:
    --  [1] t (copy)
    --  [2] Signal_m (copy)

    assert(
        if typeof(arg1) ~= "Instance" then false else true,
        "Argument 1 invalid, expected an Instance, got " .. tostring(arg1)
    )
    local t_1 = setmetatable({}, t)
    t_1.CurrentPage = nil
    t_1.PageAdded = Signal_m.new()
    t_1.PageOpened = Signal_m.new()
    t_1.PageClosed = Signal_m.new()
    t_1.PagesActivity = Signal_m.new()
    t_1._pages = {}
    t_1._container = arg1
    t_1:_Init()

    return t_1
end

function t.GetDefaultElement(arg2) -- line: 39
    local v2 = arg2.CurrentPage

    if v2 then
        v2 = arg2.CurrentPage:GetDefaultElement()
    end

    return v2
end

function t.CloseRequest(arg3) -- line: 43
    if arg3.CurrentPage then
        arg3.CurrentPage:CloseRequest()
    end
end

function t.GetPage(arg4, arg5) -- line: 50
    assert(
        if typeof(arg5) ~= "string" then false else true,
        "Argument 1 invalid, expected a string, got " .. tostring(arg5)
    )
    local _ = "Argument 1 invalid, expected a string, got " .. tostring(arg5)

    for key, val in pairs(arg4._pages) do
        if val.Name == arg5 then
            return val, key
        end
    end
end

function t.OpenPage(arg6, arg7, arg8) -- line: 61
    assert(
        if typeof(arg7) ~= "string" then false else true,
        "Argument 1 invalid, expected a string, got " .. tostring(arg7)
    )
    assert(
        not arg8 or (if typeof(arg8) ~= "boolean" then false else true),
        "Argument 2 invalid, expected a boolean or nil, got " .. tostring(arg8)
    )
    local v6 = arg6:GetPage(arg7)

    if not v6 then
        arg6:CreatePage(arg7)
        v6 = arg6:WaitForPage(arg7)
    end

    assert(v6 ~= nil, "Argument 1 invalid, expected a valid page name, got " .. tostring(arg7))

    if v6 == arg6.CurrentPage then
        if arg8 then
            return
        end

        arg6:CloseCurrentPage()

        return
    else
        if arg8 ~= false then
            arg6:CloseCurrentPage()
            arg6:_OpenPage(v6)
        end

        return
    end
end

function t.CloseCurrentPage(arg9) -- line: 86
    local CurrentPage = arg9.CurrentPage

    if CurrentPage then
        CurrentPage:Close()
        arg9.CurrentPage = nil
        arg9.PageClosed:Fire(CurrentPage)
    end
end

function t.WaitForPage(arg10, arg11) -- line: 97
    assert(
        if typeof(arg11) ~= "string" then false else true,
        "Argument 1 invalid, expected a string, got " .. tostring(arg11)
    )
    local v9 = arg10:GetPage(arg11)

    while true do
        if v9 and v9.Name == arg11 then
            break
        end

        v9 = arg10.PageAdded:Wait()
    end

    return v9
end

function t.CreatePage(arg12, arg13) -- line: 110
    -- upvalues:
    --  [1] Pages (copy)

    assert(
        if typeof(arg13) ~= "string" then false else true,
        "Argument 1 invalid, expected a string, got " .. tostring(arg13)
    )
    local v11 = require(Pages:WaitForChild(arg13))
    assert(v11.GetDefaultElement, "You forgot to implement " .. arg13 .. ":GetDefaultElement()")
    assert(v11.CloseRequest, "You forgot to implement " .. arg13 .. ":CloseRequest()")
    v11.Closed:Connect(function() -- line: 118
        -- upvalues:
        --  [1] arg12 (copy)
        --  [2] v11 (copy)

        arg12:OpenPage(v11.Name, false)
    end)
    v11.OpenPage:Connect(function(...) -- line: 122
        -- upvalues:
        --  [1] v11 (copy)
        --  [2] arg12 (copy)

        if v11:IsOpen() then
            arg12:OpenPage(...)
        end
    end)
    v11:Close()
    table.insert(arg12._pages, v11)
    arg12.PageAdded:Fire(v11)
end

function t._OpenPage(arg14, arg15) -- line: 139
    -- upvalues:
    --  [1] ControlsController_m (copy)
    --  [2] Players (copy)
    --  [3] GamepadService (copy)

    arg14.CurrentPage = arg15
    arg14.CurrentPage:Open(arg14._container)
    arg14.PageOpened:Fire(arg14.CurrentPage)

    if ControlsController_m.CurrentControls == "Gamepad" then
        local v12 = arg14.CurrentPage:GetDefaultElement()

        if not v12 or not v12:IsDescendantOf(Players.LocalPlayer.PlayerGui) then
            return
        end

        GamepadService:EnableGamepadCursor(v12)
    end
end

function t._Init(arg16) -- line: 155
    arg16.PageOpened:Connect(function() -- line: 156
        -- upvalues:
        --  [1] arg16 (copy)

        arg16.PagesActivity:Fire()
    end)
    arg16.PageClosed:Connect(function() -- line: 160
        -- upvalues:
        --  [1] arg16 (copy)

        arg16.PagesActivity:Fire()
    end)
end

return t
