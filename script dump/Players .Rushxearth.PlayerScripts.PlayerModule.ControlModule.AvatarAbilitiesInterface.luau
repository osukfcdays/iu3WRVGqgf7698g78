if require(script.Parent.Parent:WaitForChild("CommonUtils"):WaitForChild("FlagUtil")).getUserFlag(
    "UserAllowAbilityControls"
) then
    local Players = game:GetService("Players")
    local t = {}
    local v3 = nil
    local v4 = nil
    local BindableEvent = Instance.new("BindableEvent")
    local v7 = nil
    local v8 = false

    local function characterAdded(arg1) -- line: 16
        -- upvalues:
        --  [1] v3 (ref)
        --  [2] v4 (ref)
        --  [3] v7 (ref)
        --  [4] BindableEvent (copy)

        v3 = nil
        v4 = nil

        if v7 then
            v7:Disconnect()
            v7 = nil
        end

        if arg1 then
            v3 = arg1:FindFirstChild("AbilityManagerActor")
            v4 = arg1:FindFirstChildOfClass("Humanoid")

            while true do
                if v4 then
                    break
                end

                arg1.ChildAdded:wait()
                v4 = arg1:FindFirstChildOfClass("Humanoid")
            end

            BindableEvent:Fire()
            v7 = v4:GetPropertyChangedSignal("EvaluateStateMachine"):Connect(function() -- line: 33
                -- upvalues:
                --  [1] BindableEvent (ref)

                BindableEvent:Fire()
            end)
        end
    end

    local _ = function() --[[ lazyInit ]] -- line: 39
        -- upvalues:
        --  [1] v8 (ref)
        --  [2] Players (copy)
        --  [3] characterAdded (copy)

        if v8 then
            return
        end

        v8 = true
        local LocalPlayer = Players.LocalPlayer

        if LocalPlayer then
            LocalPlayer.characterAdded:Connect(characterAdded)

            if LocalPlayer.Character then
                characterAdded(LocalPlayer.Character)
            end
        end
    end

    function t.isEnabled() -- line: 54
        -- upvalues:
        --  [1] v8 (ref)
        --  [2] Players (copy)
        --  [3] characterAdded (copy)
        --  [4] v3 (ref)
        --  [5] v4 (ref)

        local v9

        if not v8 then
            v8 = true
            v9 = Players.LocalPlayer

            if v9 then
                v9.characterAdded:Connect(characterAdded)

                if v9.Character then
                    characterAdded(v9.Character)
                end
            end
        end

        v9 = if v3 == nil then false else v4 and not v4.EvaluateStateMachine

        return v9
    end

    function t.GetEnabledChangedSignal() -- line: 59
        -- upvalues:
        --  [1] v8 (ref)
        --  [2] Players (copy)
        --  [3] characterAdded (copy)
        --  [4] BindableEvent (copy)

        if not v8 then
            v8 = true
            local LocalPlayer_1 = Players.LocalPlayer

            if LocalPlayer_1 then
                LocalPlayer_1.characterAdded:Connect(characterAdded)

                if LocalPlayer_1.Character then
                    characterAdded(LocalPlayer_1.Character)
                end
            end
        end

        return BindableEvent.Event
    end

    return t
end
