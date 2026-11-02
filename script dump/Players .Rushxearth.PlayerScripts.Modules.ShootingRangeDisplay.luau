local Players = game:GetService("Players")
local FighterController_m = require(Players.LocalPlayer.PlayerScripts.Controllers.FighterController)
local TeammateSlot_m = require(Players.LocalPlayer.PlayerScripts.Modules.TeammateSlot)
local ShootingRangeGui = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild(
    "ShootingRangeGui"
)
local t = {}
t.__index = t

function t.new(arg1) -- line: 11
    -- upvalues:
    --  [1] t (copy)
    --  [2] ShootingRangeGui (copy)

    local t_1 = setmetatable({}, t)
    t_1.SurfaceGui = ShootingRangeGui:Clone()
    t_1._part = arg1
    t_1._connections = {}
    t_1._is_enabled = false
    t_1._teammate_slots = {}
    t_1:_Init()

    return t_1
end

function t.SetEnabled(arg2, arg3) -- line: 30
    -- upvalues:
    --  [1] FighterController_m (copy)

    if arg3 == arg2._is_enabled then
        return
    end

    for _, val in pairs(arg2._connections) do
        val:Disconnect()
    end

    arg2._connections = {}
    arg2._is_enabled = arg3

    if not arg2._is_enabled then
        arg2:_GeneratePlayers()

        return
    end

    table.insert(arg2._connections, FighterController_m.ObjectRemoved:Connect(function() -- line: 47
        -- upvalues:
        --  [1] arg2 (copy)

        arg2:_GeneratePlayers()
    end))

    local function client_fighter_added(arg4, arg5) -- line: 51
        -- upvalues:
        --  [1] arg2 (copy)

        local Connections_1 = arg2._connections
        local IsInShootingRange = arg4:GetDataChangedSignal("IsInShootingRange")
        table.insert(Connections_1, IsInShootingRange:Connect(function() -- line: 52
            -- upvalues:
            --  [1] arg2 (ref)

            arg2:_GeneratePlayers()
        end))

        if not arg5 then
            arg2:_GeneratePlayers()
        end
    end

    table.insert(arg2._connections, FighterController_m.ObjectAdded:Connect(client_fighter_added))
    local _ = FighterController_m.ObjectAdded:Connect(client_fighter_added)

    for _, val_1 in pairs(FighterController_m.Objects) do
        table.insert(arg2._connections, val_1:GetDataChangedSignal("IsInShootingRange"):Connect(function() -- line: 52
            -- upvalues:
            --  [1] arg2 (copy)

            arg2:_GeneratePlayers()
        end))
    end

    arg2:_GeneratePlayers()
end

function t.Destroy(arg6) -- line: 70
    arg6:SetEnabled(false)
    arg6.SurfaceGui:Destroy()
end

function t._GeneratePlayers(arg7) -- line: 79
    -- upvalues:
    --  [1] FighterController_m (copy)
    --  [2] TeammateSlot_m (copy)

    for _, val_2 in pairs(arg7._teammate_slots) do
        val_2:Destroy()
    end

    arg7._teammate_slots = {}
    arg7.SurfaceGui.Title.Position = UDim2.new(0.5, 0, 0.5, 0)
    arg7.SurfaceGui.Title.Size = UDim2.new(0.25, 0, 0.4, 0)

    if not arg7._is_enabled then
        return
    end

    for _, val_3 in pairs(FighterController_m.Objects) do
        if val_3:Get("IsInShootingRange") then
            local v1 = val_3.Player:GetAttribute("StatisticDuelsWinStreak") or 0
            local v3 = TeammateSlot_m.new(
                val_3.Player.UserId,
                val_3:Get("Controls"),
                1,
                false,
                false,
                v1,
                val_3.Player:GetAttribute("Level")
            )
            v3.SlotFrame.LayoutOrder = -v1
            v3.SlotFrame.Parent = arg7.SurfaceGui.Players
            table.insert(arg7._teammate_slots, v3)
        end
    end

    if #arg7._teammate_slots > 0 then
        arg7.SurfaceGui.Title.Position = UDim2.new(0.5, 0, 0.375, 0)
        arg7.SurfaceGui.Title.Size = UDim2.new(0.5, 0, 0.1, 0)
    end
end

function t._Setup(arg8) -- line: 111
    -- upvalues:
    --  [1] Players (copy)

    arg8.SurfaceGui.Adornee = arg8._part
    arg8.SurfaceGui.Parent = Players.LocalPlayer.PlayerGui
end

function t._Init(arg9) -- line: 116
    arg9:_Setup()
end

return t
