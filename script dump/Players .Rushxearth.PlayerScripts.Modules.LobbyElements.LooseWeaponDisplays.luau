local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local CONSTANTS_m = require(ReplicatedStorage.Modules.CONSTANTS)
local _ = require(ReplicatedStorage.Modules.CosmeticLibrary)
local _ = require(ReplicatedStorage.Modules.ItemLibrary)
local ShopLibrary_m = require(ReplicatedStorage.Modules.ShopLibrary)
local PlayerDataController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.PlayerDataController
)
local LobbyController_m = require(Players.LocalPlayer.PlayerScripts.Controllers.LobbyController)
local LooseWeaponDisplay_m = require(Players.LocalPlayer.PlayerScripts.Modules.LooseWeaponDisplay)
local LobbyElement_m = require(Players.LocalPlayer.PlayerScripts.Modules.LobbyElement)
local t = setmetatable({}, LobbyElement_m)
t.__index = t

function t._new(...) -- line: 17
    -- upvalues:
    --  [1] LobbyElement_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(LobbyElement_m.new(...), t)
    t_1.Displays = {}
    t_1:_Init()

    return t_1
end

function t.Shuffle(arg1) -- line: 31
    -- upvalues:
    --  [1] PlayerDataController_m (copy)
    --  [2] ShopLibrary_m (copy)
    --  [3] CONSTANTS_m (copy)

    local t_2 = {}

    for _, val in pairs(PlayerDataController_m:Get("WeaponInventory")) do
        t_2[val.Name] = true
    end

    local t_3 = {}

    for _, val_1 in pairs(
        ShopLibrary_m:GetReleasedOwnableWeapons(
            CONSTANTS_m.WEAPON_EARLY_ACCESS_TIME_OFFSET,
            ShopLibrary_m.OwnableWeaponsAlphabetized
        )
    ) do
        if not t_2[val_1] then
            table.insert(t_3, math.random(1, #t_3 + 1), val_1)
        end
    end

    local t_4 = {}

    for index = 1, #arg1.Displays do
        table.insert(t_4, math.random(1, #t_4 + 1), index)
    end

    for _, val_2 in pairs(t_4) do
        arg1.Displays[val_2]:ChangeWeapon(
            arg1:_VerifyLooseWeaponDisplayWeapon(table.remove(t_3, 1))
        )
    end
end

function t.Update(arg2, arg3) -- line: 58
    for _, val_3 in pairs(arg2.Displays) do
        val_3:Update(arg3)
    end
end

function t._VerifyLooseWeaponDisplayWeapon(_, arg5) -- line: 68
    -- upvalues:
    --  [1] PlayerDataController_m (copy)

    if arg5 and not PlayerDataController_m:GetWeaponData(arg5) then
        return arg5
    end

    return nil
end

function t._ObjectAdded(arg6, arg7) -- line: 72
    -- upvalues:
    --  [1] LooseWeaponDisplay_m (copy)

    local v6 = LooseWeaponDisplay_m.new(arg7)
    table.insert(arg6.Displays, v6)
end

function t._Init(arg8) -- line: 77
    -- upvalues:
    --  [1] LobbyController_m (copy)
    --  [2] PlayerDataController_m (copy)
    --  [3] CollectionService (copy)

    LobbyController_m.LocalFighter:GetDataChangedSignal("IsInDuel"):Connect(function() -- line: 78
        -- upvalues:
        --  [1] LobbyController_m (ref)
        --  [2] arg8 (copy)

        if not LobbyController_m.LocalFighter:Get("IsInDuel") then
            arg8:Shuffle()
        end
    end)
    PlayerDataController_m:GetDataChangedSignal("WeaponInventory"):Connect(function() -- line: 84
        -- upvalues:
        --  [1] arg8 (copy)

        for _, val_4 in pairs(arg8.Displays) do
            val_4:ChangeWeapon(arg8:_VerifyLooseWeaponDisplayWeapon(val_4.CurrentWeapon))
        end
    end)
    CollectionService:GetInstanceAddedSignal("LobbyLooseWeaponDisplay"):Connect(function(arg9) -- line: 90
        -- upvalues:
        --  [1] arg8 (copy)

        arg8:_ObjectAdded(arg9)
    end)

    for _, val_5 in pairs(CollectionService:GetTagged("LobbyLooseWeaponDisplay")) do
        task.spawn(arg8._ObjectAdded, arg8, val_5)
    end

    arg8:Shuffle()
end

return t._new()
