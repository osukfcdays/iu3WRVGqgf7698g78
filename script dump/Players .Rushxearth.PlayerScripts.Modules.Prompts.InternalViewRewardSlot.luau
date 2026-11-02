local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local ButtonEffect_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("ButtonEffect")
)
local RewardSlot_m = require(Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("RewardSlot"))
local Prompt_m = require(Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("Prompt"))
local t = setmetatable({}, Prompt_m)
t.__index = t

function t.new() -- line: 11
    -- upvalues:
    --  [1] Prompt_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(Prompt_m.new(script.Name), t)
    t_1.CloseButton = t_1.PromptFrame:WaitForChild("Close")
    t_1.Container = t_1.PromptFrame:WaitForChild("Container")
    t_1.TextFrame = t_1.PromptFrame:WaitForChild("TextFrame")
    t_1.TextFrameBox = t_1.TextFrame:WaitForChild("Box")
    t_1.TextFrameBackground = t_1.TextFrame:WaitForChild("Background")
    t_1._reward_slot = nil
    t_1:_Init()

    return t_1
end

function t._Update(arg1) -- line: 37
    -- upvalues:
    --  [1] HttpService (copy)
    --  [2] RewardSlot_m (copy)

    if arg1._reward_slot then
        arg1._reward_slot:Destroy()
        arg1._reward_slot = nil
    end

    local Success, Result = pcall(HttpService.JSONDecode, HttpService, arg1.TextFrameBox.Text)

    if Success then
        local Success_1, Result_1 = pcall(function() -- line: 46
            -- upvalues:
            --  [1] RewardSlot_m (ref)
            --  [2] Result (copy)
            --  [3] arg1 (copy)

            local v5 = RewardSlot_m.new(Result)
            v5:UseHighResolutionImage()
            v5:SetInteractable(false)
            v5:SetParent(arg1.Container)

            return v5
        end)

        if Success_1 then
            arg1._reward_slot = Result_1
        end
    end

    local TextFrameBackground = arg1.TextFrameBackground
    TextFrameBackground.ImageColor3 = if arg1.TextFrameBox.Text == "" then Color3.fromRGB(
        255,
        255,
        255
    ) else if not arg1._reward_slot then Color3.fromRGB(255, 50, 50) else Color3.fromRGB(
        255,
        255,
        255
    )
end

function t._Init(arg2) -- line: 62
    -- upvalues:
    --  [1] ButtonEffect_m (copy)

    arg2.CloseButton.MouseButton1Click:Connect(function() -- line: 63
        -- upvalues:
        --  [1] arg2 (copy)

        arg2:CloseRequest()
    end)
    arg2.TextFrameBox:GetPropertyChangedSignal("Text"):Connect(function() -- line: 67
        -- upvalues:
        --  [1] arg2 (copy)

        arg2:_Update()
    end)
    arg2:_Update()
    ButtonEffect_m:Add(arg2.CloseButton)
end

return t
