return function(arg1, arg2, arg3) -- line: 1
    if not arg1:_AnimationWait(script.Name, arg3, 0.45 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://17274798693",
        0.75,
        1,
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

    if not arg1:_AnimationWait(script.Name, arg3, 1.3 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://17274798406",
        0.75,
        1,
        true,
        10
    )
    arg1:CreateSound(
        "rbxassetid://17274798198",
        0.75,
        1,
        true,
        10
    )
    arg1:CreateSound(
        "rbxassetid://17803360572",
        1,
        1 + 0.1 * math.random(),
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.6 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://17274798538",
        0.75,
        1,
        true,
        10
    )
    arg1:CreateSound(
        "rbxassetid://17803360572",
        1,
        3 + 0.3 * math.random(),
        true,
        10
    )
end
