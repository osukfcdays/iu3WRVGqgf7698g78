return {
    UNBANNED_TOKEN = "Unbanned",
    PERMANENT_BAN_DURATION = 999999999,
    IsBanLogANote = function(_, arg2) --[[ IsBanLogANote ]] -- line: 6
        return arg2.IsNote
    end,
    IsBanLogABan = function(arg3, arg4) --[[ IsBanLogABan ]] -- line: 10
        local v1 = not arg3:IsBanLogANote(arg4)

        if v1 then
            v1 = arg4.Reason ~= arg3.UNBANNED_TOKEN
        end

        return v1
    end,
    IsBanLogAnActiveBan = function(arg5, arg6) --[[ IsBanLogAnActiveBan ]] -- line: 14
        local v2 = arg5:IsBanLogABan(arg6)

        if v2 then
            v2 = arg6.EndTime and os.time() < arg6.EndTime
        end

        return v2
    end,
    IsBanLogAWarning = function(arg7, arg8) --[[ IsBanLogAWarning ]] -- line: 18
        local v3 = arg7:IsBanLogANote(arg8)

        if v3 then
            v3 = arg8.Reason

            if v3 then
                v3 = if string.sub(arg8.Reason, 1, 9) ~= "Warned - " then false else true
            end
        end

        return v3
    end,
    IsBanned = function(arg9, arg10) --[[ IsBanned ]] -- line: 23
        for _, val in pairs(arg10.BanHistory) do
            if not arg9:IsBanLogANote(val) then
                if not arg9:IsBanLogAnActiveBan(val) then
                    break
                end

                return val
            end
        end

        return nil
    end
}
