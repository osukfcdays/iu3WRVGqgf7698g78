return function(arg1, arg2, arg3) -- line: 1
    if not arg1:_AnimationWait(script.Name, arg3, 0.65 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://17650837861",
        1,
        3,
        true,
        10
    )
    arg1:CreateSound(
        "rbxassetid://17650837861",
        1,
        2,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.233 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://17650838003",
        0.5,
        0.875 + 0.25 * math.random(),
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.2 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://17650945056",
        1,
        1.5,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.85 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://17650945056",
        1,
        1,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.78 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://17650837861",
        1,
        2,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.25 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://17650837861",
        1,
        3,
        true,
        10
    )
end
