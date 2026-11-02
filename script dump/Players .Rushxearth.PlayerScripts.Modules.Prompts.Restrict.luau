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
    t_1.CasualLBsFrame = t_1.PromptFrame:WaitForChild("CasualLBs")
    t_1.CasualLBsButton = t_1.CasualLBsFrame:WaitForChild("Button")
    t_1.CasualLBsButtonEmpty = t_1.CasualLBsButton:WaitForChild("Empty")
    t_1.CasualLBsButtonFilled = t_1.CasualLBsButton:WaitForChild("Filled")
    t_1.CompLBsFrame = t_1.PromptFrame:WaitForChild("CompLBs")
    t_1.CompLBsButton = t_1.CompLBsFrame:WaitForChild("Button")
    t_1.CompLBsButtonEmpty = t_1.CompLBsButton:WaitForChild("Empty")
    t_1.CompLBsButtonFilled = t_1.CompLBsButton:WaitForChild("Filled")
    t_1._ban_data = arg1
    t_1:_Init()

    return t_1
end

function t.Confirm(arg2) -- line: 36
    -- upvalues:
    --  [1] ReplicatedStorage (copy)

    ReplicatedStorage.Remotes.Moderator.Restrict:FireServer(
        arg2._ban_data.Name,
        {
            RestrictedFromCasualLeaderboards = arg2.CasualLBsButtonFilled.Visible,
            RestrictedFromCompetitiveLeaderboards = arg2.CompLBsButtonFilled.Visible
        }
    )
    task.defer(arg2.CloseRequest, arg2)
end

function t._Setup(arg3) -- line: 50
    arg3.TitleText.Text = "@" .. arg3._ban_data.Name
    local v4 = arg3._ban_data.Restrictions
    local CasualLBsButtonFilled = arg3.CasualLBsButtonFilled

    if v4 then
        v4 = arg3._ban_data.Restrictions.RestrictedFromCasualLeaderboards
    end

    CasualLBsButtonFilled.Visible = v4
    arg3.CasualLBsButtonEmpty.Visible = not arg3.CasualLBsButtonFilled.Visible
    local v5 = arg3._ban_data.Restrictions
    local CompLBsButtonFilled = arg3.CompLBsButtonFilled
    v5 = v5 and arg3._ban_data.Restrictions.RestrictedFromCompetitiveLeaderboards
    CompLBsButtonFilled.Visible = v5
    arg3.CompLBsButtonEmpty.Visible = not arg3.CompLBsButtonFilled.Visible
end

function t._Init(arg4) -- line: 58
    -- upvalues:
    --  [1] ButtonEffect_m (copy)

    arg4.CloseButton.MouseButton1Click:Connect(function() -- line: 59
        -- upvalues:
        --  [1] arg4 (copy)

        arg4:CloseRequest()
    end)
    arg4.ConfirmButton.MouseButton1Click:Connect(function() -- line: 63
        -- upvalues:
        --  [1] arg4 (copy)

        arg4:Confirm()
    end)
    arg4.CasualLBsButton.MouseButton1Click:Connect(function() -- line: 67
        -- upvalues:
        --  [1] arg4 (copy)

        arg4.CasualLBsButtonEmpty.Visible = not arg4.CasualLBsButtonEmpty.Visible
        arg4.CasualLBsButtonFilled.Visible = not arg4.CasualLBsButtonEmpty.Visible
    end)
    arg4.CompLBsButton.MouseButton1Click:Connect(function() -- line: 72
        -- upvalues:
        --  [1] arg4 (copy)

        arg4.CompLBsButtonEmpty.Visible = not arg4.CompLBsButtonEmpty.Visible
        arg4.CompLBsButtonFilled.Visible = not arg4.CompLBsButtonEmpty.Visible
    end)
    arg4:_Setup()
    ButtonEffect_m:Add(arg4.CloseButton)
    ButtonEffect_m:Add(arg4.ConfirmButton)
    ButtonEffect_m:Add(arg4.CasualLBsButton)
    ButtonEffect_m:Add(arg4.CompLBsButton)
end

return t
