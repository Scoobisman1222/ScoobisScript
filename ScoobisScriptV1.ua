-- 🚨 Secure Mode (optional)
getgenv().SecureMode = true

-- ⬛ Load Rayfield UI
local Rayfield = loadstring(game:HttpGet("https://raw.githubusercontent.com/SiriusSoftwareLtd/Rayfield/main/source.lua"))()
local Window = Rayfield:CreateWindow({
    Name = "Scoobis Modern Hub",
    LoadingTitle = "Welcome, Scoobis!",
    ConfigurationSaving = { Enabled = true, FolderName = "ScoobisHub", FileName = "Settings" },
    KeySystem = false
})

-- ⚙️ Global Flags
getgenv().AimEnabled     = false
getgenv().EspEnabled     = false
getgenv().SpeedEnabled   = false
getgenv().WalkSpeed      = 16
getgenv().AimSensitivity = 3.5
getgenv().FovRadius      = 90

-- 🧩 Core Variables
local Players    = game:GetService("Players")
local UIS        = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Cam        = workspace.CurrentCamera
local LP         = Players.LocalPlayer

-- 🎯 Helper: Find closest valid enemy head to cursor
local function getClosestEnemy()
    local closest, minDist = nil, math.huge
    local mousePos = UIS:GetMouseLocation()
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            if p.Team ~= LP.Team then  -- Team check
                local head = p.Character:FindFirstChild("Head")
                if head and head.Parent:FindFirstChildOfClass("Humanoid") and head.Parent.Humanoid.Health > 0 then
                    local screenPos, onScreen = Cam:WorldToViewportPoint(head.Position)
                    if onScreen then
                        local d = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                        if d < minDist and d <= getgenv().FovRadius then
                            closest, minDist = head, d
                        end
                    end
                end
            end
        end
    end
    return closest
end

-- 🎯 Improved Aimbot using mousemoverel
UIS.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton2 then getgenv()._aiming = true end
end)
UIS.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton2 then getgenv()._aiming = false end
end)
RunService.RenderStepped:Connect(function()
    if getgenv().AimEnabled and getgenv()._aiming then
        local head = getClosestEnemy()
        if head then
            local pos, on = Cam:WorldToViewportPoint(head.Position)
            if on then
                local mousePos = UIS:GetMouseLocation()
                local delta = Vector2.new(pos.X, pos.Y) - mousePos
                mousemoverel(delta.X/getgenv().AimSensitivity, delta.Y/getgenv().AimSensitivity)
            end
        end
    end
end)

-- 👁️ Malicious-look closest-ESP Text label
local label = Drawing.new("Text")
label.Center = true
label.Outline = true
label.Color = Color3.new(1,0,0)
label.Size = 18

RunService.RenderStepped:Connect(function()
    if getgenv().EspEnabled then
        local head = getClosestEnemy()
        if head then
            local pos, on = Cam:WorldToViewportPoint(head.Position)
            label.Visible = on
            if on then
                label.Position = Vector2.new(pos.X, pos.Y - 20)
                label.Text = head.Parent.Name
            end
        else
            label.Visible = false
        end
    else
        label.Visible = false
    end
end)

-- ⚡ Walk speed updater
RunService.RenderStepped:Connect(function()
    if getgenv().SpeedEnabled then
        local char = LP.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.WalkSpeed = getgenv().WalkSpeed
        end
    end
end)

-- 🧭 GUI Controls
local tab = Window:CreateTab("Main", 4483362458)
local combatSection = tab:CreateSection("Combat")
combatSection:CreateToggle({ Name="Aimbot", Flag="Aimbot", Callback=function(v) getgenv().AimEnabled = v end })
combatSection:CreateSlider({
    Name="Aim Sensitivity", Range={1,10}, Increment=0.1, Value=getgenv().AimSensitivity,
    Callback=function(v) getgenv().AimSensitivity = v end
})
combatSection:CreateToggle({ Name="ESP (Closest)", Flag="ESP", Callback=function(v) getgenv().EspEnabled = v end })
combatSection:CreateSlider({
    Name="FOV Radius", Range={10,300}, Increment=5, Value=getgenv().FovRadius, Suffix="px",
    Callback=function(v) getgenv().FovRadius = v end
})

local moveSection = tab:CreateSection("Movement")
moveSection:CreateToggle({ Name="Speed Hack", Flag="Speed", Callback=function(v) getgenv().SpeedEnabled = v end })
moveSection:CreateSlider({
    Name="Walk Speed", Range={16,200}, Increment=1, Value=getgenv().WalkSpeed, Suffix="studs/s",
    Callback=function(v) getgenv().WalkSpeed = v end
})
