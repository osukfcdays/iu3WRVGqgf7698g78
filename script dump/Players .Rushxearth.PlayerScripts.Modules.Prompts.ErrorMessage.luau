local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local ButtonEffect_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("ButtonEffect")
)
local Prompt_m = require(Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("Prompt"))
local t = setmetatable({}, Prompt_m)
t.__index = t

function t.new(arg1, arg2) -- line: 12
    -- upvalues:
    --  [1] Prompt_m (copy)
    --  [2] t (copy)

    assert(
        if typeof(arg1) ~= "string" then false else true,
        "Argument 1 invalid, expected a string, got " .. tostring(arg1)
    )
    assert(
        if typeof(arg2) ~= "string" then false else true,
        "Argument 2 invalid, expected a string, got " .. tostring(arg2)
    )
    local t_1 = setmetatable(Prompt_m.new(script.Name), t)
    t_1.CloseButton = t_1.PromptFrame:WaitForChild("Close")
    t_1.TitleText = t_1.PromptFrame:WaitForChild("Title")
    t_1.DescriptionText = t_1.PromptFrame:WaitForChild("Description")
    t_1._title = arg1
    t_1._desc = arg2
    t_1:_Init()

    return t_1
end

function t._Setup(arg3) -- line: 40
    -- upvalues:
    --  [1] Utility_m (copy)

    arg3.TitleText.Text = arg3._title
    arg3.DescriptionText.Text = arg3._desc
    Utility_m:CreateSound(
        "rbxassetid://17153811469",
        2,
        1,
        script,
        true,
        5
    )
end

function t._Init(arg4) -- line: 47
    -- upvalues:
    --  [1] ButtonEffect_m (copy)

    arg4.CloseButton.MouseButton1Click:Connect(function() -- line: 48
        -- upvalues:
        --  [1] arg4 (copy)

        arg4:CloseRequest()
    end)
    arg4:_Setup()
    ButtonEffect_m:Add(arg4.CloseButton)
end

return t
