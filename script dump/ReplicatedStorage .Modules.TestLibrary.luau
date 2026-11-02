local TestService = game:GetService("TestService")
local RunService = game:GetService("RunService")

return {
    GetTestAttribute = function(_, arg2) --[[ GetTestAttribute ]] -- line: 7
        -- upvalues:
        --  [1] RunService (copy)
        --  [2] TestService (copy)

        if not RunService:IsStudio() then
            return nil
        end

        local attribute

        while true do
            attribute = TestService:GetAttribute(arg2)

            if attribute ~= nil then
                break
            end

            warn("TestService attribute not found, waiting for", arg2)
            wait(1)
        end

        if attribute == "" then
            return nil
        end

        return attribute
    end
}
