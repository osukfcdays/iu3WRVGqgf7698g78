return function(arg1, arg2, arg3) -- line: 1
    if not arg1:_AnimationWait(script.Name, arg3, 0.7 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://13158330555",
        1,
        1,
        true,
        10
    )
    arg1:CreateSound(
        "rbxassetid://13236549962",
        1,
        1.5,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 1.3 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://13158330555",
        1,
        1.5,
        true,
        10
    )
end
