local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")
local PlayerDataController_m = require(
    game:GetService("Players").LocalPlayer.PlayerScripts.Controllers.PlayerDataController
)
local t = {}
t.__index = t

function t._new() -- line: 12
    -- upvalues:
    --  [1] t (copy)

    local t_1 = setmetatable({}, t)
    t_1._default_settings_cooldown = 0
    t_1:_Init()

    return t_1
end

function t.GetMobileButtonSetting(
    _,
    arg2,
    arg3,
    arg4,
    arg5
) -- line: 26
    -- upvalues:
    --  [1] PlayerDataController_m (copy)

    local _ = function(arg6) --[[ get ]] -- line: 27
        -- upvalues:
        --  [1] arg5 (copy)
        --  [2] PlayerDataController_m (ref)

        if arg5 and arg5[arg6] ~= nil then
            return arg5[arg6]
        end

        return (PlayerDataController_m:GetSetting(arg6))
    end

    local v1 = if not arg4 then nil else "MobileButton " .. arg2 .. " " .. arg4

    if v1 and PlayerDataController_m:GetSetting("MobileButton " .. arg2 .. " Override") then
        if arg5 and arg5[v1] ~= nil then
            return arg5[v1]
        end

        return (PlayerDataController_m:GetSetting(v1))
    end

    if arg3 then
        if arg5 and arg5[arg3] ~= nil then
            return arg5[arg3]
        end

        return (PlayerDataController_m:GetSetting(arg3))
    end

    return nil
end

function t.SwitchSettingsProfile(_, arg8) -- line: 39
    -- upvalues:
    --  [1] ReplicatedStorage (copy)

    assert(if typeof(arg8) ~= "number" then false else true)
    ReplicatedStorage.Remotes.Data.SwitchSettingsProfile:FireServer(arg8)
end

function t.ChangeSetting(arg9, arg10, arg11) -- line: 44
    arg9:ChangeSettings({ { arg10, arg11 } })
end

function t.ChangeSettings(_, arg13) -- line: 48
    -- upvalues:
    --  [1] ReplicatedStorage (copy)

    ReplicatedStorage.Remotes.Data.ChangeSettings:FireServer(arg13)
end

function t.DefaultSettings(arg14, arg15) -- line: 52
    -- upvalues:
    --  [1] ReplicatedStorage (copy)

    if tick() < arg14._default_settings_cooldown then
        return
    end

    arg14._default_settings_cooldown = tick() + 1
    ReplicatedStorage.Remotes.Data.DefaultSettings:FireServer(arg15)
end

function t._ResetHUDSetting(arg16) -- line: 65
    -- upvalues:
    --  [1] TeleportService (copy)

    if TeleportService:GetTeleportSetting("DontResetHUDSetting") then
        return
    end

    TeleportService:SetTeleportSetting("DontResetHUDSetting", true)
    arg16:ChangeSetting("Hide HUD", false)
end

function t._Init(arg17) -- line: 74
    task.defer(arg17._ResetHUDSetting, arg17)
end

return t._new()
