return function(arg1, arg2, arg3) -- line: 1
    if not arg1:_AnimationWait(script.Name, arg3, 1.6 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://17650945056",
        0.5,
        1.75,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.28 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://17650945056",
        0.5,
        2,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.42 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://17650945056",
        0.5,
        2,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.4 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://106994976644858",
        1,
        1.25,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.35 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://106994976644858",
        1,
        0.875,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.58 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://106994976644858",
        1,
        1.25,
        true,
        10
    )
end
