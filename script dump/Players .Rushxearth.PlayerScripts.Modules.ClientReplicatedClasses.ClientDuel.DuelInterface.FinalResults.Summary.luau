local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local SeasonLibrary_m = require(ReplicatedStorage.Modules.SeasonLibrary)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local RankIcon_m = require(Players.LocalPlayer.PlayerScripts.Modules.RankIcon)
local ELOBar_m = require(Players.LocalPlayer.PlayerScripts.Modules.ELOBar)
local udim2 = UDim2.new(0.8, 0, 0.8, 0)
local udim2_1 = UDim2.new(0.5, 0, 0.5, 0)
local udim2_2 = UDim2.new(0.5, 0, 0.5, 0)
local udim2_3 = UDim2.new(0.5, 0, 0.375, 0)
local t = {}
t.__index = t

function t.new(arg1) -- line: 17
    -- upvalues:
    --  [1] t (copy)
    --  [2] ELOBar_m (copy)

    local t_1 = setmetatable({}, t)
    t_1.FinalResults = arg1
    t_1.ELOBar = ELOBar_m.new()
    t_1.Frame = t_1.FinalResults.Frame:WaitForChild("Summary")
    t_1.Container = t_1.Frame:WaitForChild("Container")
    t_1.CardFrame = t_1.Container:WaitForChild("Card")
    t_1.BarContainer = t_1.CardFrame:WaitForChild("BarContainer")
    t_1.RankFrame = t_1.CardFrame:WaitForChild("Rank")
    t_1.RankHeaderFrame = t_1.RankFrame:WaitForChild("Header")
    t_1.RankHeaderText = t_1.RankHeaderFrame:WaitForChild("Title")
    t_1.RankHeaderTextLeftIcon = t_1.RankHeaderText:WaitForChild("Left")
    t_1.RankHeaderTextRightIcon = t_1.RankHeaderText:WaitForChild("Right")
    t_1.RankHeaderBackground = t_1.RankHeaderFrame:WaitForChild("Background")
    t_1._last_rank_icon = nil
    t_1._summary_details_hash = 0
    t_1._summary_details = nil
    t_1:_Init()

    return t_1
end

function t.GetLocalPlayerPreviousELO(arg2) -- line: 60
    -- upvalues:
    --  [1] Players (copy)

    if not arg2._summary_details then
        return Players.LocalPlayer:GetAttribute("DisplayELO")
    end

    if arg2._summary_details.SummaryType == "RankedELOChanged" then
        return arg2._summary_details.PreviousELO
    end

    return nil
end

function t.HasDetailsReady(arg3) -- line: 70
    return arg3._summary_details ~= nil
end

function t.SetDetails(arg4, arg5) -- line: 74
    arg4._summary_details = arg5
    arg4._summary_details_hash += 1
end

function t.SetVisible(arg6, arg7) -- line: 79
    arg6.Frame.Visible = arg7
    arg6._summary_details_hash += 1

    if arg7 then
        arg6:DisplaySummaryDetails()
    end
end

function t.DisplaySummaryDetails(arg8) -- line: 88
    -- upvalues:
    --  [1] udim2 (copy)
    --  [2] udim2_1 (copy)
    --  [3] Utility_m (copy)
    --  [4] SeasonLibrary_m (copy)
    --  [5] Players (copy)
    --  [6] udim2_2 (copy)
    --  [7] udim2_3 (copy)

    arg8._summary_details_hash += 1
    local SummaryDetailsHash = arg8._summary_details_hash
    arg8:_PlayCountingSound(0)
    arg8:_PlayPromoteSound(0)
    arg8:_PlayDemoteSound(0)
    arg8:_PlayShieldSound(0)
    arg8.BarContainer.Visible = false
    arg8.RankFrame.Size = UDim2.new(0, 0, 0, 0)
    arg8.RankFrame.Position = UDim2.new(0.5, 0, 1, 0)
    arg8.RankFrame:TweenSizeAndPosition(
        udim2,
        udim2_1,
        "Out",
        "Quint",
        0.5,
        true
    )
    arg8.RankHeaderText.Text = ""
    arg8.RankHeaderTextLeftIcon.Visible = false
    arg8.RankHeaderTextRightIcon.Visible = false

    if arg8._summary_details.SummaryType == "RankedPlacementsProgress" then
        arg8:_CreateRankIcon(nil):SetParent(arg8.RankFrame)
        wait(0.5)

        if SummaryDetailsHash ~= arg8._summary_details_hash then
            return
        end
    elseif arg8._summary_details.SummaryType == "RankedPlacementsComplete" then
        local v3 = arg8:_CreateRankIcon(nil)
        v3:SetLabelFromELOEvent(nil, nil, 0)
        v3:SetParent(arg8.RankFrame)
        wait(0.5)

        if SummaryDetailsHash ~= arg8._summary_details_hash then
            return
        end

        arg8:_PlayCountingSound()
        Utility_m:RenderstepForLoop(0, 100, 2, function(arg9) -- line: 128
            -- upvalues:
            --  [1] SummaryDetailsHash (copy)
            --  [2] arg8 (copy)
            --  [3] v3 (copy)
            --  [4] SeasonLibrary_m (ref)

            if SummaryDetailsHash ~= arg8._summary_details_hash then
                return true
            end

            v3:SetLabelFromELOEvent(
                nil,
                nil,
                (math.floor(
                    SeasonLibrary_m.CurrentSeason.RankProfile.NumPlacementDuels * (arg9 / 100)
                ))
            )
        end)

        if SummaryDetailsHash ~= arg8._summary_details_hash then
            return
        end

        wait(1)

        if SummaryDetailsHash ~= arg8._summary_details_hash then
            return
        end

        arg8.RankHeaderText.Text = "Congratulations! You've placed " .. SeasonLibrary_m:GetRank(
            arg8._summary_details.PlacementELO,
            Players.LocalPlayer.UserId
        )
        arg8:_PlayPromoteSound()
        arg8:_CreateRankIcon(arg8._summary_details.PlacementELO):SetParent(arg8.RankFrame)
        arg8.RankFrame.Size = udim2 + UDim2.new(0.4, 0, 0.4, 0)
        arg8.RankFrame:TweenSize(
            udim2,
            "Out",
            "Back",
            0.25,
            true
        )
        wait(1)

        if SummaryDetailsHash ~= arg8._summary_details_hash then
            return
        end
    elseif arg8._summary_details.SummaryType == "RankedELOChanged" then
        local v7 = arg8:_CreateRankIcon(arg8._summary_details.PreviousELO)
        v7:SetParent(arg8.RankFrame)
        wait(0.5)

        if SummaryDetailsHash ~= arg8._summary_details_hash then
            return
        end

        arg8:_PlayCountingSound()
        local v8 = arg8._summary_details.CurrentELO - arg8._summary_details.PreviousELO
        local v9 = arg8._summary_details.ELOSaved or v8
        Utility_m:RenderstepForLoop(0, 100, 2, function(arg10) -- line: 177
            -- upvalues:
            --  [1] SummaryDetailsHash (copy)
            --  [2] arg8 (copy)
            --  [3] v7 (copy)
            --  [4] v9 (copy)
            --  [5] SeasonLibrary_m (ref)

            if SummaryDetailsHash ~= arg8._summary_details_hash then
                return true
            end

            v7:SetLabelFromELOEvent(
                math.floor(v9 * (arg10 / 100)),
                arg8._summary_details.PreviousELO,
                SeasonLibrary_m.CurrentSeason.RankProfile.NumPlacementDuels
            )
        end)

        if SummaryDetailsHash ~= arg8._summary_details_hash then
            return
        end

        wait(1)

        if SummaryDetailsHash ~= arg8._summary_details_hash then
            return
        end

        local v11 = SeasonLibrary_m:GetRank(
            arg8._summary_details.PreviousELO,
            Players.LocalPlayer.UserId
        )
        local v12 = SeasonLibrary_m:GetRank(
            arg8._summary_details.CurrentELO,
            Players.LocalPlayer.UserId
        )

        if arg8._summary_details.ELOSaved then
            v7:SetLabelFromELOEvent(
                v8,
                arg8._summary_details.PreviousELO,
                SeasonLibrary_m.CurrentSeason.RankProfile.NumPlacementDuels
            )
            arg8.RankFrame.Position = udim2_1 + UDim2.new(0, 0, 0.15, 0)
            arg8.RankFrame:TweenPosition(
                udim2_1,
                "Out",
                "Quint",
                0.25,
                true
            )
            arg8.RankHeaderText.Text = string.format(
                "Your ELO Shield saved you from <font color=\"rgb(255,50,50)\">%s ELO</font>",
                arg8._summary_details.ELOSaved
            )
            arg8.RankHeaderTextLeftIcon.Visible = true
            arg8.RankHeaderTextRightIcon.Visible = true
            arg8.RankHeaderTextLeftIcon.Image = "rbxassetid://118920750856778"
            arg8.RankHeaderTextRightIcon.Image = "rbxassetid://118920750856778"
            arg8:_PlayShieldSound()
            wait(1)

            if SummaryDetailsHash ~= arg8._summary_details_hash then
                return
            end
        elseif v11 ~= v12 then
            local v14 = arg8:_CreateRankIcon(arg8._summary_details.CurrentELO)
            v14:SetLabelFromELOEvent(
                v9,
                arg8._summary_details.CurrentELO,
                SeasonLibrary_m.CurrentSeason.RankProfile.NumPlacementDuels
            )
            v14:SetParent(arg8.RankFrame)
            arg8.RankFrame.Size = udim2 + UDim2.new(0.4, 0, 0.4, 0)
            arg8.RankFrame:TweenSize(
                udim2,
                "Out",
                "Back",
                0.25,
                true
            )

            if arg8._summary_details.CurrentELO > arg8._summary_details.PreviousELO then
                arg8.RankHeaderText.Text = "Congratulations! You've promoted to " .. v12
                arg8:_PlayPromoteSound()
            else
                arg8.RankHeaderText.Text = "You've demoted to " .. v12
                arg8:_PlayDemoteSound()
            end

            wait(1)

            if SummaryDetailsHash ~= arg8._summary_details_hash then
                return
            end
        end
    else
        assert(false, arg8._summary_details.SummaryType)
    end

    arg8.RankFrame:TweenSizeAndPosition(
        udim2_2,
        udim2_3,
        "Out",
        "Quint",
        0.5,
        true
    )
    wait(0.1)

    if SummaryDetailsHash ~= arg8._summary_details_hash then
        return
    end

    arg8.BarContainer.Visible = true
    arg8.ELOBar:Update(true)
end

function t.Destroy(arg11) -- line: 256
    arg11._summary_details_hash += 1
    arg11.ELOBar:Destroy()
end

function t._PlayCountingSound(arg12, arg13) -- line: 265
    arg12.FinalResults.DuelInterface:CreateSound(
        "rbxassetid://99054764924747",
        1 * (arg13 or 1),
        1,
        script,
        true,
        10
    )
end

function t._PlayPromoteSound(arg14, arg15) -- line: 271
    local v17 = arg15 or 1
    arg14.FinalResults.DuelInterface:CreateSound(
        "rbxassetid://138975587469438",
        1 * v17,
        1,
        script,
        true,
        10
    )
    task.delay(
        0.125,
        arg14.FinalResults.DuelInterface.CreateSound,
        arg14.FinalResults.DuelInterface,
        "rbxassetid://70643163489676",
        1 * v17,
        1,
        script,
        true,
        10
    )
end

function t._PlayDemoteSound(arg16, arg17) -- line: 279
    local v19 = arg17 or 1
    arg16.FinalResults.DuelInterface:CreateSound(
        "rbxassetid://70643163489676",
        1 * v19,
        0.75,
        script,
        true,
        10
    )
    arg16.FinalResults.DuelInterface:CreateSound(
        "rbxassetid://91547731028928",
        1 * v19,
        1,
        script,
        true,
        10
    )
end

function t._PlayShieldSound(arg18, arg19) -- line: 286
    local v22 = arg19 or 1
    arg18.FinalResults.DuelInterface:CreateSound(
        "rbxassetid://132313563275913",
        0.75 * v22,
        2,
        script,
        true,
        10
    )
    arg18.FinalResults.DuelInterface:CreateSound(
        "rbxassetid://128864122802098",
        1 * v22,
        1.5,
        script,
        true,
        10
    )
end

function t._CreateRankIcon(arg20, arg21) -- line: 293
    -- upvalues:
    --  [1] RankIcon_m (copy)
    --  [2] Players (copy)

    if arg20._last_rank_icon then
        arg20._last_rank_icon:Destroy()
        arg20._last_rank_icon = nil
    end

    arg20._last_rank_icon = RankIcon_m.new(arg21, Players.LocalPlayer.UserId)

    return arg20._last_rank_icon
end

function t._UpdateHeader(arg22) -- line: 304
    local v25 = if arg22.RankHeaderTextLeftIcon.Visible then arg22.RankHeaderTextLeftIcon.AbsoluteSize.X + arg22.RankHeaderTextRightIcon.AbsoluteSize.X else if not arg22.RankHeaderTextRightIcon.Visible then 0 else arg22.RankHeaderTextLeftIcon.AbsoluteSize.X + arg22.RankHeaderTextRightIcon.AbsoluteSize.X
    arg22.RankHeaderBackground.Size = UDim2.new(
        0,
        arg22.RankHeaderText.TextBounds.X + arg22.RankHeaderText.TextBounds.Y * 1.5 + v25,
        1,
        0
    )
    local RankHeaderBackground_1 = arg22.RankHeaderBackground
    RankHeaderBackground_1.Visible = arg22.RankHeaderText.TextBounds.X > 0
    arg22.RankHeaderTextLeftIcon.Position = UDim2.new(
        0.5,
        -arg22.RankHeaderText.TextBounds.X / 2,
        0.5,
        0
    )
    arg22.RankHeaderTextRightIcon.Position = UDim2.new(
        0.5,
        arg22.RankHeaderText.TextBounds.X / 2,
        0.5,
        0
    )
end

function t._Setup(arg23) -- line: 313
    arg23.ELOBar:SetParent(arg23.BarContainer)
end

function t._Init(arg24) -- line: 317
    arg24.RankHeaderText:GetPropertyChangedSignal("TextBounds"):Connect(function() -- line: 318
        -- upvalues:
        --  [1] arg24 (copy)

        arg24:_UpdateHeader()
    end)
    arg24.RankHeaderTextLeftIcon:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- line: 322
        -- upvalues:
        --  [1] arg24 (copy)

        arg24:_UpdateHeader()
    end)
    arg24.RankHeaderTextLeftIcon:GetPropertyChangedSignal("Visible"):Connect(function() -- line: 326
        -- upvalues:
        --  [1] arg24 (copy)

        arg24:_UpdateHeader()
    end)
    arg24.RankHeaderTextRightIcon:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- line: 330
        -- upvalues:
        --  [1] arg24 (copy)

        arg24:_UpdateHeader()
    end)
    arg24.RankHeaderTextRightIcon:GetPropertyChangedSignal("Visible"):Connect(function() -- line: 334
        -- upvalues:
        --  [1] arg24 (copy)

        arg24:_UpdateHeader()
    end)
    arg24:_Setup()
    arg24:_UpdateHeader()
end

return t
