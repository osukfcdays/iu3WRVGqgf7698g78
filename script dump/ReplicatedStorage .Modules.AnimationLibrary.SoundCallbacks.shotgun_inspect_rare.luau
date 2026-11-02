return function(arg1, arg2, arg3) -- line: 1
    if not arg1:_AnimationWait(script.Name, arg3, 1 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://13515046921",
        1,
        1.25,
        true,
        10
    )
    arg1:CreateSound(
        "rbxassetid://13236026280",
        1,
        1,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.717 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://13160326139",
        1,
        1.25,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 2.783 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://13160326139",
        0.5,
        1.75,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.6 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://13235979356",
        1,
        1,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.15 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://13515046988",
        1,
        1.25,
        true,
        10
    )
end
