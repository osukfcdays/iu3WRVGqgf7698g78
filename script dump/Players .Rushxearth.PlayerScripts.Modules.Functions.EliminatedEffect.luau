local EliminatedEffect_m = require(
    game:GetService("Players").LocalPlayer.PlayerScripts.Modules.UserInterface.EliminatedEffect
)

return function(...) -- line: 5
    -- upvalues:
    --  [1] EliminatedEffect_m (copy)

    EliminatedEffect_m:Play(...)
end
