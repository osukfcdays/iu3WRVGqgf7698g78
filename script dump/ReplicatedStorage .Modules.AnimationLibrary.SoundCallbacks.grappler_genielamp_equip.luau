return function(arg1, arg2, arg3) -- line: 1
    arg1:CreateSound(
        "rbxassetid://128735130219172",
        0.5,
        1 + 0.2 * math.random(),
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.75 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://114830743588818",
        0.5,
        1 + 0.1 * math.random(),
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.25 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://114830743588818",
        0.5,
        1.1 + 0.1 * math.random(),
        true,
        10
    )
end
