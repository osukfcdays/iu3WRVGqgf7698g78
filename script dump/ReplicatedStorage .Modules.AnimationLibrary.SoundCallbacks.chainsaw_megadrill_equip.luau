return function(arg1, arg2, arg3) -- line: 1
    local v1 = arg1:CreateSound("rbxassetid://13645858587", 0.375, 1, true)

    if v1 then
        v1.Looped = true
    end

    local v2 = arg1:CreateSound("rbxassetid://13646484249", 0.375, 1, true)

    if v2 then
        v2.Looped = true
    end

    local v3 = arg1:CreateSound("rbxassetid://13646484113", 0.25, 1, true)

    if v3 then
        v3.Looped = true
    end

    if not arg1:_AnimationWait(script.Name, arg3, 0.25 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://17247639614",
        0.75,
        1 + 0.1 * math.random(),
        true,
        10
    )
end
