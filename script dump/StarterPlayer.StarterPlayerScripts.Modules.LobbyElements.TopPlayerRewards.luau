local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local SeasonLibrary_m = require(ReplicatedStorage.Modules.SeasonLibrary)
local StaticViewModel_m = require(
    Players.LocalPlayer.PlayerScripts.Modules.StaticModel.StaticViewModel
)
local LobbyElement_m = require(Players.LocalPlayer.PlayerScripts.Modules.LobbyElement)
local t = setmetatable({}, LobbyElement_m)
t.__index = t

function t._new(...) -- line: 12
    -- upvalues:
    --  [1] LobbyElement_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(LobbyElement_m.new(...), t)
    t_1:_Init()

    return t_1
end

function t._ModelAdded(_, arg2) -- line: 30
    -- upvalues:
    --  [1] SeasonLibrary_m (copy)
    --  [2] StaticViewModel_m (copy)

    local TopPlayerRewardSkinName = SeasonLibrary_m.CurrentSeason.TopPlayerRewardSkinName
    arg2:WaitForChild("NeonCone").Transparency = if TopPlayerRewardSkinName then arg2:WaitForChild(
        "NeonCone"
    ).Transparency else 1
    arg2:WaitForChild("Neon").Material = if TopPlayerRewardSkinName then Enum.Material.Neon else Enum.Material.SmoothPlastic

    if not TopPlayerRewardSkinName then
        return
    end

    local v3 = StaticViewModel_m.new(TopPlayerRewardSkinName)
    v3:ScaleTo(3.25)
    v3:PivotTo(arg2:WaitForChild("Preview").CFrame)
    v3:SetParent(arg2:WaitForChild("Preview"))
end

function t._Init(arg3) -- line: 46
    -- upvalues:
    --  [1] CollectionService (copy)

    CollectionService:GetInstanceAddedSignal("LobbyTopPlayerReward"):Connect(function(arg4) -- line: 47
        -- upvalues:
        --  [1] arg3 (copy)

        arg3:_ModelAdded(arg4)
    end)

    for _, val in pairs(CollectionService:GetTagged("LobbyTopPlayerReward")) do
        task.defer(arg3._ModelAdded, arg3, val)
    end
end

return t._new()
