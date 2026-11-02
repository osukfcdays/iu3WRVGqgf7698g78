return function(arg1, arg2, arg3) -- line: 1
    if not arg1:_AnimationWait(script.Name, arg3, 0.85 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://17650837861",
        0.75,
        0.5,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 1.4 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://84676580117737",
        0.5,
        0.625,
        true,
        10
    )
end
