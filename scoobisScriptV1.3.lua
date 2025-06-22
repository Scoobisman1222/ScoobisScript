-- Load Rayfield
getgenv().SecureMode = true
local Rayfield = loadstring(game:HttpGet("https://raw.githubusercontent.com/SiriusSoftwareLtd/Rayfield/main/source.lua", true))()
local Window = Rayfield:CreateWindow({
  Name = "Scoobis Modern Hub",
  LoadingTitle = "Welcome!",
  ConfigurationSaving = { Enabled = true, FolderName = "ScoobisHub", FileName = "Settings" },
  KeySystem = false
})

-- UI Controls
local tab = Window:CreateTab("Main", 4483362458)
local combat = tab:CreateSection("Combat")
combat:CreateToggle({
  Name = "Aimbot",
  CurrentValue = getgenv().AimEnabled,
  Flag = "Aimbot",
  Callback = function(v) getgenv().AimEnabled = v end
})
combat:CreateSlider({
  Name = "Aim Sensitivity",
  Range = {1, 10}, Increment = 0.1,
  CurrentValue = getgenv().AimSensitivity,
  Suffix = "",
  Flag = "AimSensitivity",
  Callback = function(v) getgenv().AimSensitivity = v end
})
combat:CreateToggle({
  Name = "ESP (Closest)",
  CurrentValue = getgenv().EspEnabled,
  Flag = "ESP",
  Callback = function(v) getgenv().EspEnabled = v end
})
combat:CreateSlider({
  Name = "FOV Radius",
  Range = {10, 300}, Increment = 5,
  CurrentValue = getgenv().FovRadius,
  Suffix = "px",
  Flag = "FOVRadius",
  Callback = function(v) getgenv().FovRadius = v end
})

local move = tab:CreateSection("Movement")
move:CreateToggle({
  Name = "Speed Hack",
  CurrentValue = getgenv().SpeedEnabled,
  Flag = "Speed",
  Callback = function(v) getgenv().SpeedEnabled = v end
})
move:CreateSlider({
  Name = "Walk Speed",
  Range = {16, 200}, Increment = 1,
  CurrentValue = getgenv().WalkSpeed,
  Suffix = "studs/s",
  Flag = "WalkSpeed",
  Callback = function(v) getgenv().WalkSpeed = v end
})

-- Load config to render controls
Rayfield:LoadConfiguration()
