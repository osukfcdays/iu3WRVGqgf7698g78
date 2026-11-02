return function(arg1, arg2, arg3) -- line: 1
    if not arg1:_AnimationWait(script.Name, arg3, 0.13333333333333333 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://13158330555",
        1,
        1,
        true,
        10
    )
    arg1:CreateSound(
        "rbxassetid://87740786635301",
        0.375 + 0.25 * math.random(),
        0.9 + 0.4 * math.random(),
        true,
        5
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.9166666666666666 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://13158330666",
        1,
        1,
        true,
        10
    )
    arg1:CreateSound(
        "rbxassetid://87740786635301",
        0.375 + 0.25 * math.random(),
        0.9 + 0.4 * math.random(),
        true,
        5
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.5 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://17247776127",
        1,
        1,
        true,
        10
    )
    arg1:CreateSound(
        "rbxassetid://87740786635301",
        0.375 + 0.25 * math.random(),
        0.9 + 0.4 * math.random(),
        true,
        5
    )
end
