local LocalizationService = game:GetService("LocalizationService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")
local UserService = game:GetService("UserService")
local Players = game:GetService("Players")
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local PlayerDataController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("PlayerDataController")
)
local t = {}
t.__index = t

function t._new() -- line: 13
    -- upvalues:
    --  [1] t (copy)

    local t_1 = setmetatable({}, t)
    t_1._is_fetching_user_info = {}
    t_1._user_info_cache = {}
    t_1:_Init()

    return t_1
end

function t.IsChina(_, arg2) -- line: 28
    -- upvalues:
    --  [1] PlayerDataController_m (copy)

    local v2 = arg2 or PlayerDataController_m:Get("PolicyInfo")

    return not v2 or v2.IsSubjectToChinaPolicies
end

function t.IsExternalReferencesAllowed(arg3, arg4) -- line: 34
    -- upvalues:
    --  [1] PlayerDataController_m (copy)

    local v4 = PlayerDataController_m:Get("PolicyInfo")
    local v5 = v4

    if v5 then
        v5 = not arg3:IsChina()

        if v5 then
            v5 = table.find(v4.AllowedExternalLinkReferences, arg4 or "YouTube")
        end
    end

    return v5
end

function t.ArePaidRandomItemsRestricted(arg5, arg6) -- line: 40
    -- upvalues:
    --  [1] PlayerDataController_m (copy)

    local v6 = arg6 or PlayerDataController_m:Get("PolicyInfo")

    return not v6 or v6.ArePaidRandomItemsRestricted or arg5:IsChina(v6)
end

function t.IsPaidItemTradingAllowed(_) -- line: 46
    -- upvalues:
    --  [1] PlayerDataController_m (copy)

    local v8 = PlayerDataController_m:Get("PolicyInfo")
    local v9 = v8

    if v9 then
        v9 = v8.IsPaidItemTradingAllowed
    end

    return v9
end

function t.UserIDsAllowed(arg8) -- line: 52
    return not arg8:IsChina()
end

function t.UsernamesAllowed(arg9) -- line: 56
    return not arg9:IsChina()
end

function t.UseDisplayNames(_) -- line: 60
    return true
end

function t.GetName(arg11, arg12) -- line: 65
    -- upvalues:
    --  [1] Utility_m (copy)

    return Utility_m:GetName(arg12, arg11:UseDisplayNames() and arg12.DisplayName or arg12.Name)
end

function t.GetUserInfos(arg13, arg14, arg15) -- line: 69
    if not arg15 then
        return arg13:_GetUserInfos(arg14)
    end

    local t_2 = {}
    local t_3 = {}

    for key, val in pairs(arg14) do
        if arg15 >= key then
            table.insert(t_2, val)
        else
            table.insert(t_3, val)
        end
    end

    local t_4 = {}

    for _, val_1 in pairs({ t_2, t_3 }) do
        for key_2, val_2 in pairs(arg13:_GetUserInfos(val_1)) do
            t_4[key_2] = val_2
        end
    end

    return t_4
end

function t._GetUserInfos(arg16, arg17) -- line: 101
    -- upvalues:
    --  [1] UserService (copy)

    local t_5 = {}

    for _, val_3 in pairs(arg17) do
        if
            not arg16._user_info_cache[tostring(val_3)]
            and not arg16._is_fetching_user_info[tostring(val_3)]
        then
            table.insert(t_5, val_3)
        end
    end

    for _, val_4 in pairs(t_5) do
        arg16._is_fetching_user_info[tostring(val_4)] = true
    end

    local Success, Result = pcall(UserService.GetUserInfosByUserIdsAsync, UserService, t_5)

    for _, val_5 in pairs(t_5) do
        arg16._is_fetching_user_info[tostring(val_5)] = nil
    end

    if not Success then
        return {}
    end

    for _, val_6 in pairs(Result) do
        arg16._user_info_cache[tostring(val_6.Id)] = val_6
    end

    local t_6 = {}

    for _, val_7 in pairs(arg17) do
        t_6[tostring(val_7)] = arg16._user_info_cache[tostring(val_7)] or nil
    end

    for _, val_8 in pairs(Result) do
        t_6[tostring(val_8.Id)] = val_8
    end

    return t_6
end

function t._BlacklistedObject(arg18, arg19) -- line: 152
    if arg18._country_code == arg19:GetAttribute("CountryCode") then
        task.defer(arg19.Destroy, arg19)
    end
end

function t._WhitelistedObject(arg20, arg21) -- line: 158
    if arg20._country_code ~= arg21:GetAttribute("CountryCode") then
        task.defer(arg21.Destroy, arg21)
    end
end

function t._SetupLocaleObjects(arg22) -- line: 164
    -- upvalues:
    --  [1] LocalizationService (copy)
    --  [2] Players (copy)
    --  [3] CollectionService (copy)

    local Success_1, Result_1 = pcall(
        LocalizationService.GetCountryRegionForPlayerAsync,
        LocalizationService,
        Players.LocalPlayer
    )

    if Success_1 then
        arg22._country_code = Result_1
    else
        warn("Failed to fetch country code, error:", Result_1)
    end

    CollectionService:GetInstanceAddedSignal("RegionHideThisObject"):Connect(function(arg23) -- line: 173
        -- upvalues:
        --  [1] arg22 (copy)

        arg22:_BlacklistedObject(arg23)
    end)
    CollectionService:GetInstanceAddedSignal("RegionShowThisObject"):Connect(function(arg24) -- line: 177
        -- upvalues:
        --  [1] arg22 (copy)

        arg22:_WhitelistedObject(arg24)
    end)

    for _, val_9 in pairs(CollectionService:GetTagged("RegionHideThisObject")) do
        task.defer(arg22._BlacklistedObject, arg22, val_9)
    end

    for _, val_10 in pairs(CollectionService:GetTagged("RegionShowThisObject")) do
        task.defer(arg22._WhitelistedObject, arg22, val_10)
    end
end

function t._Init(arg25) -- line: 190
    task.defer(arg25._SetupLocaleObjects, arg25)
end

return t._new()
