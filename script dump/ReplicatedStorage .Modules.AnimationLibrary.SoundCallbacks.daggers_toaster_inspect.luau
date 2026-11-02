return function(arg1, arg2, arg3) -- line: 1
    if not arg1:_AnimationWait(script.Name, arg3, 0.85 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://88834968924220",
        1,
        1 + 0.2 * math.random(),
        true,
        5
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.35 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://13160326139",
        0.25,
        1,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 1 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://18128896162",
        1,
        1 + 0.25 * math.random(),
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 1.05 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://122724754588572",
        1.25,
        1 + 0.2 * math.random(),
        true,
        5
    )
end
