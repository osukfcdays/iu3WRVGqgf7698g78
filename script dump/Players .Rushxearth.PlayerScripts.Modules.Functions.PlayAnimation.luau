return function(arg1, arg2, ...) -- line: 1
    local Animation = Instance.new("Animation")
    Animation.AnimationId = arg2
    local animationTrack = arg1:LoadAnimation(Animation)
    animationTrack:Play(...)

    return animationTrack, Animation
end
