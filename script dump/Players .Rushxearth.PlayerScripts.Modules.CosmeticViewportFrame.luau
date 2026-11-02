local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local PlayerDataUtility_m = require(ReplicatedStorage.Modules.PlayerDataUtility)
local CosmeticLibrary_m = require(ReplicatedStorage.Modules.CosmeticLibrary)
local SeasonLibrary_m = require(ReplicatedStorage.Modules.SeasonLibrary)
local PlayerDataController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.PlayerDataController
)
local WrapController_m = require(Players.LocalPlayer.PlayerScripts.Controllers.WrapController)
local _ = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("StaticModel"):WaitForChild(
        "StaticViewModel"
    )
)
local ViewportCameras_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("ViewportCameras")
)
local CosmeticViewportFrame = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild(
    "CosmeticViewportFrame"
)
local Wrap = Players.LocalPlayer.PlayerScripts.Assets:WaitForChild("Misc"):WaitForChild("Wrap")
local Charms = Players.LocalPlayer.PlayerScripts.Assets:WaitForChild("Charms")
local t = {}
t.__index = t

function t.new(arg1, arg2) -- line: 19
    -- upvalues:
    --  [1] t (copy)
    --  [2] CosmeticLibrary_m (copy)
    --  [3] CosmeticViewportFrame (copy)

    local t_1 = setmetatable({}, t)
    t_1.Name = arg1
    t_1.Info = CosmeticLibrary_m.Cosmetics[t_1.Name]
    t_1.IsLocked = arg2
    t_1.Frame = CosmeticViewportFrame:Clone()
    t_1:_Init()

    return t_1
end

function t.ZoomOut(arg3) -- line: 36
    -- upvalues:
    --  [1] ViewportCameras_m (copy)

    arg3.Frame.Size = UDim2.new(
        arg3.Frame.Size.X.Scale * ViewportCameras_m.ZOOM_OUT_FACTOR,
        arg3.Frame.Size.X.Offset * ViewportCameras_m.ZOOM_OUT_FACTOR,
        arg3.Frame.Size.Y.Scale * ViewportCameras_m.ZOOM_OUT_FACTOR,
        arg3.Frame.Size.Y.Offset * ViewportCameras_m.ZOOM_OUT_FACTOR
    )
    local Frame_1 = arg3.Frame
    Frame_1.CurrentCamera = if arg3.Info.Type ~= "Charm" then if arg3.Info.Type ~= "Wrap" then arg3.Frame.CurrentCamera else ViewportCameras_m.WrapZoomedOut else ViewportCameras_m.CharmZoomedOut
end

function t.Destroy(arg4) -- line: 43
    arg4.Frame:Destroy()
end

function t._SetupSeasonRankCharm(arg5, arg6) -- line: 51
    -- upvalues:
    --  [1] SeasonLibrary_m (copy)
    --  [2] PlayerDataUtility_m (copy)
    --  [3] PlayerDataController_m (copy)

    if #arg5.Name < 8 or string.sub(arg5.Name, 1, 7) ~= "Season " then
        return
    end

    local num = tonumber((string.sub(arg5.Name, 8)))

    if not num then
        return
    end

    local Name = SeasonLibrary_m.SeasonsByVersion[num].Name
    local v4, v5 = PlayerDataUtility_m:GetSeasonInfo(PlayerDataController_m, Name)
    SeasonLibrary_m:FormatSeasonRankCharm(arg6, Name, v4, v5)
end

function t._Setup(arg7) -- line: 68
    -- upvalues:
    --  [1] Charms (copy)
    --  [2] ViewportCameras_m (copy)
    --  [3] Wrap (copy)
    --  [4] WrapController_m (copy)

    local Frame_2 = arg7.Frame
    Frame_2.ImageColor3 = arg7.IsLocked and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(255, 255, 255)
    local Frame_3 = arg7.Frame
    Frame_3.ImageTransparency = if not arg7.IsLocked then 0 else 0.5

    if arg7.Name ~= "NONE_COSMETIC" and arg7.Name ~= "RANDOM_COSMETIC" then
        if arg7.Info.Type == "Charm" then
            local v9 = Charms[arg7.Name]:Clone()
            v9.PrimaryPart = v9.Primary
            v9:PivotTo(CFrame.identity)
            v9.Hook:Destroy()
            v9.Parent = arg7.Frame
            task.defer(arg7._SetupSeasonRankCharm, arg7, v9)
            arg7.Frame.CurrentCamera = ViewportCameras_m.Charm

            return
        end

        if arg7.Info.Type == "Wrap" then
            local v10 = Wrap:Clone()
            v10:PivotTo(CFrame.identity)
            v10.Parent = arg7.Frame
            WrapController_m:ApplyWrap(
                WrapController_m:RecordOriginalWrapProperties(v10),
                { Name = arg7.Name }
            )
            arg7.Frame.CurrentCamera = ViewportCameras_m.Wrap
        end
    end
end

function t._Init(arg8) -- line: 93
    arg8:_Setup()
end

return t
