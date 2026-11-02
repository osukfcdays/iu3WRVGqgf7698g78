local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Signal_m = require(ReplicatedStorage.Modules.Signal)
local _ = require(script:WaitForChild("Daily"))
local _ = require(script:WaitForChild("Currency"))
local _ = require(script:WaitForChild("Bundles"))
local _ = require(script:WaitForChild("Ranked"))
local _ = require(script:WaitForChild("Skins"))
local _ = require(script:WaitForChild("Home"))
local ShopPages = Players.LocalPlayer.PlayerScripts.Assets:WaitForChild("Temp"):WaitForChild(
    "ShopPages"
)
local t = { "Currency", "Bundles", "Ranked", "Daily", "Skins", "Home" }
local t_1 = {}
t_1.__index = t_1

function t_1.new(arg1) -- line: 18
    -- upvalues:
    --  [1] t_1 (copy)
    --  [2] Signal_m (copy)

    local t_2 = setmetatable({}, t_1)
    t_2.UpdateCanvasSize = Signal_m.new()
    t_2.Shop = arg1
    t_2.Frame = t_2.Shop.Container:WaitForChild("Pages")
    t_2.Components = {}
    t_2._page_frames = {}
    t_2:_Init()

    return t_2
end

function t_1.GetComponentFrame(arg2, arg3) -- line: 39
    return arg2.Components[arg3] and arg2.Components[arg3].Frame
end

function t_1.Open(arg4) -- line: 43
    for _, val in pairs(arg4.Components) do
        val:Open()
    end
end

function t_1.Close(arg5) -- line: 49
    for _, val_1 in pairs(arg5.Components) do
        val_1:Close()
    end
end

function t_1.Setup(arg6) -- line: 55
    for _, val_2 in pairs(arg6.Components) do
        val_2:Setup()
    end

    arg6:_Update()
end

function t_1._Update(arg7) -- line: 67
    -- upvalues:
    --  [1] ShopPages (copy)

    for key_3, val_3 in pairs(arg7._page_frames) do
        local v8 = if key_3 ~= arg7.Shop.CurrentPage then false else true
        local v9 = v8 and arg7.Frame or ShopPages
        val_3.Parent = v9
        val_3.Visible = v8
    end
end

function t_1._Setup(arg8) -- line: 76
    -- upvalues:
    --  [1] t (copy)
    --  [2] ShopPages (copy)

    for _, val_4 in pairs(t) do
        local v10 = require(script:WaitForChild(val_4)).new(arg8)
        v10.Frame:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- line: 80
            -- upvalues:
            --  [1] arg8 (copy)

            arg8.UpdateCanvasSize:Fire()
        end)
        v10.Frame:GetPropertyChangedSignal("AbsolutePosition"):Connect(function() -- line: 84
            -- upvalues:
            --  [1] arg8 (copy)

            arg8.UpdateCanvasSize:Fire()
        end)
        arg8.Components[val_4] = v10
    end

    for _, val_5 in pairs(arg8.Shop.PAGE_NAMES) do
        local v11 = arg8.Frame:WaitForChild(val_5)
        v11.Visible = false
        v11.Parent = ShopPages
        arg8._page_frames[val_5] = v11
    end
end

function t_1._Init(arg9) -- line: 99
    arg9.Shop.CurrentPageChanged:Connect(function() -- line: 100
        -- upvalues:
        --  [1] arg9 (copy)

        arg9:_Update()
    end)
    arg9:_Setup()
end

return t_1
