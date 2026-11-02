local DuelLibrary_m = require(game:GetService("ReplicatedStorage").Modules.DuelLibrary)
local t = { "rbxassetid://121789380697435", "rbxassetid://131598663318488" }
local t_1 = {}
t_1.__index = t_1

function t_1.new(arg1) -- line: 14
    -- upvalues:
    --  [1] t_1 (copy)

    local t_2 = setmetatable({}, t_1)
    t_2.ClientDueler = arg1
    t_2._connections = {}
    t_2._honcho_highlight = nil
    t_2._bodyguard_highlight = nil
    t_2._hide_honcho_highlight_until = 0
    t_2._aura_sound = nil
    t_2:_Init()

    return t_2
end

function t_1.Destroy(arg2) -- line: 34
    for _, val in pairs(arg2._connections) do
        val:Disconnect()
    end

    if arg2._honcho_highlight then
        arg2._honcho_highlight:Destroy()
        arg2._honcho_highlight = nil
    end

    if arg2._bodyguard_highlight then
        arg2._bodyguard_highlight:Destroy()
        arg2._bodyguard_highlight = nil
    end

    if arg2._aura_sound then
        arg2._aura_sound:Destroy()
        arg2._aura_sound = nil
    end
end

function t_1._UpdateBodyguardHighlight(arg3) -- line: 59
    if arg3._bodyguard_highlight then
        arg3._bodyguard_highlight:Destroy()
        arg3._bodyguard_highlight = nil
    end

    if
        not arg3.ClientDueler.ClientDuel:Get("IsSpectating")
        or arg3.ClientDueler:Get("IsHeadHoncho") ~= false
        or not arg3.ClientDueler.ClientFighter
        or arg3.ClientDueler.ClientFighter:Get("IsSpectating")
        or not arg3.ClientDueler.ClientFighter.Entity
    then
        return
    end

    if
        not arg3.ClientDueler.ClientDuel.LocalDueler
        or arg3.ClientDueler.ClientDuel.LocalDueler:Get("IsHeadHoncho") ~= true
        or arg3.ClientDueler.ClientDuel.LocalDueler:Get("TeamID") == arg3.ClientDueler:Get("TeamID")
    then
        return
    end

    local Model = arg3.ClientDueler.ClientFighter.Entity.Model
    arg3._bodyguard_highlight = Instance.new("Highlight")
    arg3._bodyguard_highlight.FillTransparency = 1
    arg3._bodyguard_highlight.OutlineColor = Color3.fromRGB(255, 50, 50)
    arg3._bodyguard_highlight.OutlineTransparency = 0.5
    arg3._bodyguard_highlight.Adornee = Model
    arg3._bodyguard_highlight.Parent = Model
end

function t_1._UpdateHonchoHighlight(arg4) -- line: 87
    -- upvalues:
    --  [1] t (copy)
    --  [2] DuelLibrary_m (copy)

    if arg4._honcho_highlight then
        arg4._honcho_highlight:Destroy()
        arg4._honcho_highlight = nil
    end

    if arg4._aura_sound then
        arg4._aura_sound:Destroy()
        arg4._aura_sound = nil
    end

    if
        not arg4.ClientDueler.ClientDuel:Get("IsSpectating")
        or arg4.ClientDueler:Get("IsHeadHoncho") ~= true
        or not arg4.ClientDueler.ClientFighter
        or not arg4.ClientDueler.ClientFighter.Entity
    then
        return
    end

    if arg4.ClientDueler.ClientFighter:Get("IsSpectating") then
    end

    if not t[DuelLibrary_m.TeamsByID[arg4.ClientDueler:Get("TeamID")].TeamIndex] then
        local _ = t[1]
    end

    if arg4.ClientDueler.ClientFighter:Get("IsSpectating") then
        return
    end

    local v5 = DuelLibrary_m:GetTeamColor(arg4.ClientDueler:Get("TeamID"))
    local Model_1 = arg4.ClientDueler.ClientFighter.Entity.Model
    arg4._honcho_highlight = Instance.new("Highlight")
    local HonchoHighlight = arg4._honcho_highlight
    HonchoHighlight.DepthMode = tick() < arg4._hide_honcho_highlight_until and Enum.HighlightDepthMode.Occluded or Enum.HighlightDepthMode.AlwaysOnTop
    arg4._honcho_highlight.FillColor = v5
    arg4._honcho_highlight.OutlineColor = v5
    arg4._honcho_highlight.Adornee = Model_1
    arg4._honcho_highlight.Parent = Model_1
end

function t_1._SetupDamageTakenLogic(arg5) -- line: 128
    if not arg5.ClientDueler.ClientFighter then
        return
    end

    local Connections = arg5._connections
    local IsSpectating = arg5.ClientDueler.ClientFighter:GetDataChangedSignal("IsSpectating")
    table.insert(Connections, IsSpectating:Connect(function(...) -- line: 133
        -- upvalues:
        --  [1] arg5 (copy)

        arg5:_UpdateHonchoHighlight()
        arg5:_UpdateBodyguardHighlight()
    end))
    local v7 = nil
    table.insert(arg5._connections, arg5.ClientDueler.ClientFighter.HealthChanged:Connect(function(
        ...
    ) -- line: 140
        -- upvalues:
        --  [1] arg5 (copy)
        --  [2] v7 (ref)

        local v8 = arg5.ClientDueler.ClientFighter:GetHealth()

        if v7 and v8 < v7 then
            arg5._hide_honcho_highlight_until = tick() + 5
            arg5:_UpdateHonchoHighlight()
            task.delay(5, arg5._UpdateHonchoHighlight, arg5)
        end

        v7 = arg5.ClientDueler.ClientFighter:GetHealth()
    end))
end

function t_1._Init(arg6) -- line: 153
    local Connections_2 = arg6._connections
    local IsSpectating_1 = arg6.ClientDueler.ClientDuel:GetDataChangedSignal("IsSpectating")
    table.insert(Connections_2, IsSpectating_1:Connect(function() -- line: 154
        -- upvalues:
        --  [1] arg6 (copy)

        arg6:_UpdateHonchoHighlight()
        arg6:_UpdateBodyguardHighlight()
    end))
    arg6.ClientDueler:GetDataChangedSignal("IsHeadHoncho"):Connect(function() -- line: 159
        -- upvalues:
        --  [1] arg6 (copy)

        arg6:_UpdateHonchoHighlight()
        arg6:_UpdateBodyguardHighlight()
    end)
    arg6.ClientDueler:GetDataChangedSignal("TeamID"):Connect(function() -- line: 164
        -- upvalues:
        --  [1] arg6 (copy)

        arg6:_UpdateHonchoHighlight()
        arg6:_UpdateBodyguardHighlight()
    end)
    arg6.ClientDueler.EntityAdded:Connect(function() -- line: 169
        -- upvalues:
        --  [1] arg6 (copy)

        arg6:_UpdateHonchoHighlight()
        arg6:_UpdateBodyguardHighlight()
    end)
    arg6:_SetupDamageTakenLogic()
    arg6:_UpdateHonchoHighlight()
    arg6:_UpdateBodyguardHighlight()
end

return t_1
