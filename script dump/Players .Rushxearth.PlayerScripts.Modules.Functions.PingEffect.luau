local PingEffect_m = require(
    game:GetService("Players").LocalPlayer.PlayerScripts.Modules.UserInterface.PingEffect
)

return function(...) -- line: 5
    -- upvalues:
    --  [1] PingEffect_m (copy)

    PingEffect_m:Play(...)
end
