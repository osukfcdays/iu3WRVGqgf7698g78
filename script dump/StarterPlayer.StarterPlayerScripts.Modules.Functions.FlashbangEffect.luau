local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local CONSTANTS_m = require(ReplicatedStorage.Modules.CONSTANTS)
local BetterDebris_m = require(ReplicatedStorage.Modules.BetterDebris)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local SpectateController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.SpectateController
)
local FlashbangEffect = Players.LocalPlayer.PlayerScripts.Assets.Misc:WaitForChild(
    "FlashbangEffect"
)

local _ = function(arg1) --[[ default_flash_sound_callback ]] -- line: 11
    -- upvalues:
    --  [1] Utility_m (copy)

    Utility_m:CreateSound(
        "rbxassetid://14778230670",
        1,
        1,
        arg1,
        true,
        10
    )
end

return function(
    arg2,
    arg3,
    arg4,
    arg5,
    arg6,
    arg7,
    arg8
) -- line: 15
    -- upvalues:
    --  [1] CONSTANTS_m (copy)
    --  [2] FlashbangEffect (copy)
    --  [3] BetterDebris_m (copy)
    --  [4] Utility_m (copy)
    --  [5] SpectateController_m (copy)

    if (workspace.CurrentCamera.CFrame.Position - arg3).Magnitude > CONSTANTS_m.RENDER_DISTANCE then
        return
    end

    local v1 = FlashbangEffect:Clone()
    v1.CFrame = CFrame.new(arg3)
    v1.Parent = workspace
    v1.Attachment.Glow:Emit(5)
    BetterDebris_m:AddItem(v1, 5)
    local PointLight = v1.PointLight
    task.spawn(
        Utility_m.RenderstepForLoop,
        Utility_m,
        0,
        100,
        4,
        function(arg9) -- line: 28
            -- upvalues:
            --  [1] PointLight (copy)

            PointLight.Brightness = 40 * (1 - arg9 / 100)
        end
    )

    if arg7 then
        arg7(arg3)
    else
        Utility_m:CreateSound(
            "rbxassetid://14778230670",
            1,
            1,
            arg3,
            true,
            10
        )
    end

    if SpectateController_m.CurrentSubject and SpectateController_m.CurrentSubject.FighterInterface then
        SpectateController_m.CurrentSubject.FighterInterface.Flashed:AttemptToFlash(
            arg2,
            arg3,
            arg4,
            arg5,
            arg6,
            arg8
        )
    end
end
