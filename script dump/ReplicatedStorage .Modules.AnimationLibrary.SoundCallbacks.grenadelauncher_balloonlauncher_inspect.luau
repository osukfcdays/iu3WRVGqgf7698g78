return function(arg1, arg2, arg3) -- line: 1
    if not arg1:_AnimationWait(script.Name, arg3, 2.2 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://17274387490",
        0.375,
        1,
        true,
        10
    )
    arg1:CreateSound(
        "rbxassetid://17803360572",
        1,
        2.5 + 0.25 * math.random(),
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.7 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://17274387490",
        0.25,
        0.9,
        true,
        10
    )
    arg1:CreateSound(
        "rbxassetid://17803360572",
        1,
        2 + 0.2 * math.random(),
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.25 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://13158735106",
        0.25,
        1.5,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 1.6 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://13158735106",
        0.2,
        1.25,
        true,
        10
    )
end
