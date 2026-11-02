return function(arg1, arg2, arg3) -- line: 1
    arg1:CreateSound(
        "rbxassetid://137232955524669",
        1,
        1 + 0.1 * math.random(),
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 4.55 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://13158735106",
        0.75,
        1.75,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 1.4 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://13158735106",
        0.75,
        1.25,
        true,
        10
    )
end
