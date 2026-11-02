local v1 = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local CONSTANTS_m = require(v1.Modules.CONSTANTS)
local EnumLibrary_m = require(v1.Modules.EnumLibrary)
local Signal_m = require(v1.Modules.Signal)
v1 = CONSTANTS_m.IS_CLIENT

if v1 then
    v1 = Players.LocalPlayer

    if v1 then
        v1 = Players.LocalPlayer.PlayerScripts:WaitForChild("Modules"):WaitForChild(
            "ClientReplicatedClasses"
        )
    end
end

local v2 = 0
local t = {}
t.__index = t

function t.new(arg1, arg2) -- line: 16
    -- upvalues:
    --  [1] v2 (ref)
    --  [2] t (copy)
    --  [3] CONSTANTS_m (copy)
    --  [4] Signal_m (copy)

    assert(
        not arg1 or (if typeof(arg1) ~= "table" then false else true),
        "Argument 1 invalid, expected a table or nil"
    )
    v2 = (v2 + 1) % 1000000
    local t_1 = setmetatable({}, t)
    t_1.Data = { ObjectID = utf8.char(v2) }
    t_1.ReplicateToClient = CONSTANTS_m.IS_SERVER and Signal_m.new() or nil
    t_1.ReplicateToClientUnreliable = CONSTANTS_m.IS_SERVER and Signal_m.new() or nil
    t_1._value_changed_events = {}
    t_1._temp_serial = arg1
    t_1._dont_compress_replication = arg2
    t_1:_Init()

    return t_1
end

function t.GetReplicatedClass(_, arg4) -- line: 43
    -- upvalues:
    --  [1] CONSTANTS_m (copy)
    --  [2] v1 (copy)
    --  [3] t (copy)

    assert(CONSTANTS_m.IS_CLIENT)
    local v5 = arg4

    if v5 then
        v5 = v1:FindFirstChild(arg4, true)
    end

    return v5 and require(v5) or t
end

function t.Get(arg5, arg6) -- line: 52
    return arg5.Data[arg6]
end

function t.Set(arg7, arg8, arg9) -- line: 59
    arg7.Data[arg8] = arg9
end

function t.GetDataChangedSignal(arg10, arg11) -- line: 66
    -- upvalues:
    --  [1] Signal_m (copy)

    assert(
        if typeof(arg11) ~= "string" then false else true,
        "Argument 1 invalid, expected a string"
    )

    if not arg10._value_changed_events[arg11] then
        arg10._value_changed_events[arg11] = Signal_m.new()
    end

    return arg10._value_changed_events[arg11]
end

function t.Replicate(arg12, arg13, arg14) -- line: 77
    assert(
        if typeof(arg13) ~= "string" then false else true,
        "Argument 1 invalid, expected a string"
    )
    local v9 = arg12:Get(arg13)
    local v8 = if arg14 then "ReplicateToClientUnreliable" else "ReplicateToClient"

    if arg12[v8] then
        arg12[v8]:Fire(
            "DataValueChanged",
            arg12._dont_compress_replication and arg13 or arg12:ToEnum(arg13) or arg13,
            v9
        )
    end

    if arg12._value_changed_events[arg13] then
        arg12._value_changed_events[arg13]:Fire(v9, arg13)
    end
end

function t.SetReplicate(arg15, arg16, arg17, arg18) -- line: 93
    assert(
        if typeof(arg16) ~= "string" then false else true,
        "Argument 1 invalid, expected a string"
    )
    arg15:Set(arg16, arg17)
    arg15:Replicate(arg16, arg18)
end

function t.Increment(arg19, arg20, arg21) -- line: 101
    assert(
        if typeof(arg20) ~= "string" then false else true,
        "Argument 1 invalid, expected a string"
    )
    assert(
        if typeof(arg21) ~= "number" then false else true,
        "Argument 2 invalid, expected a number"
    )

    if arg21 == 0 then
        return
    end

    arg19:Set(arg20, arg19:Get(arg20) + arg21)
end

function t.IncrementReplicate(arg22, arg23, arg24) -- line: 113
    assert(
        if typeof(arg23) ~= "string" then false else true,
        "Argument 1 invalid, expected a string"
    )
    assert(
        if typeof(arg24) ~= "number" then false else true,
        "Argument 2 invalid, expected a number"
    )

    if arg24 == 0 then
        return
    end

    arg22:Increment(arg23, arg24)
    arg22:Replicate(arg23)
end

function t.ReplicateFromServer(arg25, arg26, ...) -- line: 127
    if arg26 == "DataValueChanged" then
        local v16, v17 = ...
        arg25:SetReplicate(
            arg25._dont_compress_replication and v16 or arg25:FromEnum(v16) or v16,
            v17
        )

        return
    end

    assert(false, "No implementation for change type: " .. tostring(arg26))
end

function t.ToEnum(_, arg28) -- line: 137
    -- upvalues:
    --  [1] EnumLibrary_m (copy)

    return EnumLibrary_m:ToEnum(arg28)
end

function t.FromEnum(_, arg30) -- line: 141
    -- upvalues:
    --  [1] EnumLibrary_m (copy)

    return EnumLibrary_m:FromEnum(arg30)
end

function t.Serialize(arg31) -- line: 145
    return arg31:_EncodeSerial({ ClientReplicatedClassType = nil, Data = arg31:_SerializeData() })
end

function t.Destroy(arg32) -- line: 154
    if arg32.ReplicateToClient then
        arg32.ReplicateToClient:Destroy()
    end

    if arg32.ReplicateToClientUnreliable then
        arg32.ReplicateToClientUnreliable:Destroy()
    end

    for _, val in pairs(arg32._value_changed_events) do
        val:Destroy()
    end
end

function t._DecodeSerial(arg33, arg34) -- line: 172
    -- upvalues:
    --  [1] EnumLibrary_m (copy)

    if arg33._dont_compress_replication then
        return arg34
    end

    local t_4 = {}

    for key_1, val_1 in pairs(arg34) do
        local v19 = EnumLibrary_m:ToEnum(key_1, true) and key_1 or arg33:FromEnum(key_1)
        t_4[v19] = val_1
    end

    table.clear(arg34)

    for key_2, val_2 in pairs(t_4) do
        arg34[key_2] = val_2
    end

    return arg34
end

function t._EncodeSerial(arg35, arg36) -- line: 192
    -- upvalues:
    --  [1] EnumLibrary_m (copy)

    if arg35._dont_compress_replication then
        return arg36
    end

    local t_5 = {}

    for key_3, val_3 in pairs(arg36) do
        if EnumLibrary_m:FromEnum(key_3, true) then
            t_5[key_3] = val_3
        end
    end

    for key_4, val_4 in pairs(arg36) do
        if not EnumLibrary_m:FromEnum(key_4, true) then
            t_5[arg35:ToEnum(key_4)] = val_4
        end
    end

    return t_5
end

function t._SerializeData(arg37) -- line: 218
    if arg37._dont_compress_replication then
        return arg37.Data
    end

    local t_6 = {}

    for key_5, val_5 in pairs(arg37.Data) do
        t_6[arg37:ToEnum(key_5)] = val_5
    end

    return t_6
end

function t._Setup(arg38) -- line: 232
    if arg38._temp_serial then
        arg38:_DecodeSerial(arg38._temp_serial)

        for key_6, val_6 in pairs(arg38._temp_serial.Data) do
            local v20 = arg38._dont_compress_replication and key_6 or arg38:FromEnum(key_6)
            arg38:SetReplicate(v20, val_6)
        end
    end

    arg38._temp_serial = nil
end

function t._Init(arg39) -- line: 244
    arg39:_Setup()
end

return t
