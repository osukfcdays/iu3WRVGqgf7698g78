return function(arg1, arg2, arg3) -- line: 1
    arg1:CreateSound(
        "rbxassetid://100664516053133",
        0.25,
        1.5,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 1.2 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://71387264231358",
        1.5,
        0.875,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.55 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://96253147006478",
        0.75,
        1.25,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.25 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://96253147006478",
        0.25,
        1.5,
        true,
        10
    )
end
