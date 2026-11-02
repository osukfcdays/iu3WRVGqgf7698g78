local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CONSTANTS_m = require(ReplicatedStorage.Modules.CONSTANTS)
local CosmeticLibrary_m = require(ReplicatedStorage.Modules.CosmeticLibrary)
local ItemLibrary_m = require(ReplicatedStorage.Modules.ItemLibrary)
local Signal_m = require(ReplicatedStorage.Modules.Signal)
local v1 = CONSTANTS_m.DEFAULT_WEAPONS[1]
local t = {}
t.__index = t

function t.new(arg1) -- line: 13
    -- upvalues:
    --  [1] t (copy)
    --  [2] Signal_m (copy)

    local t_1 = setmetatable({}, t)
    t_1.SelectedWeaponChanged = Signal_m.new()
    t_1.CareerPageOpened = Signal_m.new()
    t_1.CareerPageOpened = Signal_m.new()
    t_1.CustomizingChanged = Signal_m.new()
    t_1.CustomizingStateChanged = Signal_m.new()
    t_1.CosmeticSearchChanged = Signal_m.new()
    t_1.Equipment = arg1
    t_1.SelectedWeapon = nil
    t_1.IsCareerPageOpen = false
    t_1.CustomizingType = nil
    t_1.SelectedCosmetic = nil
    t_1.CosmeticInverted = nil
    t_1.CosmeticSearchQuery = ""
    t_1:_Init()

    return t_1
end

function t.SelectWeapon(arg2, arg3) -- line: 42
    -- upvalues:
    --  [1] ItemLibrary_m (copy)

    assert(not arg3 or ItemLibrary_m.Items[arg3] ~= nil, arg3)

    if arg3 then
        arg2:OpenCareerPage(false)
    end

    arg2.SelectedWeapon = arg3
    arg2.SelectedWeaponChanged:Fire()
end

function t.OpenCareerPage(arg4, arg5) -- line: 53
    assert(if typeof(arg5) ~= "boolean" then false else true)

    if arg5 then
        arg4:SelectWeapon(nil)
    end

    arg4.IsCareerPageOpen = arg5
    arg4.CareerPageOpened:Fire()
end

function t.StartCustomizing(arg6, arg7) -- line: 64
    -- upvalues:
    --  [1] CosmeticLibrary_m (copy)
    --  [2] v1 (copy)

    local v4 = CosmeticLibrary_m.Types[arg7]
    assert(not arg7 or v4 and not v4.NotCosmetic)

    if arg7 then
        local v6 = arg7 == "Emote"
        arg6:OpenCareerPage(v6)
        v6 = if v4.IsWeaponCosmetic then arg6.SelectedWeapon or v1 or nil else nil
        arg6:SelectWeapon(v6)
    else
        arg6:SelectCosmetic(nil)
        arg6:SetCosmeticInvertedState(nil)
        arg6:SetCosmeticSearchQuery(nil)
    end

    arg6.CustomizingType = arg7
    arg6.CustomizingChanged:Fire()
end

function t.SelectCosmetic(arg8, arg9) -- line: 82
    -- upvalues:
    --  [1] CosmeticLibrary_m (copy)

    assert(
        not arg9 or arg9 == "NONE_COSMETIC" or arg9 == "RANDOM_COSMETIC" or CosmeticLibrary_m.Cosmetics[arg9] ~= nil,
        arg9
    )
    arg8.SelectedCosmetic = if arg9 == "NONE_COSMETIC" then nil else arg9
    arg8.CustomizingStateChanged:Fire()
end

function t.SetCosmeticInvertedState(arg10, arg11) -- line: 89
    arg10.CosmeticInverted = arg11
    arg10.CustomizingStateChanged:Fire()
end

function t.SetCosmeticSearchQuery(arg12, arg13) -- line: 94
    arg12.CosmeticSearchQuery = arg13 and string.lower(arg13) or ""
    arg12.CosmeticSearchChanged:Fire()
end

function t.OnOpen(arg14) -- line: 99
    -- upvalues:
    --  [1] v1 (copy)

    if arg14.Equipment.IsOpen then
        arg14:SelectWeapon(arg14.SelectedWeapon or v1)

        return
    end

    arg14:StartCustomizing(nil)
end

function t._Init(_) -- line: 111
end

return t
