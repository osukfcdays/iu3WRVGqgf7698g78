return function(arg1, arg2, arg3) -- line: 1
    arg1:CreateSound(
        "rbxassetid://107901458751913",
        1.5,
        2,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.4 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://134279576638277",
        1.25,
        2,
        true,
        10
    )
end
