local t = { "rbxassetid://72815891526849", "rbxassetid://134260292117186" }

return function(arg1, _, _) -- line: 3
    -- upvalues:
    --  [1] t (copy)

    arg1:CreateSound(
        t[math.random(#t)],
        0.75,
        1 + 0.2 * math.random(),
        true,
        5
    )
    arg1:CreateSound(
        "rbxassetid://101461115963186",
        1.2,
        1 + 0.2 * math.random(),
        true,
        5
    )
    arg1:CreateSound(
        "rbxassetid://115140983811870",
        0.875,
        1.375 + 0.25 * math.random(),
        true,
        5
    )
end
