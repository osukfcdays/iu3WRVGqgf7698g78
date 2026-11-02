return function(arg1, arg2, arg3) -- line: 1
    arg1:CreateSound(
        "rbxassetid://17650837718",
        1,
        0.95 + 0.1 * math.random(),
        true,
        10
    )
    arg1:CreateSound(
        "rbxassetid://17650837503",
        0.875,
        0.95 + 0.1 * math.random(),
        true,
        10
    )
    arg1:CreateSound(
        "rbxassetid://17650964342",
        0.75,
        1 + 0.1 * math.random(),
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.5 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://17650837861",
        1,
        3,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.067 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://17650837861",
        1,
        2,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.05 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://17650837861",
        1,
        2,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.183 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://17650837861",
        1,
        3,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.05 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://17650838003",
        0.5,
        0.875 + 0.25 * math.random(),
        true,
        10
    )
end
