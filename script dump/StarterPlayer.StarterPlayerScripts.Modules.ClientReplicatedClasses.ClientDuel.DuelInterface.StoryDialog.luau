local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local CONSTANTS_m = require(ReplicatedStorage.Modules.CONSTANTS)
local DuelLibrary_m = require(ReplicatedStorage.Modules.DuelLibrary)
local t = {}
t.__index = t

function t.new(arg1) -- line: 10
    -- upvalues:
    --  [1] t (copy)

    local t_1 = setmetatable({}, t)
    t_1.DuelInterface = arg1
    t_1.Frame = t_1.DuelInterface.Frame:WaitForChild("Top"):WaitForChild("StoryDialog")
    t_1.Container = t_1.Frame:WaitForChild("Container")
    t_1.RightSpeakerFrame = t_1.Container:WaitForChild("RightSpeaker")
    t_1.RightSpeakerImage = t_1.RightSpeakerFrame:WaitForChild("Player"):WaitForChild("Headshot")
    t_1.LeftSpeakerFrame = t_1.Container:WaitForChild("LeftSpeaker")
    t_1.LeftSpeakerImage = t_1.LeftSpeakerFrame:WaitForChild("Player"):WaitForChild("Headshot")
    t_1.Message = t_1.Container:WaitForChild("Message")
    t_1._destroyed = false
    t_1._is_playing_story = false
    t_1._already_played = {}
    t_1._random = Random.new(t_1.DuelInterface.ClientDuel:Get("DuelSeed"))
    t_1:_Init()

    return t_1
end

function t.CreateSound(arg2, ...) -- line: 36
    local v1 = arg2.Frame.Visible

    if v1 then
        v1 = arg2.Container.Visible

        if v1 then
            v1 = arg2.DuelInterface:CreateSound(...)
        end
    end

    return v1
end

function t.Update(arg3) -- line: 40
    local Frame = arg3.Frame
    local v2 = not arg3.DuelInterface.Scoreboard:IsOpen()

    if v2 then
        v2 = not arg3.DuelInterface:IsPageOpen()

        if v2 then
            v2 = not arg3.DuelInterface.RoundResult.Frame.Visible
        end
    end

    Frame.Visible = v2

    if arg3.DuelInterface.ClientDuel:Get("Status") == "RoundStarted" then
        task.spawn(arg3._AttemptToPlayStory, arg3)
    end
end

function t.Destroy(arg4) -- line: 48
    arg4._destroyed = true
end

function t._GetRandomSpeaker(arg5, ...) -- line: 56
    local t_2 = { ... }
    local t_3 = {}

    for _, val in pairs(arg5.DuelInterface.ClientDuel.Duelers) do
        if val.Player and not table.find(t_2, val.Player) then
            table.insert(t_3, val.Player)
        end
    end

    table.sort(t_3, function(arg6, arg7) -- line: 66
        return arg6.UserId < arg7.UserId
    end)

    if #t_3 == 0 then
        return nil
    end

    return t_3[arg5._random:NextInteger(1, #t_3)]
end

function t._PlayDialog(arg8, arg9, arg10) -- line: 73
    -- upvalues:
    --  [1] Players (copy)
    --  [2] CONSTANTS_m (copy)

    arg8._is_playing_story = true
    arg8.Container.Visible = true
    arg8.Container.Size = UDim2.new(1, 0, 1, 0)
    arg8:CreateSound(
        "rbxassetid://105553937408843",
        1,
        1,
        script,
        true,
        10
    )

    for key_1, val_1 in pairs(arg10) do
        if arg8._destroyed then
            return
        end

        task.delay(
            if key_1 ~= 1 then 0 else 0.5,
            arg8.CreateSound,
            arg8,
            "rbxassetid://124144337176625",
            1,
            0.9 + 0.2 * math.random(),
            script,
            true,
            10
        )

        if arg8.Container:IsDescendantOf(Players.LocalPlayer.PlayerGui) then
            arg8.Container.Size = UDim2.new(1.1, 0, 1.1, 0)
            arg8.Container:TweenSize(
                UDim2.new(1, 0, 1, 0),
                "Out",
                "Quint",
                0.25,
                true
            )
        end

        arg8.Message.Text = val_1.Message
        local RightSpeakerFrame = arg8.RightSpeakerFrame
        local v6 = table.find(arg9, val_1.Speaker) == 1
        RightSpeakerFrame.Visible = v6
        arg8.RightSpeakerImage.Image = string.format(
            CONSTANTS_m.HEADSHOT_IMAGE,
            val_1.Speaker.UserId
        )
        arg8.LeftSpeakerImage.Image = arg8.RightSpeakerImage.Image
        arg8.LeftSpeakerFrame.Visible = not arg8.RightSpeakerFrame.Visible
        wait(val_1.WaitBeforeMovingOn)
    end

    if arg8.Container:IsDescendantOf(Players.LocalPlayer.PlayerGui) then
        arg8:CreateSound(
            "rbxassetid://105553937408843",
            1,
            0.75,
            script,
            true,
            10
        )
        arg8.Container:TweenSize(
            UDim2.new(0.25, 0, 0.25, 0),
            "In",
            "Quint",
            0.25,
            true
        )
        wait(0.25)
    end

    arg8._is_playing_story = false
    arg8.Container.Visible = false
end

function t._ZombieTowerIntro(arg11) -- line: 111
    local v7 = arg11:_GetRandomSpeaker()
    local v8 = arg11:_GetRandomSpeaker(v7)

    if v7 and v8 then
        arg11:_PlayDialog(
            { v7, v8 },
            {
                {
                    Speaker = v7,
                    WaitBeforeMovingOn = 6,
                    Message = "This must be the tower our intel had us locate."
                },
                {
                    Speaker = v7,
                    WaitBeforeMovingOn = 6,
                    Message = "Let's find our way to the top and radio for rescue."
                },
                { Speaker = v8, WaitBeforeMovingOn = 4, Message = "Easier said than done!" },
                {
                    Speaker = v8,
                    WaitBeforeMovingOn = 6,
                    Message = "Do you see how tall it is? I can't even see the top!"
                },
                {
                    Speaker = v8,
                    WaitBeforeMovingOn = 6,
                    Message = "We're so dead. I really thought we had a chance."
                },
                { Speaker = v7, WaitBeforeMovingOn = 4, Message = "We do have a chance.\n" },
                {
                    Speaker = v7,
                    WaitBeforeMovingOn = 4,
                    Message = "Just stay focused. We've come too far to give up."
                },
                {
                    Speaker = v8,
                    WaitBeforeMovingOn = 6,
                    Message = "We're looking for a.. what? A radio? Then what?"
                },
                {
                    Speaker = v7,
                    WaitBeforeMovingOn = 6,
                    Message = "..then we hope for the best. Let's go!"
                }
            }
        )

        return
    end

    if v7 then
        arg11:_PlayDialog(
            { v7 },
            {
                {
                    Speaker = v7,
                    WaitBeforeMovingOn = 6,
                    Message = "This is it. This is the tower they told me to find."
                },
                {
                    Speaker = v7,
                    WaitBeforeMovingOn = 6,
                    Message = "I'm the only one left. I can't give up now."
                },
                {
                    Speaker = v7,
                    WaitBeforeMovingOn = 6,
                    Message = "All I need to do now is reach the top and.. radio for help."
                },
                {
                    Speaker = v7,
                    WaitBeforeMovingOn = 6,
                    Message = "No problem at all. No big deal.. I got this.."
                }
            }
        )

        return
    end
end

function t._GargoyleTowerIntro(arg12) -- line: 145
    local v9 = arg12:_GetRandomSpeaker()
    local v10 = arg12:_GetRandomSpeaker(v9)

    if v9 and v10 then
        arg12:_PlayDialog(
            { v9, v10 },
            {
                {
                    Speaker = v9,
                    WaitBeforeMovingOn = 6,
                    Message = "The intel was right, that crack at the base of the tower is the only way in."
                },
                {
                    Speaker = v10,
                    WaitBeforeMovingOn = 6,
                    Message = "This is scarier than last time, this better be our way out."
                },
                {
                    Speaker = v9,
                    WaitBeforeMovingOn = 6,
                    Message = "Our Warper is toast, going up is our only route back to the rest of the squad."
                },
                {
                    Speaker = v10,
                    WaitBeforeMovingOn = 6,
                    Message = "They said the last team set rendezvous for the top of the tower, they left a radio."
                },
                {
                    Speaker = v9,
                    WaitBeforeMovingOn = 6,
                    Message = "Good, I want out of this place."
                },
                {
                    Speaker = v10,
                    WaitBeforeMovingOn = 6,
                    Message = "I don't understand how this tower resembles Headquarters at all.."
                },
                {
                    Speaker = v9,
                    WaitBeforeMovingOn = 6,
                    Message = "Don't mind that, nothing's left of what was before. This dimension has already reached their apocalypse."
                },
                {
                    Speaker = v10,
                    WaitBeforeMovingOn = 6,
                    Message = "Whatever. Let's get out of here!"
                }
            }
        )

        return
    end

    if v9 then
        arg12:_PlayDialog(
            { v9 },
            {
                {
                    Speaker = v9,
                    WaitBeforeMovingOn = 6,
                    Message = "This is it, the last team set rendezvous for the top of the tower."
                },
                {
                    Speaker = v9,
                    WaitBeforeMovingOn = 6,
                    Message = "I'm what's left of my squad, my Warper is broken, no easy way back."
                },
                {
                    Speaker = v9,
                    WaitBeforeMovingOn = 6,
                    Message = "I need to get back to base. I've got all the data that's needed, the only way out is up.. "
                },
                {
                    Speaker = v9,
                    WaitBeforeMovingOn = 6,
                    Message = "This is no different than last year. I've got this.. I'm so close to the end.."
                }
            }
        )

        return
    end
end

function t._AttemptToPlayStory(arg13) -- line: 178
    -- upvalues:
    --  [1] DuelLibrary_m (copy)

    if arg13._is_playing_story then
        return
    end

    local v11 = arg13.DuelInterface.ClientDuel:Get("PlaySourceName")
    local v12 = v11

    if v12 then
        v12 = DuelLibrary_m.PlaySources[v11].DuelLogic
    end

    local function play_story(arg14, arg15, ...) -- line: 186
        -- upvalues:
        --  [1] arg13 (copy)

        if arg13._already_played[arg14] then
            return
        end

        arg13._already_played[arg14] = true
        task.spawn(arg15, ...)
    end

    if v12 == "Zombie Tower" then
        play_story("zombietower_intro", arg13._ZombieTowerIntro, arg13)

        return
    end

    if v12 == "Gargoyle Tower" then
        play_story("gargoyletower_intro", arg13._GargoyleTowerIntro, arg13)
    end
end

function t._Init(arg16) -- line: 202
    arg16.DuelInterface.RoundResult.Frame:GetPropertyChangedSignal("Visible"):Connect(function() -- line: 203
        -- upvalues:
        --  [1] arg16 (copy)

        arg16:Update()
    end)
    arg16.DuelInterface.Scoreboard.VisibilityChanged:Connect(function() -- line: 207
        -- upvalues:
        --  [1] arg16 (copy)

        arg16:Update()
    end)
end

return t
