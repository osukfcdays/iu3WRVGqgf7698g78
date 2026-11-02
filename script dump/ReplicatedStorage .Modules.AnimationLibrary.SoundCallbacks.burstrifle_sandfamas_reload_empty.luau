return function(arg1, arg2, arg3) -- line: 1
    if not arg1:_AnimationWait(script.Name, arg3, 0.4 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://13236549962",
        1,
        1.25,
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

    if not arg1:_AnimationWait(script.Name, arg3, 0.8 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://13236549962",
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

    if not arg1:_AnimationWait(script.Name, arg3, 0.35 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://13455395017",
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

    if not arg1:_AnimationWait(script.Name, arg3, 0.217 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://13455395017",
        1,
        1.25,
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
