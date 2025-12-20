local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local ToggleButton = Instance.new("TextButton")
local MinimizeButton = Instance.new("TextButton")
local UICorner = Instance.new("UICorner")

ScreenGui.Name = "boid
"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ResetOnSpawn = false

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Position = UDim2.new(0.5, -75, 0.5, -50)
MainFrame.Size = UDim2.new(0, 150, 0, 100)
MainFrame.Active = true
MainFrame.Draggable = true

local MainCorner = UICorner:Clone()
MainCorner.Parent = MainFrame

Title.Name = "Title"
Title.Parent = MainFrame
Title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Title.Size = UDim2.new(1, 0, 0, 25)
Title.Font = Enum.Font.GothamBold
Title.Text = "Tap Void All"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 12

local TitleCorner = UICorner:Clone()
TitleCorner.Parent = Title

MinimizeButton.Name = "MinimizeButton"
MinimizeButton.Parent = MainFrame
MinimizeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
MinimizeButton.Position = UDim2.new(1, -25, 0, 0)
MinimizeButton.Size = UDim2.new(0, 25, 0, 25)
MinimizeButton.Text = "-"
MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)

ToggleButton.Name = "ToggleButton"
ToggleButton.Parent = MainFrame
ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
ToggleButton.Position = UDim2.new(0, 10, 0, 40)
ToggleButton.Size = UDim2.new(0, 130, 0, 45)
ToggleButton.Font = Enum.Font.Gotham
ToggleButton.Text = "TAP TO VOID"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 14

local ButtonCorner = UICorner:Clone()
ButtonCorner.Parent = ToggleButton

local minified = false

MinimizeButton.MouseButton1Click:Connect(function()
    minified = not minified
    if minified then
        ToggleButton.Visible = false
        MainFrame.Size = UDim2.new(0, 150, 0, 25)
        MinimizeButton.Text = "+"
    else
        ToggleButton.Visible = true
        MainFrame.Size = UDim2.new(0, 150, 0, 100)
        MinimizeButton.Text = "-"
    end
end)

ToggleButton.MouseButton1Click:Connect(function()
    for _, v in pairs(game:GetService("Players"):GetPlayers()) do
        if v ~= game:GetService("Players").LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            v.Character.HumanoidRootPart.CFrame = CFrame.new(v.Character.HumanoidRootPart.Position.X, -5000, v.Character.HumanoidRootPart.Position.Z)
        end
    end
    
    ToggleButton.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
    task.wait(0.2)
    ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
end)
