local t = { "rbxassetid://14000023581", "rbxassetid://14000023392" }

return function(arg1, arg2, arg3) -- line: 3
    -- upvalues:
    --  [1] t (copy)

    if not arg1:_AnimationWait(script.Name, arg3, 2 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://14427935597",
        0.5,
        1.125,
        true,
        10
    )
    arg1:CreateSound(
        "rbxassetid://96253147006478",
        0.75,
        1.25,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.25 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://96253147006478",
        0.5,
        1.375,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.25 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://96253147006478",
        0.25,
        1.5,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.375 / arg2) then
        return
    end

    for _ = 1, 15 do
        local v6 = t[math.random(#t)]
        arg1:CreateSound(
            v6,
            1,
            1 + 0.25 * math.random(),
            true,
            10
        )
        arg1:CreateSound(
            "rbxassetid://96253147006478",
            0.375,
            1 + 0.5 * math.random(),
            true,
            10
        )

        if not arg1:_AnimationWait(script.Name, arg3, 0.058333333333333334 / arg2) then
            return
        end
    end

    if not arg1:_AnimationWait(script.Name, arg3, 0.15 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://96253147006478",
        0.2,
        1.25,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.25 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://96253147006478",
        0.1,
        1.5,
        true,
        10
    )
    arg1:CreateSound(
        "rbxassetid://89056031983351",
        0.75,
        1.117,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.933 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://133090858473825",
        0.75,
        1,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.5 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://90757583550672",
        0.75,
        1 + 0.125 * math.random(),
        true,
        5
    )

    for index_1 = 1, 3 do
        arg1:CreateSound(
            "rbxassetid://14427782350",
            1,
            (index_1 - 1) * 0.25 + 1,
            true,
            10
        )

        if not arg1:_AnimationWait(script.Name, arg3, 0.05 / arg2) then
            return
        end
    end

    if not arg1:_AnimationWait(script.Name, arg3, 0.5 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://71387264231358",
        1,
        0.875,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.767 / arg2) then
        return
    end

    local v20 = arg1:CreateSound("rbxassetid://82637145735352", 0.5, 1 + 0.1 * math.random(), true)
    task.spawn(function() -- line: 81
        -- upvalues:
        --  [1] arg1 (copy)
        --  [2] arg3 (copy)
        --  [3] arg2 (copy)
        --  [4] v20 (copy)

        if not arg1:_AnimationWait(script.Name, arg3, 2.5 / arg2) then
            return
        end

        if v20 then
            v20:Destroy()
        end
    end)

    if not arg1:_AnimationWait(script.Name, arg3, 1.45 / arg2) then
        return
    end

    for _ = 1, 5 do
        arg1:CreateSound(
            "rbxassetid://13160326139",
            0.75,
            1 + 0.25 * math.random(),
            true,
            10
        )

        if not arg1:_AnimationWait(script.Name, arg3, 0.2 / arg2) then
            return
        end
    end
end
