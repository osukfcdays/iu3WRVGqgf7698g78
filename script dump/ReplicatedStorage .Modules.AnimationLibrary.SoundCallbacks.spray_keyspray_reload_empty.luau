return function(arg1, arg2, arg3) -- line: 1
    if not arg1:_AnimationWait(script.Name, arg3, 0.4 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://13158330555",
        1,
        1.25,
        true,
        10
    )
    arg1:CreateSound(
        "rbxassetid://110122962237431",
        1,
        1.1 + 0.1 * math.random(),
        true,
        5
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.55 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://96253147006478",
        0.625,
        0.9,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.55 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://84163808107137",
        1,
        1,
        true,
        10
    )
    arg1:CreateSound(
        "rbxassetid://110122962237431",
        1,
        1.1 + 0.1 * math.random(),
        true,
        5
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.25 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://14241444681",
        1,
        1 + 0.25 * math.random(),
        true,
        10
    )
    arg1:CreateSound(
        "rbxassetid://110122962237431",
        1.25,
        1.25 + 0.25 * math.random() + 0.25,
        true,
        5
    )
end
