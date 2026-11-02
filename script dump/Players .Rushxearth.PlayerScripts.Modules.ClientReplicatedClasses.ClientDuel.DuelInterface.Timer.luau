local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local Signal_m = require(ReplicatedStorage.Modules.Signal)
local t = {}
t.__index = t

function t.new(arg1) -- line: 11
    -- upvalues:
    --  [1] t (copy)
    --  [2] Signal_m (copy)

    local t_1 = setmetatable({}, t)
    t_1.TimerChanged = Signal_m.new()
    t_1.DuelInterface = arg1
    t_1.Frame = t_1.DuelInterface.Frame:WaitForChild("Top"):WaitForChild("Timer")
    t_1.InfiniteIcon = t_1.Frame:WaitForChild("Infinite")
    t_1.StopwatchText = t_1.Frame:WaitForChild("Stopwatch")
    t_1.NumbersFrame = t_1.Frame:WaitForChild("Numbers")
    t_1.NumbersFullFrame = t_1.NumbersFrame:WaitForChild("Full")
    t_1.NumbersFullText = t_1.NumbersFullFrame:WaitForChild("Value")
    t_1.NumbersSecondsOnesFrame = t_1.NumbersFrame:WaitForChild("SecondsOnes")
    t_1.NumbersSecondsOnesText = t_1.NumbersSecondsOnesFrame:WaitForChild("Value")
    t_1.NumbersSecondsTensFrame = t_1.NumbersFrame:WaitForChild("SecondsTens")
    t_1.NumbersSecondsTensText = t_1.NumbersSecondsTensFrame:WaitForChild("Value")
    t_1.NumbersMinutesOnesFrame = t_1.NumbersFrame:WaitForChild("MinutesOnes")
    t_1.NumbersMinutesOnesText = t_1.NumbersMinutesOnesFrame:WaitForChild("Value")
    t_1.NumbersColonFrame = t_1.NumbersFrame:WaitForChild("Colon")
    t_1.NumbersColonText = t_1.NumbersColonFrame:WaitForChild("Value")
    t_1.NumbersIconFrame = t_1.NumbersFrame:WaitForChild("Icon")
    t_1.NumbersIconIcon = t_1.NumbersIconFrame:WaitForChild("Icon")
    t_1._destroyed = false
    t_1._is_visible = true
    t_1._time_remaining = 0
    t_1._countdown_hash = 0
    t_1._last4sec_sound = nil
    t_1._last10sec_sound = nil
    t_1._stopwatch_start = nil
    t_1._stopwatch_finish = nil
    t_1._stopwatch_connection = nil
    t_1:_Init()

    return t_1
end

function t.GetTimeRemaining(arg2) -- line: 53
    return arg2._time_remaining
end

function t.SetVisible(arg3, arg4) -- line: 57
    arg3._is_visible = arg4
    arg3:Update()
end

function t.Set(arg5, arg6) -- line: 63
    -- upvalues:
    --  [1] RunService (copy)

    local NumbersFrame = arg5.NumbersFrame
    NumbersFrame.Visible = arg6 ~= nil
    local InfiniteIcon = arg5.InfiniteIcon
    InfiniteIcon.Visible = arg6 == nil
    arg5._countdown_hash += 1

    if not arg6 then
        arg5:_ClearSounds()

        return
    end

    local CountdownHash = arg5._countdown_hash
    local now = tick()

    while true do
        if CountdownHash ~= arg5._countdown_hash or not (arg6 > tick() - now) then
            break
        end

        arg5:_SetText(arg6 - (tick() - now))
        RunService.RenderStepped:Wait()
    end

    if CountdownHash ~= arg5._countdown_hash then
        return
    end

    arg5:_SetText(0)
end

function t.Pause(arg7, arg8) -- line: 92
    arg7._countdown_hash += 1

    if arg8 then
        arg7:_SetText(arg8)
    end

    arg7:_ClearSounds()
end

function t.UpdateSizeAndPosition(arg9) -- line: 102
    -- upvalues:
    --  [1] Players (copy)

    local v3 = if arg9.DuelInterface.ClientDuel:Get("ScoresBehavior") == "Duelers" then not arg9.DuelInterface.ClientDuel:Get(
        "VoteOptions"
    ) else false
    local v4 = v3 and UDim2.new(0.5, 0, 0.03, 7.5) or UDim2.new(0.5, 0, 0.04, 10)
    local v5 = v3 and UDim2.new(0.075, 30, 0.0375, 15) or UDim2.new(0.1, 40, 0.05, 20)

    if arg9.Frame:IsDescendantOf(Players) then
        arg9.Frame:TweenSizeAndPosition(
            v5,
            v4,
            "Out",
            "Quint",
            0.25,
            true
        )

        return
    end

    arg9.Frame.Size = v5
    arg9.Frame.Position = v4
end

function t.StopwatchStart(arg10) -- line: 115
    -- upvalues:
    --  [1] RunService (copy)

    arg10:StopwatchFinish()
    arg10.InfiniteIcon.Position = UDim2.new(0.5, 0, 0.4, 0)
    arg10.NumbersFrame.Position = UDim2.new(0.5, 0, 0.4, 0)
    arg10._stopwatch_start = tick()
    arg10._stopwatch_finish = nil
    arg10._stopwatch_connection = RunService.RenderStepped:Connect(function() -- line: 124
        -- upvalues:
        --  [1] arg10 (copy)

        arg10.StopwatchText.Text = string.format("%.3f", tick() - arg10._stopwatch_start)
    end)
end

function t.StopwatchFinish(arg11, arg12) -- line: 129
    arg11._stopwatch_start = nil
    arg11._stopwatch_finish = arg12

    if arg11._stopwatch_connection then
        arg11._stopwatch_connection:Disconnect()
        arg11._stopwatch_connection = nil
    end

    local StopwatchText_1 = arg11.StopwatchText
    StopwatchText_1.Text = arg11._stopwatch_finish and string.format(
        "%.3f",
        arg11._stopwatch_finish
    ) or ""
end

function t.ClearStopwatch(arg13) -- line: 141
    arg13:StopwatchFinish()
    arg13.InfiniteIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
    arg13.NumbersFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
end

function t.Update(arg14) -- line: 147
    local v7 = arg14._is_visible
    local Frame = arg14.Frame

    if v7 then
        v7 = not arg14.DuelInterface:IsPageOpen()

        if v7 then
            v7 = not arg14.DuelInterface.ClientDuel:Get("HideMostDuelInterfaceElements")
        end
    end

    Frame.Visible = v7
end

function t.Destroy(arg15) -- line: 151
    arg15._destroyed = true
    arg15._countdown_hash += 1
    arg15.TimerChanged:Destroy()
    arg15:ClearStopwatch()
    arg15:_ClearSounds()
end

function t._UpdateLayouts(arg16) -- line: 163
    arg16.NumbersFullFrame.Size = UDim2.new(0.1, arg16.NumbersFullText.TextBounds.X, 0.6, 0)
end

function t._ClearSounds(arg17) -- line: 167
    if arg17._last4sec_sound then
        arg17._last4sec_sound:Destroy()
        arg17._last4sec_sound = nil
    end

    if arg17._last10sec_sound then
        arg17._last10sec_sound:Destroy()
        arg17._last10sec_sound = nil
    end
end

function t._SetText(arg18, arg19) -- line: 179
    -- upvalues:
    --  [1] Utility_m (copy)

    arg18._time_remaining = math.max(0, arg19)
    arg18.TimerChanged:Fire(arg18._time_remaining)
    local ceiling = math.ceil(arg18._time_remaining)
    local v8 = arg18._time_remaining <= 0.05 and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(
        255,
        255,
        255
    )
    local v9 = arg18._time_remaining < 10 and true
    local v10 = Utility_m:TimeFormat(ceiling)
    arg18.NumbersFullFrame.Visible = false
    arg18.NumbersSecondsOnesFrame.Visible = not v9
    arg18.NumbersSecondsTensFrame.Visible = true
    arg18.NumbersMinutesOnesFrame.Visible = true
    arg18.NumbersColonFrame.Visible = true
    local NumbersFullText = arg18.NumbersFullText
    NumbersFullText.Text = if v9 then string.format("%.1f", (math.abs(arg18._time_remaining))) else v10
    arg18.NumbersSecondsOnesText.Text = ceiling % 10
    arg18.NumbersSecondsTensText.Text = if v9 then math.floor(arg18._time_remaining % 1 * 10) else math.floor(
        ceiling % 60 / 10
    )
    arg18.NumbersMinutesOnesText.Text = if v9 then math.floor(arg18._time_remaining % 10) else math.floor(
        ceiling / 60
    ) % 10
    arg18.NumbersColonText.Text = if v9 then "." else ":"
    arg18.NumbersFullText.TextColor3 = v8
    arg18.NumbersSecondsOnesText.TextColor3 = v8
    arg18.NumbersSecondsTensText.TextColor3 = v8
    arg18.NumbersColonText.TextColor3 = v8
    arg18.NumbersMinutesOnesText.TextColor3 = v8
    arg18.NumbersIconIcon.ImageColor3 = v8

    if arg18._time_remaining <= 4 then
        if not arg18._last4sec_sound and arg18.DuelInterface.ClientDuel:Get("Status") == "RoundStarted" then
            arg18._last4sec_sound = arg18.DuelInterface:CreateSound(
                "rbxassetid://17826390328",
                1.25,
                1,
                script,
                true,
                15
            )

            return
        end
    elseif arg18._time_remaining <= 10 then
        if
            not arg18._last10sec_sound
            and arg18.DuelInterface.ClientDuel:Get("Status") == "RoundStarted"
        then
            arg18._last10sec_sound = arg18.DuelInterface:CreateSound(
                "rbxassetid://17826470563",
                0.5,
                1,
                script,
                true,
                15
            )

            return
        end
    else
        arg18:_ClearSounds()
    end
end

function t._Init(arg20) -- line: 220
    arg20.NumbersFullText:GetPropertyChangedSignal("TextBounds"):Connect(function() -- line: 221
        -- upvalues:
        --  [1] arg20 (copy)

        arg20:_UpdateLayouts()
    end)
    arg20:_UpdateLayouts()
    arg20:UpdateSizeAndPosition()
    arg20:ClearStopwatch()
    task.defer(arg20._SetText, arg20, 0)
end

return t
