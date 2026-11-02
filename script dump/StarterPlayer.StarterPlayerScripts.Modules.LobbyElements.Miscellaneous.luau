local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local SeasonLibrary_m = require(ReplicatedStorage.Modules.SeasonLibrary)
local LobbyElement_m = require(Players.LocalPlayer.PlayerScripts.Modules.LobbyElement)
local t = setmetatable({}, LobbyElement_m)
t.__index = t

function t._new(...) -- line: 11
    -- upvalues:
    --  [1] LobbyElement_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(LobbyElement_m.new(...), t)
    t_1:_Init()

    return t_1
end

function t.Update(arg1, _) -- line: 23
    -- upvalues:
    --  [1] CollectionService (copy)

    local v2 = math.sin(tick() * 0.25) ^ 30 * 1
    local v3 = tick() * 0.1 % 6.283185307179586
    local _ = Vector3.new(0, v2, 0)
    local _ = CFrame.Angles(0, v3, 0)
    local v6 = math.sin(tick() * 0.75) ^ 30 * 1
    local v7 = tick() * -0.2 % 6.283185307179586
    local vec3_1 = Vector3.new(0, v6, 0)
    local cframe_1 = CFrame.Angles(0, v7, 0)

    for _, val in pairs(CollectionService:GetTagged("LobbyFloatingDisplay")) do
        if val:IsDescendantOf(workspace) then
            local v11 = arg1:_GetOriginalPivot(val)
            local v12 = val:GetAttribute("GlobalSpin") and v11.Rotation:Inverse() or CFrame.identity
            v11 = val:GetAttribute("NoSpin") and CFrame.identity or cframe_1
            val:PivotTo(arg1:_GetOriginalPivot(val) * v12 * v11 * v12:Inverse() + vec3_1)
        end
    end

    for _, val_1 in pairs(CollectionService:GetTagged("LobbyRing")) do
        local v16 = val_1:GetAttribute("Multiplier") or 1
        local v17 = val_1:GetAttribute("IsGlobalSpace") or false
        local v18 = arg1:_GetOriginalPivot(val_1)
        local cframe_2 = CFrame.Angles(0, tick() * 0.1 * v16 % 6.283185307179586, 0)

        if v17 then
            val_1:PivotTo(CFrame.new(v18.Position) * cframe_2 * v18.Rotation)
        else
            val_1:PivotTo(v18 * cframe_2)
        end
    end

    for _, val_2 in pairs(CollectionService:GetTagged("LobbyHologramGift")) do
        val_2:PivotTo(arg1:_GetOriginalPivot(val_2) * cframe_1 + vec3_1)
    end

    for _, val_3 in pairs(CollectionService:GetTagged("LobbyHologramMobile")) do
        val_3.Earth:PivotTo(
            arg1:_GetOriginalPivot(val_3.Earth) * CFrame.Angles(
                0,
                tick() * 0.35 % 6.283185307179586,
                0
            )
        )
        val_3.Phone:PivotTo(
            arg1:_GetOriginalPivot(val_3.Phone) + Vector3.new(0, math.sin(tick() * 0.75) * 0.75, 0)
        )
        val_3.Tablet:PivotTo(
            arg1:_GetOriginalPivot(val_3.Tablet) + Vector3.new(0, math.cos(tick() * 0.375), 0)
        )
    end
end

function t._UpdateSeasonTexts(_) -- line: 79
    -- upvalues:
    --  [1] CollectionService (copy)
    --  [2] SeasonLibrary_m (copy)

    for _, val_4 in pairs(CollectionService:GetTagged("SeasonNameDisplay")) do
        val_4.Text = string.upper(SeasonLibrary_m.CurrentSeason.Name)
    end

    for _, val_5 in pairs(CollectionService:GetTagged("SeasonVersionDisplay")) do
        val_5.Text = "SEASON " .. SeasonLibrary_m.CurrentSeason.Version
    end
end

function t._Init(arg4) -- line: 89
    -- upvalues:
    --  [1] CollectionService (copy)

    CollectionService:GetInstanceAddedSignal("SeasonNameDisplay"):Connect(function() -- line: 90
        -- upvalues:
        --  [1] arg4 (copy)

        arg4:_UpdateSeasonTexts()
    end)
    CollectionService:GetInstanceAddedSignal("SeasonVersionDisplay"):Connect(function() -- line: 94
        -- upvalues:
        --  [1] arg4 (copy)

        arg4:_UpdateSeasonTexts()
    end)
    arg4:_UpdateSeasonTexts()
end

return t._new()
