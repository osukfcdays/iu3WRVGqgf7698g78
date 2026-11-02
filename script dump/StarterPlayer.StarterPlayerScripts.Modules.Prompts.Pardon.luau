local ReplicatedStorage = game:GetService("ReplicatedStorage")
local _ = game:GetService("RunService")
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

function t.Confirm(arg2) -- line: 29
    -- upvalues:
    --  [1] ReplicatedStorage (copy)

    local Success, Result = pcall(
        ReplicatedStorage.Remotes.Moderator.PardonRedFlags.InvokeServer,
        ReplicatedStorage.Remotes.Moderator.PardonRedFlags,
        arg2._ban_data.Name
    )
    local v4 = ""
    local v5 = pairs
    local v6 = Success and Result or {}

    for key, val in v5(v6) do
        v4 = v4 .. val .. (if not (key < #Result) then "" else "\n")
    end

    local OpenPrompt = arg2.OpenPrompt
    OpenPrompt:Fire(
        "ErrorMessage",
        if not Success then "Whoops!" else if v4 == "" then "Whoops!" else "Success!",
        Success and v4 ~= "" and "Successfully pardoned this player's red flags:\n" .. v4 or (if not Success then "Failed to pardon this player's red flags, please try again!" else if v4 ~= "" then "Failed to pardon this player's red flags, please try again!" else "This player has no red flags!")
    )
end

function t._Setup(arg3) -- line: 48
    arg3.TitleText.Text = "Pardon " .. arg3._ban_data.Name
end

function t._Init(arg4) -- line: 52
    -- upvalues:
    --  [1] ButtonEffect_m (copy)

    arg4.CloseButton.MouseButton1Click:Connect(function() -- line: 53
        -- upvalues:
        --  [1] arg4 (copy)

        arg4:CloseRequest()
    end)
    arg4.ConfirmButton.MouseButton1Click:Connect(function() -- line: 57
        -- upvalues:
        --  [1] arg4 (copy)

        arg4:Confirm()
    end)
    arg4:_Setup()
    ButtonEffect_m:Add(arg4.CloseButton)
    ButtonEffect_m:Add(arg4.ConfirmButton)
end

return t
