return function(arg1, arg2, arg3) -- line: 1
    if not arg1:_AnimationWait(script.Name, arg3, 2 / arg2) then
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
        "rbxassetid://110122962237431",
        1.25,
        1.25 + 0.25 * math.random(),
        true,
        5
    )

    if not arg1:_AnimationWait(script.Name, arg3, 3 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://13456860578",
        1.25,
        1.25,
        true,
        10
    )
    arg1:CreateSound(
        "rbxassetid://110122962237431",
        1.25,
        1.25 + 0.25 * math.random(),
        true,
        5
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.45 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://13456860578",
        1,
        1.5,
        true,
        10
    )
    arg1:CreateSound(
        "rbxassetid://110122962237431",
        1.25,
        1.25 + 0.25 * math.random(),
        true,
        5
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.4 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://13456860578",
        0.75,
        1.75,
        true,
        10
    )
    arg1:CreateSound(
        "rbxassetid://110122962237431",
        1.25,
        1.25 + 0.25 * math.random(),
        true,
        5
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.4 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://13456860578",
        0.25,
        1,
        true,
        10
    )
    arg1:CreateSound(
        "rbxassetid://110122962237431",
        1.25,
        1.25 + 0.25 * math.random(),
        true,
        5
    )

    if not arg1:_AnimationWait(script.Name, arg3, 1.5 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://96253147006478",
        0.625,
        0.9,
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
end
