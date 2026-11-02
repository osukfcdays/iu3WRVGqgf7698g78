local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local SkinHologram_m = require(Players.LocalPlayer.PlayerScripts.Modules.SkinHologram)
local LobbyElement_m = require(Players.LocalPlayer.PlayerScripts.Modules.LobbyElement)
local t = setmetatable({}, LobbyElement_m)
t.__index = t

function t._new(...) -- line: 10
    -- upvalues:
    --  [1] LobbyElement_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(LobbyElement_m.new(...), t)
    t_1.Holograms = {}
    t_1:_Init()

    return t_1
end

function t.Update(arg1, arg2) -- line: 24
    for _, val in pairs(arg1.Holograms) do
        val:Update(arg2)
    end
end

function t._ObjectAdded(arg3, arg4) -- line: 34
    -- upvalues:
    --  [1] SkinHologram_m (copy)

    local v3 = SkinHologram_m.new(arg4)
    table.insert(arg3.Holograms, v3)
end

function t._Init(arg5) -- line: 39
    -- upvalues:
    --  [1] CollectionService (copy)

    CollectionService:GetInstanceAddedSignal("LobbyDailyShopSkinHologram"):Connect(function(arg6) -- line: 40
        -- upvalues:
        --  [1] arg5 (copy)

        arg5:_ObjectAdded(arg6)
    end)

    for _, val_1 in pairs(CollectionService:GetTagged("LobbyDailyShopSkinHologram")) do
        task.defer(arg5._ObjectAdded, arg5, val_1)
    end
end

return t._new()
