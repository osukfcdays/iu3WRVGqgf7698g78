local CONSTANTS_m = require(game:GetService("ReplicatedStorage").Modules.CONSTANTS)
local t = { Info = {}, Order = {}, LookupID = {} }
local t_1 = {}
local t_2 = {}

local function add_badge(
    arg1,
    arg2,
    arg3,
    arg4,
    arg5,
    arg6
) -- line: 15
    -- upvalues:
    --  [1] CONSTANTS_m (copy)
    --  [2] t (copy)
    --  [3] t_1 (copy)
    --  [4] t_2 (copy)

    if arg6 and CONSTANTS_m.IS_CLIENT then
        return
    end

    local t_3 = { Name = arg2, Section = arg1, BadgeID = arg3, Rewards = arg4, IsHidden = arg5 }
    local v1 = t[arg1] or {}
    t[arg1] = v1
    t[arg1][arg2] = t_3
    t.Info[arg2] = t_3
    t.LookupID[tostring(arg3)] = t_3
    table.insert(t.Order, arg2)

    if CONSTANTS_m.IS_SERVER then
        if arg3 == 0 then
            warn("[BADGE] Badge ID missing: " .. arg1 .. arg2)
        end

        if t_1[tostring(arg3)] and arg3 > 0 then
            warn("[BADGE] Duplicate badge ID: " .. arg3)
        else
            t_1[tostring(arg3)] = true
        end

        if t_2[arg2] then
            warn("[BADGE] Duplicate badge section & name: " .. arg1 .. arg2)

            return
        end

        t_2[arg2] = true
    end
end

add_badge("Misc", "Welcome", 2904819966736756)
add_badge("Misc", "AlphaTesterTesting", 1651092271685623)
add_badge(
    "Misc",
    "AlphaTester",
    1330297521556384,
    { { Name = "Alpha Coin", Weapon = "IsUniversal" } }
)
add_badge("SpecialChallenge", "2024WinterSpotlight1", 3550066675718)
add_badge("SpecialChallenge", "2024WinterSpotlight2", 3480019912304713)
add_badge("SpecialChallenge", "TheHuntMegaEdition1", 2472187632273965)
add_badge("SpecialChallenge", "TheHuntMegaEdition2", 2731731095831523)

return t
