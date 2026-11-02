return function(arg1, arg2, arg3) -- line: 1
    arg1:CreateSound(
        "rbxassetid://119827986766384",
        0.75,
        1,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 1 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://119827986766384",
        0.5,
        0.75,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 1 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://119827986766384",
        0.375,
        0.5,
        true,
        10
    )
end
