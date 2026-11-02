return function(arg1, arg2, arg3) -- line: 1
    if not arg1:_AnimationWait(script.Name, arg3, 1.45 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://110122962237431",
        1.25,
        1.5 + 0.1 * math.random(),
        true,
        5
    )
    arg1:CreateSound(
        "rbxassetid://71387264231358",
        0.75,
        1,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.4 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://96253147006478",
        0.5,
        0.8,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.7 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://110122962237431",
        1.25,
        1 + 0.1 * math.random(),
        true,
        5
    )
    arg1:CreateSound(
        "rbxassetid://71387264231358",
        0.75,
        1,
        true,
        10
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
    arg1:CreateSound(
        "rbxassetid://96253147006478",
        0.5,
        0.8,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.25 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://96253147006478",
        0.375,
        1,
        true,
        10
    )
end
