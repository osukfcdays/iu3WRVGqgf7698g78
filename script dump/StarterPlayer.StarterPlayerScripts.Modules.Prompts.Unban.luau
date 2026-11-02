local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local ButtonEffect_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("ButtonEffect")
)
local Prompt_m = require(Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("Prompt"))
local t = setmetatable({}, Prompt_m)
t.__index = t

function t.new(arg1) -- line: 11
    -- upvalues:
    --  [1] Prompt_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(Prompt_m.new(script.Name), t)
    t_1.CloseButton = t_1.PromptFrame:WaitForChild("Close")
    t_1.ConfirmButton = t_1.PromptFrame:WaitForChild("Confirm")
    t_1.TitleText = t_1.PromptFrame:WaitForChild("Title")
    t_1._ban_data = arg1
    t_1:_Init()

    return t_1
end

function t._Setup(arg2) -- line: 35
    arg2.TitleText.Text = "Unban " .. arg2._ban_data.Name
end

function t._Init(arg3) -- line: 39
    -- upvalues:
    --  [1] ReplicatedStorage (copy)
    --  [2] RunService (copy)
    --  [3] ButtonEffect_m (copy)

    arg3.CloseButton.MouseButton1Click:Connect(function() -- line: 40
        -- upvalues:
        --  [1] arg3 (copy)

        arg3:CloseRequest()
    end)
    arg3.ConfirmButton.MouseButton1Click:Connect(function() -- line: 44
        -- upvalues:
        --  [1] ReplicatedStorage (ref)
        --  [2] arg3 (copy)
        --  [3] RunService (ref)

        ReplicatedStorage.Remotes.Moderator.Unban:FireServer(arg3._ban_data.Name)
        RunService.Heartbeat:Wait()
        arg3:CloseRequest()
    end)
    arg3:_Setup()
    ButtonEffect_m:Add(arg3.CloseButton)
    ButtonEffect_m:Add(arg3.ConfirmButton)
end

return t
