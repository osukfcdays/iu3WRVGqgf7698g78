return function(arg1, arg2, arg3) -- line: 1
    arg1:CreateSound(
        "rbxassetid://13160400909",
        1,
        0.9 + 0.2 * math.random(),
        true,
        10
    )
    arg1:CreateSound(
        "rbxassetid://101733853413710",
        1,
        1 + 0.1 * math.random(),
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 1.05 / arg2) then
        return
    end

    arg1:CreateSpectatorSound(
        "rbxassetid://113941779770778",
        1,
        1 + 0.1 * math.random(),
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.3 / arg2) then
        return
    end

    arg1:CreateSpectatorSound(
        "rbxassetid://108891371725091",
        1,
        1 + 0.1 * math.random(),
        true,
        10
    )
    arg1:CreateSpectatorSound(
        "rbxassetid://76064160033456",
        1,
        1 + 0.1 * math.random(),
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.55 / arg2) then
        return
    end

    arg1:CreateSpectatorSound(
        "rbxassetid://108891371725091",
        1,
        1 + 0.1 * math.random(),
        true,
        10
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.15 / arg2) then
        return
    end

    arg1:CreateSpectatorSound(
        "rbxassetid://106430462780583",
        1,
        1.5 + 0.2 * math.random(),
        true,
        10
    )
end
