local Players = game:GetService("Players")
local _ = {
    LOCAL_PLAYER = "LOCAL_PLAYER",
    ON_LOCAL_PLAYER = "ON_LOCAL_PLAYER",
    CHARACTER_ADDED = "CHARACTER_ADDED",
    ON_CHARACTER = "ON_CHARACTER",
    CHARACTER_CHILD_ADDED = "CHARACTER_CHILD_ADDED"
}
local t_1 = {
    _connectionUtil = require(script.Parent:WaitForChild("ConnectionUtil")).new(),
    _boundEvents = {},
    getLocalPlayer = function() --[[ getLocalPlayer ]] -- line: 53
        -- upvalues:
        --  [1] Players (copy)

        return Players.LocalPlayer
    end
}

function t_1.onLocalPlayer(arg1) -- line: 57
    -- upvalues:
    --  [1] t_1 (copy)
    --  [2] Players (copy)

    local v1 = t_1.getLocalPlayer()

    if v1 then
        arg1(v1)
    end

    t_1._connectionUtil:trackConnection("LOCAL_PLAYER", Players:GetPropertyChangedSignal(
        "LocalPlayer"
    ):Connect(function() -- line: 66
        -- upvalues:
        --  [1] t_1 (ref)

        local v2 = t_1.getLocalPlayer()
        assert(v2)
        t_1._getOrCreateBoundEvent("LOCAL_PLAYER"):Fire(v2)
    end))

    return t_1._getOrCreateBoundEvent("LOCAL_PLAYER").Event:Connect(arg1)
end

function t_1.getCharacter() -- line: 77
    -- upvalues:
    --  [1] t_1 (copy)

    local v3 = t_1.getLocalPlayer()

    if not v3 then
        return nil
    end

    return v3.Character
end

function t_1.onCharacter(arg2) -- line: 85
    -- upvalues:
    --  [1] t_1 (copy)

    t_1._connectionUtil:trackConnection("ON_LOCAL_PLAYER", t_1.onLocalPlayer(function(arg3) -- line: 89
        -- upvalues:
        --  [1] t_1 (ref)
        --  [2] arg2 (copy)

        local v4 = t_1.getCharacter()

        if v4 then
            arg2(v4)
        end

        t_1._connectionUtil:trackConnection("CHARACTER_ADDED", arg3.CharacterAdded:Connect(function(
            character: Model
        ) -- line: 98
            -- upvalues:
            --  [1] t_1 (ref)

            assert(character)
            t_1._getOrCreateBoundEvent("CHARACTER_ADDED"):Fire(character)
        end))
    end))

    return t_1._getOrCreateBoundEvent("CHARACTER_ADDED").Event:Connect(arg2)
end

function t_1.getChild(s1: string, s2: string) -- line: 110
    -- upvalues:
    --  [1] t_1 (copy)

    local v5 = t_1.getCharacter()

    if not v5 then
        return nil
    end

    local v6 = v5:FindFirstChild(s1)

    if v6 and v6:IsA(s2) then
        return v6
    end

    return nil
end

function t_1.onChild(s3: string, s4: string, arg5: any) -- line: 122
    -- upvalues:
    --  [1] t_1 (copy)

    t_1._connectionUtil:trackConnection("ON_CHARACTER", t_1.onCharacter(function(arg6) -- line: 126
        -- upvalues:
        --  [1] t_1 (ref)
        --  [2] s3 (copy)
        --  [3] s4 (copy)
        --  [4] arg5 (copy)

        local v7 = t_1.getChild(s3, s4)

        if v7 then
            arg5(v7)
        end

        t_1._connectionUtil:trackConnection("CHARACTER_CHILD_ADDED", arg6.ChildAdded:Connect(function(
            child: Instance
        ) -- line: 135
            -- upvalues:
            --  [1] s3 (ref)
            --  [2] s4 (ref)
            --  [3] t_1 (ref)

            if child.Name == s3 and child:IsA(s4) then
                t_1._getOrCreateBoundEvent("CHARACTER_CHILD_ADDED" .. s3 .. s4):Fire(child)
            end
        end))
    end))

    return t_1._getOrCreateBoundEvent("CHARACTER_CHILD_ADDED" .. s3 .. s4).Event:Connect(arg5)
end

function t_1._getOrCreateBoundEvent(s5: string) -- line: 149
    -- upvalues:
    --  [1] t_1 (copy)

    if not t_1._boundEvents[s5] then
        t_1._boundEvents[s5] = Instance.new("BindableEvent")
    end

    return t_1._boundEvents[s5]
end

return t_1
