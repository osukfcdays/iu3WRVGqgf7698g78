return function(arg1, arg2, arg3) -- line: 1
    local v1 = arg1:CreateSound(
        "rbxassetid://13456860578",
        1.25,
        1.25,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.4 / arg2) then
        return
    end

    if v1 then
        v1:Destroy()
    end

    arg1:CreateSound(
        "rbxassetid://13483008798",
        1,
        2,
        true,
        10
    )
end
