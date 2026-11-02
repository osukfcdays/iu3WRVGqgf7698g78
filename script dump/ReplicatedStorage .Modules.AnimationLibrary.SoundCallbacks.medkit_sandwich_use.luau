return function(arg1, arg2, arg3) -- line: 1
    arg1:CreateSound(
        "rbxassetid://13158735106",
        0.25,
        1.5,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 1.4 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://18128896162",
        1,
        1 + 0.25 * math.random(),
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.95 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://18128896162",
        1,
        1 + 0.25 * math.random(),
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.56 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://18128896162",
        1,
        1 + 0.25 * math.random(),
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.29 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://18128896162",
        0.5,
        1 + 0.25 * math.random(),
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.8 / arg2) then
        return
    end

    if math.random() < 0.628 then
        arg1:CreateSound(
            "rbxassetid://18128949754",
            0.6,
            1 + 0.1 * math.random(),
            true,
            10
        )
    end
end
