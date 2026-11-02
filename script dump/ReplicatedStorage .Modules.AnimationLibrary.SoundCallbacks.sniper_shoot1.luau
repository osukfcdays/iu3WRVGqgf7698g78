return function(arg1, arg2, arg3) -- line: 1
    arg1:CreateSound(
        "rbxassetid://13270206222",
        0.875,
        0.95 + 0.1 * math.random(),
        true,
        10
    )
    arg1:CreateSound(
        "rbxassetid://13270206087",
        0.875,
        0.95 + 0.1 * math.random(),
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.5 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://13455395017",
        1,
        2,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.067 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://13455395017",
        1,
        1,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.05 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://13455394948",
        1,
        1,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.183 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://13455394948",
        1,
        2,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.05 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://13455395090",
        0.25,
        0.75 + 0.25 * math.random(),
        true,
        10
    )
end
