return function(arg1, arg2, arg3) -- line: 1
    if not arg1:_AnimationWait(script.Name, arg3, 0.65 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://118906938239363",
        1,
        0.9 + 0.2 * math.random(),
        true,
        10
    )
end
