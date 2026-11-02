return function(arg1, arg2, arg3) -- line: 1
    arg1:CreateSound(
        "rbxassetid://13479562219",
        1,
        1.25 + 0.25 * math.random(),
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.35 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://13515046921",
        1,
        1.25,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.15 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://13515046988",
        1,
        1.25,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.1 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://13531443905",
        0.125,
        0.75 + 0.25 * math.random(),
        true,
        10
    )
end
