return function(arg1, arg2, arg3) -- line: 1
    if not arg1:_AnimationWait(script.Name, arg3, 1.55 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://13456860578",
        0.75,
        1,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.4 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://13160326139",
        0.25,
        1,
        true,
        10
    )
    arg1:CreateSound(
        "rbxassetid://13456860578",
        0.5,
        1.25,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 1 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://13456860578",
        0.5,
        1,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.58 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://13160326139",
        0.175,
        1,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.42 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://13160326139",
        0.125,
        0.75,
        true,
        10
    )
end
