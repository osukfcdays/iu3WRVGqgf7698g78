local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CONSTANTS_m = require(ReplicatedStorage.Modules.CONSTANTS)
local Finisher_m = require(ReplicatedStorage.Modules.Finisher)
local _ = require(ReplicatedStorage.Modules.Utility)
local t = setmetatable({}, Finisher_m)
t.__index = t

function t.new(...) -- line: 12
    -- upvalues:
    --  [1] Finisher_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(Finisher_m.new(...), t)
    t_1:_Init()

    return t_1
end

function t.PlayServer(arg1) -- line: 24
    -- upvalues:
    --  [1] CONSTANTS_m (copy)

    arg1:_AnchorModel(0, false)
    arg1:_Ragdoll()
    local t_2 = {}

    for _, val in pairs(arg1:_GetObjects()) do
        if val:IsA("BasePart") and val.Name ~= "Head" and val.Name ~= "UpperTorso" then
            table.insert(t_2, val)
        end
    end

    local v3 = t_2[math.random(#t_2)]

    if not v3 then
        return
    end

    arg1:CreateSound(
        "rbxassetid://130365736768706",
        1.25,
        1,
        nil,
        true,
        5
    )
    arg1:CreateSound(
        "rbxassetid://95957584341529",
        1.25,
        2 + 0.25 * math.random(),
        nil,
        true,
        5
    )
    local Attachment = Instance.new("Attachment")
    Attachment.Parent = v3
    table.insert(arg1._destroy_these, Attachment)

    for _ = 1, 3 do
        local v5 = Random.new():NextUnitVector() * Vector3.new(1, 0, 1)
        local v6 = script.Balloon:Clone()
        v6.Color = Color3.fromHSV(math.random(), 1, 1)
        v6.CFrame = v3.CFrame + Vector3.new(0, 4, 0) + v5 * 2
        v6.RopeConstraint.Attachment1 = Attachment
        v6.Parent = v3
        table.insert(arg1._destroy_these, v6)

        if CONSTANTS_m.IS_SERVER then
            v6:SetNetworkOwner(nil)
        end

        wait(0.1)
    end
end

function t._Init(_) -- line: 71
end

return t
