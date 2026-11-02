local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local ClientMap_m = require(
    Players.LocalPlayer.PlayerScripts.Modules.ClientReplicatedClasses.ClientDuel.ClientMap
)
local CutsceneLogic_m = require(script:WaitForChild("CutsceneLogic"))
local ZombieTowerLadderGui = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild(
    "ZombieTowerLadderGui"
)
local t = setmetatable({}, ClientMap_m)
t.__index = t

function t.new(...) -- line: 16
    -- upvalues:
    --  [1] ClientMap_m (copy)
    --  [2] t (copy)
    --  [3] CutsceneLogic_m (copy)
    --  [4] ZombieTowerLadderGui (copy)

    local t_1 = setmetatable(ClientMap_m.new(...), t)
    t_1.CutsceneLogic = CutsceneLogic_m.new(t_1)
    t_1._floors_folder = t_1.Model:WaitForChild("Floors")
    t_1._spectating_thread = nil
    t_1._flashing_red_enemies_connection = nil
    t_1._ladder_guide_bbg = ZombieTowerLadderGui:Clone()
    t_1._active_enemy_humanoids = {}
    t_1:_Init()

    return t_1
end

function t.GetFloorNumberFromPosition(arg1, arg2) -- line: 36
    -- upvalues:
    --  [1] Utility_m (copy)

    local v3 = arg2 or workspace.CurrentCamera.CFrame.Position

    for _, child in pairs(arg1._floors_folder:GetChildren()) do
        local v5 = pairs
        local v6 = child:FindFirstChild("Important") and child.Important:GetChildren() or {}

        for _, val in v5(v6) do
            if val.Name == "Volume" and Utility_m:IsWithinPart(val, v3) then
                return (tonumber(child.Name))
            end
        end
    end
end

function t.GetScoreboardDisplay(arg3) -- line: 48
    local v7 = arg3:GetFloorNumberFromPosition()

    return arg3.Name .. (if not v7 then "" else "   \226\128\162   Floor " .. v7)
end

function t.ReplicateFromServer(arg4, arg5, ...) -- line: 55
    -- upvalues:
    --  [1] ClientMap_m (copy)

    if arg5 == "StopCutsceneNow" then
        if not arg4:IsRendered() then
            return
        end

        arg4.CutsceneLogic:StopCutscene()

        return
    else
        ClientMap_m.ReplicateFromServer(arg4, arg5, ...)

        return
    end
end

function t.Destroy(arg6) -- line: 67
    -- upvalues:
    --  [1] ClientMap_m (copy)

    if arg6._spectating_thread then
        task.cancel(arg6._spectating_thread)
        arg6._spectating_thread = nil
    end

    if arg6._flashing_red_enemies_connection then
        arg6._flashing_red_enemies_connection:Disconnect()
        arg6._flashing_red_enemies_connection = nil
    end

    arg6.CutsceneLogic:Destroy()
    ClientMap_m.Destroy(arg6)
end

function t._FloorAdded(arg7, arg8) -- line: 87
    local MobGroups = arg8:WaitForChild("MobGroups")

    local function humanoid_added(arg9) -- line: 90
        -- upvalues:
        --  [1] arg7 (copy)

        local t_2 = { StartFlashingRed = 0, Highlight = nil }

        local function reset() -- line: 96
            -- upvalues:
            --  [1] t_2 (copy)

            t_2.StartFlashingRed = tick() + 60

            if t_2.Highlight then
                t_2.Highlight:Destroy()
                t_2.Highlight = nil
            end
        end

        arg9.HealthChanged:Connect(reset)
        t_2.StartFlashingRed = tick() + 60

        if t_2.Highlight then
            t_2.Highlight:Destroy()
            t_2.Highlight = nil
        end

        arg7._active_enemy_humanoids[arg9] = t_2
        arg9.Destroying:Connect(function() -- line: 110
            -- upvalues:
            --  [1] arg7 (ref)
            --  [2] arg9 (copy)

            arg7._active_enemy_humanoids[arg9] = nil
        end)
    end

    local function object_value_added(arg10) -- line: 115
        -- upvalues:
        --  [1] humanoid_added (copy)

        local v10 = false

        local function check() -- line: 118
            -- upvalues:
            --  [1] v10 (ref)
            --  [2] arg10 (copy)
            --  [3] humanoid_added (ref)

            if v10 or not arg10.Value then
                return
            end

            v10 = true
            task.spawn(humanoid_added, arg10.Value)
        end

        arg10:GetPropertyChangedSignal("Value"):Connect(check)

        if not v10 and arg10.Value then
            v10 = true
            task.spawn(humanoid_added, arg10.Value)
        end
    end

    local function mob_group_added(arg11) -- line: 135
        -- upvalues:
        --  [1] object_value_added (copy)

        local EntityHumanoidObjectValues = arg11:WaitForChild("EntityHumanoidObjectValues", 3)

        if not EntityHumanoidObjectValues then
            return
        end

        EntityHumanoidObjectValues.ChildAdded:Connect(object_value_added)

        for _, val_1 in pairs(EntityHumanoidObjectValues:GetChildren()) do
            task.spawn(object_value_added, val_1)
        end
    end

    MobGroups.ChildAdded:Connect(mob_group_added)

    for _, child_1 in pairs(MobGroups:GetChildren()) do
        task.spawn(mob_group_added, child_1)
    end

    if (tonumber(arg8.Name) or 0) > 2 then
        task.delay(
            1,
            arg7.CreateSound,
            arg7,
            "rbxassetid://1843115730",
            2,
            1,
            arg8:WaitForChild("Important"):WaitForChild("Entrance"),
            true,
            10,
            400,
            400
        )
    end
end

function t._UpdateLadderGuide(_) -- line: 161
end

function t._UpdateLightingChange(arg13) -- line: 174
    -- upvalues:
    --  [1] Utility_m (copy)

    local v13 = arg13.Model:FindFirstChild("LightingParts")
    local v14 = nil
    local v15 = pairs
    local v16 = v13 and v13:GetChildren() or {}

    for _, val_2 in v15(v16) do
        if Utility_m:IsWithinPart(val_2, workspace.CurrentCamera.CFrame.Position) then
            v14 = val_2
            break
        end
    end

    v13 = v14 and v14:GetAttribute("LightingProfileOverride") or nil

    if v13 ~= arg13:Get("LightingProfileOverride") then
        arg13:SetReplicate("LightingProfileOverride", v13)
    end
end

function t._VerifySpectatingThread(arg14) -- line: 192
    if arg14._spectating_thread then
        task.cancel(arg14._spectating_thread)
        arg14._spectating_thread = nil
    end

    if not arg14.ClientDuel:Get("IsSpectating") then
        return
    end

    arg14._spectating_thread = task.spawn(function() -- line: 202
        -- upvalues:
        --  [1] arg14 (copy)

        while true do
            arg14:_UpdateLightingChange()
            arg14:_UpdateLadderGuide()
            wait(1)
        end
    end)
end

function t._VerifyFlashingRedEnemiesConnection(arg15) -- line: 211
    -- upvalues:
    --  [1] RunService (copy)

    if arg15._flashing_red_enemies_connection then
        arg15._flashing_red_enemies_connection:Disconnect()
        arg15._flashing_red_enemies_connection = nil
    end

    if arg15._destroyed or not arg15.ClientDuel:Get("IsSpectating") then
        return
    end

    arg15._flashing_red_enemies_connection = RunService.RenderStepped:Connect(function() -- line: 221
        -- upvalues:
        --  [1] arg15 (copy)

        local maximum = math.max(0, (math.sin(3.141592653589793 * tick())))
        local _ = 3.141592653589793 * tick()

        for key_5, val_3 in pairs(arg15._active_enemy_humanoids) do
            if not (tick() < val_3.StartFlashingRed) then
                if not val_3.Highlight then
                    val_3.Highlight = Instance.new("Highlight")
                    val_3.Highlight.FillColor = Color3.fromRGB(255, 0, 0)
                    val_3.Highlight.OutlineColor = Color3.fromRGB(255, 0, 0)
                    val_3.Highlight.Adornee = key_5.Parent
                    val_3.Highlight.Name = "FlashingRed"
                    val_3.Highlight.Parent = key_5
                end

                val_3.Highlight.OutlineTransparency = maximum * 1 + 0
                val_3.Highlight.FillTransparency = maximum * 0.125 + 0.875
            end
        end
    end)
end

function t._Init(arg16) -- line: 244
    arg16._floors_folder.ChildAdded:Connect(function(child_3: Instance) -- line: 245
        -- upvalues:
        --  [1] arg16 (copy)

        arg16:_FloorAdded(child_3)
    end)
    local Connections = arg16._connections
    local IsSpectating = arg16.ClientDuel:GetDataChangedSignal("IsSpectating")
    table.insert(Connections, IsSpectating:Connect(function() -- line: 249
        -- upvalues:
        --  [1] arg16 (copy)

        task.spawn(arg16._VerifySpectatingThread, arg16)
        arg16:_VerifyFlashingRedEnemiesConnection()
    end))
    local v18 = pairs
    local _ = IsSpectating:Connect(function() -- line: 249
        -- upvalues:
        --  [1] arg16 (copy)

        task.spawn(arg16._VerifySpectatingThread, arg16)
        arg16:_VerifyFlashingRedEnemiesConnection()
    end)

    for _, child_2 in v18(arg16._floors_folder:GetChildren()) do
        task.spawn(arg16._FloorAdded, arg16, child_2)
    end

    arg16:_Setup()
    arg16:_VerifyFlashingRedEnemiesConnection()
    task.spawn(arg16._VerifySpectatingThread, arg16)
end

return t
