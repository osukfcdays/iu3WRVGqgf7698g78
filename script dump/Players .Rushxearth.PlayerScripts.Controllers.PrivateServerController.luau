local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local CONSTANTS_m = require(ReplicatedStorage.Modules.CONSTANTS)
local ReplicatedClass_m = require(ReplicatedStorage.Modules.ReplicatedClass)
local Signal_m = require(ReplicatedStorage.Modules.Signal)
local t = { "FreecamEnabled", "ArcadeCanPlayAllMaps" }
local t_1 = setmetatable({}, ReplicatedClass_m)
t_1.__index = t_1

function t_1._new() -- line: 14
    -- upvalues:
    --  [1] ReplicatedClass_m (copy)
    --  [2] t_1 (copy)
    --  [3] Signal_m (copy)

    local t_2 = setmetatable(ReplicatedClass_m.new(), t_1)
    t_2.BannedPlayersChanged = Signal_m.new()
    t_2.BannedPlayers = {}
    t_2:_Init()

    return t_2
end

function t_1.ServerKick(_, arg2) -- line: 30
    -- upvalues:
    --  [1] ReplicatedStorage (copy)

    ReplicatedStorage.Remotes.PrivateServer.KickPlayer:FireServer(arg2)
end

function t_1.ServerBan(_, arg4) -- line: 34
    -- upvalues:
    --  [1] ReplicatedStorage (copy)

    ReplicatedStorage.Remotes.PrivateServer.BanPlayer:FireServer(arg4)
end

function t_1._ObjectAdded(_, arg6) -- line: 42
    -- upvalues:
    --  [1] CONSTANTS_m (copy)

    if CONSTANTS_m.IS_PRIVATE_HUB_SERVER then
        return
    end

    task.defer(arg6.Destroy, arg6)
end

function t_1._SetBannedPlayers(arg7, arg8) -- line: 50
    arg7.BannedPlayers = arg8
    arg7.BannedPlayersChanged:Fire()
end

function t_1._FetchBannedPlayers(arg9) -- line: 55
    -- upvalues:
    --  [1] CONSTANTS_m (copy)
    --  [2] Players (copy)
    --  [3] ReplicatedStorage (copy)

    if not CONSTANTS_m.IS_PRIVATE_SERVER_OWNER(Players.LocalPlayer.UserId) then
        return
    end

    local Success, Result = pcall(
        ReplicatedStorage.Remotes.PrivateServer.FetchBannedPlayers.InvokeServer,
        ReplicatedStorage.Remotes.PrivateServer.FetchBannedPlayers
    )

    if not Success then
        return
    end

    arg9:_SetBannedPlayers(Result)
end

function t_1._Setup(arg10) -- line: 69
    -- upvalues:
    --  [1] t (copy)

    for _, val in pairs(t) do
        workspace:GetAttributeChangedSignal(val):Connect(function() --[[ update ]] -- line: 71
            -- upvalues:
            --  [1] arg10 (copy)
            --  [2] val (copy)

            arg10:SetReplicate(val, workspace:GetAttribute(val))
        end)
        arg10:SetReplicate(val, workspace:GetAttribute(val))
    end
end

function t_1._Init(arg11) -- line: 80
    -- upvalues:
    --  [1] ReplicatedStorage (copy)
    --  [2] CollectionService (copy)

    ReplicatedStorage.Remotes.PrivateServer.ReplicateBannedPlayers.OnClientEvent:Connect(function(
        arguments
    ) -- line: 81
        -- upvalues:
        --  [1] arg11 (copy)

        arg11:_SetBannedPlayers(arguments)
    end)
    CollectionService:GetInstanceAddedSignal("LobbyPrivateServerOnly"):Connect(function(arg13) -- line: 85
        -- upvalues:
        --  [1] arg11 (copy)

        arg11:_ObjectAdded(arg13)
    end)

    for _, val_1 in pairs(CollectionService:GetTagged("LobbyPrivateServerOnly")) do
        task.defer(arg11._ObjectAdded, arg11, val_1)
    end

    arg11:_Setup()
    task.defer(arg11._FetchBannedPlayers, arg11)
end

return t_1._new()
