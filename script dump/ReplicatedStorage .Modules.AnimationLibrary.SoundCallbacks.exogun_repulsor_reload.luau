return function(arg1, arg2, arg3) -- line: 1
    arg1:CreateSound(
        "rbxassetid://80245415527547",
        0.75,
        1 + 0.1 * math.random(),
        true,
        5
    )
    arg1:CreateSound(
        "rbxassetid://94519339983000",
        0.75,
        1 + 0.1 * math.random(),
        true,
        5
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.4 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://86450952337176",
        0.75,
        1 + 0.1 * math.random(),
        true,
        5
    )
end
