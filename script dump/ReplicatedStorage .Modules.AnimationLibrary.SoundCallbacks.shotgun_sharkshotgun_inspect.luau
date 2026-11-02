return function(arg1, arg2, arg3) -- line: 1
    if not arg1:_AnimationWait(script.Name, arg3, 1.65 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://93644201634454",
        0.75,
        1 + 0.1 * math.random(),
        true,
        5
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.45 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://93644201634454",
        0.75,
        0.75 + 0.1 * math.random(),
        true,
        5
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.6 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://13158735106",
        0.25,
        1.5,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.4 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://93644201634454",
        0.375,
        0.875 + 0.05 * math.random(),
        true,
        5
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.35 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://93644201634454",
        0.375,
        0.875 + 0.05 * math.random(),
        true,
        5
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.55 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://93644201634454",
        0.75,
        1 + 0.1 * math.random(),
        true,
        5
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.75 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://13158735106",
        0.25,
        1.5,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.6 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://93644201634454",
        0.75,
        0.75 + 0.1 * math.random(),
        true,
        5
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.65 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://13158735106",
        0.25,
        1.5,
        true,
        10
    )
end
