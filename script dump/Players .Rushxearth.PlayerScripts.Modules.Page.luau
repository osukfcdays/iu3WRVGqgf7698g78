local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")
local Signal_m = require(ReplicatedStorage.Modules.Signal)
local UILibrary_m = require(Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("UILibrary"))
local Pages = Players.LocalPlayer.PlayerScripts.Assets:WaitForChild("Temp"):WaitForChild("Pages")
local t = {}
t.__index = t

function t.new(arg1) -- line: 15
    -- upvalues:
    --  [1] t (copy)
    --  [2] Signal_m (copy)
    --  [3] UILibrary_m (copy)
    --  [4] Pages (copy)

    assert(
        if typeof(arg1) ~= "string" then false else true,
        "Argument 1 invalid, expected a string, got " .. tostring(arg1)
    )
    local t_1 = setmetatable({}, t)
    t_1.OpenChanged = Signal_m.new()
    t_1.Closed = Signal_m.new()
    t_1.OpenPage = Signal_m.new()
    t_1.Name = arg1
    t_1.PageFrame = UILibrary_m:GetPage(arg1)
    t_1.CantBeClosedFromInputs = false
    t_1.DisableGlowyBackground = false
    t_1.UseDarkBlurryBackground = false
    t_1._default_size = t_1.PageFrame.Size
    t_1._is_open = false
    t_1._is_open_hash = 0
    t_1._open_connections = {}
    t_1._open_threads = {}
    t_1._temp_folder = Pages
    t_1._redirect_to = nil
    t_1._open_animation_disabled = false
    t_1:_Init()

    return t_1
end

function t.GetDefaultElement(arg2) -- line: 48
    return arg2.PromptSystem and arg2.PromptSystem:GetDefaultElement() or arg2.PageFrame
end

function t.CloseRequest(arg3) -- line: 52
    if arg3.PromptSystem and arg3.PromptSystem.CurrentPrompt then
        arg3.PromptSystem.CurrentPrompt:CloseRequest()

        return
    end

    if arg3._redirect_to then
        arg3.OpenPage:Fire(arg3._redirect_to)
        arg3._redirect_to = nil

        return
    end

    arg3.Closed:Fire()
end

function t.IsOpen(arg4) -- line: 63
    return arg4._is_open
end

function t.Open(arg5, arg6) -- line: 68
    -- upvalues:
    --  [1] GuiService (copy)

    assert(
        if typeof(arg6) ~= "Instance" then false else true,
        "Argument 1 invalid, expected an Instance, got " .. tostring(arg6)
    )
    arg5.PageFrame.Parent = arg6
    arg5.PageFrame.Visible = true

    if arg5._open_animation_disabled or GuiService.ReducedMotionEnabled then
        arg5.PageFrame.Size = arg5._default_size
        arg5.PageFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    else
        arg5.PageFrame.Size = UDim2.new(
            arg5._default_size.X.Scale * 0.75,
            arg5._default_size.X.Offset * 0.75,
            arg5._default_size.Y.Scale * 0.75,
            arg5._default_size.Y.Offset * 0.75
        )
        arg5.PageFrame:TweenSize(
            arg5._default_size,
            "Out",
            "Back",
            0.25,
            true
        )
        arg5.PageFrame.Position = UDim2.new(0.5, 0, 0.6, 0)
        arg5.PageFrame:TweenPosition(
            UDim2.new(0.5, 0, 0.5, 0),
            "Out",
            "Back",
            0.25,
            true
        )
    end

    arg5:_CleanupOnOpenChanged()
    arg5._is_open = true
    arg5._is_open_hash += 1
    arg5.OpenChanged:Fire()
end

function t.Close(arg7) -- line: 90
    -- upvalues:
    --  [1] Pages (copy)

    arg7:_CleanupOnOpenChanged()
    arg7._is_open = false
    arg7._is_open_hash += 1
    arg7.OpenChanged:Fire()

    if arg7.PromptSystem then
        arg7.PromptSystem:Close()
    end

    arg7.PageFrame.Visible = false
    arg7.PageFrame.Parent = Pages
end

function t.RedirectTo(arg8, arg9) -- line: 104
    arg8._redirect_to = arg9
end

function t._CleanupOnOpenChanged(arg10) -- line: 112
    for _, val in pairs(arg10._open_connections) do
        val:Disconnect()
    end

    for _, val_1 in pairs(arg10._open_threads) do
        pcall(task.cancel, val_1)
    end

    arg10._open_connections = {}
    arg10._open_threads = {}
end

function t._Init(_) -- line: 125
end

return t
