return function(arg1, arg2, arg3) -- line: 1
    arg1:CreateSound(
        "rbxassetid://73931497990415",
        0.75,
        1 + 0.1 * math.random(),
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.9 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://13158735106",
        0.125,
        1.5,
        true,
        10
    )
end
