return function(arg1, arg2, arg3) -- line: 1
    arg1:CreateSound(
        "rbxassetid://85453370165436",
        1,
        1.1,
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.5 / arg2) then
        return
    end

    arg1:CreateSound(
        "rbxassetid://136633555539199",
        1,
        0.75,
        true,
        10
    )
end
