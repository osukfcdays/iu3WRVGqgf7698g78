local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local SeasonLibrary_m = require(ReplicatedStorage.Modules.SeasonLibrary)
local PlayerDataController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.PlayerDataController
)
local BaseContractSlot_m = require(Players.LocalPlayer.PlayerScripts.Modules.BaseContractSlot)
local t = {}
t.__index = t

function t.new(arg1) -- line: 14
    -- upvalues:
    --  [1] t (copy)
    --  [2] BaseContractSlot_m (copy)

    local t_1 = setmetatable({}, t)
    t_1.Page = arg1
    t_1._base_contract_slot = BaseContractSlot_m.new()
    t_1:_Init()

    return t_1
end

function t.Open(arg2) -- line: 30
    arg2:_Update()
end

function t.Close(_) -- line: 34
end

function t._Update(arg4) -- line: 42
    -- upvalues:
    --  [1] PlayerDataController_m (copy)
    --  [2] SeasonLibrary_m (copy)

    local v2 = PlayerDataController_m:Get("Seasons")[SeasonLibrary_m.CurrentSeason.Name]
    local v1 = v2

    if v1 then
        v1 = v2.RankedPerformances[SeasonLibrary_m.UNIVERSAL_ELO_NAME]
    end

    v2 = v1 and v1.CurrentELO ~= nil
    arg4._base_contract_slot.Frame.Visible = v2

    if not arg4._base_contract_slot.Frame.Visible then
        return
    end

    arg4._base_contract_slot:SetProgress(
        v1.DuelsWon * SeasonLibrary_m.CurrentSeason.ParticipationPointsPerWin + v1.DuelsLost * SeasonLibrary_m.CurrentSeason.ParticipationPointsPerLoss
    )
end

function t._Setup(arg5) -- line: 58
    -- upvalues:
    --  [1] SeasonLibrary_m (copy)

    local ParticipationPointsPerWin = SeasonLibrary_m.CurrentSeason.ParticipationPointsPerWin
    local ParticipationPointsPerLoss = SeasonLibrary_m.CurrentSeason.ParticipationPointsPerLoss
    local string_format = string.format(
        "Earn %s point%s from every ranked win",
        ParticipationPointsPerWin,
        if ParticipationPointsPerWin ~= 1 then "s" else ""
    )
    local string_format_1 = string.format(
        "Earn %s point%s from every ranked loss",
        ParticipationPointsPerLoss,
        if ParticipationPointsPerLoss ~= 1 then "s" else ""
    )
    local v6 = (if ParticipationPointsPerWin > 0 and ParticipationPointsPerLoss > 0 then string_format .. " \226\128\162 " .. string_format_1 else if not (ParticipationPointsPerWin > 0) then if not (ParticipationPointsPerLoss > 0) then "???" else string_format_1 else string_format) .. "   \226\128\162   Only available during Season " .. SeasonLibrary_m.CurrentSeason.Version
    arg5._base_contract_slot:SetImage("rbxassetid://117835427046796")
    arg5._base_contract_slot:SetTitle("Ranked Contract")
    arg5._base_contract_slot:SetDescription(v6)
    arg5._base_contract_slot:SetScale(0.75)

    for _, val in pairs(SeasonLibrary_m.CurrentSeason.ParticipationPrizes) do
        local v9, v10 = table.unpack(val)
        arg5._base_contract_slot:AddMilestone(v9, v10)
    end

    arg5._base_contract_slot.Frame.LayoutOrder = 30
    arg5._base_contract_slot.Frame.Parent = arg5.Page.Container
end

function t._Init(arg6) -- line: 83
    arg6:_Setup()
end

return t
