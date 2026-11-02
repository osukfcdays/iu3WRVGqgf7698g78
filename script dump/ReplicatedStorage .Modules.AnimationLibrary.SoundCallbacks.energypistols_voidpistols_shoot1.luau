return function(arg1, _, _) -- line: 1
    if tick() < arg1.EnergyPistolsShootSoundCooldown then
        return
    end

    arg1.EnergyPistolsShootSoundCooldown = tick() + 0.05
    arg1:CreateSound(
        "rbxassetid://94684661380385",
        0.625,
        1 + 0.2 * math.random(),
        true,
        1
    )
end
