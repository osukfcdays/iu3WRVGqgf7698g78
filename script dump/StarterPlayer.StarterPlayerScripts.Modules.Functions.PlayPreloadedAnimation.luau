local PreloadController_m = require(
    game:GetService("Players").LocalPlayer.PlayerScripts.Controllers.PreloadController
)

return function(arg1, arg2) -- line: 5
    -- upvalues:
    --  [1] PreloadController_m (copy)

    arg1:LoadAnimation(PreloadController_m:GetPreloadedAnimation(arg2)):Play()
end
