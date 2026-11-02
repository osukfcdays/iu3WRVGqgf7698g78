return function(arg1, arg2, arg3) -- line: 1
    while true do
        if not arg1.Animator:IsAnimationHashValid(script.Name, arg3) then
            break
        end

        if not arg1:_AnimationWait(script.Name, arg3, 0.1 / arg2) then
            return
        end

        arg1:CreateSound(
            "rbxassetid://130511754869111",
            1,
            1 + 0.1 * math.random(),
            true,
            10
        )
        arg1:CreateSound(
            "rbxassetid://119684878895970",
            1,
            1 + 0.1 * math.random(),
            true,
            10
        )

        if not arg1:_AnimationWait(script.Name, arg3, 0.15 / arg2) then
            return
        end

        arg1:CreateSound(
            "rbxassetid://130511754869111",
            1,
            1 + 0.1 * math.random(),
            true,
            10
        )
        arg1:CreateSound(
            "rbxassetid://119684878895970",
            1,
            1 + 0.1 * math.random(),
            true,
            10
        )

        if not arg1:_AnimationWait(script.Name, arg3, 0.2 / arg2) then
            return
        end

        arg1:CreateSound(
            "rbxassetid://130511754869111",
            1,
            1 + 0.1 * math.random(),
            true,
            10
        )
        arg1:CreateSound(
            "rbxassetid://119684878895970",
            1,
            1 + 0.1 * math.random(),
            true,
            10
        )

        if not arg1:_AnimationWait(script.Name, arg3, 0.2 / arg2) then
            return
        end

        arg1:CreateSound(
            "rbxassetid://130511754869111",
            1,
            1 + 0.1 * math.random(),
            true,
            10
        )
        arg1:CreateSound(
            "rbxassetid://119684878895970",
            1,
            1 + 0.1 * math.random(),
            true,
            10
        )

        if not arg1:_AnimationWait(script.Name, arg3, 0.15 / arg2) then
            return
        end

        arg1:CreateSound(
            "rbxassetid://130511754869111",
            1,
            1 + 0.1 * math.random(),
            true,
            10
        )
        arg1:CreateSound(
            "rbxassetid://119684878895970",
            1,
            1 + 0.1 * math.random(),
            true,
            10
        )
    end
end
