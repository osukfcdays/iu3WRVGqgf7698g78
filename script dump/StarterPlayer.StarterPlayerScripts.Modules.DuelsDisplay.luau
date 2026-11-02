local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local EventLibrary_m = require(ReplicatedStorage.Modules.EventLibrary)
local DuelController_m = require(Players.LocalPlayer.PlayerScripts.Controllers.DuelController)
local DuelDisplay_m = require(script:WaitForChild("DuelDisplay"))
local LobbyVisuals = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("LobbyVisuals")
local t = {}
t.__index = t

function t.new(arg1) -- line: 13
    -- upvalues:
    --  [1] t (copy)
    --  [2] LobbyVisuals (copy)
    --  [3] EventLibrary_m (copy)

    local t_1 = setmetatable({}, t)
    t_1.Part = arg1
    local v2 = LobbyVisuals:FindFirstChild(EventLibrary_m.LOBBY_VISUALS_PROFILE) and LobbyVisuals[EventLibrary_m.LOBBY_VISUALS_PROFILE]:FindFirstChild(
        "DuelsBoardGui"
    ) or LobbyVisuals.Default.DuelsBoardGui
    t_1.SurfaceGui = v2:Clone()
    t_1._duel_displays = {}
    t_1._connections = {}
    t_1._enabled_hash = 0
    t_1._is_enabled = nil
    t_1:_Init()

    return t_1
end

function t.SetEnabled(arg2, arg3) -- line: 33
    if arg2._is_enabled == arg3 then
        return
    end

    arg2._is_enabled = arg3
    arg2:_Clear()

    if arg3 then
        task.spawn(arg2._Generate, arg2)
    end
end

function t._UpdateEmpty(arg4) -- line: 50
    arg4.SurfaceGui.Empty.Visible = not next(arg4._duel_displays)
end

function t._Generate(arg5) -- line: 54
    -- upvalues:
    --  [1] DuelController_m (copy)

    arg5._enabled_hash += 1
    local EnabledHash = arg5._enabled_hash
    task.spawn(function() -- line: 58
        -- upvalues:
        --  [1] arg5 (copy)
        --  [2] EnabledHash (copy)

        while true do
            arg5.SurfaceGui.Live.Text = "\226\128\162 LIVE"
            wait(1)

            if EnabledHash ~= arg5._enabled_hash then
                return
            end

            arg5.SurfaceGui.Live.Text = "LIVE"
            wait(0.25)

            if EnabledHash == arg5._enabled_hash then
                continue
            end

            return
        end
    end)
    table.insert(arg5._connections, DuelController_m.ObjectAdded:Connect(function(arg6) -- line: 78
        -- upvalues:
        --  [1] arg5 (copy)

        arg5:_DuelAdded(arg6)
    end))
    table.insert(arg5._connections, DuelController_m.ObjectRemoved:Connect(function(arg7) -- line: 82
        -- upvalues:
        --  [1] arg5 (copy)

        arg5:_DuelRemoved(arg7)
    end))
    local _ = DuelController_m.ObjectRemoved:Connect(function(arg7) -- line: 82
        -- upvalues:
        --  [1] arg5 (copy)

        arg5:_DuelRemoved(arg7)
    end)

    for _, val in pairs(DuelController_m.Objects) do
        task.defer(arg5._DuelAdded, arg5, val)
    end
end

function t._Clear(arg8) -- line: 91
    for _, val_1 in pairs(arg8._duel_displays) do
        val_1:Destroy()
    end

    for _, val_2 in pairs(arg8._connections) do
        val_2:Disconnect()
    end

    arg8._connections = {}
    arg8._duel_displays = {}
    arg8._enabled_hash += 1
end

function t._DuelAdded(arg9, arg10) -- line: 105
    -- upvalues:
    --  [1] DuelDisplay_m (copy)

    arg9:_DuelRemoved(arg10)

    if arg10:Get("Status") == "GameOver" then
        return
    end

    local v3 = DuelDisplay_m.new(arg10)
    v3.Frame.Parent = arg9.SurfaceGui.List.Container
    arg9._duel_displays[arg10] = v3
    v3.GameOver:Connect(function() -- line: 116
        -- upvalues:
        --  [1] arg9 (copy)
        --  [2] arg10 (copy)

        arg9:_DuelRemoved(arg10)
    end)
    arg9:_UpdateEmpty()
end

function t._DuelRemoved(arg11, arg12) -- line: 123
    if arg11._duel_displays[arg12] then
        arg11._duel_displays[arg12]:Destroy()
        arg11._duel_displays[arg12] = nil
    end

    arg11:_UpdateEmpty()
end

function t._Setup(arg13) -- line: 132
    -- upvalues:
    --  [1] Players (copy)

    arg13.SurfaceGui.Adornee = arg13.Part
    arg13.SurfaceGui.Parent = Players.LocalPlayer.PlayerGui
end

function t._Init(arg14) -- line: 137
    arg14.SurfaceGui.List.Container.Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(
        function() -- line: 138
            -- upvalues:
            --  [1] arg14 (copy)

            arg14.SurfaceGui.List.CanvasSize = UDim2.new(
                0,
                0,
                0,
                arg14.SurfaceGui.List.Container.Layout.AbsoluteContentSize.Y
            )
        end
    )
    arg14:_Setup()
    arg14:_UpdateEmpty()
    arg14:SetEnabled(true)
end

return t
