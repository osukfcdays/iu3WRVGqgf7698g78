local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local SoundLibrary_m = require(ReplicatedStorage.Modules.SoundLibrary)
local BetterDebris_m = require(ReplicatedStorage.Modules.BetterDebris)
local DuelLibrary_m = require(ReplicatedStorage.Modules.DuelLibrary)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local ComplianceController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.ComplianceController
)
local UILibrary_m = require(Players.LocalPlayer.PlayerScripts.Modules.UILibrary)
local EliminationSlot = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild(
    "EliminationSlot"
)
local t = {}
t.__index = t

function t.new(arg1) -- line: 18
    -- upvalues:
    --  [1] t (copy)
    --  [2] UILibrary_m (copy)

    local t_1 = setmetatable({}, t)
    t_1.FighterInterface = arg1
    t_1.Frame = t_1.FighterInterface.Frame:WaitForChild("EliminationSlots")
    t_1._destroyed = false
    t_1._connections = {}
    t_1._reference_frame = UILibrary_m:GetTo("MainFrame", "BottomStack", "EliminationSlots")
    t_1._elimination_queue = {}
    t_1._elimination_queue_playing = false
    t_1._elimination_chain = 0
    t_1:_Init()

    return t_1
end

function t.SetVisible(arg2, arg3) -- line: 40
    arg2.Frame.Visible = arg3
end

function t.Refresh(arg4) -- line: 44
    arg4.Frame.Position = UDim2.new(0.5, 0, 0, arg4._reference_frame.AbsolutePosition.Y)
end

function t.Clear(arg5) -- line: 48
    arg5._elimination_chain = 0
end

function t.Create(arg6, ...) -- line: 52
    -- upvalues:
    --  [1] Players (copy)
    --  [2] SoundLibrary_m (copy)
    --  [3] DuelLibrary_m (copy)
    --  [4] ComplianceController_m (copy)
    --  [5] EliminationSlot (copy)
    --  [6] BetterDebris_m (copy)
    --  [7] Utility_m (copy)

    if not arg6.FighterInterface:IsActive() then
        return
    end

    table.insert(arg6._elimination_queue, { ... })

    if arg6._elimination_queue_playing then
        return
    end

    arg6._elimination_queue_playing = true

    while true do
        if not (#arg6._elimination_queue > 0) then
            break
        end

        local v1, v2 = table.unpack(table.remove(arg6._elimination_queue, 1))

        if v1 == Players.LocalPlayer then
            continue
        end

        arg6._elimination_chain += 1
        local clampedValue = math.clamp(arg6._elimination_chain - 3, 0, 10)
        local FighterInterface = arg6.FighterInterface
        local EliminationSounds = SoundLibrary_m.EliminationSounds
        local v3 = clampedValue * 0.25 + 2
        FighterInterface:CreateSound(
            EliminationSounds[math.min(arg6._elimination_chain, 3)],
            v3,
            clampedValue * 0.1 + 1,
            script,
            true,
            10
        )
        local v6 = DuelLibrary_m:GetTeamColor(arg6.FighterInterface.ClientFighter:Get("TeamID"))
        local v7 = string.format(
            "%s,%s,%s",
            string.format("%.0f", v6.R * 255),
            string.format("%.0f", v6.G * 255),
            string.format("%.0f", v6.B * 255)
        )
        local v8 = ComplianceController_m:GetName(arg6.FighterInterface.ClientFighter.Player)
        local v9 = not arg6.FighterInterface.ClientFighter.IsLocalPlayer

        if v9 then
            v9 = string.format(
                "<stroke color=\"rgb(0,0,0)\" joins=\"round\" thickness=\"3\" transparency=\"0\"><font color=\"rgb(%s)\"><font weight=\"800\">%s</font></font></stroke>  ",
                v7,
                v8
            )
        end

        v7 = if not v2 then "Eliminated" else "Assist"
        local v13 = DuelLibrary_m:GetTeamColor(v1:GetAttribute("TeamID"))
        local formattedText_4 = string.format(
            "%s,%s,%s",
            string.format("%.0f", v13.R * 255),
            string.format("%.0f", v13.G * 255),
            string.format("%.0f", v13.B * 255)
        )
        local v15 = ComplianceController_m:GetName(v1)
        local string_format_2 = string.format
        local v16 = v9 and string.lower(v7) or v7
        local v19 = string_format_2(
            "<stroke color=\"rgb(0,0,0)\" joins=\"round\" thickness=\"1\" transparency=\"0.75\"><font weight=\"500\">%s  </font></stroke><stroke color=\"rgb(0,0,0)\" joins=\"round\" thickness=\"3\" transparency=\"0\"><font color=\"rgb(%s)\"><font weight=\"800\">%s</font></font></stroke>",
            v16,
            formattedText_4,
            v15
        )
        local v20 = EliminationSlot:Clone()
        v20.LayoutOrder = arg6._elimination_chain
        v20.TextLabel.Text = (v9 or "") .. v19
        v20.Size = UDim2.new(1, 0, 0, 0)
        v20.Parent = arg6.Frame
        BetterDebris_m:AddItem(v20, 5)
        v20:TweenSize(
            UDim2.new(1, 0, if v9 then 0.75 else 1, 6),
            "Out",
            "Back",
            0.25,
            true,
            function() -- line: 95
                -- upvalues:
                --  [1] arg6 (copy)
                --  [2] v20 (copy)
                --  [3] Players (ref)
                --  [4] Utility_m (ref)

                wait(3)

                if arg6._destroyed or not v20:IsDescendantOf(Players.LocalPlayer) then
                    return
                end

                v20:TweenSize(
                    UDim2.new(1, 0, 0, 0),
                    "In",
                    "Quint",
                    0.5,
                    true
                )
                Utility_m:RenderstepForLoop(0, 100, 10, function(arg7) -- line: 104
                    -- upvalues:
                    --  [1] v20 (ref)

                    v20.GroupTransparency = arg7 / 100
                end)
                v20:Destroy()

                if #arg6.Frame:GetChildren() == 1 then
                    arg6:Clear()
                end
            end
        )
        wait(0.04)
    end

    arg6._elimination_queue_playing = false
end

function t.Destroy(arg8) -- line: 121
    arg8._destroyed = true

    for _, val in pairs(arg8._connections) do
        val:Disconnect()
    end

    arg8._connections = {}
end

function t._Init(arg9) -- line: 135
    local Connections = arg9._connections
    local AbsolutePosition = arg9._reference_frame:GetPropertyChangedSignal("AbsolutePosition")
    table.insert(Connections, AbsolutePosition:Connect(function() -- line: 136
        -- upvalues:
        --  [1] arg9 (copy)

        arg9:Refresh()
    end))
end

return t
