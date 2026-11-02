local Players = game:GetService("Players")
local ClientEnemy_m = require(
    Players.LocalPlayer.PlayerScripts.Modules.ClientReplicatedClasses.ClientEntity.ClientHumanoidEntity.ClientEnemy
)
local DPSGui = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("DPSGui")
local t = setmetatable({}, ClientEnemy_m)
t.__index = t

function t.new(...) -- line: 11
    -- upvalues:
    --  [1] ClientEnemy_m (copy)
    --  [2] t (copy)
    --  [3] DPSGui (copy)

    local t_1 = setmetatable(ClientEnemy_m.new(...), t)
    t_1._gui = DPSGui:Clone()
    t_1._dps_start = nil
    t_1._dps_initial_damage = 0
    t_1._dps_total_damage = 0
    t_1._dps_hash = 0
    t_1:_Init()

    return t_1
end

function t.ReplicateFromServer(arg1, arg2, ...) -- line: 29
    -- upvalues:
    --  [1] ClientEnemy_m (copy)

    if arg2 == "RegisterDPS" then
        if not arg1:IsRendered() then
            return
        end

        local v2 = ...
        arg1._dps_start = arg1._dps_start or tick()
        arg1._dps_initial_damage = arg1._dps_initial_damage or v2
        arg1._dps_total_damage += v2
        arg1._dps_hash += 1
        local v5 = arg1._dps_total_damage - (if math.abs(
            arg1._dps_initial_damage - arg1._dps_total_damage
        ) < 0.001 then 0 else arg1._dps_initial_damage)
        arg1._gui.MainFrame.Bar.Bar.Size = UDim2.new(1, 0, 1, 0)
        arg1._gui.MainFrame.Bar.Bar:TweenSize(
            UDim2.new(0, 0, 1, 0),
            "Out",
            "Linear",
            3,
            true
        )
        arg1._gui.MainFrame.DPS.Text = string.format(
            "DPS: %.1f",
            v5 / math.max(1, tick() - arg1._dps_start)
        )
        arg1._gui.MainFrame.Total.Text = string.format("Total: %.1f", arg1._dps_total_damage)
        arg1._gui.Enabled = true
        local DpsHash = arg1._dps_hash
        task.delay(3, function() -- line: 54
            -- upvalues:
            --  [1] arg1 (copy)
            --  [2] DpsHash (copy)

            if arg1._destroyed or arg1._dps_hash ~= DpsHash then
                return
            end

            arg1._dps_start = nil
            arg1._dps_initial_damage = 0
            arg1._dps_total_damage = 0
            arg1._gui.Enabled = false
        end)

        return
    else
        ClientEnemy_m.ReplicateFromServer(arg1, arg2, ...)

        return
    end
end

function t._Setup(arg3) -- line: 73
    arg3._gui.Enabled = false
    arg3._gui.Parent = arg3.RootPart
end

function t._Init(arg4) -- line: 78
    arg4:_Setup()
end

return t
