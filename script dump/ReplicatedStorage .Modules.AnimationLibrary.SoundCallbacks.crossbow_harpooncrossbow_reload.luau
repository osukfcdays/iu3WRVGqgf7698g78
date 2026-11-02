return function(arg1, arg2, arg3) -- line: 1
    if not arg1:_AnimationWait(script.Name, arg3, 0.78 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://13456746131",
        0.75,
        2,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.25 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://13456746075",
        1,
        1.75,
        true,
        10
    )
end
