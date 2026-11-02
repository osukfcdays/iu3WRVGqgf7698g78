local t = {
    "rbxassetid://124463680760542",
    "rbxassetid://93542288707517",
    "rbxassetid://110622947899700",
    "rbxassetid://96443038656377"
}
local t_1 = { "rbxassetid://77109116351775", "rbxassetid://134101368984038" }

return function(arg1, _, _) -- line: 4
    -- upvalues:
    --  [1] t (copy)
    --  [2] t_1 (copy)

    arg1:CreateSound(
        "rbxassetid://17672502566",
        0.875,
        0.725 + 0.05 * math.random(),
        true,
        10
    )
    arg1:CreateSound(
        t[math.random(#t)],
        0.875,
        0.95 + 0.1 * math.random(),
        true,
        10
    )
    arg1:CreateSound(
        t_1[math.random(#t_1)],
        0.875,
        0.6 + 0.1 * math.random(),
        true,
        10
    )
end
