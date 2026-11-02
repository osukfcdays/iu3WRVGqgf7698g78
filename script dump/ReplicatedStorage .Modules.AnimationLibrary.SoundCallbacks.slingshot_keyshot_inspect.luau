return function(arg1, arg2, arg3) -- line: 1
    if not arg1:_AnimationWait(script.Name, arg3, 0.55 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://8971407217",
        0.5,
        1.25,
        true,
        5
    )
    arg1:CreateSound(
        "rbxassetid://110122962237431",
        1.25,
        1 + 0.1 * math.random(),
        true,
        5
    )

    if not arg1:_AnimationWait(script.Name, arg3, 2.85 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://14241444681",
        0.5,
        1.5,
        true,
        10
    )
    arg1:CreateSound(
        "rbxassetid://110122962237431",
        1.25,
        1 + 0.1 * math.random(),
        true,
        5
    )
    arg1:CreateSound(
        "rbxasset://sounds//Rubber band sling shot.mp3",
        0.75,
        1.4 + 0.2 * math.random(),
        true,
        5
    )
end
