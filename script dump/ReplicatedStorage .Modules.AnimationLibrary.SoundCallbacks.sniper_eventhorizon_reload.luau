return function(arg1, arg2, arg3) -- line: 1
    arg1:CreateSound(
        "rbxassetid://113227486192611",
        0.875,
        1 + 0.1 * math.random(),
        true,
        10
    )
    arg1:CreateSound(
        "rbxassetid://122971606160018",
        0.875,
        1 + 0.1 * math.random(),
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 1.43 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://17672502879",
        0.875,
        0.875,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.47 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://17672502879",
        0.5,
        3,
        true,
        10
    )
end
