return function(arg1, arg2, arg3) -- line: 1
    arg1:CreateSound(
        "rbxassetid://130860307965581",
        1,
        1 + 0.1 * math.random(),
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 7.15 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://114610550422028",
        1,
        1 + 0.25 * math.random(),
        true,
        10
    )
end
