local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local StatisticsLibrary_m = require(ReplicatedStorage.Modules.StatisticsLibrary)
local ContractsLibrary_m = require(ReplicatedStorage.Modules.ContractsLibrary)
local PlayerDataController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.PlayerDataController
)
local Parent_m = require(script.Parent)
local t = setmetatable({}, Parent_m)
t.__index = t

function t.new(arg1, arg2) -- line: 12
    -- upvalues:
    --  [1] Parent_m (copy)
    --  [2] t (copy)
    --  [3] ContractsLibrary_m (copy)
    --  [4] PlayerDataController_m (copy)

    local t_1 = setmetatable(Parent_m.new(), t)
    t_1._statistics_directory_name = arg1
    t_1._contract_name = arg2
    t_1._contract_info = ContractsLibrary_m.Contracts[t_1._contract_name]
    t_1._progress = PlayerDataController_m:GetDirectoryStatistic(
        t_1._statistics_directory_name,
        t_1._contract_info.Identifier,
        t_1._contract_info.StatisticName,
        t_1._contract_info.ExtraStatisticNames
    )
    t_1:_Init()

    return t_1
end

function t._Setup(arg3) -- line: 35
    -- upvalues:
    --  [1] StatisticsLibrary_m (copy)

    local v2 = StatisticsLibrary_m.Info[arg3._contract_info.StatisticName]
    local v3 = v2.FullDisplayName

    for _, val in pairs(arg3._contract_info.ExtraStatisticNames) do
        v3 ..= " + " .. StatisticsLibrary_m.Info[val].FullDisplayName
    end

    arg3:SetTitle(v3)
    arg3:SetImage(v2.Image)
    arg3:SetProgress(arg3._progress)

    for _, val_1 in pairs(arg3._contract_info.Milestones) do
        local v5, v6 = table.unpack(val_1)
        arg3:AddMilestone(v5, v6, v2.TostringFunction)
    end
end

function t._Init(arg4) -- line: 53
    arg4:_Setup()
end

return t
