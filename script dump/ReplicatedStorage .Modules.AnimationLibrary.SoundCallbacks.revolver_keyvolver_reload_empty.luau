return function(arg1, arg2, arg3) -- line: 1
    if not arg1:_AnimationWait(script.Name, arg3, 0.283 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://13483008798",
        1.25,
        2.5,
        true,
        10
    )
    arg1:CreateSound(
        "rbxassetid://90757583550672",
        0.625,
        1.25 + 0.25 * math.random(),
        true,
        5
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.283 / arg2) then
        return
    end

    for index = 1, 6 do
        arg1:CreateSound(
            "rbxassetid://14241444681",
            1,
            index * 0.125 + 1,
            true,
            10
        )
        arg1:CreateSound(
            "rbxassetid://110122962237431",
            1.25,
            1.25 + 0.25 * math.random() + index * 0.125,
            true,
            5
        )

        if not arg1:_AnimationWait(script.Name, arg3, 0.044500000000000005 / arg2) then
            return
        end
    end

    arg1:CreateSound(
        "rbxassetid://71387264231358",
        1.25,
        1,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.45 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://13483008798",
        1.25,
        1.75,
        true,
        10
    )
    arg1:CreateSound(
        "rbxassetid://90757583550672",
        0.625,
        1 + 0.1 * math.random(),
        true,
        5
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.767 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://13483008798",
        0.5,
        2,
        true,
        10
    )
    arg1:CreateSound(
        "rbxassetid://110122962237431",
        0.375,
        1.5 + 0.5 * math.random(),
        true,
        5
    )
end
