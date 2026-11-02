return function(arg1, _, _) -- line: 1
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
        "rbxassetid://107162559513589",
        0.75,
        0.75 + 0.125 * math.random(),
        true,
        5
    ):SetAttribute("DontClearSound", true)
end
