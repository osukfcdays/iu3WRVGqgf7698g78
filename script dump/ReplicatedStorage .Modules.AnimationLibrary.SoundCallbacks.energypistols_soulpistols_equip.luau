return function(arg1, arg2, arg3) -- line: 1
    arg1:CreateSound(
        "rbxassetid://13456860578",
        1.25,
        1.5,
        true,
        0.5 / arg2
    )
    arg1:CreateSound(
        "rbxassetid://134917124344503",
        0.5,
        1.25,
        true,
        5
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.5 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://13483008798",
        1,
        2,
        true,
        10
    )
end
