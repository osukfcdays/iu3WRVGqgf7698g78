local _ = game:GetService("CollectionService")
local Players = game:GetService("Players")
local _ = require(Players.LocalPlayer.PlayerScripts.Controllers.FighterController)
local EliminationsDisplay_m = require(Players.LocalPlayer.PlayerScripts.Modules.EliminationsDisplay)
local LobbyElement_m = require(Players.LocalPlayer.PlayerScripts.Modules.LobbyElement)
local t = setmetatable({}, LobbyElement_m)
t.__index = t

function t._new(...) -- line: 13
    -- upvalues:
    --  [1] LobbyElement_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(LobbyElement_m.new(...), t)
    t_1.Displays = {}
    t_1:_Init()

    return t_1
end

function t._DisplayAdded(arg1, arg2) -- line: 33
    -- upvalues:
    --  [1] EliminationsDisplay_m (copy)

    table.insert(arg1.Displays, EliminationsDisplay_m.new(arg2))
end

function t._ClientFighterAdded(arg3, arg4) -- line: 37
    arg4.Elimination:Connect(function(...) -- line: 38
        -- upvalues:
        --  [1] arg3 (copy)

        for _, val in pairs(arg3.Displays) do
            val:NewElimination(...)
        end
    end)
end

function t._Init(_) -- line: 45
end

return t._new()
