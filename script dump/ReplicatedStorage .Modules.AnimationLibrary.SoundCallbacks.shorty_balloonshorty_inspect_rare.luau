return function(arg1, arg2, arg3) -- line: 1
    if not arg1:_AnimationWait(script.Name, arg3, 2.5 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://13158735106",
        0.75,
        2,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 1.1666666666666667 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://13456860578",
        1.5,
        1.5,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.75 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://17803360572",
        1,
        2,
        true,
        10
    )
end
