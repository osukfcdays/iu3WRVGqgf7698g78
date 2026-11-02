return function(arg1, arg2, arg3) -- line: 1
    if not arg1:_AnimationWait(script.Name, arg3, 1.05 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://71387264231358",
        1.25,
        1.5,
        true,
        10
    )
    arg1:CreateSound(
        "rbxassetid://13483008798",
        0.5,
        2,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 1 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://71387264231358",
        1.25,
        1,
        true,
        10
    )
    arg1:CreateSound(
        "rbxassetid://13483008798",
        0.5,
        1.75,
        true,
        10
    )
end
