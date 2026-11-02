local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local SeasonLibrary_m = require(ReplicatedStorage.Modules.SeasonLibrary)
local PlayerDataController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.PlayerDataController
)
local t = {}
t.__index = t

function t.new(arg1) -- line: 10
    -- upvalues:
    --  [1] t (copy)

    local t_1 = setmetatable({}, t)
    t_1.Page = arg1
    t_1.Frame = t_1.Page.Container:WaitForChild("ELOShield")
    t_1.Title = t_1.Frame:WaitForChild("Title")
    t_1.LeftIcon = t_1.Title:WaitForChild("Left")
    t_1.RightIcon = t_1.Title:WaitForChild("Right")
    t_1:_Init()

    return t_1
end

function t.Open(arg2) -- line: 28
    arg2:_Update()
end

function t.Close(_) -- line: 32
end

function t._UpdateIcons(arg4) -- line: 40
    arg4.LeftIcon.Position = UDim2.new(0.5, -arg4.Title.TextBounds.X / 2, 0.5, 0)
    arg4.RightIcon.Position = UDim2.new(0.5, arg4.Title.TextBounds.X / 2, 0.5, 0)
end

function t._Update(arg5) -- line: 45
    -- upvalues:
    --  [1] PlayerDataController_m (copy)
    --  [2] SeasonLibrary_m (copy)

    local v2 = PlayerDataController_m:Get("Seasons")[SeasonLibrary_m.CurrentSeason.Name]
    local v1 = v2

    if v1 then
        v1 = v2.RankedPerformances[SeasonLibrary_m.UNIVERSAL_ELO_NAME]
    end

    local Frame = arg5.Frame
    local v3 = v1 and v1.ELOShieldsRemaining > 0
    Frame.Visible = v3
    arg5:_UpdateIcons()
end

function t._Init(arg6) -- line: 53
    arg6.Title:GetPropertyChangedSignal("TextBounds"):Connect(function() -- line: 54
        -- upvalues:
        --  [1] arg6 (copy)

        arg6:_UpdateIcons()
    end)
    arg6:_UpdateIcons()
end

return t
