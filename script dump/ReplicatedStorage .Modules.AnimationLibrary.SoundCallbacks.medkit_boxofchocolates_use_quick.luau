return function(arg1, arg2, arg3) -- line: 1
    arg1:CreateSound(
        "rbxassetid://75064925834262",
        0.875,
        1 + 0.2 * math.random(),
        true,
        5
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.3 / arg2) then
        return
    end

    for _ = 1, 3 do
        arg1:CreateSound(
            "rbxassetid://128380920423591",
            0.875,
            0.8 + 0.2 * math.random(),
            true,
            5
        )

        if not arg1:_AnimationWait(script.Name, arg3, 0.1 / arg2) then
            return
        end
    end

    arg1:CreateSound(
        "rbxassetid://18128896325",
        0.75,
        1 + 0.25 * math.random(),
        true,
        10
    )
end
