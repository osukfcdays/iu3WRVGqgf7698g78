return function(arg1, arg2, arg3) -- line: 1
    arg1:CreateSound(
        "rbxassetid://14241444681",
        1.5,
        1,
        true,
        10
    )
    arg1:CreateSound(
        "rbxassetid://110122962237431",
        1.75,
        1.25 + 0.25 * math.random(),
        true,
        5
    )

    if not arg1:_AnimationWait(script.Name, arg3, 0.55 / arg2) then
        return
    end

    arg1:CreateSpectatorSound(
        "rbxassetid://113941779770778",
        1,
        1 + 0.1 * math.random(),
        true,
        10
    )
    arg1:CreateSpectatorSound(
        "rbxassetid://110122962237431",
        0.5,
        1 + 0.5 * math.random(),
        true,
        5
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
    arg1:CreateSpectatorSound(
        "rbxassetid://110122962237431",
        0.5,
        1 + 0.5 * math.random(),
        true,
        5
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
    arg1:CreateSpectatorSound(
        "rbxassetid://110122962237431",
        0.5,
        1 + 0.5 * math.random(),
        true,
        5
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
    arg1:CreateSpectatorSound(
        "rbxassetid://110122962237431",
        0.5,
        1 + 0.5 * math.random(),
        true,
        5
    )
end
