local t = {}
t.__index = t

function t.new(arg1) -- line: 4
    -- upvalues:
    --  [1] t (copy)

    local t_1 = setmetatable({}, t)
    t_1.ClientFighterCharacter = arg1
    t_1._chat_bubble_mover = Instance.new("Part")
    t_1._chat_bubble_mover_weld = nil
    t_1:_Init()

    return t_1
end

function t.Update(_, _, _) -- line: 21
end

function t.Destroy(arg5) -- line: 25
    if arg5._chat_bubble_mover then
        arg5._chat_bubble_mover:Destroy()
    end
end

function t._Update(arg6) -- line: 35
    if arg6._destroyed then
        return
    end

    local v1 = arg6.ClientFighterCharacter.ClientFighter:Get("IsMatchmaking")

    if if not v1 then not v1 and not arg6._chat_bubble_mover.Parent else arg6._chat_bubble_mover.Parent or not v1 and not arg6._chat_bubble_mover.Parent then
        return
    end

    pcall(function() -- line: 48
        -- upvalues:
        --  [1] arg6 (copy)
        --  [2] v1 (copy)

        local ChatBubbleMover = arg6._chat_bubble_mover
        ChatBubbleMover.Parent = v1 and arg6.ClientFighterCharacter.RootPart or nil
    end)

    if v1 then
        if arg6._chat_bubble_mover_weld then
            arg6._chat_bubble_mover_weld:Destroy()
        end

        arg6._chat_bubble_mover.CFrame = arg6.ClientFighterCharacter.RootPart.CFrame + Vector3.new(0, 5, 0)
        arg6._chat_bubble_mover_weld = Instance.new("WeldConstraint")
        arg6._chat_bubble_mover_weld.Part0 = arg6.ClientFighterCharacter.RootPart
        arg6._chat_bubble_mover_weld.Part1 = arg6._chat_bubble_mover
        arg6._chat_bubble_mover_weld.Parent = arg6._chat_bubble_mover
    end
end

function t._SafeUpdate(arg7) -- line: 67
    task.defer(arg7._Update, arg7)
end

function t._Setup(arg8) -- line: 71
    arg8._chat_bubble_mover.CanCollide = false
    arg8._chat_bubble_mover.CanTouch = false
    arg8._chat_bubble_mover.CanQuery = false
    arg8._chat_bubble_mover.Massless = true
    arg8._chat_bubble_mover.Transparency = 1
    arg8._chat_bubble_mover.Size = Vector3.new(1, 1, 1)
end

function t._Init(arg9) -- line: 80
    arg9.ClientFighterCharacter:AddConnection(arg9.ClientFighterCharacter.ClientFighter:GetDataChangedSignal(
        "IsMatchmaking"
    ):Connect(function() -- line: 81
        -- upvalues:
        --  [1] arg9 (copy)

        arg9:_SafeUpdate()
    end))
    arg9:_Setup()
    arg9:_SafeUpdate()
end

return t
