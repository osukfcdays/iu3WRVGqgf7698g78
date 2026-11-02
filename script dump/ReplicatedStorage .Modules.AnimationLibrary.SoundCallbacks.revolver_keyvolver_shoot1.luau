local t = {
    "rbxassetid://14417089307",
    "rbxassetid://14417089152",
    "rbxassetid://14417089046",
    "rbxassetid://14417088974"
}

return function(arg1, _, _) -- line: 3
    -- upvalues:
    --  [1] t (copy)

    arg1:CreateSound(
        t[math.random(#t)],
        1,
        0.75 + 0.125 * math.random(),
        true,
        10
    )
    arg1:CreateSound(
        t[math.random(#t)],
        1,
        1.25 + 0.25 * math.random(),
        true,
        10
    )
    arg1:CreateSound(
        "rbxassetid://13483008798",
        1.25,
        2,
        true,
        10
    )
    arg1:CreateSound(
        "rbxassetid://90757583550672",
        0.625,
        1 + 0.1 * math.random(),
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
end
