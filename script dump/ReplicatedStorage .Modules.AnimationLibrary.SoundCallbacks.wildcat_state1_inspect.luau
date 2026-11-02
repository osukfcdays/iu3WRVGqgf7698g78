return function(arg1, arg2, arg3) -- line: 1
    if not arg1:_AnimationWait(script.Name, arg3, 1.6 / arg2) then
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
        "rbxassetid://13158735106",
        0.125,
        2,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.2 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://13158330555",
        1,
        1,
        true,
        10
    )
    arg1:CreateSound(
        "rbxassetid://13236549962",
        1,
        2,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 1.3 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://13158735106",
        0.2,
        1.75,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 1.75 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://13158735106",
        0.125,
        2,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.8 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://13158330555",
        1,
        1.5,
        true,
        10
    )
end
