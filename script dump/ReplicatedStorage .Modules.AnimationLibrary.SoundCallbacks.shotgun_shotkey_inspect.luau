return function(arg1, arg2, arg3) -- line: 1
    if not arg1:_AnimationWait(script.Name, arg3, 1.85 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://71387264231358",
        2.5,
        1.25,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.31 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://13236026280",
        0.625,
        2,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 2.84 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://71387264231358",
        2.5,
        0.875,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.4 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://13236026280",
        0.5,
        1.75,
        true,
        10
    )
end
