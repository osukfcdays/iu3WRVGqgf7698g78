return function(arg1, arg2, arg3) -- line: 1
    if not arg1:_AnimationWait(script.Name, arg3, 0.666 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://13456746131",
        0.75,
        1.25,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.6 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://13456746075",
        1,
        1,
        true,
        10
    )
end
