return function(arg1, arg2, arg3) -- line: 1
    arg1:CreateSound(
        "rbxassetid://124941279780653",
        1,
        1 + 0.1 * math.random(),
        true,
        5
    ):SetAttribute("DontClearSound", true)
    arg1:CreateSound(
        "rbxassetid://125852790214228",
        1,
        1 + 0.1 * math.random(),
        true,
        5
    ):SetAttribute("DontClearSound", true)
    arg1:CreateSound(
        "rbxassetid://124261472912756",
        1,
        1 + 0.1 * math.random(),
        true,
        5
    ):SetAttribute("DontClearSound", true)
    arg1:CreateSound(
        "rbxassetid://17803360572",
        1,
        1 + 0.2 * math.random(),
        true,
        10
    ):SetAttribute("DontClearSound", true)

    for _ = 1, 5 do
        if not arg1:_AnimationWait(script.Name, arg3, 0.1 / arg2) then
            return
        end

        arg1:CreateSound(
            "rbxassetid://17803308936",
            1 + 0.25 * math.random(),
            1 + 0.3 * math.random(),
            true,
            10
        ):SetAttribute("DontClearSound", true)
    end
end
