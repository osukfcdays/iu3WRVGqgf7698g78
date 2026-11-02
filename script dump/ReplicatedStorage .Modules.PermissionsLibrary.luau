local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CONSTANTS_m = require(ReplicatedStorage.Modules.CONSTANTS)
local StudioPermissionsRoleTest = require(ReplicatedStorage.Modules.TestLibrary):GetTestAttribute(
    "StudioPermissionsRoleTest"
)
local t = { USE_GROUP_ROLES_INSTEAD_OF_DATASTORES = true }
local v1 = not StudioPermissionsRoleTest

if v1 then
    v1 = CONSTANTS_m.IS_STUDIO or CONSTANTS_m.IS_TESTING_SERVER
end

t.ALWAYS_AUTHORIZED_TO_USE_COMMANDS = v1
v1 = not StudioPermissionsRoleTest and CONSTANTS_m.IS_STUDIO
t.ALWAYS_HAS_PERMISSION = v1
t.PermissionsOrder = {}
t.Permissions = {}
t.Teams = {}
t.Roles = {}

function t.GetPermissionsRoleNameFromDisplayName(arg1, arg2) -- line: 18
    for key, val in pairs(arg1.Roles) do
        if val.DisplayName == arg2 then
            return key
        end
    end
end

function t.IsAdministrator(arg3, arg4) -- line: 26
    if arg3.ALWAYS_HAS_PERMISSION then
        return true
    end

    for _, val_1 in pairs(arg4) do
        local v2 = arg3.Roles[val_1]
        local v3 = pairs
        local v4 = v2 and v2.PermissionNames or {}

        for _, val_2 in v3(v4) do
            local v5 = arg3.Permissions[val_2]

            if v5 and v5.ExtraInformation.IsAdministrator then
                return true
            end
        end
    end

    return false
end

function t.HasPermission(arg5, arg6, arg7) -- line: 46
    if arg5:IsAdministrator(arg7) then
        return true
    end

    for _, val_3 in pairs(arg7) do
        local v6 = arg5.Roles[val_3]

        if v6 and table.find(v6.PermissionNames, arg6) then
            return true
        end
    end

    return false
end

function t.CanViewPermissionsPage(arg8, arg9) -- line: 62
    return arg8:HasPermission("permission_permissions_page_access", arg9)
end

function t.CanManageRole(arg10, arg11, arg12) -- line: 66
    if arg10:IsAdministrator(arg12) then
        return true
    end

    for _, val_4 in pairs(arg12) do
        local v7 = arg10.Roles[val_4]
        local v8 = pairs
        local v9 = v7 and v7.PermissionNames or {}

        for _, val_5 in v8(v9) do
            local v10 = arg10.Permissions[val_5]

            if
                v10
                and v10.ExtraInformation.ManageableRoles
                and table.find(v10.ExtraInformation.ManageableRoles, arg11)
            then
                return true
            end
        end
    end

    return false
end

function t.GetManageableRoles(arg13, arg14) -- line: 86
    local t_1 = {}

    for key_6, _ in pairs(arg13.Roles) do
        if arg13:CanManageRole(key_6, arg14) then
            table.insert(t_1, key_6)
        end
    end

    return t_1
end

local function add_permission(arg15, arg16, arg17, arg18) -- line: 98
    -- upvalues:
    --  [1] t (copy)

    assert(not t.Permissions[arg15])
    local t_2 = {
        Name = arg15,
        DisplayName = arg16,
        Description = arg17,
        ExtraInformation = arg18 or {},
        PermissionValue = -(#t.PermissionsOrder)
    }
    t.Permissions[t_2.Name] = t_2
    table.insert(t.PermissionsOrder, t_2.Name)
end

add_permission(
    "permission_administrator",
    "Administrator",
    "All permissions are granted",
    { IsAdministrator = true }
)
add_permission(
    "permission_permissions_page_access",
    "Permissions Page",
    "Grants access to view the Permissions page"
)
add_permission(
    "permission_leaders_management",
    "Manage Leaders",
    "Add, remove, promote, & demote Team Leads",
    { ManageableRoles = { "role_leadtester", "role_leadgamemod" } }
)
add_permission(
    "permission_freecamaccess",
    "Freecam Access",
    "Grants access to using Freecam mode any time"
)
add_permission(
    "permission_funcommands",
    "Fun Commands",
    "Grants access to using fun commands in all servers"
)
add_permission(
    "permission_moderation_modpanel_access",
    "Moderation Page",
    "Grants access to view the Moderation page"
)
add_permission(
    "permission_moderation_modpanel_investigate_full",
    "Investigative Tools",
    "Allows you use tools to investigate top leaderboard players"
)
add_permission(
    "permission_moderation_modpanel_viewbanned_full",
    "View Ban Status & Logs",
    "Allows you to view the ban status & ban logs of any player"
)
add_permission(
    "permission_moderation_modpanel_viewactions_full",
    "View Action History",
    "Allows you to view the action history of any other Moderator"
)
add_permission(
    "permission_moderation_modpanel_teleport_full",
    "Join Any Player",
    "Allows you to teleport to anyone's server (except Private Servers)"
)
add_permission(
    "permission_moderation_modpanel_unban",
    "Unban Any Player",
    "Allows you to unban any player"
)
add_permission(
    "permission_moderation_modpanel_moderate_limited",
    "Ban Average Players",
    "Allows you to ban players under 10,000 Robux spent / 1,000 historic peak Win Streak / 3,600 historic peak ELO",
    { UnderThisELO = 3600, UnderThisStreak = 1000, UnderThisRobuxSpent = 10000 }
)
add_permission(
    "permission_moderation_modpanel_moderate_most",
    "Ban Most Players",
    "Allows you to ban any player, except high ranking Nosniy Games group members"
)
add_permission(
    "permission_moderation_modpanel_moderate_full",
    "Ban Any Player",
    "Allows you to ban any player"
)
add_permission(
    "permission_moderation_modpanel_evict_limited",
    "Evict From Hub & Arcade",
    "Allows you to kick players from hub duels & arcade servers only (affects bans)"
)
add_permission(
    "permission_moderation_modpanel_evict_full",
    "Evict From Anywhere",
    "Allows you to kick players from anywhere (affects bans)"
)
add_permission(
    "permission_moderation_modpanel_viewdata_limited",
    "View Necessary Player Data",
    "Allows you to view player data that is only relevant to obvious moderation purposes"
)
add_permission(
    "permission_moderation_modpanel_viewdata_most",
    "View Most Player Data",
    "Allows you to view everything in someone's player data, except total robux spent"
)
add_permission(
    "permission_moderation_modpanel_viewdata_full",
    "View All Player Data",
    "Allows you to view everything in someone's player data"
)
add_permission(
    "permission_moderation_modpanel_pardon_limited",
    "Pardon Some Anticheat Bans",
    "Allows you to pardon anticheat bans from a strict whitelist"
)
add_permission(
    "permission_moderation_modpanel_pardon_full",
    "Pardon Any Anticheat Ban",
    "Allows you to pardon any anticheat ban"
)
add_permission(
    "permission_moderation_modpanel_lock",
    "Ban Lock Powers",
    "Allows you to lock a player from being banned, unbanned, kicked, etc"
)
add_permission(
    "permission_moderation_modpanel_removelbs_limited",
    "Remove From Leaderboards",
    "Allows you to wipe players from all leaderboards (only works for banned / restricted players)"
)
add_permission(
    "permission_moderation_modpanel_warn_template",
    "Warn Players On Ban",
    "Allows you to send a template warning message to any player during a ban"
)
add_permission(
    "permission_moderation_modpanel_warn_custom",
    "Warn Any Player",
    "Allows you to send a custom warning message to any player"
)
add_permission(
    "permission_moderation_modpanel_restrict",
    "Restrict Any Player",
    "Allows you to restrict players from features such as casual & competitive leaderboards"
)
add_permission(
    "permission_moderation_management",
    "Manage Moderators",
    "Add, remove, promote, & demote anyone related to the Moderation Team",
    {
        ManageableRoles = {
            "role_trialgamemod",
            "role_jrgamemod",
            "role_gamemod",
            "role_srgamemod"
        }
    }
)
add_permission("permission_testing_zfaccess", "ZF Access", "Grants access to the testing server")
add_permission(
    "permission_testing_publiccommands_safe",
    "Helpful Commands",
    "Gives access to a few helpful debug commands in public servers"
)
add_permission(
    "permission_testing_publiccommands_bugrewards",
    "Bug Rewarder Command",
    "Gives access to the command to hand out bug rewards"
)
add_permission(
    "permission_testing_management",
    "Manage Testers",
    "Add, remove, promote, & demote anyone related to the Testing Team",
    { ManageableRoles = { "role_backuptester", "role_tester" } }
)

local function add_team(
    arg19,
    arg20,
    arg21,
    arg22,
    arg23
) -- line: 147
    -- upvalues:
    --  [1] t (copy)

    assert(not t.Teams[arg20])
    local t_9 = {
        TeamValue = arg19,
        Name = arg20,
        DisplayName = arg21,
        Icon = arg22,
        Color = arg23,
        RoleNames = {}
    }
    t.Teams[t_9.Name] = t_9
    table.sort(t_9.RoleNames, function(arg24, arg25) -- line: 161
        -- upvalues:
        --  [1] t (ref)

        return t.Permissions[arg24].PermissionValue > t.Permissions[arg25].PermissionValue
    end)
end

add_team(
    4,
    "team_leadership",
    "Leadership",
    "rbxassetid://111377968573170",
    Color3.fromRGB(191, 0, 255)
)
add_team(
    3,
    "team_moderation",
    "Moderation",
    "rbxassetid://118920750856778",
    Color3.fromRGB(230, 126, 34)
)
add_team(
    2,
    "team_testing",
    "Testing",
    "rbxassetid://18223601855",
    Color3.fromRGB(241, 196, 15)
)
add_team(
    1,
    "team_other",
    "Other",
    "rbxassetid://17548980857",
    Color3.fromRGB(127, 127, 127)
)

local function add_role(
    arg26,
    arg27,
    arg28,
    arg29,
    arg30,
    arg31,
    arg32
) -- line: 171
    -- upvalues:
    --  [1] t (copy)

    assert(t.Teams[arg27])
    local v13 = not t.Roles[arg29]

    if v13 then
        v13 = not t:GetPermissionsRoleNameFromDisplayName(arg31)
    end

    assert(v13)
    local _ = t:GetPermissionsRoleNameFromDisplayName(arg31)

    for _, val_7 in pairs(arg32) do
        assert(t.Permissions[val_7], val_7)
    end

    local t_10 = {
        GroupRoleID = arg26,
        TeamName = arg27,
        RoleValue = arg28,
        Name = arg29,
        Color = arg30,
        DisplayName = arg31,
        PermissionNames = arg32
    }
    t.Roles[t_10.Name] = t_10
    table.insert(t.Teams[t_10.TeamName].RoleNames, t_10.Name)
end

add_role(
    23832226,
    "team_leadership",
    2,
    "role_administrator",
    Color3.fromRGB(191, 0, 255),
    "Administrator",
    { "permission_administrator" }
)
add_role(
    855122020,
    "team_leadership",
    1,
    "role_director",
    Color3.fromRGB(113, 122, 254),
    "Director",
    {
        "permission_permissions_page_access",
        "permission_leaders_management",
        "permission_testing_management",
        "permission_moderation_management"
    }
)
add_role(
    855486017,
    "team_moderation",
    5,
    "role_leadgamemod",
    Color3.fromRGB(156, 41, 0),
    "Lead Game Moderator",
    {
        "permission_moderation_modpanel_access",
        "permission_moderation_modpanel_viewbanned_full",
        "permission_moderation_modpanel_removelbs_limited",
        "permission_moderation_modpanel_teleport_full",
        "permission_moderation_modpanel_moderate_full",
        "permission_moderation_modpanel_viewdata_full",
        "permission_moderation_modpanel_evict_full",
        "permission_moderation_modpanel_pardon_full",
        "permission_moderation_modpanel_warn_template",
        "permission_moderation_modpanel_warn_custom",
        "permission_moderation_modpanel_restrict",
        "permission_moderation_modpanel_viewactions_full",
        "permission_moderation_modpanel_investigate_full",
        "permission_moderation_modpanel_unban",
        "permission_moderation_modpanel_lock",
        "permission_permissions_page_access",
        "permission_moderation_management"
    }
)
add_role(
    855568028,
    "team_moderation",
    4,
    "role_srgamemod",
    Color3.fromRGB(255, 68, 0),
    "Senior Game Moderator",
    {
        "permission_moderation_modpanel_access",
        "permission_moderation_modpanel_viewbanned_full",
        "permission_moderation_modpanel_removelbs_limited",
        "permission_moderation_modpanel_teleport_full",
        "permission_moderation_modpanel_moderate_most",
        "permission_moderation_modpanel_viewdata_most",
        "permission_moderation_modpanel_evict_full",
        "permission_moderation_modpanel_pardon_limited",
        "permission_moderation_modpanel_warn_template",
        "permission_moderation_modpanel_warn_custom",
        "permission_moderation_modpanel_restrict",
        "permission_moderation_modpanel_viewactions_full",
        "permission_moderation_modpanel_investigate_full",
        "permission_moderation_modpanel_unban"
    }
)
add_role(
    854242030,
    "team_moderation",
    3,
    "role_gamemod",
    Color3.fromRGB(230, 126, 34),
    "Game Moderator",
    {
        "permission_moderation_modpanel_access",
        "permission_moderation_modpanel_viewbanned_full",
        "permission_moderation_modpanel_removelbs_limited",
        "permission_moderation_modpanel_teleport_full",
        "permission_moderation_modpanel_moderate_most",
        "permission_moderation_modpanel_viewdata_most",
        "permission_moderation_modpanel_evict_full",
        "permission_moderation_modpanel_pardon_limited",
        "permission_moderation_modpanel_warn_template",
        "permission_moderation_modpanel_warn_custom",
        "permission_moderation_modpanel_restrict",
        "permission_moderation_modpanel_viewactions_full",
        "permission_moderation_modpanel_investigate_full",
        "permission_moderation_modpanel_unban"
    }
)
add_role(
    854812013,
    "team_moderation",
    2,
    "role_jrgamemod",
    Color3.fromRGB(230, 150, 80),
    "Junior Game Moderator",
    {
        "permission_moderation_modpanel_access",
        "permission_moderation_modpanel_viewbanned_full",
        "permission_moderation_modpanel_removelbs_limited",
        "permission_moderation_modpanel_teleport_full",
        "permission_moderation_modpanel_moderate_most",
        "permission_moderation_modpanel_viewdata_limited",
        "permission_moderation_modpanel_evict_limited",
        "permission_moderation_modpanel_pardon_limited",
        "permission_moderation_modpanel_warn_template",
        "permission_moderation_modpanel_warn_custom",
        "permission_moderation_modpanel_restrict",
        "permission_moderation_modpanel_viewactions_full",
        "permission_moderation_modpanel_investigate_full",
        "permission_moderation_modpanel_unban"
    }
)
add_role(
    853986021,
    "team_moderation",
    1,
    "role_trialgamemod",
    Color3.fromRGB(230, 170, 118),
    "Trial Game Moderator",
    {
        "permission_moderation_modpanel_access",
        "permission_moderation_modpanel_viewbanned_full",
        "permission_moderation_modpanel_removelbs_limited",
        "permission_moderation_modpanel_teleport_full",
        "permission_moderation_modpanel_moderate_most",
        "permission_moderation_modpanel_viewdata_limited",
        "permission_moderation_modpanel_evict_limited",
        "permission_moderation_modpanel_pardon_limited",
        "permission_moderation_modpanel_warn_template",
        "permission_moderation_modpanel_restrict"
    }
)
add_role(
    855640022,
    "team_testing",
    3,
    "role_leadtester",
    Color3.fromRGB(162, 130, 0),
    "Lead Tester",
    {
        "permission_testing_zfaccess",
        "permission_testing_publiccommands_safe",
        "permission_testing_publiccommands_bugrewards",
        "permission_permissions_page_access",
        "permission_testing_management",
        "permission_moderation_modpanel_access",
        "permission_moderation_modpanel_teleport_full",
        "permission_moderation_modpanel_viewdata_full"
    }
)
add_role(
    33929719,
    "team_testing",
    2,
    "role_tester",
    Color3.fromRGB(241, 196, 15),
    "Tester",
    { "permission_testing_zfaccess", "permission_testing_publiccommands_safe" }
)
add_role(
    854386033,
    "team_testing",
    1,
    "role_backuptester",
    Color3.fromRGB(252, 231, 145),
    "Backup Tester",
    { "permission_testing_zfaccess", "permission_testing_publiccommands_safe" }
)
add_role(
    854788035,
    "team_other",
    2,
    "role_funcommands",
    Color3.fromRGB(127, 127, 127),
    "Fun Commands",
    { "permission_funcommands" }
)
add_role(
    854710017,
    "team_other",
    1,
    "role_freecam",
    Color3.fromRGB(127, 127, 127),
    "Freecam",
    { "permission_freecamaccess" }
)

local function final_asserts() -- line: 209
    -- upvalues:
    --  [1] t (copy)

    for _, val_8 in pairs(t.Permissions) do
        local v15 = pairs
        local v16 = val_8.ExtraInformation.ManageableRoles or {}

        for _, val_9 in v15(v16) do
            assert(t.Roles[val_9] ~= nil, val_9)
        end
    end
end

final_asserts()

return t
