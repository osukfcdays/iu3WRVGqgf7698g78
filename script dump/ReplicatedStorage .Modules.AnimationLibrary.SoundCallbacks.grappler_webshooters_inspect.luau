local t = { 2.11, 2.25, 2.41, 2.85, 3.09, 3.14, 3.44 }

return function(arg1, _, _) -- line: 3
    -- upvalues:
    --  [1] t (copy)

    for key, val in pairs(t) do
        wait(val - (t[key - 1] or 0))
        arg1:CreateSound(
            "rbxassetid://100300369951636",
            0.75 + 0.75 * math.random(),
            0.9 + 0.6 * math.random(),
            true,
            10
        )
    end
end
