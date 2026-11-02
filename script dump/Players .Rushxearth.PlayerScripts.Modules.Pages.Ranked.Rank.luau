local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local SeasonLibrary_m = require(ReplicatedStorage.Modules.SeasonLibrary)
local PlayerDataController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.PlayerDataController
)
local ELOBar_m = require(Players.LocalPlayer.PlayerScripts.Modules.ELOBar)
local t = {}
t.__index = t

function t.new(arg1) -- line: 11
    -- upvalues:
    --  [1] t (copy)
    --  [2] ELOBar_m (copy)

    local t_1 = setmetatable({}, t)
    t_1.Page = arg1
    t_1.Frame = t_1.Page.Container:WaitForChild("Rank")
    t_1.ELOBar = ELOBar_m.new()
    t_1:_Init()

    return t_1
end

function t.Open(arg2) -- line: 27
    arg2.ELOBar:Update(true)
    arg2:_UpdateLayoutOrder()
end

function t.Close(arg3) -- line: 32
    arg3.ELOBar:Update(false)
    arg3:_UpdateLayoutOrder()
end

function t._UpdateLayoutOrder(arg4) -- line: 41
    -- upvalues:
    --  [1] PlayerDataController_m (copy)
    --  [2] SeasonLibrary_m (copy)

    local v2 = PlayerDataController_m:Get("Seasons")[SeasonLibrary_m.CurrentSeason.Name]
    local v1 = v2

    if v1 then
        v1 = v2.RankedPerformances[SeasonLibrary_m.UNIVERSAL_ELO_NAME]
    end

    v2 = v1 and v1.CurrentELO ~= nil
    arg4.Frame.LayoutOrder = if not v2 then 20 else 0
end

function t._Setup(arg5) -- line: 49
    arg5.ELOBar:SetParent(arg5.Frame)
end

function t._Init(arg6) -- line: 53
    arg6:_Setup()
    arg6:_UpdateLayoutOrder()
end

return t
