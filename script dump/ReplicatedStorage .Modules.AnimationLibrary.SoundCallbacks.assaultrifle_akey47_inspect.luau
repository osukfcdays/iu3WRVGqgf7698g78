return function(arg1, arg2, arg3) -- line: 1
    arg1:CreateSound(
        "rbxassetid://96253147006478",
        0.6,
        1,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.7166666666666667 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://13236549929",
        1,
        0.875,
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

    if not arg1:_AnimationWait(script.Name, arg3, 2.0833333333333335 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://13236549962",
        1,
        1,
        true,
        10
    )
    arg1:CreateSound(
        "rbxassetid://110122962237431",
        1,
        1 + 0.1 * math.random(),
        true,
        5
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.65 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://13455395017",
        1,
        0.75,
        true,
        10
    )
    arg1:CreateSound(
        "rbxassetid://110122962237431",
        1,
        0.75 + 0.05 * math.random(),
        true,
        5
    )

    if not arg1:_AnimationWait(script.Name, arg3, 1.45 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://13455395017",
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
end
