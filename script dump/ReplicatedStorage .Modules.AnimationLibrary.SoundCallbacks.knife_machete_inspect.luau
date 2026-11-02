return function(arg1, arg2, arg3) -- line: 1
    if not arg1:_AnimationWait(script.Name, arg3, 3.5 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://13158735106",
        0.25,
        1.5,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.85 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://80771716293563",
        0.75,
        1 + 0.1 * math.random(),
        true,
        10
    )
end
