return function(arg1, arg2, arg3) -- line: 1
    if not arg1:_AnimationWait(script.Name, arg3, 0.3 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://112852622692949",
        0.875,
        1.1 + 0.1 * math.random(),
        true,
        5
    )

    if not arg1:_AnimationWait(script.Name, arg3, 1.1666666666666667 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://117184161634687",
        0.875,
        1 + 0.05 * math.random(),
        true,
        5
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.7166666666666667 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://13455395017",
        1,
        2,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.18333333333333332 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://13455395017",
        1,
        1,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 1.2166666666666666 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://13455394948",
        1,
        1,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.23333333333333334 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://13455394948",
        1,
        2,
        true,
        10
    )
end
