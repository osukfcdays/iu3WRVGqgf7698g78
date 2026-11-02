local t = { "rbxassetid://13110197302", "rbxassetid://13110197220" }

return function(arg1, _, _) -- line: 3
    -- upvalues:
    --  [1] t (copy)

    arg1:CreateSound(
        t[math.random(#t)],
        0.875,
        1 + 0.2 * math.random(),
        true,
        5
    )
    arg1:CreateSound(
        "rbxassetid://76996559479025",
        1,
        1,
        true,
        5
    )
end
