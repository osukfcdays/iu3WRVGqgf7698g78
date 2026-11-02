local t = { "rbxassetid://16526185100", "rbxassetid://16526184479", "rbxassetid://16526184730" }
local t_1 = {
    "rbxassetid://82734275723667",
    "rbxassetid://94668708681028",
    "rbxassetid://114970794949077"
}

return function(arg1, _, _) -- line: 4
    -- upvalues:
    --  [1] t (copy)
    --  [2] t_1 (copy)

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
        1.25,
        0.75 + 0.5 * math.random(),
        true,
        5
    )
    arg1:CreateSound(
        t_1[math.random(#t_1)],
        1,
        0.95 + 0.1 * math.random(),
        true,
        5
    )
end
