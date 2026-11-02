local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Signal_m = require(ReplicatedStorage.Modules.Signal)
local Prompts = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("Prompts")
local t = {}
t.__index = t

function t.new(arg1) -- line: 12
    -- upvalues:
    --  [1] t (copy)
    --  [2] Signal_m (copy)
    --  [3] Prompts (copy)

    assert(
        if typeof(arg1) ~= "string" then false else true,
        "Argument 1 invalid, expected a string, got " .. tostring(arg1)
    )
    local t_1 = setmetatable({}, t)
    t_1.Closed = Signal_m.new()
    t_1.OpenPrompt = Signal_m.new()
    t_1.PromptFrame = Prompts:WaitForChild(arg1):Clone()
    t_1._destroyed = false
    t_1._connections = {}
    t_1._destroy_these = {}
    t_1:_Init()

    return t_1
end

function t.GetDefaultElement(arg2) -- line: 35
    return arg2.CloseButton or nil
end

function t.CloseRequest(arg3) -- line: 39
    arg3.Closed:Fire()
end

function t.Open(arg4, arg5) -- line: 44
    assert(
        if typeof(arg5) ~= "Instance" then false else true,
        "Argument 1 invalid, expected an Instance, got " .. tostring(arg5)
    )
    arg4.PromptFrame.Parent = arg5
    arg4.PromptFrame.Position = UDim2.new(0.5, 0, 0.625, 0)
    arg4.PromptFrame:TweenPosition(
        UDim2.new(0.5, 0, 0.5, 0),
        "Out",
        "Back",
        0.25,
        true
    )
end

function t.Destroy(arg6) -- line: 52
    if arg6._destroyed then
        return
    end

    arg6._destroyed = true

    for _, val in pairs(arg6._destroy_these) do
        val:Destroy()
    end

    arg6._destroy_these = {}

    for _, val_1 in pairs(arg6._connections) do
        val_1:Disconnect()
    end

    arg6._connections = {}
    arg6.PromptFrame:Destroy()
    arg6.Closed:Destroy()
    arg6.OpenPrompt:Destroy()
end

function t._Init(_) -- line: 80
end

return t
