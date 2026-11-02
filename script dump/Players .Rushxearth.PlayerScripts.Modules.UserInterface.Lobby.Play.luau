local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")
local CONSTANTS_m = require(ReplicatedStorage.Modules.CONSTANTS)
local _ = require(ReplicatedStorage.Modules.InputLibrary)
local MatchmakingController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("MatchmakingController")
)
local PlayerDataController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("PlayerDataController")
)
local _ = require(Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("FighterController"))
local ArcadeController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("ArcadeController")
)
local PartyController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("PartyController")
)
local Matchmaking_m = require(
    Players.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("Lobby"):WaitForChild(
        "Matchmaking"
    )
)
local MobileInputs_m = require(
    Players.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("MobileInputs")
)
local Teleporting_m = require(
    Players.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("Teleporting")
)
local Equipment_m = require(
    Players.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("Equipment")
)
local Queue_m = require(
    Players.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("Queue")
)
local Pages_m = require(
    Players.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("Pages")
)
local ButtonEffect_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("ButtonEffect")
)
local UILibrary_m = require(Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("UILibrary"))
local t = {}
t.__index = t

function t._new() -- line: 24
    -- upvalues:
    --  [1] t (copy)
    --  [2] UILibrary_m (copy)

    local t_1 = setmetatable({}, t)
    t_1.Frame = UILibrary_m:GetTo("MainFrame", "Lobby", "Play")
    t_1.HubButton = t_1.Frame:WaitForChild("Hub")
    t_1.PlayButton = t_1.Frame:WaitForChild("Play")
    t_1.PlayButtonOffFrame = t_1.PlayButton:WaitForChild("Off")
    t_1.PlayButtonOffJoinText = t_1.PlayButtonOffFrame:WaitForChild("Title")
    t_1.PlayButtonJoinFrame = t_1.PlayButton:WaitForChild("Join")
    t_1.PlayButtonJoinText = t_1.PlayButtonJoinFrame:WaitForChild("Title")
    t_1.PlayButtonJoinBubble = t_1.PlayButtonJoinFrame:WaitForChild("Bubble")
    t_1.PlayButtonJoinBubbleText = t_1.PlayButtonJoinBubble:WaitForChild("Title")
    t_1.PlayButtonJoinBubbleBackground = t_1.PlayButtonJoinBubble:WaitForChild("Background")
    t_1.RematchButton = t_1.Frame:WaitForChild("Rematch")
    t_1.RematchCountText = t_1.RematchButton:WaitForChild("Count")
    t_1.IsHubVisible = false
    t_1.IsPlayVisible = false
    t_1.IsRematchVisible = false
    t_1._bubble_effect = 0
    t_1:_Init()

    return t_1
end

function t.GoBackToHub(_) -- line: 55
    -- upvalues:
    --  [1] ReplicatedStorage (copy)

    ReplicatedStorage.Remotes.Matchmaking.BackToHub:FireServer()
end

function t.RematchRequest(_) -- line: 59
    -- upvalues:
    --  [1] ReplicatedStorage (copy)

    ReplicatedStorage.Remotes.Duels.Rematch:FireServer()
end

function t.OpenPlayPage(_) -- line: 63
    -- upvalues:
    --  [1] CONSTANTS_m (copy)
    --  [2] ArcadeController_m (copy)
    --  [3] PlayerDataController_m (copy)
    --  [4] PartyController_m (copy)
    --  [5] MatchmakingController_m (copy)
    --  [6] Pages_m (copy)

    if CONSTANTS_m.IS_ARCADE_SERVER or ArcadeController_m.CurrentDuel then
        ArcadeController_m:Join()

        return
    end

    if
        PlayerDataController_m:GetStatistic("StatisticDuelsPlayed") <= 1
        and PlayerDataController_m:GetStatistic("StatisticDuelsWon") < CONSTANTS_m.BEGINNER_QUEUE_WINS
        and not PartyController_m.CurrentParty
    then
        MatchmakingController_m:QueueInto(CONSTANTS_m.BEGINNER_QUEUE_NAME)

        return
    end

    Pages_m.PageSystem:OpenPage("Matchmaking", true)
end

function t._UpdateLayouts(arg4) -- line: 80
    arg4.PlayButtonJoinBubbleBackground.Size = UDim2.new(
        0,
        arg4.PlayButtonJoinBubbleText.TextBounds.X + arg4.PlayButtonJoinBubble.AbsoluteSize.Y,
        1,
        0
    )
end

function t._UpdateRematchButton(arg5) -- line: 84
    -- upvalues:
    --  [1] MatchmakingController_m (copy)

    local v14 = MatchmakingController_m:Get("MatchmadeRematchSuccess")
    local v15 = MatchmakingController_m:Get("MatchmadeRematchCount")
    local v16 = MatchmakingController_m:Get("MatchmadeRematchGoal")
    local v17 = MatchmakingController_m:IsRematchAvailable()
    local RematchCountText = arg5.RematchCountText
    RematchCountText.Text = if v14 then "\226\128\162 \226\128\162 \226\128\162" else v17 and v15 .. " / " .. v16 or "Unavailable"
end

function t._BubbleEffect(arg6) -- line: 93
    -- upvalues:
    --  [1] Players (copy)

    arg6._bubble_effect += 1
    local BubbleEffect = arg6._bubble_effect

    if
        not arg6.Frame.Visible
        or not arg6.PlayButtonJoinFrame.Visible
        or not arg6.PlayButtonJoinBubble.Visible
    then
        return
    end

    while true do
        if BubbleEffect ~= arg6._bubble_effect then
            return
        end

        if arg6.PlayButtonJoinBubble:IsDescendantOf(Players) then
            arg6.PlayButtonJoinBubble:TweenPosition(
                UDim2.new(0.5, 0, -0.5, 0),
                "Out",
                "Sine",
                0.5,
                true
            )
        end

        wait(0.5)

        if BubbleEffect ~= arg6._bubble_effect then
            return
        end

        if arg6.PlayButtonJoinBubble:IsDescendantOf(Players) then
            arg6.PlayButtonJoinBubble:TweenPosition(
                UDim2.new(0.5, 0, -0.2, 0),
                "In",
                "Sine",
                0.5,
                true
            )
        end

        wait(0.5)
    end
end

function t._UpdatePlayButton(arg7) -- line: 124
    -- upvalues:
    --  [1] CONSTANTS_m (copy)
    --  [2] ArcadeController_m (copy)
    --  [3] PlayerDataController_m (copy)

    if CONSTANTS_m.IS_ARCADE_SERVER or ArcadeController_m.CurrentDuel then
        local v21 = ArcadeController_m:GetJoinCooldown()
        local v22 = ArcadeController_m.CurrentDuel

        if v22 then
            v22 = if ArcadeController_m.CurrentDuel:Get("Status") ~= "GameOver" then v21 <= 0 else false
        end

        arg7.PlayButtonJoinBubble.Visible = false
        local PlayButtonOffJoinText = arg7.PlayButtonOffJoinText
        PlayButtonOffJoinText.Text = v21 > 0 and v21 or "Join"
        arg7.PlayButtonJoinFrame.Visible = v22
        arg7.PlayButtonOffFrame.Visible = not v22
    else
        local key = next(PlayerDataController_m:Get("FreeWeaponTrialsRemaining"))
        local v25 = key
        local PlayButtonJoinBubble_2 = arg7.PlayButtonJoinBubble

        if not v25 then
            v25 = PlayerDataController_m:GetStatistic("StatisticDuelsPlayed") <= 3 and true
        end

        PlayButtonJoinBubble_2.Visible = v25
        v25 = if not key then "Join the queue to start playing!" else "Your free weapon trial is ready!"
        arg7.PlayButtonJoinBubbleText.Text = v25
        arg7.PlayButtonJoinText.Text = "Play"
        arg7.PlayButtonJoinFrame.Visible = true
        arg7.PlayButtonOffFrame.Visible = false
    end

    task.spawn(arg7._BubbleEffect, arg7)
end

function t._UpdateVisibility(arg8) -- line: 146
    -- upvalues:
    --  [1] Pages_m (copy)
    --  [2] Equipment_m (copy)
    --  [3] Queue_m (copy)
    --  [4] Matchmaking_m (copy)
    --  [5] Teleporting_m (copy)
    --  [6] MobileInputs_m (copy)
    --  [7] GuiService (copy)
    --  [8] CONSTANTS_m (copy)
    --  [9] MatchmakingController_m (copy)
    --  [10] PartyController_m (copy)
    --  [11] ArcadeController_m (copy)

    local v26 = not Pages_m.PageSystem.CurrentPage

    if v26 then
        v26 = not Equipment_m.IsOpen

        if v26 then
            v26 = not Queue_m:IsVisible()

            if v26 then
                v26 = not Matchmaking_m:IsVisible()

                if v26 then
                    v26 = not Teleporting_m.Enabled and not MobileInputs_m.EditorEnabled and not GuiService.MenuIsOpen
                end
            end
        end
    end

    local v27 = v26

    if v27 then
        if not CONSTANTS_m.IS_ARCADE_SERVER then
            v27 = MatchmakingController_m:IsMatchmadeDuelOver()

            if v27 then
                v27 = PartyController_m:IsPartyLeader()
            end
        else
            v27 = PartyController_m:IsPartyLeader()
        end
    end

    arg8.IsHubVisible = v27
    v27 = v26

    if v27 then
        v27 = CONSTANTS_m.QUEUES_ACTIVE or CONSTANTS_m.IS_ARCADE_SERVER or ArcadeController_m.CurrentDuel or MatchmakingController_m:IsMatchmadeDuelOver()
    end

    arg8.IsPlayVisible = v27
    v27 = v26

    if v27 then
        v27 = MatchmakingController_m:IsRematchAvailable()
    end

    arg8.IsRematchVisible = v27
    v27 = arg8.HubButton
    local v28 = arg8.IsHubVisible and UDim2.new(-3.5, 0, 0.5, 0) or UDim2.new(-3.5, 0, 7, 0)
    v27:TweenPosition(
        v28,
        "Out",
        "Quint",
        0.25,
        true
    )
    local PlayButton = arg8.PlayButton
    v28 = arg8.IsPlayVisible and UDim2.new(0.5, 0, 0.5, 0) or UDim2.new(0.5, 0, 7, 0)
    PlayButton:TweenPosition(
        v28,
        "Out",
        "Quint",
        0.25,
        true
    )
    local RematchButton = arg8.RematchButton
    v28 = arg8.IsRematchVisible and UDim2.new(4.5, 0, 0.5, 0) or UDim2.new(4.5, 0, 7, 0)
    RematchButton:TweenPosition(
        v28,
        "Out",
        "Quint",
        0.25,
        true
    )
end

function t._Init(arg9) -- line: 164
    -- upvalues:
    --  [1] PartyController_m (copy)
    --  [2] MatchmakingController_m (copy)
    --  [3] Equipment_m (copy)
    --  [4] Pages_m (copy)
    --  [5] Queue_m (copy)
    --  [6] Matchmaking_m (copy)
    --  [7] Teleporting_m (copy)
    --  [8] MobileInputs_m (copy)
    --  [9] PlayerDataController_m (copy)
    --  [10] ArcadeController_m (copy)
    --  [11] GuiService (copy)
    --  [12] ButtonEffect_m (copy)

    arg9.PlayButton.MouseButton1Click:Connect(function() -- line: 165
        -- upvalues:
        --  [1] arg9 (copy)

        arg9:OpenPlayPage()
    end)
    arg9.HubButton.MouseButton1Click:Connect(function() -- line: 169
        -- upvalues:
        --  [1] arg9 (copy)

        arg9:GoBackToHub()
    end)
    arg9.RematchButton.MouseButton1Click:Connect(function() -- line: 173
        -- upvalues:
        --  [1] arg9 (copy)

        arg9:RematchRequest()
    end)
    arg9.Frame:GetPropertyChangedSignal("Visible"):Connect(function() -- line: 177
        -- upvalues:
        --  [1] arg9 (copy)

        arg9:_UpdatePlayButton()
    end)
    arg9.PlayButtonJoinBubbleText:GetPropertyChangedSignal("TextBounds"):Connect(function() -- line: 181
        -- upvalues:
        --  [1] arg9 (copy)

        arg9:_UpdateLayouts()
    end)
    arg9.PlayButtonJoinBubble:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- line: 185
        -- upvalues:
        --  [1] arg9 (copy)

        arg9:_UpdateLayouts()
    end)
    PartyController_m.PartyChanged:Connect(function() -- line: 189
        -- upvalues:
        --  [1] arg9 (copy)

        arg9:_UpdateVisibility()
    end)
    MatchmakingController_m.MatchmadeDuelEnded:Connect(function() -- line: 193
        -- upvalues:
        --  [1] arg9 (copy)

        arg9:_UpdateVisibility()
    end)
    MatchmakingController_m.RematchDetailsChanged:Connect(function() -- line: 197
        -- upvalues:
        --  [1] arg9 (copy)

        arg9:_UpdateVisibility()
        arg9:_UpdateRematchButton()
    end)
    Equipment_m.Opened:Connect(function() -- line: 202
        -- upvalues:
        --  [1] arg9 (copy)

        arg9:_UpdateVisibility()
    end)
    Pages_m.PageSystem.PageOpened:Connect(function() -- line: 206
        -- upvalues:
        --  [1] arg9 (copy)

        arg9:_UpdateVisibility()
    end)
    Pages_m.PageSystem.PageClosed:Connect(function() -- line: 210
        -- upvalues:
        --  [1] arg9 (copy)

        arg9:_UpdateVisibility()
    end)
    Queue_m.VisibilityChanged:Connect(function() -- line: 214
        -- upvalues:
        --  [1] arg9 (copy)

        arg9:_UpdateVisibility()
    end)
    Matchmaking_m.VisibilityChanged:Connect(function() -- line: 218
        -- upvalues:
        --  [1] arg9 (copy)

        arg9:_UpdateVisibility()
    end)
    Teleporting_m.EnabledChanged:Connect(function() -- line: 222
        -- upvalues:
        --  [1] arg9 (copy)

        arg9:_UpdateVisibility()
    end)
    MobileInputs_m.EditorEnabledChanged:Connect(function() -- line: 226
        -- upvalues:
        --  [1] arg9 (copy)

        arg9:_UpdateVisibility()
    end)
    PlayerDataController_m:GetDataChangedSignal("StatisticDuelsPlayed"):Connect(function() -- line: 230
        -- upvalues:
        --  [1] arg9 (copy)

        arg9:_UpdatePlayButton()
    end)
    PlayerDataController_m:GetDataChangedSignal("FreeWeaponTrialsRemaining"):Connect(function() -- line: 234
        -- upvalues:
        --  [1] arg9 (copy)

        arg9:_UpdatePlayButton()
    end)
    ArcadeController_m.DuelSet:Connect(function(_) -- line: 238
        -- upvalues:
        --  [1] arg9 (copy)

        arg9:_UpdateVisibility()
        arg9:_UpdatePlayButton()
    end)
    ArcadeController_m.UpdateJoinCooldown:Connect(function() -- line: 243
        -- upvalues:
        --  [1] arg9 (copy)

        arg9:_UpdatePlayButton()
    end)
    GuiService:GetPropertyChangedSignal("MenuIsOpen"):Connect(function() -- line: 247
        -- upvalues:
        --  [1] arg9 (copy)

        arg9:_UpdateVisibility()
    end)

    if ArcadeController_m.CurrentDuel then
        task.defer(arg9._ArcadeDuelAdded, arg9, ArcadeController_m.CurrentDuel)
    end

    arg9:_UpdateLayouts()
    arg9:_UpdatePlayButton()
    arg9:_UpdateVisibility()
    ButtonEffect_m:Add(arg9.HubButton)
    ButtonEffect_m:Add(arg9.PlayButton)
    ButtonEffect_m:Add(arg9.RematchButton)
end

return t._new()
