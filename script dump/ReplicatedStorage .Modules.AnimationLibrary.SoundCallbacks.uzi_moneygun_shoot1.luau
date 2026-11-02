local t = { "rbxassetid://16526185100", "rbxassetid://16526184479", "rbxassetid://16526184730" }
local t_1 = {
    "rbxassetid://88544860864804",
    "rbxassetid://129694620679651",
    "rbxassetid://102804344908530"
}

return function(arg1, _, _) -- line: 4
    -- upvalues:
    --  [1] t (copy)
    --  [2] t_1 (copy)

    arg1:CreateSound(
        t[math.random(#t)],
        0.5,
        0.75 + 0.5 * math.random(),
        true,
        5
    )
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
        t_1[math.random(#t_1)],
        0.875,
        1 + 0.2 * math.random(),
        true,
        10
    )
    arg1:CreateSound(
        "rbxassetid://76983701785959",
        1.5,
        1,
        true,
        5
    )
end
