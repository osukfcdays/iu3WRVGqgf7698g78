local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local MatchmakingController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("MatchmakingController")
)
local t = {}
t.__index = t

function t.new(arg1) -- line: 13
    -- upvalues:
    --  [1] t (copy)

    local t_1 = setmetatable({}, t)
    t_1.Inset = arg1
    t_1.LeftFrame = t_1.Inset.LeftButtonsFrame:WaitForChild("Details")
    t_1.LeftContainer = t_1.LeftFrame:WaitForChild("Container")
    t_1.LeftServerRegionFrame = t_1.LeftContainer:WaitForChild("ServerRegion")
    t_1.LeftServerRegionTitle = t_1.LeftServerRegionFrame:WaitForChild("Title")
    t_1.LeftConnectionFrame = t_1.LeftContainer:WaitForChild("Connection")
    t_1.LeftConnectionTitle = t_1.LeftConnectionFrame:WaitForChild("Title")
    t_1.LeftConnectionIcon = t_1.LeftConnectionFrame:WaitForChild("Icon")
    t_1.RightFrame = t_1.Inset.RightButtonsFrame:WaitForChild("Details")
    t_1.RightContainer = t_1.RightFrame:WaitForChild("Container")
    t_1.RightServerRegionFrame = t_1.RightContainer:WaitForChild("ServerRegion")
    t_1.RightServerRegionTitle = t_1.RightServerRegionFrame:WaitForChild("Title")
    t_1.RightConnectionFrame = t_1.RightContainer:WaitForChild("Connection")
    t_1.RightConnectionTitle = t_1.RightConnectionFrame:WaitForChild("Title")
    t_1.RightConnectionIcon = t_1.RightConnectionFrame:WaitForChild("Icon")
    t_1._dt_history = {}
    t_1:_Init()

    return t_1
end

function t.SetVisible(arg2, arg3) -- line: 43
    arg2.LeftFrame.Visible = arg3 and false
    arg2.RightFrame.Visible = arg3 and true
end

function t._UpdateServerRegion(arg4) -- line: 52
    -- upvalues:
    --  [1] MatchmakingController_m (copy)

    arg4.LeftServerRegionTitle.Text = MatchmakingController_m:Get("ServerRegion") or "\226\128\162 \226\128\162 \226\128\162"
    arg4.RightServerRegionTitle.Text = arg4.LeftServerRegionTitle.Text
end

function t._UpdateTextBounds(arg5) -- line: 57
    arg5.LeftFrame.Size = UDim2.new(
        1.25,
        math.max(arg5.LeftServerRegionTitle.TextBounds.X, arg5.LeftConnectionTitle.TextBounds.X),
        1,
        0
    )
    arg5.RightFrame.Size = UDim2.new(
        1.25,
        math.max(arg5.RightServerRegionTitle.TextBounds.X, arg5.RightConnectionTitle.TextBounds.X),
        1,
        0
    )
end

function t._GetFramerate(arg6) -- line: 62
    -- upvalues:
    --  [1] RunService (copy)

    table.insert(arg6._dt_history, 1, RunService.RenderStepped:Wait())
    table.remove(arg6._dt_history, 11)
    local v2 = 0
    local _ = RunService.RenderStepped:Wait()

    for _, val in pairs(arg6._dt_history) do
        v2 += val
    end

    return (math.floor(1 / (v2 / #arg6._dt_history)))
end

function t._UpdateConnectionLoop(arg7) -- line: 75
    -- upvalues:
    --  [1] Utility_m (copy)

    while true do
        local v4 = Utility_m:GetLocalConnectionPing()
        local v6 = Utility_m:GetConnectionLevelIcon((Utility_m:GetConnectionLevel(v4)))
        arg7.LeftConnectionTitle.Text = arg7:_GetFramerate() .. "fps   " .. v4 .. "ms"
        arg7.LeftConnectionIcon.Image = v6 or ""
        arg7.RightConnectionTitle.Text = arg7.LeftConnectionTitle.Text
        arg7.RightConnectionIcon.Image = arg7.LeftConnectionIcon.Image
        wait(0.25)
    end
end

function t._Init(arg8) -- line: 91
    -- upvalues:
    --  [1] MatchmakingController_m (copy)

    arg8.LeftServerRegionTitle:GetPropertyChangedSignal("TextBounds"):Connect(function() -- line: 92
        -- upvalues:
        --  [1] arg8 (copy)

        arg8:_UpdateTextBounds()
    end)
    arg8.RightServerRegionTitle:GetPropertyChangedSignal("TextBounds"):Connect(function() -- line: 96
        -- upvalues:
        --  [1] arg8 (copy)

        arg8:_UpdateTextBounds()
    end)
    arg8.LeftConnectionTitle:GetPropertyChangedSignal("TextBounds"):Connect(function() -- line: 100
        -- upvalues:
        --  [1] arg8 (copy)

        arg8:_UpdateTextBounds()
    end)
    arg8.RightConnectionTitle:GetPropertyChangedSignal("TextBounds"):Connect(function() -- line: 104
        -- upvalues:
        --  [1] arg8 (copy)

        arg8:_UpdateTextBounds()
    end)
    MatchmakingController_m:GetDataChangedSignal("ServerRegion"):Connect(function() -- line: 108
        -- upvalues:
        --  [1] arg8 (copy)

        arg8:_UpdateServerRegion()
    end)
    arg8:_UpdateServerRegion()
    task.defer(arg8._UpdateConnectionLoop, arg8)
end

return t
