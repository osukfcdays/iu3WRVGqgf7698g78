return function(arg1, arg2, arg3) -- line: 1
    arg1:CreateSound(
        "rbxassetid://73644074370077",
        0.875,
        1 + 0.2 * math.random(),
        true,
        5
    )
    arg1:CreateSound(
        "rbxassetid://108166862465565",
        0.75,
        1 + 0.2 * math.random(),
        true,
        5
    )

    for _ = 1, 3 do
        arg1:CreateSound(
            "rbxassetid://18763517194",
            1,
            1 + 0.25 * math.random(),
            true,
            5
        )

        if not arg1:_AnimationWait(script.Name, arg3, 0.1 / arg2) then
            return
        end
    end
end
