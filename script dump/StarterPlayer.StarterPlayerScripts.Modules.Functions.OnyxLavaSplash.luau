local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local BetterDebris_m = require(ReplicatedStorage.Modules.BetterDebris)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local OnyxLavaSplash = Players.LocalPlayer.PlayerScripts.Assets.Misc:WaitForChild("OnyxLavaSplash")

return function(arg1, arg2, arg3) -- line: 9
    -- upvalues:
    --  [1] Utility_m (copy)
    --  [2] OnyxLavaSplash (copy)
    --  [3] BetterDebris_m (copy)

    local raycastResult = Utility_m:Raycast(
        arg2,
        arg2 - Vector3.new(0, 1, 0),
        500,
        { arg1 },
        Enum.RaycastFilterType.Include
    )
    local v2 = if raycastResult.Instance then raycastResult.Position else arg2
    local v3 = OnyxLavaSplash:Clone()
    v3.Size = Vector3.new(1, 1, 1)
    v3.CanCollide = true
    v3.CollisionGroup = "IgnoreEntities"
    v3.CFrame = CFrame.new(v2)
    v3.Parent = workspace
    v3.Attachment.LavaDroplets.Color = ColorSequence.new(arg1.Color)
    v3.Attachment.LavaDroplets:Emit(25)
    BetterDebris_m:AddItem(v3, 5)
    Utility_m:CreateSound(
        arg3 or "rbxassetid://12100798607",
        1,
        1 + 0.25 * math.random(),
        v3,
        true,
        5
    )
end
