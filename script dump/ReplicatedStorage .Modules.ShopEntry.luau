local CurrencyLibrary_m = require(game:GetService("ReplicatedStorage").Modules.CurrencyLibrary)
local t = {}
t.__index = t

function t.new(
    arg1,
    arg2,
    arg3,
    arg4,
    arg5,
    arg6,
    arg7,
    arg8,
    arg9,
    arg10
) -- line: 8
    -- upvalues:
    --  [1] t (copy)

    assert(
        if typeof(arg1) ~= "string" then false else true,
        "Argument 1 invalid, expected a string, got " .. tostring(arg1)
    )
    assert(
        if typeof(arg2) ~= "string" then false else true,
        "Argument 2 invalid, expected a string, got " .. tostring(arg2)
    )
    assert(
        if typeof(arg3) ~= "table" then false else true,
        "Argument 3 invalid, expected a table, got " .. tostring(arg3)
    )
    local v1 = not arg4 or (if typeof(arg4) ~= "table" then false else true)
    assert(v1, "Argument 4 invalid, expected a table or nil, got " .. tostring(arg4))
    v1 = not arg5 or (if typeof(arg5) == "table" then next(arg5) else false)
    assert(v1, "Argument 5 invalid, expected a table or nil, got " .. tostring(arg5))
    v1 = not arg6 or (if typeof(arg6) ~= "boolean" then false else true)
    assert(v1, "Argument 6 invalid, expected a boolean or nil, got " .. tostring(arg6))
    v1 = not arg7 or (if typeof(arg7) ~= "number" then false else true)
    assert(v1, "Argument 7 invalid, expected a number or nil, got " .. tostring(arg7))
    v1 = not arg8 or (if typeof(arg8) ~= "number" then false else true)
    assert(v1, "Argument 8 invalid, expected a number or nil, got " .. tostring(arg8))
    v1 = not arg9 or (if typeof(arg9) ~= "number" then false else true)
    assert(v1, "Argument 9 invalid, expected a number or nil, got " .. tostring(arg9))
    v1 = not arg10 or (if typeof(arg10) ~= "table" then false else true)
    assert(v1, "Argument 10 invalid, expected a table or nil, got " .. tostring(arg10))
    local t_1 = setmetatable({}, t)
    t_1.EntryType = arg1
    t_1.EntryName = arg2
    t_1.Rewards = arg3
    v1 = arg4 or {}
    t_1.Prices = v1
    t_1.MainCurrency = nil
    t_1.ProductIDs = arg5 or nil
    t_1.ProductQuantityToID = nil
    t_1.IsLimited = arg6 or nil
    t_1.PurchaseAppearTime = arg7 or -1
    t_1.PurchaseStartTime = arg8 or -1
    t_1.PurchaseDuration = arg9 or math.huge
    t_1._temp_properties = arg10
    t_1:_Init()

    return t_1
end

function t._Setup(arg11) -- line: 51
    -- upvalues:
    --  [1] CurrencyLibrary_m (copy)

    for key, _ in pairs(arg11.Prices) do
        assert(
            CurrencyLibrary_m.Info[key] ~= nil,
            "Argument 4 invalid, expected a valid currency name, got " .. tostring(key)
        )

        if
            not arg11.MainCurrency
            or CurrencyLibrary_m.Info[key].OrderIndex < CurrencyLibrary_m.Info[arg11.MainCurrency].OrderIndex
        then
            arg11.MainCurrency = key
        end
    end

    local v3 = arg11.MainCurrency or arg11.ProductIDs
    assert(v3, "Currency missing")

    if arg11.ProductIDs then
        arg11.ProductQuantityToID = {}

        for key_1, val_1 in pairs(arg11.ProductIDs) do
            arg11.ProductQuantityToID[val_1] = key_1
        end
    end

    local v4 = pairs
    local v3 = arg11._temp_properties or {}

    for key_2, val_2 in v4(v3) do
        arg11[key_2] = val_2
    end

    arg11._temp_properties = nil
end

function t._Init(arg12) -- line: 77
    arg12:_Setup()
end

return t
