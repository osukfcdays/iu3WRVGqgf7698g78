local t = { 25, 33, 37, 45, 51, 56, 66, 107, 124, 132, 152, 155 }

return function(arg1, arg2, arg3) -- line: 3
    -- upvalues:
    --  [1] t (copy)

    for key, val in pairs(t) do
        arg1:CreateSound(
            "rbxassetid://14241444681",
            1,
            1 + 0.25 * math.random(),
            true,
            10
        )
        arg1:CreateSound(
            "rbxassetid://110122962237431",
            1.25,
            1.25 + 0.25 * math.random() + 0.25,
            true,
            5
        )

        if not arg1:_AnimationWait(script.Name, arg3, (val - (t[key - 1] or 0)) / 60 / arg2) then
            return
        end
    end
end
