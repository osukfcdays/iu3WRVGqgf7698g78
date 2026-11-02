local Requests_m = require(
    game:GetService("Players").LocalPlayer.PlayerScripts.Modules.UserInterface.Lobby.Requests
)

return function(...) -- line: 5
    -- upvalues:
    --  [1] Requests_m (copy)

    Requests_m:ChallengeRequest(...)
end
