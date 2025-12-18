local launcherEnabled = true
local launchForce = 2000
local useExplosion = false
local explosionRadius = 10
local upwardsModifier = 50

local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local camera = workspace.CurrentCamera

local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 250, 0, 150)
frame.Position = UDim2.new(0, 20, 0, 20)
frame.BackgroundColor3 = Color3.fromRGB(50,50,50)
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

local button = Instance.new("TextButton")
button.Size = UDim2.new(0, 80, 0, 30)
button.Position = UDim2.new(0,10,0,10)
button.Text = "ON"
button.BackgroundColor3 = Color3.fromRGB(0,255,0)
button.Parent = frame

local explosionToggle = Instance.new("TextButton")
explosionToggle.Size = UDim2.new(0, 120, 0, 30)
explosionToggle.Position = UDim2.new(0,10,0,50)
explosionToggle.Text = "Explosion: OFF"
explosionToggle.BackgroundColor3 = Color3.fromRGB(150,150,150)
explosionToggle.Parent = frame

local forceSlider = Instance.new("TextButton")
forceSlider.Size = UDim2.new(0, 200, 0, 20)
forceSlider.Position = UDim2.new(0,10,0,90)
forceSlider.Text = "Force: "..launchForce
forceSlider.BackgroundColor3 = Color3.fromRGB(100,100,100)
forceSlider.Parent = frame

button.MouseButton1Click:Connect(function()
    launcherEnabled = not launcherEnabled
    if launcherEnabled then
        button.Text = "ON"
        button.BackgroundColor3 = Color3.fromRGB(0,255,0)
    else
        button.Text = "OFF"
        button.BackgroundColor3 = Color3.fromRGB(255,0,0)
    end
end)

explosionToggle.MouseButton1Click:Connect(function()
    useExplosion = not useExplosion
    if useExplosion then
        explosionToggle.Text = "Explosion: ON"
        explosionToggle.BackgroundColor3 = Color3.fromRGB(0,200,255)
    else
        explosionToggle.Text = "Explosion: OFF"
        explosionToggle.BackgroundColor3 = Color3.fromRGB(150,150,150)
    end
end)

forceSlider.MouseButton1Click:Connect(function()
    launchForce = launchForce + 500
    if launchForce > 5000 then launchForce = 500 end
    forceSlider.Text = "Force: "..launchForce
end)

local function launch(targetPosition)
    if not launcherEnabled then return end
    local hitParts = {}
    if useExplosion then
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") then
                if (obj.Position - targetPosition).Magnitude <= explosionRadius then
                    table.insert(hitParts, obj)
                end
            end
        end
    else
        local target = mouse.Target
        if target and target:IsA("BasePart") then
            table.insert(hitParts, target)
        end
    end
    for _, part in pairs(hitParts) do
        if part:IsA("BasePart") then
            local bv = Instance.new("BodyVelocity")
            local direction
            if useExplosion then
                direction = (part.Position - targetPosition).unit
            else
                direction = (camera.CFrame.Position - part.Position).unit * -1
            end
            bv.Velocity = direction * launchForce + Vector3.new(0,upwardsModifier,0)
            bv.MaxForce = Vector3.new(1e5,1e5,1e5)
            bv.Parent = part
            game:GetService("Debris"):AddItem(bv,0.5)
        end
    end
end

mouse.Button1Down:Connect(function()
    launch(mouse.Hit.p)
end)
