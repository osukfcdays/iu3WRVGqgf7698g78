local t = {
    "rbxassetid://111073083700270",
    "rbxassetid://94924686270578",
    "rbxassetid://132703068792668"
}

return function(arg1, _, _) -- line: 3
    -- upvalues:
    --  [1] t (copy)

    arg1:CreateSound(
        t[math.random(#t)],
        1.25,
        0.9 + 0.2 * math.random(),
        true,
        5
    )
end
