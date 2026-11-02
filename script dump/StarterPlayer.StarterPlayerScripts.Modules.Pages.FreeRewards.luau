local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GroupService = game:GetService("GroupService")
local Players = game:GetService("Players")
local CONSTANTS_m = require(ReplicatedStorage.Modules.CONSTANTS)
local PlayerDataController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("PlayerDataController")
)
local BaseContractSlot_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("BaseContractSlot")
)
local PromptSystem_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("PromptSystem")
)
local ButtonEffect_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("ButtonEffect")
)
local Page_m = require(Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("Page"))
local t = setmetatable({}, Page_m)
t.__index = t

function t._new() -- line: 17
    -- upvalues:
    --  [1] Page_m (copy)
    --  [2] t (copy)
    --  [3] PromptSystem_m (copy)
    --  [4] BaseContractSlot_m (copy)

    local t_1 = setmetatable(Page_m.new(script.Name), t)
    t_1.CloseButton = t_1.PageFrame:WaitForChild("Close")
    t_1.PromptsFrame = t_1.PageFrame:WaitForChild("Prompts")
    t_1.Container = t_1.PageFrame:WaitForChild("Container")
    t_1.VerifyButton = t_1.Container:WaitForChild("Verify")
    t_1.VerifyButtonReadyFrame = t_1.VerifyButton:WaitForChild("Ready")
    t_1.VerifyButtonCountdownFrame = t_1.VerifyButton:WaitForChild("Countdown")
    t_1.VerifyButtonCountdownText = t_1.VerifyButtonCountdownFrame:WaitForChild("Title")
    t_1.PromptSystem = PromptSystem_m.new(t_1.PromptsFrame)
    t_1._verify_countdown_hash = 0
    t_1._contract_slot = BaseContractSlot_m.new()
    t_1:_Init()

    return t_1
end

function t._UpdateClaimed(arg1) -- line: 48
    -- upvalues:
    --  [1] PlayerDataController_m (copy)

    local v7 = PlayerDataController_m:Get("ClaimedGroupReward")
    arg1.VerifyButton.Visible = not v7
    arg1._contract_slot:SetProgress(if v7 then 2 else 0)
end

function t._Countdown(arg2) -- line: 55
    arg2._verify_countdown_hash += 1
    local VerifyCountdownHash = arg2._verify_countdown_hash
    arg2.VerifyButtonCountdownFrame.Visible = true
    arg2.VerifyButtonReadyFrame.Visible = false
    task.spawn(function() -- line: 62
        -- upvalues:
        --  [1] arg2 (copy)
        --  [2] VerifyCountdownHash (copy)

        for index = 15, 1, -1 do
            arg2.VerifyButtonCountdownText.Text = index
            wait(1)

            if VerifyCountdownHash ~= arg2._verify_countdown_hash then
                return
            end
        end

        arg2.VerifyButtonCountdownFrame.Visible = false
        arg2.VerifyButtonReadyFrame.Visible = true
    end)
end

function t._Setup(arg3) -- line: 78
    arg3._contract_slot:SetTitle("Free Rewards")
    arg3._contract_slot:SetImage("rbxassetid://84811629597038", UDim2.new(1.25, 0, 1, 0))
    arg3._contract_slot:SetScale(1.25)
    arg3._contract_slot:SetRequiresPreviousMilestoneCompleted(false)
    arg3._contract_slot:SetDescription(
        "Like the game (RIVALS) \240\159\145\141 and join the group (Nosniy Games) \240\159\146\156 to claim!"
    )
    arg3._contract_slot:AddMilestone(2, { Name = "RIVALS", Weapon = "IsUniversal" })
    arg3._contract_slot:AddMilestone(2, { Name = "Nosniy Games", Weapon = "IsUniversal" })
    arg3._contract_slot:AddMilestone(2, { Name = "Key", Quantity = 3 })
    arg3._contract_slot.Frame.Parent = arg3.Container
end

function t._Init(arg4) -- line: 90
    -- upvalues:
    --  [1] GroupService (copy)
    --  [2] CONSTANTS_m (copy)
    --  [3] ReplicatedStorage (copy)
    --  [4] PlayerDataController_m (copy)
    --  [5] ButtonEffect_m (copy)

    arg4.CloseButton.MouseButton1Click:Connect(function() -- line: 91
        -- upvalues:
        --  [1] arg4 (copy)

        arg4:CloseRequest()
    end)
    arg4.VerifyButton.MouseButton1Click:Connect(function() -- line: 95
        -- upvalues:
        --  [1] arg4 (copy)
        --  [2] GroupService (ref)
        --  [3] CONSTANTS_m (ref)
        --  [4] ReplicatedStorage (ref)

        if not arg4.VerifyButtonReadyFrame.Visible then
            return
        end

        arg4:_Countdown()
        local Success, Result = pcall(
            GroupService.PromptJoinAsync,
            GroupService,
            CONSTANTS_m.GROUP_ID
        )

        if not Success then
            warn("Failed to prompt group join, error:", Result)
        end

        if ReplicatedStorage.Remotes.Data.ClaimGroupReward:InvokeServer() then
            ReplicatedStorage.Remotes.Data.ClaimLikeReward:FireServer()

            return
        end

        arg4.PromptSystem:Open(
            "ErrorMessage",
            "Whoops!",
            "Failed to verify, make sure to like the game AND join the group!"
        )
    end)
    PlayerDataController_m:GetDataChangedSignal("ClaimedGroupReward"):Connect(function() -- line: 117
        -- upvalues:
        --  [1] arg4 (copy)

        arg4:_UpdateClaimed()
    end)
    arg4:_Setup()
    arg4:_UpdateClaimed()
    ButtonEffect_m:Add(arg4.CloseButton)
    ButtonEffect_m:Add(arg4.VerifyButton)
end

return t._new()
