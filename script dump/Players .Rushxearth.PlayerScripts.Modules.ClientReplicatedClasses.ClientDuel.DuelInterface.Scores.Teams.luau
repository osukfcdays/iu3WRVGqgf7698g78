local ScoreNeeded_m = require(script:WaitForChild("ScoreNeeded"))
local Classic_m = require(script:WaitForChild("Classic"))
local t = {}
t.__index = t

function t.new(arg1) -- line: 7
    -- upvalues:
    --  [1] t (copy)
    --  [2] ScoreNeeded_m (copy)
    --  [3] Classic_m (copy)

    local t_1 = setmetatable({}, t)
    t_1.Scores = arg1
    t_1.Frame = t_1.Scores.Frame:WaitForChild("Teams")
    t_1.LeftFrame = t_1.Frame:WaitForChild("Left")
    t_1.RightFrame = t_1.Frame:WaitForChild("Right")
    t_1.ScoreNeeded = ScoreNeeded_m.new(t_1)
    t_1.Classic = Classic_m.new(t_1)
    t_1:_Init()

    return t_1
end

function t.GetChatBubbleContainer(arg2, arg3) -- line: 27
    return arg2.ScoreNeeded:GetChatBubbleContainer(arg3) or arg2.Classic:GetChatBubbleContainer(
        arg3
    )
end

function t.Generate(arg4) -- line: 32
    arg4.ScoreNeeded:Generate()
    arg4.Classic:Generate()
end

function t.Destroy(arg5) -- line: 37
    arg5.ScoreNeeded:Destroy()
    arg5.Classic:Destroy()
end

function t._Init(_) -- line: 46
end

return t
