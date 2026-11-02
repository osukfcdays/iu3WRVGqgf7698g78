local t = {}
local t_1 = {}
t_1.Default = { "rbxassetid://16621776051", "rbxassetid://16621776521" }
t_1.Climbing = {
    "rbxassetid://18222266749",
    "rbxassetid://18222266999",
    "rbxassetid://18222266464"
}
t_1.Stomping = { "rbxassetid://111711853822950" }
t_1.Grass = { "rbxassetid://16598817576", "rbxassetid://16598817760" }
t_1.LeafyGrass = {
    "rbxassetid://16604463729",
    "rbxassetid://16598888371",
    "rbxassetid://16598887984"
}
t_1.Wood = { "rbxassetid://16598817344", "rbxassetid://16598817050" }
t_1.Snow = { "rbxassetid://120787301888419", "rbxassetid://120787301888419" }
t_1.Concrete = { "rbxassetid://16614076829", "rbxassetid://16614077242" }
t_1.Metal = { "rbxassetid://16600019660", "rbxassetid://16600019248" }
t_1.Pebble = { "rbxassetid://16600018760", "rbxassetid://16600018511" }
t_1.Mud = { "rbxassetid://113106858242537", "rbxassetid://92366631281116" }
t_1.Fabric = { "rbxassetid://16621776149", "rbxassetid://16621776381" }
t_1.Sand = { "rbxassetid://16639468191", "rbxassetid://16639468533" }
t_1.DiamondPlate = "Metal"
t_1.WoodPlanks = "Wood"
t_1.Salt = "Pebble"
t_1.Ground = "Mud"
t_1.Slate = "Concrete"
t_1.Brick = "Concrete"
t.FootstepSounds = t_1
t.EquipSounds = {
    "rbxassetid://13158735106",
    "rbxassetid://13158734943",
    "rbxassetid://13158735037"
}
t.EnemyDeathSounds = {
    "rbxassetid://9276932564",
    "rbxassetid://9276932474",
    "rbxassetid://9276932416",
    "rbxassetid://9276932370",
    "rbxassetid://9276932285"
}
t.EliminationSounds = {
    "rbxassetid://16530229616",
    "rbxassetid://16530229541",
    "rbxassetid://16530229695"
}
t.ViewModelSounds = require(script:WaitForChild("ViewModelSounds"))
t.ItemSounds = require(script:WaitForChild("ItemSounds"))
t.AnimationSounds = {}
t.AlwaysPreload = {
    t.EquipSounds,
    t.EliminationSounds,
    {
        "rbxassetid://16537449730",
        "rbxassetid://16537337310",
        "rbxassetid://13110130082",
        "rbxassetid://13455969017",
        "rbxassetid://13949557844",
        "rbxassetid://13949557885",
        "rbxassetid://13087319223",
        "rbxassetid://13159969353",
        "rbxassetid://16540273321",
        "rbxassetid://13702989275",
        "rbxassetid://14441658101",
        "rbxassetid://16736552001",
        "rbxassetid://16736552098",
        "rbxassetid://16737738355",
        "rbxassetid://16737738420",
        "rbxassetid://16770456156",
        "rbxassetid://17662575175",
        "rbxassetid://17662574898",
        "rbxassetid://17662623697",
        "rbxassetid://17826470563",
        "rbxassetid://17826390328",
        "rbxassetid://17662575024",
        "rbxassetid://17153811469",
        "rbxassetid://177266782"
    }
}

function t.PreloadSounds(_, arg2, arg3, ...) -- line: 43
    local t_20 = {}
    local v1 = pairs
    local v2 = arg2 or {}

    for _, val in v1({ v2, { ... } }) do
        for _, val_1 in pairs(val) do
            local Sound = Instance.new("Sound")
            Sound.Volume = 0
            Sound.Looped = true
            Sound.SoundId = val_1
            Sound.Parent = script
            Sound:Play()
            table.insert(t_20, Sound)

            if arg3 then
                table.insert(arg3, Sound)
            end
        end
    end

    return t_20
end

local function setup_external_sounds() -- line: 65
    -- upvalues:
    --  [1] t (copy)

    local v3 = pairs
    local g_require_2 = require
    local _ = script:WaitForChild("ScrapedAnimationSounds")

    for key_2, val_2 in v3(g_require_2(script:WaitForChild("ScrapedAnimationSounds"))) do
        local AnimationSounds = t.AnimationSounds
        local v4 = t.AnimationSounds[key_2] or {}
        AnimationSounds[key_2] = v4

        for _, val_3 in pairs(val_2) do
            table.insert(t.AnimationSounds[key_2], val_3)
        end
    end
end

setup_external_sounds()

return t
