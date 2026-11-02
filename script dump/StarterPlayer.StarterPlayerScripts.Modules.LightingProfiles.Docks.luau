local t = {
    TerrainMaterials = nil,
    TerrainProperties = nil,
    LightingProperties = nil,
    SoundServiceProperties = nil
}
local t_1 = {}
t_1[Enum.Material.Asphalt] = Color3.fromRGB(115, 123, 107)
t_1[Enum.Material.Basalt] = Color3.fromRGB(30, 30, 37)
t_1[Enum.Material.Brick] = Color3.fromRGB(138, 86, 62)
t_1[Enum.Material.Cobblestone] = Color3.fromRGB(132, 123, 90)
t_1[Enum.Material.Concrete] = Color3.fromRGB(127, 102, 63)
t_1[Enum.Material.CrackedLava] = Color3.fromRGB(232, 156, 74)
t_1[Enum.Material.Glacier] = Color3.fromRGB(101, 176, 234)
t_1[Enum.Material.Grass] = Color3.fromRGB(41, 90, 22)
t_1[Enum.Material.Ground] = Color3.fromRGB(88, 63, 68)
t_1[Enum.Material.Ice] = Color3.fromRGB(129, 194, 224)
t_1[Enum.Material.LeafyGrass] = Color3.fromRGB(40, 91, 25)
t_1[Enum.Material.Limestone] = Color3.fromRGB(206, 173, 148)
t_1[Enum.Material.Mud] = Color3.fromRGB(58, 46, 36)
t_1[Enum.Material.Pavement] = Color3.fromRGB(148, 148, 140)
t_1[Enum.Material.Rock] = Color3.fromRGB(69, 73, 74)
t_1[Enum.Material.Salt] = Color3.fromRGB(198, 189, 181)
t_1[Enum.Material.Sand] = Color3.fromRGB(143, 126, 95)
t_1[Enum.Material.Sandstone] = Color3.fromRGB(137, 90, 71)
t_1[Enum.Material.Slate] = Color3.fromRGB(63, 127, 107)
t_1[Enum.Material.Snow] = Color3.fromRGB(195, 199, 218)
t_1[Enum.Material.WoodPlanks] = Color3.fromRGB(139, 109, 79)
t.TerrainMaterials = t_1
t.TerrainProperties = {
    WaterReflectance = 1,
    WaterTransparency = 0.3,
    WaterWaveSize = 0.15,
    WaterWaveSpeed = 10
}
t.LightingProperties = {
    Ambient = Color3.fromRGB(180, 180, 180),
    Brightness = 2,
    ColorShift_Bottom = Color3.fromRGB(0, 0, 0),
    ColorShift_Top = Color3.fromRGB(0, 0, 0),
    EnvironmentDiffuseScale = 1,
    EnvironmentSpecularScale = 1,
    OutdoorAmbient = Color3.fromRGB(128, 128, 128),
    ShadowSoftness = 0.2,
    ClockTime = 10.2,
    GeographicLatitude = 10.2,
    ExposureCompensation = 0,
    FogColor = Color3.fromRGB(192, 192, 192),
    FogEnd = 1500,
    FogStart = 0
}
t.SoundServiceProperties = {
    AmbientReverb = Enum.ReverbType.NoReverb,
    DistanceFactor = 3.33,
    DopplerScale = 1,
    RolloffScale = 1
}

return t
