local CollectionService = game:GetService("CollectionService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local FighterController_m = require(Players.LocalPlayer.PlayerScripts.Controllers.FighterController)
local WrapController_m = require(Players.LocalPlayer.PlayerScripts.Controllers.WrapController)
local t = {}
t.__index = t

function t._new() -- line: 11
    -- upvalues:
    --  [1] t (copy)

    local t_1 = setmetatable({}, t)
    t_1:_Init()

    return t_1
end

function t._GetItem(_, arg2) -- line: 29
    -- upvalues:
    --  [1] FighterController_m (copy)

    for _, val in pairs(FighterController_m.Objects) do
        local v1 = val:GetItem(arg2)

        if v1 then
            return v1
        end
    end
end

function t._SetupWrap(_, arg4, arg5) -- line: 39
    -- upvalues:
    --  [1] WrapController_m (copy)

    local v2 = nil

    local _ = function() --[[ update_wrap ]] -- line: 42
        -- upvalues:
        --  [1] WrapController_m (ref)
        --  [2] v2 (ref)
        --  [3] arg4 (copy)
        --  [4] arg5 (copy)

        WrapController_m:ResetWrap(v2)
        v2 = WrapController_m:RecordOriginalWrapProperties(arg4)
        WrapController_m:ApplyWrap(v2, arg5:GetWrap(), true)
    end

    arg4.DescendantAdded:Connect(function(descendant: Instance) -- line: 48
        -- upvalues:
        --  [1] WrapController_m (ref)
        --  [2] v2 (ref)
        --  [3] arg4 (copy)
        --  [4] arg5 (copy)

        if descendant:HasTag("Wrappable") then
            WrapController_m:ResetWrap(v2)
            v2 = WrapController_m:RecordOriginalWrapProperties(arg4)
            WrapController_m:ApplyWrap(v2, arg5:GetWrap(), true)
        end
    end)
    WrapController_m:ResetWrap(v2)
    v2 = WrapController_m:RecordOriginalWrapProperties(arg4)
    local v9 = WrapController_m
    local v10 = arg5:GetWrap()
    v9:ApplyWrap(v2, v10, true)
end

function t._ObjectAdded(arg7, arg8) -- line: 57
    -- upvalues:
    --  [1] Players (copy)
    --  [2] FighterController_m (copy)
    --  [3] RunService (copy)

    arg8:WaitForChild("Hitbox")
    local ObjectID = arg8:GetAttribute("ObjectID")
    local HitboxDelay = arg8:GetAttribute("HitboxDelay")
    local PlacedByUserID = arg8:GetAttribute("PlacedByUserID")
    local v11 = arg8:GetAttribute("TeamID")
    local v13 = arg7:_GetItem(ObjectID)

    if v13 then
        v13.ViewModel:PlayHideMineSound(arg8)
        arg7:_SetupWrap(arg8, v13)
    end

    v13 = true

    if PlacedByUserID ~= Players.LocalPlayer.UserId then
        v13 = FighterController_m.LocalFighter

        if v13 then
            v13 = FighterController_m.LocalFighter:Get("TeamID")

            if v13 then
                v13 = if FighterController_m.LocalFighter:Get("TeamID") ~= v11 then false else true
            end
        end
    end

    v11 = if not v13 then 1 else 0.5
    local v14 = HitboxDelay / 2
    local v15 = 0
    local t_2 = {}

    local _ = function(arg9) --[[ update_transparency ]] -- line: 82
        -- upvalues:
        --  [1] t_2 (copy)
        --  [2] v13 (copy)
        --  [3] v11 (copy)
        --  [4] v15 (ref)

        arg9.LocalTransparencyModifier = if not t_2[arg9] then v11 * v15 else if v13 then v11 * v15 else 1
    end

    local _ = function(arg10) --[[ set ]] -- line: 88
        -- upvalues:
        --  [1] v15 (ref)
        --  [2] t_2 (copy)
        --  [3] v13 (copy)
        --  [4] v11 (copy)

        v15 = arg10

        for key_1, _ in pairs(t_2) do
            local v17 = if not t_2[key_1] then v11 * v15 else if v13 then v11 * v15 else 1
            key_1.LocalTransparencyModifier = v17
        end
    end

    local function add_object(arg11) -- line: 96
        -- upvalues:
        --  [1] t_2 (copy)
        --  [2] v13 (copy)
        --  [3] v11 (copy)
        --  [4] v15 (ref)

        if
            arg11:IsA("BasePart")
            or arg11:IsA("Decal")
            or arg11:IsA("Texture")
            or arg11:IsA("ParticleEmitter")
            or arg11:IsA("Trail")
            or arg11:IsA("Beam")
        then
            t_2[arg11] = arg11:HasTag("DontShowToEnemies") or false
            arg11.LocalTransparencyModifier = if t_2[arg11] and not v13 then 1 else v11 * v15
        end
    end

    arg8.DescendantAdded:Connect(add_object)

    for _, descendant_1 in pairs(arg8:GetDescendants()) do
        add_object(descendant_1)
    end

    v15 = 0
    local v21

    for key_3, _ in pairs(t_2) do
        v21 = if not t_2[key_3] then v11 * v15 else if v13 then v11 * v15 else 1
        key_3.LocalTransparencyModifier = v21
    end

    wait(HitboxDelay / 2)
    local now = tick()

    while true do
        if not arg8:IsDescendantOf(workspace) then
            break
        end

        if not (tick() < now + v14) then
            break
        end

        v15 = math.clamp((tick() - now) / v14, 0, 1)

        for key_4, _ in pairs(t_2) do
            local v22 = if not t_2[key_4] then v11 * v15 else if v13 then v11 * v15 else 1
            key_4.LocalTransparencyModifier = v22
        end

        RunService.RenderStepped:Wait()
    end

    v15 = 1

    for key_5, _ in pairs(t_2) do
        v21 = if not t_2[key_5] then v11 * v15 else if v13 then v11 * v15 else 1
        key_5.LocalTransparencyModifier = v21
    end
end

function t._Init(arg12) -- line: 124
    -- upvalues:
    --  [1] CollectionService (copy)

    CollectionService:GetInstanceAddedSignal("SubspaceTripmine"):Connect(function(arg13) -- line: 125
        -- upvalues:
        --  [1] arg12 (copy)

        arg12:_ObjectAdded(arg13)
    end)

    for _, val_5 in pairs(CollectionService:GetTagged("SubspaceTripmine")) do
        task.defer(arg12._ObjectAdded, arg12, val_5)
    end
end

return t._new()
