return function(arg1, arg2, arg3) -- line: 1
    arg1:CreateSound(
        "rbxassetid://100664516053133",
        0.25,
        1.5,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.75 / arg2) then
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
        2.25,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.5 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://110122962237431",
        0.75,
        1.5 + 0.25 * math.random(),
        true,
        5
    )
end
