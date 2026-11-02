local TracerEffect_m = require(
    game:GetService("Players").LocalPlayer.PlayerScripts.Modules.TracerEffect
)

return function(...) -- line: 5
    -- upvalues:
    --  [1] TracerEffect_m (copy)

    TracerEffect_m:Play(...)
end
