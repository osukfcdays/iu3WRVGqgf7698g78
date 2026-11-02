local t = { "rbxassetid://137835445333923" }
local t_1 = {
    "rbxassetid://111635700014206",
    "rbxassetid://71082815960227",
    "rbxassetid://102452124576950"
}

return function(arg1, _, _) -- line: 4
    -- upvalues:
    --  [1] t (copy)
    --  [2] t_1 (copy)

    arg1:CreateSound(
        t[math.random(#t)],
        1,
        1.25 + 0.25 * math.random(),
        true,
        10
    )
    arg1:CreateSound(
        t_1[math.random(#t_1)],
        1,
        0.95 + 0.1 * math.random(),
        true,
        10
    )
end
