local RunService = game:GetService("RunService")

return function(arg1, arg2, arg3) -- line: 3
    -- upvalues:
    --  [1] RunService (copy)

    if not arg1:_AnimationWait(script.Name, arg3, 0.75 / arg2) then
        return
    end

    local v2 = arg1:CreateSound(
        "rbxassetid://135262581066376",
        1,
        1,
        true,
        10
    )

    while true do
        if not arg1.Animator:IsAnimationHashValid(script.Name, arg3) then
            break
        end

        RunService.RenderStepped:Wait()
    end

    if v2 then
        v2:Destroy()
    end
end
