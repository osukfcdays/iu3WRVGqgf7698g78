local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local ButtonEffect_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("ButtonEffect")
)
local Prompt_m = require(Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("Prompt"))
local t = setmetatable({}, Prompt_m)
t.__index = t

function t.new() -- line: 12
    -- upvalues:
    --  [1] Prompt_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(Prompt_m.new(script.Name), t)
    t_1.CloseButton = t_1.PromptFrame:WaitForChild("Close")
    t_1.ConfirmButton = t_1.PromptFrame:WaitForChild("Confirm")
    t_1.List = t_1.PromptFrame:WaitForChild("List")
    t_1.Container = t_1.List:WaitForChild("Container")
    t_1.Layout = t_1.Container:WaitForChild("Layout")
    t_1.RecipientValueBox = t_1.Container:WaitForChild("RecipientValue"):WaitForChild("Input"):WaitForChild(
        "Box"
    )
    t_1.RecipientAddFrame = t_1.Container:WaitForChild("RewardAdd")
    t_1.RecipientAddInputFrame = t_1.RecipientAddFrame:WaitForChild("Input")
    t_1.RecipientAddInputAddButton = t_1.RecipientAddInputFrame:WaitForChild("Add")
    t_1.RecipientAddInputAddNetButton = t_1.RecipientAddInputFrame:WaitForChild("AddNet")
    t_1.RecipientAddInputAddBugNetButton = t_1.RecipientAddInputFrame:WaitForChild("AddBugNet")
    t_1._reward_value_template = t_1.Container:WaitForChild("RewardValue")
    t_1._reward_value_frames = {}
    t_1:_Init()

    return t_1
end

function t.Confirm(arg1) -- line: 39
    -- upvalues:
    --  [1] Utility_m (copy)
    --  [2] HttpService (copy)
    --  [3] ReplicatedStorage (copy)

    if #arg1._reward_value_frames == 0 then
        Utility_m:CreateSound(
            "rbxassetid://17153811469",
            2,
            1,
            script,
            true,
            5
        )

        return
    end

    local Text = arg1.RecipientValueBox.Text

    if Text == "" then
        Utility_m:CreateSound(
            "rbxassetid://17153811469",
            2,
            1,
            script,
            true,
            5
        )

        return
    end

    local t_2 = {}

    for _, val in pairs(arg1._reward_value_frames) do
        local Text_1 = val.Input.Box.Text

        if Text_1 ~= "" then
            if not arg1:_IsValidJSON(Text_1) then
                Utility_m:CreateSound(
                    "rbxassetid://17153811469",
                    2,
                    1,
                    script,
                    true,
                    5
                )

                return
            end

            table.insert(t_2, HttpService:JSONDecode(Text_1))
        end
    end

    local Success, Result = pcall(HttpService.JSONEncode, HttpService, t_2)

    if not Success then
        warn("Failed to encode reward_datas:", Result)
        Utility_m:CreateSound(
            "rbxassetid://17153811469",
            2,
            1,
            script,
            true,
            5
        )

        return
    end

    local Success_1, Result_1 = pcall(
        ReplicatedStorage.Remotes.Debug.Command.InvokeServer,
        ReplicatedStorage.Remotes.Debug.Command,
        "SendOfflineGiftRewards",
        { Text, Result }
    )

    if not Success_1 or not Result_1 then
        warn("Failed to send rewards:", Result_1)
        Utility_m:CreateSound(
            "rbxassetid://17153811469",
            2,
            1,
            script,
            true,
            5
        )

        return
    end

    arg1:CloseRequest()
end

function t._IsValidJSON(_, arg3) -- line: 92
    -- upvalues:
    --  [1] HttpService (copy)

    return (pcall(HttpService.JSONDecode, HttpService, arg3))
end

function t._AddRewardValueFrame(arg4, arg5) -- line: 97
    -- upvalues:
    --  [1] HttpService (copy)
    --  [2] ButtonEffect_m (copy)

    local v4 = arg4._reward_value_template:Clone()
    v4.LayoutOrder = arg4._reward_value_template.LayoutOrder + #arg4._reward_value_frames
    v4.Input.Box.Text = if not arg5 then "" else HttpService:JSONEncode(arg5)
    v4.Parent = arg4.Container
    table.insert(arg4._reward_value_frames, v4)
    v4.Input.Close.MouseButton1Click:Connect(function() -- line: 104
        -- upvalues:
        --  [1] v4 (copy)
        --  [2] arg4 (copy)

        v4:Destroy()
        local index = table.find(arg4._reward_value_frames, v4)

        if index then
            table.remove(arg4._reward_value_frames, index)
        end
    end)
    v4.Input.Box:GetPropertyChangedSignal("Text"):Connect(function() -- line: 114
        -- upvalues:
        --  [1] v4 (copy)
        --  [2] arg4 (copy)

        v4.Input.Background.ImageColor3 = if v4.Input.Box.Text == "" or arg4:_IsValidJSON(
            v4.Input.Box.Text
        ) then Color3.fromRGB(255, 255, 255) else Color3.fromRGB(255, 50, 50)
    end)
    ButtonEffect_m:Add(v4.Input.Close)
end

function t._Setup(arg6) -- line: 121
    arg6._reward_value_template.Parent = nil
end

function t._Init(arg7) -- line: 125
    -- upvalues:
    --  [1] ButtonEffect_m (copy)

    arg7.CloseButton.MouseButton1Click:Connect(function() -- line: 126
        -- upvalues:
        --  [1] arg7 (copy)

        arg7:CloseRequest()
    end)
    arg7.ConfirmButton.MouseButton1Click:Connect(function() -- line: 130
        -- upvalues:
        --  [1] arg7 (copy)

        arg7:Confirm()
    end)
    arg7.Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() -- line: 134
        -- upvalues:
        --  [1] arg7 (copy)

        arg7.List.CanvasSize = UDim2.new(0, 0, 0, arg7.Layout.AbsoluteContentSize.Y)
    end)
    arg7.RecipientAddInputAddButton.MouseButton1Click:Connect(function() -- line: 138
        -- upvalues:
        --  [1] arg7 (copy)

        arg7:_AddRewardValueFrame(nil)
    end)
    arg7.RecipientAddInputAddNetButton.MouseButton1Click:Connect(function() -- line: 142
        -- upvalues:
        --  [1] arg7 (copy)

        arg7:_AddRewardValueFrame({ Name = "Net", Quantity = 1, Weapon = "IsRandom" })
    end)
    arg7.RecipientAddInputAddBugNetButton.MouseButton1Click:Connect(function() -- line: 146
        -- upvalues:
        --  [1] arg7 (copy)

        arg7:_AddRewardValueFrame({ Name = "Bug Net", Quantity = 1, Weapon = "Scythe" })
    end)
    arg7:_Setup()
    ButtonEffect_m:Add(arg7.CloseButton)
    ButtonEffect_m:Add(arg7.ConfirmButton)
    ButtonEffect_m:Add(arg7.RecipientAddInputAddButton)
    ButtonEffect_m:Add(arg7.RecipientAddInputAddNetButton)
    ButtonEffect_m:Add(arg7.RecipientAddInputAddBugNetButton)
end

return t
