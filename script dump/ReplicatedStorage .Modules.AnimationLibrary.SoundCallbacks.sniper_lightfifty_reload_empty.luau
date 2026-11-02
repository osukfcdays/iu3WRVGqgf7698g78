return function(arg1, arg2, arg3) -- line: 1
    if not arg1:_AnimationWait(script.Name, arg3, 0.75 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://13455395017",
        1,
        1.25,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.75 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://13455395090",
        0.25,
        0.75 + 0.25 * math.random(),
        true,
        10
    )
    arg1:CreateSound(
        "rbxassetid://13455229044",
        1,
        0.8,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.75 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://13455229188",
        1,
        0.8,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.65 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://13455395017",
        1,
        0.7,
        true,
        10
    )
end
