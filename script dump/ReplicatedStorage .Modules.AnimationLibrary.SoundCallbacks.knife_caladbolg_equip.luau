return function(arg1, arg2, arg3) -- line: 1
    if not arg1:_AnimationWait(script.Name, arg3, 0.55 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://101161696630107",
        1.5,
        1,
        true,
        10
    )
    arg1:CreateSound(
        "rbxassetid://136174258344321",
        0.5,
        2 + 0.25 * math.random(),
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.9 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://14427935597",
        0.75,
        1.125,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.6 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://13160326139",
        1,
        1.25,
        true,
        10
    )
end
