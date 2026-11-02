return function(arg1, arg2, arg3) -- line: 1
    if not arg1:_AnimationWait(script.Name, arg3, 1.25 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://101161696630107",
        1.5,
        0.5,
        true,
        10
    )
    arg1:CreateSound(
        "rbxassetid://136174258344321",
        0.375,
        1.5 + 0.25 * math.random(),
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 1.55 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://13158735106",
        0.125,
        1.5,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 1.75 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://13158735106",
        0.25,
        1.5,
        true,
        10
    )
end
