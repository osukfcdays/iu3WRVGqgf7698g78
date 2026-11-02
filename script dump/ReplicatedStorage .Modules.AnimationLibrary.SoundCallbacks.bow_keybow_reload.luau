return function(arg1, arg2, arg3) -- line: 1
    if not arg1:_AnimationWait(script.Name, arg3, 0.15 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://13682183816",
        0.5,
        2 + 0.5 * math.random(),
        true,
        10
    )
    arg1:CreateSound(
        "rbxassetid://110122962237431",
        0.5,
        1.5 + 0.25 * math.random(),
        true,
        5
    )
    arg1:CreateSound(
        "rbxassetid://71387264231358",
        0.375,
        1,
        true,
        10
    )
end
