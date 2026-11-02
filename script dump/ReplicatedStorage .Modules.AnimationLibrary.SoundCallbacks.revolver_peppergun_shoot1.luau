local t = {
    "rbxassetid://116197718267373",
    "rbxassetid://70565429278087",
    "rbxassetid://134615455726492"
}

return function(arg1, _, _) -- line: 3
    -- upvalues:
    --  [1] t (copy)

    arg1:CreateSound(
        t[math.random(#t)],
        1,
        1 + 0.1 * math.random(),
        true,
        10
    )
end
