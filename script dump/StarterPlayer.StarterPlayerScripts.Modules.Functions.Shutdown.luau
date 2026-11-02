local Shutdown_m = require(
    game:GetService("Players").LocalPlayer.PlayerScripts.Modules.UserInterface.Shutdown
)

return function(arg1) -- line: 5
    -- upvalues:
    --  [1] Shutdown_m (copy)

    Shutdown_m:Enable(arg1)
end
