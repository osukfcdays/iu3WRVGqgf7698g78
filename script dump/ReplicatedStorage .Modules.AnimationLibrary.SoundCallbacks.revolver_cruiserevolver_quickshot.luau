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
        0.95 + 0.1 * math.random(),
        true,
        10
    )
    arg1:CreateSound(
        "rbxassetid://94299557217235",
        1,
        0.95 + 0.1 * math.random(),
        true,
        10
    )
    arg1:CreateSound(
        "rbxassetid://134815282110155",
        1.25,
        1,
        true,
        10
    )
end
