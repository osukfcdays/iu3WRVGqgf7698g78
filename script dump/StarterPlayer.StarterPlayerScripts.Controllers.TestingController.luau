local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local _ = require(ReplicatedStorage.Modules.CONSTANTS)
local CosmeticLibrary_m = require(ReplicatedStorage.Modules.CosmeticLibrary)
local TestLibrary_m = require(ReplicatedStorage.Modules.TestLibrary)
local ShootingRangeController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.ShootingRangeController
)
local StudioFinisherTest = TestLibrary_m:GetTestAttribute("StudioFinisherTest")
local StudioSkinTest = TestLibrary_m:GetTestAttribute("StudioSkinTest")
local t = {}
t.__index = t

function t._new() -- line: 15
    -- upvalues:
    --  [1] t (copy)

    local t_1 = setmetatable({}, t)
    t_1:_Init()

    return t_1
end

function t._SetupFinisherTest(_) -- line: 33
    -- upvalues:
    --  [1] StudioFinisherTest (copy)
    --  [2] Players (copy)
    --  [3] ShootingRangeController_m (copy)

    if not StudioFinisherTest then
        return
    end

    if not Players.LocalPlayer.Character then
        Players.LocalPlayer.CharacterAdded:Wait()
    end

    ShootingRangeController_m:Enter("Sniper")
end

function t._SetupSkinTest(_) -- line: 45
    -- upvalues:
    --  [1] StudioSkinTest (copy)
    --  [2] Players (copy)
    --  [3] ShootingRangeController_m (copy)
    --  [4] CosmeticLibrary_m (copy)

    if not StudioSkinTest then
        return
    end

    if not Players.LocalPlayer.Character then
        Players.LocalPlayer.CharacterAdded:Wait()
    end

    ShootingRangeController_m:Enter(
        CosmeticLibrary_m.Cosmetics[StudioSkinTest] and CosmeticLibrary_m.Cosmetics[StudioSkinTest].ItemName or StudioSkinTest
    )
end

function t._Init(arg3) -- line: 57
    task.defer(arg3._SetupSkinTest, arg3)
    task.defer(arg3._SetupFinisherTest, arg3)
end

return t._new()
