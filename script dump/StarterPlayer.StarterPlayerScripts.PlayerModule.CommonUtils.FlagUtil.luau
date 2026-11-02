return {
    getUserFlag = function(arg1) --[[ getUserFlag ]] -- line: 11
        local Success, Result = pcall(function() -- line: 12
            -- upvalues:
            --  [1] arg1 (copy)

            return UserSettings():IsUserFeatureEnabled(arg1)
        end)

        return Success and Result
    end
}
