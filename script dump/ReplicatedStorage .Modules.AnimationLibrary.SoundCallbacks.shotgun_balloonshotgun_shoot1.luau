return function(arg1, arg2, arg3) -- line: 1
    for index = 1, 5 do
        task.spawn(function() -- line: 3
            -- upvalues:
            --  [1] arg1 (copy)
            --  [2] arg3 (copy)
            --  [3] arg2 (copy)
            --  [4] index (copy)

            if not arg1:_AnimationWait(script.Name, arg3, 0.15 / arg2 * index / 5) then
                return
            end

            arg1:CreateSound(
                "rbxassetid://17803308936",
                1 + 0.25 * math.random(),
                1 + 0.3 * math.random(),
                true,
                10
            )
        end)
    end

    if not arg1:_AnimationWait(script.Name, arg3, 0.35 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://17803360572",
        1,
        2,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.15 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://17803360572",
        1,
        1.25,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.1 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://17803368105",
        0.5,
        0.75 + 0.25 * math.random(),
        true,
        10
    )
end
