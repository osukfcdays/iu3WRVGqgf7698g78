local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local Signal_m = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Signal"))
local t = {}
t.__index = t

function t._new() -- line: 11
    -- upvalues:
    --  [1] t (copy)
    --  [2] Signal_m (copy)

    local t_1 = setmetatable({}, t)
    t_1.AlwaysReplicateToEveryone = {}
    t_1._num_enums = 0
    t_1._to_enum = {}
    t_1._from_enum = {}
    t_1._enum_builder_complete = false
    t_1._enum_builder_completed_internal = Signal_m.new()
    t_1:_Init()

    return t_1
end

function t.EncryptTable(_, arg2) -- line: 31
    -- upvalues:
    --  [1] HttpService (copy)

    local reversedText = string.reverse(HttpService:JSONEncode(arg2))
    local v3 = ""

    for index = 1, #reversedText do
        local substring_1 = string.sub(reversedText, index, index)
        v3 ..= string.char(string.byte(substring_1) - -1)
    end

    return v3
end

function t.DecryptTable(_, arg4) -- line: 45
    -- upvalues:
    --  [1] HttpService (copy)

    return pcall(function() -- line: 46
        -- upvalues:
        --  [1] arg4 (copy)
        --  [2] HttpService (ref)

        local v6 = ""

        for index_1 = #arg4, 1, -1 do
            local substring_3 = string.sub(arg4, index_1, index_1)
            v6 ..= string.char(string.byte(substring_3) + -1)
        end

        return HttpService:JSONDecode(v6)
    end)
end

function t.ToEnum(arg5, arg6, arg7) -- line: 60
    if not arg6 then
        return
    end

    local v9 = arg5._to_enum[arg6]
    assert(arg7 or v9 ~= nil, arg6)

    return v9
end

function t.FromEnum(arg8, arg9, arg10) -- line: 70
    if not arg9 then
        return
    end

    local v11 = arg8._from_enum[arg9]
    assert(arg10 or v11 ~= nil, arg9)

    return v11
end

function t.AddEnum(arg11, arg12) -- line: 80
    if arg11:ToEnum(arg12, true) then
        return
    end

    local text = utf8.char(arg11._num_enums)
    arg11._num_enums += 1
    arg11._to_enum[arg12] = text
    arg11._from_enum[text] = arg12
end

function t.WaitForEnumBuilder(arg13) -- line: 92
    if not arg13._enum_builder_complete then
        arg13._enum_builder_completed_internal:Wait()
    end
end

function t.EnumBuilderCompleted(arg14) -- line: 98
    arg14._enum_builder_complete = true
    arg14._enum_builder_completed_internal:Fire()
end

function t._Init(_) -- line: 107
end

return t._new()
