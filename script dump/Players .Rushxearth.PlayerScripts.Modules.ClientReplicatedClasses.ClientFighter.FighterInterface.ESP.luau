local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local CONSTANTS_m = require(ReplicatedStorage.Modules.CONSTANTS)
local UILibrary_m = require(Players.LocalPlayer.PlayerScripts.Modules.UILibrary)
local ESPGui = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("ESPGui")
local ESPSlot = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("ESPSlot")
local t = {}
t.__index = t

function t.new(arg1) -- line: 13
    -- upvalues:
    --  [1] t (copy)

    local t_1 = setmetatable({}, t)
    t_1.FighterInterface = arg1
    t_1._esp_connections = {}
    t_1._esp_slots = {}
    t_1._esp_gui = nil
    t_1._esp_gui_frame = nil
    t_1._esp_gui_fov_frame = nil
    t_1:_Init()

    return t_1
end

function t.Refresh(arg2) -- line: 33
    -- upvalues:
    --  [1] Players (copy)
    --  [2] ESPSlot (copy)
    --  [3] UILibrary_m (copy)
    --  [4] CONSTANTS_m (copy)

    arg2:Clear()

    if not arg2.FighterInterface.ClientFighter:Get("CheaterMode") then
        return
    end

    arg2._esp_gui = arg2:_CreateGui()
    arg2._esp_gui_frame = arg2._esp_gui:WaitForChild("Frame")
    arg2._esp_gui_fov_frame = arg2._esp_gui_frame:WaitForChild("FOV")

    local function clear_player(arg3) -- line: 44
        -- upvalues:
        --  [1] arg2 (copy)

        if arg2._esp_slots[arg3] then
            arg2._esp_slots[arg3].Slot:Destroy()
            arg2._esp_slots[arg3] = nil
        end
    end

    table.insert(arg2._esp_connections, Players.PlayerRemoving:Connect(clear_player))

    local function check_player(arg4) -- line: 53
        -- upvalues:
        --  [1] arg2 (copy)
        --  [2] Players (ref)
        --  [3] ESPSlot (ref)
        --  [4] UILibrary_m (ref)
        --  [5] CONSTANTS_m (ref)

        if arg2._esp_slots[arg4] then
            arg2._esp_slots[arg4].Slot:Destroy()
            arg2._esp_slots[arg4] = nil
        end

        local TeamID = Players.LocalPlayer:GetAttribute("TeamID")

        if
            arg4 == Players.LocalPlayer
            or Players.LocalPlayer:GetAttribute("TeamID") and TeamID == arg4:GetAttribute("TeamID")
        then
            return
        end

        local Character = arg4.Character
        local v1 = Character

        if v1 then
            v1 = Character:FindFirstChild("HumanoidRootPart")
        end

        local v2 = Character

        if v2 then
            v2 = Character:FindFirstChild("Humanoid")
        end

        if not v1 or not v2 or v2.Health <= 0 then
            return
        end

        local v3 = ESPSlot:Clone()
        v3.Parent = arg2._esp_gui_frame
        local Line = v3.Line

        local function update(_) -- line: 73
            -- upvalues:
            --  [1] v1 (copy)
            --  [2] UILibrary_m (ref)
            --  [3] arg2 (ref)
            --  [4] v3 (copy)
            --  [5] CONSTANTS_m (ref)
            --  [6] v2 (copy)
            --  [7] Line (copy)

            local screenPoint, _ = workspace.CurrentCamera:WorldToScreenPoint(v1.Position)
            local v6 = UILibrary_m:ScreenPointToPosition(
                Vector2.new(screenPoint.X, screenPoint.Y),
                arg2._esp_gui_frame.AbsolutePosition
            )
            local v5 = false
            local v7 = v3

            if screenPoint.Z >= 0 then
                v5 = screenPoint.Z < CONSTANTS_m.RENDER_DISTANCE and v2.Health > 0
            end

            v7.Visible = v5

            if not v3.Visible then
                return
            end

            local v8 = arg2._esp_gui_fov_frame.AbsolutePosition + arg2._esp_gui_fov_frame.AbsoluteSize / 2
            local squareRoot = math.sqrt((v8.X - screenPoint.X) ^ 2 + (v8.Y - screenPoint.Y) ^ 2)
            local v9 = 4.71238898038469 - math.atan2(screenPoint.X - v8.X, screenPoint.Y - v8.Y)
            v3.Position = UDim2.new(0, v6.X, 0, v6.Y)
            Line.Size = UDim2.new(0, squareRoot, 0, 0)
            Line.Position = UDim2.new(
                0.5,
                math.cos(v9) * squareRoot / 2,
                0.5,
                math.sin(v9) * squareRoot / 2
            )
            Line.Rotation = math.deg(v9)
            local screenPoint_1 = workspace.CurrentCamera:WorldToScreenPoint(
                v1.Position + Vector3.new(0, 2, 0)
            )
            local absoluteValue = math.abs(
                screenPoint_1.Y - workspace.CurrentCamera:WorldToScreenPoint(
                    v1.Position - Vector3.new(0, 3, 0)
                ).Y
            )
            v3.Size = UDim2.new(0, absoluteValue * 0.8, 0, absoluteValue)
        end

        arg2._esp_slots[arg4] = { Slot = v3, Update = update }
    end

    local function player_added(arg6) -- line: 105
        -- upvalues:
        --  [1] check_player (copy)
        --  [2] arg2 (copy)

        local function check() -- line: 106
            -- upvalues:
            --  [1] arg6 (copy)
            --  [2] check_player (ref)

            arg6:WaitForChild("HumanoidRootPart", 3)
            check_player(arg6)
        end

        table.insert(arg2._esp_connections, arg6:GetAttributeChangedSignal("TeamID"):Connect(check))
        table.insert(arg2._esp_connections, arg6.CharacterAdded:Connect(check))
        task.defer(check)
    end

    table.insert(arg2._esp_connections, Players.PlayerAdded:Connect(player_added))
    local v18 = pairs
    local _ = Players.PlayerAdded:Connect(player_added)

    for _, val in v18(Players:GetPlayers()) do
        task.defer(player_added, val)
    end

    local function check_all_players() -- line: 122
        -- upvalues:
        --  [1] Players (ref)
        --  [2] check_player (copy)

        for _, val_1 in pairs(Players:GetPlayers()) do
            check_player(val_1)
        end
    end

    table.insert(
        arg2._esp_connections,
        Players.LocalPlayer:GetAttributeChangedSignal("TeamID"):Connect(check_all_players)
    )
    arg2._esp_gui.Parent = Players.LocalPlayer.PlayerGui
end

function t.Update(arg7, arg8, _) -- line: 133
    -- upvalues:
    --  [1] UILibrary_m (copy)
    --  [2] CONSTANTS_m (copy)

    if not arg7._esp_gui then
        return
    end

    local v21 = UILibrary_m:ScreenPointToPosition(
        arg7.FighterInterface.ClientFighter:GetMouseLocation(),
        arg7._esp_gui_frame.AbsolutePosition
    )
    arg7._esp_gui_fov_frame.Position = UDim2.new(0, v21.X, 0, v21.Y)

    for _, val_2 in pairs(arg7._esp_slots) do
        if CONSTANTS_m.IS_STUDIO then
            val_2.Update(arg8)
        else
            pcall(val_2.Update, arg8)
        end
    end
end

function t.Clear(arg10) -- line: 151
    for _, val_3 in pairs(arg10._esp_connections) do
        val_3:Disconnect()
    end

    for _, val_4 in pairs(arg10._esp_slots) do
        val_4.Slot:Destroy()
    end

    arg10._esp_connections = {}
    arg10._esp_slots = {}

    if arg10._esp_gui then
        arg10._esp_gui:Destroy()
        arg10._esp_gui = nil
    end
end

function t.Destroy(arg11) -- line: 169
    arg11:Clear()
end

function t._CreateGui(arg12) -- line: 177
    -- upvalues:
    --  [1] ESPGui (copy)

    local v22 = ESPGui:Clone()

    local function update_visible() -- line: 180
        -- upvalues:
        --  [1] v22 (copy)
        --  [2] arg12 (copy)

        local v23 = arg12.FighterInterface.Frame.Visible
        local v24 = v22
        v23 = v23 and arg12.FighterInterface.Frame.Parent
        v24.Enabled = v23
    end

    table.insert(
        arg12._esp_connections,
        arg12.FighterInterface.Frame:GetPropertyChangedSignal("Visible"):Connect(update_visible)
    )
    local v25 = arg12.FighterInterface.Frame.Visible

    if v25 then
        v25 = arg12.FighterInterface.Frame.Parent
    end

    v22.Enabled = v25

    function v25() --[[ ancestry_changed ]] -- line: 187
        -- upvalues:
        --  [1] arg12 (copy)
        --  [2] update_visible (copy)
        --  [3] v22 (copy)

        if not arg12.FighterInterface.Frame.Parent then
            return
        end

        table.insert(
            arg12._esp_connections,
            arg12.FighterInterface.Frame.Parent:GetPropertyChangedSignal("Visible"):Connect(
                update_visible
            )
        )
        local v26 = arg12.FighterInterface.Frame.Visible
        local v27 = v22

        if v26 then
            v26 = arg12.FighterInterface.Frame.Parent
        end

        v27.Enabled = v26
    end

    table.insert(arg12._esp_connections, arg12.FighterInterface.Frame.AncestryChanged:Connect(v25))

    if not arg12.FighterInterface.Frame.Parent then
        return v22
    end

    table.insert(
        arg12._esp_connections,
        arg12.FighterInterface.Frame.Parent:GetPropertyChangedSignal("Visible"):Connect(
            update_visible
        )
    )
    local v28 = arg12.FighterInterface.Frame.Visible

    if v28 then
        v28 = arg12.FighterInterface.Frame.Parent
    end

    v22.Enabled = v28

    return v22
end

function t._Init(_) -- line: 202
end

return t
