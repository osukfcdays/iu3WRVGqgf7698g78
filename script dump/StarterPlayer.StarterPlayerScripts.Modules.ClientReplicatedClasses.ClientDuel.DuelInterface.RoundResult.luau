local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DuelLibrary_m = require(ReplicatedStorage.Modules.DuelLibrary)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local udim2 = UDim2.new(0.5, 0, 0.125, 30)
local udim2_1 = UDim2.new(0.175, 58, 0.07, 20)
local t = {}
t.__index = t

function t.new(arg1) -- line: 13
    -- upvalues:
    --  [1] t (copy)

    local t_1 = setmetatable({}, t)
    t_1.DuelInterface = arg1
    t_1.Frame = t_1.DuelInterface.Frame:WaitForChild("Top"):WaitForChild("RoundResult")
    t_1.Container = t_1.Frame:WaitForChild("Container")
    t_1.OutlineFrame = t_1.Container:WaitForChild("Outline")
    t_1.OutlineUIStroke = t_1.OutlineFrame:WaitForChild("UIStroke")
    t_1.ShineFrame = t_1.Container:WaitForChild("Shine"):WaitForChild("Frame")
    t_1.Background = t_1.Container:WaitForChild("Background")
    t_1.BackgroundTitle = t_1.Background:WaitForChild("Title")
    t_1.BackgroundStatus = t_1.Background:WaitForChild("Status")
    t_1.Background2 = t_1.Container:WaitForChild("Background2")
    t_1._destroyed = false
    t_1._round_result_hash = 0
    t_1:_Init()

    return t_1
end

function t.Play(arg2, arg3) -- line: 39
    -- upvalues:
    --  [1] udim2_1 (copy)
    --  [2] udim2 (copy)
    --  [3] DuelLibrary_m (copy)
    --  [4] Utility_m (copy)

    arg2._round_result_hash += 1
    local RoundResultHash = arg2._round_result_hash
    local v1 = if arg3 == nil then "Tie" else if not arg2.DuelInterface.ClientDuel.LocalDueler then "Win" else if arg2.DuelInterface.ClientDuel.LocalDueler and arg3 == arg2.DuelInterface.ClientDuel.LocalDueler:Get(
        "TeamID"
    ) then "Win" else "Lose"
    arg2.Frame.Size = udim2_1
    arg2.Frame.Position = udim2
    arg2.OutlineFrame.Size = UDim2.new(1, 0, 1, 0)
    arg2.OutlineUIStroke.Thickness = 0
    arg2.ShineFrame.Position = UDim2.new(-0.5, 0, 0.5, 0)
    arg2.BackgroundTitle.TextTransparency = 0
    arg2.BackgroundStatus.TextTransparency = 0
    local BackgroundTitle = arg2.BackgroundTitle
    local v2 = if arg2.DuelInterface.ClientDuel.LocalDueler then "ROUND" else if arg3 then DuelLibrary_m.TeamsByID[arg3].TeamName else "ROUND"
    BackgroundTitle.Text = v2
    local BackgroundStatus = arg2.BackgroundStatus
    v2 = if not arg2.DuelInterface.ClientDuel.LocalDueler then if arg3 then "WON" else "DRAW" else if v1 ~= "Win" then if v1 ~= "Lose" then "DRAW" else "LOST" else "WON"
    BackgroundStatus.Text = v2
    local Background2 = arg2.Background2

    if arg2.DuelInterface.ClientDuel.LocalDueler then
        if v1 == "Win" then
            v2 = Color3.fromRGB(67, 214, 59)

            if not v2 then
                v2 = v1 == "Lose" and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(150, 150, 150)
            end
        else
            v2 = v1 == "Lose" and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(150, 150, 150)
        end
    else
        v2 = DuelLibrary_m:GetTeamColor(arg3)
    end

    Background2.ImageColor3 = v2
    arg2.Background2.ImageTransparency = 0
    arg2.Frame.Visible = true
    arg2.DuelInterface:CreateSound(
        if v1 ~= "Win" then if v1 ~= "Lose" then "rbxassetid://16810087814" else "rbxassetid://16810321565" else "rbxassetid://16810041280",
        1.5,
        1,
        script,
        true,
        5
    )

    if v1 == "Win" then
        arg2.Frame.Size = UDim2.new()
        task.spawn(
            Utility_m.RenderstepForLoop,
            Utility_m,
            0,
            100,
            4,
            function(arg4) -- line: 65
                -- upvalues:
                --  [1] arg2 (copy)
                --  [2] RoundResultHash (copy)
                --  [3] udim2 (ref)

                if arg2._round_result_hash ~= RoundResultHash then
                    return true
                end

                local Frame_1 = arg2.Frame
                local v4 = udim2
                local udim2_2 = UDim2.new(
                    0,
                    0,
                    0.15 * (1 - (1 + 2.70158 * (arg4 / 100 - 1) ^ 3 + 1.70158 * (arg4 / 100 - 1) ^ 2)),
                    0
                )
                Frame_1.Position = v4 + udim2_2
            end
        )
        Utility_m:RenderstepForLoop(0, 100, 4, function(arg5) -- line: 75
            -- upvalues:
            --  [1] arg2 (copy)
            --  [2] RoundResultHash (copy)
            --  [3] udim2_1 (ref)

            if arg2._round_result_hash ~= RoundResultHash then
                return true
            end

            local v5 = arg5 / 100
            arg2.Frame.Size = UDim2.new(
                udim2_1.X.Scale * v5,
                udim2_1.X.Offset * v5,
                udim2_1.Y.Scale * v5,
                udim2_1.Y.Offset * v5
            )
        end)

        if arg2._round_result_hash ~= RoundResultHash then
            return
        end

        Utility_m:RenderstepForLoop(0, 100, 5, function(arg6) -- line: 89
            -- upvalues:
            --  [1] arg2 (copy)
            --  [2] RoundResultHash (copy)

            if arg2._round_result_hash ~= RoundResultHash then
                return true
            end

            arg2.OutlineUIStroke.Thickness = 12 * (1 - (1 - arg6 / 100) ^ 4)
        end)

        if arg2._round_result_hash ~= RoundResultHash then
            return
        end

        Utility_m:RenderstepForLoop(0, 100, 2, function(arg7) -- line: 103
            -- upvalues:
            --  [1] arg2 (copy)
            --  [2] RoundResultHash (copy)

            if arg2._round_result_hash ~= RoundResultHash then
                return true
            end

            local v6 = 1 - (1 - arg7 / 100) ^ 4
            local v7 = 12 * (1 - v6)
            local OutlineUIStroke = arg2.OutlineUIStroke
            OutlineUIStroke.Thickness = if not (v7 < 0.5) then v7 else 0
            arg2.OutlineFrame.Size = UDim2.new(1, 12 * v6 * 1.5, 1, 12 * v6 * 1.5)
        end)

        if arg2._round_result_hash ~= RoundResultHash then
            return
        end

        Utility_m:RenderstepForLoop(0, 100, 2, function(arg8) -- line: 119
            -- upvalues:
            --  [1] arg2 (copy)
            --  [2] RoundResultHash (copy)

            if arg2._round_result_hash ~= RoundResultHash then
                return true
            end

            arg2.ShineFrame.Position = UDim2.new(-0.5 + 2 * (1 - (1 - arg8 / 100) ^ 2), 0, 0.5, 0)
        end)
        wait(2)

        if arg2._round_result_hash ~= RoundResultHash then
            return
        end

        Utility_m:RenderstepForLoop(0, 100, 2, function(arg9) -- line: 135
            -- upvalues:
            --  [1] arg2 (copy)
            --  [2] RoundResultHash (copy)

            if arg2._round_result_hash ~= RoundResultHash then
                return true
            end

            local v9 = (arg9 / 100) ^ 4
            arg2.BackgroundTitle.TextTransparency = v9
            arg2.BackgroundStatus.TextTransparency = v9
            arg2.Background2.ImageTransparency = v9
        end)

        if arg2._round_result_hash ~= RoundResultHash then
            return
        end

        arg2.Frame.Visible = false

        return
    elseif v1 == "Lose" then
        Utility_m:RenderstepForLoop(0, 100, 2, function(arg10) -- line: 153
            -- upvalues:
            --  [1] arg2 (copy)
            --  [2] RoundResultHash (copy)
            --  [3] udim2 (ref)

            if arg2._round_result_hash ~= RoundResultHash then
                return true
            end

            local v10 = 1 - (1 - arg10 / 100) ^ 2
            local v11 = 20 * (1 - (arg10 / 100) ^ 2)
            arg2.Frame.Position = udim2 + UDim2.new(
                0,
                v11 * math.random(),
                -0.025 * (1 - v10),
                30 + v11 * 0.25 * math.random()
            )
            arg2.BackgroundTitle.TextTransparency = 1 - v10
            arg2.BackgroundStatus.TextTransparency = 1 - v10
            arg2.Background2.ImageTransparency = 1 - v10
        end)
        wait(3)

        if arg2._round_result_hash ~= RoundResultHash then
            return
        end

        Utility_m:RenderstepForLoop(0, 100, 1, function(arg11) -- line: 173
            -- upvalues:
            --  [1] arg2 (copy)
            --  [2] RoundResultHash (copy)

            if arg2._round_result_hash ~= RoundResultHash then
                return true
            end

            local v16 = (arg11 / 100) ^ 4
            arg2.BackgroundTitle.TextTransparency = v16
            arg2.BackgroundStatus.TextTransparency = v16
            arg2.Background2.ImageTransparency = v16
        end)

        if arg2._round_result_hash ~= RoundResultHash then
            return
        end

        arg2.Frame.Visible = false

        return
    else
        if v1 == "Tie" then
            Utility_m:RenderstepForLoop(0, 100, 2, function(arg12) -- line: 191
                -- upvalues:
                --  [1] arg2 (copy)
                --  [2] RoundResultHash (copy)

                if arg2._round_result_hash ~= RoundResultHash then
                    return true
                end

                local v17 = 1 - (1 - arg12 / 100) ^ 4
                arg2.BackgroundTitle.TextTransparency = 1 - v17
                arg2.BackgroundStatus.TextTransparency = 1 - v17
                arg2.Background2.ImageTransparency = 1 - v17
            end)
            wait(3)

            if arg2._round_result_hash ~= RoundResultHash then
                return
            end

            Utility_m:RenderstepForLoop(0, 100, 2, function(arg13) -- line: 209
                -- upvalues:
                --  [1] arg2 (copy)
                --  [2] RoundResultHash (copy)

                if arg2._round_result_hash ~= RoundResultHash then
                    return true
                end

                local v18 = (arg13 / 100) ^ 4
                arg2.BackgroundTitle.TextTransparency = v18
                arg2.BackgroundStatus.TextTransparency = v18
                arg2.Background2.ImageTransparency = v18
            end)

            if arg2._round_result_hash ~= RoundResultHash then
                return
            end

            arg2.Frame.Visible = false
        end

        return
    end
end

function t.UpdateVisibility(arg14) -- line: 229
    local Container = arg14.Container
    local v19 = not arg14.DuelInterface:IsPageOpen()

    if v19 then
        v19 = not arg14.DuelInterface.Scoreboard:IsOpen()

        if v19 then
            v19 = not arg14.DuelInterface.Voting:IsOpen()
        end
    end

    Container.Visible = v19
end

function t.Destroy(arg15) -- line: 233
    arg15._destroyed = true
    arg15._round_result_hash += 1
end

function t._Init(arg16) -- line: 242
    arg16.DuelInterface.Scoreboard.VisibilityChanged:Connect(function() -- line: 243
        -- upvalues:
        --  [1] arg16 (copy)

        arg16:UpdateVisibility()
    end)
    arg16.DuelInterface.Voting.VisibilityChanged:Connect(function() -- line: 247
        -- upvalues:
        --  [1] arg16 (copy)

        arg16:UpdateVisibility()
    end)
end

return t
