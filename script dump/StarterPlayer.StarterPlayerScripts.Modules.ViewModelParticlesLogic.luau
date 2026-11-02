local Utility_m = require(game:GetService("ReplicatedStorage").Modules.Utility)
local t = {}
t.__index = t

function t.new(arg1, arg2) -- line: 10
    -- upvalues:
    --  [1] t (copy)

    local t_1 = setmetatable({}, t)
    t_1.ClientViewModel = arg1
    t_1._tag = arg2 or "ArchParticles"
    t_1._effect_hash = 0
    t_1._particles = {}
    t_1:_Init()

    return t_1
end

function t.SetVisible(arg3, arg4) -- line: 28
    -- upvalues:
    --  [1] Utility_m (copy)

    for _, val in pairs(arg3._particles) do
        val.Enabled = arg4

        if val:IsA("ParticleEmitter") and not arg4 then
            val:Clear()
        end
    end

    if arg4 then
        Utility_m:PlayParticles(arg3._particles)
    end
end

function t.PlayEffect(arg5, arg6, arg7) -- line: 42
    arg5:CancelEffect()
    local EffectHash = arg5._effect_hash

    if arg6 > 0 then
        wait(arg6)

        if arg5._effect_hash ~= EffectHash then
            return
        end
    end

    arg5:SetVisible(false)

    if arg7 > 0 then
        wait(arg7)

        if arg5._effect_hash ~= EffectHash then
            return
        end
    end

    arg5:SetVisible(true)
end

function t.CancelEffect(arg8) -- line: 67
    arg8._effect_hash += 1
end

function t.Destroy(arg9) -- line: 71
    arg9:CancelEffect()
end

function t._Setup(arg10) -- line: 80
    for _, descendant in pairs(arg10.ClientViewModel.ItemModel:GetDescendants()) do
        if descendant:HasTag(arg10._tag) and descendant.Enabled then
            table.insert(arg10._particles, descendant)
        end
    end
end

function t._Init(arg11) -- line: 88
    arg11:_Setup()
end

return t
