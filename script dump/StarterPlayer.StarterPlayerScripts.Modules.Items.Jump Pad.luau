local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local GameplayUtility_m = require(ReplicatedStorage.Modules.GameplayUtility)
local _ = require(ReplicatedStorage.Modules.Utility)
local _ = require(Players.LocalPlayer.PlayerScripts.Controllers.WrapController)
local JumpPads_m = require(Players.LocalPlayer.PlayerScripts.Modules.GameComponents.JumpPads)
local Custom_m = require(Players.LocalPlayer.PlayerScripts.Modules.ItemTypes.Custom)
local t = setmetatable({}, Custom_m)
t.__index = t

function t.new(...) -- line: 14
    -- upvalues:
    --  [1] Custom_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(Custom_m.new(...), t)
    t_1._use_cooldown = 0
    t_1._preview_connection = nil
    t_1._preview_model = nil
    t_1:_Init()

    return t_1
end

function t.GetAutoShootReactionTime(_) -- line: 30
    return nil
end

function t.CanQuickAttack(arg2) -- line: 34
    local v2 = false

    if tick() > arg2._use_cooldown then
        v2 = false

        if (arg2:Get("Ammo") or math.huge) > 0 then
            v2 = not arg2:IsEquipping()

            if v2 then
                v2 = arg2:_CanPlace()
            end
        end
    end

    return v2
end

function t.StartShooting(arg3, arg4) -- line: 38
    if
        not arg4
        and (tick() < arg3._use_cooldown or (arg3:Get("Ammo") or math.huge) <= 0 or arg3:IsEquipping() or not arg3:_CanPlace())
    then
        return false
    end

    arg3._use_cooldown = tick() + arg3.Info.Cooldown
    arg3:CooldownEffect("rbxassetid://17156089790", arg3.Info.Cooldown, "Use")
    arg3.ViewModel:StopAnimation("Inspect")
    arg3.ViewModel:PlayAnimation("Use", 0.5)

    return true, "StartShooting", (arg3.ClientFighter:GetCameraData())
end

function t.Equip(arg5, ...) -- line: 53
    -- upvalues:
    --  [1] Custom_m (copy)

    Custom_m.Equip(arg5, ...)
    arg5:_StartPlacementPreview()
end

function t.Unequip(arg6, ...) -- line: 58
    -- upvalues:
    --  [1] Custom_m (copy)

    arg6:_StopPlacementPreview()
    Custom_m.Unequip(arg6, ...)
end

function t.Destroy(arg7) -- line: 63
    -- upvalues:
    --  [1] Custom_m (copy)

    arg7:_StopPlacementPreview()
    Custom_m.Destroy(arg7)
end

function t._GetPlacementData(arg8) -- line: 72
    -- upvalues:
    --  [1] GameplayUtility_m (copy)

    local v3 = arg8.ClientFighter:GetCameraData(nil, nil, true)
    local v9, v10 = GameplayUtility_m:GetJumpPadPlacement(
        arg8.ClientFighter:Get("EnvironmentID"),
        arg8.Info.MaxReach,
        v3[utf8.char(0)],
        v3[utf8.char(1)],
        v3[utf8.char(2)],
        v3[utf8.char(3)]
    )

    return v9, v10
end

function t._CanPlace(arg9) -- line: 79
    local v11, v12 = arg9:_GetPlacementData()

    return v11.Instance and v12, v11, v12
end

function t._StopPlacementPreview(arg10) -- line: 86
    if arg10._preview_connection then
        arg10._preview_connection:Disconnect()
        arg10._preview_connection = nil
    end

    if arg10._preview_model then
        arg10._preview_model:Destroy()
        arg10._preview_model = nil
    end
end

function t._StartPlacementPreview(arg11) -- line: 98
    -- upvalues:
    --  [1] JumpPads_m (copy)
    --  [2] RunService (copy)

    arg11:_StopPlacementPreview()

    if not arg11.ClientFighter.IsLocalPlayer or not arg11.ClientFighter:Get("IsSpectating") then
        return
    end

    local v13 = JumpPads_m:CreateJumpPadVisual(arg11.ViewModel.Name, arg11.Info.HitboxSize)

    for _, descendant in pairs(v13:GetDescendants()) do
        if descendant:IsA("BasePart") then
            descendant.Material = Enum.Material.ForceField
            descendant.Color = Color3.fromRGB(0, 200, 255)
            descendant.CastShadow = false
        end
    end

    local function update() -- line: 120
        -- upvalues:
        --  [1] arg11 (copy)
        --  [2] v13 (copy)

        if not (tick() > arg11._use_cooldown) or not ((arg11:Get("Ammo") or math.huge) > 0) then
            v13.Parent = nil

            return
        end

        local _, _, v17 = arg11:_CanPlace()

        if not arg11:_CanPlace() then
            v13.Parent = nil

            return
        end

        v13.Parent = workspace
        v13:PivotTo(v17)
    end

    arg11._preview_connection = RunService.RenderStepped:Connect(update)
    update()
    arg11._preview_model = v13
end

function t._Init(arg12) -- line: 143
    local Connections = arg12._connections
    local IsSpectating = arg12.ClientFighter:GetDataChangedSignal("IsSpectating")
    table.insert(Connections, IsSpectating:Connect(function() -- line: 144
        -- upvalues:
        --  [1] arg12 (copy)

        if arg12.ClientFighter:Get("IsSpectating") then
            if arg12.IsEquipped then
                arg12:_StartPlacementPreview()

                return
            end
        else
            arg12:_StopPlacementPreview()
        end
    end))
end

return t
