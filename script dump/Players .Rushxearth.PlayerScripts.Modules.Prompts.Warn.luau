local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local ButtonEffect_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("ButtonEffect")
)
local Prompt_m = require(Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("Prompt"))
local t = setmetatable({}, Prompt_m)
t.__index = t

function t.new(arg1) -- line: 10
    -- upvalues:
    --  [1] Prompt_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(Prompt_m.new(script.Name), t)
    t_1.CloseButton = t_1.PromptFrame:WaitForChild("Close")
    t_1.ConfirmButton = t_1.PromptFrame:WaitForChild("Confirm")
    t_1.TitleText = t_1.PromptFrame:WaitForChild("Title")
    t_1.DetailsFrame = t_1.PromptFrame:WaitForChild("Details")
    t_1.ReasonCustomBox = t_1.DetailsFrame:WaitForChild("ReasonCustom"):WaitForChild("Input"):WaitForChild(
        "Box"
    )
    t_1._ban_data = arg1
    t_1:_Init()

    return t_1
end

function t.Confirm(arg2) -- line: 30
    -- upvalues:
    --  [1] ReplicatedStorage (copy)

    local Text = arg2.ReasonCustomBox.Text

    if #Text < 5 or #Text > 999 then
        return
    end

    ReplicatedStorage.Remotes.Moderator.Warn:FireServer(arg2._ban_data.Name, Text)
    task.defer(arg2.CloseRequest, arg2)
end

function t._Setup(arg3) -- line: 46
    arg3.TitleText.Text = "@" .. arg3._ban_data.Name
end

function t._Init(arg4) -- line: 50
    -- upvalues:
    --  [1] ButtonEffect_m (copy)

    arg4.CloseButton.MouseButton1Click:Connect(function() -- line: 51
        -- upvalues:
        --  [1] arg4 (copy)

        arg4:CloseRequest()
    end)
    arg4.ConfirmButton.MouseButton1Click:Connect(function() -- line: 55
        -- upvalues:
        --  [1] arg4 (copy)

        arg4:Confirm()
    end)
    arg4:_Setup()
    ButtonEffect_m:Add(arg4.CloseButton)
    ButtonEffect_m:Add(arg4.ConfirmButton)
end

return t
