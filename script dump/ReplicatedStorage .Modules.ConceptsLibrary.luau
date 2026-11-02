local CosmeticLibrary_m = require(game:GetService("ReplicatedStorage").Modules.CosmeticLibrary)
local t = {}
local t_1 = { UserID = 1544275061, Cosmetics = { "Hyper Sniper", "Apex Pistols", "Bat Daggers" } }
t.Kevin_DJiceninja = t_1
local t_3 = {
    UserID = 1796756117,
    Cosmetics = { "Spaceship Launcher", "Boba Gun", "Riptide Katana" }
}
t.SooHui_PH2 = t_3
local t_5 = {
    UserID = 10763717,
    Cosmetics = {
        "Keyttle Axe",
        "Spider Web",
        "Energy Shield",
        "Wrapped Freeze Ray",
        "Keyshot",
        "Waffle Cone",
        "Fish Scales",
        "Neapolitan",
        "Tidal",
        "Spectralized",
        "Sundae Launcher",
        "Coconut Launcher",
        "Palm Scythe",
        "Crab Claws",
        "Splattered",
        "Enerkey Rifle",
        "Enerkey Pistols",
        "Jeremiah",
        "Jerm"
    }
}
t.mozzywalkstheplank = t_5
local t_7 = {
    UserID = 7207159625,
    Cosmetics = {
        "Gearnade Launcher",
        "Squid Launcher",
        "Notebook Satchel",
        "Mega Drill",
        "Masterpiece"
    }
}
t.Invicibrow = t_7
local t_9 = { UserID = 446253736, Cosmetics = { "Water Balloon", "Soul Grenade", "Bounce House" } }
t.NPC2Z = t_9
local t_11 = { UserID = 3746614610, Cosmetics = { "Bag o' Money", "Ban Axe" } }
t.NSK0815 = t_11
local t_13 = { UserID = 343054539, Cosmetics = { "Medkitty" } }
t.tazd = t_13
local t_15 = { UserID = 4830771682, Cosmetics = { "Hourglass" } }
t.TheMonkeyMasterSeb = t_15
local t_17 = { UserID = 4382977409, Cosmetics = { "Fighter Jet" } }
t.ayroyuusho123 = t_17
local t_19 = { UserID = 436956865, Cosmetics = { "Mimic Axe" } }
t.myxushi = t_19
local t_21 = { UserID = 3751863229, Cosmetics = { "Cerulean Axe", "Repulsor" } }
t.S3ntraMyst1c = t_21
local t_23 = { UserID = 4942063762, Cosmetics = { "Event Horizon" } }
t.StrangerHades0 = t_23
local t_25 = { UserID = 2592938109, Cosmetics = { "Neon Lights", "Regal" } }
t.ACrystalPirate = t_25
local t_27 = { UserID = 1544233658, Cosmetics = { "Candy Apple" } }
t.MunchFish = t_27
local t_29 = { UserID = 301707243, Cosmetics = { "Cardboard" } }
t.BobbVX = t_29
local t_31 = { UserID = 874685655, Cosmetics = { "Diamond" } }
t.Z0Z_Gaming = t_31
local t_33 = { UserID = 780350915, Cosmetics = { "Hammered Copper", "Honeycomb" } }
t.nekoanims = t_33
local t_35 = { UserID = 1325102532, Cosmetics = { "Jolly Man", "Plasma Distortion" } }
t.SpunkyKatane = t_35
local t_37 = { UserID = 4192733792, Cosmetics = { "Beloved Bow" } }
t.TylkonTylko = t_37
local t_39 = { UserID = 1142556567, Cosmetics = { "Key Spray" } }
t.Salllu_78 = t_39
local t_41 = { UserID = 5010662019, Cosmetics = { "Arch Molotov" } }
t.emiiluumii = t_41
local t_43 = { UserID = 1511223890, Cosmetics = { "Lighthouse" } }
t.Galaxywolfibrar = t_43
local t_45 = { UserID = 5239484609, Cosmetics = { "Chark Kebab" } }
t.bladesof_fir3 = t_45
local t_47 = { UserID = 724399676, Cosmetics = { "Palmshot" } }
t["99kRom"] = t_47
local t_49 = { UserID = 7156056199, Cosmetics = { "Hazard Sign" } }
t.Kisasage = t_49
local t_51 = { UserID = 1442276929, Cosmetics = { "Snowblob" } }
t.T0Wa_chan = t_51
local t_53 = { UserID = 2660279857, Cosmetics = { "Plunger" } }
t.Juanicho2021 = t_53
local t_55 = { UserID = 10960176795, Cosmetics = { "Arcade Claw" } }
t.konenro = t_55
local t_57 = { UserID = 660553399, Cosmetics = { "Genie Lamp", "Red Moon" } }
t.fertmeny = t_57
local t_59 = { UserID = 4163861479, Cosmetics = { "Starforge Maul", "Starforge Permafrost" } }
t.FishingFlare = t_59
local t_61 = { UserID = 260550404, Cosmetics = { "Keythe" } }
t["0RAFO9"] = t_61
local t_63 = { UserID = 2591156063, Cosmetics = { "Brewery", "Ravensoul" } }
t.zaidbeyblades = t_63
local t_65 = { UserID = 1415379390, Cosmetics = { "Nightmare" } }
t.Jlgaspar35 = t_65
local t_67 = {
    UserID = 11575114164,
    Cosmetics = { "Xenofrost", "Cursed Daggers", "Karambat", "Spider Crossbow" }
}
t.scaredOfFall = t_67
local t_69 = { UserID = 441670695, Cosmetics = { "Gravelight" } }
t["13ayir"] = t_69
local t_71 = { CONCEPT_REWARD_NAME = "Scribble", Leaderboard = {}, Conceptors = {} }

function t_71.GetConceptors(_, arg2) -- line: 155
    -- upvalues:
    --  [1] t_71 (copy)

    local t_72 = {}

    for key, val in pairs(t_71.Conceptors) do
        if table.find(val.CosmeticConcepts, arg2) then
            table.insert(t_72, key)
        end
    end

    return t_72
end

function t_71.GetConceptScore(_, arg4) -- line: 167
    -- upvalues:
    --  [1] t_71 (copy)

    local v1 = t_71.Conceptors[tostring(arg4)]

    if not v1 then
        return 0
    end

    local v2 = 0

    for _, val_1 in pairs(v1.CosmeticConcepts) do
        local v3 = #t_71:GetConceptors(val_1)

        if v3 == 0 then
            warn("??? Conceptors for cosmetic " .. val_1 .. " == 0")
        else
            v2 += 1 / v3
        end
    end

    return v2
end

function t_71.GetNextMilestone(_, arg6) -- line: 190
    -- upvalues:
    --  [1] t_71 (copy)

    for key_2, val_2 in pairs(t_71.Milestones) do
        if arg6 < val_2[1] then
            return val_2, t_71.Milestones[key_2 - 1]
        end
    end
end

local function add_conceptor(arg7, arg8) -- line: 198
    -- upvalues:
    --  [1] CosmeticLibrary_m (copy)
    --  [2] t_71 (copy)

    assert(if typeof(arg7) == "number" then if arg7 == 0 then false else true else false)
    local t_73 = {}

    for index = #arg8, 1, -1 do
        local v5 = arg8[index]

        if not CosmeticLibrary_m.Cosmetics[v5] then
            table.remove(arg8, index)
            task.spawn(error, "Item doesnt exist: " .. v5)
        else
            assert(not t_73[v5], "Item entered in more than once: " .. v5)
            t_73[v5] = true
        end
    end

    local t_74 = { UserID = arg7, CosmeticConcepts = nil }
    local v4 = arg8 or {}
    t_74.CosmeticConcepts = v4
    t_71.Conceptors[tostring(t_74.UserID)] = t_74
    local t_75 = { key = tostring(arg7), value = nil }
    table.insert(t_71.Leaderboard, t_75)
end

for _, val_3 in pairs(t) do
    add_conceptor(val_3.UserID, val_3.Cosmetics)
end

local function sort_leaderboard() -- line: 235
    -- upvalues:
    --  [1] t_71 (copy)
    --  [2] t (copy)

    for _, val_4 in pairs(t_71.Leaderboard) do
        val_4.value = t_71:GetConceptScore(val_4.key)
    end

    table.sort(t_71.Leaderboard, function(arg9, arg10) -- line: 240
        return arg9.value > arg10.value
    end)
    local t_76 = {}

    for _, val_5 in pairs(t) do
        if t_76[val_5.UserID] then
            error("[CONCEPTS] Duplicate User ID:", val_5.UserID)
        end

        t_76[val_5.UserID] = true
    end
end

sort_leaderboard()

return t_71
