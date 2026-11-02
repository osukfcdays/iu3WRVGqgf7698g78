return function(arg1, arg2, arg3) -- line: 1
    if not arg1:_AnimationWait(script.Name, arg3, 0.1 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://17803231630",
        1,
        1,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.1 / arg2) then
        return
    end

    if not arg1:_AnimationWait(script.Name, arg3, 0.95 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://17803231954",
        1,
        1,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.39 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://13160326139",
        0.75,
        1,
        true,
        10
    )
end
