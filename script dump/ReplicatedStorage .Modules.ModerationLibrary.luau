local PermissionsLibrary_m = require(
    game:GetService("ReplicatedStorage").Modules.PermissionsLibrary
)
local t = {
    CanViewModerationPage = function(_, arg2) --[[ CanViewModerationPage ]] -- line: 7
        -- upvalues:
        --  [1] PermissionsLibrary_m (copy)

        return PermissionsLibrary_m:HasPermission("permission_moderation_modpanel_access", arg2)
    end,
    CanViewBanStatusAndLogs = function(_, arg4) --[[ CanViewBanStatusAndLogs ]] -- line: 11
        -- upvalues:
        --  [1] PermissionsLibrary_m (copy)

        return PermissionsLibrary_m:HasPermission(
            "permission_moderation_modpanel_viewbanned_full",
            arg4
        )
    end
}

function t.CanLookupPlayers(_, arg6) -- line: 15
    -- upvalues:
    --  [1] t (copy)

    return t:CanViewModerationPage(arg6)
end

function t.CanViewActionHistory(_, arg8) -- line: 19
    -- upvalues:
    --  [1] PermissionsLibrary_m (copy)

    return PermissionsLibrary_m:HasPermission(
        "permission_moderation_modpanel_viewactions_full",
        arg8
    )
end

function t.CanUseInvestigativeCommands(_, arg10) -- line: 23
    -- upvalues:
    --  [1] PermissionsLibrary_m (copy)

    return PermissionsLibrary_m:HasPermission(
        "permission_moderation_modpanel_investigate_full",
        arg10
    )
end

function t.CanPardonLimited(_, arg12) -- line: 27
    -- upvalues:
    --  [1] PermissionsLibrary_m (copy)

    return PermissionsLibrary_m:HasPermission(
        "permission_moderation_modpanel_pardon_limited",
        arg12
    )
end

function t.CanPardonAnyone(_, arg14) -- line: 31
    -- upvalues:
    --  [1] PermissionsLibrary_m (copy)

    return PermissionsLibrary_m:HasPermission("permission_moderation_modpanel_pardon_full", arg14)
end

function t.CanPardon(arg15, arg16) -- line: 35
    return arg15:CanPardonLimited(arg16) or arg15:CanPardonAnyone(arg16)
end

function t.CanViewDataLimited(_, arg18) -- line: 39
    -- upvalues:
    --  [1] PermissionsLibrary_m (copy)

    return PermissionsLibrary_m:HasPermission(
        "permission_moderation_modpanel_viewdata_limited",
        arg18
    )
end

function t.CanViewDataMost(_, arg20) -- line: 43
    -- upvalues:
    --  [1] PermissionsLibrary_m (copy)

    return PermissionsLibrary_m:HasPermission("permission_moderation_modpanel_viewdata_most", arg20)
end

function t.CanViewDataFully(_, arg22) -- line: 47
    -- upvalues:
    --  [1] PermissionsLibrary_m (copy)

    return PermissionsLibrary_m:HasPermission("permission_moderation_modpanel_viewdata_full", arg22)
end

function t.CanViewData(arg23, arg24) -- line: 51
    return arg23:CanViewDataLimited(arg24) or arg23:CanViewDataMost(arg24) or arg23:CanViewDataFully(
        arg24
    )
end

function t.CanUnban(_, arg26) -- line: 55
    -- upvalues:
    --  [1] PermissionsLibrary_m (copy)

    return PermissionsLibrary_m:HasPermission("permission_moderation_modpanel_unban", arg26)
end

function t.CanJoinAnyone(_, arg28) -- line: 59
    -- upvalues:
    --  [1] PermissionsLibrary_m (copy)

    return PermissionsLibrary_m:HasPermission("permission_moderation_modpanel_teleport_full", arg28)
end

function t.CanEvictLimited(_, arg30) -- line: 63
    -- upvalues:
    --  [1] PermissionsLibrary_m (copy)

    return PermissionsLibrary_m:HasPermission("permission_moderation_modpanel_evict_limited", arg30)
end

function t.CanEvictAnyone(_, arg32) -- line: 67
    -- upvalues:
    --  [1] PermissionsLibrary_m (copy)

    return PermissionsLibrary_m:HasPermission("permission_moderation_modpanel_evict_full", arg32)
end

function t.CanEvict(arg33, arg34) -- line: 71
    return arg33:CanEvictLimited(arg34) or arg33:CanEvictAnyone(arg34)
end

function t.CanBanLimited(_, arg36) -- line: 75
    -- upvalues:
    --  [1] PermissionsLibrary_m (copy)

    return PermissionsLibrary_m:HasPermission(
        "permission_moderation_modpanel_moderate_limited",
        arg36
    )
end

function t.CanBanMost(_, arg38) -- line: 79
    -- upvalues:
    --  [1] PermissionsLibrary_m (copy)

    return PermissionsLibrary_m:HasPermission("permission_moderation_modpanel_moderate_most", arg38)
end

function t.CanBanAnyone(_, arg40) -- line: 83
    -- upvalues:
    --  [1] PermissionsLibrary_m (copy)

    return PermissionsLibrary_m:HasPermission("permission_moderation_modpanel_moderate_full", arg40)
end

function t.CanBan(arg41, arg42) -- line: 87
    return arg41:CanBanLimited(arg42) or arg41:CanBanMost(arg42) or arg41:CanBanAnyone(arg42)
end

function t.CanManageBanLocks(_, arg44) -- line: 91
    -- upvalues:
    --  [1] PermissionsLibrary_m (copy)

    return PermissionsLibrary_m:HasPermission("permission_moderation_modpanel_lock", arg44)
end

function t.CanRemoveFromLeaderboards(_, arg46) -- line: 95
    -- upvalues:
    --  [1] PermissionsLibrary_m (copy)

    return PermissionsLibrary_m:HasPermission(
        "permission_moderation_modpanel_removelbs_limited",
        arg46
    )
end

function t.CanWarnTemplate(_, arg48) -- line: 99
    -- upvalues:
    --  [1] PermissionsLibrary_m (copy)

    return PermissionsLibrary_m:HasPermission("permission_moderation_modpanel_warn_template", arg48)
end

function t.CanWarnCustom(_, arg50) -- line: 103
    -- upvalues:
    --  [1] PermissionsLibrary_m (copy)

    return PermissionsLibrary_m:HasPermission("permission_moderation_modpanel_warn_custom", arg50)
end

function t.CanRestrict(_, arg52) -- line: 107
    -- upvalues:
    --  [1] PermissionsLibrary_m (copy)

    return PermissionsLibrary_m:HasPermission("permission_moderation_modpanel_restrict", arg52)
end

return t
