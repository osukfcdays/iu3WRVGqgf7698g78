local t = { "rbxassetid://13677205703", "rbxassetid://13677205578", "rbxassetid://13677205647" }

return function(arg1, _, _) -- line: 3
    -- upvalues:
    --  [1] t (copy)

    arg1:CreateSound(
        t[math.random(#t)],
        3,
        0.95 + 0.1 * math.random(),
        true,
        10
    )
    arg1:CreateSound(
        "rbxassetid://110122962237431",
        0.75,
        1.5 + 0.25 * math.random(),
        true,
        5
    )
end
