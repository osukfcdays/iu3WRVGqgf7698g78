local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local CosmeticLibrary_m = require(ReplicatedStorage.Modules.CosmeticLibrary)
local EmoteViewportFrame_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("EmoteViewportFrame")
)
local ButtonEffect_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("ButtonEffect")
)
local Parent_m = require(script.Parent)
local ShopBigSlot = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("ShopBigSlot")
local t = setmetatable({}, Parent_m)
t.__index = t

function t.new(...) -- line: 14
    -- upvalues:
    --  [1] Parent_m (copy)
    --  [2] t (copy)
    --  [3] ShopBigSlot (copy)

    local t_1 = setmetatable(Parent_m.new(...), t)
    t_1.Frame = ShopBigSlot:Clone()
    t_1._emote_viewport_frame = nil
    t_1:_Init()

    return t_1
end

function t.OnClick(arg1, arg2) -- line: 30
    arg1.Frame.Button.MouseButton1Click:Connect(arg2)
end

function t.SetDescription(arg3, arg4) -- line: 34
    arg3.Frame.Button.Description.Text = arg4
end

function t.Destroy(arg5) -- line: 38
    if arg5._emote_viewport_frame then
        arg5._emote_viewport_frame:Destroy()
    end

    arg5.Frame:Destroy()
end

function t._Setup(arg6) -- line: 50
    -- upvalues:
    --  [1] CosmeticLibrary_m (copy)
    --  [2] ButtonEffect_m (copy)
    --  [3] EmoteViewportFrame_m (copy)

    local v4 = CosmeticLibrary_m.Cosmetics[arg6.FirstRewardData.Name]
    arg6.Frame.Button.Background.BackgroundColor3 = CosmeticLibrary_m.Rarities[v4.Rarity].Color
    arg6.Frame.Button.Background.UIStroke.Color = arg6.Frame.Button.Background.BackgroundColor3
    arg6.Frame.Button.Icon.Image = v4.ImageHighResolution or ""
    arg6.Frame.Button.Title.Text = arg6.FirstRewardData.Name
    arg6.Frame.Button.Weapon.Text = v4.Rarity .. " " .. (v4.ItemName or "???") .. " " .. v4.Type

    if not arg6.IsOwned and not arg6.IsLocked then
        ButtonEffect_m:Add(arg6.Frame.Button, nil, { HoverRatio = 1.03, ReleaseRatio = 1.03 })
    end

    if v4.Type == "Emote" then
        arg6._emote_viewport_frame = EmoteViewportFrame_m.new(arg6.FirstRewardData.Name)
        arg6._emote_viewport_frame:SetParent(arg6.Frame.Button)
        arg6._emote_viewport_frame.Frame.ZIndex = 9
        arg6._emote_viewport_frame.Frame.Position = UDim2.new(0.5, 0, 1, 0)
        arg6._emote_viewport_frame.EmoteGlow.Position = UDim2.new(0.5, 0, 0.85, 0)
        arg6._emote_viewport_frame.EmoteGlow.Position = UDim2.new(0.5, 0, 0.85, 0)
    end
end

function t._Init(arg7) -- line: 73
    arg7:_Setup()
    arg7:_SetupBuyButton(arg7.Frame.Button.Buy, arg7.Frame.Button.Owned)
    arg7:SetDescription("")
end

return t
