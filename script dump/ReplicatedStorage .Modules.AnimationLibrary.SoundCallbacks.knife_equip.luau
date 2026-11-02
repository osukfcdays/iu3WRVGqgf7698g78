return function(arg1, arg2, arg3) -- line: 1
    arg1:CreateSound(
        "rbxassetid://14427935597",
        0.75,
        1.125,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.4666666666666667 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://13160326139",
        1,
        1.25,
        true,
        10
    )
end
