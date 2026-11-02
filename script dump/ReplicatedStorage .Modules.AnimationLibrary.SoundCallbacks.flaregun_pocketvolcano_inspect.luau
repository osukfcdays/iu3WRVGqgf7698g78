return function(arg1, arg2, arg3) -- line: 1
    if not arg1:_AnimationWait(script.Name, arg3, 2.2 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://111475442610934",
        4,
        1,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.28 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://106855758356398",
        0.25,
        1.5,
        true,
        10
    )
end
