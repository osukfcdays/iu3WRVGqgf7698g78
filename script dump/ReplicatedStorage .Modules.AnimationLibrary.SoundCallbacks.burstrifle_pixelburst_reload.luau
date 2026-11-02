return function(arg1, arg2, arg3) -- line: 1
    if not arg1:_AnimationWait(script.Name, arg3, 0.1 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://17650945056",
        1.25,
        1.5,
        true,
        10
    )
    arg1:CreateSound(
        "rbxassetid://17650837503",
        1.25,
        1,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.95 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://17650945056",
        1,
        1,
        true,
        10
    )
    arg1:CreateSound(
        "rbxassetid://17650837718",
        1,
        2,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.39 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://17650838003",
        2,
        1.25,
        true,
        10
    )
end
