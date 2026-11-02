local CorePackages = game:GetService("CorePackages")
local JestGlobals_m = require(CorePackages.Packages.Dev.JestGlobals)
local Describe = JestGlobals_m.describe
local Expect = JestGlobals_m.expect
local It = JestGlobals_m.it
local WaitForEvents = require(CorePackages.Workspace.Packages.TestUtils).DeferredLuaHelpers.waitForEvents
local CameraWrapper_m = require(script.Parent.CameraWrapper)
Describe("CameraWrapper", function() -- line: 12
    -- upvalues:
    --  [1] It (copy)
    --  [2] CameraWrapper_m (copy)
    --  [3] Expect (copy)
    --  [4] WaitForEvents (copy)

    It("should instantiate", function() -- line: 13
        -- upvalues:
        --  [1] CameraWrapper_m (ref)
        --  [2] Expect (ref)

        Expect((CameraWrapper_m.new())).never.toBeNil()
    end)
    It("should return updated camera", function() -- line: 19
        -- upvalues:
        --  [1] CameraWrapper_m (ref)
        --  [2] Expect (ref)
        --  [3] WaitForEvents (ref)

        local v1 = CameraWrapper_m.new()
        v1:Enable()
        local Camera = Instance.new("Camera")
        Camera.Parent = game.Workspace
        Expect(v1:getCamera()).toBe(game.Workspace.CurrentCamera)
        Expect(v1:getCamera()).never.toBe(Camera)
        game.Workspace.CurrentCamera = Camera
        WaitForEvents()
        Expect(v1:getCamera()).toBe(game.Workspace.CurrentCamera)
        Expect(v1:getCamera()).toBe(Camera)
    end)
end)
