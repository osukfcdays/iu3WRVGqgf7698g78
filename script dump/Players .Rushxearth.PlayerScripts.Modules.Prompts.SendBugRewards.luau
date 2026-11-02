local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local ServerOsTime_m = require(ReplicatedStorage.Modules.ServerOsTime)
local DebugLibrary_m = require(ReplicatedStorage.Modules.DebugLibrary)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local PlayerDataController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("PlayerDataController")
)
local ButtonEffect_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("ButtonEffect")
)
local RewardSlot_m = require(Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("RewardSlot"))
local Prompt_m = require(Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("Prompt"))
local t = setmetatable({}, Prompt_m)
t.__index = t

function t.new() -- line: 15
    -- upvalues:
    --  [1] Prompt_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(Prompt_m.new(script.Name), t)
    t_1.CloseButton = t_1.PromptFrame:WaitForChild("Close")
    t_1.ConfirmButton = t_1.PromptFrame:WaitForChild("Confirm")
    t_1.BudgetText = t_1.PromptFrame:WaitForChild("Budget")
    t_1.BudgetTimerText = t_1.PromptFrame:WaitForChild("BudgetTimer")
    t_1.HeaderFrame = t_1.PromptFrame:WaitForChild("Header")
    t_1.HeaderWrapFrame = t_1.HeaderFrame:WaitForChild("Wrap")
    t_1.HeaderSkinFrame = t_1.HeaderFrame:WaitForChild("Skin")
    t_1.List = t_1.PromptFrame:WaitForChild("List")
    t_1.Container = t_1.List:WaitForChild("Container")
    t_1.Layout = t_1.Container:WaitForChild("Layout")
    t_1.RecipientAddButton = t_1.Container:WaitForChild("RewardAdd"):WaitForChild("Add")
    t_1._reward_value_template = t_1.Container:WaitForChild("BugRewardRecepientSlot")
    t_1._reward_value_frames = {}
    t_1:_Init()

    return t_1
end

function t.Confirm(arg1) -- line: 42
    -- upvalues:
    --  [1] Utility_m (copy)
    --  [2] ReplicatedStorage (copy)

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

    local Success, Result = pcall(
        ReplicatedStorage.Remotes.Debug.Command.InvokeServer,
        ReplicatedStorage.Remotes.Debug.Command,
        "SendBugRewards",
        arg1:_GetBatch(true)
    )

    if not Success or not Result then
        warn("Failed to send rewards:", Result)
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

function t._GetBatch(arg2, arg3) -- line: 63
    -- upvalues:
    --  [1] Utility_m (copy)

    local t_2 = {}

    for _, val in pairs(arg2._reward_value_frames) do
        local Text = val.Player.Box.Text

        if Text == "" and arg3 then
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

        table.insert(
            t_2,
            { Text, tonumber(val.Wraps.Box.Text) or 0, tonumber(val.Skins.Box.Text) or 0 }
        )
    end

    return t_2
end

function t._UpdateBudgetText(arg4) -- line: 83
    -- upvalues:
    --  [1] PlayerDataController_m (copy)
    --  [2] ServerOsTime_m (copy)
    --  [3] DebugLibrary_m (copy)
    --  [4] Utility_m (copy)

    local v7 = 0
    local v8 = 0

    for _, val_1 in pairs(arg4:_GetBatch()) do
        v7 += val_1[2]
        v8 += val_1[3]
    end

    local v10 = PlayerDataController_m:Get("SendBugRewardsCooldown")

    if v10 then
        v10 = ServerOsTime_m:Get() < PlayerDataController_m:Get("SendBugRewardsCooldown") and true
    end

    arg4.BudgetText.Text = string.format(
        "\195\151%s Net Wraps   \195\151%s Bug Net Skins",
        if v10 then 0 else math.max(0, DebugLibrary_m.MAX_NET_WRAPS_PER_CYCLE - v7),
        if v10 then 0 else math.max(0, DebugLibrary_m.MAX_BUG_NET_SKINS_PER_CYCLE - v8)
    )
    local BudgetText_1 = arg4.BudgetText
    BudgetText_1.TextColor3 = if v10 then Color3.fromRGB(255, 50, 50) else if v7 > DebugLibrary_m.MAX_NET_WRAPS_PER_CYCLE then Color3.fromRGB(
        255,
        50,
        50
    ) else if not (v8 > DebugLibrary_m.MAX_BUG_NET_SKINS_PER_CYCLE) then Color3.fromRGB(
        255,
        255,
        255
    ) else Color3.fromRGB(255, 50, 50)
    local BudgetTimerText = arg4.BudgetTimerText
    BudgetTimerText.Text = if v10 then string.format(
        "Budget refreshes in %s",
        Utility_m:TimeFormat2(
            (math.ceil(PlayerDataController_m:Get("SendBugRewardsCooldown") - ServerOsTime_m:Get()))
        )
    ) else "Bug rewards ready to be handed out!"
end

function t._UpdateBudgetTextLoop(arg5) -- line: 99
    while true do
        if arg5._destroyed then
            break
        end

        arg5:_UpdateBudgetText()
        wait(1)
    end
end

function t._AddRewardValueFrame(arg6) -- line: 106
    -- upvalues:
    --  [1] ButtonEffect_m (copy)
    --  [2] DebugLibrary_m (copy)

    local v17 = arg6._reward_value_template:Clone()
    v17.Wraps.Box.Text = "1"
    v17.LayoutOrder = arg6._reward_value_template.LayoutOrder + #arg6._reward_value_frames
    v17.Close.Visible = #arg6._reward_value_frames > 0 and true
    v17.Parent = arg6.Container
    table.insert(arg6._reward_value_frames, v17)
    ButtonEffect_m:Add(v17.Close)
    v17.Close.MouseButton1Click:Connect(function() -- line: 115
        -- upvalues:
        --  [1] v17 (copy)
        --  [2] arg6 (copy)

        v17:Destroy()
        local index = table.find(arg6._reward_value_frames, v17)

        if index then
            table.remove(arg6._reward_value_frames, index)
            arg6:_UpdateBudgetText()
        end
    end)

    local function update() -- line: 126
        -- upvalues:
        --  [1] v17 (copy)
        --  [2] DebugLibrary_m (ref)
        --  [3] arg6 (copy)

        local Box = v17.Wraps.Box
        Box.Text = if v17.Wraps.Box.Text == "" then "" else math.clamp(
            math.floor(tonumber(v17.Wraps.Box.Text) or 0),
            0,
            DebugLibrary_m.MAX_NET_WRAPS_PER_PLAYER
        )
        local Box_1 = v17.Skins.Box
        Box_1.Text = if v17.Skins.Box.Text == "" then "" else math.clamp(
            math.floor(tonumber(v17.Skins.Box.Text) or 0),
            0,
            DebugLibrary_m.MAX_BUG_NET_SKINS_PER_PLAYER
        )
        arg6:_UpdateBudgetText()
    end

    v17.Wraps.Box:GetPropertyChangedSignal("Text"):Connect(update)
    v17.Skins.Box:GetPropertyChangedSignal("Text"):Connect(update)
    update()
    arg6:_UpdateBudgetText()
end

function t._Setup(arg7) -- line: 139
    -- upvalues:
    --  [1] RewardSlot_m (copy)

    RewardSlot_m.new({ Name = "Net", Quantity = 1, Weapon = "IsRandom" }):SetParent(
        arg7.HeaderWrapFrame
    )
    RewardSlot_m.new({ Name = "Bug Net", Quantity = 1, Weapon = "Scythe" }):SetParent(
        arg7.HeaderSkinFrame
    )
    arg7._reward_value_template.Parent = nil
end

function t._Init(arg8) -- line: 145
    -- upvalues:
    --  [1] ButtonEffect_m (copy)

    arg8.CloseButton.MouseButton1Click:Connect(function() -- line: 146
        -- upvalues:
        --  [1] arg8 (copy)

        arg8:CloseRequest()
    end)
    arg8.ConfirmButton.MouseButton1Click:Connect(function() -- line: 150
        -- upvalues:
        --  [1] arg8 (copy)

        arg8:Confirm()
    end)
    arg8.Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() -- line: 154
        -- upvalues:
        --  [1] arg8 (copy)

        arg8.List.CanvasSize = UDim2.new(0, 0, 0, arg8.Layout.AbsoluteContentSize.Y)
    end)
    arg8.RecipientAddButton.MouseButton1Click:Connect(function() -- line: 158
        -- upvalues:
        --  [1] arg8 (copy)

        arg8:_AddRewardValueFrame(nil)
    end)
    arg8:_Setup()
    arg8:_UpdateBudgetText()
    arg8:_AddRewardValueFrame()
    task.spawn(arg8._UpdateBudgetTextLoop, arg8)
    ButtonEffect_m:Add(arg8.CloseButton)
    ButtonEffect_m:Add(arg8.ConfirmButton)
    ButtonEffect_m:Add(arg8.RecipientAddButton)
end

return t
