return function(arg1, arg2, arg3) -- line: 1
    if not arg1:_AnimationWait(script.Name, arg3, 0.3 / arg2) then
        return
    end

    arg1:PlayShadowPoofParticles(2, true)
end
