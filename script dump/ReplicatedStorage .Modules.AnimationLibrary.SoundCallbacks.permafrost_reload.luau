return function(arg1, arg2, arg3) -- line: 1
    if not arg1:_AnimationWait(script.Name, arg3, 0.3 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://97621886814272",
        1,
        3 + 0.25 * math.random(),
        true,
        10
    )
    arg1:CreateSound(
        "rbxassetid://13160326139",
        0.375,
        1.5,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.2 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://13236026280",
        0.5,
        2.25,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 1.2 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://97621886814272",
        1,
        2.5 + 0.125 * math.random(),
        true,
        10
    )
    arg1:CreateSound(
        "rbxassetid://13160326139",
        0.375,
        1.25,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.35 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://13236026280",
        0.375,
        1.75,
        true,
        10
    )
end
