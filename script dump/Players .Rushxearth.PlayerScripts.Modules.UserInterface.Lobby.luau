local Players = game:GetService("Players")
local SpectateController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("SpectateController")
)
local FighterController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("FighterController")
)
local UILibrary_m = require(Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("UILibrary"))
local t = {}
t.__index = t

function t._new() -- line: 10
    -- upvalues:
    --  [1] t (copy)
    --  [2] UILibrary_m (copy)

    local t_1 = setmetatable({}, t)
    t_1.Frame = UILibrary_m:GetTo("MainFrame", "Lobby")
    t_1.Play = require(script:WaitForChild("Play"))
    t_1.Party = require(script:WaitForChild("Party"))
    t_1.Buttons = require(script:WaitForChild("Buttons"))
    t_1.Currency = require(script:WaitForChild("Currency"))
    t_1.Requests = require(script:WaitForChild("Requests"))
    t_1.Matchmaking = require(script:WaitForChild("Matchmaking"))
    t_1.LocalFighter = nil
    t_1._duel_connections = {}
    t_1:_Init()

    return t_1
end

function t._UpdateVisibility(arg1) -- line: 39
    -- upvalues:
    --  [1] SpectateController_m (copy)

    local v4 = arg1.LocalFighter

    if v4 then
        v4 = not arg1.LocalFighter:Get("IsInShootingRange")

        if v4 then
            v4 = not arg1.LocalFighter:Get("IsInDuel")

            if v4 then
                v4 = not SpectateController_m.CurrentDuelSubject
            end
        end
    end

    arg1.Play.Frame.Visible = v4
    arg1.Buttons.Frame.Visible = v4
    arg1.Currency.Frame.Visible = v4
    arg1.Requests.Frame.Visible = v4
    arg1.Party.BottomDisplayFrame.Visible = v4
end

function t._UpdateCurrentDuelSubject(arg2) -- line: 49
    -- upvalues:
    --  [1] SpectateController_m (copy)

    for _, val in pairs(arg2._duel_connections) do
        val:Disconnect()
    end

    arg2._duel_connections = {}

    if not SpectateController_m.CurrentDuelSubject then
        arg2:_UpdateVisibility()

        return
    end

    arg2:_UpdateVisibility()
end

function t._HookLocalFighter(arg3) -- line: 66
    -- upvalues:
    --  [1] FighterController_m (copy)

    arg3.LocalFighter = FighterController_m:WaitForLocalFighter()
    arg3.LocalFighter:GetDataChangedSignal("IsInDuel"):Connect(function() -- line: 69
        -- upvalues:
        --  [1] arg3 (copy)

        arg3:_UpdateVisibility()
    end)
    arg3.LocalFighter:GetDataChangedSignal("IsInShootingRange"):Connect(function() -- line: 73
        -- upvalues:
        --  [1] arg3 (copy)

        arg3:_UpdateVisibility()
    end)
    arg3:_UpdateVisibility()
end

function t._Init(arg4) -- line: 80
    -- upvalues:
    --  [1] SpectateController_m (copy)

    SpectateController_m.DuelSubjectChanged:Connect(function() -- line: 81
        -- upvalues:
        --  [1] arg4 (copy)

        arg4:_UpdateCurrentDuelSubject()
    end)
    arg4:_UpdateVisibility()
    arg4:_UpdateCurrentDuelSubject()
    task.spawn(arg4._HookLocalFighter, arg4)
end

return t._new()
