local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserService = game:GetService("UserService")
local CosmeticLibrary_m = require(ReplicatedStorage.Modules.CosmeticLibrary)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local t = { Players = {}, Rewards = {} }

local function add_player(arg1, arg2, arg3) -- line: 16
    -- upvalues:
    --  [1] t (copy)
    --  [2] Utility_m (copy)
    --  [3] CosmeticLibrary_m (copy)

    local t_1 = { EliminationReward = arg2, WinReward = arg3 }
    t.Players[tostring(arg1)] = t_1

    if t_1.EliminationReward then
        local v1 = if arg1 == 324386852 and Utility_m:IsAprilFools() then "spell mud backwards" else nil
        t.Rewards[t_1.EliminationReward] = true
        local v2 = v1
        local v3 = CosmeticLibrary_m.Cosmetics[t_1.EliminationReward]

        if not v2 then
            v2 = string.format(
                "Earned by eliminating @%s with a weapon",
                "\226\128\162 \226\128\162 \226\128\162"
            )
        end

        v3.Description = v2
        local v4 = CosmeticLibrary_m.Cosmetics[t_1.EliminationReward]
        v2 = v1 or string.format(
            "Earned by eliminating @%s with this weapon",
            "\226\128\162 \226\128\162 \226\128\162"
        )
        v4.DescriptionSpecific = v2
    end

    if t_1.WinReward then
        t.Rewards[t_1.WinReward] = true
        CosmeticLibrary_m.Cosmetics[t_1.WinReward].Description = string.format(
            "Earned by winning with or against @%s",
            "\226\128\162 \226\128\162 \226\128\162"
        )
    end
end

add_player(15941965, "SenseiWarrior", "Sensite")
add_player(20349956, "Nosniy", "Nosnite")
add_player(780350915, "nekoanims", "Nekore")
add_player(13108868, "ShadowTrojan", "Shadore")
add_player(1730213868, "Brian1KB", "Brianore")
add_player(8034104, "GreatGuyBoom", "Boomore")
add_player(42477697, "D_reamz", nil)
add_player(266340204, "Blizmid")
add_player(487532097, "CarbonMeister")
add_player(964088769, "DV")
add_player(64516, "Bandites")
add_player(84743203, "TanqR")
add_player(301707243, "BobbVX")
add_player(341006533, "oPixel")
add_player(52392831, "MiniBloxia")
add_player(72777686, "enriquebruv")
add_player(15315966, "hoppy819")
add_player(2528007458, "Chex")
add_player(264355696, "Hoopie")
add_player(4891355965, "Kaye")
add_player(103070346, "Karful")
add_player(19737278, "Khayri")
add_player(68729698, "viecti")
add_player(18394211, "SharkTactics")
add_player(1010680683, "Applino")
add_player(172669397, "8sty")
add_player(11127106743, "atorix")
add_player(3410760577, "philhood")
add_player(324386852, "Mud")
add_player(527669241, "KaiM")
add_player(121130556, "Darktru")
add_player(4378716640, "Kashy")
add_player(6114260623, "Milo")
add_player(147139016, "elixir")
add_player(2466113945, "WE1RD")
add_player(42306452, "Cruz")
add_player(7474730049, "Stefan")
add_player(152334685, "Mixedify")
add_player(719253194, "SlingshotBwai")
add_player(817372683, "TinyDude")
add_player(9822237397, "Incublox")
add_player(317520373, "RODNY")

local function setup_descriptions() -- line: 84
    -- upvalues:
    --  [1] t (copy)
    --  [2] UserService (copy)
    --  [3] CosmeticLibrary_m (copy)

    local t_2 = {}

    for key, _ in pairs(t.Players) do
        table.insert(t_2, (tonumber(key)))
    end

    local Success, Result = pcall(UserService.GetUserInfosByUserIdsAsync, UserService, t_2)

    if not Success then
        warn("Failed to fetch user infos:", Result, t_2)

        return
    end

    for _, val_1 in pairs(Result) do
        local v6 = t.Players[tostring(val_1.Id)]

        if v6 then
            if v6.EliminationReward then
                CosmeticLibrary_m.Cosmetics[v6.EliminationReward].Description = string.format(
                    "Earned by eliminating @%s with a weapon",
                    val_1.Username
                )
                CosmeticLibrary_m.Cosmetics[v6.EliminationReward].DescriptionSpecific = string.format(
                    "Earned by eliminating @%s with this weapon",
                    val_1.Username
                )
            end

            if v6.WinReward then
                CosmeticLibrary_m.Cosmetics[v6.WinReward].Description = string.format(
                    "Earned by winning with or against @%s",
                    val_1.Username
                )
            end
        end
    end
end

task.defer(setup_descriptions)

return t
