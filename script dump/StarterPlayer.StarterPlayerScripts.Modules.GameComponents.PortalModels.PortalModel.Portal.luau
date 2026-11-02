local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local GameplayUtility_m = require(ReplicatedStorage.Modules.GameplayUtility)
local DuelLibrary_m = require(ReplicatedStorage.Modules.DuelLibrary)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local Spring_m = require(ReplicatedStorage.Modules.Spring)
local Signal_m = require(ReplicatedStorage.Modules.Signal)
local t = {}
local PortalKeybindGui = Players.LocalPlayer.PlayerScripts.UserInterface.PortalKeybindGui
local Portals = Players.LocalPlayer.PlayerScripts.Assets.Misc.Portals
t.__index = t

function t.new(arg1) -- line: 19
    -- upvalues:
    --  [1] t (copy)
    --  [2] Signal_m (copy)
    --  [3] PortalKeybindGui (copy)
    --  [4] Spring_m (copy)

    local t_1 = setmetatable({}, t)
    t_1.FinishedGrowing = Signal_m.new()
    t_1.Model = arg1
    t_1.Hitbox = t_1.Model:WaitForChild("Hitbox")
    t_1.PortalNum = tonumber(t_1.Model.Name)
    t_1.Visual = t_1:_GetPortalTemplate():Clone()
    t_1.BigVisual = t_1.Visual:WaitForChild("Big")
    t_1.SmallVisual = t_1.Visual:WaitForChild("Small")
    t_1.Gui = PortalKeybindGui:Clone()
    t_1._viewmodel_name = t_1.Model:GetAttribute("ViewModelName")
    t_1._owner_user_id = t_1.Model:GetAttribute("OwnerUserID")
    t_1._owner_team_id = t_1.Model:GetAttribute("OwnerTeamID")
    t_1._original_scale = t_1.Visual:GetScale()
    t_1._grow_start = nil
    t_1._spawn_delay = nil
    t_1._finished_growing = nil
    t_1._is_enabled = false
    t_1._established = false
    t_1._pivot_offset_spring = Spring_m.new(Vector3.new(0, 0, 0), 0.5, 25)
    t_1._opened_hotel_door = false
    t_1:_Init()

    return t_1
end

function t.IsGrown(arg2) -- line: 53
    return arg2._finished_growing
end

function t.GetTeleportCFrame(arg3) -- line: 57
    -- upvalues:
    --  [1] GameplayUtility_m (copy)
    --  [2] Players (copy)
    --  [3] Utility_m (copy)

    local v1 = arg3.Hitbox.CFrame
    local v2 = v1 * CFrame.new(0, 0, -4)
    local v5 = GameplayUtility_m:GetRaycastWhitelist(
        Players.LocalPlayer:GetAttribute("EnvironmentID")
    )
    local raycastResult = Utility_m:Raycast(
        v1.Position,
        v2.Position,
        4,
        v5,
        Enum.RaycastFilterType.Include
    )

    return CFrame.new(raycastResult.Position) * v2.Rotation
end

function t.UpdateVisuals(arg4, arg5, arg6) -- line: 66
    -- upvalues:
    --  [1] Utility_m (copy)

    task.defer(function() -- line: 67
        -- upvalues:
        --  [1] arg5 (copy)
        --  [2] arg4 (copy)
        --  [3] arg6 (copy)
        --  [4] Utility_m (ref)

        local v6 = arg5

        if v6 then
            v6 = arg4._finished_growing
        end

        local v7 = arg4
        v7:_SafeParent(arg4.BigVisual, if not v6 then nil else arg4.Visual)
        arg4:_SafeParent(arg4.SmallVisual, if v6 then nil else arg4.Visual)

        if v6 and not arg4._opened_hotel_door and arg4._viewmodel_name == "Hotel Bell" then
            arg4._opened_hotel_door = true
            task.defer(function() -- line: 76
                -- upvalues:
                --  [1] arg4 (ref)

                arg4.BigVisual.Screen.SurfaceGui.MainFrame:TweenSize(
                    UDim2.new(0.1, 0, 1, 0),
                    "Out",
                    "Quint",
                    0.5,
                    true
                )
            end)
        end

        if arg6 or v6 and not arg4._is_enabled and not arg4._established then
            arg4._established = true

            if arg4._viewmodel_name == "Hotel Bell" then
                task.delay(
                    0.1 + 0.1 * math.random(),
                    Utility_m.CreateSound,
                    Utility_m,
                    "rbxassetid://109072275653492",
                    1,
                    1.25 + 0.25 * math.random(),
                    arg4.Hitbox,
                    true,
                    10
                )
                Utility_m:CreateSound(
                    "rbxassetid://119325209237441",
                    0.5,
                    1 + 0.1 * math.random(),
                    arg4.Hitbox,
                    true,
                    10
                )
            else
                Utility_m:CreateSound(
                    "rbxassetid://119325209237441",
                    0.75,
                    1 + 0.1 * math.random(),
                    arg4.Hitbox,
                    true,
                    10
                )
            end
        end

        arg4._is_enabled = arg5

        if not arg4._is_enabled then
            arg4:_ScaleTo(1)
        end
    end)
end

function t.Update(arg7, arg8) -- line: 102
    arg7:_Pivot()

    if arg7._viewmodel_name == "Hotel Bell" then
        local Spin = arg7.BigVisual.Part.SurfaceGui1.CanvasGroup.Spin
        Spin.Rotation += arg8 * -90
        local Spin_1 = arg7.BigVisual.Part.SurfaceGui2.CanvasGroup.Spin
        Spin_1.Rotation += arg8 * -90
    end

    if not arg7._is_enabled or arg7._finished_growing then
        return
    end

    local v17

    if arg7._spawn_delay <= 0 then
        v17 = 1
    else
        local _ = arg7._finished_growing
        v17 = math.clamp((tick() - arg7._grow_start) / arg7._spawn_delay, 0, 1)
    end

    local v18 = if not (v17 < 1) then 1 else 3
    arg7:_ScaleTo((v17 * 0.75 + 0.25) * v18)

    if v17 < 1 then
        return
    end

    arg7._finished_growing = true
    arg7.FinishedGrowing:Fire()
    local v20 = arg7._spawn_delay <= 0.01 and true

    if not v20 then
        arg7._pivot_offset_spring.Value = Vector3.new(0, 0, -3)
    end

    arg7:UpdateVisuals(arg7._is_enabled, not v20)
end

function t.Destroy(arg9) -- line: 135
    pcall(function() -- line: 136
        -- upvalues:
        --  [1] arg9 (copy)

        arg9.Model:Destroy()
    end)
    pcall(function() -- line: 140
        -- upvalues:
        --  [1] arg9 (copy)

        arg9.Visual:Destroy()
    end)
    arg9.FinishedGrowing:Destroy()
end

function t._GetPortalTemplate(arg10) -- line: 151
    -- upvalues:
    --  [1] Portals (copy)

    local ViewModelName = arg10.Model:GetAttribute("ViewModelName")

    return (Portals:FindFirstChild(ViewModelName) or Portals.Default)[arg10.PortalNum]
end

function t._Pivot(arg11) -- line: 158
    arg11.Visual:PivotTo(arg11.Model:GetPivot() * CFrame.new(arg11._pivot_offset_spring.Value))
end

function t._SafeParent(_, arg13, arg14) -- line: 162
    pcall(function() -- line: 163
        -- upvalues:
        --  [1] arg13 (copy)
        --  [2] arg14 (copy)

        arg13.Parent = arg14
    end)
end

function t._ScaleTo(arg15, arg16) -- line: 168
    local Parent = arg15.BigVisual.Parent
    local Parent_1 = arg15.SmallVisual.Parent
    arg15:_SafeParent(arg15.BigVisual, arg15.Visual)
    arg15:_SafeParent(arg15.SmallVisual, arg15.Visual)
    arg15.Visual:ScaleTo(arg15._original_scale * arg16)
    arg15:_SafeParent(arg15.BigVisual, Parent)
    arg15:_SafeParent(arg15.SmallVisual, Parent_1)
end

function t._InitializeGrowing(arg17) -- line: 181
    arg17._grow_start = tick()
    arg17._spawn_delay = arg17.Model:GetAttribute("SpawnDelay") or 0
    arg17._finished_growing = false
    arg17:UpdateVisuals(arg17._is_enabled)
end

function t._Setup(arg18) -- line: 188
    -- upvalues:
    --  [1] DuelLibrary_m (copy)
    --  [2] Players (copy)
    --  [3] Utility_m (copy)

    local PadColor = DuelLibrary_m:GetTeamColor(arg18._owner_team_id, nil, "PadColor")

    for _, descendant in pairs(arg18.Visual:GetDescendants()) do
        if descendant:HasTag("ColorThis") then
            local v25 = descendant:GetAttribute("ColorThisMultiplier") or 1
            local color = Color3.new(PadColor.R * v25, PadColor.G * v25, PadColor.B * v25)

            if descendant:IsA("BasePart") then
                descendant.Color = color
            elseif descendant:IsA("Frame") then
                descendant.BackgroundColor3 = color
            elseif descendant:IsA("ImageLabel") then
                descendant.ImageColor3 = color
            end
        end

        if descendant:IsA("BasePart") then
            descendant.CanCollide = false
            descendant.CanQuery = false
            descendant.CanTouch = false
        end
    end

    arg18.Gui.Parent = arg18.Visual.Primary

    if arg18._owner_user_id == Players.LocalPlayer.UserId then
        arg18.Gui.CanvasGroup.Keybind:SetAttribute(
            "InputName",
            if arg18.PortalNum ~= 1 then "Aim" else "Shoot"
        )
        arg18.Gui.CanvasGroup.Keybind:AddTag("UIKeybindContainer")
    end

    arg18.Visual.PrimaryPart = arg18.Visual.Primary
    arg18.BigVisual.WorldPivot = arg18.Visual.WorldPivot
    arg18.SmallVisual.WorldPivot = arg18.Visual.WorldPivot
    arg18.Visual.Parent = arg18.Model
    Utility_m:CreateSound(
        "rbxassetid://114274252176516",
        0.5,
        0.95 + 0.1 * math.random(),
        arg18.Visual.Primary,
        true
    ).Looped = true
end

function t._Init(arg19) -- line: 228
    arg19.Model:GetAttributeChangedSignal("SpawnDelay"):Connect(function() -- line: 229
        -- upvalues:
        --  [1] arg19 (copy)

        arg19:_InitializeGrowing()
    end)
    arg19.Model:GetAttributeChangedSignal("RegrowHash"):Connect(function() -- line: 233
        -- upvalues:
        --  [1] arg19 (copy)

        arg19:_InitializeGrowing()
    end)
    arg19:_Setup()
    arg19:_Pivot()
    arg19:_InitializeGrowing()
end

return t
