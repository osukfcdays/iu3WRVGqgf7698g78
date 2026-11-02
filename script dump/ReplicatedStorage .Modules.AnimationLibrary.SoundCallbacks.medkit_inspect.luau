return function(arg1, arg2, arg3) -- line: 1
    if not arg1:_AnimationWait(script.Name, arg3, 1.1 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://13456860578",
        1,
        1,
        true,
        10
    )
    arg1:CreateSound(
        "rbxassetid://13160326139",
        0.25,
        1,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 1.01 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://13456860532",
        1,
        1.1,
        true,
        10
    )
    arg1:CreateSound(
        "rbxassetid://13160326139",
        0.25,
        1,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.4 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://13160326139",
        0.125,
        1,
        true,
        10
    )
end
