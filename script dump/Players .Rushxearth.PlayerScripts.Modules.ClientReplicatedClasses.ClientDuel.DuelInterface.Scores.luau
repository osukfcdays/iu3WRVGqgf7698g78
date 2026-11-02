local ChatBubbles_m = require(script:WaitForChild("ChatBubbles"))
local Duelers_m = require(script:WaitForChild("Duelers"))
local Teams_m = require(script:WaitForChild("Teams"))
local t = {}
t.__index = t

function t.new(arg1) -- line: 8
    -- upvalues:
    --  [1] t (copy)
    --  [2] ChatBubbles_m (copy)
    --  [3] Duelers_m (copy)
    --  [4] Teams_m (copy)

    local t_1 = setmetatable({}, t)
    t_1.DuelInterface = arg1
    t_1.Frame = t_1.DuelInterface.Frame:WaitForChild("Top"):WaitForChild("Scores")
    t_1.ChatBubbles = ChatBubbles_m.new(t_1)
    t_1.Duelers = Duelers_m.new(t_1)
    t_1.Teams = Teams_m.new(t_1)
    t_1._is_visible = true
    t_1:_Init()

    return t_1
end

function t.GetChatBubbleContainer(arg2, arg3) -- line: 29
    return arg2.Duelers:GetChatBubbleContainer(arg3) or arg2.Teams:GetChatBubbleContainer(arg3)
end

function t.SetVisible(arg4, arg5) -- line: 34
    arg4._is_visible = arg5
    arg4:UpdateVisibility()
end

function t.UpdateVisibility(arg6) -- line: 39
    local v5 = arg6._is_visible
    local Frame = arg6.Frame

    if v5 then
        v5 = not arg6.DuelInterface:IsPageOpen()

        if v5 then
            v5 = not arg6.DuelInterface.ClientDuel:Get("HideMostDuelInterfaceElements")
        end
    end

    Frame.Visible = v5
end

function t.NewChatMessage(arg7, ...) -- line: 43
    arg7.ChatBubbles:NewChatMessage(...)
end

function t.Generate(arg8) -- line: 47
    arg8.ChatBubbles:Hide()
    arg8.Duelers:Generate()
    arg8.Teams:Generate()
    arg8.ChatBubbles:Show()
end

function t.Destroy(arg9) -- line: 54
    arg9.ChatBubbles:Destroy()
    arg9.Duelers:Destroy()
    arg9.Teams:Destroy()
end

function t._Init(_) -- line: 64
end

return t
