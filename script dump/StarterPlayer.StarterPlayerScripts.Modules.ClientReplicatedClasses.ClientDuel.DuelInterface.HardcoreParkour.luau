local ReplicatedStorage = game:GetService("ReplicatedStorage")
local _ = game:GetService("RunService")
local Players = game:GetService("Players")
local CONSTANTS_m = require(ReplicatedStorage.Modules.CONSTANTS)
local DuelLibrary_m = require(ReplicatedStorage.Modules.DuelLibrary)
local Pages_m = require(Players.LocalPlayer.PlayerScripts.Modules.UserInterface.Pages)
local t = {}
local ObbyGradient = ReplicatedStorage.Assets.Misc.ObbyGradient
local ParkourPlayerSlot = Players.LocalPlayer.PlayerScripts.UserInterface.ParkourPlayerSlot
t.__index = t

function t.new(arg1) -- line: 16
    -- upvalues:
    --  [1] t (copy)

    local t_1 = setmetatable({}, t)
    t_1.DuelInterface = arg1
    t_1.Frame = t_1.DuelInterface.Frame:WaitForChild("HardcoreParkour")
    t_1.Container = t_1.Frame:WaitForChild("Container")
    t_1.ProgressFrame = t_1.Container:WaitForChild("Progress")
    t_1.ProgressContainer = t_1.ProgressFrame:WaitForChild("Container")
    t_1.BarFrame = t_1.ProgressContainer:WaitForChild("Bar")
    t_1.BarStroke = t_1.BarFrame:WaitForChild("UIStroke")
    t_1.DuelersFrame = t_1.ProgressContainer:WaitForChild("Duelers")
    t_1._destroyed = false
    t_1._tasks = {}
    t_1._connections = {}
    t_1._slots = {}
    t_1:_Init()

    return t_1
end

function t.Update(arg2) -- line: 42
    -- upvalues:
    --  [1] Pages_m (copy)
    --  [2] DuelLibrary_m (copy)
    --  [3] ParkourPlayerSlot (copy)
    --  [4] CONSTANTS_m (copy)

    local v1 = not arg2._destroyed

    if v1 then
        v1 = arg2.DuelInterface:IsActive()

        if v1 then
            v1 = not arg2.DuelInterface.Scoreboard:IsOpen()

            if v1 then
                v1 = not arg2.DuelInterface.Voting:IsOpen()

                if v1 then
                    v1 = not Pages_m.PageSystem.CurrentPage

                    if v1 then
                        v1 = not arg2.DuelInterface.RoundResult.Frame.Visible

                        if v1 then
                            v1 = if arg2.DuelInterface.ClientDuel:Get("Status") == "GameOver" then false else true
                        end
                    end
                end
            end
        end
    end

    local v2 = arg2.DuelInterface.ClientDuel.Map

    if v2 then
        v2 = arg2.DuelInterface.ClientDuel.Map:Get("ObbyStartPosition")
    end

    local v3 = arg2.DuelInterface.ClientDuel.Map

    if v3 then
        v3 = arg2.DuelInterface.ClientDuel.Map:Get("ObbyFinishPosition")
    end

    local v4 = v2 and v3 and v1 and true

    if v4 == arg2.Frame.Visible then
        return
    end

    arg2:_Cleanup()
    arg2.Frame.Visible = v4

    if not v4 then
        return
    end

    local v5 = v2 * Vector3.new(1, 0, 1)
    local Magnitude = (v5 - v3 * Vector3.new(1, 0, 1)).Magnitude

    local function update_positions(arg3) -- line: 65
        -- upvalues:
        --  [1] arg2 (copy)
        --  [2] v5 (ref)
        --  [3] Magnitude (copy)

        local t_2 = {}
        local v6

        for _, val in pairs(arg2._slots) do
            v6 = val.ClientDueler.ClientFighter and val.ClientDueler.ClientFighter.Entity and val.ClientDueler.ClientFighter.Entity.RootPart and val.ClientDueler.ClientFighter.Entity.RootPart.Position
            table.insert(
                t_2,
                {
                    val,
                    if not v6 then nil else if arg2.DuelInterface.ClientDuel:Get("Status") == "RoundStarting" then 0 else (v6 * Vector3.new(1, 0, 1) - v5).Magnitude
                }
            )
        end

        table.sort(t_2, function(arg4, arg5) -- line: 77
            return (arg4[2] or 0) < (arg5[2] or 0)
        end)

        for key_1, val_1 in pairs(t_2) do
            local v7
            v6, v7 = table.unpack(val_1)
            v6.Slot.ZIndex = key_1

            if v7 then
                local udim2 = UDim2.new(math.clamp(v7 / Magnitude, 0, 1), 0, 0.5, 0)
                v7 = if arg3 ~= v6.ClientDueler then udim2.X.Scale < v6.Slot.Position.X.Scale and true else true

                if v7 then
                    v6.Slot.Position = udim2
                end

                local v10 = if not v7 then 1 else 0
                v6.Slot:TweenPosition(
                    udim2,
                    "Out",
                    "Linear",
                    v10,
                    true
                )
            end
        end
    end

    table.insert(arg2._tasks, task.spawn(function() -- line: 101
        -- upvalues:
        --  [1] update_positions (copy)

        while true do
            update_positions()
            wait(1)
        end
    end))

    function v1(arg6) --[[ dueler_removed ]] -- line: 108
        -- upvalues:
        --  [1] arg2 (copy)
        --  [2] update_positions (copy)

        if arg2._slots[arg6.Player] then
            arg2._slots[arg6.Player].Slot:Destroy()
            arg2._slots[arg6.Player] = nil
        end

        update_positions()
    end

    table.insert(arg2._connections, arg2.DuelInterface.ClientDuel.DuelerRemoved:Connect(v1))

    local function dueler_added(arg7) -- line: 119
        -- upvalues:
        --  [1] arg2 (copy)
        --  [2] update_positions (copy)
        --  [3] DuelLibrary_m (ref)
        --  [4] ParkourPlayerSlot (ref)
        --  [5] CONSTANTS_m (ref)

        if arg2._slots[arg7.Player] then
            arg2._slots[arg7.Player].Slot:Destroy()
            arg2._slots[arg7.Player] = nil
        end

        update_positions()
        local v12 = DuelLibrary_m:GetTeamColor(arg7:Get("TeamID"))
        local v13 = ParkourPlayerSlot:Clone()
        v13.Container.Arrow.ImageColor3 = v12
        v13.Container.Background.ImageColor3 = v12
        v13.Size = arg7.IsLocalDueler and UDim2.new(1, 0, 1, 0) or UDim2.new(0.75, 0, 0.75, 0)
        v13.Container.Headshot.Image = string.format(CONSTANTS_m.HEADSHOT_IMAGE, arg7.Player.UserId)
        v13.Position = UDim2.new(0, 0, 0.5, 0)
        v13.Parent = arg2.DuelersFrame
        arg2._slots[arg7.Player] = { Slot = v13, ClientDueler = arg7 }
        update_positions(arg7)
    end

    table.insert(arg2._connections, arg2.DuelInterface.ClientDuel.DuelerAdded:Connect(dueler_added))
    local _ = arg2.DuelInterface.ClientDuel.DuelerAdded:Connect(dueler_added)

    for _, val_2 in pairs(arg2.DuelInterface.ClientDuel.Duelers) do
        task.spawn(dueler_added, val_2)
    end
end

function t.Destroy(arg8) -- line: 143
    arg8._destroyed = true
    arg8:_Cleanup()
end

function t._Cleanup(arg9) -- line: 152
    for _, val_3 in pairs(arg9._tasks) do
        task.cancel(val_3)
    end

    for _, val_4 in pairs(arg9._connections) do
        val_4:Disconnect()
    end

    for _, val_5 in pairs(arg9._slots) do
        val_5.Slot:Destroy()
    end

    arg9._tasks = {}
    arg9._connections = {}
    arg9._slots = {}
end

function t._Setup(arg10) -- line: 170
    -- upvalues:
    --  [1] ObbyGradient (copy)

    ObbyGradient:Clone().Parent = arg10.BarFrame
    ObbyGradient:Clone().Parent = arg10.BarStroke
end

function t._Init(arg11) -- line: 175
    arg11.DuelInterface.RoundResult.Frame:GetPropertyChangedSignal("Visible"):Connect(function() -- line: 176
        -- upvalues:
        --  [1] arg11 (copy)

        arg11:Update()
    end)
    arg11.DuelInterface.Scoreboard.VisibilityChanged:Connect(function() -- line: 180
        -- upvalues:
        --  [1] arg11 (copy)

        arg11:Update()
    end)
    arg11.DuelInterface.Voting.VisibilityChanged:Connect(function() -- line: 184
        -- upvalues:
        --  [1] arg11 (copy)

        arg11:Update()
    end)
    arg11:_Setup()
end

return t
