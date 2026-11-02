return function(arg1, arg2, arg3) -- line: 1
    if not arg1:_AnimationWait(script.Name, arg3, 0.25 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://13456860578",
        1.25,
        1.5,
        true,
        10
    )
    arg1:CreateSound(
        "rbxassetid://110122962237431",
        1.25,
        1.25 + 0.25 * math.random(),
        true,
        5
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.55 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://13483008798",
        1,
        2,
        true,
        10
    )
    arg1:CreateSound(
        "rbxassetid://110122962237431",
        1.25,
        1 + 0.1 * math.random(),
        true,
        5
    )

    if not arg1:_AnimationWait(script.Name, arg3, 1.75 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://71387264231358",
        0.25,
        1.5,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.55 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://71387264231358",
        0.125,
        1.25,
        true,
        10
    )
end
