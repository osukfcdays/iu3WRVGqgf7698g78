return function(arg1, arg2, arg3) -- line: 1
    if not arg1:_AnimationWait(script.Name, arg3, 0.68 / arg2) then
        return
    end

    arg1:PlayReloadStartParticles()

    if not arg1:_AnimationWait(script.Name, arg3, 0.75 / arg2) then
        return
    end

    arg1:PlayReloadFinishParticles()
end
