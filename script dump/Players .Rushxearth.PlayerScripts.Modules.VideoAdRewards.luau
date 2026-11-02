local ReplicatedStorage = game:GetService("ReplicatedStorage")
local AdService = game:GetService("AdService")
local Players = game:GetService("Players")
local MonetizationLibrary_m = require(ReplicatedStorage.Modules.MonetizationLibrary)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local Signal_m = require(ReplicatedStorage.Modules.Signal)
local PlayerDataController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.PlayerDataController
)
local ButtonEffect_m = require(Players.LocalPlayer.PlayerScripts.Modules.ButtonEffect)
local RewardSlot_m = require(Players.LocalPlayer.PlayerScripts.Modules.RewardSlot)
local VideoAdRewards = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild(
    "VideoAdRewards"
)
local VideoAdRewardSlot = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild(
    "VideoAdRewardSlot"
)
local t = {}
t.__index = t

function t.new(_) -- line: 19
    -- upvalues:
    --  [1] t (copy)
    --  [2] Signal_m (copy)
    --  [3] VideoAdRewards (copy)

    local t_1 = setmetatable({}, t)
    t_1.PlayedAd = Signal_m.new()
    t_1.AvailabilityChanged = Signal_m.new()
    t_1.Frame = VideoAdRewards:Clone()
    t_1.Container = t_1.Frame:WaitForChild("Container")
    t_1.Background = t_1.Container:WaitForChild("Background")
    t_1.WaitingFrame = t_1.Container:WaitForChild("Waiting")
    t_1.WaitingDotsFrame = t_1.WaitingFrame:WaitForChild("Dots")
    t_1.UnavailableFrame = t_1.Container:WaitForChild("Unavailable")
    t_1.UnavailableTitle = t_1.UnavailableFrame:WaitForChild("Title")
    t_1.UnavailableDescription = t_1.UnavailableFrame:WaitForChild("Description")
    t_1.UnavailableImage = t_1.UnavailableFrame:WaitForChild("ImageLabel")
    t_1.AvailableFrame = t_1.Container:WaitForChild("Available")
    t_1.AvailableTitle = t_1.AvailableFrame:WaitForChild("Title")
    t_1.AvailableDescription = t_1.AvailableFrame:WaitForChild("Description")
    t_1.RewardsFrame = t_1.AvailableFrame:WaitForChild("Rewards")
    t_1._connections = {}
    t_1._cleanup = {}
    t_1._update_hash = 0
    t_1._auto_update_task = nil
    t_1._buttons_position = nil
    t_1:_Init()

    return t_1
end

function t.IsAvailable(arg2) -- line: 54
    return arg2.AvailableFrame.Visible
end

function t.SetButtonsPositionY(arg3, arg4) -- line: 58
    arg3._buttons_position_y = arg4
end

function t.SetRewardsSize(arg5, arg6) -- line: 62
    arg5.RewardsFrame.Size = UDim2.new(0.9, 0, arg6, 0)
end

function t.SetBackgroundVisible(arg7, arg8) -- line: 66
    arg7.Background.Visible = arg8
end

function t.SetWhiteColor(arg9, arg10) -- line: 70
    arg9.AvailableTitle.TextColor3 = arg10
    arg9.AvailableDescription.TextColor3 = arg10
    arg9.UnavailableTitle.TextColor3 = arg10
    arg9.UnavailableDescription.TextColor3 = arg10
    arg9.UnavailableImage.ImageColor3 = arg10

    for _, child in pairs(arg9.WaitingDotsFrame:GetChildren()) do
        if child:IsA("ImageLabel") then
            child.ImageColor3 = arg10
        end
    end
end

function t.AutoUpdate(arg11, arg12) -- line: 84
    arg11._auto_update_task = task.spawn(function() -- line: 85
        -- upvalues:
        --  [1] arg11 (copy)
        --  [2] arg12 (copy)

        while true do
            arg11:Update()
            wait(arg12 or 60)
        end
    end)
end

function t.Update(arg13) -- line: 93
    task.spawn(arg13._Update, arg13)
end

function t.WeakUpdate(arg14) -- line: 97
    if arg14.AvailableFrame.Visible then
        return
    end

    arg14:Update()
end

function t.Destroy(arg15) -- line: 105
    for _, val in pairs(arg15._connections) do
        val:Disconnect()
    end

    if arg15._auto_update_task then
        task.cancel(arg15._auto_update_task)
    end

    arg15.AvailabilityChanged:Destroy()
    arg15.PlayedAd:Destroy()
end

function t._Update(arg16) -- line: 122
    -- upvalues:
    --  [1] AdService (copy)
    --  [2] MonetizationLibrary_m (copy)
    --  [3] PlayerDataController_m (copy)
    --  [4] Utility_m (copy)
    --  [5] VideoAdRewardSlot (copy)
    --  [6] RewardSlot_m (copy)
    --  [7] ReplicatedStorage (copy)
    --  [8] ButtonEffect_m (copy)

    for _, val_1 in pairs(arg16._cleanup) do
        val_1:Destroy()
    end

    arg16._cleanup = {}
    arg16._update_hash += 1
    local UpdateHash = arg16._update_hash
    arg16.WaitingFrame.Visible = true
    arg16.WaitingDotsFrame:AddTag("UILoadingDots")
    arg16.UnavailableFrame.Visible = false
    arg16.AvailableFrame.Visible = false
    local v2, v3 = pcall(
        AdService.GetAdAvailabilityNowAsync,
        AdService,
        Enum.AdFormat.RewardedVideo
    )

    if UpdateHash ~= arg16._update_hash then
        return
    end

    local v4 = v2 and v3.AdAvailabilityResult == Enum.AdAvailabilityResult.IsAvailable
    arg16.WaitingFrame.Visible = false
    arg16.WaitingDotsFrame:RemoveTag("UILoadingDots")
    arg16.UnavailableFrame.Visible = not v4
    arg16.AvailableFrame.Visible = v4

    if not v4 then
        return
    end

    v3 = 0

    for index = 1, #MonetizationLibrary_m.VideoAdRewards do
        v2 = PlayerDataController_m:Get("VideoAdRewardsClaimed") % #MonetizationLibrary_m.VideoAdRewards + index
        v4 = math.min(
            MonetizationLibrary_m.VIDEO_AD_REWARDS_MAX_SCALE_FACTOR,
            (math.ceil(
                (PlayerDataController_m:Get("VideoAdRewardsClaimed") + index) / #MonetizationLibrary_m.VideoAdRewards
            ))
        )
        local v6 = MonetizationLibrary_m.VideoAdRewards[(v2 - 1) % #MonetizationLibrary_m.VideoAdRewards + 1]
        v2 = if index ~= 1 then false else true

        if index > 1 then
            local v7 = arg16:_CreateArrow()
            v7.LayoutOrder = v3
            v7.Parent = arg16.RewardsFrame
            table.insert(arg16._cleanup, v7)
            v3 += 1
        end

        local t_2 = { v6.RewardDatas }

        if PlayerDataController_m:Get("VideoAdRewardsClaimed") + index <= #MonetizationLibrary_m.VideoAdRewards then
            table.insert(t_2, v6.PreRepetitionRewardDatas)
        end

        local v8 = 0

        for _, val_2 in pairs(t_2) do
            v8 += #val_2
        end

        local v9 = 0

        for _, val_3 in pairs(t_2) do
            for _, val_4 in pairs(val_3) do
                v9 += 1
                v3 += 1
                local v10 = Utility_m:CloneTable(val_4)
                v10.Quantity = (v10.Quantity or 1) * v4
                local v11 = VideoAdRewardSlot:Clone()
                v11.Button.Visible = if v9 ~= 1 then false else true
                v11.Button.Position = UDim2.new(v8 * 0.5, 0, arg16._buttons_position_y or 1.25, 0)
                v11.Button.Unlocked.Title.Text = string.format(
                    "%s <font size=\"8\">/ %s</font>",
                    PlayerDataController_m:Get("VideoAdsWatchedBeforeClaiming"),
                    v6.NumAdsRequired
                )
                v11.Button.Unlocked.Visible = v2
                v11.Button.Locked.Visible = not v2
                v11.LayoutOrder = v3
                v11.Parent = arg16.RewardsFrame
                table.insert(arg16._cleanup, v11)
                local v14 = RewardSlot_m.new(v10)
                v14:SetParent(v11)
                table.insert(arg16._cleanup, v14)

                local function update() -- line: 205
                    -- upvalues:
                    --  [1] v11 (copy)

                    v11.Button.Unlocked.Title.Position = UDim2.new(
                        0.5,
                        v11.Button.Unlocked.Title.Icon.AbsoluteSize.X * 0.4,
                        0.5,
                        0
                    )
                    v11.Button.Unlocked.Title.Icon.Position = UDim2.new(
                        0.5,
                        -v11.Button.Unlocked.Title.TextBounds.X / 2,
                        0.5,
                        0
                    )
                end

                v11.Button.Unlocked.Title.Icon:GetPropertyChangedSignal("AbsoluteSize"):Connect(
                    update
                )
                v11.Button.Unlocked.Title:GetPropertyChangedSignal("TextBounds"):Connect(update)
                update()

                if v2 then
                    v11.Button.MouseButton1Click:Connect(function() -- line: 215
                        -- upvalues:
                        --  [1] v2 (copy)
                        --  [2] arg16 (copy)
                        --  [3] ReplicatedStorage (ref)

                        if not v2 then
                            return
                        end

                        arg16.PlayedAd:Fire()
                        ReplicatedStorage.Remotes.Misc.PlayVideoAdShopOffer:FireServer()
                    end)
                    ButtonEffect_m:Add(v11.Button)
                end
            end
        end
    end
end

function t._CreateArrow(_) -- line: 232
    local ImageLabel = Instance.new("ImageLabel")
    ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
    ImageLabel.BackgroundTransparency = 1
    ImageLabel.Image = "rbxassetid://133426948634565"
    ImageLabel.SizeConstraint = Enum.SizeConstraint.RelativeYY
    ImageLabel.Size = UDim2.new(0.5, 0, 0.25, 0)
    ImageLabel.ScaleType = Enum.ScaleType.Fit

    return ImageLabel
end

function t._Init(arg18) -- line: 243
    -- upvalues:
    --  [1] PlayerDataController_m (copy)

    arg18.AvailableFrame:GetPropertyChangedSignal("Visible"):Connect(function() -- line: 244
        -- upvalues:
        --  [1] arg18 (copy)

        arg18.AvailabilityChanged:Fire()
    end)
    local Connections = arg18._connections
    local VideoAdRewardsClaimed = PlayerDataController_m:GetDataChangedSignal(
        "VideoAdRewardsClaimed"
    )
    table.insert(Connections, VideoAdRewardsClaimed:Connect(function() -- line: 248
        -- upvalues:
        --  [1] arg18 (copy)

        arg18:Update()
    end))
    local Connections_1 = arg18._connections
    local VideoAdsWatchedBeforeClaiming = PlayerDataController_m:GetDataChangedSignal(
        "VideoAdsWatchedBeforeClaiming"
    )
    table.insert(Connections_1, VideoAdsWatchedBeforeClaiming:Connect(function() -- line: 252
        -- upvalues:
        --  [1] arg18 (copy)

        arg18:Update()
    end))
end

return t
