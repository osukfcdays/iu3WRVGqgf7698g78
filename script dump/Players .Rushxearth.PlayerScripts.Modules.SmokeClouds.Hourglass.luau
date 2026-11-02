local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local SmokeCloud_m = require(Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("SmokeCloud"))
local t = setmetatable({}, SmokeCloud_m)
t.__index = t

function t.new(...) -- line: 10
    -- upvalues:
    --  [1] SmokeCloud_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(SmokeCloud_m.new(...), t)
    t_1:_Init()

    return t_1
end

function t.Update(arg1, arg2) -- line: 22
    -- upvalues:
    --  [1] SmokeCloud_m (copy)

    if SmokeCloud_m.Update(arg1, arg2) then
        return
    end

    arg1.Model:PivotTo(
        CFrame.new(arg1._position_spring.Value, workspace.CurrentCamera.CFrame.Position) * CFrame.Angles(
            -arg1._spin,
            0,
            0
        )
    )
end

function t._CreateIdleSound(_) -- line: 34
    -- upvalues:
    --  [1] Utility_m (copy)

    return Utility_m:CreateSound(
        "rbxassetid://94857514154727",
        2,
        1,
        nil,
        true
    )
end

function t._Init(_) -- line: 38
end

return t
