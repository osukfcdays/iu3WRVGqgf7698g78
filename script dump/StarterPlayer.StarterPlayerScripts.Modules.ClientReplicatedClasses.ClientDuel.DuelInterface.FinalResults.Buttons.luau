local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local CONSTANTS_m = require(ReplicatedStorage.Modules.CONSTANTS)
local PlayerDataController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.PlayerDataController
)
local SpectateController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.SpectateController
)
local PartyController_m = require(Players.LocalPlayer.PlayerScripts.Controllers.PartyController)
local ButtonEffect_m = require(Players.LocalPlayer.PlayerScripts.Modules.ButtonEffect)
local t = { HoverRatio = UDim2.new(0, 10, 0, 10), ReleaseRatio = UDim2.new(0, 10, 0, 10) }
local t_1 = {}
t_1.__index = t_1

function t_1.new(arg1) -- line: 15
    -- upvalues:
    --  [1] t_1 (copy)

    local t_2 = setmetatable({}, t_1)
    t_2.FinalResults = arg1
    t_2.Frame = t_2.FinalResults.Frame:WaitForChild("Buttons")
    t_2.BottomRightFrame = t_2.Frame:WaitForChild("BottomRight")
    t_2.BottomRightContainer = t_2.BottomRightFrame:WaitForChild("Container")
    t_2.ContinueFrame = t_2.BottomRightContainer:WaitForChild("Continue")
    t_2.ContinueButton = t_2.ContinueFrame:WaitForChild("Button")
    t_2.PlayAgainFrame = t_2.BottomRightContainer:WaitForChild("PlayAgain")
    t_2.PlayAgainButton = t_2.PlayAgainFrame:WaitForChild("Button")
    t_2.LeaveFrame = t_2.BottomRightContainer:WaitForChild("Leave")
    t_2.LeaveButton = t_2.LeaveFrame:WaitForChild("Button")
    t_2.LeaveButtonTitle = t_2.LeaveButton:WaitForChild("Title")
    t_2.LeaveButtonTitleStroke = t_2.LeaveButtonTitle:WaitForChild("UIStroke")
    t_2.LeaveButtonShine = t_2.LeaveButton:WaitForChild("Shine")
    t_2.LeaveButtonOutlineUIStroke = t_2.LeaveButton:WaitForChild("Outline"):WaitForChild(
        "UIStroke"
    )
    t_2.RematchFrame = t_2.BottomRightContainer:WaitForChild("Rematch")
    t_2.RematchButton = t_2.RematchFrame:WaitForChild("Button")
    t_2.RematchButtonTitle = t_2.RematchButton:WaitForChild("Title")
    t_2.RematchButtonTitleStroke = t_2.RematchButtonTitle:WaitForChild("UIStroke")
    t_2.RematchButtonCount = t_2.RematchButton:WaitForChild("Count")
    t_2.RematchButtonCountStroke = t_2.RematchButtonCount:WaitForChild("UIStroke")
    t_2.RematchButtonShine = t_2.RematchButton:WaitForChild("Shine")
    t_2.RematchButtonOutlineUIStroke = t_2.RematchButton:WaitForChild("Outline"):WaitForChild(
        "UIStroke"
    )
    t_2.BottomLeftFrame = t_2.Frame:WaitForChild("BottomLeft")
    t_2.BottomLeftContainer = t_2.BottomLeftFrame:WaitForChild("Container")
    t_2.BackFrame = t_2.BottomLeftContainer:WaitForChild("Back")
    t_2.BackButton = t_2.BackFrame:WaitForChild("Button")
    t_2._destroyed = false
    t_2:_Init()

    return t_2
end

function t_1.LeaveRequest(arg2) -- line: 56
    -- upvalues:
    --  [1] ReplicatedStorage (copy)
    --  [2] SpectateController_m (copy)

    if not arg2.FinalResults.Winners:IsFinished() then
        arg2.FinalResults.Winners:Skip()

        return
    end

    if arg2.FinalResults.DuelInterface.ClientDuel.LocalDueler then
        ReplicatedStorage.Remotes.Duels.LeaveDuel:FireServer()

        return
    end

    SpectateController_m:Exit()
end

function t_1.Rematch(_) -- line: 69
    -- upvalues:
    --  [1] ReplicatedStorage (copy)

    ReplicatedStorage.Remotes.Duels.Rematch:FireServer()
end

function t_1.PlayAgain(_) -- line: 73
    -- upvalues:
    --  [1] ReplicatedStorage (copy)

    ReplicatedStorage.Remotes.Matchmaking.PlayAgain:FireServer()
end

function t_1.Continue(arg5) -- line: 77
    arg5.FinalResults:SetPage("Summary")
end

function t_1.Update(arg6) -- line: 81
    arg6:_UpdateRematchButton()
end

function t_1.Destroy(arg7) -- line: 85
    arg7._destroyed = true
end

function t_1._UpdateRematchButton(arg8) -- line: 93
    local v1 = arg8.FinalResults.DuelInterface.ClientDuel:Get("RematchCount")
    local v2 = arg8.FinalResults.DuelInterface.ClientDuel:Get("RematchGoal")
    local v3 = arg8.FinalResults.DuelInterface.ClientDuel:Get("RematchSuccess")
    local v4 = v3 or v1 and v2 and arg8.FinalResults.DuelInterface.ClientDuel:Get(
        "RematchAvailable"
    )
    local v5 = v4 and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(0, 0, 0)
    local v6 = if not v4 then 0.75 else 0
    arg8.RematchButtonOutlineUIStroke.Color = v5
    arg8.RematchButtonShine.ImageColor3 = v5
    arg8.RematchButtonTitle.TextColor3 = v5
    arg8.RematchButtonCount.TextColor3 = v5
    arg8.RematchButtonOutlineUIStroke.Transparency = v6
    arg8.RematchButtonShine.ImageTransparency = v6
    arg8.RematchButtonTitle.TextTransparency = v6
    arg8.RematchButtonCount.TextTransparency = v6
    local RematchButtonCount = arg8.RematchButtonCount
    RematchButtonCount.Text = if v3 then "\226\128\162 \226\128\162 \226\128\162" else v4 and v1 .. " / " .. v2 or "Unavailable"
    local RematchButtonCount_1 = arg8.RematchButtonCount
    RematchButtonCount_1.FontFace = v4 and Font.fromId(12187365977, Enum.FontWeight.Heavy) or Font.fromId(
        12187365977,
        Enum.FontWeight.Medium
    )
    arg8.RematchButtonTitleStroke.Enabled = v4
    arg8.RematchButtonCountStroke.Enabled = v4
end

function t_1._UpdateButtonStates(arg9) -- line: 119
    -- upvalues:
    --  [1] CONSTANTS_m (copy)
    --  [2] PartyController_m (copy)

    local v8 = arg9.FinalResults:IsActive()
    local v9 = arg9.FinalResults.Winners:IsFinished()
    local v10 = arg9.FinalResults.CurrentPage
    local v11 = if arg9.FinalResults.DuelInterface.ClientDuel.LocalDueler == nil then false else true
    local v12 = v8
    local ContinueFrame = arg9.ContinueFrame

    if v12 then
        v12 = v9

        if v12 then
            v12 = if v10 == "Winners" then arg9.FinalResults.Summary:HasDetailsReady() else false
        end
    end

    ContinueFrame.Visible = v12
    local RematchFrame = arg9.RematchFrame
    v12 = v11 and not arg9.ContinueFrame.Visible and v8 and v9
    RematchFrame.Visible = v12
    v12 = v11
    local PlayAgainFrame = arg9.PlayAgainFrame

    if v12 then
        v12 = not arg9.ContinueFrame.Visible

        if v12 then
            v12 = v8

            if v12 then
                v12 = v9

                if v12 then
                    v12 = CONSTANTS_m.IS_MATCHMAKING_SERVER

                    if v12 then
                        v12 = PartyController_m:IsPartyLeader()
                    end
                end
            end
        end
    end

    PlayAgainFrame.Visible = v12
    arg9.LeaveFrame.Visible = not arg9.ContinueFrame.Visible and v8
    local BackButton = arg9.BackButton
    v12 = v8 and v9 and v10 == "Summary"
    BackButton.Visible = v12
    v11 = v9 and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(0, 0, 0)
    v10 = if not v9 then 0.75 else 0
    v8 = if not v9 then "Skip" else "Leave"
    arg9.LeaveButtonTitle.Text = v8
    arg9.LeaveButtonTitle.TextColor3 = v11
    arg9.LeaveButtonShine.ImageColor3 = v11
    arg9.LeaveButtonOutlineUIStroke.Color = v11
    arg9.LeaveButtonTitle.TextTransparency = v10
    arg9.LeaveButtonShine.ImageTransparency = v10
    arg9.LeaveButtonOutlineUIStroke.Transparency = v10
    arg9.LeaveButtonTitleStroke.Enabled = v9
end

function t_1._Init(arg10) -- line: 145
    -- upvalues:
    --  [1] PlayerDataController_m (copy)
    --  [2] ButtonEffect_m (copy)
    --  [3] t (copy)

    arg10.LeaveButton.MouseButton1Click:Connect(function() -- line: 146
        -- upvalues:
        --  [1] arg10 (copy)

        arg10:LeaveRequest()
    end)
    arg10.PlayAgainButton.MouseButton1Click:Connect(function() -- line: 150
        -- upvalues:
        --  [1] arg10 (copy)

        arg10:PlayAgain()
    end)
    arg10.RematchButton.MouseButton1Click:Connect(function() -- line: 154
        -- upvalues:
        --  [1] arg10 (copy)

        arg10:Rematch()
    end)
    arg10.ContinueButton.MouseButton1Click:Connect(function() -- line: 158
        -- upvalues:
        --  [1] arg10 (copy)

        arg10:Continue()
    end)
    arg10.BackButton.MouseButton1Click:Connect(function() -- line: 162
        -- upvalues:
        --  [1] arg10 (copy)

        arg10.FinalResults:SetPage("Winners")
    end)
    arg10.FinalResults.Activated:Connect(function() -- line: 166
        -- upvalues:
        --  [1] arg10 (copy)

        arg10:_UpdateButtonStates()
    end)
    arg10.FinalResults.Winners.Finished:Connect(function() -- line: 170
        -- upvalues:
        --  [1] PlayerDataController_m (ref)
        --  [2] arg10 (copy)

        if PlayerDataController_m:GetSetting("Hide HUD") then
            arg10:LeaveRequest()
        end

        arg10:_UpdateButtonStates()
    end)
    arg10.FinalResults.PageChanged:Connect(function() -- line: 178
        -- upvalues:
        --  [1] arg10 (copy)

        arg10:_UpdateButtonStates()
    end)
    task.defer(arg10._UpdateButtonStates, arg10)
    task.defer(arg10._UpdateRematchButton, arg10)
    ButtonEffect_m:Add(arg10.ContinueButton, nil, t)
    ButtonEffect_m:Add(arg10.LeaveButton, nil, t)
    ButtonEffect_m:Add(arg10.PlayAgainButton, nil, t)
    ButtonEffect_m:Add(arg10.RematchButton, nil, t)
    ButtonEffect_m:Add(arg10.BackButton, nil, t)
end

return t_1
