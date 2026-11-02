return function(arg1, arg2, arg3) -- line: 1
    if not arg1:_AnimationWait(script.Name, arg3, 2.7 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://13158735106",
        0.25,
        1.5,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.25 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://13158735106",
        0.125,
        1.25,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 1 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://17640978498",
        0.75,
        1.3,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.4 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://17640978498",
        0.625,
        1.35,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.35 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://17640978498",
        0.4,
        1.4,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.45 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://17640978498",
        1,
        1,
        true,
        10
    )
end
