local t = { "rbxassetid://16526185100", "rbxassetid://16526184479", "rbxassetid://16526184730" }

return function(arg1, _, _) -- line: 3
    -- upvalues:
    --  [1] t (copy)

    arg1:CreateSound(
        "rbxassetid://16397424081",
        0.2,
        4 + 0.5 * math.random(),
        true,
        5
    )
    arg1:CreateSound(
        "rbxassetid://16526184265",
        0.5,
        2 + 0.5 * math.random(),
        true,
        5
    )
    arg1:CreateSound(
        t[math.random(#t)],
        0.75,
        1.25 + 0.75 * math.random(),
        true,
        5
    )
    arg1:CreateSound(
        t[math.random(#t)],
        0.75,
        2.5 + 1 * math.random(),
        true,
        5
    )
    arg1:CreateSound(
        "rbxassetid://90757583550672",
        0.5,
        2.5 + 0.5 * math.random(),
        true,
        5
    )
    arg1:CreateSound(
        "rbxassetid://110122962237431",
        1,
        1 + 0.1 * math.random(),
        true,
        5
    )
end
