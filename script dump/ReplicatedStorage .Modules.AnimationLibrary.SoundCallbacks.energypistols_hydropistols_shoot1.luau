return function(arg1, _, _) -- line: 1
    if tick() < arg1.EnergyPistolsShootSoundCooldown then
        return
    end

    arg1.EnergyPistolsShootSoundCooldown = tick() + 0.05
    arg1:CreateSound(
        "rbxassetid://120386834342865",
        0.625,
        1 + 0.2 * math.random(),
        true,
        1
    )
    arg1:CreateSound(
        "rbxassetid://18763517194",
        1,
        1 + 0.25 * math.random(),
        true,
        5
    )
end
