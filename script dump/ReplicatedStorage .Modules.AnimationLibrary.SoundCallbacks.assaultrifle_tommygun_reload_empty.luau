return function(arg1, arg2, arg3) -- line: 1
    arg1:CreateSound(
        "rbxassetid://13158735106",
        0.25,
        0.5,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.4 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://13236549929",
        1,
        0.75,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.8 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://13236549962",
        1,
        0.875,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.6 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://13455395017",
        1,
        1.75,
        true,
        10
    )
end
