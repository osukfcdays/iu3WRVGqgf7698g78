return function(arg1, arg2, arg3) -- line: 1
    if not arg1:_AnimationWait(script.Name, arg3, 1.5 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://115253895253213",
        0.875,
        1 + 0.2 * math.random(),
        true,
        5
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.4 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://115253895253213",
        0.875,
        1 + 0.2 * math.random(),
        true,
        5
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.75 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://137209644295911",
        0.875,
        1 + 0.2 * math.random(),
        true,
        5
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.95 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://137209644295911",
        0.875,
        1 + 0.2 * math.random(),
        true,
        5
    )

    if not arg1:_AnimationWait(script.Name, arg3, 1.1 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://137209644295911",
        0.875,
        1 + 0.2 * math.random(),
        true,
        5
    )
    arg1:CreateSound(
        "rbxassetid://135586619814232",
        0.875,
        1 + 0.2 * math.random(),
        true,
        5
    )
    arg1:CreateSound(
        "rbxassetid://92587536325720",
        0.875,
        1 + 0.2 * math.random(),
        true,
        5
    )
end
