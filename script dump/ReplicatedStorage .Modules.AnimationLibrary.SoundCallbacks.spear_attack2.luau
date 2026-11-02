local t = {
    "rbxassetid://117634080761694",
    "rbxassetid://119713534712313",
    "rbxassetid://105025971160103"
}

return function(arg1, _, _) -- line: 3
    -- upvalues:
    --  [1] t (copy)

    arg1:CreateSound(
        t[math.random(#t)],
        0.9 + 0.2 * math.random(),
        0.95 + 0.1 * math.random(),
        true,
        10
    )
end
