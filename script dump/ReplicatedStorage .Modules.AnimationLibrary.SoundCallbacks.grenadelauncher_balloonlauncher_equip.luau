return function(arg1, arg2, arg3) -- line: 1
    if not arg1:_AnimationWait(script.Name, arg3, 0.3 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://17274369044",
        0.375,
        1,
        true,
        10
    )
    arg1:CreateSound(
        "rbxassetid://17803360572",
        1,
        1 + 0.2 * math.random(),
        true,
        10
    )
end
