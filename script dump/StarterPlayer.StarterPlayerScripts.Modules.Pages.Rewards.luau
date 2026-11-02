local ExperienceNotificationService = game:GetService("ExperienceNotificationService")
local AvatarEditorService = game:GetService("AvatarEditorService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local _ = game:GetService("SocialService")
local GroupService = game:GetService("GroupService")
local Players = game:GetService("Players")
local CONSTANTS_m = require(ReplicatedStorage.Modules.CONSTANTS)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local PlayerDataController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("PlayerDataController")
)
local ComplianceController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("ComplianceController")
)
local SocialController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("SocialController")
)
local PromptSystem_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("PromptSystem")
)
local ButtonEffect_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("ButtonEffect")
)
local RewardSlot_m = require(Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("RewardSlot"))
local Page_m = require(Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("Page"))
local t = { HoverRatio = 1.05, ReleaseRatio = 1.05 }
local t_1 = setmetatable({}, Page_m)
t_1.__index = t_1

function t_1._new() -- line: 24
    -- upvalues:
    --  [1] Page_m (copy)
    --  [2] t_1 (copy)
    --  [3] PromptSystem_m (copy)

    local t_2 = setmetatable(Page_m.new(script.Name), t_1)
    t_2.CloseButton = t_2.PageFrame:WaitForChild("Close")
    t_2.PromptsFrame = t_2.PageFrame:WaitForChild("Prompts")
    t_2.List = t_2.PageFrame:WaitForChild("List")
    t_2.Container = t_2.List:WaitForChild("Container")
    t_2.Layout = t_2.Container:WaitForChild("Layout")
    t_2.InviteFrame = t_2.Container:WaitForChild("Invite")
    t_2.InviteRewardFrame = t_2.InviteFrame:WaitForChild("Reward")
    t_2.InviteRewardButton = t_2.InviteFrame:WaitForChild("Button")
    t_2.FavoriteFrame = t_2.Container:WaitForChild("Favorite")
    t_2.FavoriteRewardClaimed = t_2.FavoriteFrame:WaitForChild("Claimed")
    t_2.FavoriteRewardFrame = t_2.FavoriteFrame:WaitForChild("Reward")
    t_2.FavoriteRewardButton = t_2.FavoriteFrame:WaitForChild("Button")
    t_2.NotificationsFrame = t_2.Container:WaitForChild("Notifications")
    t_2.NotificationsRewardClaimed = t_2.NotificationsFrame:WaitForChild("Claimed")
    t_2.NotificationsRewardFrame = t_2.NotificationsFrame:WaitForChild("Reward")
    t_2.NotificationsRewardButton = t_2.NotificationsFrame:WaitForChild("Button")
    t_2.LikeFrame = t_2.Container:WaitForChild("Like")
    t_2.LikeRewardFrame = t_2.LikeFrame:WaitForChild("Reward")
    t_2.LikeRewardClaimed = t_2.LikeFrame:WaitForChild("Claimed")
    t_2.LikeRewardButton = t_2.LikeFrame:WaitForChild("Button")
    t_2.LikeRewardReadyFrame = t_2.LikeRewardButton:WaitForChild("Ready")
    t_2.LikeRewardCountdownFrame = t_2.LikeRewardButton:WaitForChild("Countdown")
    t_2.LikeRewardCountdownText = t_2.LikeRewardCountdownFrame:WaitForChild("Title")
    t_2.GroupFrame = t_2.Container:WaitForChild("Group")
    t_2.GroupRewardFrame = t_2.GroupFrame:WaitForChild("Reward")
    t_2.GroupRewardClaimed = t_2.GroupFrame:WaitForChild("Claimed")
    t_2.GroupRewardButton = t_2.GroupFrame:WaitForChild("Button")
    t_2.GroupRewardReadyFrame = t_2.GroupRewardButton:WaitForChild("Ready")
    t_2.GroupRewardCountdownFrame = t_2.GroupRewardButton:WaitForChild("Countdown")
    t_2.GroupRewardJoinFrame = t_2.GroupRewardButton:WaitForChild("Join")
    t_2.GroupRewardCountdownText = t_2.GroupRewardCountdownFrame:WaitForChild("Title")
    t_2.CodesFrame = t_2.Container:WaitForChild("Codes")
    t_2.CodesVerifiedFrame = t_2.CodesFrame:WaitForChild("Verified")
    t_2.CodesVerifiedInputFrame = t_2.CodesVerifiedFrame:WaitForChild("Input")
    t_2.CodesVerifiedBox = t_2.CodesVerifiedInputFrame:WaitForChild("Box")
    t_2.CodesVerifiedButton = t_2.CodesVerifiedInputFrame:WaitForChild("Button")
    t_2.CodesVerifiedButtonReadyFrame = t_2.CodesVerifiedButton:WaitForChild("Ready")
    t_2.CodesVerifiedButtonCountdownFrame = t_2.CodesVerifiedButton:WaitForChild("Countdown")
    t_2.CodesVerifiedButtonCountdownText = t_2.CodesVerifiedButtonCountdownFrame:WaitForChild(
        "Title"
    )
    t_2.CodesUnverifiedFrame = t_2.CodesFrame:WaitForChild("Unverified")
    t_2.CodesUnverifiedButton = t_2.CodesUnverifiedFrame:WaitForChild("Input"):WaitForChild(
        "Button"
    )
    t_2.CodesUnverifiedButtonReadyFrame = t_2.CodesUnverifiedButton:WaitForChild("Ready")
    t_2.CodesUnverifiedButtonCountdownFrame = t_2.CodesUnverifiedButton:WaitForChild("Countdown")
    t_2.CodesUnverifiedButtonCountdownText = t_2.CodesUnverifiedButtonCountdownFrame:WaitForChild(
        "Title"
    )
    t_2.PromptSystem = PromptSystem_m.new(t_2.PromptsFrame)
    t_2._open_animation_disabled = true
    t_2._group_reward_countdown_hash = 0
    t_2._like_reward_countdown_hash = 0
    t_2._codes_verify_countdown_hash = 0
    t_2._window_focus_connection = nil
    t_2._is_enabling_notifications = false
    t_2._is_favoriting = false
    t_2._can_verify = false
    t_2._previous_verified_status = nil
    t_2._redirect_on_close = nil
    t_2:_Init()

    return t_2
end

function t_1.CloseRequest(arg1) -- line: 94
    -- upvalues:
    --  [1] PlayerDataController_m (copy)
    --  [2] Page_m (copy)

    local StatisticDuelsPlayed = PlayerDataController_m:GetStatistic("StatisticDuelsPlayed")
    local StatisticDuelsWon = PlayerDataController_m:GetStatistic("StatisticDuelsWon")

    if StatisticDuelsPlayed >= 5 and StatisticDuelsWon < 10 then
        Page_m.CloseRequest(arg1)

        return
    end

    arg1.OpenPage:Fire("Shop", true)
end

function t_1._UpdateCodesVerified(arg2) -- line: 109
    -- upvalues:
    --  [1] PlayerDataController_m (copy)
    --  [2] Utility_m (copy)

    local v9 = PlayerDataController_m:Get("CodesVerified")

    if arg2._previous_verified_status == false and v9 then
        Utility_m:CreateSound(
            "rbxassetid://7715210658",
            1,
            1,
            script,
            true,
            5
        )
    end

    arg2._previous_verified_status = v9
    arg2.CodesVerifiedFrame.Visible = v9
    arg2.CodesUnverifiedFrame.Visible = not v9
end

function t_1._CountdownCodesVerify(arg3) -- line: 121
    arg3._codes_verify_countdown_hash += 1
    local CodesVerifyCountdownHash = arg3._codes_verify_countdown_hash
    arg3.CodesUnverifiedButtonCountdownFrame.Visible = true
    arg3.CodesUnverifiedButtonReadyFrame.Visible = false
    task.spawn(function() -- line: 128
        -- upvalues:
        --  [1] arg3 (copy)
        --  [2] CodesVerifyCountdownHash (copy)

        for index = 15, 1, -1 do
            arg3.CodesUnverifiedButtonCountdownText.Text = index
            wait(1)

            if CodesVerifyCountdownHash ~= arg3._codes_verify_countdown_hash then
                return
            end
        end

        arg3.CodesUnverifiedButtonCountdownFrame.Visible = false
        arg3.CodesUnverifiedButtonReadyFrame.Visible = true
    end)
end

function t_1._UpdateNotificationsReward(arg4) -- line: 144
    -- upvalues:
    --  [1] PlayerDataController_m (copy)

    local v10 = PlayerDataController_m:Get("ClaimedNotificationsReward")
    arg4.NotificationsRewardClaimed.Visible = v10
    arg4.NotificationsRewardButton.Visible = not v10
end

function t_1._UpdateFavoriteReward(arg5) -- line: 151
    -- upvalues:
    --  [1] PlayerDataController_m (copy)

    local v11 = PlayerDataController_m:Get("ClaimedFavoriteReward")
    arg5.FavoriteRewardClaimed.Visible = v11
    arg5.FavoriteRewardButton.Visible = not v11
end

function t_1._UpdateLikeReward(arg6) -- line: 158
    -- upvalues:
    --  [1] PlayerDataController_m (copy)

    local v12 = PlayerDataController_m:Get("ClaimedLikeReward")
    arg6.LikeRewardClaimed.Visible = v12
    arg6.LikeRewardButton.Visible = not v12

    if v12 then
        arg6._like_reward_countdown_hash += 1
    end
end

function t_1._CountdownLikeReward(arg7) -- line: 169
    arg7._like_reward_countdown_hash += 1
    local LikeRewardCountdownHash = arg7._like_reward_countdown_hash
    arg7.LikeRewardCountdownFrame.Visible = true
    arg7.LikeRewardReadyFrame.Visible = false
    task.spawn(function() -- line: 176
        -- upvalues:
        --  [1] arg7 (copy)
        --  [2] LikeRewardCountdownHash (copy)

        for index_1 = 20, 1, -1 do
            arg7.LikeRewardCountdownText.Text = index_1
            wait(1)

            if LikeRewardCountdownHash ~= arg7._like_reward_countdown_hash then
                return
            end
        end

        arg7.LikeRewardCountdownFrame.Visible = false
        arg7.LikeRewardReadyFrame.Visible = true
    end)
end

function t_1._UpdateGroupReward(arg8) -- line: 192
    -- upvalues:
    --  [1] PlayerDataController_m (copy)

    local v13 = PlayerDataController_m:Get("ClaimedGroupReward")
    arg8.GroupRewardClaimed.Visible = v13
    arg8.GroupRewardButton.Visible = not v13

    if v13 then
        arg8._group_reward_countdown_hash += 1
    end
end

function t_1._CountdownGroupReward(arg9) -- line: 203
    arg9._group_reward_countdown_hash += 1
    local GroupRewardCountdownHash = arg9._group_reward_countdown_hash
    arg9.GroupRewardCountdownFrame.Visible = true
    arg9.GroupRewardReadyFrame.Visible = false
    task.spawn(function() -- line: 210
        -- upvalues:
        --  [1] arg9 (copy)
        --  [2] GroupRewardCountdownHash (copy)

        for index_2 = 60, 1, -1 do
            arg9.GroupRewardCountdownText.Text = index_2
            wait(1)

            if GroupRewardCountdownHash ~= arg9._group_reward_countdown_hash then
                return
            end
        end

        arg9.GroupRewardCountdownFrame.Visible = false
        arg9.GroupRewardReadyFrame.Visible = true
    end)
end

function t_1._UpdateInviteFrame(arg10) -- line: 226
    -- upvalues:
    --  [1] SocialController_m (copy)

    arg10.InviteFrame.Visible = SocialController_m.CanSendGameInvite
end

function t_1._Setup(arg11) -- line: 230
    -- upvalues:
    --  [1] ComplianceController_m (copy)
    --  [2] RewardSlot_m (copy)
    --  [3] ExperienceNotificationService (copy)

    for _, val in pairs({ "Group", "Nosniy", "SenseiWarrior" }) do
        local v14 = arg11.CodesFrame:WaitForChild(val)

        for _, val_1 in pairs({ "X", "Discord", "YouTube" }) do
            local v15 = v14:WaitForChild("Details"):FindFirstChild(val_1)

            if v15 then
                v15.Visible = ComplianceController_m:IsExternalReferencesAllowed(val_1)
            end
        end
    end

    RewardSlot_m.new({ Name = "Cream", Weapon = "IsRandom" }):SetParent(arg11.InviteRewardFrame)
    RewardSlot_m.new({ Name = "Shooting Star", Weapon = "IsUniversal" }):SetParent(
        arg11.FavoriteRewardFrame
    )
    RewardSlot_m.new({ Name = "Bell", Weapon = "IsUniversal" }):SetParent(
        arg11.NotificationsRewardFrame
    )
    RewardSlot_m.new({ Name = "Nosniy Games", Weapon = "IsUniversal" }):SetParent(
        arg11.GroupRewardFrame
    )
    RewardSlot_m.new({ Name = "RIVALS", Weapon = "IsUniversal" }):SetParent(arg11.LikeRewardFrame)
    local v21 = RewardSlot_m.new({ Name = "Key", Quantity = 3 })
    v21:SetParent(arg11.LikeRewardFrame)
    v21.Frame.Position = UDim2.new(-0.5, 0, 0.5, 0)
    task.spawn(function() -- line: 255
        -- upvalues:
        --  [1] arg11 (copy)
        --  [2] ExperienceNotificationService (ref)

        arg11.NotificationsFrame.Visible = false
        local Success, Result = pcall(
            ExperienceNotificationService.CanPromptOptInAsync,
            ExperienceNotificationService
        )
        arg11.NotificationsFrame.Visible = Success and Result
    end)
end

function t_1._Init(arg12) -- line: 262
    -- upvalues:
    --  [1] GroupService (copy)
    --  [2] CONSTANTS_m (copy)
    --  [3] ReplicatedStorage (copy)
    --  [4] AvatarEditorService (copy)
    --  [5] SocialController_m (copy)
    --  [6] ExperienceNotificationService (copy)
    --  [7] UserInputService (copy)
    --  [8] PlayerDataController_m (copy)
    --  [9] ButtonEffect_m (copy)
    --  [10] t (copy)

    arg12.Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() -- line: 263
        -- upvalues:
        --  [1] arg12 (copy)

        arg12.List.CanvasSize = UDim2.new(0, 0, 0, arg12.Layout.AbsoluteContentSize.Y)
    end)
    arg12.CloseButton.MouseButton1Click:Connect(function() -- line: 267
        -- upvalues:
        --  [1] arg12 (copy)

        arg12:CloseRequest()
    end)
    arg12.GroupRewardButton.MouseButton1Click:Connect(function() -- line: 271
        -- upvalues:
        --  [1] arg12 (copy)
        --  [2] GroupService (ref)
        --  [3] CONSTANTS_m (ref)
        --  [4] ReplicatedStorage (ref)

        if arg12.GroupRewardJoinFrame.Visible then
            arg12.GroupRewardJoinFrame.Visible = false
            arg12.GroupRewardReadyFrame.Visible = true
            local Success_1, Result_1 = pcall(
                GroupService.PromptJoinAsync,
                GroupService,
                CONSTANTS_m.GROUP_ID
            )

            if not Success_1 then
                arg12.PromptSystem:Open(
                    "ErrorMessage",
                    "Whoops!",
                    "Failed to join, please try again another time!"
                )
                warn("Failed to prompt group join, error:", Result_1)

                return
            end
        elseif arg12.GroupRewardReadyFrame.Visible then
            arg12:_CountdownGroupReward()

            if not ReplicatedStorage.Remotes.Data.ClaimGroupReward:InvokeServer() then
                arg12.PromptSystem:Open(
                    "ErrorMessage",
                    "Whoops!",
                    "Failed to verify, join the group before claiming your reward!"
                )
            end
        end
    end)
    arg12.LikeRewardButton.MouseButton1Click:Connect(function() -- line: 293
        -- upvalues:
        --  [1] arg12 (copy)
        --  [2] ReplicatedStorage (ref)

        if arg12.LikeRewardReadyFrame.Visible then
            if arg12._window_focus_connection then
                arg12._window_focus_connection:Disconnect()
                arg12._window_focus_connection = nil
                arg12.PromptSystem:Open(
                    "ErrorMessage",
                    "Whoops!",
                    "Failed to verify, like the game before claiming your reward!"
                )
                arg12:_CountdownLikeReward()

                return
            end

            ReplicatedStorage.Remotes.Data.ClaimLikeReward:FireServer()
        end
    end)
    arg12.FavoriteRewardButton.MouseButton1Click:Connect(function() -- line: 307
        -- upvalues:
        --  [1] AvatarEditorService (ref)
        --  [2] CONSTANTS_m (ref)
        --  [3] arg12 (copy)
        --  [4] ReplicatedStorage (ref)

        AvatarEditorService:PromptSetFavorite(
            CONSTANTS_m.HUB_PLACE_ID,
            Enum.AvatarItemType.Asset,
            true
        )

        if not arg12._is_favoriting then
            arg12._is_favoriting = true
            wait(10)
            ReplicatedStorage.Remotes.Data.ClaimFavoriteReward:FireServer()
        end
    end)
    arg12.InviteRewardButton.MouseButton1Click:Connect(function() -- line: 319
        -- upvalues:
        --  [1] SocialController_m (ref)

        SocialController_m:PromptFriendInvite()
    end)
    arg12.NotificationsRewardButton.MouseButton1Click:Connect(function() -- line: 323
        -- upvalues:
        --  [1] ExperienceNotificationService (ref)
        --  [2] arg12 (copy)
        --  [3] ReplicatedStorage (ref)

        ExperienceNotificationService:PromptOptIn()

        if not arg12._is_enabling_notifications then
            arg12._is_enabling_notifications = true
            wait(10)
            ReplicatedStorage.Remotes.Data.ClaimNotificationsReward:FireServer()
        end
    end)
    arg12.CodesUnverifiedButton.MouseButton1Click:Connect(function() -- line: 335
        -- upvalues:
        --  [1] arg12 (copy)
        --  [2] ReplicatedStorage (ref)

        if not arg12.CodesUnverifiedButtonReadyFrame.Visible then
            return
        end

        if not arg12._can_verify then
            arg12._can_verify = true
            arg12.PromptSystem:Open(
                "ErrorMessage",
                "Whoops!",
                "Failed to verify, follow the developers before verifying!"
            )
            arg12:_CountdownCodesVerify()

            return
        end

        ReplicatedStorage.Remotes.Data.VerifyCodes:FireServer()
    end)
    arg12.CodesVerifiedButton.MouseButton1Click:Connect(function() -- line: 349
        -- upvalues:
        --  [1] ReplicatedStorage (ref)
        --  [2] arg12 (copy)

        local v23 = ReplicatedStorage.Remotes.Data.RedeemCode:InvokeServer(
            string.lower(arg12.CodesVerifiedBox.Text)
        ) or "Something went wrong"

        if v23 ~= "Success" then
            arg12.PromptSystem:Open("ErrorMessage", "Whoops!", "Failed to redeem code: " .. v23)
        end
    end)
    arg12._window_focus_connection = UserInputService.WindowFocusReleased:Connect(function() -- line: 357
        -- upvalues:
        --  [1] arg12 (copy)

        arg12._window_focus_connection:Disconnect()
        arg12._window_focus_connection = nil
    end)
    PlayerDataController_m:GetDataChangedSignal("ClaimedGroupReward"):Connect(function() -- line: 362
        -- upvalues:
        --  [1] arg12 (copy)

        arg12:_UpdateGroupReward()
    end)
    PlayerDataController_m:GetDataChangedSignal("ClaimedLikeReward"):Connect(function() -- line: 366
        -- upvalues:
        --  [1] arg12 (copy)

        arg12:_UpdateLikeReward()
    end)
    PlayerDataController_m:GetDataChangedSignal("ClaimedFavoriteReward"):Connect(function() -- line: 370
        -- upvalues:
        --  [1] arg12 (copy)

        arg12:_UpdateFavoriteReward()
    end)
    PlayerDataController_m:GetDataChangedSignal("ClaimedNotificationsReward"):Connect(function() -- line: 374
        -- upvalues:
        --  [1] arg12 (copy)

        arg12:_UpdateNotificationsReward()
    end)
    PlayerDataController_m:GetDataChangedSignal("CodesVerified"):Connect(function() -- line: 378
        -- upvalues:
        --  [1] arg12 (copy)

        arg12:_UpdateCodesVerified()
    end)
    SocialController_m.CanSendGameInviteChanged:Connect(function() -- line: 382
        -- upvalues:
        --  [1] arg12 (copy)

        arg12:_UpdateInviteFrame()
    end)
    arg12:_Setup()
    arg12:_UpdateInviteFrame()
    arg12:_UpdateLikeReward()
    arg12:_UpdateGroupReward()
    arg12:_UpdateFavoriteReward()
    arg12:_UpdateNotificationsReward()
    arg12:_UpdateCodesVerified()
    ButtonEffect_m:Add(arg12.CloseButton)
    ButtonEffect_m:Add(arg12.InviteRewardButton, nil, t)
    ButtonEffect_m:Add(arg12.FavoriteRewardButton, nil, t)
    ButtonEffect_m:Add(arg12.NotificationsRewardButton, nil, t)
    ButtonEffect_m:Add(arg12.LikeRewardButton, nil, t)
    ButtonEffect_m:Add(arg12.GroupRewardButton, nil, t)
    ButtonEffect_m:Add(arg12.CodesVerifiedButton, nil, t)
    ButtonEffect_m:Add(arg12.CodesUnverifiedButton, nil, t)
end

return t_1._new()
