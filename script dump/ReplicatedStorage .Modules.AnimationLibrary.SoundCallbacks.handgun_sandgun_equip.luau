return function(arg1, arg2, arg3) -- line: 1
    if not arg1:_AnimationWait(script.Name, arg3, 0.15 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://13158610792",
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
