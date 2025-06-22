-- == ✅ Services & Variables ==
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Cam = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- == 🔧 Global Toggles ==
getgenv().AimEnabled = false
getgenv().EspEnabled = false
getgenv().SpeedEnabled = false
getgenv().WalkSpeed = 16

-- == 🎯 Aimbot Feature ==
local aiming = false
UIS.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton2 then aiming = true end
end)
UIS.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton2 then aiming = false end
end)

local function getClosest()
    local closest, dist = nil, math.huge
    local mousePos = UIS:GetMouseLocation()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
            local pos, onScreen = Cam:WorldToViewportPoint(p.Character.Head.Position)
            if onScreen then
                local d = (Vector2.new(pos.X, pos.Y) - mousePos).Magnitude
                if d < dist then
                    closest, dist = p, d
                end
            end
        end
    end
    return closest
end

RunService.RenderStepped:Connect(function()
    if getgenv().AimEnabled and aiming then
        local tgt = getClosest()
        if tgt and tgt.Character:FindFirstChild("Head") then
            Cam.CFrame = CFrame.new(Cam.CFrame.Position, tgt.Character.Head.Position)
        end
    end
end)

-- == 🧩 ESP Feature ==
local espLabels = {}
local function updateESP()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            if not espLabels[p.Name] then
                local txt = Drawing.new("Text")
                espLabels[p.Name] = txt
            end
            local txt = espLabels[p.Name]
            local root = p.Character.HumanoidRootPart
            local pos, onScreen = Cam:WorldToViewportPoint(root.Position)
            txt.Visible = getgenv().EspEnabled and onScreen
            if txt.Visible then
                txt.Position = Vector2.new(pos.X, pos.Y - 25)
                txt.Text = p.Name
                txt.Color = Color3.fromRGB(255, 0, 0)
                txt.Size = 16
                txt.Center = true
                txt.Outline = true
            end
        end
    end
end

RunService.RenderStepped:Connect(updateESP)

-- == ⚡ Speed Feature ==
RunService.RenderStepped:Connect(function()
    if getgenv().SpeedEnabled then
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.WalkSpeed = getgenv().WalkSpeed
        end
    end
end)

-- == 🧭 GUI Setup ==
local screen = Instance.new("ScreenGui", game.CoreGui)
local frame = Instance.new("Frame", screen)
frame.Size = UDim2.new(0,220,0,150)
frame.Position = UDim2.new(0,10,0,10)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)

local function makeToggle(text, y, flag)
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(0,200,0,30)
    btn.Position = UDim2.new(0,10,0,y)
    btn.Text = text..": OFF"
    btn.BackgroundColor3 = Color3.fromRGB(70,70,70)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.MouseButton1Click:Connect(function()
        getgenv()[flag] = not getgenv()[flag]
        btn.Text = text..(getgenv()[flag] and ": ON" or ": OFF")
        btn.BackgroundColor3 = getgenv()[flag]
            and Color3.fromRGB(0,150,0)
            or Color3.fromRGB(150,0,0)
    end)
end

makeToggle("Aimbot", 10, "AimEnabled")
makeToggle("ESP", 50, "EspEnabled")
makeToggle("Speed", 90, "SpeedEnabled")

-- Speed slider
local slider = Instance.new("TextLabel", frame)
slider.Size = UDim2.new(0,200,0,20)
slider.Position = UDim2.new(0,10,0,130)
slider.Text = "Speed: 16"
slider.TextColor3 = Color3.new(1,1,1)
slider.BackgroundTransparency = 1

UIS.InputChanged:Connect(function(input)
    if getgenv().SpeedEnabled and UIS:IsKeyDown(Enum.KeyCode.Up) then
        getgenv().WalkSpeed += 1
        slider.Text = "Speed: "..getgenv().WalkSpeed
    elseif getgenv().SpeedEnabled and UIS:IsKeyDown(Enum.KeyCode.Down) then
        getgenv().WalkSpeed = math.max(16, getgenv().WalkSpeed - 1)
        slider.Text = "Speed: "..getgenv().WalkSpeed
    end
end)
