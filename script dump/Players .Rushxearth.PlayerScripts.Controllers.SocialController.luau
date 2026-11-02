local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SocialService = game:GetService("SocialService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local Signal_m = require(ReplicatedStorage.Modules.Signal)
local t = {}
t.__index = t

function t._new() -- line: 11
    -- upvalues:
    --  [1] t (copy)
    --  [2] Signal_m (copy)

    local t_1 = setmetatable({}, t)
    t_1.CanSendGameInviteChanged = Signal_m.new()
    t_1.FriendsFetched = Signal_m.new()
    t_1.CanSendGameInvite = nil
    t_1.Friends = {}
    t_1._is_friends_with = {}
    t_1:_Init()

    return t_1
end

function t.IsFriendsWith(arg1, arg2) -- line: 31
    -- upvalues:
    --  [1] Players (copy)

    local v1 = arg1._is_friends_with[tostring(arg2)]

    if v1 then
        return v1
    end

    local Success, Result = pcall(Players.LocalPlayer.IsFriendsWithAsync, Players.LocalPlayer, arg2)

    if not Success then
        warn("Failed to check IsFriendsWithAsync, error:", Result)

        return false
    end

    return Result
end

function t.PromptFriendInvite(_) -- line: 48
    -- upvalues:
    --  [1] HttpService (copy)
    --  [2] ReplicatedStorage (copy)
    --  [3] SocialService (copy)
    --  [4] Players (copy)

    local ExperienceInviteOptions = Instance.new("ExperienceInviteOptions")
    ExperienceInviteOptions.PromptMessage = "Challenge your friends to a duel!"
    ExperienceInviteOptions.InviteMessageId = "1dc4ba3b-4978-ea4f-9c63-35babfc20045"
    local t_2 = { SenderHash = ReplicatedStorage.Remotes.Misc.RequestInviteData:InvokeServer() }
    ExperienceInviteOptions.LaunchData = HttpService:JSONEncode(t_2)
    SocialService:PromptGameInvite(Players.LocalPlayer, ExperienceInviteOptions)
end

function t._FetchFriends(arg4) -- line: 61
    -- upvalues:
    --  [1] Players (copy)

    for _ = 1, 3 do
        local Success_1, Result_1 = pcall(
            Players.LocalPlayer.GetFriendsOnlineAsync,
            Players.LocalPlayer,
            50
        )

        if not Success_1 then
            warn("Failed to fetch GetFriendsOnlineAsync, error:", Result_1)
        else
            arg4.Friends = Result_1
            break
        end

        wait(1)
    end

    for _, val in pairs(arg4.Friends) do
        arg4._is_friends_with[tostring(val.VisitorId)] = true
    end

    arg4.FriendsFetched:Fire()
end

function t._FetchCanSendGameInvite(arg5) -- line: 82
    -- upvalues:
    --  [1] SocialService (copy)
    --  [2] Players (copy)

    for _ = 1, 3 do
        local Success_2, Result_2 = pcall(
            SocialService.CanSendGameInviteAsync,
            SocialService,
            Players.LocalPlayer
        )

        if not Success_2 then
            warn("Failed to fetch CanSendGameInviteAsync:", Result_2)
        else
            arg5.CanSendGameInvite = Result_2
            break
        end

        wait(1)
    end

    arg5.CanSendGameInviteChanged:Fire()
end

function t._Init(arg6) -- line: 99
    task.defer(arg6._FetchFriends, arg6)
    task.defer(arg6._FetchCanSendGameInvite, arg6)
end

return t._new()
