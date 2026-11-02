return function(arg1, arg2, arg3) -- line: 1
    arg1:CreateSound(
        "rbxassetid://13158735106",
        0.25,
        0.5,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.94 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://13236549929",
        1,
        0.875,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.86 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://13236549962",
        1,
        1,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.87 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://13455395017",
        1,
        0.75,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.3 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://13455395017",
        1,
        1,
        true,
        10
    )
end
