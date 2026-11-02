local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local SeasonLibrary_m = require(ReplicatedStorage.Modules.SeasonLibrary)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local PlayerDataController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.PlayerDataController
)
local RewardSlot_m = require(Players.LocalPlayer.PlayerScripts.Modules.RewardSlot)
local t = {}
t.__index = t

function t.new(arg1) -- line: 15
    -- upvalues:
    --  [1] t (copy)

    local t_1 = setmetatable({}, t)
    t_1.Page = arg1
    t_1.Frame = t_1.Page.Container:WaitForChild("GloryPayout")
    t_1.Container = t_1.Frame:WaitForChild("Container")
    t_1.Description = t_1.Frame:WaitForChild("Description")
    t_1.Description2 = t_1.Frame:WaitForChild("Description2")
    t_1._reward_slot = nil
    t_1:_Init()

    return t_1
end

function t.Open(arg2) -- line: 35
    arg2:_Update()
end

function t.Close(_) -- line: 39
end

function t._Update(arg4) -- line: 47
    -- upvalues:
    --  [1] PlayerDataController_m (copy)
    --  [2] SeasonLibrary_m (copy)
    --  [3] Utility_m (copy)
    --  [4] RewardSlot_m (copy)

    if arg4._reward_slot then
        arg4._reward_slot:Destroy()
        arg4._reward_slot = nil
    end

    local v2 = PlayerDataController_m:Get("Seasons")[SeasonLibrary_m.CurrentSeason.Name]
    local v1 = v2

    if v1 then
        v1 = v2.RankedPerformances[SeasonLibrary_m.UNIVERSAL_ELO_NAME]
    end

    local v3 = v1 and v1.CurrentELO ~= nil
    arg4.Frame.Visible = v3

    if not arg4.Frame.Visible then
        return
    end

    v3 = SeasonLibrary_m:GetGloryPayout(SeasonLibrary_m.CurrentSeason.Name, v2)
    arg4.Description.Text = string.format(
        "You'll receive <font transparency=\"0\" weight=\"900\">%s Glory</font> when this season ends!",
        v3
    )
    arg4.Description2.Text = string.format(
        "Based on your total ranked wins (<font transparency=\"0\" weight=\"900\">%s</font> / %s) and your final ELO (<font transparency=\"0\" weight=\"900\">%s</font> / %s)",
        Utility_m:PrettyNumber(
            (math.min(v1.DuelsWon, SeasonLibrary_m.CurrentSeason.GloryPayoutMaxWins))
        ),
        Utility_m:PrettyNumber(SeasonLibrary_m.CurrentSeason.GloryPayoutMaxWins),
        Utility_m:PrettyNumber(
            (math.min(v1.CurrentELO, SeasonLibrary_m.CurrentSeason.GloryPayoutMaxELO))
        ),
        Utility_m:PrettyNumber(SeasonLibrary_m.CurrentSeason.GloryPayoutMaxELO)
    )
    arg4._reward_slot = RewardSlot_m.new({ Name = "Glory", Quantity = v3 })
    arg4._reward_slot:SetParent(arg4.Container)
end

function t._Init(_) -- line: 78
end

return t
