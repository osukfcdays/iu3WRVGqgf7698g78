local t = { "rbxassetid://13677205703", "rbxassetid://13677205578", "rbxassetid://13677205647" }

return function(arg1, arg2, arg3) -- line: 3
    -- upvalues:
    --  [1] t (copy)

    arg1:CreateSound(
        t[math.random(#t)],
        3,
        0.95 + 0.1 * math.random(),
        true,
        10
    )
    arg1:CreateSound(
        "rbxassetid://113094896439924",
        1.5,
        1,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.5 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://13682183816",
        0.5,
        0.95 + 0.1 * math.random(),
        true,
        10
    )
end
