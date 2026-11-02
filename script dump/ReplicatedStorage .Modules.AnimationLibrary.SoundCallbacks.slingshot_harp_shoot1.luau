return function(arg1, _, _) -- line: 1
    local v1, _, _ = workspace.CurrentCamera.CFrame:ToEulerAnglesYXZ()
    local clampedValue = math.clamp(v1 / 1.3962634015954636, -1, 1)
    arg1:CreateSound(
        "rbxassetid://117069125273832",
        0.75,
        clampedValue * 0.5 + 1.75,
        true,
        5
    )
    arg1:CreateSound(
        "rbxassetid://127039236309973",
        1,
        clampedValue * 0.25 + 1,
        true,
        5
    )
end
