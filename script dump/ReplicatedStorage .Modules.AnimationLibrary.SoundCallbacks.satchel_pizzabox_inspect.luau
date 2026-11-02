return function(arg1, arg2, arg3) -- line: 1
    if not arg1:_AnimationWait(script.Name, arg3, 0.3 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://124893673183314",
        1,
        1,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 1.6 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://129245637994313",
        0.5,
        1.5,
        true,
        10
    )
    arg1:CreateSound(
        "rbxassetid://80643999817278",
        0.5,
        1.5,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.75 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://13456860578",
        1,
        1,
        true,
        10
    )
    arg1:CreateSound(
        "rbxassetid://13160326139",
        0.25,
        1,
        true,
        10
    )
end
