local DuelScoresChatBubble = game:GetService("Players").LocalPlayer.PlayerScripts.UserInterface:WaitForChild(
    "DuelScoresChatBubble"
)
local t = {}
t.__index = t

function t.new(arg1) -- line: 9
    -- upvalues:
    --  [1] t (copy)

    local t_1 = setmetatable({}, t)
    t_1.Scores = arg1
    t_1._chat_bubble_layout_order = 0
    t_1._chat_messages = {}
    t_1:_Init()

    return t_1
end

function t.NewChatMessage(arg2, arg3, arg4) -- line: 26
    -- upvalues:
    --  [1] DuelScoresChatBubble (copy)

    arg2._chat_bubble_layout_order += 1
    local v1 = DuelScoresChatBubble:Clone()
    v1.ZIndex = -arg2._chat_bubble_layout_order
    v1.LayoutOrder = arg2._chat_bubble_layout_order
    v1.Title.Text = arg4

    local function update() -- line: 34
        -- upvalues:
        --  [1] v1 (copy)

        v1.Background.Size = UDim2.new(0.0375, v1.Title.TextBounds.X, 1, 0)
    end

    v1.Title:GetPropertyChangedSignal("TextBounds"):Connect(update)
    v1.AncestryChanged:Connect(update)
    v1.Background.Size = UDim2.new(0.0375, v1.Title.TextBounds.X, 1, 0)
    local t_2 = { Player = arg3, Frame = v1 }
    table.insert(arg2._chat_messages, 1, t_2)
    arg2:_UpdateParent(t_2)
    local v2 = 0

    for key, val in pairs(arg2._chat_messages) do
        if val.Player == arg3 then
            v2 += 1

            if v2 > 4 then
                val.Frame:Destroy()
                table.remove(arg2._chat_messages, key)
                break
            end
        end
    end

    task.delay(7, function() -- line: 64
        -- upvalues:
        --  [1] v1 (copy)
        --  [2] arg2 (copy)
        --  [3] t_2 (copy)

        v1:Destroy()
        local index = table.find(arg2._chat_messages, t_2)

        if index then
            table.remove(arg2._chat_messages, index)
        end
    end)
end

function t.Hide(arg5) -- line: 75
    for _, val_1 in pairs(arg5._chat_messages) do
        val_1.Frame.Parent = nil
    end
end

function t.Show(arg6) -- line: 81
    for _, val_2 in pairs(arg6._chat_messages) do
        arg6:_UpdateParent(val_2)
    end
end

function t.Destroy(arg7) -- line: 87
    for _, val_3 in pairs(arg7._chat_messages) do
        val_3.Frame:Destroy()
    end

    arg7._chat_messages = {}
end

function t._UpdateParent(arg8, arg9) -- line: 99
    arg9.Frame.Parent = arg8.Scores:GetChatBubbleContainer(arg9.Player)
end

function t._Init(_) -- line: 103
end

return t
