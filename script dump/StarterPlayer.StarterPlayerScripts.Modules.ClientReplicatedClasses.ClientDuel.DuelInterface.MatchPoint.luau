local Utility_m = require(game:GetService("ReplicatedStorage").Modules.Utility)
local t = {}
t.__index = t

function t.new(arg1) -- line: 8
    -- upvalues:
    --  [1] t (copy)

    local t_1 = setmetatable({}, t)
    t_1.DuelInterface = arg1
    t_1.Frame = t_1.DuelInterface.Frame:WaitForChild("Top"):WaitForChild("MatchPoint")
    t_1.Background = t_1.Frame:WaitForChild("Background")
    t_1.Title = t_1.Frame:WaitForChild("Title")
    t_1._destroyed = false
    t_1._match_point_hash = 0
    t_1:_Init()

    return t_1
end

function t.Play(arg2, arg3) -- line: 28
    -- upvalues:
    --  [1] Utility_m (copy)

    arg2._match_point_hash += 1

    if arg2.DuelInterface.ClientDuel:Get("MatchPointVisualDisabled") then
        return
    end

    local MatchPointHash = arg2._match_point_hash
    local v1 = if not arg3 then "rbxassetid://17026600996" else "rbxassetid://17467242617"
    local v2 = if not arg3 then 1 else 1.5
    arg2.DuelInterface:CreateSound(
        v1,
        v2,
        1,
        script,
        true,
        15
    )
    arg2.DuelInterface.Timer:SetVisible(false)
    arg2.DuelInterface.Scores:SetVisible(false)
    arg2.Frame.Visible = true
    arg2.Frame.GroupTransparency = 0
    arg2.Frame.Position = UDim2.new(0.5, 0, 0.02, 5)
    local Background = arg2.Background
    Background.Size = arg3 and UDim2.new(0.66, 0, 0.5, 0) or UDim2.new(0.6, 0, 0.5, 0)
    arg2.Title.Text = if not arg3 then "MATCH POINT" else "SUDDEN DEATH"
    arg2:_UpdateTextBounds()
    arg2.Frame:TweenPosition(
        UDim2.new(0.5, 0, 0.0425, 10),
        "Out",
        "Quint",
        2,
        true,
        function() -- line: 49
            -- upvalues:
            --  [1] Utility_m (ref)
            --  [2] MatchPointHash (copy)
            --  [3] arg2 (copy)

            Utility_m:RenderstepForLoop(0, 100, 2, function(arg4) -- line: 50
                -- upvalues:
                --  [1] MatchPointHash (ref)
                --  [2] arg2 (ref)

                if MatchPointHash ~= arg2._match_point_hash then
                    return true
                end

                arg2.Frame.GroupTransparency = 1 - (1 - arg4 / 100) ^ 4
            end)

            if MatchPointHash ~= arg2._match_point_hash then
                return
            end

            arg2.DuelInterface.Timer:SetVisible(true)
            arg2.DuelInterface.Scores:SetVisible(true)
            arg2.Frame.Visible = false
        end
    )
end

function t.Destroy(arg5) -- line: 68
    arg5._destroyed = true
    arg5._match_point_hash += 1
end

function t._UpdateTextBounds(arg6) -- line: 77
    arg6.Background.Size = UDim2.new(0.1, arg6.Title.TextBounds.X, 0.5, 0)
end

function t._Init(arg7) -- line: 81
    arg7.Title:GetPropertyChangedSignal("TextBounds"):Connect(function() -- line: 82
        -- upvalues:
        --  [1] arg7 (copy)

        arg7:_UpdateTextBounds()
    end)
    arg7:_UpdateTextBounds()
end

return t
