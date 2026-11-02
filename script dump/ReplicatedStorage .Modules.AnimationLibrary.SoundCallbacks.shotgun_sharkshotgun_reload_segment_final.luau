return function(arg1, arg2, arg3) -- line: 1
    if not arg1:_AnimationWait(script.Name, arg3, 0.1 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://13515046872",
        1,
        1,
        true,
        10
    )
    arg1:CreateSound(
        "rbxassetid://71924311860992",
        0.75,
        1,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.25 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://93644201634454",
        0.75,
        0.75 + 0.1 * math.random(),
        true,
        5
    )
end
