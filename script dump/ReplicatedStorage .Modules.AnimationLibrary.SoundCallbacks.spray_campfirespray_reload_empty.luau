return function(arg1, arg2, arg3) -- line: 1
    if not arg1:_AnimationWait(script.Name, arg3, 0.45 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://112852622692949",
        0.875,
        1.1 + 0.1 * math.random(),
        true,
        5
    )

    if not arg1:_AnimationWait(script.Name, arg3, 1.05 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://117184161634687",
        0.875,
        1 + 0.05 * math.random(),
        true,
        5
    )
end
