local _ = { 4, 6, 12, 17, 23, 28, 33, 38, 42, 46, 51, 56, 62, 67 }
local t_1 = { "rbxassetid://14000023581", "rbxassetid://14000023392" }

return function(arg1, arg2, arg3) -- line: 6
    -- upvalues:
    --  [1] t_1 (copy)

    for _ = 1, 15 do
        arg1:CreateSound(
            t_1[math.random(#t_1)],
            0.75 + 0.5 * math.random(),
            2 + 0.5 * math.random(),
            true,
            10
        )
        arg1:CreateSound(
            "rbxassetid://13455968853",
            0.375,
            1.25 + 0.25 * math.random(),
            true,
            10
        )

        if not arg1:_AnimationWait(script.Name, arg3, 0.06666666666666667 / arg2) then
            return
        end
    end
end
