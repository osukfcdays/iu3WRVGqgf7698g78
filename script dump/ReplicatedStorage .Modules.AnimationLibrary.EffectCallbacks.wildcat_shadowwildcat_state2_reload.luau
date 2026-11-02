return function(arg1, arg2, arg3) -- line: 1
    arg1:PlayShadowPoofParticles(2)

    if not arg1:_AnimationWait(script.Name, arg3, 1.2 / arg2) then
        return
    end

    arg1:PlayShadowPoofParticles(1, true)

    if not arg1:_AnimationWait(script.Name, arg3, 0.12 / arg2) then
        return
    end

    arg1:PlayShadowPoofParticles(2, true)
end
