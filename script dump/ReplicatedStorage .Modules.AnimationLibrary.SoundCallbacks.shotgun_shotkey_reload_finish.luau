return function(arg1, arg2, arg3) -- line: 1
    if not arg1:_AnimationWait(script.Name, arg3, 0.1 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://13515046872",
        0.75,
        1,
        true,
        10
    )
    arg1:CreateSound(
        "rbxassetid://90757583550672",
        0.5,
        3 + 0.25 * math.random(),
        true,
        5
    )
end
