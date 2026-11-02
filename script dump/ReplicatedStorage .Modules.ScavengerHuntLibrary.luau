local ItemLibrary_m = require(game:GetService("ReplicatedStorage").Modules.ItemLibrary)
local t = { Info = {}, InfoByWeapon = {} }

local function add_scavenger_hunt(
    arg1,
    arg2,
    arg3,
    arg4,
    arg5,
    arg6,
    arg7,
    arg8,
    arg9
) -- line: 10
    -- upvalues:
    --  [1] t (copy)
    --  [2] ItemLibrary_m (copy)

    local t_1 = {
        AllowedInPrivateServers = arg1,
        Name = arg2,
        Color = arg3,
        ObjectsName = arg4,
        ObjectsNamePlural = arg5,
        ObjectsImage = arg6,
        Objects = arg7,
        NumObjects = #arg7,
        RewardOnCompletion = arg8,
        Rewards = arg9
    }
    t.Info[arg2] = t_1

    for _, val in pairs(arg9) do
        if ItemLibrary_m.Items[val.Name] then
            t.InfoByWeapon[val.Name] = t_1
        end
    end
end

add_scavenger_hunt(
    false,
    "JumpPad",
    Color3.fromRGB(49, 210, 255),
    "Jump Shard",
    "Jump Shards",
    "rbxassetid://110601089716497",
    { "1", "2", "3", "4", "5", "6", "7", "8", "9" },
    true,
    { { Name = "Jump Pad" } }
)

return t
